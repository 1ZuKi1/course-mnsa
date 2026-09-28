// ===== Тохиргоо =====
// The page and the API are served by the same Worker, so every API call is a
// plain same-origin '/api/...' request.
// Shown as the fixed suffix on the login field. Must match
// ALLOWED_EMAIL_DOMAINS in the API Worker's wrangler.toml.
const SCHOOL_EMAIL_DOMAIN = 'stu.pku.edu.cn';

// ===== Icon library (inline SVG, Lucide-style) =====
const ICON_PATHS = {
  search: '<circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/>',
  mail: '<rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>',
  user: '<path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>',
  graduationCap: '<path d="M21.42 10.922a1 1 0 0 0-.019-1.838L12.83 5.18a2 2 0 0 0-1.66 0L2.6 9.08a1 1 0 0 0 0 1.832l8.57 3.908a2 2 0 0 0 1.66 0z"/><path d="M22 10v6"/><path d="M6 12.5V16a6 3 0 0 0 12 0v-3.5"/>',
  pencil: '<path d="M17 3a2.85 2.83 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5Z"/>',
  trash: '<path d="M3 6h18"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/><path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><line x1="10" x2="10" y1="11" y2="17"/><line x1="14" x2="14" y1="11" y2="17"/>',
  messageCircle: '<path d="M7.9 20A9 9 0 1 0 4 16.1L2 22Z"/>',
  inbox: '<polyline points="22 12 16 12 14 15 10 15 8 12 2 12"/><path d="M5.45 5.11 2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z"/>',
  chevronRight: '<path d="m9 18 6-6-6-6"/>',
  checkCircle: '<path d="M21.801 10A10 10 0 1 1 17 3.335"/><path d="m9 11 3 3L22 4"/>',
  xCircle: '<circle cx="12" cy="12" r="10"/><path d="m15 9-6 6"/><path d="m9 9 6 6"/>',
  info: '<circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/>',
  calendar: '<rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="M8 2v4"/><path d="M16 2v4"/>',
  credit: '<path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1 0-5H20"/>',
  send: '<path d="m22 2-7 20-4-9-9-4Z"/><path d="M22 2 11 13"/>',
};

function icon(name, size = 16, extra = '') {
  const body = ICON_PATHS[name] || '';
  return `<svg class="icon" width="${size}" height="${size}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" ${extra}>${body}</svg>`;
}

function escapeHtml(str) {
  return String(str == null ? '' : str).replace(/[&<>"']/g, (c) => (
    { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]
  ));
}

function starSvg(filled) {
  return `<svg width="13" height="13" viewBox="0 0 24 24" fill="${filled ? 'currentColor' : 'none'}" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>`;
}

// ===== Төлөв =====
let currentUser = null;
let currentCourse = null;
let editingReviewId = null;
let allCourses = [];
// course_id -> this user's own review, so the site can mark what they have
// covered and reopen an existing review instead of creating a duplicate.
let myReviews = new Map();

// ===== Token management =====
const TOKEN_KEY = 'auth_token';
const USER_KEY = 'current_user';
function getToken() { return localStorage.getItem(TOKEN_KEY); }
function setToken(token) { localStorage.setItem(TOKEN_KEY, token); }
function clearToken() { localStorage.removeItem(TOKEN_KEY); }
function getStoredUser() { const data = localStorage.getItem(USER_KEY); return data ? JSON.parse(data) : null; }
function setStoredUser(user) { localStorage.setItem(USER_KEY, JSON.stringify(user)); }
function clearStoredUser() { localStorage.removeItem(USER_KEY); }

// ===== Toast =====
function showToast(message, type = 'info') {
  const container = document.getElementById('toastContainer');
  const toast = document.createElement('div');
  toast.className = `toast toast-${type}`;
  const iconName = type === 'success' ? 'checkCircle' : type === 'error' ? 'xCircle' : 'info';
  toast.innerHTML = `<span class="toast-icon">${icon(iconName, 18)}</span><span>${escapeHtml(message)}</span>`;
  container.appendChild(toast);
  requestAnimationFrame(() => toast.classList.add('show'));
  setTimeout(() => {
    toast.classList.remove('show');
    setTimeout(() => toast.remove(), 350);
  }, 3200);
}

// ===== DOM =====
const courseListEl = document.getElementById('courseList');
const modalOverlay = document.getElementById('modalOverlay');
const modalTitle = document.getElementById('modalTitle');
const modalSub = document.getElementById('modalSub');
const reviewListEl = document.getElementById('reviewList');
const courseSummary = document.getElementById('courseSummary');
const reviewCountEl = document.getElementById('reviewCount');
const reviewFormArea = document.getElementById('reviewFormArea');
const loginBtn = document.getElementById('loginBtn');
const logoutBtn = document.getElementById('logoutBtn');
const userInfo = document.getElementById('userInfo');
const userName = document.getElementById('userName');
const userRole = document.getElementById('userRole');
const formContentScore = document.getElementById('formContentScore');
const formWorkloadScore = document.getElementById('formWorkloadScore');
const formGradingScore = document.getElementById('formGradingScore');
const formMidterm = document.getElementById('formMidterm');
const formFinal = document.getElementById('formFinal');
const formHomework = document.getElementById('formHomework');
const formAttendance = document.getElementById('formAttendance');
const formGroupwork = document.getElementById('formGroupwork');
const formBigassignment = document.getElementById('formBigassignment');
const formGradingRatio = document.getElementById('formGradingRatio');
const formComment = document.getElementById('formComment');
const formTakenSemester = document.getElementById('formTakenSemester');
const formAnonymous = document.getElementById('formAnonymous');
const submitReviewBtn = document.getElementById('submitReviewBtn');
const cancelEditBtn = document.getElementById('cancelEditBtn');
const modalCloseBtn = document.getElementById('modalCloseBtn');
const loginModalOverlay = document.getElementById('loginModalOverlay');
const loginModalCloseBtn = document.getElementById('loginModalCloseBtn');
const loginEmail = document.getElementById('loginEmail');
const loginName = document.getElementById('loginName');
const loginRole = document.getElementById('loginRole');
const loginStep1 = document.getElementById('loginStep1');
const loginStep2 = document.getElementById('loginStep2');
const sendCodeBtn = document.getElementById('sendCodeBtn');
const loginSubmitBtn = document.getElementById('loginSubmitBtn');
const backToStep1 = document.getElementById('backToStep1');
const searchInput = document.getElementById('searchInput');
const toggleDetailsBtn = document.getElementById('toggleDetailsBtn');
const reviewDetails = document.getElementById('reviewDetails');
const courseCount = document.getElementById('courseCount');
const thinNotice = document.getElementById('thinNotice');
const thinNoticeText = document.getElementById('thinNoticeText');
const loginPrompt = document.getElementById('loginPrompt');
const promptLoginBtn = document.getElementById('promptLoginBtn');
const addCourseBtn = document.getElementById('addCourseBtn');
const addCourseOverlay = document.getElementById('addCourseOverlay');
const addCourseCloseBtn = document.getElementById('addCourseCloseBtn');
const newCourseName = document.getElementById('newCourseName');
const newCourseTeacher = document.getElementById('newCourseTeacher');
const newCourseCredits = document.getElementById('newCourseCredits');
const newCourseSemester = document.getElementById('newCourseSemester');
const newCourseCategory = document.getElementById('newCourseCategory');
const submitCourseBtn = document.getElementById('submitCourseBtn');

// ===== Button busy state =====
function setBusy(btn, busy, busyLabel) {
  if (!btn) return;
  if (busy) {
    if (btn.dataset.idleHtml === undefined) btn.dataset.idleHtml = btn.innerHTML;
    btn.disabled = true;
    btn.innerHTML = `<span class="btn-spinner"></span>${escapeHtml(busyLabel || '')}`;
  } else {
    btn.disabled = false;
    if (btn.dataset.idleHtml !== undefined) {
      btn.innerHTML = btn.dataset.idleHtml;
      delete btn.dataset.idleHtml;
    }
  }
}

// Recent terms, newest first. Generated rather than hard-coded so the list
// doesn't go stale as years pass.
function buildSemesterOptions() {
  const now = new Date();
  const year = now.getFullYear();
  // Spring runs into summer, so before August the current year's autumn
  // term hasn't happened yet.
  const startYear = now.getMonth() >= 7 ? year : year - 1;
  const opts = ['<option value="">— 选填 —</option>'];
  for (let y = startYear; y > startYear - 5; y--) {
    opts.push(`<option value="${y} 秋季">${y} 秋季</option>`);
    opts.push(`<option value="${y} 春季">${y} 春季</option>`);
  }
  opts.push('<option value="更早">更早 / 记不清了</option>');
  formTakenSemester.innerHTML = opts.join('');
}
buildSemesterOptions();

// ===== Review form optional details =====
function setDetailsOpen(open) {
  toggleDetailsBtn.classList.toggle('open', open);
  toggleDetailsBtn.setAttribute('aria-expanded', String(open));
  reviewDetails.classList.toggle('open', open);
}
toggleDetailsBtn.addEventListener('click', () => {
  setDetailsOpen(!reviewDetails.classList.contains('open'));
});

// ===== Score slider helpers =====
function updateScoreSlider(input) {
  const value = parseInt(input.value, 10);
  const pct = (value / 10) * 100;
  input.style.background =
    `linear-gradient(to right, var(--accent) 0%, var(--accent) ${pct}%, #ddd5c7 ${pct}%, #ddd5c7 100%)`;
  const valueEl = document.getElementById(input.id + 'Value');
  if (valueEl) valueEl.textContent = value;
  // Keep the 0–10 buttons (desktop) in step with the slider (phone).
  const seg = document.querySelector(`.score-seg[data-for="${input.id}"]`);
  if (seg) {
    seg.querySelectorAll('button').forEach(b => {
      const on = Number(b.dataset.value) === value;
      b.setAttribute('aria-checked', String(on));
      b.tabIndex = on ? 0 : -1;
    });
  }
}

// 0–10 button row for each score. The range input stays the single source of
// truth; the buttons just write into it. CSS shows the buttons on wide screens
// and the large slider on phones, where 11 buttons would be too narrow to tap.
document.querySelectorAll('.score-seg').forEach(seg => {
  const input = document.getElementById(seg.dataset.for);
  seg.innerHTML = Array.from({ length: 11 }, (_, n) =>
    `<button type="button" role="radio" data-value="${n}" aria-checked="false">${n}</button>`
  ).join('');
  seg.addEventListener('click', (e) => {
    const btn = e.target.closest('button');
    if (!btn) return;
    input.value = btn.dataset.value;
    updateScoreSlider(input);
  });
  // Arrow keys move between values, like a native radio group.
  seg.addEventListener('keydown', (e) => {
    const delta = { ArrowRight: 1, ArrowUp: 1, ArrowLeft: -1, ArrowDown: -1 }[e.key];
    if (delta === undefined) return;
    e.preventDefault();
    input.value = Math.min(10, Math.max(0, Number(input.value) + delta));
    updateScoreSlider(input);
    seg.querySelector('[aria-checked="true"]').focus();
  });
});

function setupScoreSlider(id) {
  const el = document.getElementById(id);
  if (!el) return;
  updateScoreSlider(el);
  el.addEventListener('input', () => updateScoreSlider(el));
}

function setScoreSlider(id, value) {
  const el = document.getElementById(id);
  if (!el) return;
  el.value = (value === null || value === undefined) ? 5 : Math.min(10, Math.max(0, Number(value)));
  updateScoreSlider(el);
}

setupScoreSlider('formContentScore');
setupScoreSlider('formWorkloadScore');
setupScoreSlider('formGradingScore');

// ===== Conditional "有/无" fields (考试 / 作业等) =====
const toggleFieldConfig = [
  { key: 'midterm', cb: 'hasMidterm', input: 'formMidterm' },
  { key: 'final', cb: 'hasFinal', input: 'formFinal' },
  { key: 'homework', cb: 'hasHomework', input: 'formHomework' },
  { key: 'attendance', cb: 'hasAttendance', input: 'formAttendance' },
  { key: 'groupwork', cb: 'hasGroupwork', input: 'formGroupwork' },
  { key: 'bigassignment', cb: 'hasBigassignment', input: 'formBigassignment' },
];

function setToggle(cbId, on) {
  const cb = document.getElementById(cbId);
  if (!cb) return;
  cb.checked = on;
  const item = cb.closest('.toggle-item');
  if (item) {
    item.classList.toggle('on', on);
    const caption = item.querySelector('.switch-caption');
    if (caption) caption.textContent = on ? '有' : '无';
  }
}

function resetToggleFields() {
  toggleFieldConfig.forEach(({ cb, input }) => {
    setToggle(cb, false);
    document.getElementById(input).value = '';
  });
}

function getToggleValue(cbId, inputId) {
  if (!document.getElementById(cbId).checked) return null;
  const text = document.getElementById(inputId).value.trim();
  return text || '有';
}

document.querySelectorAll('.toggle-item .switch input').forEach(cb => {
  cb.addEventListener('change', () => setToggle(cb.id, cb.checked));
});

// ===== API fetch =====
async function apiFetch(path, options = {}) {
  const headers = { 'Content-Type': 'application/json', ...options.headers };
  const token = getToken();
  if (token) headers['Authorization'] = `Bearer ${token}`;

  const resp = await fetch(path, { ...options, headers });
  const contentType = resp.headers.get('content-type') || '';
  // A non-JSON body means the request never reached the API code.
  if (!contentType.includes('application/json')) {
    throw new Error('API_UNREACHABLE');
  }
  return resp.json();
}

function formatDate(ts) {
  if (!ts) return '';
  const d = new Date(ts);
  return d.toLocaleDateString('mn-MN') + ' ' + d.toLocaleTimeString('mn-MN', { hour: '2-digit', minute: '2-digit' });
}

// Teacher · credits · semester, shown right under the course name on the card
// and in the course window. Credits get their own chip because they are the
// first thing a student checks when planning a term.
function courseFacts(c, withCategory = false) {
  const hasCredits = c.credits !== null && c.credits !== undefined && c.credits !== '';
  const items = [
    `<span class="fact fact-credits">${icon('credit', 15)}${hasCredits ? escapeHtml(String(c.credits)) : '—'} кредит</span>`,
    c.teacher ? `<span class="fact">${icon('user', 15)}${escapeHtml(c.teacher)}</span>` : '',
    formatSemester(c.semester) ? `<span class="fact">${icon('calendar', 15)}${escapeHtml(formatSemester(c.semester))}</span>` : '',
    withCategory && c.category ? `<span class="fact">${escapeHtml(c.category)}</span>` : '',
  ].filter(Boolean);
  return `<div class="course-facts">${items.join('')}</div>`;
}

function formatSemester(semester) {
  const map = { '秋': '秋季', '春': '春季', '秋/春': '秋季/春季' };
  return map[semester] || semester || '';
}

// ===== Courses =====
async function loadMyReviews() {
  myReviews = new Map();
  if (!currentUser) return;
  try {
    const res = await apiFetch('/api/reviews/mine');
    if (res.success) {
      res.data.forEach(r => myReviews.set(Number(r.course_id), r));
    }
  } catch (e) {
    // Non-fatal: the site just loses the "already reviewed" markers.
  }
}

async function loadCourses() {
  const res = await apiFetch('/api/courses');
  if (res.success) {
    allCourses = res.data;
    await loadMyReviews();
    renderCategoryFilter();
    applyFilters();
  } else {
    courseListEl.innerHTML = `<div class="empty-state">${icon('info', 32)}<p>Ачаалахад алдаа гарлаа: ${escapeHtml(res.error)}</p></div>`;
  }
}

function renderCourses(courses) {
  const total = (courses || []).length;
  if (courseCount) {
    const base = total === allCourses.length ? `${total} хичээл` : `${total} / ${allCourses.length} хичээл`;
    // Signed-in students also see how much of the catalogue they have
    // covered — a quiet nudge that their own reviews are still missing.
    const mine = currentUser ? myReviews.size : 0;
    courseCount.textContent = total
      ? (currentUser ? `${base} · Таны үнэлсэн: ${mine}` : base)
      : '';
  }
  if (!courses || courses.length === 0) {
    courseListEl.innerHTML = `<div class="empty-state">${icon('inbox', 38)}<p>Хичээл олдсонгүй</p></div>`;
    return;
  }
  courseListEl.innerHTML = courses.map((c) => {
    const credits = (c.credits !== null && c.credits !== undefined && c.credits !== '')
      ? `${c.credits} кредит`
      : '— кредит';
    const facts = courseFacts(c);
    const reviewCount = Number(c.review_count) || 0;
    const avgScore = (c.avg_score === null || c.avg_score === undefined) ? null : Number(c.avg_score);
    // Three distinct states: no reviews at all / reviews but nobody left a
    // numeric score / a real average. Collapsing the middle case into
    // "no reviews" hides reviews that do exist.
    let ratingHtml;
    if (reviewCount === 0) {
      ratingHtml = `<div class="course-rating empty"><span>Одоохондоо үнэлгээ байхгүй</span><span class="first-review">Эхний үнэлгээг өгөх</span></div>`;
    } else if (avgScore === null) {
      ratingHtml = `<div class="course-rating"><span>${reviewCount} үнэлгээ</span></div>`;
    } else {
      ratingHtml = `<div class="course-rating"><span class="rating-star">${starSvg(true)}</span><span class="rating-score">${avgScore.toFixed(1)}</span><span>· ${reviewCount} үнэлгээ</span></div>`;
    }
    const reviewedChip = myReviews.has(c.id)
      ? `<span class="chip chip-good">${icon('checkCircle', 14)} Үнэлсэн</span>` : '';
    // A real link: keyboard, middle-click and "copy link" all work, and the
    // hashchange listener opens the course.
    return `
<a class="course-card" href="#course-${c.id}" data-id="${c.id}">
  <div class="card-chips">
    ${c.category ? `<span class="chip">${escapeHtml(c.category)}</span>` : ''}
    ${reviewedChip}
  </div>
  <h3 class="course-name">${escapeHtml(c.name_cn || c.name_en || '—')}</h3>
  ${c.name_en ? `<div class="course-meta">${escapeHtml(c.name_en)}</div>` : ''}
  ${facts}
  <div class="course-card-bottom">
    ${ratingHtml}
    <span class="card-arrow">${icon('chevronRight', 18)}</span>
  </div>
</a>
  `;
  }).join('');
}

// Searching for who built this — in any of the three languages the site
// touches — turns up the signature instead of "no courses found".
const AUTHOR_KEYWORDS = [
  'зохиогч', 'хөгжүүлэгч', 'бүтээгч', 'хэн хийсэн',
  '创作者', '开发者', '作者', '制作者', '谁做的', '谁开发的',
  'author', 'creator', 'developer', 'credits', 'made by', 'who made this',
];

function renderSignature() {
  if (courseCount) courseCount.textContent = '';
  courseListEl.innerHTML = `
    <div class="signature">
      <div class="signature-mark">✦</div>
      <div class="signature-label">Сайтын зохиогч</div>
      <div class="signature-name">Battugs Zuchi<span>族池</span></div>
      <div class="signature-story">
        <p>这个网站最初只是一份问卷。</p>
        <p>我们靠它收集蒙古留学生对课程的评价——能收上来，但也就到此为止了。新来的同学想了解一门课，得先找到人、要来文件，再自己一行行翻。</p>
        <p>大二上学期我开始想，既然学的是计算机，为什么不把它做成一个真正能用的东西。于是有了这个网站，和它背后的数据库。</p>
        <p>现在写评价不用再填表，看别人写的也不用再找人要文件——搜一下就有。希望以后的学弟学妹选课时，能少走一点弯路。</p>
      </div>
      <div class="signature-foot">2026 · Энэ сайтыг Монгол оюутнуудад зориулж хийсэн</div>
    </div>
  `;
}

// ===== Categories =====
// The only categories a course can have. 通识课 has four sub-types, stored as
// the full name (通识课一 …) so each course keeps exactly one category.
const COURSE_CATEGORIES = [
  { value: '与中国有关课程', label: '与中国有关课程' },
  { value: '通识课', label: '通识课', subs: ['通识课一', '通识课二', '通识课三', '通识课四'] },
  { value: '体育课', label: '体育课' },
];
const DEFAULT_CATEGORY = '与中国有关课程';
let activeCategory = '';      // '' = all, or a top-level value
let activeSubCategory = '';   // '' = all 通识课, or 通识课一 …

const categoryFilterEl = document.getElementById('categoryFilter');
const categorySubEl = document.getElementById('categorySub');

function inCategory(course, top, sub) {
  const cat = course.category || '';
  if (!top) return true;
  if (top === '通识课') return sub ? cat === sub : cat.startsWith('通识课');
  return cat === top;
}

function catButton(value, label, pressed, count, level) {
  return `<button type="button" class="cat-btn" data-level="${level}" data-value="${escapeHtml(value)}" aria-pressed="${pressed}">${escapeHtml(label)}<span class="cat-count">${count}</span></button>`;
}

function renderCategoryFilter() {
  const count = (top, sub = '') => allCourses.filter(c => inCategory(c, top, sub)).length;
  categoryFilterEl.innerHTML = [
    catButton('', 'Бүгд', activeCategory === '', allCourses.length, 'top'),
    ...COURSE_CATEGORIES.map(c => catButton(c.value, c.label, activeCategory === c.value, count(c.value), 'top')),
  ].join('');
  const tongshi = COURSE_CATEGORIES.find(c => c.subs);
  categorySubEl.hidden = activeCategory !== tongshi.value;
  categorySubEl.innerHTML = [
    catButton('', 'Бүх 通识课', activeSubCategory === '', count(tongshi.value), 'sub'),
    ...tongshi.subs.map(s => catButton(s, s, activeSubCategory === s, count(tongshi.value, s), 'sub')),
  ].join('');
}

function onCategoryClick(e) {
  const btn = e.target.closest('.cat-btn');
  if (!btn) return;
  if (btn.dataset.level === 'top') {
    activeCategory = btn.dataset.value;
    activeSubCategory = '';
  } else {
    activeSubCategory = btn.dataset.value;
  }
  renderCategoryFilter();
  applyFilters();
}
categoryFilterEl.addEventListener('click', onCategoryClick);
categorySubEl.addEventListener('click', onCategoryClick);

// Search text and category filter work together.
function applyFilters() {
  const query = searchInput.value.toLowerCase().trim();
  if (query && AUTHOR_KEYWORDS.includes(query)) { renderSignature(); return; }
  const filtered = allCourses.filter(c =>
    inCategory(c, activeCategory, activeSubCategory) && (!query ||
      (c.name_cn || '').toLowerCase().includes(query) ||
      (c.name_en || '').toLowerCase().includes(query) ||
      (c.teacher || '').toLowerCase().includes(query) ||
      (c.category || '').toLowerCase().includes(query) ||
      (c.semester || '').toLowerCase().includes(query))
  );
  renderCourses(filtered);
}

searchInput.addEventListener('input', applyFilters);

// ===== Course Detail & Reviews =====
async function openCourseDetail(course) {
  currentCourse = course;
  editingReviewId = null;
  cancelEditBtn.style.display = 'none';
  submitReviewBtn.innerHTML = `${icon('send', 16)} Үнэлгээ илгээх`;
  modalTitle.textContent = course.name_cn;
  modalSub.innerHTML = courseFacts(course, true);
  courseSummary.hidden = true;
  reviewCountEl.textContent = '';
  // Give the open course its own address (#course-12) so the phone's Back
  // button closes it and the link can be shared.
  const hash = `#course-${course.id}`;
  if (location.hash !== hash) history.pushState(null, '', hash);

  // Clear form
  setScoreSlider('formContentScore', 5);
  setScoreSlider('formWorkloadScore', 5);
  setScoreSlider('formGradingScore', 5);
  resetToggleFields();
  formGradingRatio.value = '';
  formComment.value = '';
  formAnonymous.checked = false;
  formTakenSemester.value = '';
  setDetailsOpen(false);

  // Already reviewed this course? Open straight into editing it, so nobody
  // writes a second review by accident.
  const existing = myReviews.get(course.id);
  if (currentUser && existing) fillEditForm(existing);

  updateReviewFormVisibility();
  modalOverlay.classList.add('active');
  modalOverlay.querySelector('.modal-body').scrollTop = 0;
  modalCloseBtn.focus({ preventScroll: true });
  await loadReviews(course.id);
}

// ===== Course URL routing (#course-<id>) =====
// True when the visitor arrived straight on a course link: there is no list
// page behind it in history, so closing must not call history.back().
let landedOnCourse = false;

function courseIdFromHash() {
  const m = location.hash.match(/^#course-(\d+)$/);
  return m ? Number(m[1]) : null;
}

function routeFromHash() {
  const id = courseIdFromHash();
  if (id === null) {
    modalOverlay.classList.remove('active');
    return;
  }
  const course = allCourses.find(c => c.id === id);
  if (!course) return;
  const alreadyOpen = modalOverlay.classList.contains('active') && currentCourse && currentCourse.id === id;
  if (!alreadyOpen) openCourseDetail(course);
}
window.addEventListener('hashchange', routeFromHash);
window.addEventListener('popstate', routeFromHash);

function closeCourse() {
  if (courseIdFromHash() === null) {
    modalOverlay.classList.remove('active');
  } else if (landedOnCourse) {
    landedOnCourse = false;
    history.replaceState(null, '', location.pathname + location.search);
    modalOverlay.classList.remove('active');
  } else {
    history.back(); // hashchange/popstate then closes the modal
  }
}

// Logged-out visitors get an invitation to sign in instead of a form that
// only rejects them on submit.
function updateReviewFormVisibility() {
  const loggedIn = !!currentUser;
  if (reviewFormArea) reviewFormArea.style.display = loggedIn ? '' : 'none';
  if (loginPrompt) loginPrompt.style.display = loggedIn ? 'none' : 'flex';
  updateThinNotice();
}

// Almost every course here has only one review, which is the main reason
// the site isn't useful yet. Say so where someone can actually act on it —
// but not to people who already reviewed this course.
function updateThinNotice() {
  if (!thinNotice) return;
  const count = currentCourse ? (Number(currentCourse.review_count) || 0) : 0;
  const alreadyMine = currentCourse && myReviews.has(currentCourse.id);
  const show = !!currentUser && !alreadyMine && count > 0 && count <= 2;
  thinNotice.style.display = show ? 'flex' : 'none';
  if (show) {
    thinNoticeText.textContent = count === 1
      ? 'Энэ хичээлд ганцхан үнэлгээ байна. Таны туршлага бусдад маш их тус болно.'
      : `Энэ хичээлд ${count} үнэлгээ байна. Таны туршлага бусдад тус болно.`;
  }
}

async function loadReviews(courseId) {
  reviewListEl.innerHTML = '<div class="loading"><span class="spinner"></span>Уншиж байна...</div>';
  const res = await apiFetch(`/api/reviews?course_id=${courseId}`);
  if (res.success) {
    renderReviews(res.data);
  } else {
    reviewListEl.innerHTML = `<div class="empty-state">${icon('info', 32)}<p>Ачаалахад алдаа гарлаа: ${escapeHtml(res.error)}</p></div>`;
  }
}

// Each 0-10 score becomes one plain-language verdict. The wording names its
// own subject, so no separate 内容/作业量/给分 label is needed. `tone` is
// whether that verdict is good news for a student — note 作业量 runs the
// other way, since less homework is the good case.
const VERDICTS = {
  content: {
    label: '内容',
    tiers: [
      { max: 3, text: '内容特别差', tone: 'bad' },
      { max: 6, text: '内容中等', tone: 'mid' },
      { max: 10, text: '内容特别好', tone: 'good' },
    ],
  },
  workload: {
    label: '作业量',
    tiers: [
      { max: 3, text: '作业特别少', tone: 'good' },
      { max: 6, text: '作业中等', tone: 'mid' },
      { max: 10, text: '作业特别多', tone: 'bad' },
    ],
  },
  grading: {
    label: '给分',
    tiers: [
      { max: 3, text: '给分特别差', tone: 'bad' },
      { max: 6, text: '给分中等', tone: 'mid' },
      { max: 10, text: '给分特别好', tone: 'good' },
    ],
  },
};

// An unscored dimension renders nothing rather than an empty placeholder.
function verdictChip(kind, score) {
  if (score === null || score === undefined || score === '' || isNaN(score)) return '';
  const spec = VERDICTS[kind];
  const n = Number(score);
  const tier = spec.tiers.find(t => n <= t.max) || spec.tiers[spec.tiers.length - 1];
  // The reviewer's own number sits next to the verdict, so readers see both
  // what they thought and exactly how many points they gave.
  return `<span class="verdict verdict-${tier.tone}" aria-label="${escapeHtml(spec.label)} ${n}/10 — ${tier.text}">${verdictSymbol(tier.tone)}<span>${tier.text}</span><span class="verdict-score">${n}<small>/10</small></span></span>`;
}

// One reviewer's score for one dimension: label, the exact points they gave,
// and the plain-language verdict. Unscored dimensions keep their slot so the
// three tiles always line up.
function scoreTile(kind, score) {
  const spec = VERDICTS[kind];
  if (score === null || score === undefined || score === '' || isNaN(score)) {
    return `<div class="score-tile score-none"><span class="score-label">${spec.label}</span><span class="score-num">—</span><span class="score-verdict">Оноо өгөөгүй</span></div>`;
  }
  const n = Number(score);
  const tier = tierFor(kind, n);
  return `<div class="score-tile tone-${tier.tone}">
      <span class="score-label">${spec.label}</span>
      <span class="score-num">${n}<small>/10</small></span>
      <span class="score-verdict">${verdictSymbol(tier.tone)}${tier.text}</span>
    </div>`;
}

// A shape as well as a colour, so the verdict never depends on colour alone.
function verdictSymbol(tone) {
  const sym = { good: '▲', mid: '●', bad: '▼' }[tone] || '';
  return `<span class="verdict-sym" aria-hidden="true">${sym}</span>`;
}

function tierFor(kind, n) {
  const spec = VERDICTS[kind];
  return spec.tiers.find(t => n <= t.max) || spec.tiers[spec.tiers.length - 1];
}

// Average of each score across this course's reviews, as three tiles.
function renderSummary(reviews) {
  const avg = (key) => {
    const vals = reviews.map(r => r[key]).filter(v => v !== null && v !== undefined && v !== '' && !isNaN(v)).map(Number);
    return vals.length ? vals.reduce((a, b) => a + b, 0) / vals.length : null;
  };
  const tiles = [
    { kind: 'content', key: 'content_score' },
    { kind: 'workload', key: 'workload_score' },
    { kind: 'grading', key: 'grading_score' },
  ].map(({ kind, key }) => ({ kind, value: avg(key) }));
  if (tiles.every(t => t.value === null)) {
    courseSummary.hidden = true;
    return;
  }
  courseSummary.innerHTML = tiles.map(({ kind, value }) => {
    const label = VERDICTS[kind].label;
    if (value === null) {
      return `<div class="stat"><span class="stat-label">${label}</span><span class="stat-value"><span class="stat-num">—</span></span></div>`;
    }
    const tier = tierFor(kind, value);
    return `
  <div class="stat">
    <span class="stat-label">${label}</span>
    <span class="stat-value">
      <span class="stat-num">${value.toFixed(1)}</span>
      <span class="verdict verdict-${tier.tone}">${verdictSymbol(tier.tone)}${tier.text}</span>
    </span>
    <span class="stat-bar" role="img" aria-label="${label} ${value.toFixed(1)} / 10"><span class="tone-${tier.tone}" style="width:${value * 10}%"></span></span>
  </div>`;
  }).join('');
  courseSummary.hidden = false;
}

function renderReviews(reviews) {
  reviewCountEl.textContent = reviews && reviews.length ? `(${reviews.length})` : '';
  if (!reviews || reviews.length === 0) {
    courseSummary.hidden = true;
    reviewListEl.innerHTML = `<div class="empty-state">${icon('inbox', 36)}<p>Одоохондоо үнэлгээ байхгүй байна.</p></div>`;
    return;
  }
  renderSummary(reviews);

  reviewListEl.innerHTML = reviews.map(r => {
    const isAuthor = currentUser && r.author_id === currentUser.id;
    const isAnon = r.is_anonymous === 1 || r.is_anonymous === true;
    const authorName = r.name || 'Нэргүй';
    const infoLines = [
      r.midterm ? { k: '期中考试', v: r.midterm } : null,
      r.final ? { k: '期末考试', v: r.final } : null,
      r.homework ? { k: '作业', v: r.homework } : null,
      r.attendance ? { k: '考勤', v: r.attendance } : null,
      r.groupwork ? { k: '小组作业', v: r.groupwork } : null,
      r.bigassignment ? { k: '大作业', v: r.bigassignment } : null,
      r.grading_ratio ? { k: '分数比例', v: r.grading_ratio } : null,
    ].filter(Boolean);
    return `
  <article class="review-item${r.comment ? '' : ' no-comment'}" data-id="${r.id}">
    <div class="review-head">
      <div class="review-author">
        <span class="avatar" aria-hidden="true">${escapeHtml(isAnon || !r.name ? '?' : [...authorName][0])}</span>
        <div>
          <div class="name">${escapeHtml(authorName)}</div>
          <div class="date">
            ${r.taken_semester ? `<span class="taken-term">${escapeHtml(r.taken_semester)} 上的</span>` : ''}
            <span>${formatDate(r.created_at)}</span>
          </div>
        </div>
      </div>
    </div>
    <div class="review-scores">
      ${scoreTile('content', r.content_score)}
      ${scoreTile('workload', r.workload_score)}
      ${scoreTile('grading', r.grading_score)}
    </div>
    ${r.comment ? `<blockquote class="comment">${escapeHtml(r.comment)}</blockquote>` : ''}
    ${infoLines.length ? `
    <details class="info-details"${r.comment ? '' : ' open'}>
      <summary>${icon('chevronRight', 16)}Шалгалт, даалгаврын мэдээлэл <span class="info-count">(${infoLines.length})</span></summary>
      <div class="info-block">
        ${infoLines.map(l => `<div class="info-item${String(l.v).length > 28 ? ' wide' : ''}"><div class="info-label">${l.k}</div><div class="info-value">${escapeHtml(l.v)}</div></div>`).join('')}
      </div>
    </details>` : ''}
    ${isAuthor ? `
      <div class="actions">
        <button class="btn btn-sm btn-ghost edit-review-btn" data-id="${r.id}">${icon('pencil', 16)} Засах</button>
        <button class="btn btn-sm btn-ghost-danger delete-review-btn" data-id="${r.id}">${icon('trash', 16)} Устгах</button>
      </div>
    ` : ''}
  </article>
`;
  }).join('');

  document.querySelectorAll('.edit-review-btn').forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.stopPropagation();
      const id = parseInt(btn.dataset.id);
      const review = reviews.find(r => r.id === id);
      if (review) {
        fillEditForm(review);
        document.getElementById('writeSection').scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    });
  });

  document.querySelectorAll('.delete-review-btn').forEach(btn => {
    btn.addEventListener('click', async (e) => {
      e.stopPropagation();
      const id = parseInt(btn.dataset.id);
      if (confirm('Энэ үнэлгээг устгахдаа итгэлтэй байна уу?')) {
        await deleteReview(id);
        await loadCourses();
        const refreshed = allCourses.find(c => c.id === currentCourse.id);
        if (refreshed) currentCourse = refreshed;
        await loadReviews(currentCourse.id);
        updateThinNotice();
        // Deleting leaves no review of theirs here, so reset to a blank form.
        editingReviewId = null;
        cancelEditBtn.style.display = 'none';
        submitReviewBtn.innerHTML = `${icon('send', 16)} Үнэлгээ илгээх`;
        setScoreSlider('formContentScore', 5);
        setScoreSlider('formWorkloadScore', 5);
        setScoreSlider('formGradingScore', 5);
        resetToggleFields();
        formGradingRatio.value = '';
        formComment.value = '';
        formAnonymous.checked = false;
        formTakenSemester.value = '';
        setDetailsOpen(false);
      }
    });
  });
}

function fillEditForm(review) {
  editingReviewId = review.id;
  setScoreSlider('formContentScore', review.content_score);
  setScoreSlider('formWorkloadScore', review.workload_score);
  setScoreSlider('formGradingScore', review.grading_score);
  toggleFieldConfig.forEach(({ key, cb, input }) => {
    const val = review[key];
    const has = val !== null && val !== undefined && String(val).trim() !== '';
    setToggle(cb, has);
    document.getElementById(input).value = has ? (String(val).trim() === '有' ? '' : String(val).trim()) : '';
  });
  formGradingRatio.value = review.grading_ratio || '';
  formComment.value = review.comment || '';
  formAnonymous.checked = review.is_anonymous === 1;
  // Only select a stored term if it's still one of the offered options.
  const term = review.taken_semester || '';
  formTakenSemester.value = [...formTakenSemester.options].some(o => o.value === term) ? term : '';
  const hasDetails = ['midterm', 'final', 'homework', 'attendance', 'groupwork', 'bigassignment', 'grading_ratio']
    .some(k => review[k] !== null && review[k] !== undefined && String(review[k]).trim() !== '');
  setDetailsOpen(hasDetails);
  submitReviewBtn.innerHTML = `${icon('pencil', 16)} Үнэлгээг шинэчлэх`;
  cancelEditBtn.style.display = 'inline-flex';
}

async function submitReview() {
  if (!currentUser) {
    showToast('Эхлээд нэвтэрнэ үү!', 'error');
    return;
  }
  if (!currentCourse) return;

  const data = {
    course_id: currentCourse.id,
    content_score: parseFloat(formContentScore.value),
    workload_score: parseFloat(formWorkloadScore.value),
    grading_score: parseFloat(formGradingScore.value),
    midterm: getToggleValue('hasMidterm', 'formMidterm'),
    final: getToggleValue('hasFinal', 'formFinal'),
    homework: getToggleValue('hasHomework', 'formHomework'),
    attendance: getToggleValue('hasAttendance', 'formAttendance'),
    groupwork: getToggleValue('hasGroupwork', 'formGroupwork'),
    bigassignment: getToggleValue('hasBigassignment', 'formBigassignment'),
    grading_ratio: formGradingRatio.value.trim() || null,
    comment: formComment.value.trim() || null,
    is_anonymous: formAnonymous.checked,
    taken_semester: formTakenSemester.value || null,
  };

  const wasEditing = !!editingReviewId;
  setBusy(submitReviewBtn, true, wasEditing ? 'Шинэчилж байна...' : 'Илгээж байна...');
  try {
    let res;
    if (editingReviewId) {
      res = await apiFetch(`/api/reviews/${editingReviewId}`, {
        method: 'PUT',
        body: JSON.stringify(data),
      });
    } else {
      res = await apiFetch('/api/reviews', {
        method: 'POST',
        body: JSON.stringify(data),
      });
    }

    if (res.success) {
      // res.data.updated means the API found an existing review and
      // updated it rather than adding a second one.
      const wasUpdate = wasEditing || (res.data && res.data.updated);
      showToast(wasUpdate ? 'Үнэлгээ шинэчлэгдлээ!' : 'Үнэлгээ илгээгдлээ!', 'success');
      editingReviewId = null;
      // Refreshes review counts, averages and the "already reviewed" marks.
      await loadCourses();
      // currentCourse is a snapshot from when the modal opened; re-point it
      // at the refreshed row so review_count is current.
      const refreshed = allCourses.find(c => c.id === currentCourse.id);
      if (refreshed) currentCourse = refreshed;
      await loadReviews(currentCourse.id);
      updateThinNotice();

      // There is now exactly one review by this user here, so stay on it in
      // edit mode instead of offering a blank form that would look like an
      // invitation to write a second one.
      const mine = myReviews.get(currentCourse.id);
      if (mine) {
        fillEditForm(mine);
        // The button is mid-busy-state; set the label it restores to.
        submitReviewBtn.dataset.idleHtml = `${icon('pencil', 16)} Үнэлгээг шинэчлэх`;
      } else {
        cancelEditBtn.style.display = 'none';
        submitReviewBtn.dataset.idleHtml = `${icon('send', 16)} Үнэлгээ илгээх`;
        setScoreSlider('formContentScore', 5);
        setScoreSlider('formWorkloadScore', 5);
        setScoreSlider('formGradingScore', 5);
        resetToggleFields();
        formGradingRatio.value = '';
        formComment.value = '';
        formAnonymous.checked = false;
        formTakenSemester.value = '';
        setDetailsOpen(false);
      }
    } else {
      showToast('Ажиллагаа амжилтгүй: ' + res.error, 'error');
    }
  } catch (e) {
    showToast('Сүлжээний алдаа: ' + e.message, 'error');
  } finally {
    setBusy(submitReviewBtn, false);
  }
}

async function deleteReview(id) {
  const res = await apiFetch(`/api/reviews/${id}`, { method: 'DELETE' });
  if (!res.success) {
    showToast('Устгахад алдаа гарлаа: ' + res.error, 'error');
  }
}

// ===== Auth =====
// Returning students only ever see email → code. Name and status are asked
// once, when the API reports that this email has no account yet.
const profileFields = document.getElementById('profileFields');

function setProfileFieldsVisible(show) {
  profileFields.hidden = !show;
  loginSubmitBtn.textContent = show ? 'Бүртгүүлэх' : 'Нэвтрэх';
}

function openLoginModal() {
  loginModalOverlay.classList.add('active');
  loginStep1.style.display = 'block';
  loginStep2.style.display = 'none';
  loginEmail.value = '';
  loginCode.value = '';
  loginName.value = '';
  loginRole.value = 'undergrad';
  setProfileFieldsVisible(false);
  loginEmail.focus();
}
loginBtn.addEventListener('click', openLoginModal);

// The field holds only the part before the domain. A value that already
// contains '@' is passed through as-is, so a pasted full address (or a
// different domain, if the whitelist ever widens) still works.
function buildLoginEmail() {
  const raw = loginEmail.value.trim().toLowerCase();
  if (!raw) return '';
  return raw.includes('@') ? raw : `${raw}@${SCHOOL_EMAIL_DOMAIN}`;
}

sendCodeBtn.addEventListener('click', async () => {
  const email = buildLoginEmail();
  if (!email || email.startsWith('@') || !email.includes('@')) {
    showToast('Оюутны дугаараа оруулна уу', 'error');
    loginEmail.focus();
    return;
  }
  sendCodeBtn.disabled = true;
  sendCodeBtn.textContent = 'Илгээж байна...';
  try {
    const res = await apiFetch('/api/auth/request-code', {
      method: 'POST',
      body: JSON.stringify({ email }),
    });
    if (res.success) {
      showToast('Баталгаажуулах код илгээгдлээ!', 'success');
      loginStep1.style.display = 'none';
      loginStep2.style.display = 'block';
      loginCode.focus();
    } else {
      showToast('Алдаа: ' + res.error, 'error');
    }
  } catch (e) {
    showToast('Сүлжээний алдаа: ' + e.message, 'error');
  } finally {
    sendCodeBtn.disabled = false;
    sendCodeBtn.textContent = 'Баталгаажуулах код авах';
  }
});

loginSubmitBtn.addEventListener('click', async () => {
  const email = buildLoginEmail();
  const code = loginCode.value.trim();
  const registering = !profileFields.hidden;
  const name = loginName.value.trim();
  const role = loginRole.value;

  if (!email || !code) {
    showToast('Имэйл болон код оруулна уу', 'error');
    return;
  }
  if (code.length !== 6) {
    showToast('Код 6 оронтой байх ёстой', 'error');
    return;
  }
  if (registering && !name) {
    showToast('Нэрээ оруулна уу', 'error');
    loginName.focus();
    return;
  }

  setBusy(loginSubmitBtn, true, registering ? 'Бүртгэж байна...' : 'Нэвтэрч байна...');
  try {
    const res = await apiFetch('/api/auth/verify-code', {
      method: 'POST',
      // Name and status are sent only when registering; a returning student's
      // saved profile is never overwritten by a login.
      body: JSON.stringify(registering ? { email, code, name, role } : { email, code }),
    });
    if (!res.success && res.needs_profile) {
      // Correct code, new email: ask for the profile once. The code stays
      // valid, so pressing Бүртгүүлэх reuses it.
      setBusy(loginSubmitBtn, false);
      setProfileFieldsVisible(true);
      loginName.focus();
      return;
    }
    if (res.success) {
      setToken(res.token);
      setStoredUser(res.user);
      currentUser = res.user;
      updateUI();
      loadCourses();
      loginModalOverlay.classList.remove('active');
      showToast('Амжилттай нэвтэрлээ! Тавтай морил ' + currentUser.name, 'success');
    } else {
      showToast('Алдаа: ' + res.error, 'error');
    }
  } catch (e) {
    showToast('Сүлжээний алдаа: ' + e.message, 'error');
  } finally {
    setBusy(loginSubmitBtn, false);
  }
});

backToStep1.addEventListener('click', (e) => {
  e.preventDefault();
  loginStep1.style.display = 'block';
  loginStep2.style.display = 'none';
  setProfileFieldsVisible(false);
});

loginModalCloseBtn.addEventListener('click', () => {
  loginModalOverlay.classList.remove('active');
});
loginModalOverlay.addEventListener('click', (e) => {
  if (e.target === loginModalOverlay) loginModalOverlay.classList.remove('active');
});

logoutBtn.addEventListener('click', () => {
  clearToken();
  clearStoredUser();
  currentUser = null;
  updateUI();
  loadCourses();
});

function updateUI() {
  // Hidden outright when logged out — an empty .role-badge still paints its
  // background and border, which showed up as a stray blank pill.
  userInfo.style.display = currentUser ? 'flex' : 'none';
  if (currentUser) {
    loginBtn.style.display = 'none';
    logoutBtn.style.display = 'inline-flex';
    userName.textContent = currentUser.name || currentUser.email;
    userRole.textContent = currentUser.role === 'undergrad' ? 'Бакалавр' :
      currentUser.role === 'prep' ? 'Бэлтгэл' : 'Магистр/Доктор';
  } else {
    loginBtn.style.display = 'inline-flex';
    logoutBtn.style.display = 'none';
    userName.textContent = '';
    userRole.textContent = '';
  }
  updateReviewFormVisibility();
}

// ===== Add course =====
function openAddCourse() {
  if (!currentUser) {
    showToast('Хичээл нэмэхийн тулд эхлээд нэвтэрнэ үү', 'error');
    openLoginModal();
    return;
  }
  newCourseName.value = '';
  newCourseTeacher.value = '';
  newCourseCredits.value = '';
  newCourseSemester.value = '秋季';
  // Fixed list — the same one the API accepts.
  newCourseCategory.innerHTML = COURSE_CATEGORIES.map(c => c.subs
    ? `<optgroup label="${escapeHtml(c.label)}">${c.subs.map(s => `<option value="${escapeHtml(s)}">${escapeHtml(s)}</option>`).join('')}</optgroup>`
    : `<option value="${escapeHtml(c.value)}">${escapeHtml(c.label)}</option>`
  ).join('');
  // Start on whatever the list is filtered to, since that's usually what
  // the student is looking for.
  newCourseCategory.value = activeSubCategory || (activeCategory === '通识课' ? '通识课一' : activeCategory) || DEFAULT_CATEGORY;
  addCourseOverlay.classList.add('active');
  newCourseName.focus();
}

async function submitNewCourse() {
  const name_cn = newCourseName.value.trim();
  if (!name_cn) {
    showToast('Хичээлийн нэр оруулна уу', 'error');
    newCourseName.focus();
    return;
  }
  const teacher = newCourseTeacher.value.trim();
  // Catch the obvious duplicate before a round trip; the API checks too.
  const existing = allCourses.find(c =>
    (c.name_cn || '').trim().toLowerCase() === name_cn.toLowerCase() &&
    (c.teacher || '').trim().toLowerCase() === teacher.toLowerCase()
  );
  if (existing) {
    showToast('Энэ хичээл жагсаалтад аль хэдийн байна', 'error');
    addCourseOverlay.classList.remove('active');
    openCourseDetail(existing);
    return;
  }

  setBusy(submitCourseBtn, true, 'Нэмж байна...');
  try {
    const res = await apiFetch('/api/courses', {
      method: 'POST',
      body: JSON.stringify({
        name_cn,
        teacher,
        credits: newCourseCredits.value,
        semester: newCourseSemester.value,
        category: newCourseCategory.value,
      }),
    });
    if (res.success) {
      showToast('Хичээл нэмэгдлээ!', 'success');
      addCourseOverlay.classList.remove('active');
      await loadCourses();
      const added = allCourses.find(c => c.id === res.data.id);
      if (added) openCourseDetail(added);
    } else {
      showToast(res.error || 'Нэмэхэд алдаа гарлаа', 'error');
    }
  } catch (e) {
    showToast('Сүлжээний алдаа: ' + e.message, 'error');
  } finally {
    setBusy(submitCourseBtn, false);
  }
}

addCourseBtn.addEventListener('click', openAddCourse);
submitCourseBtn.addEventListener('click', submitNewCourse);
addCourseCloseBtn.addEventListener('click', () => addCourseOverlay.classList.remove('active'));
addCourseOverlay.addEventListener('click', (e) => {
  if (e.target === addCourseOverlay) addCourseOverlay.classList.remove('active');
});
newCourseName.addEventListener('keydown', (e) => {
  if (e.key === 'Enter') submitNewCourse();
});

promptLoginBtn.addEventListener('click', () => {
  openLoginModal();
});

// Esc closes the topmost open modal only (login can sit above a course)
document.addEventListener('keydown', (e) => {
  if (e.key !== 'Escape') return;
  const topMost = [addCourseOverlay, loginModalOverlay, modalOverlay]
    .find(overlay => overlay.classList.contains('active'));
  if (topMost === modalOverlay) closeCourse();
  else if (topMost) topMost.classList.remove('active');
});

// ===== Modal close handlers =====
modalCloseBtn.addEventListener('click', closeCourse);
modalOverlay.addEventListener('click', (e) => {
  if (e.target === modalOverlay) closeCourse();
});
document.getElementById('jumpToFormBtn').addEventListener('click', () => {
  document.getElementById('writeSection').scrollIntoView({ behavior: 'smooth', block: 'start' });
});

// Lock the page behind any open modal so only the modal scrolls.
const overlays = [modalOverlay, loginModalOverlay, addCourseOverlay];
const syncScrollLock = () => {
  document.body.classList.toggle('modal-open', overlays.some(o => o.classList.contains('active')));
};
overlays.forEach(o => new MutationObserver(syncScrollLock).observe(o, { attributes: true, attributeFilter: ['class'] }));

cancelEditBtn.addEventListener('click', () => {
  editingReviewId = null;
  cancelEditBtn.style.display = 'none';
  submitReviewBtn.innerHTML = `${icon('send', 16)} Үнэлгээ илгээх`;
  setScoreSlider('formContentScore', 5);
  setScoreSlider('formWorkloadScore', 5);
  setScoreSlider('formGradingScore', 5);
  resetToggleFields();
  formGradingRatio.value = '';
  formComment.value = '';
  formAnonymous.checked = false;
  formTakenSemester.value = '';
  setDetailsOpen(false);
});

submitReviewBtn.addEventListener('click', submitReview);

// ===== Startup =====
console.log(
  '%cМонгол оюутнуудын хичээлийн үнэлгээ%c\n' +
  'Battugs Zuchi (族池) · 2026\n' +
  'Эхлээд ганц асуулга байсан. → /humans.txt',
  'font-size:14px;font-weight:700;color:#2f6f6a',
  'font-size:12px;color:#6b7280'
);

// One source of truth for the domain shown next to the login field.
document.getElementById('emailSuffix').textContent = '@' + SCHOOL_EMAIL_DOMAIN;

loginEmail.addEventListener('keydown', (e) => {
  if (e.key === 'Enter') sendCodeBtn.click();
});
loginCode.addEventListener('keydown', (e) => {
  if (e.key === 'Enter') loginSubmitBtn.click();
});
loginName.addEventListener('keydown', (e) => {
  if (e.key === 'Enter') loginSubmitBtn.click();
});

const storedUser = getStoredUser();
const storedToken = getToken();
if (storedUser && storedToken) {
  currentUser = storedUser;
  updateUI();
}
landedOnCourse = courseIdFromHash() !== null;
loadCourses().then(routeFromHash);
updateUI();
