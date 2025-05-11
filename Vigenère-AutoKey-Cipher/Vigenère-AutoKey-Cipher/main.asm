include Irvine32.inc

.data
msg BYTE "Hello World!", 0

.code
main PROC
    mov edx, OFFSET msg
    call WriteString
    call Crlf
    exit
main ENDP
END main
