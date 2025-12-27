import { normalizeUrl } from './urlParser.js';

describe('normalizeUrl', () => {
  it('should normalize URLs with trailing slashes', () => {
    expect(normalizeUrl('https://example.com/')).toBe('https://example.com');
  });

  it('should normalize URLs without protocol', () => {
    const result = normalizeUrl('example.com');
    expect(result).toBe('https://example.com');
  });

  it('should strip paths from URLs', () => {
    // normalizeUrl only returns protocol + hostname
    expect(normalizeUrl('https://example.com/path')).toBe('https://example.com');
  });

  it('should strip query parameters from URLs', () => {
    // normalizeUrl only returns protocol + hostname
    const result = normalizeUrl('https://example.com?param=value');
    expect(result).toBe('https://example.com');
  });

  it('should handle www subdomain', () => {
    expect(normalizeUrl('https://www.example.com')).toBe('https://www.example.com');
  });
});
