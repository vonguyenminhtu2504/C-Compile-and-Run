@echo off
title COMPILE AND RUN C++ PROGRAM USING COMMAND PROMPT
setlocal enabledelayedexpansion
cd /d "%~dp0"
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "DEL=%%a"
for %%g in (E C A) do (
    cls
    call :ColorText 03 "WELCOME TO COMPILE AND RUN C++ PROGRAM USING COMMAND PROMPT" & echo;
    call :ColorText 0%%g "This batch file was created by Vo Nguyen Minh Tu. All rights reserved" & echo;
    timeout 1 /nobreak > nul 2>&1
)
<nul set /p "="
g++ --version
if %errorlevel% neq 0 (
    call :ColorText 0E "Setting environment variables . . ." & echo;
    if exist "C:\cygwin64\bin\" ( set "PATH=C:\cygwin64\bin\;%PATH%"
    ) else if exist "C:\cygwin32\bin\" ( set "PATH=C:\cygwin32\bin\;%PATH%"
    ) else if exist "C:\MinGW\bin\" ( set "PATH=C:\MinGW\bin\;%PATH%"
    ) else (
        :askforinstalled
        call :ColorText 0B "Have you installed Cygwin or MinGW (Does your computer have 'cygwin64' or 'cygwin32' or 'MinGW' folder)? (enter 'Y' or 'y' if YES, and 'N' or 'n' if NO or NOT SURE) " & set /p "installed="
        if "!installed!" == "Y" ( goto :askforfolder 
        ) else if "!installed!" == "y" ( goto :askforfolder
        ) else if "!installed!" == "N" ( goto :askfordownload
        ) else if "!installed!" == "n" ( goto :askfordownload
        ) else if "!installed!" == "" (
            call :ColorText 0C "Please enter 'Y' or 'y' if you have installed Cygwin or MinGW (your computer has 'cygwin64' or 'cygwin32' or 'MinGW' folder), and 'N' or 'n' if you haven't installed Cygwin or MinGW (your computer doesn't have 'cygwin64' or 'cygwin32' or 'MinGW' folder) or if you are not sure about that" & echo 
            goto :askforinstalled
        ) else (
            call :ColorText 0C "Invalid character. Please enter 'Y' or 'y' if you have installed Cygwin or MinGW (your computer has 'cygwin64' or 'cygwin32' or 'MinGW' folder), and 'N' or 'n' if you haven't installed Cygwin or MinGW (your computer doesn't have 'cygwin64' or 'cygwin32' or 'MinGW' folder) or if you are not sure about that" & echo 
            goto :askforinstalled
        )
        :askforfolder
        <nul set /p "=Do you remember where the 'cygwin64' or 'cygwin32' or 'MinGW' folder is? (enter 'Y' or 'y' if YES, and 'N' or 'n' if NO) " & set /p "remember="
        if "!remember!" == "Y" ( goto :choosefolder
        ) else if "!remember!" == "y" ( goto :choosefolder
        ) else if "!remember!" == "N" ( goto :findpath
        ) else if "!remember!" == "n" ( goto :findpath
        ) else if "!remember!" == "" (
            call :ColorText 0C "Please enter 'Y' or 'y' if you remember where the 'cygwin64' or 'cygwin32' or 'MinGW' folder is, and 'N' or 'n' if you don't remember where the 'cygwin64' or 'cygwin32' or 'MinGW' folder is" & echo 
            goto :askforfolder
        ) else (
            call :ColorText 0C "Invalid character. Please enter 'Y' or 'y' if you remember, and 'N' or 'n' if you don't remember" & echo 
            goto :askforfolder
        )

        :choosefolder
        call :ColorText 0D "Please choose folder named "cygwin64" or "cygwin32" or "MinGW" & echo;
        timeout 2 /nobreak >nul 2>&1
        set "psCommand="(new-object -COM 'Shell.Application')^
		.BrowseForFolder(0,'Please choose a folder.',0,0).self.path""
		for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"
        if "!folder!" == "" (
            call :ColorText 0C "YOU HAVEN'T CHOOSEN ANY FOLDER" & echo 
            goto :chooseagain
        ) else echo You chose !folder!
        if exist "!folder!\bin\" (
            set "PATH=!folder!\bin\;%PATH%"
            g++ --version
            if !errorlevel! neq 0 (
            call :ColorText 0C "YOU HAVE CHOOSEN AN INVALID FOLDER" & echo 
            goto :chooseagain
            ) else goto :complete
        ) else (
            call :ColorText 0C "YOU HAVE CHOOSEN AN INVALID FOLDER" & echo;
            goto :chooseagain
        )
        
        :chooseagain
        <nul set /p "=Would you like to choose again? (enter 'Y' or 'y' if YES, and 'N' or 'n' if NO) " & set /p "again="
        if "!again!" == "Y" ( goto :choosefolder
        ) else if "!again!" == "y" ( goto :choosefolder
        ) else if "!again!" == "N" ( goto :findpath
        ) else if "!again!" == "n" ( goto :findpath
        ) else if "!again!" == "" (
            call :ColorText 0C "Please enter 'Y' or 'y' if you want to choose again, and 'N' or 'n' if you don't want to choose again" & echo 
            goto :chooseagain
        ) else (
            call :ColorText 0C "Invalid character. Please enter 'Y' or 'y' if you want to choose again, and 'N' or 'n' if you don't want to choose again" & echo 
            goto :chooseagain
        )
        
        :findpath
        call :ColorText 03 "Prepare to search for compiler . . ." & echo;
        set "label=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
            for %%g in (!label!) do (
                if exist "%%g:\" (
                    call :ColorText 0D "Searching in drive %%g: . . ." & echo;
                    cd /d %%g:\
                    for /f "usebackq delims=" %%g in (`dir /b /s /ad ^| findstr /e "\cygwin64"`) do (
                        set "PATH=%%g\bin\;%PATH%
                        g++ --version
                        if !errorlevel! equ 0 (
                            call :ColorText 0A "COMPILATION ENVIRONMENT FOUND" & echo;
                            cd /d "%~dp0" & goto :complete
                        )
                    )
                    for /f "usebackq delims=" %%g in (`dir /b /s /ad ^| findstr /e "\cygwin32"`) do (
                        set "PATH=%%g\bin\;%PATH%
                        g++ --version
                        if !errorlevel! equ 0 (
                            call :ColorText 0A "COMPILATION ENVIRONMENT FOUND" & echo;
                            cd /d "%~dp0" & goto :complete
                        )
                    )
                    for /f "usebackq delims=" %%g in (`dir /b /s /ad ^| findstr /e "\MinGW"`) do (
                        set "PATH=%%g\bin\;%PATH%
                        g++ --version
                        if !errorlevel! equ 0 (
                            call :ColorText 0A "COMPILATION ENVIRONMENT FOUND" & echo;
                            cd /d "%~dp0" & goto :complete
                        )
                    )
                )
            )
        call :ColorText 0C "COMPILATION ENVIRONMENT NOT FOUND" & echo 

        :askfordownload
        call :ColorText 0E "Would you like to download the compiler now? (enter 'Y' or 'y' if YES, and 'N' or 'n' if NO) " & set /p "download="
        if "!download!" == "Y" ( goto :askwhich
        ) else if "!download!" == "y" ( goto :askwhich
        ) else if "!download!" == "N" ( goto :nodownload
        ) else if "!download!" == "n" ( goto :nodownload
        ) else if "!download!" == "" (
            call :ColorText 0C "Please enter 'Y' or 'y' if you want to download the compiler now, and 'N' or 'n' if you want to download the compiler later" & echo 
            goto :askfordownload
        ) else (
            call :ColorText 0C "Invalid character. Please enter 'Y' or 'y' if you want to download the compiler now, and 'N' or 'n' if you don't want to download the compiler later" & echo 
            goto :askfordownload
        )
        
        :askwhich
        call :ColorText 09 "Which compiler would you like to install? & echo;
        echo 1. Cygwin
        echo 2. MinGW
        <nul set /p "=Please enter 1 to download Cygwin, and 2 to download MinGW" & set /p "which="
        if "!which!" == "1" (
        ) else if "!which!" == "2" (
        ) else if "!which!" == "" (
            call :ColorText 0C "Please enter 1 to download Cygwin, and 2 to download MinGW" & echo 
            goto :askwhich
        ) else (
            call :ColorText 0C "Invalid character. Please enter 1 to download Cygwin, and 2 to download MinGW" & echo 
            goto :askwhich
        )
        :nodownload
        call :ColorText 0C "This program need a compiler to compile .cpp files. You can download it manually by yourself, then open this program again"
        goto :end
    )
:complete
call :ColorText 0A "THE COMPILATION ENVIRONMENT HAS BEEN SET"
)
if exist "*.cpp" (
    for %%g in (*.cpp) do (
        call :ColorText 09 "Prepare to compile source file %%g ..." & echo;
        set name=%%g
        set name=!name:~0,-4!
        if exist "!name!.exe" (
            del "!name!.exe"
            if not exist "!name!.exe" ( call :ColorText 0D "Old file !name!.exe has been deleted" & echo;
            ) else call :ColorText 0C "CANNOT DELETE FILE !name!.exe. PLEASE CLOSE ANY PROGRAM OPENING THIS FILE THEN TRY AGAIN" & echo; & goto :end
        )
        set /a count=0
        call :ColorText 0B "Compiling source file !name!.cpp . . . Please wait . . ." & echo;
        g++ -o "!name!" "!name!.cpp" -std=c++11 -DUSE_SOME_DEF
        if exist "!name!.exe" (
            call :ColorText 0A "SOURCE FILE !name!.cpp HAS BEEN COMPILED SUCCESSFULLY" & echo;
            call :ColorText 09 "Prepare to run !name!.exe . . ." & echo;

            :ask
            <nul set /p "=Does this program need an input file? (enter 'Y' or 'y' if YES, and 'N' or 'n' if NO) " & set /p "bool="
            if "!bool!" == "Y" ( goto :case1
            ) else if "!bool!" == "y" ( goto :case1
            ) else if "!bool!" == "N" ( goto :case2
            ) else if "!bool!" == "n" ( goto :case2
            ) else if "!bool!" == "" (
                call :ColorText 0C "Please enter 'Y' or 'y' if this program needs an input file, and 'N' or 'n' if this program doesn't need an input file" & echo 
                goto :ask
            ) else (
                call :ColorText 0C "Invalid character. Please enter 'Y' or 'y' if this program needs an input file, and 'N' or 'n' if this program doesn't need an input file" & echo 
                goto :ask
            )

            :case1
            if exist "*.txt" (
                if exist "!name!.exe.*.stackdump" del "!name!.exe.*.stackdump"
                call :ColorText 0A "Running !name!.exe with an input file . . ." & echo;
                    for %%h in (*.txt) do (
                        call :ColorText 0E "Input file: " & echo %%h
                        call :ColorText 03 "Contents of input file:" & echo;
                        type "%%h" & echo;
                        call :ColorText 03 "OUTPUT:" & echo;
                        "!name!.exe" "%%h"
                        set /a exitcode=!ERRORLEVEL!
                        if exist "!name!.exe.stackdump" (
                            ren "!name!.exe.stackdump" "!name!.exe.%%h.stackdump"
                            set /p error=<"!name!.exe.%%h.stackdump"
                            Set "sub= at rip="
                            set "temp=!error!" & SET pos=0
                            :loop
                            echo !temp!|FINDSTR /b /c:"!sub!" >NUL
                            IF ERRORLEVEL 1 (
                                SET temp=!temp:~1!
                                SET /a pos+=1
                                IF DEFINED temp GOTO loop
                                SET pos=0
                            )
                            set error=!error:~0,%pos%!
                            call :ColorText 0C "ERROR: "
                            echo !error!
                        )
                        if !exitcode! equ 0 ( call :ColorText 0A "Program finished with exit code 0" & echo;
                        ) else (
                            call :ColorText 0C "Program finished with exit code !exitcode!" & echo;
                            <nul set /p "=Would you like to search on Google for information about this error? (enter 'Y' or 'y' if YES) "
                            set /p "open="
                            if "!open!" == "Y" start "" "https://www.google.com.vn/search?&q=!error!"
                            if "!open!" == "y" start "" "https://www.google.com.vn/search?&q=!error!"
                        )
                        echo;
                        )
                        goto :end
            ) else (
                call :ColorText 0C "INPUT FILE NOT FOUND. THIS BATCH FILE ONLY ACCEPTS INPUT FILES WITH THE .TXT EXTENSION" & echo;
                echo Move all of your input files to the same directory as this batch file, or change the extension of your input files, then try again & goto :end
            )

            :case2
                call :ColorText 0A "Running !name!.exe without any input file . . ." & echo;
                call :ColorText 03 "OUTPUT:" & echo;
                "!name!.exe"
                set /a exitcode=!ERRORLEVEL!
                echo;
                if !exitcode! equ 0 (
                call :ColorText 0A "Program finished with exit code 0" & echo;
                ) else call :ColorText 0C "Program finished with exit code !exitcode!" & echo;
                goto :end

        ) else call :ColorText 0C "FAILED TO COMPILE SOURCE FILE !name!.cpp" & echo; & goto :end
    )
) else (
    call :ColorText 0C "SOURCE FILE NOT FOUND. THIS BATCH FILE ONLY ACCEPTS SOURCE FILES WITH THE .CPP EXTENSION" & echo;
    echo Move or copy this batch file to the directory of your source files, then try again
    echo If your program needs an input file, remember to put all of your input files to the same directory as your source files
)

:end
<nul set /p "="
PAUSE
echo You are about to exit this batch file
call :ColorText 0B "Would you like to make friends with me on Facebook? (enter 'Y' or 'y' if YES) " & set /p "friendly="
if "!friendly!" == "Y" start "" "https://www.facebook.com/vonguyenminhtu2504/"
if "!friendly!" == "y" start "" "https://www.facebook.com/vonguyenminhtu2504/"
set id = 8 9 A B C D E F
:bye

timeout 3 /nobreak >nul 2>&1
EXIT /B

:ColorText
<nul > ~ set /p ".=."
set "param=^%~2" !
set "param=!param:"=\"!"
findstr /p /A:%1 "." "!param!\..\~" nul
<nul set /p ".=%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%"
del ~ > nul 2>&1