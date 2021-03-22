Default_irq_handler: 
	.byte $00, $00
set_custom_irq_handler:
    sei
    lda #<custom_irq_handler
    sta $0314
    lda #>custom_irq_handler
    sta $0315
    cli
    rts

reset_irq_handler: 
	sei
    lda Default_irq_handler
    sta $0314
    lda Default_irq_handler+1
    sta $0315
    cli
	rts 
	
preserve_default_irq:
    lda $0314
    sta Default_irq_handler
    lda $0315
    sta Default_irq_handler+1
    rts
	
custom_irq_handler:
    lda $9F27
    and #$01
    beq @irq_done
	; vsync ;
	inc frameCounter
	
	
	
    @irq_done:
    jmp (Default_irq_handler)
