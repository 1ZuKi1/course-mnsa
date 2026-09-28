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

After the association has its own account and domain:

1. Add at least two admins to the association account.
2. Pause writes briefly (e.g. announce a 10-minute window), then back up:
   `npx wrangler d1 export mongol-course-db --remote --output=backups/final.sql`
3. `npx wrangler logout && npx wrangler login` as the association account.
4. Repeat Phase 1 steps 2–5 in the new account (new database id, same secrets or new ones).
5. Update `MAIL_FROM` and `SITE_URL` in `wrangler.toml` for the new domain, verify that
   domain in Resend (ideally a Resend account owned by the association), and add the
   new domain in the `routes` block.
6. Once the new site works, delete the Worker and database from the personal account.

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
