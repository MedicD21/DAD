export function normalizeUrl(urlString) {
  try {
    const url = new URL(urlString.startsWith('http') ? urlString : `https://${urlString}`);
    return `${url.protocol}//${url.hostname}`;
  } catch (error) {
    throw new Error('Invalid URL format');
  }
}

export function extractDomain(urlString) {
  try {
    const url = new URL(urlString);
    return url.hostname.replace('www.', '');
  } catch (error) {
    return null;
  }
}
