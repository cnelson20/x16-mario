.DEFINE CHROUT $FFD2
.DEFINE keyboard_get $FFE4

.SEGMENT "STARTUP"
.SEGMENT "INIT"
.SEGMENT "ONCE"
	jmp setup

.include "operations.s"
temp:
	.byte $00, $00

setup:
	lda #$0F
	jsr CHROUT
main:
	jsr keyboard_get
	cmp #$20
	beq @end
	cmp #$00
	beq main 
	
	tax
	jsr CHROUT
	txa	
	
	jsr toHexChars
	txa 
	sty temp 
	ldx temp
	jsr CHROUT
	txa 
	jsr CHROUT
	lda #$0D
	jsr CHROUT
	
	jmp main 
	
@end:
	lda #$0F
	jsr CHROUT
	clc
	jmp $FF47