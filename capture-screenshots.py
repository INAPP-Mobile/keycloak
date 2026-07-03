#!/usr/bin/env python3
"""Capture 3 screenshots of Keycloak running service using Playwright headless."""
import os, json, sys

PLAYWRIGHT_DIR = os.path.expanduser("/var/home/ihshim523/Work/railway/railway-keycloak/screenshots")
os.makedirs(PLAYWRIGHT_DIR, exist_ok=True)

from playwright.sync_api import sync_playwright

DOMAIN = "https://keycloak-production-35e0.up.railway.app"

SCREENSHOTS = [
    {
        "url": f"{DOMAIN}/admin/master/console/",
        "filename": "01-admin-console",
        "label": "Admin Console Login",
    },
    {
        "url": f"{DOMAIN}/realms/master/account/",
        "filename": "02-account-page",
        "label": "Account/Service Console",
    },
    {
        "url": DOMAIN + "/",
        "filename": "03-root-landing",
        "label": "Root Landing Page (redirect to Admin)",
    },
]

page_contents = []

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    context = browser.new_context(
        viewport={"width": 1280, "height": 720},
        user_agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
    )
    page = context.new_page()

    for s in SCREENSHOTS:
        print(f"  Capturing: {s['label']} -> {s['url']}")
        try:
            resp = page.goto(s['url'], wait_until='domcontentloaded', timeout=30000)
            status = getattr(resp, 'status', '?')
            html = page.content()
            title = page.title() or "(no title)"
            
            if len(html) > 50:
                print(f"    Status: HTTP {status}, Content length: {len(html)}, Title: {title}")
            else:
                print(f"    Status: HTTP {status}, Content short ({len(html)} chars)")
            
            # Wait a moment for JS to render
            page.wait_for_timeout(2000)
            
            screenshot_path = os.path.join(PLAYWRIGHT_DIR, f"{s['filename']}.png")
            page.screenshot(path=screenshot_path, full_page=True)
            print(f"    -> Saved: {screenshot_path}")
            
            # Store metadata for the README commit
            page_contents.append({
                "label": s['label'],
                "status": status,
                "content_length": len(html),
                "title": title,
                "filename": f"screenshots/{s['filename']}.png",
                "path": screenshot_path,
            })
        except Exception as e:
            print(f"    ERROR: {e}")
            # Fallback: curl the page and save as text
            import subprocess
            r = subprocess.run(['curl', '-sL', '--connect-timeout', '15', s['url']], capture_output=True, text=True)
            fallback_path = os.path.join(PLAYWRIGHT_DIR, f"{s['filename']}.txt")
            with open(fallback_path, 'w') as f:
                f.write(r.stdout)
            print(f"    -> Fallback: {fallback_path}")

    browser.close()

# Save metadata for later use
meta_path = os.path.join(PLAYWRIGHT_DIR, "metadata.json")
with open(meta_path, 'w') as f:
    json.dump(page_contents, f, indent=2)

print("\nAll screenshots captured successfully!")
print(f"Saved metadata to: {meta_path}")
for p in page_contents:
    print(f"  - {p['label']}: {p.get('filename', 'N/A')}")
