import { fetchUrl } from '../utils/httpClient.js';
import * as cheerio from 'cheerio';

export async function collectBusinessSignals(url) {
  const signals = {};

  const pageCheck = await fetchUrl(url);

  if (pageCheck.success) {
    const $ = cheerio.load(pageCheck.data);
    const pageText = $('body').text().toLowerCase();
    const links = $('a').map((i, el) => ({ 
      href: $(el).attr('href'), 
      text: $(el).text().toLowerCase() 
    })).get();

    // Support email detection
    const emailRegex = /([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+)/gi;
    const emails = pageText.match(emailRegex) || [];
    const supportEmail = emails.find(email => 
      email.includes('support') || email.includes('help') || email.includes('contact')
    ) || emails[0];

    signals.supportEmail = {
      found: !!supportEmail,
      email: supportEmail || null
    };

    // Careers page detection
    const careerKeywords = ['careers', 'jobs', 'hiring', 'join us', 'work with us'];
    const hasCareers = links.some(link => 
      link.href && careerKeywords.some(keyword => 
        link.href.toLowerCase().includes(keyword) || link.text.includes(keyword)
      )
    );

    signals.careers = { found: hasCareers };

    // Social presence detection
    const socialPlatforms = {
      linkedin: pageText.includes('linkedin.com') || links.some(l => l.href && l.href.includes('linkedin.com')),
      twitter: pageText.includes('twitter.com') || pageText.includes('x.com') || 
               links.some(l => l.href && (l.href.includes('twitter.com') || l.href.includes('x.com'))),
      facebook: pageText.includes('facebook.com') || links.some(l => l.href && l.href.includes('facebook.com'))
    };

    signals.social = {
      platforms: Object.entries(socialPlatforms).filter(([_k, v]) => v).map(([k]) => k),
      count: Object.values(socialPlatforms).filter(v => v).length
    };

    // Terms of Service / Privacy Policy (indicates legal compliance)
    const legalKeywords = ['terms', 'privacy', 'legal'];
    const hasLegal = links.some(link =>
      link.href && legalKeywords.some(keyword =>
        link.href.toLowerCase().includes(keyword) || link.text.includes(keyword)
      )
    );

    signals.legalPages = { found: hasLegal };
  }

  return signals;
}
