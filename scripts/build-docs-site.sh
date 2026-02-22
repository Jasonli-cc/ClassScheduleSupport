#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SITE_SRC="${ROOT_DIR}/site-src"

rm -rf "${SITE_SRC}"
mkdir -p "${SITE_SRC}"

cat > "${SITE_SRC}/_config.yml" <<'YAML'
theme: minima
title: ClassSchedule 文档
encoding: utf-8
lang: zh-CN
YAML

cat > "${SITE_SRC}/index.md" <<'MD'
---
layout: page
title: 文档目录
permalink: /
---

- [隐私政策](/privacy/)
- [用户协议与服务条款](/terms/)
- [权限与通知说明](/permissions/)
- [支持文档](/support/)
MD

write_page() {
  local src="$1"
  local title="$2"
  local permalink="$3"
  local dest="$4"

  if [[ ! -f "${src}" ]]; then
    echo "Source file not found: ${src}" >&2
    exit 1
  fi

  {
    echo "---"
    echo "layout: page"
    echo "title: ${title}"
    echo "permalink: ${permalink}"
    echo "---"
    echo
    cat "${src}"
  } > "${dest}"
}

write_page "${ROOT_DIR}/PrivacyPolicy.md" "隐私政策" "/privacy/" "${SITE_SRC}/privacy.md"
write_page "${ROOT_DIR}/TermsOfService.md" "用户协议与服务条款" "/terms/" "${SITE_SRC}/terms.md"
write_page "${ROOT_DIR}/PermissionsAndNotifications.md" "权限与通知说明" "/permissions/" "${SITE_SRC}/permissions.md"
write_page "${ROOT_DIR}/Support.md" "支持文档" "/support/" "${SITE_SRC}/support.md"
