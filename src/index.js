// One Worker for the whole site.
//
//   /api/*   → handleApi (src/api.js), which reads and writes the D1 database
//   anything else → the static files in public/ (index.html, styles.css, app.js…)
//
// wrangler.toml sets `run_worker_first = ["/api/*"]`, so Cloudflare serves the
// static files directly and this code only runs for API calls. The ASSETS
// fallback below is just a safety net.
import { handleApi } from './api.js';

export default {
  async fetch(request, env) {
    const { pathname } = new URL(request.url);
    if (pathname === '/api' || pathname.startsWith('/api/')) {
      return handleApi(request, env);
    }
    return env.ASSETS.fetch(request);
  },
};
