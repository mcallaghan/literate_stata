cap program drop logs2rtf
program define logs2rtf
	syntax  , [src(string ) dest(string ) red(integer 0) green(integer 0) blue(integer 0) fs(integer 8) echo(string) results(string)]
	
	local fs = `fs'*2
	
	if "`src'" == "" {
		local src "`c(pwd)'"
	}
	
	if "`dest'" == "" {
		local dest "`c(pwd)'"
	}
	
	if "`echo'" == "" {
		local echo "TRUE"
	}
	
	if "`results'" == "" {
		local results "TRUE"
	}
	
	if c(os) == "Windows" {
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
		file write myFile _tab _tab`"Set objFile = objFSO.OpenTextFile("`src'\"  & strFileName2, ForReading) "'_n _n
		
		file write myFile _tab _tab`"strContents = objFile.ReadAll "'_n _n
		
		file write myFile _tab _tab`"echo = "`echo'""'_n
		file write myFile _tab _tab`"results = "`results'""'_n
		file write myFile _tab _tab`"newText = """'_n
		file write myFile _tab _tab`"write = 0"'_n	
		file write myFile _tab _tab`"lines = Split(strContents,VbCrLf,-1)"'_n
		
		file write myFile _tab _tab`"for each l in lines"'_n _n
		
		
		file write myFile _tab _tab _tab`"If instr(l,strEndText) > 0 Then"'_n
		file write myFile _tab _tab _tab _tab`"write = 0"'_n
		file write myFile _tab _tab _tab`"End If"'_n _n _n

		file write myFile _tab _tab _tab`"If write = 1 Then"'_n
		file write myFile _tab _tab _tab _tab`"fc = Left(l,1)"'_n
		file write myFile _tab _tab _tab _tab`"If instr(echo,"FALSE") > 0 Then"'_n
		file write myFile _tab _tab _tab _tab _tab `"If instr(fc,".") = 1 Then"'_n
		file write myFile _tab _tab _tab _tab _tab `"l = "blank""'_n
		file write myFile _tab _tab _tab _tab _tab `"End If"'_n
		file write myFile _tab _tab _tab _tab`"End If"'_n
		file write myFile _tab _tab _tab _tab`"If instr(results,"FALSE") > 0 Then"'_n
		file write myFile _tab _tab _tab _tab _tab `"If NOT fc = "." Then"'_n
		file write myFile _tab _tab _tab _tab _tab `"l = "blank""'_n
		file write myFile _tab _tab _tab _tab _tab `"End If"'_n
		file write myFile _tab _tab _tab _tab`"End If"'_n
		file write myFile _tab _tab _tab _tab`"If NOT l = "blank" Then"'_n
					
		file write myFile _tab _tab _tab _tab _tab `"newText = newText + l + VbCrLf"'_n
		file write myFile _tab _tab _tab _tab`"End If"'_n
		file write myFile _tab _tab _tab`"End if"'_n _n

		file write myFile _tab _tab _tab`"If instr(l,strStartText ) > 0 Then"'_n
		file write myFile _tab _tab _tab _tab`"write = 1"'_n
		file write myFile _tab _tab _tab _tab`"intArgsStart = InStr(l, "{")"'_n
		file write myFile _tab _tab _tab _tab`"intArgsEnd = InStr(l, "}")"'_n
		file write myFile _tab _tab _tab _tab`"if intArgsEnd > intArgsStart Then"'_n
		file write myFile _tab _tab _tab _tab _tab`"strArgs = Mid(l, intArgsStart + 1, intArgsEnd - intArgsStart - 1) "'_n
		file write myFile _tab _tab _tab _tab`"End If"'_n
		file write myFile _tab _tab _tab _tab`"Args = Split(strArgs,",",-1)"'_n 
		file write myFile _tab _tab _tab _tab`"for each a in Args"'_n
		file write myFile _tab _tab _tab _tab _tab`"arg = Split(a,"=",-1)"'_n
		file write myFile _tab _tab _tab _tab _tab`"If instr(a,"echo") > 0 Then"'_n
		file write myFile _tab _tab _tab _tab _tab _tab`"echo = arg(1)"'_n
		file write myFile _tab _tab _tab _tab _tab`"End If"'_n
		file write myFile _tab _tab _tab _tab _tab`"If instr(a,"results") > 0 Then"'_n
		file write myFile _tab _tab _tab _tab _tab _tab`"results = arg(1)"'_n
		file write myFile _tab _tab _tab _tab _tab`"End If"'_n
		file write myFile _tab _tab _tab _tab`"next"'_n
		file write myFile _tab _tab _tab`"End If"'_n _n
		
		file write myFile _tab _tab`"Next"'_n
		
		file write myFile _tab _tab`"Wscript.Echo echo"'_n
		
		file write myFile _tab _tab`"strText = newText"'_n
		
		file write myFile _tab _tab`"Set newobjFile = objFSO.CreateTextFile("`dest'\" & strFileName) "'_n
		file write myFile _tab _tab`"strText = replace(strText,VbCrLf,"\line ") "'_n

		file write myFile _tab _tab `"newobjFile.Write "{\rtf1\utf-8\deff0{\fonttbl{\f0 courier;}}{\colortbl\red`red'\green0\blue0;\red`red'\green`green'\blue`blue';}\cf1\fs`fs' " & strText & "}" "' _n

		file write myFile _tab _tab`"objFile.Close "'_n
		file write myFile _tab `"End If "'_n
		file write myFile `"Next"'_n
		
		file close myFile
		
		shell lrtfscript.vbs
	} 
	else {
	
		file open myFile using "`c(pwd)'/lrtfscript.sh", write replace
		file write myFile`"#!/bin/bash"'_n
		file write myFile`"src="`src'""'_n
		file write myFile`"dest="`dest'" "'_n
		file write myFile`"cd "`c(pwd)'" "'_n
		file write myFile`"red="`red'" "'_n
		file write myFile`"green="`green'" "'_n
		file write myFile`"blue="`blue'" "'_n
		file write myFile`"fs="`fs'" "'_n
		file write myFile`"startStr="*@s" "'_n
		file write myFile`"endStr="*@e" "'_n
		
		file write myFile`"preamble="{\rtf1\utf-8\deff0{\fonttbl{\f0 courier;}}{\colortbl\red0\green0\blue0;\red"\$red"\green"\$green"\blue"\$blue";}\cf1\fs"\$fs"" "'_n

		file write myFile`"for file in *.log; do"'_n
		file write myFile _tab`"IFS='.' read -r -a array <<< "\$file""'_n
		file write myFile _tab`"IFS='/' read -r -a array <<< "\${array[0]}""'_n
		file write myFile _tab`"newfile="\$array""'_n
		file write myFile _tab`"if [[ \$array == *'/'* ]]; then"'_n
		file write myFile _tab _tab`"newfile="\${array[-1]}""'_n
		file write myFile _tab`"fi"'_n
		file write myFile _tab`"newfile=\$newfile.rtf"'_n
		file write myFile _tab`"> \$newfile"'_n
		file write myFile _tab`"echo \$preamble >> \$newfile;"'_n
		
		file write myFile _tab`"write=0;"'_n
		file write myFile _tab _tab`"echo = "`echo'";"'_n
		file write myFile _tab _tab`"results = "`results'";"'_n
		
		file write myFile _tab`"while read line; do"'_n
		
		file write myFile _tab _tab`"if [[ \$line == *\$endStr* ]]; then"'_n
		file write myFile _tab _tab _tab`"write=0;"'_n
		file write myFile _tab _tab _tab`"echo '}' >> \$newfile;"'_n
		file write myFile _tab _tab`"fi"'_n _n
		
		
		file write myFile _tab _tab`"if [[ \$write -eq 1 ]]; then"'_n
		file write myFile _tab _tab _tab`"fc=\${line:0:1};"'_n 	
		file write myFile _tab _tab _tab`"if [[ \$echo == 'FALSE' ]]; then"'_n
		file write myFile _tab _tab _tab _tab`"if [[ \$fc == '.' ]]; then"'_n
		file write myFile _tab _tab _tab _tab _tab`"line="blank";"'_n
		file write myFile _tab _tab _tab _tab`"fi"'_n
		file write myFile _tab _tab _tab`"fi"'_n _n
		
		file write myFile _tab _tab _tab`"if [[ \$results == 'FALSE' ]]; then"'_n
		file write myFile _tab _tab _tab _tab`"if [[ \$fc != '.' ]]; then"'_n
		file write myFile _tab _tab _tab _tab _tab`"line="blank";"'_n
		file write myFile _tab _tab _tab _tab`"fi"'_n
		file write myFile _tab _tab _tab`"fi"'_n _n
		
		file write myFile _tab _tab _tab`"if [[ \$line != 'blank' ]]; then"'_n
		file write myFile _tab _tab _tab _tab `"echo \$line'\line' >> \$newfile"'_n
		file write myFile _tab _tab _tab`"fi"'_n
		
		file write myFile _tab _tab`"fi"'_n _n	
		
		file write myFile _tab _tab`"if [[ \$line == *\$startStr* ]]; then"'_n
		file write myFile _tab _tab _tab`"write=1;"'_n
		file write myFile _tab _tab _tab`"args=\$(grep -o '{[^}]*}' <<< \$line);"'_n
		file write myFile _tab _tab _tab`"args=\${args/'}'/};"'_n
		file write myFile _tab _tab _tab`"args=\${args/'{'/}"'_n
		file write myFile _tab _tab _tab`"IFS=',' read -r -a arglist <<< \$args;"'_n
		file write myFile _tab _tab _tab`"for a in \${argslist[@]}; do"'_n
		file write myFile _tab _tab _tab _tab`"IFS="=" read -r -a arg <<< \$a;"'_n
		file write myFile _tab _tab _tab _tab`"if [[ \$arg == *'results'* ]]; then"'_n
		file write myFile _tab _tab _tab _tab _tab`"results=\${arg[1]};"'_n
		file write myFile _tab _tab _tab _tab`"fi"'_n
		file write myFile _tab _tab _tab _tab`"if [[ \$arg == *'echo'* ]]; then"'_n
		file write myFile _tab _tab _tab _tab _tab`"echo=\${arg[1]};"'_n
		file write myFile _tab _tab _tab _tab`"fi"'_n
		
		file write myFile _tab _tab _tab`"done"'_n
		file write myFile _tab _tab`"fi"'_n
		
		file write myFile _tab`"done < \$file"'_n
		file write myFile`"done"'_n
		
		file close myFile
		
		shell chmod +x lrtfscript.sh
		
		shell ./lrtfscript.sh
	}
end
