(() => {
  'use strict';

  const isGoogleNavigation =
    location.hostname.includes('google.') &&
    (
      location.pathname === '/' ||
      location.pathname.startsWith('/search') ||
      location.pathname.startsWith('/imghp') ||
      location.pathname.startsWith('/imgres')
    );

  if (isGoogleNavigation) {return;}

  const DARK_BG = '#1a1c23';
  const DARK_TEXT = '#e6e6e6';
  const BORDER = '#2a2d3a';

  const LUMA_LIGHT = 0.75;

  const IGNORE = new Set([
    'VIDEO','IMG','PICTURE',
    'CANVAS','SVG','IFRAME',
    'EMBED','OBJECT'
  ]);

  function luminance(r, g, b) {
    return (0.2126*r + 0.7152*g + 0.0722*b) / 255;
  }

  function parseRGB(color) {
    const m = color.match(/\d+/g);
    if (!m || m.length < 3) return null;
    return m.slice(0,3).map(Number);
  }

  function isVisible(el) {
    const s = getComputedStyle(el);
    return s.display !== 'none' && s.visibility !== 'hidden';
  }

  function process(el) {
    if (IGNORE.has(el.tagName)) return;
    if (el.dataset.darkProcessed) return;
    if (!isVisible(el)) return;

    const bg = getComputedStyle(el).backgroundColor;
    if (!bg || bg === 'transparent') return;

    const rgb = parseRGB(bg);
    if (!rgb) return;

    if (luminance(...rgb) > LUMA_LIGHT) {
      el.style.backgroundColor = DARK_BG;
      el.style.color = DARK_TEXT;
      el.style.borderColor ||= BORDER;
      el.dataset.darkProcessed = 'true';
    }
  }

  function run(root = document.body) {
    root.querySelectorAll('*').forEach(process);
  }

  run();

  new MutationObserver(muts => {
    muts.forEach(m =>
      m.addedNodes.forEach(n => {
        if (n.nodeType === 1) run(n);
      })
    );
  }).observe(document.documentElement, {
    subtree: true,
    childList: true
  });

})();
