/* MigrateWP — small progressive enhancements. No dependencies. */
(function () {
  'use strict';

  /* --- Theme toggle -------------------------------------------------
     The initial theme is applied by an inline snippet in <head> so the
     page never flashes. This only handles the click. */
  var toggle = document.getElementById('theme-toggle');
  if (toggle) {
    toggle.addEventListener('click', function () {
      var root = document.documentElement;
      var systemDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      var current = root.getAttribute('data-theme') || (systemDark ? 'dark' : 'light');
      var next = current === 'dark' ? 'light' : 'dark';
      root.setAttribute('data-theme', next);
      toggle.setAttribute('aria-label', next === 'dark' ? 'Switch to light theme' : 'Switch to dark theme');
      try { localStorage.setItem('mwp-theme', next); } catch (e) { /* private mode */ }
    });
  }

  /* --- Mobile navigation -------------------------------------------- */
  var navToggle = document.getElementById('nav-toggle');
  var nav = document.getElementById('primary-nav');
  if (navToggle && nav) {
    var setOpen = function (open) {
      nav.hidden = !open;
      navToggle.setAttribute('aria-expanded', String(open));
    };
    // Collapsed by default on small screens only.
    var mq = window.matchMedia('(max-width: 860px)');
    var sync = function () { setOpen(!mq.matches); };
    sync();
    mq.addEventListener ? mq.addEventListener('change', sync) : mq.addListener(sync);

    navToggle.addEventListener('click', function () {
      setOpen(nav.hidden);
    });
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && mq.matches && !nav.hidden) {
        setOpen(false);
        navToggle.focus();
      }
    });
  }

  /* --- Copy buttons on code blocks ----------------------------------- */
  var blocks = document.querySelectorAll('.code');
  Array.prototype.forEach.call(blocks, function (block) {
    var pre = block.querySelector('pre');
    if (!pre) return;

    var btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'copy-btn';
    btn.textContent = 'copy';
    btn.setAttribute('aria-label', 'Copy code to clipboard');

    btn.addEventListener('click', function () {
      // Prompt characters are marked up with .p and excluded from the copy.
      var clone = pre.cloneNode(true);
      Array.prototype.forEach.call(clone.querySelectorAll('.p'), function (el) {
        el.parentNode.removeChild(el);
      });
      var text = clone.textContent.replace(/^[ \t]+/gm, function (m) { return m; }).trim();

      var done = function (ok) {
        btn.textContent = ok ? 'copied' : 'press ⌘C';
        btn.setAttribute('data-copied', String(ok));
        setTimeout(function () {
          btn.textContent = 'copy';
          btn.removeAttribute('data-copied');
        }, 1800);
      };

      if (navigator.clipboard && window.isSecureContext) {
        navigator.clipboard.writeText(text).then(function () { done(true); }, function () { done(false); });
      } else {
        done(false);
      }
    });

    block.appendChild(btn);
  });
})();
