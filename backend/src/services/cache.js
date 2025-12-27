import NodeCache from 'node-cache';

const cache = new NodeCache({
  stdTTL: parseInt(process.env.CACHE_TTL) || 86400, // 24 hours
  checkperiod: 600, // Cleanup every 10 minutes
});

export function getCache(key) {
  return cache.get(key);
}

export function setCache(key, value) {
  return cache.set(key, value);
}

export function deleteCache(key) {
  return cache.del(key);
}
