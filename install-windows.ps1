# Claude Code 설치 스크립트 (Windows PowerShell 5.1 / PowerShell 7)
# 사용법 (PowerShell에서 실행):
#   irm https://raw.githubusercontent.com/wnghdcjfe/sch-lecture/main/install-windows.ps1 | iex
# 또는 파일을 받은 경우:
#   Get-Content .\install-windows.ps1 -Raw -Encoding UTF8 | iex

& {
    $ErrorActionPreference = 'Stop'
    $ProgressPreference = 'SilentlyContinue'

    function Info($m) { Write-Host "[INFO] $m" -ForegroundColor Cyan }
    function Ok($m)   { Write-Host "[ OK ] $m" -ForegroundColor Green }
    function Warn($m) { Write-Host "[WARN] $m" -ForegroundColor Yellow }
    function Fail($m) { Write-Host "[FAIL] $m" -ForegroundColor Red }

    # 1. 환경 확인
    if (-not [Environment]::Is64BitOperatingSystem) {
        Fail "64비트 Windows만 지원합니다."
        return
    }
    if (-not [Environment]::Is64BitProcess) {
        Warn "32비트 PowerShell(x86)에서 실행 중입니다. 64비트 PowerShell에서 실행하세요."
        return
    }
    Info "PowerShell $($PSVersionTable.PSVersion)"

    # 구형 Windows에서 HTTPS 다운로드 실패 방지 (TLS 1.2 강제)
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

    # 2. Git for Windows 확인 (Claude Code가 Git Bash를 사용)
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        if (Get-Command winget -ErrorAction SilentlyContinue) {
            Info "Git이 없어 winget으로 설치합니다..."
            winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements
            $gitCmd = "$env:ProgramFiles\Git\cmd"
            if (Test-Path $gitCmd) { $env:Path = "$gitCmd;$env:Path" }
        } else {
            Warn "Git이 설치되어 있지 않습니다. https://git-scm.com/download/win 에서 설치를 권장합니다."
        }
    } else {
        Ok "Git 확인: $(git --version)"
    }

    # 3. 공식 설치 스크립트 실행
    #    irm | iex 로 직접 실행하면 실패 시 'exit' 때문에 창이 닫히므로
    #    임시 파일로 받아 별도 프로세스에서 실행한다.
    if ($env:CLAUDE_SKIP_INSTALL -ne '1') {
        $tmp = Join-Path $env:TEMP "claude-install-$([guid]::NewGuid()).ps1"
        try {
            Info "공식 설치 스크립트 다운로드..."
            Invoke-WebRequest -Uri 'https://claude.ai/install.ps1' -OutFile $tmp -UseBasicParsing
            Info "설치 중... (1~2분 소요)"
            & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $tmp
            $code = $LASTEXITCODE
        } catch {
            Fail "다운로드 실패: $($_.Exception.Message)"
            Warn "네트워크/프록시/백신 설정을 확인하세요."
            return
        } finally {
            Remove-Item $tmp -Force -ErrorAction SilentlyContinue
        }
        if ($code -ne 0) {
            Fail "설치 실패 (exit code $code). 위 오류 메시지를 확인하세요."
            return
        }
    }

    # 4. PATH 등록 (%USERPROFILE%\.local\bin)
    $bin = Join-Path $env:USERPROFILE '.local\bin'
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    if (-not $userPath) { $userPath = '' }
    if (($userPath -split ';') -notcontains $bin) {
        $newPath = (($userPath.TrimEnd(';')), $bin) -join ';'
        [Environment]::SetEnvironmentVariable('Path', $newPath.TrimStart(';'), 'User')
        Info "사용자 PATH에 추가: $bin"
    }
    if (($env:Path -split ';') -notcontains $bin) { $env:Path = "$env:Path;$bin" }

    # 5. 설치 확인
    if (Get-Command claude -ErrorAction SilentlyContinue) {
        Ok "설치 완료: $(claude --version)"
        Write-Host ""
        Write-Host "이제 프로젝트 폴더에서 'claude' 를 입력하세요. (다른 터미널은 새로 열어야 적용됩니다)"
    } else {
        Fail "claude 명령을 찾을 수 없습니다. $bin 폴더를 확인하세요."
    }
}
