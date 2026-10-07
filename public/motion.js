// Motion helpers that sit on top of app.js without changing it.
//  1. Character pop: each newly typed character springs into place.
//  2. Small "bump" animations when a number or 有/无 caption changes.
//  3. A short un-check bounce for checkboxes.
// Nothing here runs for people who ask their system for reduced motion.
(function () {
  'use strict';
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

  // ---------- 1. Character pop ----------
  // The real <input> keeps doing everything (caret, selection, IME, autofill).
  // While it has focus its own text is made transparent and an identical copy
  // ("mirror") is drawn on top, where new characters can be animated.
  // When it loses focus the mirror is hidden and the input shows its text again.
  const POP_MS = 220;        // how long a character counts as "new"
  const STAGGER_MS = 18;     // spread for pasted text
  const MAX_POPS = 40;       // longer pastes just appear

  function enhance(input) {
    if (input.dataset.tp) return;
    input.dataset.tp = '1';
    const multi = input.tagName === 'TEXTAREA';

    const wrap = document.createElement('span');
    wrap.className = 'tp-wrap';
    input.parentNode.insertBefore(wrap, input);
    wrap.appendChild(input);
    input.classList.add('tp-input');

    const mirror = document.createElement('div');
    mirror.className = 'tp-mirror ' + (multi ? 'tp-multi' : 'tp-single');
    mirror.setAttribute('aria-hidden', 'true');
    wrap.appendChild(mirror);

    let chars = [];   // current characters (code points)
    let stamps = [];  // when each one was typed (0 = old)
    let raf = 0;
    let lastScroll = '';

    function layout() {
      const cs = getComputedStyle(input);
      const st = mirror.style;
      ['fontFamily', 'fontSize', 'fontWeight', 'fontStyle', 'letterSpacing',
       'textTransform', 'textAlign', 'textIndent', 'wordSpacing'].forEach(k => { st[k] = cs[k]; });
      st.left = (input.offsetLeft + input.clientLeft) + 'px';
      st.top = (input.offsetTop + input.clientTop) + 'px';
      st.width = input.clientWidth + 'px';
      st.height = input.clientHeight + 'px';
      st.paddingLeft = cs.paddingLeft;
      st.paddingRight = cs.paddingRight;
      if (multi) {
        st.paddingTop = cs.paddingTop;
        st.paddingBottom = cs.paddingBottom;
        st.lineHeight = cs.lineHeight;
      } else {
        // An input centres its single line in the content box; do the same.
        const inner = input.clientHeight - parseFloat(cs.paddingTop) - parseFloat(cs.paddingBottom);
        st.lineHeight = inner + 'px';
        st.paddingTop = cs.paddingTop;
        st.paddingBottom = '0';
      }
    }

    function render(now) {
      mirror.textContent = '';
      let run = '';
      for (let i = 0; i < chars.length; i++) {
        const age = now - stamps[i];
        if (stamps[i] && age < POP_MS) {
          if (run) { mirror.appendChild(document.createTextNode(run)); run = ''; }
          const s = document.createElement('span');
          s.className = 'tp-c';
          s.textContent = chars[i];
          // A negative delay continues an animation that already started,
          // so re-rendering on the next keystroke doesn't restart it.
          s.style.animationDelay = (-age) + 'ms';
          mirror.appendChild(s);
        } else {
          run += chars[i];
        }
      }
      // A trailing newline needs something after it to get its own line.
      if (multi && chars[chars.length - 1] === '\n') run += ' ';
      if (run) mirror.appendChild(document.createTextNode(run));
    }

    function update(animate) {
      const next = Array.from(input.value);
      const now = performance.now();
      let p = 0;
      while (p < chars.length && p < next.length && chars[p] === next[p]) p++;
      let s = 0;
      while (s < chars.length - p && s < next.length - p &&
             chars[chars.length - 1 - s] === next[next.length - 1 - s]) s++;
      const added = next.length - p - s;
      const fresh = [];
      for (let i = 0; i < added; i++) {
        fresh.push(animate && added <= MAX_POPS && next[p + i] !== '\n' ? now + i * STAGGER_MS : 0);
      }
      stamps = stamps.slice(0, p).concat(fresh, stamps.slice(chars.length - s));
      chars = next;
      render(now);
    }

    function syncScroll() {
      const key = input.scrollLeft + ',' + input.scrollTop + ',' + input.clientWidth + ',' + input.clientHeight;
      if (key !== lastScroll) {
        lastScroll = key;
        layout();
        mirror.scrollLeft = input.scrollLeft;
        mirror.scrollTop = input.scrollTop;
      }
    }

    function tick() {
      // Catches value changes made by code (not by typing) while focused.
      if (input.value.length !== chars.length || Array.from(input.value).join('') !== chars.join('')) update(false);
      syncScroll();
      raf = requestAnimationFrame(tick);
    }

    input.addEventListener('focus', () => {
      chars = []; stamps = [];
      layout();
      update(false);
      wrap.classList.add('tp-live');
      lastScroll = '';
      syncScroll();
      cancelAnimationFrame(raf);
      raf = requestAnimationFrame(tick);
    });
    input.addEventListener('blur', () => {
      cancelAnimationFrame(raf);
      wrap.classList.remove('tp-live');
    });
    input.addEventListener('input', () => {
      update(true);
      lastScroll = '';
      syncScroll();
    });
    input.addEventListener('scroll', syncScroll);
  }

  document.querySelectorAll('input[type="text"], input[type="search"], textarea').forEach(enhance);

  // ---------- 2. Bump numbers / captions when they change ----------
  function bumpOnChange(el) {
    new MutationObserver(() => {
      el.classList.remove('bump');
      void el.offsetWidth; // restart the animation
      el.classList.add('bump');
    }).observe(el, { childList: true, characterData: true, subtree: true });
  }
  document.querySelectorAll('.slider-value, .switch-caption').forEach(bumpOnChange);

  // ---------- 3. Checkbox un-check bounce ----------
  document.querySelectorAll('.checkbox-group input[type="checkbox"]').forEach(cb => {
    cb.addEventListener('change', () => {
      cb.classList.remove('was-checked');
      if (!cb.checked) { void cb.offsetWidth; cb.classList.add('was-checked'); }
    });
  });
})();
