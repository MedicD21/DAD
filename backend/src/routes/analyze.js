import express from 'express';
import { collectAllSignals } from '../services/signalCollector.js';
import { calculateScore } from '../services/scoringEngine.js';
import { getCache, setCache } from '../services/cache.js';
import { normalizeUrl } from '../utils/urlParser.js';
import { validateAnalyzeRequest } from '../middleware/validation.js';
import { analyzeLimiter } from '../middleware/rateLimiter.js';

const router = express.Router();

// API documentation
router.get('/docs', (req, res) => {
  res.json({
    title: 'Dead App Detector API Documentation',
    version: '1.0.0',
    endpoints: [
      {
        method: 'POST',
        path: '/api/v1/analyze',
        description: 'Analyze a SaaS product URL to determine if it is actively maintained',
        requestBody: {
          url: 'string (required) - The URL of the SaaS product to analyze',
        },
        response: {
          scanId: 'string - Unique identifier for this scan',
          timestamp: 'string - ISO timestamp of the analysis',
          url: 'string - The analyzed URL',
          overallScore: 'number - Overall health score (0-100)',
          status: 'string - healthy | caution | risk',
          categories: {
            website: 'object - Website-related signals and score',
            engineering: 'object - Engineering-related signals and score',
            business: 'object - Business-related signals and score',
          },
          summary: 'string - Human-readable summary of the analysis',
          cached: 'boolean - Whether this result was served from cache',
        },
        example: {
          request: { url: 'https://github.com' },
          response: {
            scanId: 'abc123def456',
            timestamp: '2024-01-01T00:00:00.000Z',
            url: 'https://github.com',
            overallScore: 95,
            status: 'healthy',
            cached: false,
          },
        },
      },
    ],
  });
});

// Analyze endpoint with validation and rate limiting
router.post('/analyze', analyzeLimiter, validateAnalyzeRequest, async (req, res, next) => {
  try {
    const { url } = req.validatedBody;
    const normalizedUrl = normalizeUrl(url);

    // Check cache
    const cached = getCache(normalizedUrl);
    if (cached) {
      return res.json({ ...cached, cached: true });
    }

    // Collect signals
    const signals = await collectAllSignals(normalizedUrl);

    // Calculate score
    const result = calculateScore(signals, normalizedUrl);

    // Cache result
    setCache(normalizedUrl, result);

    res.json({ ...result, cached: false });
  } catch (error) {
    next(error);
  }
});

export default router;
