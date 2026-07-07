# Torre — the AI control tower for Latin America (demo)

Live routing view of the orchestration layer: simulated LatAm tenants stream requests
through a policy engine onto three "runways" (frontier APIs, open-weight in-region,
sovereign endpoints). Flip residency / cost policies and scenarios (frontier price hike,
US provider outage) and watch routing, savings, the audit log and the Layer-2 demand
pipeline react. Includes a CISO residency report generator.

Fully client-side — no backend, no keys. Everything in `public/index.html`.
All tenants, traffic, prices and revenue are **simulated** for illustration.

## Run locally
```bash
cd public && python3 -m http.server 5050    # → http://localhost:5050
# or: npx serve public
```

## Deploy
```bash
./deploy.sh    # → torre.q-starr.app
```
GitHub (`q-starr`) + Vercel ("q-starr's projects") + Namecheap (`q-starr.app`,
A record `torre` → `76.76.21.21`). The script prints the one manual DNS record to add.
Or just drag the `public/` folder into vercel.com/new and add the domain in project settings.
