# Хичээлийн үнэлгээ — course reviews for Mongolian students at PKU

One Cloudflare Worker serves the whole site:

| Path | Handled by | What it is |
|---|---|---|
| `/api/*` | `src/api.js` | Login (emailed codes + JWT), courses, reviews — stored in D1 |
| everything else | `public/` | The website: `index.html`, `styles.css`, `app.js` |

Plain HTML/CSS/JS, no build step. Only files inside `public/` are published.

```
public/            website files
src/index.js       entry: /api/* → api.js, everything else → public/
src/api.js         the API
migrations/        database schema (0001 = full current schema)
seed/dev_seed.sql  fake data for local development only
wrangler.toml      Worker + database config
```

---

## Run it on your computer

Needs [Node.js](https://nodejs.org) 18+.

```bash
npm install
cp .dev.vars.example .dev.vars      # local secrets; login codes print in the terminal
npm run db:migrate:local            # create the tables in a local test database
npm run db:seed:local               # add a few fake courses and reviews
npm run dev                         # → http://localhost:8787
```

To log in locally, type any student number, press **Баталгаажуулах код авах**, and copy
the 6-digit code from the terminal line `[dev] login code for …`.
Nothing you do locally touches the real database.

---

## Phase 1 — test on the personal Cloudflare account

The live site (`mongol-course-frontend` + `mongol-course-api` on course.icpsd.org)
keeps running the whole time. This deploys a **separate** Worker called `mnsa-course`
with a **copy** of the data.

```bash
npx wrangler login                                   # personal account

# 1. Back up the live database (this file contains student emails — keep it private)
npx wrangler d1 export mongol-course-db --remote --output=backups/live.sql
#    (If wrangler says it can't find mongol-course-db, temporarily put
#     database_name = "mongol-course-db" and
#     database_id = "503694d0-12e2-4b8c-906b-45d89fd97c2d" in wrangler.toml,
#     run the export, then change them back.)

# 2. Create a test database and paste its id into wrangler.toml → database_id
npx wrangler d1 create mnsa-course-db

# 3. Fill it with the copy, then make sure the schema is current
npx wrangler d1 execute mnsa-course-db --remote --file=backups/live.sql
npm run db:migrate

# 4. Secrets (Cloudflare never shows secret values again, so use the ones you
#    saved, or make new ones — a new JWT_SECRET just means everyone logs in again)
npx wrangler secret put JWT_SECRET
npx wrangler secret put RESEND_API_KEY

# 5. Deploy
npm run deploy                                       # → https://mnsa-course.<you>.workers.dev
```

Test everything on the workers.dev address: login email, writing / editing /
deleting a review, adding a course, phone and computer. Reviews written here go
to the **copy**, not the live site.

### Cutover (still on the personal account)

When the test version is good:

1. In `wrangler.toml`, point `database_id` at the **live** database
   (`mongol-course-db`, id `503694d0-12e2-4b8c-906b-45d89fd97c2d`) and set
   `database_name = "mongol-course-db"`. Then `npx wrangler d1 migrations apply mongol-course-db --remote`
   (safe: the schema file only creates what is missing).
2. In the Cloudflare dashboard, remove `course.icpsd.org` from the old Workers:
   the Custom Domain on **mongol-course-frontend** and the Route on **mongol-course-api**.
3. Uncomment the `routes = [...]` block at the bottom of `wrangler.toml` and `npm run deploy`.
4. Check course.icpsd.org, then delete the two old Workers and the test database.

---

## Phase 2 — move to the student association's Cloudflare

The live site now runs as Worker `mnsa-course` + database `mnsa-course-db` on the
personal account, at course.icpsd.org. Moving it = copying that database to the
association's account and deploying the same code there.

**Before you start (decisions + accounts)**

- Association Cloudflare account with at least two admins.
- The association's domain added to that account (its name servers pointed at Cloudflare).
- A Resend account owned by the association, with the new domain verified, and an API key.
- The `JWT_SECRET` value from the password manager (same value = nobody has to log in again).

**Steps**

1. Announce a short pause (≈15 min, no new reviews), then — still logged in to the
   **personal** account — back up the live data:
   `npx wrangler d1 export mnsa-course-db --remote --output=backups/final.sql`
2. Switch Wrangler to the association account:
   `npx wrangler logout` then `npx wrangler login` (sign in as the association).
3. Create the database there and paste its id into `wrangler.toml` → `database_id`:
   `npx wrangler d1 create mnsa-course-db`
4. Load the backup:
   `npx wrangler d1 execute mnsa-course-db --remote --file=backups/final.sql`
5. Check the migration history came along:
   `npx wrangler d1 migrations list mnsa-course-db --remote`
   It must say **no migrations to apply**. If it lists 0002–0007 instead, stop — do not
   run `db:migrate` (0004/0005/0007 would fail on columns that already exist); the
   d1_migrations table needs to be copied first.
6. Secrets: `npx wrangler secret put JWT_SECRET` (old value) and
   `npx wrangler secret put RESEND_API_KEY` (the association's key).
7. In `wrangler.toml` change `routes`, `MAIL_FROM` and `SITE_URL` to the new domain,
   then `npm run deploy`. Test on the workers.dev address and the new domain:
   course list, login email, writing a review.
8. Old address: on the personal account, remove `course.icpsd.org` from the Worker and
   add a Redirect Rule `course.icpsd.org/*` → the new address, so old links keep working.
9. After a week or two without problems, delete the personal `mnsa-course` Worker and
   `mnsa-course-db` (keep `backups/final.sql` somewhere safe and private).
10. GitHub: repository **Settings → Transfer ownership** to the association's organization.
    Optionally connect it in Cloudflare (Worker → Settings → Builds) for automatic deploys.

---

## GitHub

Create the repository under the association's GitHub organization, then:

```bash
git init
git add .
git commit -m "One-Worker course review site"
git branch -M main
git remote add origin https://github.com/<org>/mnsa-course.git
git push -u origin main
```

`.gitignore` already keeps out `node_modules/`, `.wrangler/`, `.dev.vars` and
`backups/` (database exports contain student emails — never commit them).

Optional automatic deploys: Cloudflare dashboard → the Worker → **Settings → Builds →
Connect** the GitHub repo. Every push to `main` then deploys, and other branches get
their own preview address.

## Changing the database later

Add a new file such as `migrations/0002_add_categories.sql`, test it with
`npm run db:migrate:local`, then apply it to the real database with `npm run db:migrate`
before deploying code that needs it.
