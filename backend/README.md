# Dead App Detector - Backend API

A robust REST API for analyzing SaaS product health and maintenance status.

## Features

- 🔍 Comprehensive signal collection (website, engineering, business)
- ⚡ In-memory caching with configurable TTL
- 🛡️ Rate limiting and security hardening
- ✅ Input validation with Joi
- 🐳 Docker support for easy deployment
- 📊 Health monitoring endpoints
- 🧪 Comprehensive test coverage
- 🔒 Security best practices

## Quick Start

### Local Development

```bash
# Install dependencies
npm install

# Configure environment
cp .env.example .env
# Edit .env and add your GitHub token (optional but recommended)

# Start development server
npm run dev
```

The API will be available at `http://localhost:3000`

### Docker

```bash
# Build and run
docker-compose up -d

# View logs
docker-compose logs -f

# Stop
docker-compose down
```

## API Endpoints

### Health Check
```
GET /health
```

### Analyze SaaS Product
```
POST /api/v1/analyze
Content-Type: application/json

{
  "url": "https://example.com"
}
```

### API Documentation
```
GET /api/v1/docs
```

## Testing

```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# Generate coverage report
npm run test:coverage
```

## Code Quality

```bash
# Lint code
npm run lint

# Fix linting issues
npm run lint:fix

# Format code
npm run format

# Check formatting
npm run format:check
```

## Environment Variables

See `.env.example` for all available configuration options.

Required:
- None (all have defaults)

Recommended:
- `GITHUB_TOKEN` - GitHub personal access token for higher API rate limits

## Architecture

```
backend/
├── src/
│   ├── collectors/        # Signal collection modules
│   ├── middleware/        # Express middleware
│   ├── routes/            # API route handlers
│   ├── services/          # Business logic
│   ├── utils/             # Utility functions
│   └── index.js           # Application entry point
├── .env.example           # Environment template
├── jest.config.js         # Test configuration
└── package.json
```

## Signal Categories

### Website Signals (30% weight)
- Domain age
- Website reachability
- Sitemap presence
- Blog/news section
- Last content update

### Engineering Signals (40% weight)
- GitHub repository detection
- Last commit date
- Commit frequency
- Open issues count

### Business Signals (30% weight)
- Support contact information
- Careers page
- Social media presence
- Legal documentation

## Performance

- In-memory caching (24-hour TTL by default)
- Request timeout: 30 seconds
- Rate limits: 100 requests/15min (API), 20 requests/15min (analyze)
- Concurrent signal collection

## Security

- Helmet.js security headers
- CORS configuration
- Rate limiting
- Input validation
- Request size limits (10kb)
- Graceful error handling

## Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for development guidelines.

## License

See [LICENSE](../LICENSE) for license information.
