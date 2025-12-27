# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting a Vulnerability

We take the security of Dead App Detector seriously. If you believe you have found a security vulnerability, please report it to us responsibly.

### How to Report

**Please do NOT report security vulnerabilities through public GitHub issues.**

Instead, please report them via email to: [your-email@example.com]

Include the following information:

- Type of vulnerability
- Full paths of affected source file(s)
- Location of the affected code (tag/branch/commit or direct URL)
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the vulnerability

### What to Expect

- We will acknowledge your email within 48 hours
- We will provide a more detailed response within 7 days
- We will keep you informed of the progress towards a fix
- We may ask for additional information or guidance

## Security Best Practices

### For Developers

1. **Environment Variables**
   - Never commit `.env` files
   - Use strong, unique GitHub tokens
   - Rotate tokens regularly

2. **Dependencies**
   - Run `npm audit` regularly
   - Keep dependencies up to date
   - Review security advisories

3. **API Security**
   - Rate limiting is enabled by default
   - Validate all inputs
   - Use HTTPS in production

4. **Docker Security**
   - Run containers as non-root user
   - Keep base images updated
   - Scan images for vulnerabilities

### For Deployment

1. **Production Environment**
   - Set `NODE_ENV=production`
   - Use strong, unique secrets
   - Enable HTTPS/TLS
   - Configure firewall rules

2. **Monitoring**
   - Monitor for unusual traffic patterns
   - Set up alerts for errors
   - Review logs regularly

3. **Updates**
   - Keep Node.js updated
   - Update dependencies monthly
   - Apply security patches promptly

## Known Security Considerations

### Rate Limiting

The API includes rate limiting to prevent abuse:
- General API: 100 requests per 15 minutes
- Analysis endpoint: 20 requests per 15 minutes

### Input Validation

All user inputs are validated using Joi schemas to prevent:
- SQL injection
- XSS attacks
- Command injection

### CORS

CORS is configured to accept requests from trusted origins only. Configure `CORS_ORIGINS` in your `.env` file.

### Helmet.js

Security headers are set using Helmet.js to protect against common web vulnerabilities.

## Dependency Security

We use automated tools to monitor dependencies:
- GitHub Dependabot
- npm audit
- Trivy scanner (in CI/CD)

## Disclosure Policy

- We will work with you to understand and fix the vulnerability
- We request that you give us reasonable time to fix the issue before public disclosure
- We will credit you in the release notes (unless you prefer to remain anonymous)

## Comments

If you have suggestions for improving this security policy, please open an issue or submit a pull request.
