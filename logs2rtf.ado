cap program drop logs2rtf
program define logs2rtf
	syntax  , [src(string ) dest(string ) red(integer 0) green(integer 0) blue(integer 0) fs(integer 8) ]
	
	local fs = `fs'*2
	
	if "`src'" == "" {
		local src "`c(pwd)'"
	}
	
	if "`dest'" == "" {
		local dest "`c(pwd)'"
	}
	
	cap file close myFile
	file open myFile using "`c(pwd)'\lrtfscript.vbs", write replace
	
	file write myFile "Const ForReading = 1"_n _n
	
	file write myFile `"Dim oShell : Set oShell = CreateObject("WScript.Shell")"'_n
	file write myFile `"oShell.CurrentDirectory = "`c(pwd)'""'_n _n
	
	file write myFile `"Set objFSO = CreateObject("Scripting.FileSystemObject")"'_n
	file write myFile `"Set objFolder = objFSO.GetFolder("`src'")"'_n
	file write myFile `"strStartText = "*@s""'_n
	file write myFile `"strEndText = "*@e""'_n _n
	
	file write myFile `"Set colFiles = objFolder.Files"'_n
	file write myFile `"For Each objFile in colFiles"'_n 
	file write myFile _tab`"If instr(objFile.Name,".log") > 0 Then"'_n
	file write myFile _tab _tab`"strFileName = replace(objFile.Name,".log",".rtf") "'_n
	file write myFile _tab _tab`"strFileName2 = objFile.Name "'_n
	file write myFile _tab _tab`"Set objFSO = CreateObject("Scripting.FileSystemObject") "'_n
	file write myFile _tab _tab`"Set objFile = objFSO.OpenTextFile("logs\" & strFileName2, ForReading) "'_n _n
	
	file write myFile _tab _tab`"strContents = objFile.ReadAll "'_n _n
	
	file write myFile _tab _tab`"intStart = InStr(strContents, strStartText) "'_n
	file write myFile _tab _tab`"intStart = intStart + Len(strStartText) + 1 "'_n
	file write myFile _tab _tab`"intArgsEnd = InStr(strContents, "}") "'_n 
	file write myFile _tab _tab`"intArgsCharacters = intArgsEnd - intStart"' _n
	
	file write myFile _tab _tab`"'Wscript.Echo intStart"'_n
	file write myFile _tab _tab`"'Wscript.Echo intArgsEnd"'_n
	file write myFile _tab _tab`"'Wscript.Echo intArgsCharacters"'_n
	
	file write myFile _tab _tab`"echo = "FALSE""'_n
	file write myFile _tab _tab`"results = "TRUE""'_n
	
	file write myFile _tab _tab`"strArgs = Mid(strContents, intStart, intArgsCharacters) "'_n
	file write myFile _tab _tab`"Args = Split(strArgs,",",-1) "'_n
	file write myFile _tab _tab`"for each a in Args"'_n
	file write myFile _tab _tab _tab`"arg = Split(a,"=",-1)"'_n
	
	file write myFile _tab _tab _tab`"If instr(a,"echo") > 0 Then"'_n
	file write myFile _tab _tab _tab _tab`"echo = arg(1)"'_n
	file write myFile _tab _tab _tab`"End If"'_n
	
	file write myFile _tab _tab _tab`"If instr(a,"results") > 0 Then"'_n
	file write myFile _tab _tab _tab _tab`"results = arg(1)"'_n
	file write myFile _tab _tab _tab`"End If"'_n
	
	file write myFile _tab _tab`"next"'_n
	
	file write myFile _tab _tab`"intEnd = InStr(strContents, strEndText) "'_n
	
	file write myFile _tab _tab`"if intArgsEnd > 0 Then "'_n
	file write myFile _tab _tab _tab`"intStart = intArgsEnd"'_n
	file write myFile _tab _tab`"End If"'_n
	
	file write myFile _tab _tab`"intCharacters = intEnd - intStart"' _n
	
	file write myFile _tab _tab`"strText = Mid(strContents, intStart + 3, intCharacters) "'_n
	
	file write myFile _tab _tab`"lines = Split(strText,VbCrLf,-1)"'_n
	
	file write myFile _tab _tab`"newText = """'_n
	
	file write myFile _tab _tab`"for each l in lines"'_n
	file write myFile _tab _tab _tab`"fc = Left(l,1)"'_n
	
	file write myFile _tab _tab _tab`"If echo = "FALSE" Then"'_n
	file write myFile _tab _tab _tab _tab`"If fc = "." Then"'_n
	file write myFile _tab _tab _tab _tab`"l = "blank""'_n
	file write myFile _tab _tab _tab _tab`"End If"'_n
	file write myFile _tab _tab _tab`"End If"'_n
	
	file write myFile _tab _tab _tab`"If results = "FALSE" Then"'_n
	file write myFile _tab _tab _tab _tab`"If NOT fc = "." Then"'_n
	file write myFile _tab _tab _tab _tab`"l = "blank""'_n
	file write myFile _tab _tab _tab _tab`"End If"'_n
	file write myFile _tab _tab _tab`"End If"'_n
	
	file write myFile _tab _tab _tab`"If NOT l = "blank" Then"'_n
	file write myFile _tab _tab _tab`"newText = newText + l + VbCrLf"'_n
	file write myFile _tab _tab _tab`"End If"'_n
	
	file write myFile _tab _tab`"Next"'_n
	
	file write myFile _tab _tab`"'Wscript.Echo newText"'_n
	
	file write myFile _tab _tab`"strText = newText"'_n
	
	file write myFile _tab _tab`"Set newobjFile = objFSO.CreateTextFile("`dest'" & strFileName) "'_n
	file write myFile _tab _tab`"strText = replace(strText,VbCrLf,"\line ") "'_n

	file write myFile _tab _tab `"newobjFile.Write "{\rtf1\utf-8\deff0{\fonttbl{\f0 courier;}}{\colortbl\red`red'\green0\blue0;\red`red'\green`green'\blue`blue';}\cf1\fs`fs'" & strText & "}" "' _n

	file write myFile _tab _tab`"objFile.Close "'_n
	file write myFile _tab `"End If "'_n
	file write myFile `"Next"'_n

	
	file close myFile
	
	shell lrtfscript.vbs

end
