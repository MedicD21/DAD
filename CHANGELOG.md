# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-27

### Added
- Initial release of Dead App Detector
- Backend REST API with Node.js/Express
- iOS native app with SwiftUI
- Comprehensive signal collection system
  - Website signals (domain age, reachability, sitemap, blog, updates)
  - Engineering signals (GitHub repo, commits, issues)
  - Business signals (support, careers, social, legal)
- Weighted scoring algorithm (0-100 scale)
- In-memory caching with configurable TTL
- Rate limiting protection
- Input validation with Joi
- Security hardening with Helmet.js
- CORS configuration
- Comprehensive error handling
- Docker and Docker Compose support
- GitHub Actions CI/CD pipeline
- Automated testing with Jest
- ESLint and Prettier integration
- Health check endpoints
- API documentation endpoint
- iOS history storage
- Share functionality
- Production-ready configuration

### Security
- Rate limiting on all endpoints
- Request size limits
- Security headers via Helmet.js
- Input sanitization
- Error message sanitization
- Non-root Docker user

### Documentation
- Comprehensive README
- API documentation
- Contributing guidelines
- Security policy
- Code of conduct
- Backend-specific README
- iOS-specific README
- Makefile for common tasks

### Infrastructure
- Dockerfile for containerization
- Docker Compose for orchestration
- GitHub Actions workflows
- Environment configuration templates
- Editor configuration files
- Git ignore rules

## [Unreleased]

### Planned Features
- PostgreSQL database integration
- User authentication system
- Subscription/payment system
- Chrome extension
- Email notifications
- Comparative analysis
- Advanced analytics dashboard
- API rate limiting per user
- Usage tracking
- Historical trend analysis
