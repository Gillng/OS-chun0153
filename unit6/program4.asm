.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    ldx #$ff
    lda #<message
    sta.z ipc_send.message
    lda #>message
    sta.z ipc_send.message+1
    jsr ipc_send
    ldx #$c8
    lda #<message1
    sta.z ipc_send.message
    lda #>message1
    sta.z ipc_send.message+1
    jsr ipc_send
    ldx #$c7
    lda #<message2
    sta.z ipc_send.message
    lda #>message2
    sta.z ipc_send.message+1
    jsr ipc_send
    ldx #$c6
    lda #<message3
    sta.z ipc_send.message
    lda #>message3
    sta.z ipc_send.message+1
    jsr ipc_send
    ldx #1
    lda #<message2
    sta.z ipc_send.message
    lda #>message2
    sta.z ipc_send.message+1
    jsr ipc_send
    ldx #$64
    lda #<message5
    sta.z ipc_send.message
    lda #>message5
    sta.z ipc_send.message+1
    jsr ipc_send
    ldx #$f0
    lda #<message6
    sta.z ipc_send.message
    lda #>message6
    sta.z ipc_send.message+1
    jsr ipc_send
  __b1:
    jsr yield
    jmp __b1
    message: .text "checkpoint  "
    .byte 0
    message1: .text "4           "
    .byte 0
    message2: .text "------------"
    .byte 0
    message3: .text "moremessages"
    .byte 0
    message5: .text "3           "
    .byte 0
    message6: .text "6.          "
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
// ipc_send(byte register(X) priority, byte* zeropage(2) message)
ipc_send: {
    .label a = $300
    .label b = 2
    .label message = 2
    jsr enable_syscalls
    lda #1
    sta a
    stx a+1
    sta a+2
    ldx #3
  __b1:
    cpx #$f
    bcc __b2
    lda #$a
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
