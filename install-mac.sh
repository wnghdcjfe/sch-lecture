#!/usr/bin/env bash
# Claude Code 설치 스크립트 (macOS / Linux / WSL)
# 사용법: curl -fsSL https://raw.githubusercontent.com/wnghdcjfe/sch-lecture/main/install-mac.sh | bash
set -euo pipefail

info() { printf '\033[36m[INFO]\033[0m %s\n' "$1"; }
ok()   { printf '\033[32m[ OK ]\033[0m %s\n' "$1"; }
fail() { printf '\033[31m[FAIL]\033[0m %s\n' "$1" >&2; exit 1; }

case "$(uname -s)" in
  Darwin|Linux) ;;
  *) fail "macOS / Linux / WSL 전용입니다. Windows는 install-windows.ps1을 사용하세요." ;;
esac

if [ "$(id -u)" -eq 0 ] && [ -n "${SUDO_USER:-}" ]; then
  fail "sudo 없이 실행하세요: curl -fsSL ... | bash"
fi

command -v curl >/dev/null 2>&1 || fail "curl이 필요합니다."

info "Claude Code 공식 설치 스크립트를 실행합니다..."
curl -fsSL https://claude.ai/install.sh | bash || fail "설치에 실패했습니다. 위 오류 메시지를 확인하세요."

# PATH 등록 (~/.local/bin)
BIN="$HOME/.local/bin"
LINE='export PATH="$HOME/.local/bin:$PATH"'
for rc in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.bash_profile"; do
  # zsh는 macOS 기본 쉘이므로 .zshrc는 없으면 만든다
  if [ "$rc" = "$HOME/.zshrc" ] || [ -f "$rc" ]; then
    touch "$rc"
    if ! grep -qs '.local/bin' "$rc"; then
      printf '\n# Claude Code\n%s\n' "$LINE" >> "$rc"
      info "PATH 추가: $rc"
    fi
  fi
done
export PATH="$BIN:$PATH"

if command -v claude >/dev/null 2>&1; then
  ok "설치 완료: $(claude --version)"
  echo
  echo "새 터미널을 열거나 'source ~/.zshrc' 실행 후 'claude' 명령을 사용하세요."
else
  fail "claude 명령을 찾을 수 없습니다. $BIN 폴더를 확인하세요."
fi
