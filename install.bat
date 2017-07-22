@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%

@set APP_PATH=%~dp0

git pull

call mklink /J "%HOME%\vimfiles" "%APP_PATH%"

@set DEIN_PATH="%APP_PATH%\bundle\repos\github.com\Shougo\dein.vim"
IF NOT EXIST %DEIN_PATH% (
    call mkdir %DEIN_PATH%
)

IF NOT EXIST %DEIN_PATH%\.git (
    call git clone https://github.com/Shougo/dein.vim %DEIN_PATH%
) ELSE (
  call git -C %DEIN_PATH% pull
)

echo "Update plugins using -  :call dein#install()"