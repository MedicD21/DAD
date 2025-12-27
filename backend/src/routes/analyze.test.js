import request from 'supertest';
import app from '../index.js';

describe('POST /api/v1/analyze', () => {
  it('should return 400 if URL is missing', async () => {
    const response = await request(app).post('/api/v1/analyze').send({});

    expect(response.status).toBe(400);
    expect(response.body).toHaveProperty('error');
  });

  it('should return 400 if URL is invalid', async () => {
    const response = await request(app).post('/api/v1/analyze').send({
      url: 'not-a-valid-url',
    });

    expect(response.status).toBe(400);
    expect(response.body).toHaveProperty('error');
  });

  it('should analyze a valid URL', async () => {
    const response = await request(app).post('/api/v1/analyze').send({
      url: 'https://github.com',
    });

    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('scanId');
    expect(response.body).toHaveProperty('overallScore');
    expect(response.body).toHaveProperty('status');
    expect(response.body).toHaveProperty('categories');
    expect(response.body).toHaveProperty('url');
  }, 30000); // Increase timeout for actual API calls

  it('should return cached results on second request', async () => {
    const url = 'https://github.com';

    // First request
    await request(app).post('/api/v1/analyze').send({ url });

    // Second request should be cached
    const response = await request(app).post('/api/v1/analyze').send({ url });

    expect(response.status).toBe(200);
    expect(response.body.cached).toBe(true);
  }, 30000);
});

describe('GET /api/v1/docs', () => {
  it('should return API documentation', async () => {
    const response = await request(app).get('/api/v1/docs');

    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('title');
    expect(response.body).toHaveProperty('endpoints');
  });
});

describe('GET /health', () => {
  it('should return health status', async () => {
    const response = await request(app).get('/health');

    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('status', 'healthy');
    expect(response.body).toHaveProperty('timestamp');
  });
});
