import { normalizeUrl } from './urlParser.js';

describe('normalizeUrl', () => {
  it('should normalize URLs with trailing slashes', () => {
    expect(normalizeUrl('https://example.com/')).toBe('https://example.com');
  });

  it('should normalize URLs without protocol', () => {
    const result = normalizeUrl('example.com');
    expect(result).toMatch(/^https?:\/\/example\.com$/);
  });

  it('should handle URLs with paths', () => {
    expect(normalizeUrl('https://example.com/path')).toBe('https://example.com/path');
  });

  it('should handle URLs with query parameters', () => {
    const result = normalizeUrl('https://example.com?param=value');
    expect(result).toContain('example.com');
  });
});
