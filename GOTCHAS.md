# Useful Information & Gotcha's

---

### Create Secrets Keys

`rake secret` for each `SECRET_KEY` constant in `config/env.yml` (`cp config/env.yml-sample config/env.yml`).

---

### Google Analytics Ghost Spam

Ghost Spam sucks, so add these hostname filters;

* `semalt|anticrawler|best-seo-offer|best-seo-solution|buttons-for-website|buttons-for-your-website|7makemoneyonline|-musicas*-gratis|kambasoft|savetubevideo|ranksonic|medispainstitute|offers.bycontext|100dollars-seo|sitevaluation|dailyrank|rank-checker`
* `videos-for-your-business|success-seo|rankscanner|doktoronline.no|adviceforum.info|video--production|sharemyfile.ru|seo-platform|justprofit.xyz|127.0.0.1|nexus.search-helper.ru|rankings-analytics.com|dbutton.net|o00.in|wordpress-crew.net`
* `fast-wordpress-start.com|top1-seo-service.com|^scripted.com|uptimechecker.com|uptimebot.net|rankings-analytics.com|^uptime.com|.responsive-test.net|dogsrun.net|free-video-tool.com|keywords-monitoring-your-success.com`
* `(best|dollar|ess|top1)\-seo|(videos|buttons)\-for|^scripted\.|\-gratis|semalt|forum69|7make|sharebutton|ranksonic|sitevaluation|dailyrank|vitaly|profit\.xyz|rankings\-|\-crew|uptime(bot|check|\.com)|responsive\-|tkpass|video\-tool|keywords\-monitoring`
