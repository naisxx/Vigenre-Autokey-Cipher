include Irvine32.inc

.data
	promptPlainText	 BYTE "Enter plaintext: ", 0
	promptKeyword	 BYTE "Enter keyword: ", 0

	maxLength		 = 100
	plainText		 BYTE maxLength DUP(?)
	keyword			 BYTE maxLength DUP(?)

	debugPlainTextMsg   BYTE "[DEBUG] Uppercase Plaintext: ", 0
    debugKeywordMsg     BYTE "[DEBUG] Uppercase Keyword: ", 0

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

	; Converting PLAINTEXT to uppercase
	mov esi, OFFSET plainText
	convertPlainTextLoop:
		; Checking if it's the end of the string
		mov al, [esi]
		cmp al, 0
		je convertKeyword

		; Checking if it's in lowercase range i.e 0-25
		cmp al, 'a'
		jb skipConvert
		cmp al, 'z'
		ja skipConvert

		; Converting to Uppercase
		sub al, 32
		mov [esi], al
	
	skipConvert:
		inc esi
		jmp convertPlainTextLoop

	convertKeyword:
		mov esi, OFFSET keyword

	convertKeywordLoop:
		 mov al, [esi]
		cmp al, 0
		je doneConvert

		cmp al, 'a'
		jb skipKeyConvert
		cmp al, 'z'
		ja skipKeyConvert

		sub al, 32
		mov [esi], al

	skipKeyConvert:
		inc esi
		jmp convertKeywordLoop

	doneConvert:

	printDebug:
    call Crlf
    mov edx, OFFSET debugPlainTextMsg
    call WriteString

    mov edx, OFFSET plainText
    call WriteString

    call Crlf
    mov edx, OFFSET debugKeywordMsg
    call WriteString

    mov edx, OFFSET keyword
    call WriteString
    call Crlf



	exit
main ENDP
END main
