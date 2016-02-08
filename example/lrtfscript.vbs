Const ForReading = 1

Dim oShell : Set oShell = CreateObject("WScript.Shell")
oShell.CurrentDirectory = "C:\Users\m.callaghan\Documents\GitHub\literate_stata\example"

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFolder = objFSO.GetFolder("C:\Users\m.callaghan\Documents\GitHub\literate_stata\example")
strStartText = "*@s"
strEndText = "*@e"

Set colFiles = objFolder.Files
For Each objFile in colFiles
	If instr(objFile.Name,".log") > 0 Then
		strFileName = replace(objFile.Name,".log",".rtf") 
		strFileName2 = objFile.Name 
		Set objFSO = CreateObject("Scripting.FileSystemObject") 
		Set objFile = objFSO.OpenTextFile("C:\Users\m.callaghan\Documents\GitHub\literate_stata\example\"  & strFileName2, ForReading) 

		strContents = objFile.ReadAll 

		intStart = InStr(strContents, strStartText) 
		intStart = intStart + Len(strStartText) + 1 
		intArgsEnd = InStr(strContents, "}") 
		intArgsCharacters = intArgsEnd - intStart
		if intArgsEnd = 0 Then
			intArgsCharacters = 0
		End If
		echo = "TRUE"
		results = "TRUE"
		strArgs = Mid(strContents, intStart, intArgsCharacters) 
		Args = Split(strArgs,",",-1) 
		for each a in Args
			arg = Split(a,"=",-1)
			If instr(a,"echo") > 0 Then
				echo = arg(1)
			End If
			If instr(a,"results") > 0 Then
				results = arg(1)
			End If
		next
		intEnd = InStr(strContents, strEndText) - 4
		if intArgsEnd > 0 Then 
			intStart = intArgsEnd
		End If
		intCharacters = intEnd - intStart
		strText = Mid(strContents, intStart + 1, intCharacters) 
		lines = Split(strText,VbCrLf,-1)
		newText = ""
		for each l in lines
			fc = Left(l,1)
			If echo = "FALSE" Then
				If fc = "." Then
				l = "blank"
				End If
			End If
			If results = "FALSE" Then
				If NOT fc = "." Then
				l = "blank"
				End If
			End If
			If NOT l = "blank" Then
			newText = newText + l + VbCrLf
			End If
		Next
		'Wscript.Echo newText
		strText = newText
		Set newobjFile = objFSO.CreateTextFile("C:\Users\m.callaghan\Documents\GitHub\literate_stata\example\" & strFileName) 
		strText = replace(strText,VbCrLf,"\line ") 
		newobjFile.Write "{\rtf1\utf-8\deff0{\fonttbl{\f0 courier;}}{\colortbl\red0\green0\blue0;\red0\green0\blue0;}\cf1\fs16 " & strText & "}" 
		objFile.Close 
	End If 
Next
