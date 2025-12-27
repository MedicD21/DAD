import { fetchUrl, fetchGitHub } from '../utils/httpClient.js';
import * as cheerio from 'cheerio';

export async function collectEngineeringSignals(url) {
  const signals = {};

  // Detect GitHub repository
  const pageCheck = await fetchUrl(url);
  let repoPath = null;

  if (pageCheck.success) {
    const $ = cheerio.load(pageCheck.data);
    
    // Look for GitHub links
    const links = $('a').map((i, el) => $(el).attr('href')).get();
    const githubLink = links.find(link => 
      link && link.includes('github.com') && link.split('/').length >= 5
    );

    if (githubLink) {
      const match = githubLink.match(/github\.com\/([^/]+\/[^/]+)/);
      if (match) {
        repoPath = match[1].replace(/\.git$/, '');
      }
    }
  }

  signals.repository = { found: !!repoPath, path: repoPath };

  // If repo found, get GitHub data
  if (repoPath) {
    const repoData = await fetchGitHub(`/repos/${repoPath}`);
    
    if (repoData.success) {
      const repo = repoData.data;
      
      signals.lastCommit = {
        date: repo.pushed_at,
        daysAgo: Math.floor((Date.now() - new Date(repo.pushed_at).getTime()) / (1000 * 60 * 60 * 24))
      };

      signals.commitFrequency = {
        updatedAt: repo.updated_at
      };

      // Get open issues count
      signals.openIssues = {
        count: repo.open_issues_count
      };

      // Get recent commits for frequency
      const commitsData = await fetchGitHub(`/repos/${repoPath}/commits?per_page=100`);
      if (commitsData.success) {
        const commits = commitsData.data;
        const now = Date.now();
        const thirtyDaysAgo = now - (30 * 24 * 60 * 60 * 1000);
        const ninetyDaysAgo = now - (90 * 24 * 60 * 60 * 1000);

        const recentCommits30 = commits.filter(c => 
          new Date(c.commit.author.date).getTime() > thirtyDaysAgo
        ).length;

        const recentCommits90 = commits.filter(c => 
          new Date(c.commit.author.date).getTime() > ninetyDaysAgo
        ).length;

        signals.commitFrequency.last30Days = recentCommits30;
        signals.commitFrequency.last90Days = recentCommits90;
      }
    }
  }

  return signals;
}
