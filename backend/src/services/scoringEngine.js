export function calculateScore(signals, url) {
  const categories = {
    website: scoreWebsiteSignals(signals.website),
    engineering: scoreEngineeringSignals(signals.engineering),
    business: scoreBusinessSignals(signals.business),
  };

  // Weighted average: website 30%, engineering 40%, business 30%
  const overallScore = Math.round(
    categories.website.score * 0.3 +
      categories.engineering.score * 0.4 +
      categories.business.score * 0.3
  );

  const status = overallScore >= 80 ? 'healthy' : overallScore >= 50 ? 'caution' : 'risk';

  const summary = generateSummary(categories, overallScore, status);

  return {
    scanId: generateScanId(),
    timestamp: new Date().toISOString(),
    url,
    overallScore,
    status,
    categories,
    summary,
  };
}

function scoreWebsiteSignals(signals) {
  const signalResults = [];
  let totalScore = 0;
  let maxScore = 0;

  // Domain age (20 points)
  maxScore += 20;
  if (signals.domainAge && !signals.domainAge.error) {
    const years = signals.domainAge.ageYears;
    const score = years >= 3 ? 20 : years >= 1 ? 15 : 10;
    totalScore += score;

    signalResults.push({
      name: 'Domain Age',
      status: years >= 3 ? 'healthy' : years >= 1 ? 'warning' : 'risk',
      value: `${years} years`,
      impact: years >= 3 ? 'positive' : 'neutral',
      explanation:
        years >= 3
          ? `Domain registered ${years} years ago, indicating established presence`
          : `Domain is relatively new (${years} years old)`,
    });
  } else {
    signalResults.push({
      name: 'Domain Age',
      status: 'unknown',
      value: 'Unknown',
      impact: 'neutral',
      explanation: 'Could not determine domain age',
    });
  }

  // Website reachable (25 points)
  maxScore += 25;
  if (signals.reachable && signals.reachable.success) {
    totalScore += 25;
    signalResults.push({
      name: 'Website Reachable',
      status: 'healthy',
      value: `${signals.reachable.status} OK`,
      impact: 'positive',
      explanation: 'Website responds successfully',
    });
  } else {
    signalResults.push({
      name: 'Website Reachable',
      status: 'risk',
      value: signals.reachable?.status || 'Failed',
      impact: 'negative',
      explanation: 'Website is not accessible or responding with errors',
    });
  }

  // Sitemap (10 points)
  maxScore += 10;
  if (signals.sitemap && signals.sitemap.exists) {
    totalScore += 10;
    signalResults.push({
      name: 'Sitemap',
      status: 'healthy',
      value: 'Found',
      impact: 'positive',
      explanation: 'Sitemap.xml detected, indicating active maintenance',
    });
  } else {
    totalScore += 5;
    signalResults.push({
      name: 'Sitemap',
      status: 'warning',
      value: 'Not found',
      impact: 'neutral',
      explanation: 'No sitemap detected',
    });
  }

  // Blog/News (15 points)
  maxScore += 15;
  if (signals.blog && signals.blog.detected) {
    totalScore += 15;
    signalResults.push({
      name: 'Blog/News Section',
      status: 'healthy',
      value: 'Found',
      impact: 'positive',
      explanation: 'Blog or news section detected',
    });
  } else {
    signalResults.push({
      name: 'Blog/News Section',
      status: 'warning',
      value: 'Not found',
      impact: 'neutral',
      explanation: 'No blog or news section found',
    });
  }

  // Last update (30 points)
  maxScore += 30;
  if (signals.lastUpdate && signals.lastUpdate.date) {
    const days = signals.lastUpdate.daysAgo;
    const score = days <= 30 ? 30 : days <= 90 ? 20 : days <= 180 ? 10 : 5;
    totalScore += score;

    const status = days <= 90 ? 'healthy' : days <= 180 ? 'warning' : 'risk';
    const timeStr =
      days < 30
        ? `${days} days ago`
        : days < 365
          ? `${Math.floor(days / 30)} months ago`
          : `${Math.floor(days / 365)} years ago`;

    signalResults.push({
      name: 'Last Content Update',
      status,
      value: timeStr,
      impact: days <= 90 ? 'positive' : 'negative',
      explanation:
        days <= 90
          ? 'Recent content updates detected'
          : `No recent updates detected (last update ${timeStr})`,
    });
  } else {
    signalResults.push({
      name: 'Last Content Update',
      status: 'unknown',
      value: 'Unknown',
      impact: 'neutral',
      explanation: 'Could not determine last update date',
    });
  }

  const finalScore = maxScore > 0 ? Math.round((totalScore / maxScore) * 100) : 0;

  return {
    score: finalScore,
    signals: signalResults,
  };
}

function scoreEngineeringSignals(signals) {
  const signalResults = [];
  let totalScore = 0;
  let maxScore = 0;

  // Repository found (20 points)
  maxScore += 20;
  if (signals.repository && signals.repository.found) {
    totalScore += 20;
    signalResults.push({
      name: 'GitHub Repository',
      status: 'healthy',
      value: 'Found',
      impact: 'positive',
      explanation: `Public repository detected: ${signals.repository.path}`,
    });

    // Last commit (40 points)
    maxScore += 40;
    if (signals.lastCommit) {
      const days = signals.lastCommit.daysAgo;
      const score = days <= 14 ? 40 : days <= 30 ? 30 : days <= 90 ? 20 : days <= 180 ? 10 : 5;
      totalScore += score;

      const status = days <= 30 ? 'healthy' : days <= 90 ? 'warning' : 'risk';
      const timeStr =
        days < 30
          ? `${days} days ago`
          : days < 365
            ? `${Math.floor(days / 30)} months ago`
            : `${Math.floor(days / 365)} years ago`;

      signalResults.push({
        name: 'Last Commit',
        status,
        value: timeStr,
        impact: days <= 30 ? 'positive' : 'negative',
        explanation:
          days <= 30
            ? 'Active recent development'
            : days <= 90
              ? 'Development activity has slowed'
              : 'Development appears stagnant',
      });
    }

    // Commit frequency (25 points)
    maxScore += 25;
    if (signals.commitFrequency) {
      const commits30 = signals.commitFrequency.last30Days || 0;
      const commits90 = signals.commitFrequency.last90Days || 0;

      const score =
        commits30 >= 10 ? 25 : commits30 >= 5 ? 20 : commits90 >= 10 ? 15 : commits90 >= 5 ? 10 : 5;
      totalScore += score;

      const status = commits30 >= 5 ? 'healthy' : commits90 >= 5 ? 'warning' : 'risk';

      signalResults.push({
        name: 'Commit Frequency',
        status,
        value: `${commits30} commits (30 days)`,
        impact: commits30 >= 5 ? 'positive' : 'negative',
        explanation:
          commits30 >= 5
            ? 'Regular development activity'
            : commits90 >= 5
              ? 'Infrequent development activity'
              : 'Minimal development activity',
      });
    }

    // Open issues (15 points)
    maxScore += 15;
    if (signals.openIssues) {
      const count = signals.openIssues.count;
      // Having some issues is normal, too many or zero both are potential concerns
      const score = count >= 5 && count <= 50 ? 15 : count > 50 ? 10 : count === 0 ? 10 : 12;
      totalScore += score;

      signalResults.push({
        name: 'Open Issues',
        status: count >= 5 && count <= 50 ? 'healthy' : 'warning',
        value: `${count} open`,
        impact: 'neutral',
        explanation:
          count === 0
            ? 'No open issues (may indicate low community engagement)'
            : count <= 50
              ? 'Normal issue activity'
              : 'High number of open issues',
      });
    }
  } else {
    signalResults.push({
      name: 'GitHub Repository',
      status: 'warning',
      value: 'Not found',
      impact: 'negative',
      explanation: 'No public repository detected on website',
    });
  }

  const finalScore = maxScore > 0 ? Math.round((totalScore / maxScore) * 100) : 50;

  return {
    score: finalScore,
    signals: signalResults,
  };
}

function scoreBusinessSignals(signals) {
  const signalResults = [];
  let totalScore = 0;
  let maxScore = 0;

  // Support email (30 points)
  maxScore += 30;
  if (signals.supportEmail && signals.supportEmail.found) {
    totalScore += 30;
    signalResults.push({
      name: 'Support Contact',
      status: 'healthy',
      value: 'Found',
      impact: 'positive',
      explanation: `Support email detected: ${signals.supportEmail.email}`,
    });
  } else {
    signalResults.push({
      name: 'Support Contact',
      status: 'risk',
      value: 'Not found',
      impact: 'negative',
      explanation: 'No support contact information found',
    });
  }

  // Careers page (25 points)
  maxScore += 25;
  if (signals.careers && signals.careers.found) {
    totalScore += 25;
    signalResults.push({
      name: 'Careers Page',
      status: 'healthy',
      value: 'Found',
      impact: 'positive',
      explanation: 'Hiring activity detected, indicating growth',
    });
  } else {
    totalScore += 5;
    signalResults.push({
      name: 'Careers Page',
      status: 'warning',
      value: 'Not found',
      impact: 'neutral',
      explanation: 'No hiring activity detected',
    });
  }

  // Social presence (20 points)
  maxScore += 20;
  if (signals.social) {
    const count = signals.social.count;
    const score = count >= 2 ? 20 : count >= 1 ? 15 : 5;
    totalScore += score;

    const status = count >= 2 ? 'healthy' : count >= 1 ? 'warning' : 'risk';
    const platforms = signals.social.platforms.join(', ');

    signalResults.push({
      name: 'Social Presence',
      status,
      value: count > 0 ? platforms : 'None',
      impact: count >= 1 ? 'positive' : 'negative',
      explanation:
        count >= 2
          ? `Active on multiple platforms: ${platforms}`
          : count >= 1
            ? `Limited social presence: ${platforms}`
            : 'No social media presence detected',
    });
  }

  // Legal pages (25 points)
  maxScore += 25;
  if (signals.legalPages && signals.legalPages.found) {
    totalScore += 25;
    signalResults.push({
      name: 'Legal Documentation',
      status: 'healthy',
      value: 'Found',
      impact: 'positive',
      explanation: 'Terms of service and privacy policy detected',
    });
  } else {
    totalScore += 10;
    signalResults.push({
      name: 'Legal Documentation',
      status: 'warning',
      value: 'Not found',
      impact: 'neutral',
      explanation: 'No terms of service or privacy policy detected',
    });
  }

  const finalScore = maxScore > 0 ? Math.round((totalScore / maxScore) * 100) : 0;

  return {
    score: finalScore,
    signals: signalResults,
  };
}

function generateSummary(categories, overallScore, status) {
  const parts = [];

  if (status === 'healthy') {
    parts.push('This app shows strong maintenance activity.');
  } else if (status === 'caution') {
    parts.push('This app shows moderate maintenance activity.');
  } else {
    parts.push('This app shows limited or no maintenance activity.');
  }

  // Add specific concerns
  const concerns = [];

  if (categories.engineering.score < 50) {
    concerns.push('engineering signals indicate development has stalled');
  } else if (categories.engineering.score < 70) {
    concerns.push('engineering signals indicate slowed development');
  }

  if (categories.business.score < 50) {
    concerns.push('business signals suggest reduced operations');
  }

  if (categories.website.score < 50) {
    concerns.push('website shows signs of neglect');
  }

  if (concerns.length > 0) {
    parts.push(concerns.join(' and '));
  } else {
    parts.push('core infrastructure remains operational with regular updates');
  }

  return parts.join('. ') + '.';
}

function generateScanId() {
  return Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
}
