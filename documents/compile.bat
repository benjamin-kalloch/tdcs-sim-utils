@ECHO OFF

REM ********* Main function ****************
pdflatex -output-directory output main.tex

CALL 	:continue_prompt

IF [%ERRORLEVEL%] == [1] GOTO :halt


bibtex output/main.aux

CALL :continue_prompt
IF [%ERRORLEVEL%] == [1] GOTO :halt

pdflatex -output-directory output main.tex

pdflatex -output-directory output main.tex

GOTO :halt

REM ********* Helper function ****************
:continue_prompt
REM SETLOCAL is neccessary in order to avoid setting USERINPUT as a global environment-variable
SETLOCAL
SET /p USERINPUT=">>>>>>PROCEED?"
IF [%USERINPUT%] == [] EXIT /B 0
EXIT /B 1
ENDLOCAL


REM ********* Exit label ****************
:halt
EXIT /B 0
