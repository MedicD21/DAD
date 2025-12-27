# Contributing to Dead App Detector

Thank you for your interest in contributing to Dead App Detector! This document provides guidelines and instructions for contributing.

## Development Setup

### Prerequisites

- Node.js 18+ and npm
- macOS with Xcode 15+ (for iOS development)
- Git
- Docker and Docker Compose (optional, for containerized development)

### Getting Started

1. **Fork and clone the repository**
   ```bash
   git clone https://github.com/yourusername/dead-app-detector.git
   cd dead-app-detector
   ```

2. **Install backend dependencies**
   ```bash
   cd backend
   npm install
   cp .env.example .env
   ```

3. **Start the development server**
   ```bash
   npm run dev
   ```

## Code Style

### JavaScript/Node.js

- Follow the ESLint configuration provided
- Use ES6+ features
- Format code with Prettier before committing
- Run `npm run lint:fix` to auto-fix linting issues
- Run `npm run format` to format code

### Swift/iOS

- Follow Swift best practices
- Use SwiftUI for UI components
- Follow MVVM architecture pattern
- Keep views simple and delegate logic to ViewModels

## Testing

### Backend Tests

```bash
cd backend
npm test                 # Run all tests
npm run test:watch      # Run tests in watch mode
npm run test:coverage   # Generate coverage report
```

### Writing Tests

- Write unit tests for all new features
- Use Jest for testing
- Aim for >80% code coverage
- Test error cases and edge cases

## Pull Request Process

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Write clean, maintainable code
   - Add tests for new features
   - Update documentation as needed

3. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add new feature"
   ```

   Follow conventional commit format:
   - `feat:` - New feature
   - `fix:` - Bug fix
   - `docs:` - Documentation changes
   - `refactor:` - Code refactoring
   - `test:` - Adding tests
   - `chore:` - Maintenance tasks

4. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

5. **Open a Pull Request**
   - Provide a clear description of changes
   - Reference any related issues
   - Ensure all CI checks pass

## Adding New Signal Collectors

To add a new signal to the analysis:

1. **Create a collector function** in `backend/src/collectors/`
   ```javascript
   export async function collectNewSignal(url) {
     // Implementation
     return { found: true, data: {} };
   }
   ```

2. **Add to signal collector** in `backend/src/services/signalCollector.js`
   ```javascript
   import { collectNewSignal } from '../collectors/newSignal.js';

   // Add to the appropriate signals object
   ```

3. **Update scoring logic** in `backend/src/services/scoringEngine.js`
   ```javascript
   // Add scoring logic for the new signal
   ```

4. **Write tests** for the new collector

5. **Update documentation** to reflect the new signal

## Code Review Guidelines

- Be respectful and constructive
- Focus on code quality and maintainability
- Suggest improvements, don't just criticize
- Approve PRs that meet quality standards

## Bug Reports

When reporting bugs, please include:

- Clear description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Environment details (Node version, OS, etc.)
- Error messages and stack traces

## Feature Requests

For feature requests:

- Explain the use case
- Describe the proposed solution
- Consider alternative approaches
- Discuss potential impact

## Questions?

Feel free to open an issue for questions or join discussions.

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.
