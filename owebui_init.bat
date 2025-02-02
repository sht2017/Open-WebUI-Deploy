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
    echo set "BASE=%%~dp0embpy\"
    echo powershell -NoProfile -ExecutionPolicy Bypass -Command "$file='%%BASE%%Scripts\open-webui.exe'; $data=[System.IO.File]::ReadAllBytes($file); $lastIndex=-1; for($i=0; $i -lt $data.Length-1; $i++) { if($data[$i] -eq 35 -and $data[$i+1] -eq 33){ $lastIndex=$i } }; if($lastIndex -ge 0){ $end=$lastIndex; while($end -lt $data.Length -and $data[$end] -ne 10 -and $data[$end] -ne 0){ $end++ }; $shebangBytes=$data[$lastIndex..($end-1)]; $shebangStr=[System.Text.Encoding]::ASCII.GetString($shebangBytes); $pattern='#!.*?embpy\\python\.exe'; if($shebangStr -match $pattern){ $newShebang='#!%%BASE%%python.exe'; $replaced=[System.Text.RegularExpressions.Regex]::Replace($shebangStr, $pattern, $newShebang); $newShebangBytes=[System.Text.Encoding]::ASCII.GetBytes($replaced); $newLength=$data.Length - $shebangBytes.Length + $newShebangBytes.Length; $newData=New-Object byte[] $newLength; [Array]::Copy($data, 0, $newData, 0, $lastIndex); [Array]::Copy($newShebangBytes, 0, $newData, $lastIndex, $newShebangBytes.Length); [Array]::Copy($data, $end, $newData, $lastIndex+$newShebangBytes.Length, $data.Length - $end); [System.IO.File]::WriteAllBytes($file, $newData) } }"
    echo open-webui serve
) > start_owebui.bat