const CACHE_NAME = 'clb-site-v1';
const OFFLINE_URL = '/index.html';
const ASSETS = [
  '/',
  '/index.html',
  '/styles.css',
  '/manifest.json'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => cache.addAll(ASSETS))
  );
  self.skipWaiting();
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys => Promise.all(
      keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k))
    ))
  );
  self.clients.claim();
});

self.addEventListener('fetch', event => {
  const req = event.request;
  // prefer cache-first for navigation and assets
  if(req.mode === 'navigate' || req.destination === 'document'){
    event.respondWith(
      fetch(req).catch(()=> caches.match(OFFLINE_URL))
    );
    return;
  }

  if(req.method !== 'GET') return;

  event.respondWith(
    caches.match(req).then(cached => cached || fetch(req).then(res => {
      // put a copy into cache
      const copy = res.clone();
      caches.open(CACHE_NAME).then(cache => cache.put(req, copy));
      return res;
    }).catch(()=> cached))
  );
});
