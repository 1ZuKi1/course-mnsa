# Routes
Single page, no router. `/` = course list; course detail, login, and add-course are modal overlays on the same page. Static assets served by Cloudflare Workers (`wrangler.toml` assets dir `./`). API: `mongol-course-api` Worker (D1).
