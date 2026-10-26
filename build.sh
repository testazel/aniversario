#!/usr/bin/env bash
# Prepara public/ con sólo lo que se publica y rellena los marcadores de los .html.
# Lo usan Cloudflare Pages (comando de build: bash build.sh) y el workflow de GitHub Pages.
#   RSVP_API_URL  URL /exec del Apps Script
#   SITE_ORIGIN   dirección pública del sitio, sin / final (p. ej. https://aniversario.pages.dev)
set -euo pipefail

: "${RSVP_API_URL:?Falta la variable RSVP_API_URL}"
: "${SITE_ORIGIN:?Falta la variable SITE_ORIGIN}"
SITE_ORIGIN="${SITE_ORIGIN%/}"

rm -rf public
mkdir public
cp main.html invitacion.html robots.txt public/
cp -r imagenes public/
if [ -d fonts ]; then cp -r fonts public/; fi

for f in public/*.html; do
  sed -i -e "s#__RSVP_API_URL__#${RSVP_API_URL}#g" -e "s#__SITE_ORIGIN__#${SITE_ORIGIN}#g" "$f"
done

if grep -l "__RSVP_API_URL__\|__SITE_ORIGIN__" public/*.html; then
  echo "Quedaron marcadores sin reemplazar" >&2
  exit 1
fi
echo "public/ listo para ${SITE_ORIGIN}"
