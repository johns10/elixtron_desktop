@echo off
setlocal enabledelayedexpansion

set var=%1
@set var=%var:~12,-1%
@set var=%var:~0,-1%
@echo %var%

pushd .
cd "%~dp0\.."
set RELEASE_ROOT=%cd%
popd

if not defined RELEASE_NAME (set RELEASE_NAME=demo)
if not defined RELEASE_VSN (for /f "tokens=1,2" %%K in ('type "!RELEASE_ROOT!\releases\start_erl.data"') do (set ERTS_VSN=%%K) && (set RELEASE_VSN=%%L))
if not defined RELEASE_MODE (set RELEASE_MODE=embedded)
set RELEASE_COMMAND=%~1
set REL_VSN_DIR=!RELEASE_ROOT!\releases\!RELEASE_VSN!
call "!REL_VSN_DIR!\env.bat"

if not defined RELEASE_COOKIE (set /p RELEASE_COOKIE=<!RELEASE_ROOT!\releases\COOKIE)
if not defined RELEASE_NODE (set RELEASE_NODE=!RELEASE_NAME!)
if not defined RELEASE_TMP (set RELEASE_TMP=!RELEASE_ROOT!\tmp)
if not defined RELEASE_VM_ARGS (set RELEASE_VM_ARGS=!REL_VSN_DIR!\vm.args)
if not defined RELEASE_DISTRIBUTION (set RELEASE_DISTRIBUTION=sname)
if not defined RELEASE_BOOT_SCRIPT (set RELEASE_BOOT_SCRIPT=start)
if not defined RELEASE_BOOT_SCRIPT_CLEAN (set RELEASE_BOOT_SCRIPT_CLEAN=start_clean)
if not defined RELEASE_SYS_CONFIG (set RELEASE_SYS_CONFIG=!REL_VSN_DIR!\sys)

if not "!REL_GOTO!" == "" (
  findstr "RUNTIME_CONFIG=true" "!RELEASE_SYS_CONFIG!.config" >nul 2>&1 && (
    set DEFAULT_SYS_CONFIG=!RELEASE_SYS_CONFIG!
    for /f "skip=1" %%X in ('wmic os get localdatetime') do if not defined TIMESTAMP set TIMESTAMP=%%X
    set RELEASE_SYS_CONFIG=!RELEASE_TMP!\!RELEASE_NAME!-!RELEASE_VSN!-!TIMESTAMP:~0,11!-!RANDOM!.runtime
    mkdir "!RELEASE_TMP!" >nul 2>&1
    copy /y "!DEFAULT_SYS_CONFIG!.config" "!RELEASE_SYS_CONFIG!.config" >nul || (
      echo Cannot start release because it could not write to "!RELEASE_SYS_CONFIG!.config"
      goto end
    )
  )

  goto !REL_GOTO!
)

set "REL_RPC=!var!"

pause

goto rpc

:rpc    

if "!RELEASE_DISTRIBUTION!" == "none" (
  set RELEASE_DISTRIBUTION_FLAG=
) else (
  set RELEASE_DISTRIBUTION_FLAG=--!RELEASE_DISTRIBUTION! "rpc-!RANDOM!-!RELEASE_NODE!"
)

"!REL_VSN_DIR!\elixir.bat" ^
  --hidden --cookie "!RELEASE_COOKIE!" ^
  !RELEASE_DISTRIBUTION_FLAG! ^
  --boot "!REL_VSN_DIR!\!RELEASE_BOOT_SCRIPT_CLEAN!" ^
  --boot-var RELEASE_LIB "!RELEASE_ROOT!\lib" ^
  --rpc-eval "!RELEASE_NODE!" "!REL_RPC!"
  
goto end

:end
endlocal
