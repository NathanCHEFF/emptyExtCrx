@echo off
set /p Input=Enter Extension name:

echo Chose action :
echo [1] - Create Extension
echo [2] - Pack to .crx (!needs chrome!)

set /p Action=Choose what you want 

if %Action%==1 (
md %Input%
break>"%Input%/background.js"
break>"%Input%/injected.js"
break>"%Input%/manifest.json"

echo console.log("%Input% download")                                  >> "%Input%/background.js"
echo var script = document.createElement("script");           >> "%Input%/background.js"
echo script.src = chrome.extension.getURL('injected.js');     >> "%Input%/background.js"
echo document.querySelector('head').appendChild(script);      >> "%Input%/background.js"
echo //document.querySelector("body").addEventListener('load', injected_main(), false); >> "%Input%/background.js"
echo document.getElementsByTagName("body")[0].setAttribute("onLoad", "injected_main();"); >> "%Input%/background.js"

echo //injected_main();                 >> "%Input%/injected.js"
echo :                                  >> "%Input%/injected.js"
echo function injected_main(){          >> "%Input%/injected.js"
echo   console.log('injected!');        >> "%Input%/injected.js"
echo }                                  >> "%Input%/injected.js"

echo {                                  >> "%Input%/manifest.json"
echo   "name": "%Input%",               >> "%Input%/manifest.json"
echo   "version": "1.0",                >> "%Input%/manifest.json"
echo   "manifest_version": 2,           >> "%Input%/manifest.json"
echo   "content_scripts": [             >> "%Input%/manifest.json"
echo     {                              >> "%Input%/manifest.json"
echo       "matches": [ "*://*/*" ],    >> "%Input%/manifest.json"
echo       "js": [ "background.js" ],   >> "%Input%/manifest.json"
echo       "run_at": "document_end"     >> "%Input%/manifest.json"
echo     }                              >> "%Input%/manifest.json"
echo   ],                               >> "%Input%/manifest.json"
echo   "web_accessible_resources": [    >> "%Input%/manifest.json"
echo     "injected.js"                  >> "%Input%/manifest.json"
echo   ]                                >> "%Input%/manifest.json"
echo }                                  >> "%Input%/manifest.json"

echo Files create
)
if %Action%==2 (
  chrome.exe --pack-extension=%Input% --pack-extension-key=%Input%\%Input%.pem
)
pause
