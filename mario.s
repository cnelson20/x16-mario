.SEGMENT "STARTUP"
.SEGMENT "INIT"
.SEGMENT "ONCE"
	jmp setup
	
.include "vsync.s"

custom_palette: ; 512 bytes , 256 bytes of 4 bit green and 4 bit blue information
; second 512 is red color information (still 4 bit)
	.res 512,$00
custom_tiles: 
	.incbin "mario_background.chr"
custom_tiles_end:
sprite_data:
	.incbin "mario_sprites.chr"
sprite_data_end:
mario_palette_offset:
	.byte $00
player_x:
	.byte $00, $00
player_y:
	.byte $00, $00
frameCounter:
	.byte $00
setup:
	;setup layer 0;
	lda #$00
	sta $9F25 
	lda #%01110001
	; for testing layer 1 ; 
	lda #%01100001
	sta $9F29 
	
	lda #$40
	sta $9F2A
	sta $9F2B
	
	; load tiles ;
	lda #124
	sta $9F2F
	lda #%00001000 ; address 00001000 00000000 / $4000
	sta $9F2E 
	
	lda #%01100001
	sta $9F34 ; 2bpp mode
	lda #%10000000
	sta $9F36 ; tile base address ($10000)
	lda #$00
	sta $9F37
	sta $9F38 
	sta $9F39
	sta $9F3A
	
	lda #$00
	sta $9F20
	sta $9F21 
	lda #$11
	sta $9F22 
	
	lda #<custom_tiles
	sta $10
	lda #>custom_tiles
	sta $11
	ldy #$00
	@l:
	lda ($10),Y
	sta $9F23 
	
	clc 
	lda $10
	adc #$01
	sta $10
	lda $11
	adc #$00
	sta $11
	
	cmp #>custom_tiles_end
	bcc @l
	lda $10
	cmp #<custom_tiles_end
	bcc @l
	
	;load new palette ;
	lda #$00
	sta $9F20 
	lda #$FA
	sta $9F21 
	lda #$11
	sta $9F22 
	
	;@l_palette:
	;lda custom_palette,X 
	;sta $9F23 
	;lda custom_palette+256,X 
	;sta $9F23 
	
	;inx 
	;cpx #$00
	;bne @l_palette
	
	; load sprites into ram next ; 
	lda #$00
	sta $9F20
	lda #$60
	sta $9F21 
	lda #$10
	sta $9F22
	
	lda #<sprite_data
	sta $10
	lda #>sprite_data
	sta $11
	
	@l_sprite:
	ldy #$00
	lda ($10),Y
	sta $9F23 
	
	clc 
	lda $10
	adc #$01
	sta $10
	lda $11
	adc #$00
	sta $11
	
	cmp #>sprite_data_end
	bcc @l_sprite
	lda $10
	cmp #<sprite_data_end
	bcc @l_sprite
	
	; coords for player sprite ;
	lda #$10
	sta player_x
	sta player_y
	lda #$00
	sta player_x+1
	sta player_y+1	
	
	; create sprite ;
	lda #$00
	sta $9F20 
	lda #$FC
	sta $9F21 
	lda #$11
	sta $9F22 
	
	lda #$00 ; sprite number 
	sta $9F23 ; byte 0
	lda #0 ;#%00000011
	sta $9F23 ; byte 1 
	lda player_x
	sta $9F23 ; byte 2 ; low byte sprite x
	lda player_x+1
	and #%00000011
	sta $9F23 ; byte 3 ; high byte sprite x
	lda player_y
	sta $9F23 ; byte 4 ; low byte sprite y
	lda player_y+1
	and #%00000011
	sta $9F23 ; byte 5 ; high byte sprite y
	lda #%00001100
	sta $9F23 ; byte 6 ; collision mask, z depth, v & h flip
	lda mario_palette_offset 
	and #$0F
	sta $9F23 ; byte 7 ; sprite height & width, palette offset 
	
main:
	lda #$00
	sta $9F20
	sta $9F21 
	lda #$10
	sta $9F22 
	
	;jsr set_custom_irq_handler
	ldy #$00
	@l:
	sty $9F23 
	iny 
	lda #$00
	sta $9F23
	
	lda $9F20
	cmp #80
	bcc @l 
	lda #$00
	sta $9F20
	ldx $9F21 
	inx 	 
	stx $9F21 
	cpx #30
	bcc @l
	
	@t:
	jsr $FFE4
	cmp #$00
	beq @t

end:	
	jsr reset_irq_handler
	clc
	jmp $FF47
