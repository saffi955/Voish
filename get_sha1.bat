@echo off
echo Setting generic JAVA_HOME...
set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
echo Navigate to project...
cd /d "%~dp0android"
echo Running signingReport (this may take a while to download Gradle if not cached)...
call .\gradlew.bat signingReport
echo.
echo ========================================================
echo LOOK FOR "SHA1" under "Variant: debug" or "Task: :app:signingReport"
echo COPY THAT SHA1 AND PASTE IT IN FIREBASE CONSOLE > Project Settings > Android App > Add Fingerprint
echo ========================================================
pause
