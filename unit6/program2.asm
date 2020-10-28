.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    jsr ipc_send
  __b1:
    jsr yield
    jmp __b1
    message: .text "cpoint 6.2  "
    .byte 0
}
yield: {
    jsr enable_syscalls
    lda #0
    sta $d645
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
ipc_send: {
    .label a = $300
    .const to = 1
    .const priority = 1
    .const sequence = 1
    .label b = 2
    jsr enable_syscalls
    lda #to
    sta a
    lda #priority
    sta a+1
    lda #sequence
    sta a+2
    lda #<main.message
    sta.z b
    lda #>main.message
    sta.z b+1
    ldx #3
  __b1:
    cpx #$f
    bcc __b2
    /*	
	while (*b) {
		*a++ = *b++;
		}
		
*/
    lda #0
    sta $d64a
    nop
    rts
  __b2:
    lda #0
    tay
    cmp (b),y
    beq __b4
    lda (b),y
    sta a,x
    inc.z b
    bne !+
    inc.z b+1
  !:
  __b4:
    inx
    jmp __b1
}
