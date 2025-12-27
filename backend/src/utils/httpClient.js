import axios from 'axios';

const client = axios.create({
  timeout: 15000,
  headers: {
    'User-Agent': 'DeadAppDetector/1.0 (Analysis Bot)',
  },
});

export async function fetchUrl(url, options = {}) {
  try {
    const response = await client.get(url, options);
    return {
      success: true,
      status: response.status,
      data: response.data,
      headers: response.headers,
    };
  } catch (error) {
    return {
      success: false,
      status: error.response?.status || 0,
      error: error.message,
    };
  }
}

export async function fetchGitHub(endpoint) {
  const token = process.env.GITHUB_TOKEN;
  try {
    const response = await client.get(`https://api.github.com${endpoint}`, {
      headers: token ? { Authorization: `token ${token}` } : {},
    });
    return { success: true, data: response.data };
  } catch (error) {
    return { success: false, error: error.message };
  }
}
