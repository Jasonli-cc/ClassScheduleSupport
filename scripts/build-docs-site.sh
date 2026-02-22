#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SITE_SRC="${ROOT_DIR}/site-src"

rm -rf "${SITE_SRC}"
mkdir -p "${SITE_SRC}"
mkdir -p "${SITE_SRC}/_includes"
mkdir -p "${SITE_SRC}/en"

# Override minima header to remove the top bar (repo name/header) on all pages.
cat > "${SITE_SRC}/_includes/header.html" <<'HTML'
<!-- header intentionally blank -->
HTML

cat > "${SITE_SRC}/_config.yml" <<'YAML'
theme: minima
title: ClassSchedule 文档
encoding: utf-8
lang: zh-CN
baseurl: /ClassScheduleSupport
YAML

cat > "${SITE_SRC}/index.md" <<'MD'
---
layout: page
title: 文档目录
permalink: /
---

- [隐私政策]({{ site.baseurl }}/privacy/)
- [用户协议与服务条款]({{ site.baseurl }}/terms/)
- [权限与通知说明]({{ site.baseurl }}/permissions/)
- [支持文档]({{ site.baseurl }}/support/)
MD

cat > "${SITE_SRC}/en/index.md" <<'MD'
---
layout: page
title: Documentation
permalink: /en/
lang: en
---

- [Privacy Policy]({{ site.baseurl }}/en/privacy/)
- [Terms of Service]({{ site.baseurl }}/en/terms/)
- [Permissions and Notifications]({{ site.baseurl }}/en/permissions/)
- [Support]({{ site.baseurl }}/en/support/)
MD

write_page() {
  local src="$1"
  local title="$2"
  local permalink="$3"
  local dest="$4"
  local lang="${5:-}"

  if [[ ! -f "${src}" ]]; then
    echo "Source file not found: ${src}" >&2
    exit 1
  fi

  {
    echo "---"
    echo "layout: page"
    echo "title: ${title}"
    echo "permalink: ${permalink}"
    if [[ -n "${lang}" ]]; then
      echo "lang: ${lang}"
    fi
    echo "---"
    echo
    cat "${src}"
  } > "${dest}"
}

write_page "${ROOT_DIR}/PrivacyPolicy.md" "隐私政策" "/privacy/" "${SITE_SRC}/privacy.md"
write_page "${ROOT_DIR}/TermsOfService.md" "用户协议与服务条款" "/terms/" "${SITE_SRC}/terms.md"
write_page "${ROOT_DIR}/PermissionsAndNotifications.md" "权限与通知说明" "/permissions/" "${SITE_SRC}/permissions.md"
write_page "${ROOT_DIR}/Support.md" "支持文档" "/support/" "${SITE_SRC}/support.md"

write_page "${ROOT_DIR}/PrivacyPolicy.en.md" "Privacy Policy" "/en/privacy/" "${SITE_SRC}/en/privacy.md" "en"
write_page "${ROOT_DIR}/TermsOfService.en.md" "Terms of Service" "/en/terms/" "${SITE_SRC}/en/terms.md" "en"
write_page "${ROOT_DIR}/PermissionsAndNotifications.en.md" "Permissions and Notifications" "/en/permissions/" "${SITE_SRC}/en/permissions.md" "en"
write_page "${ROOT_DIR}/Support.en.md" "Support" "/en/support/" "${SITE_SRC}/en/support.md" "en"
