//%attributes = {}
  // PM: "collectionToCSV"

C_COLLECTION:C1488($col;$1)
C_TEXT:C284($nameInfo;$2)
C_TEXT:C284($timeInfo;$3)

C_LONGINT:C283($i)
C_TIME:C306($docRef)
C_TEXT:C284($srcTxt)
C_TEXT:C284($srcTxtStart;$srcTxtEnd)
C_COLLECTION:C1488($colHeadRow;$colBodyRow;$colKeys)
C_TEXT:C284($headRowTxt;$bodyRowsTxt;$rowPrefix;$rowSuffix;$cellPrefix;$cellSuffix;$cellSeparator;$rowSeparator)

If (Count parameters:C259>0)
	$col:=$1.copy()
Else   // ok, than use any test data
	$col:=New collection:C1472
	If (True:C214)
		For ($i;1;1000)
			$col.push(New object:C1471("column1";$col.length+1;"column2";String:C10(Random:C100);"column3";String:C10(Random:C100);"column4";String:C10(Random:C100);"column5";String:C10(Random:C100)))
		End for 
	Else 
		For ($i;1;1000)
			$col.push($i)
		End for 
	End if 
End if 

If (Count parameters:C259>1)
	$nameInfo:=$2
Else   // ok, than use any test name
	$nameInfo:="myCollectionA"
End if 

If (Count parameters:C259>2)  // $3 or automatic standard timeInfo
	$timeInfo:=$3
Else 
	$timeInfo:=String:C10(Current date:C33;System date long:K1:3)+" "+Lowercase:C14(String:C10(Current time:C178;HH MM AM PM:K7:5))
End if 

C_TEXT:C284($lineBreak)
If (Is macOS:C1572)
	$lineBreak:=Char:C90(Line feed:K15:40)
Else 
	$lineBreak:=Char:C90(Carriage return:K15:38)+Char:C90(Line feed:K15:40)
End if 

$srcTxtStart:=""
If (False:C215)  // ...set it to true if a title is wished...
	$srcTxtStart:=$srcTxtStart+$nameInfo+$lineBreak
	$srcTxtStart:=$srcTxtStart+$timeInfo+$lineBreak
	$srcTxtStart:=$srcTxtStart+$lineBreak
End if 

$srcTxtEnd:=""

$txtResult:=""

C_COLLECTION:C1488($colReplace)
$colReplace:=New collection:C1472
$colReplace.push(New object:C1471("from";"\"";"to";"\"\""))
  // $colReplace.push(New object("from";"\t";"to";" "))
  // $colReplace.push(New object("from";"\r\n";"to";" "))
  // $colReplace.push(New object("from";"\r";"to";" "))
  // $colReplace.push(New object("from";"\n";"to";" "))

$headRowTxt:=""
$colKeys:=New collection:C1472
If ($col.length>0)
	If (Value type:C1509($col[0])=Is object:K8:27)
		$colKeys:=OB Keys:C1719($col[0])
	End if 
End if 
If ($colKeys.length>0)
	$rowPrefix:=""
	$rowSuffix:=""
	$cellPrefix:="\""
	$cellSuffix:="\""
	$cellSeparator:=";"
	$rowSeparator:=$lineBreak
	$headRowTxt:=$rowPrefix+$cellPrefix+$colKeys.join($cellSuffix+$cellSeparator+$cellPrefix)+$cellSuffix+$rowSuffix+$rowSeparator
End if 

$rowPrefix:=""
$rowSuffix:=""
$cellPrefix:="\""
$cellSuffix:="\""
$cellSeparator:=";"
$rowSeparator:=$lineBreak
If ($colKeys.length>0)
	$colBodyRow:=$col.map("colMapJoin";$rowPrefix;$rowSuffix;$cellPrefix;$cellSuffix;$cellSeparator;$colReplace;$colKeys)
Else 
	$colBodyRow:=$col.map("colMapJoin";$rowPrefix;$rowSuffix;$cellPrefix;$cellSuffix;$cellSeparator;$colReplace)
End if 
$bodyRowsTxt:=$colBodyRow.join($rowSeparator)

$srcTxt:=$srcTxtStart+$headRowTxt+$bodyRowsTxt+$srcTxtEnd

ON ERR CALL:C155("onErrDocument")
$docRef:=Create document:C266($nameInfo+".csv")
If (OK=1)  // If document has been created successfully
	CLOSE DOCUMENT:C267($docRef)
	TEXT TO DOCUMENT:C1237(Document;$srcTxt;"UTF-8";Document with LF:K24:22)
	OPEN URL:C673(Document)
Else 
	ALERT:C41("Error: Any problem by Create document!")
End if 

  // - EOF -