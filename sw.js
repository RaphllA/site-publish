// Legacy root-scope service worker cleanup.
// Root app moved to /twi/, so this worker only removes stale caches and unregisters itself.
const LEGACY_CACHE_PREFIX = 'twitter-simulator-static-';

self.addEventListener('install', (event) => {
  event.waitUntil(self.skipWaiting());
});

self.addEventListener('activate', (event) => {
  event.waitUntil((async () => {
    try {
      const keys = await caches.keys();
      await Promise.all(
        keys
          .filter((key) => key.startsWith(LEGACY_CACHE_PREFIX))
          .map((key) => caches.delete(key))
      );
    } catch (_) {
      // Ignore cache cleanup errors.
    }

    try {
      await self.registration.unregister();
    } catch (_) {
      // Ignore unregister failures.
    }

    const clients = await self.clients.matchAll({ includeUncontrolled: true, type: 'window' });
    for (const client of clients) {
      try {
        client.navigate(client.url);
      } catch (_) {
        // Ignore reload failures.
      }
    }
  })());
});