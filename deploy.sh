#!/usr/bin/env bash
# Torre — deploy to torre.q-starr.app
# Mirrors the Three Openings flow: git + GitHub (q-starr) + Vercel + one manual Namecheap record.
# Requires: gh (authed), vercel (authed). Run from the torre/ folder.
set -euo pipefail

PROJECT="torre"
ORG="q-starr"
DOMAIN="torre.q-starr.app"

echo "── Torre deploy → https://${DOMAIN}"

command -v gh >/dev/null || { echo "✗ gh CLI not found — install/auth it, or drag public/ into vercel.com/new"; exit 1; }
command -v vercel >/dev/null || { echo "✗ vercel CLI not found — npm i -g vercel && vercel login"; exit 1; }

# 1 · git + GitHub
if [ ! -d .git ]; then
  git init -q && git add -A && git commit -qm "Torre: AI control tower demo"
  echo "✓ git repo initialized"
fi
if ! gh repo view "${ORG}/${PROJECT}" >/dev/null 2>&1; then
  gh repo create "${ORG}/${PROJECT}" --public --source=. --remote=origin --push
  echo "✓ created + pushed github.com/${ORG}/${PROJECT}"
else
  git remote get-url origin >/dev/null 2>&1 || git remote add origin "https://github.com/${ORG}/${PROJECT}.git"
  git add -A && git diff --cached --quiet || git commit -qm "Update Torre demo"
  git push -u origin HEAD
  echo "✓ pushed to github.com/${ORG}/${PROJECT}"
fi

# 2 · Vercel (static: serves ./public)
vercel deploy --prod --yes --name "${PROJECT}" ./public
echo "✓ deployed to Vercel project '${PROJECT}'"

# 3 · Domain
if vercel domains add "${DOMAIN}" "${PROJECT}" >/dev/null 2>&1; then
  echo "✓ ${DOMAIN} attached to project"
else
  echo "• attach the domain in Vercel → project '${PROJECT}' → Settings → Domains → ${DOMAIN}"
fi

echo ""
echo "── One manual step (Namecheap → q-starr.app → Advanced DNS):"
echo "   A record   host: torre   value: 76.76.21.21   TTL: automatic"
echo "   (skip if already added — propagation is usually minutes)"
echo "── Done: https://${DOMAIN}"
