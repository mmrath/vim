@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%

@set APP_PATH=%~dp0

IF NOT EXIST "%APP_PATH%" (
    echo "%APP_PATH% directory does not exist. Exiting installation"
) ELSE (
    echo "Updating installation"
    chdir /d "%APP_PATH%"
    rem call git pull
)

call mklink "%HOME%\.vimrc" "%APP_PATH%\.vimrc"
call mklink /J "%HOME%\.vim" "%APP_PATH%\.vim"

@set DEIN_PATH="%APP_PATH%\.vim\repos\github.com\Shougo\dein.vim"
IF NOT EXIST %DEIN_PATH% (
    call mkdir %DEIN_PATH%
)

IF NOT EXIST %DEIN_PATH%\.git (
    call git clone https://github.com/Shougo/dein.vim %DEIN_PATH%
) ELSE (
  call cd %DEIN_PATH%
  call git pull
  call cd %APP_PATH%
)

call vim +NeoBundleInstall +NeoBundleClean +qall
