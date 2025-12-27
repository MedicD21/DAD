import { collectWebsiteSignals } from '../collectors/websiteSignals.js';
import { collectEngineeringSignals } from '../collectors/engineeringSignals.js';
import { collectBusinessSignals } from '../collectors/businessSignals.js';

export async function collectAllSignals(url) {
  const startTime = Date.now();

  // Run collectors in parallel with individual timeouts
  const [websiteSignals, engineeringSignals, businessSignals] = await Promise.allSettled([
    collectWebsiteSignals(url),
    collectEngineeringSignals(url),
    collectBusinessSignals(url)
  ]);

  const duration = Date.now() - startTime;
  console.log(`Signal collection completed in ${duration}ms`);

  return {
    website: websiteSignals.status === 'fulfilled' ? websiteSignals.value : {},
    engineering: engineeringSignals.status === 'fulfilled' ? engineeringSignals.value : {},
    business: businessSignals.status === 'fulfilled' ? businessSignals.value : {}
  };
}
