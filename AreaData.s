ProcessAreaData:
            ldx #$02                 ;start at the end of area object buffer
ProcADLoop: stx ObjectOffset
            lda #$00                 ;reset flag
            sta BehindAreaParserFlag
            ldy AreaDataOffset       ;get offset of area data pointer
            lda (AreaData),y         ;get first byte of area object
            cmp #$fd                 ;if end-of-area, skip all this crap
            beq RdyDecode
            lda AreaObjectLength,x   ;check area object buffer flag
            bpl RdyDecode            ;if buffer not negative, branch, otherwise
            iny
            lda (AreaData),y         ;get second byte of area object
            asl                      ;check for page select bit (d7), branch if not set
            bcc Chk1Row13
            lda AreaObjectPageSel    ;check page select
            bne Chk1Row13
            inc AreaObjectPageSel    ;if not already set, set it now
            inc AreaObjectPageLoc    ;and increment page location
Chk1Row13:  dey
            lda (AreaData),y         ;reread first byte of level object
            and #$0f                 ;mask out high nybble
            cmp #$0d                 ;row 13?
            bne Chk1Row14
            iny                      ;if so, reread second byte of level object
            lda (AreaData),y
            dey                      ;decrement to get ready to read first byte
            and #%01000000           ;check for d6 set (if not, object is page control)
            bne CheckRear
            lda AreaObjectPageSel    ;if page select is set, do not reread
            bne CheckRear
            iny                      ;if d6 not set, reread second byte
            lda (AreaData),y
            and #%00011111           ;mask out all but 5 LSB and store in page control
            sta AreaObjectPageLoc
            inc AreaObjectPageSel    ;increment page select
            jmp NextAObj
Chk1Row14:  cmp #$0e                 ;row 14?
            bne CheckRear
            lda BackloadingFlag      ;check flag for saved page number and branch if set
            bne RdyDecode            ;to render the object (otherwise bg might not look right)
CheckRear:  lda AreaObjectPageLoc    ;check to see if current page of level object is
            cmp CurrentPageLoc       ;behind current page of renderer
            bcc SetBehind            ;if so branch
RdyDecode:  jsr DecodeAreaData       ;do sub and do not turn on flag
            jmp ChkLength
SetBehind:  inc BehindAreaParserFlag ;turn on flag if object is behind renderer
NextAObj:   jsr IncAreaObjOffset     ;increment buffer offset and move on
ChkLength:  ldx ObjectOffset         ;get buffer offset
            lda AreaObjectLength,x   ;check object length for anything stored here
            bmi ProcLoopb            ;if not, branch to handle loopback
            dec AreaObjectLength,x   ;otherwise decrement length or get rid of it
ProcLoopb:  dex                      ;decrement buffer offset
            bpl ProcADLoop           ;and loopback unless exceeded buffer
            lda BehindAreaParserFlag ;check for flag set if objects were behind renderer
            bne ProcessAreaData      ;branch if true to load more level data, otherwise
            lda BackloadingFlag      ;check for flag set if starting right of page $00
            beq @dontBranch ;  basically bne ProcessAreaData   - branch if true to load more level data, otherwise leave
            jmp ProcessAreaData
            @dontBranch:
EndAParse:  rts

IncAreaObjOffset:
      inc AreaDataOffset    ;increment offset of level pointer
      inc AreaDataOffset
      lda #$00              ;reset page select
      sta AreaObjectPageSel
      rts

DecodeAreaData:
          lda AreaObjectLength,x     ;check current buffer flag
          bmi Chk1stB
          ldy AreaObjOffsetBuffer,x  ;if not, get offset from buffer
Chk1stB:  ldx #$10                   ;load offset of 16 for special row 15
          lda (AreaData),y           ;get first byte of level object again
          cmp #$fd
          beq EndAParse              ;if end of level, leave this routine
          and #$0f                   ;otherwise, mask out low nybble
          cmp #$0f                   ;row 15?
          beq ChkRow14               ;if so, keep the offset of 16
          ldx #$08                   ;otherwise load offset of 8 for special row 12
          cmp #$0c                   ;row 12?
          beq ChkRow14               ;if so, keep the offset value of 8
          ldx #$00                   ;otherwise nullify value by default
ChkRow14: stx $07                    ;store whatever value we just loaded here
          ldx ObjectOffset           ;get object offset again
          cmp #$0e                   ;row 14?
          bne ChkRow13
          lda #$00                   ;if so, load offset with $00
          sta $07
          lda #$2e                   ;and load A with another value
          bne NormObj                ;unconditional branch
ChkRow13: cmp #$0d                   ;row 13?
          bne ChkSRows
          lda #$22                   ;if so, load offset with 34
          sta $07
          iny                        ;get next byte
          lda (AreaData),y
          and #%01000000             ;mask out all but d6 (page control obj bit)
          beq LeavePar               ;if d6 clear, branch to leave (we handled this earlier)
          lda (AreaData),y           ;otherwise, get byte again
          and #%01111111             ;mask out d7
          cmp #$4b                   ;check for loop command in low nybble
          bne Mask2MSB               ;(plus d6 set for object other than page control)
          inc LoopCommand            ;if loop command, set loop command flag
Mask2MSB: and #%00111111             ;mask out d7 and d6
          jmp NormObj                ;and jump
ChkSRows: cmp #$0c                   ;row 12-15?
          bcs SpecObj
          iny                        ;if not, get second byte of level object
          lda (AreaData),y
          and #%01110000             ;mask out all but d6-d4
          bne LrgObj                 ;if any bits set, branch to handle large object
          lda #$16
          sta $07                    ;otherwise set offset of 24 for small object
          lda (AreaData),y           ;reload second byte of level object
          and #%00001111             ;mask out higher nybble and jump
          jmp NormObj
LrgObj:   sta $00                    ;store value here (branch for large objects)
          cmp #$70                   ;check for vertical pipe object
          bne NotWPipe
          lda (AreaData),y           ;if not, reload second byte
          and #%00001000             ;mask out all but d3 (usage control bit)
          beq NotWPipe               ;if d3 clear, branch to get original value
          lda #$00                   ;otherwise, nullify value for warp pipe
          sta $00
NotWPipe: lda $00                    ;get value and jump ahead
          jmp MoveAOId
SpecObj:  iny                        ;branch here for rows 12-15
          lda (AreaData),y
          and #%01110000             ;get next byte and mask out all but d6-d4
MoveAOId: lsr                        ;move d6-d4 to lower nybble
          lsr
          lsr
          lsr
NormObj:  sta $00                    ;store value here (branch for small objects and rows 13 and 14)
          lda AreaObjectLength,x     ;is there something stored here already?
          bpl RunAObj                ;if so, branch to do its particular sub
          lda AreaObjectPageLoc      ;otherwise check to see if the object we've loaded is on the
          cmp CurrentPageLoc         ;same page as the renderer, and if so, branch
          beq InitRear
          ldy AreaDataOffset         ;if not, get old offset of level pointer
          lda (AreaData),y           ;and reload first byte
          and #%00001111
          cmp #$0e                   ;row 14?
          bne LeavePar
          lda BackloadingFlag        ;if so, check backloading flag
          bne StrAObj                ;if set, branch to render object, else leave
LeavePar: rts
InitRear: lda BackloadingFlag        ;check backloading flag to see if it's been initialized
          beq BackColC               ;branch to column-wise check
          lda #$00                   ;if not, initialize both backloading and
          sta BackloadingFlag        ;behind-renderer flags and leave
          sta BehindAreaParserFlag
          sta ObjectOffset
LoopCmdE: rts
BackColC: ldy AreaDataOffset         ;get first byte again
          lda (AreaData),y
          and #%11110000             ;mask out low nybble and move high to low
          lsr
          lsr
          lsr
          lsr
          cmp CurrentColumnPos       ;is this where we're at?
          bne LeavePar               ;if not, branch to leave
StrAObj:  lda AreaDataOffset         ;if so, load area obj offset and store in buffer
          sta AreaObjOffsetBuffer,x
          jsr IncAreaObjOffset       ;do sub to increment to next object data
RunAObj:  lda $00                    ;get stored value and add offset to it
          clc                        ;then use the jump engine with current contents of A
          adc $07
          jsr JumpEngine

;large objects (rows $00-$0b or 00-11, d6-d4 set)
      .word VerticalPipe         ;used by warp pipes
      .word AreaStyleObject
      .word RowOfBricks
      .word RowOfSolidBlocks
      .word RowOfCoins
      .word ColumnOfBricks
      .word ColumnOfSolidBlocks
      .word VerticalPipe         ;used by decoration pipes

;objects for special row $0c or 12
      .word Hole_Empty
      .word PulleyRopeObject
      .word Bridge_High
      .word Bridge_Middle
      .word Bridge_Low
      .word Hole_Water
      .word QuestionBlockRow_High
      .word QuestionBlockRow_Low

;objects for special row $0f or 15
      .word EndlessRope
      .word BalancePlatRope
      .word CastleObject
      .word StaircaseObject
      .word ExitPipe
      .word FlagBalls_Residual

;small objects (rows $00-$0b or 00-11, d6-d4 all clear)
      .word QuestionBlock     ;power-up
      .word QuestionBlock     ;coin
      .word QuestionBlock     ;hidden, coin
      .word Hidden1UpBlock    ;hidden, 1-up
      .word BrickWithItem     ;brick, power-up
      .word BrickWithItem     ;brick, vine
      .word BrickWithItem     ;brick, star
      .word BrickWithCoins    ;brick, coins
      .word BrickWithItem     ;brick, 1-up
      .word WaterPipe
      .word EmptyBlock
      .word Jumpspring

;objects for special row $0d or 13 (d6 set)
      .word IntroPipe
      .word FlagpoleObject
      .word AxeObj
      .word ChainObj
      .word CastleBridgeObj
      .word ScrollLockObject_Warp
      .word ScrollLockObject
      .word ScrollLockObject
      .word AreaFrenzy            ;flying cheep-cheeps
      .word AreaFrenzy            ;bullet bills or swimming cheep-cheeps
      .word AreaFrenzy            ;stop frenzy
      .word LoopCmdE

;object for special row $0e or 14
      .word AlterAreaAttributes

;-------------------------------------------------------------------------------------
;(these apply to all area object subroutines in this section unless otherwise stated)
;$00 - used to store offset used to find object code
;$07 - starts with adder from area parser, used to store row offset

AlterAreaAttributes:
         ldy AreaObjOffsetBuffer,x ;load offset for level object data saved in buffer
         iny                       ;load second byte
         lda (AreaData),y
         pha                       ;save in stack for now
         and #%01000000
         bne Alter2                ;branch if d6 is set
         pla
         pha                       ;pull and push offset to copy to A
         and #%00001111            ;mask out high nybble and store as
         sta TerrainControl        ;new terrain height type bits
         pla
         and #%00110000            ;pull and mask out all but d5 and d4
         lsr                       ;move bits to lower nybble and store
         lsr                       ;as new background scenery bits
         lsr
         lsr
         sta BackgroundScenery     ;then leave
         rts
Alter2:  pla
         and #%00000111            ;mask out all but 3 LSB
         cmp #$04                  ;if four or greater, set color control bits
         bcc SetFore               ;and nullify foreground scenery bits
         sta BackgroundColorCtrl
         lda #$00
SetFore: sta ForegroundScenery     ;otherwise set new foreground scenery bits
         rts

;--------------------------------

ScrollLockObject_Warp:
         ldx #$04            ;load value of 4 for game text routine as default
         lda WorldNumber     ;warp zone (4-3-2), then check world number
         beq WarpNum
         inx                 ;if world number > 1, increment for next warp zone (5)
         ldy AreaType        ;check area type
         dey
         bne WarpNum         ;if ground area type, increment for last warp zone
         inx                 ;(8-7-6) and move on
WarpNum: txa
         sta WarpZoneControl ;store number here to be used by warp zone routine
         jsr WriteGameText   ;print text and warp zone numbers
         lda #PiranhaPlant
         jsr KillEnemies     ;load identifier for piranha plants and do sub

ScrollLockObject:
      lda ScrollLock      ;invert scroll lock to turn it on
      eor #%00000001
      sta ScrollLock
      rts

;--------------------------------
;$00 - used to store enemy identifier in KillEnemies

KillEnemies:
           sta $00           ;store identifier here
           lda #$00
           ldx #$04          ;check for identifier in enemy object buffer
KillELoop: ldy Enemy_ID,x
           cpy $00           ;if not found, branch
           bne NoKillE
           sta Enemy_Flag,x  ;if found, deactivate enemy object flag
NoKillE:   dex               ;do this until all slots are checked
           bpl KillELoop
           rts

;--------------------------------

FrenzyIDData:
      .byte FlyCheepCheepFrenzy, BBill_CCheep_Frenzy, Stop_Frenzy

AreaFrenzy:  ldx $00               ;use area object identifier bit as offset
             lda FrenzyIDData-8,x  ;note that it starts at 8, thus weird address here
             ldy #$05
FreCompLoop: dey                   ;check regular slots of enemy object buffer
             bmi ExitAFrenzy       ;if all slots checked and enemy object not found, branch to store
             cmp Enemy_ID,y    ;check for enemy object in buffer versus frenzy object
             bne FreCompLoop
             lda #$00              ;if enemy object already present, nullify queue and leave
ExitAFrenzy: sta EnemyFrenzyQueue  ;store enemy into frenzy queue
             rts

;--------------------------------
;$06 - used by MushroomLedge to store length

AreaStyleObject:
      lda AreaStyle        ;load level object style and jump to the right sub
      jsr JumpEngine
      .word TreeLedge        ;also used for cloud type levels
      .word MushroomLedge
      .word BulletBillCannon

TreeLedge:
          jsr GetLrgObjAttrib     ;get row and length of green ledge
          lda AreaObjectLength,x  ;check length counter for expiration
          beq EndTreeL
          bpl MidTreeL
          tya
          sta AreaObjectLength,x  ;store lower nybble into buffer flag as length of ledge
          lda CurrentPageLoc
          ora CurrentColumnPos    ;are we at the start of the level?
          beq MidTreeL
          lda #$16                ;render start of tree ledge
          jmp NoUnder
MidTreeL: ldx $07
          lda #$17                ;render middle of tree ledge
          sta MetatileBuffer,x    ;note that this is also used if ledge position is
          lda #$4c                ;at the start of level for continuous effect
          jmp AllUnder            ;now render the part underneath
EndTreeL: lda #$18                ;render end of tree ledge
          jmp NoUnder

MushroomLedge:
          jsr ChkLrgObjLength        ;get shroom dimensions
          sty $06                    ;store length here for now
          bcc EndMushL
          lda AreaObjectLength,x     ;divide length by 2 and store elsewhere
          lsr
          sta MushroomLedgeHalfLen,x
          lda #$19                   ;render start of mushroom
          jmp NoUnder
EndMushL: lda #$1b                   ;if at the end, render end of mushroom
          ldy AreaObjectLength,x
          beq NoUnder
          lda MushroomLedgeHalfLen,x ;get divided length and store where length
          sta $06                    ;was stored originally
          ldx $07
          lda #$1a
          sta MetatileBuffer,x       ;render middle of mushroom
          cpy $06                    ;are we smack dab in the center?
          bne MushLExit              ;if not, branch to leave
          inx
          lda #$4f
          sta MetatileBuffer,x       ;render stem top of mushroom underneath the middle
          lda #$50
AllUnder: inx
          ldy #$0f                   ;set $0f to render all way down
          jmp RenderUnderPart       ;now render the stem of mushroom
NoUnder:  ldx $07                    ;load row of ledge
          ldy #$00                   ;set 0 for no bottom on this part
          jmp RenderUnderPart

;--------------------------------

;tiles used by pulleys and rope object
PulleyRopeMetatiles:
      .byte $42, $41, $43

PulleyRopeObject:
           jsr ChkLrgObjLength       ;get length of pulley/rope object
           ldy #$00                  ;initialize metatile offset
           bcs RenderPul             ;if starting, render left pulley
           iny
           lda AreaObjectLength,x    ;if not at the end, render rope
           bne RenderPul
           iny                       ;otherwise render right pulley
RenderPul: lda PulleyRopeMetatiles,y
           sta MetatileBuffer        ;render at the top of the screen
MushLExit: rts                       ;and leave

;--------------------------------
;$06 - used to store upper limit of rows for CastleObject

CastleMetatiles:
      .byte $00, $45, $45, $45, $00
      .byte $00, $48, $47, $46, $00
      .byte $45, $49, $49, $49, $45
      .byte $47, $47, $4a, $47, $47
      .byte $47, $47, $4b, $47, $47
      .byte $49, $49, $49, $49, $49
      .byte $47, $4a, $47, $4a, $47
      .byte $47, $4b, $47, $4b, $47
      .byte $47, $47, $47, $47, $47
      .byte $4a, $47, $4a, $47, $4a
      .byte $4b, $47, $4b, $47, $4b

CastleObject:
            jsr GetLrgObjAttrib      ;save lower nybble as starting row
            sty $07                  ;if starting row is above $0a, game will crash!!!
            ldy #$04
            jsr ChkLrgObjFixedLength ;load length of castle if not already loaded
            txa
            pha                      ;save obj buffer offset to stack
            ldy AreaObjectLength,x   ;use current length as offset for castle data
            ldx $07                  ;begin at starting row
            lda #$0b
            sta $06                  ;load upper limit of number of rows to print
CRendLoop:  lda CastleMetatiles,y    ;load current byte using offset
            sta MetatileBuffer,x
            inx                      ;store in buffer and increment buffer offset
            lda $06
            beq ChkCFloor            ;have we reached upper limit yet?
            iny                      ;if not, increment column-wise
            iny                      ;to byte in next row
            iny
            iny
            iny
            dec $06                  ;move closer to upper limit
ChkCFloor:  cpx #$0b                 ;have we reached the row just before floor?
            bne CRendLoop            ;if not, go back and do another row
            pla
            tax                      ;get obj buffer offset from before
            lda CurrentPageLoc
            beq ExitCastle           ;if we're at page 0, we do not need to do anything else
            lda AreaObjectLength,x   ;check length
            cmp #$01                 ;if length almost about to expire, put brick at floor
            beq PlayerStop
            ldy $07                  ;check starting row for tall castle ($00)
            bne NotTall
            cmp #$03                 ;if found, then check to see if we're at the second column
            beq PlayerStop
NotTall:    cmp #$02                 ;if not tall castle, check to see if we're at the third column
            bne ExitCastle           ;if we aren't and the castle is tall, don't create flag yet
            jsr GetAreaObjXPosition  ;otherwise, obtain and save horizontal pixel coordinate
            pha
            jsr FindEmptyEnemySlot   ;find an empty place on the enemy object buffer
            pla
            sta Enemy_X_Position,x   ;then write horizontal coordinate for star flag
            lda CurrentPageLoc
            sta Enemy_PageLoc,x      ;set page location for star flag
            lda #$01
            sta Enemy_Y_HighPos,x    ;set vertical high byte
            sta Enemy_Flag,x         ;set flag for buffer
            lda #$90
            sta Enemy_Y_Position,x   ;set vertical coordinate
            lda #StarFlagObject      ;set star flag value in buffer itself
            sta Enemy_ID,x
            rts
PlayerStop: ldy #$52                 ;put brick at floor to stop player at end of level
            sty MetatileBuffer+10    ;this is only done if we're on the second column
ExitCastle: rts

;--------------------------------

WaterPipe:
      jsr GetLrgObjAttrib     ;get row and lower nybble
      ldy AreaObjectLength,x  ;get length (residual code, water pipe is 1 col thick)
      ldx $07                 ;get row
      lda #$6b
      sta MetatileBuffer,x    ;draw something here and below it
      lda #$6c
      sta MetatileBuffer+1,x
      rts

;--------------------------------
;$05 - used to store length of vertical shaft in RenderSidewaysPipe
;$06 - used to store leftover horizontal length in RenderSidewaysPipe
; and vertical length in VerticalPipe and GetPipeHeight

IntroPipe:
               ldy #$03                 ;check if length set, if not set, set it
               jsr ChkLrgObjFixedLength
               ldy #$0a                 ;set fixed value and render the sideways part
               jsr RenderSidewaysPipe
               bcs NoBlankP             ;if carry flag set, not time to draw vertical pipe part
               ldx #$06                 ;blank everything above the vertical pipe part
VPipeSectLoop: lda #$00                 ;all the way to the top of the screen
               sta MetatileBuffer,x     ;because otherwise it will look like exit pipe
               dex
               bpl VPipeSectLoop
               lda VerticalPipeData,y   ;draw the end of the vertical pipe part
               sta MetatileBuffer+7
NoBlankP:      rts

SidePipeShaftData:
      .byte $15, $14  ;used to control whether or not vertical pipe shaft
      .byte $00, $00  ;is drawn, and if so, controls the metatile number
SidePipeTopPart:
      .byte $15, $1e  ;top part of sideways part of pipe
      .byte $1d, $1c
SidePipeBottomPart:
      .byte $15, $21  ;bottom part of sideways part of pipe
      .byte $20, $1f

ExitPipe:
      ldy #$03                 ;check if length set, if not set, set it
      jsr ChkLrgObjFixedLength
      jsr GetLrgObjAttrib      ;get vertical length, then plow on through RenderSidewaysPipe

RenderSidewaysPipe:
              dey                       ;decrement twice to make room for shaft at bottom
              dey                       ;and store here for now as vertical length
              sty $05
              ldy AreaObjectLength,x    ;get length left over and store here
              sty $06
              ldx $05                   ;get vertical length plus one, use as buffer offset
              inx
              lda SidePipeShaftData,y   ;check for value $00 based on horizontal offset
              cmp #$00
              beq DrawSidePart          ;if found, do not draw the vertical pipe shaft
              ldx #$00
              ldy $05                   ;init buffer offset and get vertical length
              jsr RenderUnderPart       ;and render vertical shaft using tile number in A
              clc                       ;clear carry flag to be used by IntroPipe
DrawSidePart: ldy $06                   ;render side pipe part at the bottom
              lda SidePipeTopPart,y
              sta MetatileBuffer,x      ;note that the pipe parts are stored
              lda SidePipeBottomPart,y  ;backwards horizontally
              sta MetatileBuffer+1,x
              rts

VerticalPipeData:
      .byte $11, $10 ;used by pipes that lead somewhere
      .byte $15, $14
      .byte $13, $12 ;used by decoration pipes
      .byte $15, $14

VerticalPipe:
          jsr GetPipeHeight
          lda $00                  ;check to see if value was nullified earlier
          beq WarpPipe             ;(if d3, the usage control bit of second byte, was set)
          iny
          iny
          iny
          iny                      ;add four if usage control bit was not set
WarpPipe: tya                      ;save value in stack
          pha
          lda AreaNumber
          ora WorldNumber          ;if at world 1-1, do not add piranha plant ever
          beq DrawPipe
          ldy AreaObjectLength,x   ;if on second column of pipe, branch
          beq DrawPipe             ;(because we only need to do this once)
          jsr FindEmptyEnemySlot   ;check for an empty moving data buffer space
          bcs DrawPipe             ;if not found, too many enemies, thus skip
          jsr GetAreaObjXPosition  ;get horizontal pixel coordinate
          clc
          adc #$08                 ;add eight to put the piranha plant in the center
          sta Enemy_X_Position,x   ;store as enemy's horizontal coordinate
          lda CurrentPageLoc       ;add carry to current page number
          adc #$00
          sta Enemy_PageLoc,x      ;store as enemy's page coordinate
          lda #$01
          sta Enemy_Y_HighPos,x
          sta Enemy_Flag,x         ;activate enemy flag
          jsr GetAreaObjYPosition  ;get piranha plant's vertical coordinate and store here
          sta Enemy_Y_Position,x
          lda #PiranhaPlant        ;write piranha plant's value into buffer
          sta Enemy_ID,x
          jsr InitPiranhaPlant
DrawPipe: pla                      ;get value saved earlier and use as Y
          tay
          ldx $07                  ;get buffer offset
          lda VerticalPipeData,y   ;draw the appropriate pipe with the Y we loaded earlier
          sta MetatileBuffer,x     ;render the top of the pipe
          inx
          lda VerticalPipeData+2,y ;render the rest of the pipe
          ldy $06                  ;subtract one from length and render the part underneath
          dey
          jmp RenderUnderPart

GetPipeHeight:
      ldy #$01       ;check for length loaded, if not, load
      jsr ChkLrgObjFixedLength ;pipe length of 2 (horizontal)
      jsr GetLrgObjAttrib
      tya            ;get saved lower nybble as height
      and #$07       ;save only the three lower bits as
      sta $06        ;vertical length, then load Y with
      ldy AreaObjectLength,x    ;length left over
      rts

FindEmptyEnemySlot:
              ldx #$00          ;start at first enemy slot
EmptyChkLoop: clc               ;clear carry flag by default
              lda Enemy_Flag,x  ;check enemy buffer for nonzero
              beq ExitEmptyChk  ;if zero, leave
              inx
              cpx #$05          ;if nonzero, check next value
              bne EmptyChkLoop
ExitEmptyChk: rts               ;if all values nonzero, carry flag is set

;--------------------------------

Hole_Water:
      jsr ChkLrgObjLength   ;get low nybble and save as length
      lda #$86              ;render waves
      sta MetatileBuffer+10
      ldx #$0b
      ldy #$01              ;now render the water underneath
      lda #$87
      jmp RenderUnderPart

;--------------------------------

QuestionBlockRow_High:
      lda #$03    ;start on the fourth row
      .byte $2c     ;BIT instruction opcode

QuestionBlockRow_Low:
      lda #$07             ;start on the eighth row
      pha                  ;save whatever row to the stack for now
      jsr ChkLrgObjLength  ;get low nybble and save as length
      pla
      tax                  ;render question boxes with coins
      lda #$c0
      sta MetatileBuffer,x
      rts

;--------------------------------

Bridge_High:
      lda #$06  ;start on the seventh row from top of screen
      .byte $2c   ;BIT instruction opcode

Bridge_Middle:
      lda #$07  ;start on the eighth row
      .byte $2c   ;BIT instruction opcode

Bridge_Low:
      lda #$09             ;start on the tenth row
      pha                  ;save whatever row to the stack for now
      jsr ChkLrgObjLength  ;get low nybble and save as length
      pla
      tax                  ;render bridge railing
      lda #$0b
      sta MetatileBuffer,x
      inx
      ldy #$00             ;now render the bridge itself
      lda #$63
      jmp RenderUnderPart

;--------------------------------

FlagBalls_Residual:
      jsr GetLrgObjAttrib  ;get low nybble from object byte
      ldx #$02             ;render flag balls on third row from top
      lda #$6d             ;of screen downwards based on low nybble
      jmp RenderUnderPart

;--------------------------------

FlagpoleObject:
      lda #$24                 ;render flagpole ball on top
      sta MetatileBuffer
      ldx #$01                 ;now render the flagpole shaft
      ldy #$08
      lda #$25
      jsr RenderUnderPart
      lda #$61                 ;render solid block at the bottom
      sta MetatileBuffer+10
      jsr GetAreaObjXPosition
      sec                      ;get pixel coordinate of where the flagpole is,
      sbc #$08                 ;subtract eight pixels and use as horizontal
      sta Enemy_X_Position+5   ;coordinate for the flag
      lda CurrentPageLoc
      sbc #$00                 ;subtract borrow from page location and use as
      sta Enemy_PageLoc+5      ;page location for the flag
      lda #$30
      sta Enemy_Y_Position+5   ;set vertical coordinate for flag
      lda #$b0
      sta FlagpoleFNum_Y_Pos   ;set initial vertical coordinate for flagpole's floatey number
      lda #FlagpoleFlagObject
      sta Enemy_ID+5           ;set flag identifier, note that identifier and coordinates
      inc Enemy_Flag+5         ;use last space in enemy object buffer
      rts

;--------------------------------

EndlessRope:
      ldx #$00       ;render rope from the top to the bottom of screen
      ldy #$0f
      jmp DrawRope

BalancePlatRope:
          txa                 ;save object buffer offset for now
          pha
          ldx #$01            ;blank out all from second row to the bottom
          ldy #$0f            ;with blank used for balance platform rope
          lda #$44
          jsr RenderUnderPart
          pla                 ;get back object buffer offset
          tax
          jsr GetLrgObjAttrib ;get vertical length from lower nybble
          ldx #$01
DrawRope: lda #$40            ;render the actual rope
          jmp RenderUnderPart

;--------------------------------

CoinMetatileData:
      .byte $c3, $c2, $c2, $c2

RowOfCoins:
      ldy AreaType            ;get area type
      lda CoinMetatileData,y  ;load appropriate coin metatile
      jmp GetRow

;--------------------------------

C_ObjectRow:
      .byte $06, $07, $08

C_ObjectMetatile:
      .byte $c5, $0c, $89

CastleBridgeObj:
      ldy #$0c                  ;load length of 13 columns
      jsr ChkLrgObjFixedLength
      jmp ChainObj

AxeObj:
      lda #$08                  ;load bowser's palette into sprite portion of palette
      sta VRAM_Buffer_AddrCtrl

ChainObj:
      ldy $00                   ;get value loaded earlier from decoder
      ldx C_ObjectRow-2,y       ;get appropriate row and metatile for object
      lda C_ObjectMetatile-2,y
      jmp ColObj

EmptyBlock:
        jsr GetLrgObjAttrib  ;get row location
        ldx $07
        lda #$c4
ColObj: ldy #$00             ;column length of 1
        jmp RenderUnderPart

;--------------------------------

SolidBlockMetatiles:
      .byte $69, $61, $61, $62

BrickMetatiles:
      .byte $22, $51, $52, $52
      .byte $88 ;used only by row of bricks object

RowOfBricks:
            ldy AreaType           ;load area type obtained from area offset pointer
            lda CloudTypeOverride  ;check for cloud type override
            beq DrawBricks
            ldy #$04               ;if cloud type, override area type
DrawBricks: lda BrickMetatiles,y   ;get appropriate metatile
            jmp GetRow             ;and go render it

RowOfSolidBlocks:
         ldy AreaType               ;load area type obtained from area offset pointer
         lda SolidBlockMetatiles,y  ;get metatile
GetRow:  pha                        ;store metatile here
         jsr ChkLrgObjLength        ;get row number, load length
DrawRow: ldx $07
         ldy #$00                   ;set vertical height of 1
         pla
         jmp RenderUnderPart        ;render object

ColumnOfBricks:
      ldy AreaType          ;load area type obtained from area offset
      lda BrickMetatiles,y  ;get metatile (no cloud override as for row)
      jmp GetRow2

ColumnOfSolidBlocks:
         ldy AreaType               ;load area type obtained from area offset
         lda SolidBlockMetatiles,y  ;get metatile
GetRow2: pha                        ;save metatile to stack for now
         jsr GetLrgObjAttrib        ;get length and row
         pla                        ;restore metatile
         ldx $07                    ;get starting row
         jmp RenderUnderPart        ;now render the column

;--------------------------------

BulletBillCannon:
             jsr GetLrgObjAttrib      ;get row and length of bullet bill cannon
             ldx $07                  ;start at first row
             lda #$64                 ;render bullet bill cannon
             sta MetatileBuffer,x
             inx
             dey                      ;done yet?
             bmi SetupCannon
             lda #$65                 ;if not, render middle part
             sta MetatileBuffer,x
             inx
             dey                      ;done yet?
             bmi SetupCannon
             lda #$66                 ;if not, render bottom until length expires
             jsr RenderUnderPart
SetupCannon: ldx Cannon_Offset        ;get offset for data used by cannons and whirlpools
             jsr GetAreaObjYPosition  ;get proper vertical coordinate for cannon
             sta Cannon_Y_Position,x  ;and store it here
             lda CurrentPageLoc
             sta Cannon_PageLoc,x     ;store page number for cannon here
             jsr GetAreaObjXPosition  ;get proper horizontal coordinate for cannon
             sta Cannon_X_Position,x  ;and store it here
             inx
             cpx #$06                 ;increment and check offset
             bcc StrCOffset           ;if not yet reached sixth cannon, branch to save offset
             ldx #$00                 ;otherwise initialize it
StrCOffset:  stx Cannon_Offset        ;save new offset and leave
             rts

;--------------------------------

StaircaseHeightData:
      .byte $07, $07, $06, $05, $04, $03, $02, $01, $00

StaircaseRowData:
      .byte $03, $03, $04, $05, $06, $07, $08, $09, $0a

StaircaseObject:
           jsr ChkLrgObjLength       ;check and load length
           bcc NextStair             ;if length already loaded, skip init part
           lda #$09                  ;start past the end for the bottom
           sta StaircaseControl      ;of the staircase
NextStair: dec StaircaseControl      ;move onto next step (or first if starting)
           ldy StaircaseControl
           ldx StaircaseRowData,y    ;get starting row and height to render
           lda StaircaseHeightData,y
           tay
           lda #$61                  ;now render solid block staircase
           jmp RenderUnderPart

;--------------------------------

Jumpspring:
      jsr GetLrgObjAttrib
      jsr FindEmptyEnemySlot      ;find empty space in enemy object buffer
      jsr GetAreaObjXPosition     ;get horizontal coordinate for jumpspring
      sta Enemy_X_Position,x      ;and store
      lda CurrentPageLoc          ;store page location of jumpspring
      sta Enemy_PageLoc,x
      jsr GetAreaObjYPosition     ;get vertical coordinate for jumpspring
      sta Enemy_Y_Position,x      ;and store
      sta Jumpspring_FixedYPos,x  ;store as permanent coordinate here
      lda #JumpspringObject
      sta Enemy_ID,x              ;write jumpspring object to enemy object buffer
      ldy #$01

	  pha ; inserted by me ;
      sta Enemy_Y_HighPos,x  	  ;store vertical high byte
	  pla

      inc Enemy_Flag,x            ;set flag for enemy object buffer
      ldx $07
      lda #$67                    ;draw metatiles in two rows where jumpspring is
      sta MetatileBuffer,x
      lda #$68
      sta MetatileBuffer+1,x
      rts

;--------------------------------
;$07 - used to save ID of brick object

Hidden1UpBlock:
      lda Hidden1UpFlag  ;if flag not set, do not render object
      beq ExitDecBlock
      lda #$00           ;if set, init for the next one
      sta Hidden1UpFlag
      jmp BrickWithItem  ;jump to code shared with unbreakable bricks

QuestionBlock:
      jsr GetAreaObjectID ;get value from level decoder routine
      jmp DrawQBlk        ;go to render it

BrickWithCoins:
      lda #$00                 ;initialize multi-coin timer flag
      sta BrickCoinTimerFlag

BrickWithItem:
          jsr GetAreaObjectID         ;save area object ID
          sty $07
          lda #$00                    ;load default adder for bricks with lines
          ldy AreaType                ;check level type for ground level
          dey
          beq BWithL                  ;if ground type, do not start with 5
          lda #$05                    ;otherwise use adder for bricks without lines
BWithL:   clc                         ;add object ID to adder
          adc $07
          tay                         ;use as offset for metatile
DrawQBlk: lda BrickQBlockMetatiles,y  ;get appropriate metatile for brick (question block
          pha                         ;if branched to here from question block routine)
          jsr GetLrgObjAttrib         ;get row from location byte
          jmp DrawRow                 ;now render the object

GetAreaObjectID:
              lda $00    ;get value saved from area parser routine
              sec
              sbc #$00   ;possibly residual code
              tay        ;save to Y
ExitDecBlock: rts

;--------------------------------

HoleMetatiles:
      .byte $87, $00, $00, $00

Hole_Empty:
            jsr ChkLrgObjLength          ;get lower nybble and save as length
            bcc NoWhirlP                 ;skip this part if length already loaded
            lda AreaType                 ;check for water type level
            bne NoWhirlP                 ;if not water type, skip this part
            ldx Whirlpool_Offset         ;get offset for data used by cannons and whirlpools
            jsr GetAreaObjXPosition      ;get proper vertical coordinate of where we're at
            sec
            sbc #$10                     ;subtract 16 pixels
            sta Whirlpool_LeftExtent,x   ;store as left extent of whirlpool
            lda CurrentPageLoc           ;get page location of where we're at
            sbc #$00                     ;subtract borrow
            sta Whirlpool_PageLoc,x      ;save as page location of whirlpool
            iny
            iny                          ;increment length by 2
            tya
            asl                          ;multiply by 16 to get size of whirlpool
            asl                          ;note that whirlpool will always be
            asl                          ;two blocks bigger than actual size of hole
            asl                          ;and extend one block beyond each edge
            sta Whirlpool_Length,x       ;save size of whirlpool here
            inx
            cpx #$05                     ;increment and check offset
            bcc StrWOffset               ;if not yet reached fifth whirlpool, branch to save offset
            ldx #$00                     ;otherwise initialize it
StrWOffset: stx Whirlpool_Offset         ;save new offset here
NoWhirlP:   ldx AreaType                 ;get appropriate metatile, then
            lda HoleMetatiles,x          ;render the hole proper
            ldx #$08
            ldy #$0f                     ;start at ninth row and go to bottom, run RenderUnderPart

;--------------------------------

RenderUnderPart:
             sty AreaObjectHeight  ;store vertical length to render
             ldy MetatileBuffer,x  ;check current spot to see if there's something
             beq DrawThisRow       ;we need to keep, if nothing, go ahead
             cpy #$17
             beq WaitOneRow        ;if middle part (tree ledge), wait until next row
             cpy #$1a
             beq WaitOneRow        ;if middle part (mushroom ledge), wait until next row
             cpy #$c0
             beq DrawThisRow       ;if question block w/ coin, overwrite
             cpy #$c0
             bcs WaitOneRow        ;if any other metatile with palette 3, wait until next row
             cpy #$54
             bne DrawThisRow       ;if cracked rock terrain, overwrite
             cmp #$50
             beq WaitOneRow        ;if stem top of mushroom, wait until next row
DrawThisRow: sta MetatileBuffer,x  ;render contents of A from routine that called this
WaitOneRow:  inx
             cpx #$0d              ;stop rendering if we're at the bottom of the screen
             bcs ExitUPartR
             ldy AreaObjectHeight  ;decrement, and stop rendering if there is no more length
             dey
             bpl RenderUnderPart
ExitUPartR:  rts

;--------------------------------

ChkLrgObjLength:
        jsr GetLrgObjAttrib     ;get row location and size (length if branched to from here)

ChkLrgObjFixedLength:
        lda AreaObjectLength,x  ;check for set length counter
        clc                     ;clear carry flag for not just starting
        bpl LenSet              ;if counter not set, load it, otherwise leave alone
        tya                     ;save length into length counter
        sta AreaObjectLength,x
        sec                     ;set carry flag if just starting
LenSet: rts


GetLrgObjAttrib:
      ldy AreaObjOffsetBuffer,x ;get offset saved from area obj decoding routine
      lda (AreaData),y          ;get first byte of level object
      and #%00001111
      sta $07                   ;save row location
      iny
      lda (AreaData),y          ;get next byte, save lower nybble (length or height)
      and #%00001111            ;as Y, then leave
      tay
      rts

;--------------------------------

GetAreaObjXPosition:
      lda CurrentColumnPos    ;multiply current offset where we're at by 16
      asl                     ;to obtain horizontal pixel coordinate
      asl
      asl
      asl
      rts

;--------------------------------

GetAreaObjYPosition:
      lda $07  ;multiply value by 16
      asl
      asl      ;this will give us the proper vertical pixel coordinate
      asl
      asl
      clc
      adc #32  ;add 32 pixels for the status bar
      rts

WriteGameText:
  rts ; we can ignore this for now, it only displays warp zone messages to the screen and other things, not so essential

  ; this is so itll assemble, need to remove when actual enemy routines are put in ;
