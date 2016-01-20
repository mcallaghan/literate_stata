cap program drop logs2rtf
program define logs2rtf
	syntax  ,src(string) dest(string) [ red(integer 0) green(integer 0) blue(integer 0) fs(integer 8) ]
	
	local fs = `fs'*2
	
	cap file close myFile
	file open myFile using "`c(pwd)'\lrtfscript.vbs", write replace
	
	file write myFile "Const ForReading = 1"_n _n
	
	file write myFile `"Dim oShell : Set oShell = CreateObject("WScript.Shell")"'_n
	file write myFile `"oShell.CurrentDirectory = "`c(pwd)'""'_n _n
	
	file write myFile `"Set objFSO = CreateObject("Scripting.FileSystemObject")"'_n
	file write myFile `"Set objFolder = objFSO.GetFolder("`src'")"'_n
	file write myFile `"strStartText = "*@*lstart""'_n
	file write myFile `"strEndText = "*@*lend""'_n _n
	
	file write myFile `"Set colFiles = objFolder.Files"'_n
	file write myFile `"For Each objFile in colFiles"'_n 
	file write myFile _tab`"If instr(objFile.Name,".log") > 0 Then"'_n
	file write myFile _tab _tab`"strFileName = replace(objFile.Name,".log",".rtf") "'_n
	file write myFile _tab _tab`"strFileName2 = objFile.Name "'_n
	file write myFile _tab _tab`"Set objFSO = CreateObject("Scripting.FileSystemObject") "'_n
	file write myFile _tab _tab`"Set objFile = objFSO.OpenTextFile("logs\" & strFileName2, ForReading) "'_n _n
	
	file write myFile _tab _tab`"strContents = objFile.ReadAll "'_n _n
	
	file write myFile _tab _tab`"intStart = InStr(strContents, strStartText) "'_n
	file write myFile _tab _tab`"intStart = intStart + Len(strStartText) "'_n
	
	file write myFile _tab _tab`"intEnd = InStr(strContents, strEndText) "'_n 
	
	file write myFile _tab _tab`"intCharacters = intEnd - intStart - 8"' _n
	
	file write myFile _tab _tab`"strText = Mid(strContents, intStart + 3, intCharacters) "'_n
	file write myFile _tab _tab`"Set newobjFile = objFSO.CreateTextFile("`dest'" & strFileName) "'_n
	file write myFile _tab _tab`"strText = replace(strText,VbCrLf,"\line") "'_n

	file write myFile _tab _tab `"newobjFile.Write "{\rtf1\utf-8\deff0{\fonttbl{\f0 courier;}}" & VbCrLf & " {\colortbl\red`red'\green0\blue0;\red`red'\green`green'\blue`blue';} \cf1 \fs`fs'" & strText & "}" "' _n

	file write myFile _tab _tab`"objFile.Close "'_n
	file write myFile _tab `"End If "'_n
	file write myFile `"Next"'_n

	
	file close myFile
	
	shell lrtfscript.vbs

end
