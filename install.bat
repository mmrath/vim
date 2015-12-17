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

IF NOT EXIST "%APP_PATH%\.vim\bundle" (
    call mkdir "%APP_PATH%\.vim\bundle"
)

IF NOT EXIST "%HOME%/.vim/bundle/Vundle.vim" (
    call git clone https://github.com/VundleVim/Vundle.vim.git %APP_PATH%/.vim/bundle/Vundle.vim
) ELSE (
  call cd "%HOME%/.vim/bundle/Vundle.vim"
  call git pull
  call cd %APP_PATH%
)

call vim +PluginInstall +PluginClean +qall