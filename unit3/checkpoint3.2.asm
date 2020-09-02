  .file [name="checkpoint3.2.bin", type="bin", segments="XMega65Bin"]
.segmentdef XMega65Bin [segments="Syscall, Code, Data, Stack, Zeropage"]
.segmentdef Syscall [start=$8000, max=$81ff]
.segmentdef Code [start=$8200, min=$8200, max=$bdff]
.segmentdef Data [startAfter="Code", min=$8200, max=$bdff]
.segmentdef Stack [min=$be00, max=$beff, fill]
.segmentdef Zeropage [min=$bf00, max=$bfff, fill]
  .label VIC_MEMORY = $d018
  .label SCREEN = $400
  .label COLS = $d800
  .const WHITE = 1
  .const JMP = $4c
  .const NOP = $ea
  .label p = $e
  .label current_screen_x = 9
  .label current_screen_line = $c
  .label mem_start = 2
  .label mem_end = 5
  .label current_screen_line_28 = 7
  .label is_mem_error = 4
  .label current_screen_line_55 = 7
  .label current_screen_line_56 = 7
  .label current_screen_line_57 = 7
  .label current_screen_line_58 = 7
  .label current_screen_line_59 = 7
  .label current_screen_line_60 = 7
  lda #<0
  sta.z p
  sta.z p+1
  jsr main
  rts
.segment Code
main: {
    rts
}
cpukil: {
    jsr exit_hypervisor
    rts
}
exit_hypervisor: {
    lda #1
    sta $d67f
    rts
}
reserved: {
    jsr exit_hypervisor
    rts
}
vf011wr: {
    jsr exit_hypervisor
    rts
}
vf011rd: {
    jsr exit_hypervisor
    rts
}
alttabkey: {
    jsr exit_hypervisor
    rts
}
restorkey: {
    jsr exit_hypervisor
    rts
}
pagfault: {
    jsr exit_hypervisor
    rts
}
reset: {
    lda #$14
    sta VIC_MEMORY
    ldx #' '
    lda #<SCREEN
    sta.z memset.str
    lda #>SCREEN
    sta.z memset.str+1
    lda #<$28*$19
    sta.z memset.num
    lda #>$28*$19
    sta.z memset.num+1
    jsr memset
    ldx #WHITE
    lda #<COLS
    sta.z memset.str
    lda #>COLS
    sta.z memset.str+1
    lda #<$28*$19
    sta.z memset.num
    lda #>$28*$19
    sta.z memset.num+1
    jsr memset
    lda #0
    sta.z current_screen_x
    lda #<$400
    sta.z current_screen_line_28
    lda #>$400
    sta.z current_screen_line_28+1
    lda #<message
    sta.z print_to_screen.message
    lda #>message
    sta.z print_to_screen.message+1
    jsr print_to_screen
    lda #<$400
    sta.z current_screen_line
    lda #>$400
    sta.z current_screen_line+1
    jsr print_newline
    lda.z current_screen_line
    sta.z current_screen_line_56
    lda.z current_screen_line+1
    sta.z current_screen_line_56+1
    lda #0
    sta.z current_screen_x
    lda #<message1
    sta.z print_to_screen.message
    lda #>message1
    sta.z print_to_screen.message+1
    jsr print_to_screen
    jsr test_memory
    jsr exit_hypervisor
    rts
  .segment Data
    message: .text "chun0153 operating system starting..."
    .byte 0
    message1: .text "testing hardware"
    .byte 0
}
.segment Code
test_memory: {
    lda #0
    sta.z is_mem_error
    lda #<$800
    sta.z mem_start
    lda #>$800
    sta.z mem_start+1
  __b1:
    lda.z mem_start+1
    cmp #>$7fff
    bcc b1
    bne !+
    lda.z mem_start
    cmp #<$7fff
    bcc b1
  !:
    lda #<$8000
    sta.z mem_end
    lda #>$8000
    sta.z mem_end+1
  __b10:
    jsr print_newline
    lda.z current_screen_line
    sta.z current_screen_line_58
    lda.z current_screen_line+1
    sta.z current_screen_line_58+1
    lda #0
    sta.z current_screen_x
    lda #<message1
    sta.z print_to_screen.message
    lda #>message1
    sta.z print_to_screen.message+1
    jsr print_to_screen
    lda.z mem_start
    sta.z print_hex.value
    lda.z mem_start+1
    sta.z print_hex.value+1
    jsr print_hex
    lda.z current_screen_line
    sta.z current_screen_line_59
    lda.z current_screen_line+1
    sta.z current_screen_line_59+1
    lda #<message2
    sta.z print_to_screen.message
    lda #>message2
    sta.z print_to_screen.message+1
    jsr print_to_screen
    lda.z mem_end
    sta.z print_hex.value
    lda.z mem_end+1
    sta.z print_hex.value+1
    jsr print_hex
    jsr print_newline
    lda.z current_screen_line
    sta.z current_screen_line_60
    lda.z current_screen_line+1
    sta.z current_screen_line_60+1
    lda #0
    sta.z current_screen_x
    lda #<message3
    sta.z print_to_screen.message
    lda #>message3
    sta.z print_to_screen.message+1
    jsr print_to_screen
    rts
  // p = mem_start;
  b1:
    ldx #0
  __b2:
    cpx #$ff
    bcc __b3
  __b5:
    lda.z is_mem_error
    cmp #0
    bne __b8
    inc.z mem_start
    bne !+
    inc.z mem_start+1
  !:
    jmp __b1
  __b8:
    lda.z p
    sta.z mem_end
    lda.z p+1
    sta.z mem_end+1
    jmp __b10
  __b3:
    lda.z is_mem_error
    cmp #0
    bne __b4
    txa
    ldy #0
    sta (p),y
    txa
    cmp (p),y
    beq __b4
    jsr print_newline
    lda.z current_screen_line
    sta.z current_screen_line_57
    lda.z current_screen_line+1
    sta.z current_screen_line_57+1
    lda #0
    sta.z current_screen_x
    lda #<message
    sta.z print_to_screen.message
    lda #>message
    sta.z print_to_screen.message+1
    jsr print_to_screen
    lda.z mem_start
    sta.z print_hex.value
    lda.z mem_start+1
    sta.z print_hex.value+1
    jsr print_hex
    lda #1
    sta.z is_mem_error
    jmp __b5
  __b4:
    inx
    jmp __b2
  .segment Data
    message: .text "memory error at $"
    .byte 0
    message1: .text "memory found at $"
    .byte 0
    message2: .text " - $"
    .byte 0
    message3: .text "finished testing hardware"
    .byte 0
}
.segment Code
// print_hex(word zeropage($a) value)
print_hex: {
    .label __3 = $10
    .label __6 = $12
    .label value = $a
    ldx #0
  __b1:
    cpx #4
    bcc __b2
    lda #0
    sta hex+4
    lda.z current_screen_line
    sta.z current_screen_line_55
    lda.z current_screen_line+1
    sta.z current_screen_line_55+1
    lda #<hex
    sta.z print_to_screen.message
    lda #>hex
    sta.z print_to_screen.message+1
    jsr print_to_screen
    rts
  __b2:
    lda.z value+1
    cmp #>$a000
    bcc __b4
    bne !+
    lda.z value
    cmp #<$a000
    bcc __b4
  !:
    ldy #$c
    lda.z value
    sta.z __3
    lda.z value+1
    sta.z __3+1
    cpy #0
    beq !e+
  !:
    lsr.z __3+1
    ror.z __3
    dey
    bne !-
  !e:
    lda.z __3
    sec
    sbc #9
    sta hex,x
  __b5:
    asl.z value
    rol.z value+1
    asl.z value
    rol.z value+1
    asl.z value
    rol.z value+1
    asl.z value
    rol.z value+1
    inx
    jmp __b1
  __b4:
    ldy #$c
    lda.z value
    sta.z __6
    lda.z value+1
    sta.z __6+1
    cpy #0
    beq !e+
  !:
    lsr.z __6+1
    ror.z __6
    dey
    bne !-
  !e:
    lda.z __6
    clc
    adc #'0'
    sta hex,x
    jmp __b5
  .segment Data
    hex: .fill 5, 0
}
.segment Code
//char[] MESSAGE = "checkpoint 3.1 by chun0153";
// print_to_screen(byte* zeropage($a) message)
print_to_screen: {
    .label message = $a
  __b1:
    ldy #0
    lda (message),y
    cmp #0
    bne __b2
    rts
  __b2:
    ldy #0
    lda (message),y
    ldy.z current_screen_x
    sta (current_screen_line_28),y
    inc.z message
    bne !+
    inc.z message+1
  !:
    inc.z current_screen_x
    jmp __b1
}
print_newline: {
    lda #$28
    clc
    adc.z current_screen_line
    sta.z current_screen_line
    bcc !+
    inc.z current_screen_line+1
  !:
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage($12) str, byte register(X) c, word zeropage($10) num)
memset: {
    .label end = $10
    .label dst = $12
    .label num = $10
    .label str = $12
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    lda.z end
    clc
    adc.z str
    sta.z end
    lda.z end+1
    adc.z str+1
    sta.z end+1
  __b2:
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
  __breturn:
    rts
  __b3:
    txa
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
syscall3F: {
    jsr exit_hypervisor
    rts
}
syscall3E: {
    jsr exit_hypervisor
    rts
}
syscall3D: {
    jsr exit_hypervisor
    rts
}
syscall3C: {
    jsr exit_hypervisor
    rts
}
syscall3B: {
    jsr exit_hypervisor
    rts
}
syscall3A: {
    jsr exit_hypervisor
    rts
}
syscall39: {
    jsr exit_hypervisor
    rts
}
syscall38: {
    jsr exit_hypervisor
    rts
}
syscall37: {
    jsr exit_hypervisor
    rts
}
syscall36: {
    jsr exit_hypervisor
    rts
}
syscall35: {
    jsr exit_hypervisor
    rts
}
syscall34: {
    jsr exit_hypervisor
    rts
}
syscall33: {
    jsr exit_hypervisor
    rts
}
syscall32: {
    jsr exit_hypervisor
    rts
}
syscall31: {
    jsr exit_hypervisor
    rts
}
syscall30: {
    jsr exit_hypervisor
    rts
}
syscall2F: {
    jsr exit_hypervisor
    rts
}
syscall2E: {
    jsr exit_hypervisor
    rts
}
syscall2D: {
    jsr exit_hypervisor
    rts
}
syscall2C: {
    jsr exit_hypervisor
    rts
}
syscall2B: {
    jsr exit_hypervisor
    rts
}
syscall2A: {
    jsr exit_hypervisor
    rts
}
syscall29: {
    jsr exit_hypervisor
    rts
}
syscall28: {
    jsr exit_hypervisor
    rts
}
syscall27: {
    jsr exit_hypervisor
    rts
}
syscall26: {
    jsr exit_hypervisor
    rts
}
syscall25: {
    jsr exit_hypervisor
    rts
}
syscall24: {
    jsr exit_hypervisor
    rts
}
syscall23: {
    jsr exit_hypervisor
    rts
}
syscall22: {
    jsr exit_hypervisor
    rts
}
syscall21: {
    jsr exit_hypervisor
    rts
}
syscall20: {
    jsr exit_hypervisor
    rts
}
syscall1F: {
    jsr exit_hypervisor
    rts
}
syscall1E: {
    jsr exit_hypervisor
    rts
}
syscall1D: {
    jsr exit_hypervisor
    rts
}
syscall1C: {
    jsr exit_hypervisor
    rts
}
syscall1B: {
    jsr exit_hypervisor
    rts
}
syscall1A: {
    jsr exit_hypervisor
    rts
}
syscall19: {
    jsr exit_hypervisor
    rts
}
syscall18: {
    jsr exit_hypervisor
    rts
}
syscall17: {
    jsr exit_hypervisor
    rts
}
syscall16: {
    jsr exit_hypervisor
    rts
}
syscall15: {
    jsr exit_hypervisor
    rts
}
syscall14: {
    jsr exit_hypervisor
    rts
}
syscall13: {
    jsr exit_hypervisor
    rts
}
securexit: {
    jsr exit_hypervisor
    rts
}
securentr: {
    jsr exit_hypervisor
    rts
}
syscall10: {
    jsr exit_hypervisor
    rts
}
syscall0F: {
    jsr exit_hypervisor
    rts
}
syscall0E: {
    jsr exit_hypervisor
    rts
}
syscall0D: {
    jsr exit_hypervisor
    rts
}
syscall0C: {
    jsr exit_hypervisor
    rts
}
syscall0B: {
    jsr exit_hypervisor
    rts
}
syscall0A: {
    jsr exit_hypervisor
    rts
}
syscall09: {
    jsr exit_hypervisor
    rts
}
syscall08: {
    jsr exit_hypervisor
    rts
}
syscall07: {
    jsr exit_hypervisor
    rts
}
syscall06: {
    jsr exit_hypervisor
    rts
}
syscall05: {
    jsr exit_hypervisor
    rts
}
syscall04: {
    jsr exit_hypervisor
    rts
}
syscall03: {
    jsr exit_hypervisor
    rts
}
syscall02: {
    jsr exit_hypervisor
    rts
}
syscall01: {
    jsr exit_hypervisor
    rts
}
syscall00: {
    jsr exit_hypervisor
    rts
}
.segment Syscall
  SYSCALLS: .byte JMP
  .word syscall00
  .byte NOP, JMP
  .word syscall01
  .byte NOP, JMP
  .word syscall02
  .byte NOP, JMP
  .word syscall03
  .byte NOP, JMP
  .word syscall04
  .byte NOP, JMP
  .word syscall05
  .byte NOP, JMP
  .word syscall06
  .byte NOP, JMP
  .word syscall07
  .byte NOP, JMP
  .word syscall08
  .byte NOP, JMP
  .word syscall09
  .byte NOP, JMP
  .word syscall0A
  .byte NOP, JMP
  .word syscall0B
  .byte NOP, JMP
  .word syscall0C
  .byte NOP, JMP
  .word syscall0D
  .byte NOP, JMP
  .word syscall0E
  .byte NOP, JMP
  .word syscall0F
  .byte NOP, JMP
  .word syscall10
  .byte NOP, JMP
  .word securentr
  .byte NOP, JMP
  .word securexit
  .byte NOP, JMP
  .word syscall13
  .byte NOP, JMP
  .word syscall14
  .byte NOP, JMP
  .word syscall15
  .byte NOP, JMP
  .word syscall16
  .byte NOP, JMP
  .word syscall17
  .byte NOP, JMP
  .word syscall18
  .byte NOP, JMP
  .word syscall19
  .byte NOP, JMP
  .word syscall1A
  .byte NOP, JMP
  .word syscall1B
  .byte NOP, JMP
  .word syscall1C
  .byte NOP, JMP
  .word syscall1D
  .byte NOP, JMP
  .word syscall1E
  .byte NOP, JMP
  .word syscall1F
  .byte NOP, JMP
  .word syscall20
  .byte NOP, JMP
  .word syscall21
  .byte NOP, JMP
  .word syscall22
  .byte NOP, JMP
  .word syscall23
  .byte NOP, JMP
  .word syscall24
  .byte NOP, JMP
  .word syscall25
  .byte NOP, JMP
  .word syscall26
  .byte NOP, JMP
  .word syscall27
  .byte NOP, JMP
  .word syscall28
  .byte NOP, JMP
  .word syscall29
  .byte NOP, JMP
  .word syscall2A
  .byte NOP, JMP
  .word syscall2B
  .byte NOP, JMP
  .word syscall2C
  .byte NOP, JMP
  .word syscall2D
  .byte NOP, JMP
  .word syscall2E
  .byte NOP, JMP
  .word syscall2F
  .byte NOP, JMP
  .word syscall30
  .byte NOP, JMP
  .word syscall31
  .byte NOP, JMP
  .word syscall32
  .byte NOP, JMP
  .word syscall33
  .byte NOP, JMP
  .word syscall34
  .byte NOP, JMP
  .word syscall35
  .byte NOP, JMP
  .word syscall36
  .byte NOP, JMP
  .word syscall37
  .byte NOP, JMP
  .word syscall38
  .byte NOP, JMP
  .word syscall39
  .byte NOP, JMP
  .word syscall3A
  .byte NOP, JMP
  .word syscall3B
  .byte NOP, JMP
  .word syscall3C
  .byte NOP, JMP
  .word syscall3D
  .byte NOP, JMP
  .word syscall3E
  .byte NOP, JMP
  .word syscall3F
  .byte NOP
  .align $100
  TRAPS: .byte JMP
  .word reset
  .byte NOP, JMP
  .word pagfault
  .byte NOP, JMP
  .word restorkey
  .byte NOP, JMP
  .word alttabkey
  .byte NOP, JMP
  .word vf011rd
  .byte NOP, JMP
  .word vf011wr
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word cpukil
  .byte NOP
