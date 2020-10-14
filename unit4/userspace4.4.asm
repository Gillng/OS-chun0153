.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    jsr print_string
  __b1:
    jmp __b1
    message: .text "printed via print string api"
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
    lda #<main.message
    sta.z message
    lda #>main.message
    sta.z message+1
  __b1:
    ldy #0
    lda (message),y
    cmp #0
    bne __b2
    tya
    tay
    sta (mem),y
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
