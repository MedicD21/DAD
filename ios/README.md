# Dead App Detector - iOS App

Native iOS app for analyzing SaaS product health and maintenance status.

## Features

- 📱 Native SwiftUI interface
- 🎨 Modern, intuitive design
- 💾 Local history storage
- 🔄 Pull-to-refresh
- 📊 Detailed signal breakdown
- 🎯 Score-based health indicators
- 📤 Share analysis results
- ⚡ Async/await networking

## Requirements

- iOS 17.0+
- Xcode 15.0+
- macOS Monterey or later

## Architecture

### MVVM Pattern

```
ios/DeadAppDetector/
├── Models/              # Data models
│   ├── AnalysisResult.swift
│   └── Signal.swift
├── ViewModels/          # Business logic
│   └── AnalysisViewModel.swift
├── Views/               # UI components
│   ├── InputView.swift
│   ├── ResultsView.swift
│   ├── HistoryView.swift
│   └── Components/
├── Services/            # API and data services
│   ├── APIService.swift
│   └── HistoryService.swift
└── Utilities/           # Helpers and extensions
    └── Theme.swift
```

## Setup

### 1. Create Xcode Project

If you don't have an `.xcodeproj` file:

1. Open Xcode
2. File → New → Project
3. Choose "iOS" → "App"
4. Product Name: "DeadAppDetector"
5. Interface: SwiftUI
6. Language: Swift
7. Add all Swift files from the directory structure

### 2. Configure API Endpoint

Edit `Services/APIService.swift`:

```swift
private let baseURL: String = {
    #if DEBUG
    return "http://localhost:3000/api/v1"  // For simulator
    // return "http://192.168.1.XXX:3000/api/v1"  // For physical device
    #else
    return "https://your-production-url.com/api/v1"
    #endif
}()
```

For testing on a physical device, replace `192.168.1.XXX` with your computer's local IP address.

### 3. Run the Backend

Make sure the backend API is running:

```bash
cd ../backend
npm run dev
```

### 4. Build and Run

1. Select a simulator (iPhone 15 Pro recommended)
2. Press ⌘R or click the Play button

## Usage

1. **Enter URL**: Type or paste a SaaS product URL
2. **Analyze**: Tap "Analyze App" to start analysis
3. **View Results**: Review health score and detailed signals
4. **History**: Access past analyses via the history button
5. **Share**: Export or share analysis reports

## Models

### AnalysisResult

Represents a complete analysis with:
- Overall score (0-100)
- Status (healthy/caution/risk)
- Category breakdowns
- Individual signals
- Timestamp

### Signal

Individual data points like:
- Name and value
- Status indicator
- Impact (positive/negative/neutral)
- Explanation

## Services

### APIService

Handles all API communication:
- POST /api/v1/analyze
- GET /health
- Error handling
- Timeout management
- Rate limit handling

### HistoryService

Manages local storage:
- Save analysis results
- Retrieve history
- Clear history
- Persistence with UserDefaults

## UI Components

### InputView
- URL input field
- Validation
- Loading states
- Error display

### ResultsView
- Score visualization
- Category breakdown
- Signal details
- Share functionality

### HistoryView
- List of past analyses
- Delete functionality
- Tap to view details

## Theming

Customize colors and styles in `Utilities/Theme.swift`:

```swift
extension Color {
    static let healthy = Color.green
    static let caution = Color.yellow
    static let risk = Color.red
}
```

## Error Handling

The app handles various error scenarios:
- Network errors
- Invalid URLs
- Server errors
- Rate limiting
- Decoding failures

All errors display user-friendly messages with recovery suggestions.

## Testing

### Manual Testing Checklist

- [ ] Enter valid URL and analyze
- [ ] Enter invalid URL (should show error)
- [ ] Test with no network connection
- [ ] Test with server offline
- [ ] Verify caching (second request should be instant)
- [ ] Test history save/load
- [ ] Test share functionality
- [ ] Test on both simulator and device

## Performance

- Async/await for smooth UI
- Result caching for instant repeat queries
- Efficient list rendering
- Minimal memory footprint

## Known Issues

### Simulator Networking

If you encounter "Connection refused" on simulator:
- Ensure backend is running on localhost:3000
- Check that `baseURL` is set correctly
- Try rebuilding the app

### Physical Device Testing

For testing on physical devices:
- Use your computer's local IP address
- Ensure both device and computer are on same network
- Disable any firewalls blocking port 3000

## Future Enhancements

- [ ] Widget support for quick checks
- [ ] Push notifications for monitored apps
- [ ] Dark mode improvements
- [ ] iPad optimization
- [ ] macOS companion app
- [ ] Export to PDF
- [ ] Compare multiple apps

## Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

## License

See [LICENSE](../LICENSE) for license information.
