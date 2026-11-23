#!/usr/bin/env bash
set -euo pipefail

FLUTTER_VERSION="3.47.7"
FLUTTER_HOME="${HOME}/.cache/my-arc/flutter-${FLUTTER_VERSION}"

if [[ ! -x "${FLUTTER_HOME}/bin/flutter" ]]; then
  mkdir -p "$(dirname "${FLUTTER_HOME}")"
  git clone --depth 1 --branch "${FLUTTER_VERSION}" \
    https://github.com/flutter/flutter.git "${FLUTTER_HOME}"
fi

export PATH="${FLUTTER_HOME}/bin:${PATH}"
flutter config --no-analytics
flutter pub get
flutter build web --release --base-href /
