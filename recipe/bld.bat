:: This batch file is based on those from the scipy and numpy feedstocks. (Thank you!)
@echo on
setlocal enabledelayedexpansion

set "BUILD_DIR=build"
mkdir %BUILD_DIR%

:: -wnx flags mean: --wheel --no-isolation --skip-dependency-check
%PYTHON% -m build -w -n -x ^
    -Cbuilddir=%BUILD_DIR% ^
    -Cinstall-args=--tags=runtime,python-runtime,devel ^
    -Csetup-args=-Dcpp_std=c++11 ^
    -Csetup-args=-Dfortran_std=none ^
    -Csetup-args=-Duse-g77-abi=false
if %ERRORLEVEL% neq 0 (type %BUILD_DIR%\meson-logs\meson-log.txt && exit 1)

:: `pip install dist\*.whl` does not work on windows,
:: so use a loop; there's only one wheel in dist/ anyway
for /f %%f in ('dir /b /S .\dist') do (
    %PYTHON% -m pip install %%f -vvv
    if %ERRORLEVEL% neq 0 exit 1
)
