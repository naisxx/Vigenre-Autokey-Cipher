include Irvine32.inc

.data
    promptPlainText  BYTE "Enter plaintext: ", 0
    promptKeyword    BYTE "Enter keyword: ", 0
    resultMsg        BYTE "Encrypted text: ", 0

    maxLength        = 100
    plainText        BYTE maxLength DUP(?)
    keyword          BYTE maxLength DUP(?)
    cipherText       BYTE maxLength DUP(?)

    keyword_length   DWORD ?     ; we will compute this
    
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

    ; Get keyword length and save in memory
    mov edx, OFFSET keyword
    call Str_length
    mov keyword_length, eax        ; store length in our variable

    ; Converting PLAINTEXT to uppercase
    mov esi, OFFSET plainText
    convertPlainTextLoop:
        ; Check if it's the end of the string
        mov al, [esi]
        cmp al, 0
        je convertKeyword

        ; Check if it's in lowercase range
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

    ; For DEBUG purposes
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

    ; Encryption process
    mov esi, OFFSET plainText      ; Source pointer (plaintext)
    mov edi, OFFSET cipherText     ; Destination pointer (ciphertext)
    mov ecx, 0                     ; Keyword position counter

    encrypt_loop:
        ; Get next plaintext character
        mov al, [esi]
        cmp al, 0                  ; Check for end of string
        je done_encrypt

        ; Check if char is a letter: 'A' to 'Z'
        cmp al, 'A'
        jb not_letter
        cmp al, 'Z'
        ja not_letter

        ; Get the corresponding keyword character
        push eax                   ; Save plaintext character
        mov eax, ecx               ; Current keyword position
        xor edx, edx               ; Clear EDX for division
        div keyword_length         ; EDX now contains position % keyword_length
        mov ebx, OFFSET keyword    ; Get keyword base address
        add ebx, edx               ; Add the remainder (position in keyword)
        mov bl, [ebx]              ; Get the keyword character
        sub bl, 'A'                ; Convert to 0-25 value
        pop eax                    ; Restore plaintext character

        ; Encrypt the character
        sub al, 'A'                ; Convert plaintext to 0-25
        add al, bl                 ; Add keyword shift
        
        ; Take modulo 26 more carefully
        movzx edx, al              ; Move with zero extend to avoid sign issues
        mov ebx, 26
        xor eax, eax               ; Clear EAX
        mov al, dl                 ; Move character value back
        xor edx, edx               ; Clear EDX for division
        div bl                     ; Divide by 26, remainder in AH
        mov al, ah                 ; Get remainder (modulo result)
        
        add al, 'A'                ; Convert back to ASCII
        mov [edi], al              ; Store in ciphertext
        inc ecx                    ; Move to next keyword position
        jmp next_char

    not_letter:
        mov [edi], al              ; Copy non-letter characters unchanged
        
    next_char:
        inc esi                    ; Move to next plaintext character
        inc edi                    ; Move to next ciphertext position
        jmp encrypt_loop

    done_encrypt:
        mov BYTE PTR [edi], 0      ; Null-terminate the ciphertext

    ; Display the result
    call Crlf
    mov edx, OFFSET resultMsg
    call WriteString
    mov edx, OFFSET cipherText
    call WriteString
    call Crlf

    exit
main ENDP
END main