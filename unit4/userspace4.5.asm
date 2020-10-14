.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    jsr get_os_version
    lda #<message
    sta.z print_string.message
    lda #>message
    sta.z print_string.message+1
    jsr print_string
    lda #<get_os_version.return
    sta.z print_string.message
    lda #>get_os_version.return
    sta.z print_string.message+1
    jsr print_string
  __b1:
    jmp __b1
    message: .text "os version is: "
    .byte 0
}
// print_string(byte* zeropage(2) message)
print_string: {
    .label mem = 4
    .label message = 2
    lda #<$302
    sta.z mem
    lda #>$302
    sta.z mem+1
  __b1:
    ldy #0
    lda (message),y
    cmp #0
    bne __b2
    tya
    tay
    sta (mem),y
    jsr call_syscall02
    rts
  __b2:
    ldy #0
    lda (message),y
    sta (mem),y
    inc.z mem
    bne !+
    inc.z mem+1
  !:
    inc.z message
    bne !+
    inc.z message+1
  !:
    jmp __b1
}
call_syscall02: {
    jsr enable_syscalls
    lda #0
    sta $d642
    nop
    rts
}
enable_syscalls: {
    lda #$47
    sta $d02f
    lda #$53
    sta $d02f
    rts
}
get_os_version: {
    jsr call_syscall03
    rts
    return: .text "froschos 1.00"
    .byte 0
}
call_syscall03: {
    jsr enable_syscalls
    lda #0
    sta $d643
    nop
    rts
}
