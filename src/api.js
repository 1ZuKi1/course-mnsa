// API for the course review site: JWT login via emailed codes, courses and
// reviews in D1. Called by src/index.js for every /api/* request; all other
// paths are static files from public/.
export async function handleApi(request, env) {
  {
    const url = new URL(request.url);
    const path = url.pathname;
    const method = request.method;

    // The page and the API share one origin now, so no CORS headers are
    // needed. The name is kept so every response below stays unchanged.
    const corsHeaders = {};

    try {
      const db = env.DB;

      // Helper: JWT
      async function createJWT(userId, secret) {
        const header = { alg: 'HS256', typ: 'JWT' };
        const payload = {
          sub: userId,
          exp: Math.floor(Date.now() / 1000) + 30 * 24 * 60 * 60,
          iat: Math.floor(Date.now() / 1000),
        };
        const enc = (obj) => btoa(JSON.stringify(obj)).replace(/=+$/, '');
        const encodedHeader = enc(header);
        const encodedPayload = enc(payload);
        const signatureInput = `${encodedHeader}.${encodedPayload}`;
        const key = await crypto.subtle.importKey(
          'raw',
          new TextEncoder().encode(secret),
          { name: 'HMAC', hash: 'SHA-256' },
          false,
          ['sign']
        );
        const sig = await crypto.subtle.sign('HMAC', key, new TextEncoder().encode(signatureInput));
        const encodedSig = btoa(String.fromCharCode(...new Uint8Array(sig))).replace(/=+$/, '');
        return `${encodedHeader}.${encodedPayload}.${encodedSig}`;
      }

      async function verifyJWT(token, secret) {
        try {
          const parts = token.split('.');
          if (parts.length !== 3) return null;
          const [header, payload, sig] = parts;
          const signatureInput = `${header}.${payload}`;
          const key = await crypto.subtle.importKey(
            'raw',
            new TextEncoder().encode(secret),
            { name: 'HMAC', hash: 'SHA-256' },
            false,
            ['verify']
          );
          const sigBytes = Uint8Array.from(atob(sig), c => c.charCodeAt(0));
          const valid = await crypto.subtle.verify('HMAC', key, sigBytes, new TextEncoder().encode(signatureInput));
          if (!valid) return null;
          const decoded = JSON.parse(atob(payload));
          if (decoded.exp < Math.floor(Date.now() / 1000)) return null;
          return decoded;
        } catch (e) {
          return null;
        }
      }

      // Helper: SHA-256
      async function sha256(input) {
        const data = new TextEncoder().encode(input);
        const hash = await crypto.subtle.digest('SHA-256', data);
        return [...new Uint8Array(hash)].map(b => b.toString(16).padStart(2, '0')).join('');
      }

      // Helper: Verification email template (table-based + inline styles so it
      // survives Outlook / Gmail / mobile clients, which strip <style> blocks)
      function verificationEmailHtml(code, siteUrl) {
        return `<!DOCTYPE html>
<html lang="mn">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Баталгаажуулах код</title>
</head>
<body style="margin:0; padding:0; background-color:#f5f1ea; -webkit-font-smoothing:antialiased;">
  <div style="display:none; max-height:0; overflow:hidden; opacity:0;">Таны баталгаажуулах код: ${code} — 10 минутын дотор хүчинтэй.</div>
  <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f5f1ea;">
    <tr>
      <td align="center" style="padding:32px 16px;">
        <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="max-width:480px; background-color:#fbf9f5; border:1px solid #e2dbcf; border-radius:16px;">
          <tr>
            <td style="padding:28px 32px 0 32px; font-family:'Segoe UI',Roboto,Helvetica,Arial,sans-serif;">
              <span style="display:inline-block; font-size:14px; font-weight:700; color:#2f6f6a; letter-spacing:-0.01em;">Хичээлийн үнэлгээ</span>
            </td>
          </tr>
          <tr>
            <td style="padding:16px 32px 0 32px; font-family:'Segoe UI',Roboto,Helvetica,Arial,sans-serif;">
              <h1 style="margin:0 0 8px 0; font-size:22px; font-weight:700; color:#2a2723; letter-spacing:-0.02em;">Баталгаажуулах код</h1>
              <p style="margin:0; font-size:15px; line-height:1.6; color:#5c554c;">Сайн байна уу! Доорх кодыг сайт дээр оруулж нэвтэрнэ үү.</p>
            </td>
          </tr>
          <tr>
            <td style="padding:22px 32px 0 32px;">
              <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#e3eeeb; border:1px solid #cfe0dc; border-radius:12px;">
                <tr>
                  <td align="center" style="padding:20px 16px; font-family:'Courier New',Courier,monospace; font-size:32px; font-weight:700; color:#1f4f4b; letter-spacing:8px; text-indent:8px;">${code}</td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td style="padding:16px 32px 0 32px; font-family:'Segoe UI',Roboto,Helvetica,Arial,sans-serif;">
              <p style="margin:0; font-size:13.5px; line-height:1.6; color:#5c554c;">Энэ код <strong style="color:#2a2723;">10 минутын</strong> дотор хүчинтэй. Хэрэв та энэ хүсэлтийг илгээгээгүй бол энэ захидлыг үл тоомсорлоно уу.</p>
            </td>
          </tr>
          <tr>
            <td style="padding:24px 32px 28px 32px;">
              <hr style="border:none; border-top:1px solid #e2dbcf; margin:0 0 16px 0;" />
              <p style="margin:0; font-family:'Segoe UI',Roboto,Helvetica,Arial,sans-serif; font-size:12.5px; line-height:1.6; color:#6f675c;">
                Монгол оюутнуудын хичээлийн үнэлгээний сан<br />
                <a href="${siteUrl}" style="color:#2f6f6a; text-decoration:none;">${siteUrl.replace(/^https?:\/\//, '')}</a>
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>`;
      }

      // Helper: Send email via Resend
      async function sendVerificationEmail(email, code, apiKey) {
        // MAIL_FROM lets the sender follow whichever domain is verified in
        // Resend without another code change.
        const from = env.MAIL_FROM || 'Хичээлийн үнэлгээ <noreply@course.icpsd.org>';
        const siteUrl = env.SITE_URL || 'https://course.icpsd.org';
        const response = await fetch('https://api.resend.com/emails', {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${apiKey}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            from,
            to: [email],
            subject: `Баталгаажуулах код: ${code}`,
            html: verificationEmailHtml(code, siteUrl),
            // Plain-text alternative: required by some clients and improves
            // deliverability (HTML-only mail scores worse with spam filters).
            text: `Хичээлийн үнэлгээ\n\nТаны баталгаажуулах код: ${code}\n\nЭнэ код 10 минутын дотор хүчинтэй.\nХэрэв та энэ хүсэлтийг илгээгээгүй бол энэ захидлыг үл тоомсорлоно уу.\n\n${siteUrl}`,
          }),
        });
        if (!response.ok) {
          const errorText = await response.text();
          throw new Error(`Resend error: ${response.status} - ${errorText}`);
        }
        return true;
      }

      // Helper: Check email domain
      function allowedEmailDomains() {
        const allowed = env.ALLOWED_EMAIL_DOMAINS;
        if (!allowed) return [];
        return allowed.split(',').map(d => d.trim().toLowerCase()).filter(Boolean);
      }

      function isEmailAllowed(email) {
        const allowedList = allowedEmailDomains();
        if (allowedList.length === 0) return true;
        const domain = (email.split('@')[1] || '').toLowerCase();
        return allowedList.includes(domain);
      }

      // Auth endpoints
      if (path === '/api/auth/request-code' && method === 'POST') {
        const { email: rawEmail } = await request.json();
        const email = rawEmail.toLowerCase().trim();
        if (!email || !email.includes('@')) {
          return Response.json({ success: false, error: 'Зөв имэйл хаяг оруулна уу' }, { status: 400, headers: corsHeaders });
        }
        if (!isEmailAllowed(email)) {
          // Name the accepted domain(s) so the student knows what to use
          // instead of just being told "no".
          const label = allowedEmailDomains().map(d => '@' + d).join(' / ');
          return Response.json({
            success: false,
            error: `Зөвхөн сургуулийн имэйл (${label}) хаягаар бүртгүүлэх боломжтой`,
          }, { status: 403, headers: corsHeaders });
        }
        const now = Math.floor(Date.now() / 1000);
        const recent = await db.prepare(
          'SELECT id FROM verification_codes WHERE email = ? AND created_at > ? LIMIT 1'
        ).bind(email, now - 60).first();
        if (recent) {
          return Response.json({ success: false, error: 'Хэт олон хүсэлт. 1 минут хүлээнэ үү.' }, { status: 429, headers: corsHeaders });
        }
        const code = Math.floor(100000 + Math.random() * 900000).toString();
        const codeHash = await sha256(email + code + env.JWT_SECRET);
        const expiresAt = now + 600;
        await db.prepare(
          'INSERT INTO verification_codes (email, code_hash, expires_at, created_at) VALUES (?, ?, ?, ?)'
        ).bind(email, codeHash, expiresAt, now).run();
        try {
          if (env.DEV_LOG_CODES === 'true') {
            // Local development only (set in .dev.vars, never in production):
            // print the code to the terminal instead of sending an email.
            console.log(`[dev] login code for ${email}: ${code}`);
          } else {
            await sendVerificationEmail(email, code, env.RESEND_API_KEY);
          }
        } catch (err) {
          return Response.json({ success: false, error: 'Имэйл илгээхэд алдаа гарлаа: ' + err.message }, { status: 500, headers: corsHeaders });
        }
        return Response.json({ success: true, message: 'Баталгаажуулах код илгээгдлээ' }, { headers: corsHeaders });
      }

      if (path === '/api/auth/verify-code' && method === 'POST') {
        const { email: rawEmail, code, name: rawName, role: rawRole } = await request.json();
        const email = (rawEmail || '').toLowerCase().trim();
        const name = (rawName || '').trim().slice(0, 40);
        const role = ['undergrad', 'prep', 'grad'].includes(rawRole) ? rawRole : 'undergrad';
        if (!email || !code) {
          return Response.json({ success: false, error: 'Имэйл болон код оруулна уу' }, { status: 400, headers: corsHeaders });
        }
        const now = Math.floor(Date.now() / 1000);
        const codeHash = await sha256(email + code + env.JWT_SECRET);
        const record = await db.prepare(
          'SELECT id FROM verification_codes WHERE email = ? AND code_hash = ? AND consumed = 0 AND expires_at > ? ORDER BY id DESC LIMIT 1'
        ).bind(email, codeHash, now).first();
        if (!record) {
          return Response.json({ success: false, error: 'Код буруу эсвэл хүчингүй' }, { status: 400, headers: corsHeaders });
        }
        let user = await db.prepare('SELECT * FROM users WHERE email = ?').bind(email).first();

        // First login for this email: the name is required and is stored once.
        // Asked only after the code is proven correct, so nobody can use this
        // to find out which student numbers already have an account. The code
        // is NOT consumed here, so the same code finishes the registration.
        if (!user && !name) {
          return Response.json({
            success: false,
            needs_profile: true,
            error: 'Анх удаа нэвтэрч байна — нэрээ оруулна уу',
          }, { headers: corsHeaders });
        }

        await db.prepare('UPDATE verification_codes SET consumed = 1 WHERE id = ?').bind(record.id).run();

        if (!user) {
          const userId = crypto.randomUUID();
          await db.prepare(
            'INSERT INTO users (id, email, name, role, created_at, last_login_at) VALUES (?, ?, ?, ?, ?, ?)'
          ).bind(userId, email, name, role, now, now).run();
          user = await db.prepare('SELECT * FROM users WHERE id = ?').bind(userId).first();
        } else {
          // Returning student: only the login time changes. Name and status
          // stay as registered.
          await db.prepare('UPDATE users SET last_login_at = ? WHERE id = ?').bind(now, user.id).run();
        }

        const token = await createJWT(user.id, env.JWT_SECRET);
        return Response.json({
          success: true,
          token,
          user: {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role,
            avatar_url: user.avatar_url || null,
          },
        }, { headers: corsHeaders });
      }

      // Helper to get user id from JWT
      const getUserIdFromRequest = async () => {
        const authHeader = request.headers.get('Authorization');
        if (!authHeader || !authHeader.startsWith('Bearer ')) return null;
        const token = authHeader.replace('Bearer ', '');
        const payload = await verifyJWT(token, env.JWT_SECRET);
        return payload ? payload.sub : null;
      };

      // Teachers of a course, in the order they were added. A course can have
      // several (different sections); co-teachers of one class are ONE entry
      // such as "孟庆楠、白辉洪".
      const getCourseTeachers = async (courseId) => {
        const { results } = await db.prepare(
          'SELECT teacher FROM course_teachers WHERE course_id = ? ORDER BY id'
        ).bind(Number(courseId)).all();
        if (results.length) return results.map(r => r.teacher);
        const c = await db.prepare('SELECT teacher FROM courses WHERE id = ?').bind(Number(courseId)).first();
        return c && c.teacher ? [c.teacher] : [];
      };

      // The review's teacher: required when the course has several, filled in
      // automatically when it has one. Returns { teacher } or { error }.
      const resolveReviewTeacher = async (courseId, chosen) => {
        const teachers = await getCourseTeachers(courseId);
        const t = (chosen || '').trim();
        if (teachers.length <= 1) return { teacher: teachers[0] || null };
        if (!t) return { error: 'Багшаа сонгоно уу' };
        if (!teachers.includes(t)) return { error: 'Энэ багш энэ хичээлд байхгүй байна' };
        return { teacher: t };
      };

      // Courses
      if (path === '/api/courses' && method === 'GET') {
        // review_count / avg_score are aggregated from reviews so the most-
        // reviewed courses can be shown first (and displayed on the card).
        let whereClause = '';
        let params = [];
        const userId = await getUserIdFromRequest();
        if (userId) {
          const user = await db.prepare('SELECT role FROM users WHERE id = ?').bind(userId).first();
          if (user && user.role === 'prep') {
            whereClause = 'WHERE c.category = ?';
            params = ['预科'];
          }
        }
        const sql = `
          SELECT c.*,
            (SELECT GROUP_CONCAT(entry, '||') FROM
               (SELECT ct.teacher || '::' || IFNULL(ct.note, '') AS entry
                FROM course_teachers ct WHERE ct.course_id = c.id ORDER BY ct.id)
            ) AS teacher_list,
            COALESCE(rv.review_count, 0) AS review_count,
            rv.avg_score AS avg_score
          FROM courses c
          LEFT JOIN (
            SELECT course_id,
              COUNT(*) AS review_count,
              -- Averaged per column so a review missing one dimension still
              -- counts for the other two, then divided by however many
              -- dimensions actually have data — otherwise a course where
              -- nobody filled in one dimension (e.g. 给分) would produce
              -- NULL + x = NULL and look like it had no reviews at all.
              -- workload_score is inverted (10 - x) because for that one
              -- dimension a LOWER number is better (less homework).
              (
                COALESCE(AVG(content_score), 0)
                + COALESCE(AVG(10.0 - workload_score), 0)
                + COALESCE(AVG(grading_score), 0)
              ) / NULLIF(
                (CASE WHEN AVG(content_score) IS NULL THEN 0 ELSE 1 END)
                + (CASE WHEN AVG(workload_score) IS NULL THEN 0 ELSE 1 END)
                + (CASE WHEN AVG(grading_score) IS NULL THEN 0 ELSE 1 END)
              , 0) AS avg_score
            FROM reviews
            GROUP BY course_id
          ) rv ON rv.course_id = c.id
          ${whereClause}
          ORDER BY review_count DESC, c.id ASC
        `;
        const { results } = await db.prepare(sql).bind(...params).all();
        // teachers: names in order; teacher_notes: e.g. { 王东敏: '男生班' }
        // for sections that are only for men or only for women.
        const data = results.map(({ teacher_list, ...c }) => {
          const entries = teacher_list ? teacher_list.split('||').map(e => e.split('::')) : [];
          const teacher_notes = {};
          entries.forEach(([t, note]) => { if (note) teacher_notes[t] = note; });
          return {
            ...c,
            teachers: entries.length ? entries.map(([t]) => t) : (c.teacher ? [c.teacher] : []),
            teacher_notes,
          };
        });
        return Response.json({ success: true, data }, { headers: corsHeaders });
      }

      // Add course (students can fill in courses missing from the list)
      if (path === '/api/courses' && method === 'POST') {
        const userId = await getUserIdFromRequest();
        if (!userId) {
          return Response.json({ success: false, error: 'Нэвтэрнэ үү' }, { status: 401, headers: corsHeaders });
        }
        const body = await request.json();
        const name_cn = (body.name_cn || '').trim();
        const name_en = (body.name_en || '').trim();
        const teacher = (body.teacher || '').trim();
        const semester = (body.semester || '').trim();
        // Must match COURSE_CATEGORIES in public/app.js.
        const CATEGORIES = ['与中国有关课程', '通识课一', '通识课二', '通识课三', '通识课四', '体育课'];
        const category = (body.category || '').trim() || '与中国有关课程';
        if (!CATEGORIES.includes(category)) {
          return Response.json({ success: false, error: 'Ангилал буруу байна' }, { status: 400, headers: corsHeaders });
        }
        const credits = (body.credits === '' || body.credits === null || body.credits === undefined)
          ? null
          : Number(body.credits);

        if (!name_cn) {
          return Response.json({ success: false, error: 'Хичээлийн нэр оруулна уу' }, { status: 400, headers: corsHeaders });
        }
        // Teacher and credits are required: without them the course card
        // can't tell students which class (and how much load) this is.
        if (!teacher) {
          return Response.json({ success: false, error: 'Багшийн нэрийг оруулна уу' }, { status: 400, headers: corsHeaders });
        }
        if (credits === null || isNaN(credits) || credits <= 0 || credits > 30) {
          return Response.json({ success: false, error: 'Кредитийг зөв оруулна уу' }, { status: 400, headers: corsHeaders });
        }
        // One course per name. A course that already exists with another
        // teacher gets that teacher added instead of a second card; the same
        // name + teacher is a duplicate.
        const same = await db.prepare(
          'SELECT id FROM courses WHERE TRIM(LOWER(name_cn)) = ? ORDER BY id LIMIT 1'
        ).bind(name_cn.toLowerCase()).first();
        if (same) {
          const teachers = await getCourseTeachers(same.id);
          if (teachers.some(t => t.trim().toLowerCase() === teacher.toLowerCase())) {
            return Response.json({
              success: false,
              error: 'Ийм хичээл аль хэдийн бүртгэгдсэн байна',
              data: { id: same.id, duplicate: true },
            }, { status: 409, headers: corsHeaders });
          }
          // Courses created before teacher lists existed keep their teacher
          // only on the course row — copy it over first so it isn't lost.
          const stored = await db.prepare('SELECT COUNT(*) AS n FROM course_teachers WHERE course_id = ?').bind(same.id).first();
          if (!stored.n && teachers.length) {
            await db.prepare('INSERT OR IGNORE INTO course_teachers (course_id, teacher) VALUES (?, ?)').bind(same.id, teachers[0]).run();
          }
          await db.prepare('INSERT OR IGNORE INTO course_teachers (course_id, teacher) VALUES (?, ?)').bind(same.id, teacher).run();
          return Response.json({ success: true, data: { id: same.id, added_teacher: true } }, { headers: corsHeaders });
        }
        // 通识课 courses also record their type and whether they are 核心课.
        const tongshi = category.startsWith('通识课') ? category : null;
        const isCore = tongshi && (body.is_core === true || body.is_core === 1) ? 1 : 0;
        const result = await db.prepare(
          'INSERT INTO courses (name_cn, name_en, teacher, credits, semester, category, tongshi, is_core) VALUES (?, ?, ?, ?, ?, ?, ?, ?)'
        ).bind(name_cn, name_en || null, teacher, credits, semester || null, category, tongshi, isCore).run();
        const newId = result.meta.last_row_id;
        await db.prepare('INSERT OR IGNORE INTO course_teachers (course_id, teacher) VALUES (?, ?)').bind(newId, teacher).run();
        return Response.json({ success: true, data: { id: newId } }, { headers: corsHeaders });
      }

      // Reviews
      if (path === '/api/reviews' && method === 'GET') {
        const courseId = url.searchParams.get('course_id');
        if (!courseId) {
          return Response.json({ success: false, error: 'Хичээлийн ID оруулна уу' }, { status: 400, headers: corsHeaders });
        }
        const { results } = await db.prepare(`
          SELECT r.*, u.name, u.avatar_url
          FROM reviews r
          LEFT JOIN users u ON r.author_id = u.id
          WHERE r.course_id = ?
          ORDER BY r.created_at DESC
        `).bind(Number(courseId)).all();
        const processed = results.map(r => {
          if (r.is_anonymous) {
            return { ...r, name: 'Нэргүй', avatar_url: null };
          }
          return r;
        });
        return Response.json({ success: true, data: processed }, { headers: corsHeaders });
      }

      // Every review this user has written — lets the site show what they have
      // already covered and reopen an existing review instead of duplicating it.
      if (path === '/api/reviews/mine' && method === 'GET') {
        const userId = await getUserIdFromRequest();
        if (!userId) {
          return Response.json({ success: false, error: 'Нэвтэрнэ үү' }, { status: 401, headers: corsHeaders });
        }
        const { results } = await db.prepare(
          'SELECT * FROM reviews WHERE author_id = ? ORDER BY created_at DESC'
        ).bind(userId).all();
        return Response.json({ success: true, data: results }, { headers: corsHeaders });
      }

      if (path === '/api/reviews' && method === 'POST') {
        const userId = await getUserIdFromRequest();
        if (!userId) {
          return Response.json({ success: false, error: 'Нэвтэрнэ үү' }, { status: 401, headers: corsHeaders });
        }
        const body = await request.json();
        const {
          course_id, content_score, workload_score, grading_score,
          midterm, final, homework, attendance, groupwork, bigassignment,
          grading_ratio, comment, is_anonymous, taken_semester, teacher: chosenTeacher
        } = body;
        if (!course_id) {
          return Response.json({ success: false, error: 'Хичээл сонгоно уу' }, { status: 400, headers: corsHeaders });
        }
        const picked = await resolveReviewTeacher(course_id, chosenTeacher);
        if (picked.error) {
          return Response.json({ success: false, error: picked.error }, { status: 400, headers: corsHeaders });
        }

        // One review per person per course. A repeat submission updates the
        // existing one rather than stacking duplicates — which would also
        // inflate review_count, the value the course list is sorted by.
        const mine = await db.prepare(
          'SELECT id FROM reviews WHERE author_id = ? AND course_id = ? LIMIT 1'
        ).bind(userId, Number(course_id)).first();

        if (mine) {
          await db.prepare(`
            UPDATE reviews SET
              content_score = ?, workload_score = ?, grading_score = ?,
              midterm = ?, final = ?, homework = ?, attendance = ?,
              groupwork = ?, bigassignment = ?, grading_ratio = ?, comment = ?,
              is_anonymous = ?, taken_semester = ?, teacher = ?, updated_at = CURRENT_TIMESTAMP
            WHERE id = ?
          `).bind(
            content_score ?? null, workload_score ?? null, grading_score ?? null,
            midterm || null, final || null, homework || null, attendance || null,
            groupwork || null, bigassignment || null, grading_ratio || null, comment || null,
            is_anonymous ? 1 : 0, taken_semester || null, picked.teacher,
            mine.id
          ).run();
          return Response.json({ success: true, data: { id: mine.id, updated: true } }, { headers: corsHeaders });
        }

        const result = await db.prepare(`
          INSERT INTO reviews (course_id, author_id, content_score, workload_score, grading_score,
            midterm, final, homework, attendance, groupwork, bigassignment, grading_ratio, comment,
            is_anonymous, taken_semester, teacher)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `).bind(
          Number(course_id), userId,
          content_score ?? null, workload_score ?? null, grading_score ?? null,
          midterm || null, final || null, homework || null, attendance || null,
          groupwork || null, bigassignment || null, grading_ratio || null, comment || null,
          is_anonymous ? 1 : 0, taken_semester || null, picked.teacher
        ).run();
        return Response.json({ success: true, data: { id: result.meta.last_row_id } }, { headers: corsHeaders });
      }

      if (path.startsWith('/api/reviews/') && method === 'PUT') {
        const userId = await getUserIdFromRequest();
        if (!userId) {
          return Response.json({ success: false, error: 'Нэвтэрнэ үү' }, { status: 401, headers: corsHeaders });
        }
        const reviewId = path.split('/')[3];
        if (!reviewId) {
          return Response.json({ success: false, error: 'Үнэлгээний ID оруулна уу' }, { status: 400, headers: corsHeaders });
        }
        const existing = await db.prepare('SELECT author_id, course_id FROM reviews WHERE id = ?').bind(Number(reviewId)).first();
        if (!existing) {
          return Response.json({ success: false, error: 'Үнэлгээ олдсонгүй' }, { status: 404, headers: corsHeaders });
        }
        if (existing.author_id !== userId) {
          return Response.json({ success: false, error: 'Бусдын үнэлгээг засварлах боломжгүй' }, { status: 403, headers: corsHeaders });
        }
        const body = await request.json();
        const {
          content_score, workload_score, grading_score,
          midterm, final, homework, attendance, groupwork, bigassignment,
          grading_ratio, comment, is_anonymous, taken_semester, teacher: chosenTeacher
        } = body;
        const picked = await resolveReviewTeacher(existing.course_id, chosenTeacher);
        if (picked.error) {
          return Response.json({ success: false, error: picked.error }, { status: 400, headers: corsHeaders });
        }
        await db.prepare(`
          UPDATE reviews SET
            content_score = ?, workload_score = ?, grading_score = ?,
            midterm = ?, final = ?, homework = ?, attendance = ?,
            groupwork = ?, bigassignment = ?, grading_ratio = ?, comment = ?,
            is_anonymous = ?, taken_semester = ?, teacher = ?, updated_at = CURRENT_TIMESTAMP
          WHERE id = ?
        `).bind(
          content_score ?? null, workload_score ?? null, grading_score ?? null,
          midterm || null, final || null, homework || null, attendance || null,
          groupwork || null, bigassignment || null, grading_ratio || null, comment || null,
          is_anonymous ? 1 : 0, taken_semester || null, picked.teacher,
          Number(reviewId)
        ).run();
        return Response.json({ success: true }, { headers: corsHeaders });
      }

      if (path.startsWith('/api/reviews/') && method === 'DELETE') {
        const userId = await getUserIdFromRequest();
        if (!userId) {
          return Response.json({ success: false, error: 'Нэвтэрнэ үү' }, { status: 401, headers: corsHeaders });
        }
        const reviewId = path.split('/')[3];
        if (!reviewId) {
          return Response.json({ success: false, error: 'Үнэлгээний ID оруулна уу' }, { status: 400, headers: corsHeaders });
        }
        const existing = await db.prepare('SELECT author_id FROM reviews WHERE id = ?').bind(Number(reviewId)).first();
        if (!existing) {
          return Response.json({ success: false, error: 'Үнэлгээ олдсонгүй' }, { status: 404, headers: corsHeaders });
        }
        if (existing.author_id !== userId) {
          return Response.json({ success: false, error: 'Бусдын үнэлгээг устгах боломжгүй' }, { status: 403, headers: corsHeaders });
        }
        await db.prepare('DELETE FROM reviews WHERE id = ?').bind(Number(reviewId)).run();
        return Response.json({ success: true }, { headers: corsHeaders });
      }

      // User endpoint
      if (path === '/api/user' && method === 'GET') {
        const userId = await getUserIdFromRequest();
        if (!userId) {
          return Response.json({ success: false, error: 'Нэвтэрнэ үү' }, { status: 401, headers: corsHeaders });
        }
        const user = await db.prepare('SELECT id, email, name, role, avatar_url FROM users WHERE id = ?').bind(userId).first();
        if (!user) {
          return Response.json({ success: false, error: 'Хэрэглэгч олдсонгүй' }, { status: 404, headers: corsHeaders });
        }
        return Response.json({ success: true, data: user }, { headers: corsHeaders });
      }

      return Response.json({ success: false, error: 'Интерфэйс олдсонгүй' }, { status: 404, headers: corsHeaders });
    } catch (error) {
      console.error(error);
      return Response.json({ success: false, error: 'Серверийн алдаа: ' + error.message }, { status: 500, headers: corsHeaders });
    }
  }
}
