@echo off
echo deploy embedded python
call init.bat 3.11.9
echo build requrements
call start_build
call env.bat
for %%F in (*.whl) do pip install "%%F"
pip install open-webui
(
    echo @echo off
    echo call env
    echo open-webui serve
) > start_owebui.bat