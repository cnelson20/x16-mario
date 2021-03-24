.macro write_sprite mem_number, data_no, x_pos, x_offset, y_pos, y_offset, palette_offset, flip	
	; create sprite ;
	lda mem_number
	asl
	asl
	asl
	sta $9F20
	lda mem_number
	and #%01100000
	lsr 
	lsr 
	lsr 
	lsr
	lsr
	adc #$FC
	sta $9F21 
	lda #$11
	sta $9F22 
	
	lda data_no; sprite number 
	sta $9F23 ; byte 0
	lda #%00001010
	sta $9F23 ; byte 1 
	lda x_pos
	adc x_offset
	sta $9F23 ; byte 2 ; low byte sprite x
	lda x_pos+1
	adc #$00
	sta $9F23 ; byte 3 ; high byte sprite x
	lda y_pos
	adc y_offset
	sta $9F23 ; byte 4 ; low byte sprite y
	lda #$00
	adc #$00
	sta $9F23 ; byte 5 ; high byte sprite y
	lda flip 
	and #%00000011
	ora #%00001100
	sta $9F23 ; byte 6 ; collision mask, z depth of 3, no v & h flip
	lda palette_offset 
	and #$0F
	sta $9F23 ; byte 7 ; sprite height & width, palette offset 
.endmacro
