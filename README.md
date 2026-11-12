# Claude Code CLI 설치 가이드

Claude Code CLI를 설치하면 터미널에서 `claude` 명령어를 바로 사용할 수 있습니다.

현재 공식 권장 설치 방식은 **네이티브 설치(Native Install)** 이며, Node.js나 npm 없이도 설치할 수 있습니다.

## ⚡ 빠른 설치 (권장)

이 저장소의 설치 스크립트는 공식 설치 + Git 확인 + PATH 등록 + 설치 확인까지 한 번에 처리합니다.

### Windows

**PowerShell**을 열고 실행합니다. (명령 프롬프트 `cmd`가 아닙니다. 시작 메뉴에서 "PowerShell" 검색)

```powershell
irm https://raw.githubusercontent.com/wnghdcjfe/sch-lecture/main/install-windows.ps1 | iex
```

### macOS / Linux / WSL

**터미널**을 열고 실행합니다. (`sudo` 를 붙이지 마세요)

```bash
curl -fsSL https://raw.githubusercontent.com/wnghdcjfe/sch-lecture/main/install-mac.sh | bash
```

`[ OK ] 설치 완료: x.x.x (Claude Code)` 가 출력되면 성공입니다. **터미널을 새로 연 뒤** `claude` 를 입력하세요.

---

## 수동 설치

### 목차

1. [Claude Code CLI 설치](#1-claude-code-cli-설치)
2. [설치 확인](#2-설치-확인)
3. [Claude 실행](#3-claude-실행)
4. [자주 발생하는 오류](#4-자주-발생하는-오류)
5. [`claude` 명령어를 찾지 못하는 경우](#5-claude-명령어를-찾지-못하는-경우)
6. [업데이트](#6-업데이트)

---

## 1. Claude Code CLI 설치

### Windows (PowerShell)

```powershell
irm https://claude.ai/install.ps1 | iex
```

### macOS / Linux / WSL (Bash)

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

## 2. 설치 확인

설치가 완료되면 **터미널을 새로 열고** 다음 명령어를 실행합니다.

```bash
claude --version
claude doctor
```

정상적으로 설치되었다면 버전 정보가 출력됩니다.

## 3. Claude 실행

프로젝트 디렉터리로 이동한 후 실행합니다.

```bash
cd my-project
claude
```

> 최초 실행 시 Anthropic 계정 인증이 필요할 수 있습니다.

## 4. 자주 발생하는 오류

| 증상 | 원인 / 해결 |
| --- | --- |
| `'irm'은(는) 내부 또는 외부 명령...이 아닙니다` | `cmd`에서 실행함 → **PowerShell**에서 실행 |
| 오류 후 PowerShell 창이 바로 닫힘 | 공식 스크립트의 `exit` 때문 → 위 **빠른 설치** 스크립트 사용 |
| `SSL/TLS 보안 채널을 만들 수 없습니다` | 구형 Windows TLS 설정 → 빠른 설치 스크립트가 TLS 1.2를 자동 적용 |
| `Claude Code on Windows requires git-bash` | Git 미설치 → [Git for Windows](https://git-scm.com/download/win) 설치 (빠른 설치 스크립트는 winget으로 자동 설치) |
| `claude: command not found` / `'claude' 용어가 ... 인식되지 않습니다` | PATH 미등록 → 아래 5번 참고, 또는 **터미널 새로 열기** |
| macOS `Permission denied` / root 경로에 설치됨 | `sudo` 로 실행함 → `sudo` 없이 다시 실행 |

## 5. `claude` 명령어를 찾지 못하는 경우

설치는 완료됐지만 명령어가 인식되지 않는다면 **PATH 문제**일 가능성이 높습니다.

### Windows (PowerShell)

현재 세션에서만 적용:

```powershell
$env:Path += ";$env:USERPROFILE\.local\bin"
claude --version
```

사용자 PATH에 영구적으로 추가:

```powershell
$bin = "$env:USERPROFILE\.local\bin"
$path = [Environment]::GetEnvironmentVariable("Path", "User")
if (($path -split ';') -notcontains $bin) {
    [Environment]::SetEnvironmentVariable("Path", "$path;$bin", "User")
}
```

### macOS (zsh)

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
claude --version
```

## 6. 업데이트

```bash
claude update
```

---

## 요약

| 환경 | 권장 설치 방식 |
| --- | --- |
| Windows | PowerShell 네이티브 설치 |
| macOS / Ubuntu | Bash 네이티브 설치 |

설치 후 `claude --version`이 정상 출력되면 CLI 설정이 완료된 것입니다.

## 참고 자료

- [Claude Code 설치 및 설정 (공식 문서)](https://code.claude.com/docs/en/setup)
- [Claude Help Center](https://support.claude.com)
