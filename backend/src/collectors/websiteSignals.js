import { fetchUrl } from '../utils/httpClient.js';
import { extractDomain } from '../utils/urlParser.js';
import * as cheerio from 'cheerio';
import whois from 'whois-json';

export async function collectWebsiteSignals(url) {
  const signals = {};

  // Domain age
  try {
    const domain = extractDomain(url);
    const whoisData = await whois(domain, { timeout: 10000 });
    
    if (whoisData.creationDate) {
      const creationDate = new Date(whoisData.creationDate);
      const ageYears = (Date.now() - creationDate.getTime()) / (1000 * 60 * 60 * 24 * 365);
      signals.domainAge = {
        value: creationDate.toISOString(),
        ageYears: Math.floor(ageYears)
      };
    }
  } catch (error) {
    signals.domainAge = { error: error.message };
  }

  // Website reachability
  const siteCheck = await fetchUrl(url);
  signals.reachable = {
    success: siteCheck.success,
    status: siteCheck.status
  };

  if (siteCheck.success) {
    const $ = cheerio.load(siteCheck.data);

    // Sitemap detection
    const sitemapCheck = await fetchUrl(`${url}/sitemap.xml`);
    signals.sitemap = { exists: sitemapCheck.success };

    // Blog/news detection
    const blogKeywords = ['blog', 'news', 'updates', 'changelog'];
    const links = $('a').map((i, el) => $(el).attr('href')).get();
    const hasBlog = links.some(link => 
      link && blogKeywords.some(keyword => link.toLowerCase().includes(keyword))
    );
    signals.blog = { detected: hasBlog };

    // Last update detection (best effort from meta tags or blog)
    let lastUpdate = null;
    
    // Check meta tags
    const metaModified = $('meta[property="article:modified_time"]').attr('content') ||
                         $('meta[name="last-modified"]').attr('content');
    if (metaModified) {
      lastUpdate = new Date(metaModified);
    }

    // If blog detected, try to fetch it
    if (hasBlog && !lastUpdate) {
      const blogLink = links.find(link => 
        link && blogKeywords.some(keyword => link.toLowerCase().includes(keyword))
      );
      
      if (blogLink) {
        const blogUrl = blogLink.startsWith('http') ? blogLink : new URL(blogLink, url).href;
        const blogPage = await fetchUrl(blogUrl);
        
        if (blogPage.success) {
          const $blog = cheerio.load(blogPage.data);
          const dates = $blog('time').map((i, el) => $blog(el).attr('datetime')).get();
          
          if (dates.length > 0) {
            lastUpdate = new Date(Math.max(...dates.map(d => new Date(d).getTime())));
          }
        }
      }
    }

    signals.lastUpdate = lastUpdate ? {
      date: lastUpdate.toISOString(),
      daysAgo: Math.floor((Date.now() - lastUpdate.getTime()) / (1000 * 60 * 60 * 24))
    } : { detected: false };
  }

  return signals;
}
