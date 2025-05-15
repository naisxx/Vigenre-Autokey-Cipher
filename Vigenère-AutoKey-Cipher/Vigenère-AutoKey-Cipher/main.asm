include Irvine32.inc

.data
	promptPlainText	 BYTE "Enter plaintext: ", 0
	promptKeyword	 BYTE "Enter keyword: ", 0

	maxLength		 = 100
	plainText		 BYTE maxLength DUP(?)
	keyword			 BYTE maxLength DUP(?)

.code
main PROC
	; Reading PlainText
	mov edx, OFFSET promptPlainText
	call WriteString

	mov edx, OFFSET plainText
	mov ecx, maxLength
	call ReadString

	; Reading Keyword
	mov edx, OFFSET promptKeyword
	call WriteString

	mov edx, OFFSET keyword
	mov ecx, maxLength
	call ReadString

	exit
main ENDP
END main
