# 🔍 Dead App Detector

> A production-ready iOS app and REST API that analyzes whether SaaS products are actively maintained.

[![CI/CD](https://github.com/yourusername/dead-app-detector/workflows/CI%2FCD%20Pipeline/badge.svg)](https://github.com/yourusername/dead-app-detector/actions)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Node Version](https://img.shields.io/badge/node-%3E%3D18.0.0-brightgreen)](package.json)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

**Dead App Detector** helps you evaluate the health and maintenance status of SaaS products by analyzing multiple signals across website presence, engineering activity, and business indicators.

## ✨ Features

- 🔍 **Comprehensive Analysis** - Evaluates 15+ signals across multiple categories
- 📊 **Smart Scoring** - Weighted algorithm produces reliable health scores (0-100)
- ⚡ **Fast & Cached** - Results cached for 24 hours for instant repeat queries
- 🛡️ **Production Ready** - Rate limiting, validation, security hardening included
- 📱 **Native iOS App** - Beautiful SwiftUI interface with local history
- 🐳 **Docker Support** - One-command deployment with Docker Compose
- 🧪 **Well Tested** - Comprehensive test suite with Jest
- 📖 **API Documentation** - Built-in API docs at `/api/v1/docs`

## 🚀 Quick Start

### Using Docker (Recommended)

```bash
# Clone the repository
git clone https://github.com/yourusername/dead-app-detector.git
cd dead-app-detector

# Start with Docker Compose
docker-compose up -d

# Test the API
curl -X POST http://localhost:3000/api/v1/analyze \
  -H "Content-Type: application/json" \
  -d '{"url": "https://github.com"}'
```

### Using Make

```bash
# Install dependencies and setup
make setup

# Start development server
make dev

# Run tests
make test

# Run all quality checks
make check
```

### Manual Setup

See detailed setup instructions in [Backend README](backend/README.md) and [iOS README](ios/README.md).

## Project Structure

```
DeadAppDetector/
├── backend/                 # Node.js/Express API
│   ├── src/
│   │   ├── index.js
│   │   ├── routes/
│   │   ├── services/
│   │   ├── collectors/
│   │   └── utils/
│   ├── package.json
│   └── .env.example
└── ios/                     # SwiftUI iOS App
    └── DeadAppDetector/
        ├── Models/
        ├── ViewModels/
        ├── Views/
        ├── Services/
        └── Utilities/
```

## Backend Setup

### Prerequisites
- Node.js 18+ and npm
- (Optional) GitHub personal access token for better API limits

### Installation

1. Navigate to backend directory:
```bash
cd backend
```

2. Install dependencies:
```bash
npm install
```

3. Configure environment:
```bash
cp .env.example .env
```

Edit `.env` and add your GitHub token (optional but recommended):
```
PORT=3000
GITHUB_TOKEN=your_github_personal_access_token_here
CACHE_TTL=86400
NODE_ENV=development
```

4. Start the server:
```bash
# Development mode with auto-reload
npm run dev

# Or production mode
npm start
```

Server will be running at `http://localhost:3000`

### API Endpoints

**Health Check:**
```bash
GET /health
```

**Analyze App:**
```bash
POST /api/v1/analyze
Content-Type: application/json

{
  "url": "https://example.com"
}
```

### Test the API

```bash
curl -X POST http://localhost:3000/api/v1/analyze \
  -H "Content-Type: application/json" \
  -d '{"url": "https://github.com"}'
```

## iOS App Setup

### Prerequisites
- macOS with Xcode 15+
- iOS 17+ (deployment target)

### Installation

1. Open the iOS project in Xcode:
```bash
cd ios
open DeadAppDetector.xcodeproj
```

If you don't have an Xcode project file yet, you'll need to create one:
1. Open Xcode
2. File → New → Project
3. Choose "iOS" → "App"
4. Product Name: "DeadAppDetector"
5. Interface: SwiftUI
6. Language: Swift
7. Add all the Swift files from the `ios/DeadAppDetector` directory

2. Update the API endpoint (if not using localhost):
   - Open `Services/APIService.swift`
   - Change `baseURL` to your server address

3. Run the app:
   - Select a simulator (iPhone 15 Pro recommended)
   - Press ⌘R or click the Play button

### Using the iOS App

1. Enter a website URL (e.g., `https://github.com`)
2. Tap "Analyze App"
3. Wait for analysis to complete
4. Review the health score and detailed signals
5. Share or save the report
6. Access past analyses via the history button

## How It Works

### Signal Collection

The backend collects three categories of signals:

**Website Signals (30% weight):**
- Domain age
- Website reachability
- Sitemap presence
- Blog/news section
- Last content update

**Engineering Signals (40% weight):**
- GitHub repository detection
- Last commit date
- Commit frequency
- Open issues count

**Business Signals (30% weight):**
- Support contact information
- Careers page
- Social media presence
- Legal documentation

### Scoring System

- **80-100**: Actively Maintained (Green)
- **50-79**: Caution (Yellow)
- **0-49**: High Risk (Red)

Each signal category is scored independently, then weighted to produce an overall health score.

### Caching

Results are cached for 24 hours to prevent redundant scans and respect rate limits.

## Architecture

### Backend
- **Framework**: Express.js
- **Signal Collection**: Parallel execution with timeout handling
- **Caching**: node-cache (in-memory)
- **Web Scraping**: Cheerio
- **GitHub Integration**: REST API with optional authentication

### iOS
- **Architecture**: MVVM (Model-View-ViewModel)
- **UI Framework**: SwiftUI
- **Networking**: URLSession with async/await
- **Persistence**: UserDefaults for history

## Production Deployment

### Backend Deployment Options

**Option 1: Railway**
```bash
# Install Railway CLI
npm i -g @railway/cli

# Login and deploy
railway login
railway init
railway up
```

**Option 2: Render**
1. Push code to GitHub
2. Connect repository to Render
3. Add environment variables
4. Deploy

**Option 3: AWS/Google Cloud**
- Deploy as containerized app
- Use RDS/Cloud SQL for PostgreSQL
- Use ElastiCache/Memorystore for Redis

### iOS Deployment

1. Create an Apple Developer account
2. Configure signing in Xcode
3. Archive the app (Product → Archive)
4. Upload to App Store Connect
5. Submit for TestFlight or App Store review

## Future Enhancements

- [ ] PostgreSQL database for persistent storage
- [ ] User authentication and accounts
- [ ] Subscription/payment system (Stripe)
- [ ] Chrome extension version
- [ ] Email notifications for monitored apps
- [ ] Comparative analysis across competitors
- [ ] API rate limiting and usage tracking
- [ ] Advanced analytics dashboard

## Development Notes

### Adding New Signals

1. Create collector in `backend/src/collectors/`
2. Add to `signalCollector.js`
3. Update scoring logic in `scoringEngine.js`
4. Update iOS models if needed

### Customizing Weights

Edit the weights in `scoringEngine.js`:
```javascript
const overallScore = Math.round(
  categories.website.score * 0.3 +
  categories.engineering.score * 0.4 +
  categories.business.score * 0.3
);
```

## Troubleshooting

**Backend won't start:**
- Check Node.js version (18+)
- Verify all dependencies installed
- Check port 3000 is available

**iOS app can't connect:**
- Ensure backend is running
- Check API endpoint in `APIService.swift`
- If using simulator, use `http://localhost:3000`
- If using physical device, use your computer's local IP

**GitHub API rate limits:**
- Add `GITHUB_TOKEN` to `.env`
- Generate token at https://github.com/settings/tokens
- Requires `public_repo` scope

## 📚 Documentation

- [Backend API Documentation](backend/README.md)
- [iOS App Documentation](ios/README.md)
- [Contributing Guidelines](CONTRIBUTING.md)
- [Security Policy](SECURITY.md)
- [Changelog](CHANGELOG.md)

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting PRs.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Express.js](https://expressjs.com/)
- iOS app built with [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- Testing with [Jest](https://jestjs.io/)
- Containerization with [Docker](https://www.docker.com/)

## 📧 Support

For issues, questions, or feature requests:
- Open an [issue](https://github.com/yourusername/dead-app-detector/issues)
- Check existing [discussions](https://github.com/yourusername/dead-app-detector/discussions)

## ⭐ Show Your Support

Give a ⭐️ if this project helped you!

---

**Made with ❤️ by the Dead App Detector team**
