# Claude Code CLI 설치 가이드

Claude Code CLI를 설치하면 터미널에서 `claude` 명령어를 바로 사용할 수 있습니다.

현재 공식 권장 설치 방식은 **네이티브 설치(Native Install)** 이며, Node.js나 npm 없이도 설치할 수 있습니다.

## 목차

1. [Claude Code CLI 설치](#1-claude-code-cli-설치)
2. [설치 확인](#2-설치-확인)
3. [Claude 실행](#3-claude-실행)
4. [`claude` 명령어를 찾지 못하는 경우](#4-claude-명령어를-찾지-못하는-경우)
5. [업데이트](#5-업데이트)

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

## 4. `claude` 명령어를 찾지 못하는 경우

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

## 5. 업데이트

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
