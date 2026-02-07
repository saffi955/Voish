@echo off
set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
set "KEYTOOL=%JAVA_HOME%\bin\keytool.exe"
set "KEYSTORE_DIR=%USERPROFILE%\.android"
set "KEYSTORE_PATH=%KEYSTORE_DIR%\debug.keystore"

echo Checking for debug keystore...

if not exist "%KEYSTORE_DIR%" (
    echo Creating .android directory...
    mkdir "%KEYSTORE_DIR%"
)

if not exist "%KEYSTORE_PATH%" (
    echo Debug keystore missing at %KEYSTORE_PATH%
    echo Generating new debug keystore...
    "%KEYTOOL%" -genkey -v -keystore "%KEYSTORE_PATH%" -storepass android -alias androiddebugkey -keypass android -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=Android Debug,O=Android,C=US"
    if %ERRORLEVEL% NEQ 0 (
        echo Failed to generate keystore.
        pause
        exit /b
    )
    echo Keystore generated successfully.
) else (
    echo Debug keystore already exists.
)

echo.
echo Running signingReport...
cd /d "%~dp0android"
call .\gradlew.bat signingReport

echo.
echo ========================================================
echo SUCCESS!
echo.
echo LOOK FOR "SHA1" ABOVE under "Task: :app:signingReport" (Variant: debug)
echo It will look like: 5E:8F:16:06:2E:A3:CD:2C:4A:0D:54:78:76:BA:A6:F3:8C:AB:CD:EF
echo.
echo 1. COPY that SHA1 string.
echo 2. Go to Firebase Console > Project Settings > General > Your Android App.
echo 3. Click "Add fingerprint" and paste it there.
echo 4. Restart your app.
echo ========================================================
pause
