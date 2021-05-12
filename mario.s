.SETCPU "65C02"
.SEGMENT "STARTUP"
.SEGMENT "INIT"
.SEGMENT "ONCE"
	sei
	cld
	jsr preserve_default_irq
	jmp setup

.include "macros.s"
.include "vsync.s"
.include "data.s"

tiles_data_table:
	.res $100,$00
overworld_palette:
	.incbin "overworld_palette.bin"
custom_tiles_name:
	.byte "mario_background.chr"
custom_tiles_name_end:
custom_tiles:
	.incbin "mario_background.chr"
custom_tiles_end:
sprite_data:
	.incbin "mario_sprites.chr"
sprite_data_end:
; allows for the palette data in the default level
; processing to convert to how the x16 palette is laid out
; i could rearrange them but id dont cause im lazy, barely any less efficient ;
default_palette_table:
	.byte $06*16, $05*16, $07*16, $00*16
overworld_mysterybox:
	.byte $A2, $0E, $50, $0A, $20, $05, $50, $0A
mysterybox_no:
	.byte $00
hud_text:
	.byte $20, $20, $20, $4D, $41, $52, $49, $4F, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $57, $4F, $52, $4C, $44, $20, $20, $20, $54, $49, $4D, $45
hud_text_end:
; $02 = always advance, $01 = advance if running ;
timing_frame_dat:
; neither = 00
; running = 10 
; walking = 01
; both    =	11
	.byte %11, %00, %00, %00, %10, %00, %01, %00, %10, %00, %00, %00
	.byte %11, %00, %00, %00, %10, %00, %01, %00, %10, %00, %00, %00
frame_data:
	;little mario ;
	; mario standing still ;
	.byte $3A, $00, $37, $00, $4F, $00, $4F, $01
	; mario running frame 1 ;
	.byte $32, $00, $33, $00, $34, $00, $35, $00
	; mario running frame 2 ;
	.byte $36, $00, $37, $00, $38, $00, $39, $00
	; mario running frame 3;
	.byte $36, $00, $37, $00, $3B, $00, $3C, $00
	; mario jumping ;
	.byte $32, $00, $41, $00, $42, $00, $43, $00
	; mario turning ;
quit:
	.byte $00
paused:
	.byte $00
mario_accel:
	.byte $00; x and y acceleration ;
mario_yAccel:
	.byte $00
mario_vel:
	.byte $00
mario_yVel:
	.byte $00 ; x and y vel ;
mario_pos:
	.byte $00, $00
mario_data:
; inair, walk frame, powerup, direction, ground_run ;
; powerup: 0 = small 1=mushroom 2=fire flower ;
	.byte $00, $00, $00, $00, $00
player_x:
	.byte $00, $00
player_y:
	.byte $00, $00
map_scroll:
	.byte $00, $00, $00, $00
temp_scroll:
	.byte $00, $00
timer_frames:
	.byte $00
inLevel:
	.byte $00
LoadMoreAreaFlag:
	.byte $00
NES_RAM:
	.res $800,$00
NES_RAM_end:

	ObjectOffset          = $08
	
	FrameCounter          = $09
	
	SavedJoypadBits       = $06fc+NES_RAM
	controller_input = SavedJoypad1Bits
	SavedJoypad1Bits      = $06fc+NES_RAM
	SavedJoypad2Bits      = $06fd+NES_RAM
	JoypadBitMask         = $074a+NES_RAM
	JoypadOverride        = $0758+NES_RAM
	
	A_B_Buttons           = $0a
	PreviousA_B_Buttons   = $0d
	Up_Down_Buttons       = $0b
	Left_Right_Buttons    = $0c
	
	GameEngineSubroutine  = $0e
	
	Mirror_PPU_CTRL_REG1  = $0778+NES_RAM
	Mirror_PPU_CTRL_REG2  = $0779+NES_RAM
	
	OperMode              = $0770+NES_RAM
	OperMode_Task         = $0772+NES_RAM
	ScreenRoutineTask     = $073c+NES_RAM
	
	GamePauseStatus       = $0776+NES_RAM
	GamePauseTimer        = $0777+NES_RAM
	
	DemoAction            = $0717+NES_RAM
	DemoActionTimer       = $0718+NES_RAM
	
	TimerControl          = $0747+NES_RAM
	IntervalTimerControl  = $077f+NES_RAM
	
	Timers                = $0780+NES_RAM
	SelectTimer           = $0780+NES_RAM
	PlayerAnimTimer       = $0781+NES_RAM
	JumpSwimTimer         = $0782+NES_RAM
	RunningTimer          = $0783+NES_RAM
	BlockBounceTimer      = $0784+NES_RAM
	SideCollisionTimer    = $0785+NES_RAM
	JumpspringTimer       = $0786+NES_RAM
	GameTimerCtrlTimer    = $0787+NES_RAM
	ClimbSideTimer        = $0789+NES_RAM
	EnemyFrameTimer       = $078a+NES_RAM
	FrenzyEnemyTimer      = $078f+NES_RAM
	BowserFireBreathTimer = $0790+NES_RAM
	StompTimer            = $0791+NES_RAM
	AirBubbleTimer        = $0792+NES_RAM
	ScrollIntervalTimer   = $0795+NES_RAM
	EnemyIntervalTimer    = $0796+NES_RAM
	BrickCoinTimer        = $079d+NES_RAM
	InjuryTimer           = $079e+NES_RAM
	StarInvincibleTimer   = $079f+NES_RAM
	ScreenTimer           = $07a0+NES_RAM
	WorldEndTimer         = $07a1+NES_RAM
	DemoTimer             = $07a2+NES_RAM
	
	Sprite_Data           = $0200+NES_RAM
	
	Sprite_Y_Position     = $0200+NES_RAM
	Sprite_Tilenumber     = $0201+NES_RAM
	Sprite_Attributes     = $0202+NES_RAM
	Sprite_X_Position     = $0203+NES_RAM
	
	ScreenEdge_PageLoc    = $071a+NES_RAM
	ScreenEdge_X_Pos      = $071c+NES_RAM
	ScreenLeft_PageLoc    = $071a+NES_RAM
	ScreenRight_PageLoc   = $071b+NES_RAM
	ScreenLeft_X_Pos      = $071c+NES_RAM
	ScreenRight_X_Pos     = $071d+NES_RAM
	
	PlayerFacingDir       = $33+NES_RAM
	DestinationPageLoc    = $34
	VictoryWalkControl    = $35+NES_RAM 
	ScrollFractional      = $0768+NES_RAM
	PrimaryMsgCounter     = $0719+NES_RAM
	SecondaryMsgCounter   = $0749+NES_RAM
	
	HorizontalScroll      = $073f+NES_RAM
	VerticalScroll        = $0740+NES_RAM
	ScrollLock            = $0723+NES_RAM
	ScrollThirtyTwo       = $073d+NES_RAM
	Player_X_Scroll       = $06ff+NES_RAM
	Player_Pos_ForScroll  = $0755+NES_RAM
	ScrollAmount          = $0775+NES_RAM
	
	AreaData              = $e7
	AreaDataLow           = $e7
	AreaDataHigh          = $e8
	EnemyData             = $e9
	EnemyDataLow          = $e9
	EnemyDataHigh         = $ea
	
	AreaParserTaskNum     = $071f+NES_RAM
	ColumnSets            = $071e+NES_RAM
	CurrentPageLoc        = $0725+NES_RAM
	CurrentColumnPos      = $0726+NES_RAM
	BackloadingFlag       = $0728+NES_RAM
	BehindAreaParserFlag  = $0729+NES_RAM
	AreaObjectPageLoc     = $072a+NES_RAM
	AreaObjectPageSel     = $072b+NES_RAM
	AreaDataOffset        = $072c+NES_RAM
	AreaObjOffsetBuffer   = $072d+NES_RAM
	AreaObjectLength      = $0730+NES_RAM
	StaircaseControl      = $0734+NES_RAM
	AreaObjectHeight      = $0735+NES_RAM
	MushroomLedgeHalfLen  = $0736+NES_RAM
	EnemyDataOffset       = $0739+NES_RAM
	EnemyObjectPageLoc    = $073a+NES_RAM
	EnemyObjectPageSel    = $073b+NES_RAM
	MetatileBuffer        = $06a1+NES_RAM
	BlockBufferColumnPos  = $06a0+NES_RAM
	CurrentNTAddr_Low     = $0721+NES_RAM
	CurrentNTAddr_High    = $0720+NES_RAM
	AttributeBuffer       = $03f9+NES_RAM
	
	LoopCommand           = $0745+NES_RAM
	
	DisplayDigits         = $07d7+NES_RAM
	TopScoreDisplay       = $07d7+NES_RAM
	ScoreAndCoinDisplay   = $07dd+NES_RAM
	PlayerScoreDisplay    = $07dd+NES_RAM
	score = PlayerScoreDisplay
	GameTimerDisplay      = $07f8+NES_RAM
	timer = GameTimerDisplay
	DigitModifier         = $0134+NES_RAM
	
	VerticalFlipFlag      = $0109+NES_RAM
	FloateyNum_Control    = $0110+NES_RAM
	ShellChainCounter     = $0125+NES_RAM
	FloateyNum_Timer      = $012c+NES_RAM
	FloateyNum_X_Pos      = $0117+NES_RAM
	FloateyNum_Y_Pos      = $011e+NES_RAM
	FlagpoleFNum_Y_Pos    = $010d+NES_RAM
	FlagpoleFNum_YMFDummy = $010e+NES_RAM
	FlagpoleScore         = $010f+NES_RAM
	FlagpoleCollisionYPos = $070f+NES_RAM
	StompChainCounter     = $0484+NES_RAM
	
	VRAM_Buffer1_Offset   = $0300+NES_RAM
	VRAM_Buffer1          = $0301+NES_RAM
	VRAM_Buffer2_Offset   = $0340+NES_RAM
	VRAM_Buffer2          = $0341+NES_RAM
	VRAM_Buffer_AddrCtrl  = $0773+NES_RAM
	Sprite0HitDetectFlag  = $0722+NES_RAM
	DisableScreenFlag     = $0774+NES_RAM
	DisableIntermediate   = $0769+NES_RAM
	ColorRotateOffset     = $06d4+NES_RAM
	
	TerrainControl        = $0727+NES_RAM
	AreaStyle             = $0733+NES_RAM
	ForegroundScenery     = $0741+NES_RAM
	BackgroundScenery     = $0742+NES_RAM
	CloudTypeOverride     = $0743+NES_RAM
	BackgroundColorCtrl   = $0744+NES_RAM
	AreaType              = $074e+NES_RAM
	AreaAddrsLOffset      = $074f+NES_RAM
	AreaPointer           = $0750+NES_RAM
	
	PlayerEntranceCtrl    = $0710+NES_RAM
	GameTimerSetting      = $0715+NES_RAM
	AltEntranceControl    = $0752+NES_RAM
	EntrancePage          = $0751+NES_RAM
	NumberOfPlayers       = $077a+NES_RAM
	WarpZoneControl       = $06d6+NES_RAM
	ChangeAreaTimer       = $06de+NES_RAM
	
	MultiLoopCorrectCntr  = $06d9+NES_RAM
	MultiLoopPassCntr     = $06da+NES_RAM
	
	FetchNewGameTimerFlag = $0757+NES_RAM
	GameTimerExpiredFlag  = $0759+NES_RAM
	
	PrimaryHardMode       = $076a+NES_RAM
	SecondaryHardMode     = $06cc+NES_RAM
	WorldSelectNumber     = $076b+NES_RAM
	WorldSelectEnableFlag = $07fc+NES_RAM
	ContinueWorld         = $07fd+NES_RAM
	
	CurrentPlayer         = $0753+NES_RAM
	PlayerSize            = $0754+NES_RAM
	PlayerStatus          = $0756+NES_RAM
	
	OnscreenPlayerInfo    = $075a+NES_RAM
	NumberofLives         = $075a+NES_RAM ;used by current player
	lives = NumberofLives
	HalfwayPage           = $075b+NES_RAM
	LevelNumber           = $075c+NES_RAM ;the actual dash number
	Hidden1UpFlag         = $075d+NES_RAM
	CoinTally             = $075e+NES_RAM
	WorldNumber           = $075f+NES_RAM
	world = WorldNumber
	AreaNumber            = $0760+NES_RAM ;internal number used to find areas
	level = AreaNumber
	
	CoinTallyFor1Ups      = $0748+NES_RAM
	coins = CoinTallyFor1Ups
	
	OffscreenPlayerInfo   = $0761+NES_RAM
	OffScr_NumberofLives  = $0761+NES_RAM ;used by offscreen player
	OffScr_HalfwayPage    = $0762+NES_RAM
	OffScr_LevelNumber    = $0763+NES_RAM
	OffScr_Hidden1UpFlag  = $0764+NES_RAM
	OffScr_CoinTally      = $0765+NES_RAM
	OffScr_WorldNumber    = $0766+NES_RAM
	OffScr_AreaNumber     = $0767+NES_RAM
	
	BalPlatformAlignment  = $03a0+NES_RAM
	Platform_X_Scroll     = $03a1+NES_RAM
	PlatformCollisionFlag = $03a2+NES_RAM
	YPlatformTopYPos      = $0401+NES_RAM
	YPlatformCenterYPos   = $58
	
	BrickCoinTimerFlag    = $06bc+NES_RAM
	StarFlagTaskControl   = $0746+NES_RAM
	
	PseudoRandomBitReg    = $07a7+NES_RAM
	WarmBootValidation    = $07ff+NES_RAM
	
	SprShuffleAmtOffset   = $06e0+NES_RAM
	SprShuffleAmt         = $06e1+NES_RAM
	SprDataOffset         = $06e4+NES_RAM
	Player_SprDataOffset  = $06e4+NES_RAM
	Enemy_SprDataOffset   = $06e5+NES_RAM
	Block_SprDataOffset   = $06ec+NES_RAM
	Alt_SprDataOffset     = $06ec+NES_RAM
	Bubble_SprDataOffset  = $06ee+NES_RAM
	FBall_SprDataOffset   = $06f1+NES_RAM
	Misc_SprDataOffset    = $06f3+NES_RAM
	SprDataOffset_Ctrl    = $03ee+NES_RAM
	
	Player_State          = $1d
	Enemy_State           = $1e
	Fireball_State        = $24
	Block_State           = $26
	Misc_State            = $2a
	
	Player_MovingDir      = $45
	Enemy_MovingDir       = $46
	
	SprObject_X_Speed     = $57
	Player_X_Speed        = $57
	Enemy_X_Speed         = $58
	Fireball_X_Speed      = $5e
	Block_X_Speed         = $60
	Misc_X_Speed          = $64
	
	Jumpspring_FixedYPos  = $58
	JumpspringAnimCtrl    = $070e+NES_RAM
	JumpspringForce       = $06db+NES_RAM
	
	SprObject_PageLoc     = $6d
	Player_PageLoc        = $6d
	Enemy_PageLoc         = $6e
	Fireball_PageLoc      = $74+NES_RAM
	Block_PageLoc         = $76+NES_RAM
	Misc_PageLoc          = $7a+NES_RAM
	Bubble_PageLoc        = $83+NES_RAM
	
	SprObject_X_Position  = $86+NES_RAM
	Player_X_Position     = $86+NES_RAM
	Enemy_X_Position      = $87+NES_RAM
	Fireball_X_Position   = $8d+NES_RAM
	Block_X_Position      = $8f+NES_RAM
	Misc_X_Position       = $93+NES_RAM
	Bubble_X_Position     = $9c+NES_RAM
	
	SprObject_Y_Speed     = $9f+NES_RAM
	Player_Y_Speed        = $9f+NES_RAM
	Enemy_Y_Speed         = $a0+NES_RAM
	Fireball_Y_Speed      = $a6+NES_RAM
	Block_Y_Speed         = $a8+NES_RAM
	Misc_Y_Speed          = $ac
	
	SprObject_Y_HighPos   = $b5
	Player_Y_HighPos      = $b5
	Enemy_Y_HighPos       = $b6
	Fireball_Y_HighPos    = $bc
	Block_Y_HighPos       = $be
	Misc_Y_HighPos        = $c2
	Bubble_Y_HighPos      = $cb
	
	SprObject_Y_Position  = $ce
	Player_Y_Position     = $ce
	Enemy_Y_Position      = $cf
	Fireball_Y_Position   = $d5
	Block_Y_Position      = $d7
	Misc_Y_Position       = $db
	Bubble_Y_Position     = $e4
	
	SprObject_Rel_XPos    = $03ad+NES_RAM
	Player_Rel_XPos       = $03ad+NES_RAM
	Enemy_Rel_XPos        = $03ae+NES_RAM
	Fireball_Rel_XPos     = $03af+NES_RAM
	Bubble_Rel_XPos       = $03b0+NES_RAM
	Block_Rel_XPos        = $03b1+NES_RAM
	Misc_Rel_XPos         = $03b3+NES_RAM
	
	SprObject_Rel_YPos    = $03b8+NES_RAM
	Player_Rel_YPos       = $03b8+NES_RAM
	Enemy_Rel_YPos        = $03b9+NES_RAM
	Fireball_Rel_YPos     = $03ba+NES_RAM
	Bubble_Rel_YPos       = $03bb+NES_RAM
	Block_Rel_YPos        = $03bc+NES_RAM
	Misc_Rel_YPos         = $03be+NES_RAM
	
	SprObject_SprAttrib   = $03c4+NES_RAM
	Player_SprAttrib      = $03c4+NES_RAM
	Enemy_SprAttrib       = $03c5+NES_RAM
	
	SprObject_X_MoveForce = $0400+NES_RAM
	Enemy_X_MoveForce     = $0401+NES_RAM
	
	SprObject_YMF_Dummy   = $0416+NES_RAM
	Player_YMF_Dummy      = $0416+NES_RAM
	Enemy_YMF_Dummy       = $0417+NES_RAM
	Bubble_YMF_Dummy      = $042c+NES_RAM
	
	SprObject_Y_MoveForce = $0433+NES_RAM
	Player_Y_MoveForce    = $0433+NES_RAM
	Enemy_Y_MoveForce     = $0434+NES_RAM
	Block_Y_MoveForce     = $043c+NES_RAM
	
	DisableCollisionDet   = $0716+NES_RAM
	Player_CollisionBits  = $0490+NES_RAM
	Enemy_CollisionBits   = $0491+NES_RAM
	
	SprObj_BoundBoxCtrl   = $0499+NES_RAM
	Player_BoundBoxCtrl   = $0499+NES_RAM
	Enemy_BoundBoxCtrl    = $049a+NES_RAM
	Fireball_BoundBoxCtrl = $04a0+NES_RAM
	Misc_BoundBoxCtrl     = $04a2+NES_RAM
	
	EnemyFrenzyBuffer     = $06cb+NES_RAM
	EnemyFrenzyQueue      = $06cd+NES_RAM
	Enemy_Flag            = $0f
	Enemy_ID              = $16
	
	PlayerGfxOffset       = $06d5+NES_RAM
	Player_XSpeedAbsolute = $0700+NES_RAM
	FrictionAdderHigh     = $0701+NES_RAM
	FrictionAdderLow      = $0702+NES_RAM
	RunningSpeed          = $0703+NES_RAM
	SwimmingFlag          = $0704+NES_RAM
	Player_X_MoveForce    = $0705+NES_RAM
	DiffToHaltJump        = $0706+NES_RAM
	JumpOrigin_Y_HighPos  = $0707+NES_RAM
	JumpOrigin_Y_Position = $0708+NES_RAM
	VerticalForce         = $0709+NES_RAM
	VerticalForceDown     = $070a+NES_RAM
	PlayerChangeSizeFlag  = $070b+NES_RAM
	PlayerAnimTimerSet    = $070c+NES_RAM
	PlayerAnimCtrl        = $070d+NES_RAM
	DeathMusicLoaded      = $0712+NES_RAM
	FlagpoleSoundQueue    = $0713+NES_RAM
	CrouchingFlag         = $0714+NES_RAM
	MaximumLeftSpeed      = $0450+NES_RAM
	MaximumRightSpeed     = $0456+NES_RAM
	
	SprObject_OffscrBits  = $03d0+NES_RAM
	Player_OffscreenBits  = $03d0+NES_RAM
	Enemy_OffscreenBits   = $03d1+NES_RAM
	FBall_OffscreenBits   = $03d2+NES_RAM
	Bubble_OffscreenBits  = $03d3+NES_RAM
	Block_OffscreenBits   = $03d4+NES_RAM
	Misc_OffscreenBits    = $03d6+NES_RAM
	EnemyOffscrBitsMasked = $03d8+NES_RAM
		
	Cannon_Offset         = $046a+NES_RAM
	Cannon_PageLoc        = $046b+NES_RAM
	Cannon_X_Position     = $0471+NES_RAM
	Cannon_Y_Position     = $0477+NES_RAM
	Cannon_Timer          = $047d+NES_RAM
	
	Whirlpool_Offset      = $046a+NES_RAM
	Whirlpool_PageLoc     = $046b+NES_RAM
	Whirlpool_LeftExtent  = $0471+NES_RAM
	Whirlpool_Length      = $0477+NES_RAM
	Whirlpool_Flag        = $047d+NES_RAM
	
	VineFlagOffset        = $0398+NES_RAM
	VineHeight            = $0399+NES_RAM
	VineObjOffset         = $039a+NES_RAM
	VineStart_Y_Position  = $039d+NES_RAM
	
	Block_Orig_YPos       = $03e4+NES_RAM
	Block_BBuf_Low        = $03e6+NES_RAM
	Block_Metatile        = $03e8+NES_RAM
	Block_PageLoc2        = $03ea+NES_RAM
	Block_RepFlag         = $03ec+NES_RAM
	Block_ResidualCounter = $03f0+NES_RAM
	Block_Orig_XPos       = $03f1+NES_RAM
	
	BoundingBox_UL_XPos   = $04ac+NES_RAM
	BoundingBox_UL_YPos   = $04ad+NES_RAM
	BoundingBox_DR_XPos   = $04ae+NES_RAM
	BoundingBox_DR_YPos   = $04af+NES_RAM
	BoundingBox_UL_Corner = $04ac+NES_RAM
	BoundingBox_LR_Corner = $04ae+NES_RAM
	EnemyBoundingBoxCoord = $04b0+NES_RAM
	
	PowerUpType           = $39
	
	FireballBouncingFlag  = $3a
	FireballCounter       = $06ce+NES_RAM
	FireballThrowingTimer = $0711+NES_RAM
	
	HammerEnemyOffset     = $06ae+NES_RAM
	JumpCoinMiscOffset    = $06b7+NES_RAM
	
	Block_Buffer_1        = $0500+NES_RAM
	Block_Buffer_2        = $05d0+NES_RAM
	
	HammerThrowingTimer   = $03a2+NES_RAM
	HammerBroJumpTimer    = $3c
	Misc_Collision_Flag   = $06be+NES_RAM
	
	RedPTroopaOrigXPos    = $0401+NES_RAM
	RedPTroopaCenterYPos  = $58
	
	XMovePrimaryCounter   = $a0+NES_RAM
	XMoveSecondaryCounter = $58
	
	CheepCheepMoveMFlag   = $58
	CheepCheepOrigYPos    = $0434+NES_RAM
	BitMFilter            = $06dd+NES_RAM
	
	LakituReappearTimer   = $06d1+NES_RAM
	LakituMoveSpeed       = $58
	LakituMoveDirection   = $a0+NES_RAM
	
	FirebarSpinState_Low  = $58
	FirebarSpinState_High = $a0+NES_RAM
	FirebarSpinSpeed      = $0388+NES_RAM
	FirebarSpinDirection  = $34
	
	DuplicateObj_Offset   = $06cf+NES_RAM
	NumberofGroupEnemies  = $06d3+NES_RAM
	
	BlooperMoveCounter    = $a0+NES_RAM
	BlooperMoveSpeed      = $58
	
	BowserBodyControls    = $0363+NES_RAM
	BowserFeetCounter     = $0364+NES_RAM
	BowserMovementSpeed   = $0365+NES_RAM
	BowserOrigXPos        = $0366+NES_RAM
	BowserFlameTimerCtrl  = $0367+NES_RAM
	BowserFront_Offset    = $0368+NES_RAM
	BridgeCollapseOffset  = $0369+NES_RAM
	BowserGfxFlag         = $036a+NES_RAM
	BowserHitPoints       = $0483+NES_RAM
	MaxRangeFromOrigin    = $06dc+NES_RAM
	
	BowserFlamePRandomOfs = $0417+NES_RAM
	
	PiranhaPlantUpYPos    = $0417+NES_RAM
	PiranhaPlantDownYPos  = $0434+NES_RAM
	PiranhaPlant_Y_Speed  = $58
	PiranhaPlant_MoveFlag = $a0+NES_RAM
	
	FireworksCounter      = $06d7+NES_RAM
	ExplosionGfxCounter   = $58 ;+NES_RAM
	ExplosionTimerCounter = $a0+NES_RAM
	
	;sound related defines
	Squ2_NoteLenBuffer    = $07b3+NES_RAM
	Squ2_NoteLenCounter   = $07b4+NES_RAM
	Squ2_EnvelopeDataCtrl = $07b5+NES_RAM
	Squ1_NoteLenCounter   = $07b6+NES_RAM
	Squ1_EnvelopeDataCtrl = $07b7+NES_RAM
	Tri_NoteLenBuffer     = $07b8+NES_RAM
	Tri_NoteLenCounter    = $07b9+NES_RAM
	Noise_BeatLenCounter  = $07ba+NES_RAM
	Squ1_SfxLenCounter    = $07bb+NES_RAM
	Squ2_SfxLenCounter    = $07bd+NES_RAM
	Sfx_SecondaryCounter  = $07be+NES_RAM
	Noise_SfxLenCounter   = $07bf+NES_RAM
	
	PauseSoundQueue       = $fa ;+NES_RAM
	Square1SoundQueue     = $ff ;+NES_RAM
	Square2SoundQueue     = $fe ;+NES_RAM
	NoiseSoundQueue       = $fd ;+NES_RAM
	AreaMusicQueue        = $fb ;+NES_RAM
	EventMusicQueue       = $fc ;+NES_RAM
	
	Square1SoundBuffer    = $f1 ;+NES_RAM
	Square2SoundBuffer    = $f2 ;+NES_RAM
	NoiseSoundBuffer      = $f3 ;+NES_RAM
	AreaMusicBuffer       = $f4 ;+NES_RAM
	EventMusicBuffer      = $07b1+NES_RAM
	PauseSoundBuffer      = $07b2+NES_RAM
	
	MusicData             = $f5+NES_RAM
	MusicDataLow          = $f5+NES_RAM
	MusicDataHigh         = $f6+NES_RAM
	MusicOffset_Square2   = $f7+NES_RAM
	MusicOffset_Square1   = $f8+NES_RAM
	MusicOffset_Triangle  = $f9+NES_RAM
	MusicOffset_Noise     = $07b0+NES_RAM
	
	NoteLenLookupTblOfs   = $f0+NES_RAM
	DAC_Counter           = $07c0+NES_RAM
	NoiseDataLoopbackOfs  = $07c1+NES_RAM
	NoteLengthTblAdder    = $07c4+NES_RAM
	AreaMusicBuffer_Alt   = $07c5+NES_RAM
	PauseModeFlag         = $07c6+NES_RAM
	GroundMusicHeaderOfs  = $07c7+NES_RAM
	AltRegContentFlag     = $07ca+NES_RAM
; end of OG Game Code defines 


setup:
	lda #$0E
	jsr $FFD2

	lda #$00
	sta $9F25
	sta $9F30
	sta $9F31
	sta $9F32
	sta $9F33

	lda #124 ; default character set
	sta $9F2F ; L0_TILEBASE
	lda #%11010000 ; vram addr % 1 1010 0000 0000 0000
	sta $9F2E ; L0_MAPBASE
	lda #$10 ; %01 01 0000
	sta $9F2D ; L0_CONFIG

	lda #$00
	sta $9F20
	lda #$A0
	sta $9F21
	lda #$11
	sta $9F22

	ldx #$20
	ldy #$FE
	@l_l0:
	stx $9F23
	sty $9F23

	lda $9F21
	cmp #$A0+$10
	bcc @l_l0

	lda #%01110001
	sta $9F29

	lda #$40
	sta $9F2A
	sta $9F2B
	
	; load tiles into ram ; 
	;ldx #<custom_tiles_name
	;ldy #>custom_tiles_name
	;lda #custom_tiles_name_end-custom_tiles_name
	;jsr $FFBD ;SETNAM
	
	;lda #$FF ; file #
	;ldx #$08 ; device no #8 (sd card / disk drive)
	;ldy #$FF ; needs to be here 
	;jsr $FFBA ; SETLFS 
	
	;lda #$01 
	;sta $00 
	
	;lda #0 
	;ldx #$00
	;ldy #$A0
	;jsr $FFD5
	
	; load tiles ;
	lda #%01100001
	sta $9F34 ; 2bpp mode
	lda #%10000000
	sta $9F36 ; tile base address ($1 00 00)
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
	ldx #<overworld_palette
	ldy #>overworld_palette
	jsr loadPalette

	; load sprites into ram next ;
	lda #$00
	sta $9F20
	lda #$40
	sta $9F21
	lda #$11
	sta $9F22

	lda #<sprite_data
	sta $10
	lda #>sprite_data
	sta $11

	@l_sprite:
	ldy #$00
	lda ($10),Y
	sta $9F23

	clc ; increment address to read from ;
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

	; from setup code in smb1 ;
	ldy #ColdBootOffset          ;load default cold boot pointer
    ldx #$05                     ;this is where we check for a warm boot
	@WBootCheck:  
	lda TopScoreDisplay,x        ;check each score digit in the top score
    cmp #10                      ;to see if we have a valid digit
    bcs @ColdBoot                 ;if not, give up and proceed with cold boot
    dex                      
    bpl @WBootCheck
    lda WarmBootValidation       ;second checkpoint, check to see if 
    cmp #$a5                     ;another location has a specific value
    bne @ColdBoot   
    ldy #WarmBootOffset          ;if passed both, load warm boot pointer
	@ColdBoot:    
	jsr InitializeMemory         ;clear memory using pointer in Y
    sta OperMode                 ;reset primary mode of operation
    lda #$a5                     ;set warm boot flag
    sta WarmBootValidation     


	; coords for player sprite ;
	lda #0
	sta level ; World 1-1
	sta world
	lda #3
	sta lives
	jsr loadNewLevel
	
	jmp main

loadPalette:
	stx $10
	stx $12
	sty $11
	iny
	sty $13

	lda #$00
	sta $9F20
	lda #$FA
	sta $9F21
	lda #$11
	sta $9F22
	ldy #0

	@l_palette:
	lda ($10),Y
	sta $9F23

	lda ($12),Y
	sta $9F23

	iny
	cpy #0
	bne @l_palette
	rts
main:
	; fills the screen with blank tiles
	lda #$00
	sta $9F20
	sta $9F21
	lda #$10
	sta $9F22

	ldx #$24
	ldy #$00
	@l:
	stx $9F23 
	sty $9F23 
	
	lda $9F21
	cmp #4 
	bcc @l
	cmp #30 
	bcs @endL
	lda #29
	sta $9F21 
	jmp @l
	@endL:
	
	jsr createHUD
	
	lda #$03
	sta lives 
	lda #$00
	sta lives+1
	sta coins 
	sta coins+1
	sta score
	sta score+1
	sta score+2
	sta score+3
	sta score+4
	sta score+5
	lda #$01
	sta quit
	sta inLevel
	jsr set_custom_irq_handler
	@t:
	
	lda LoadMoreAreaFlag
	beq @dontLoadMore
	
	jsr loadMoreLevelData
	lda #$00
	sta LoadMoreAreaFlag
	@dontLoadMore:
	 
	lda quit
	cmp #$00
	bne @t

end:
	jsr reset_irq_handler
	;ldx #<default_palette
	;ldy #>default_palette
	;jsr loadPalette
	lda #%10000000
	sta $9F25 
	brk ; break, is the end of the program ;
	rts

outOfTime:
	lda inLevel
	bne @d
	rts
	@d:
die:
	lda #0
	sta timer+1
	sta timer+2
	lda #04
	sta timer

	ldx lives
	cpx #00
	bne @singleDigit
	ldy lives+1
	cpy #00
	beq @gameOver
	dey
	sty lives+1
	ldx #10
	@singleDigit:
	dex
	stx lives
	rts
	@gameOver:
	; kill player ; 
	rts
game:
	lda paused
	and inLevel
	beq @unpaused

	lda controller_input
	sta controller_input+1

	lda #$00
	jsr $FF56
	sta controller_input
	and #START_BUTTON
	bne @end_paused
	lda #0
	sta paused
	@end_paused:
	rts

	@unpaused:

	ldx timer_frames
	inx
	stx timer_frames
	cpx #24
	bcc @dontDecTimer
	ldx #$00
	stx timer_frames

	lda timer+2
	bne @c2
	ldy #10
	sty timer+2
	lda timer+1
	bne @c1
	ldy #10
	sty timer+1
	lda timer
	bne @c0 
	jsr outOfTime
	@c0:
	dec timer
	@c1:
	dec timer+1
	@c2:
	dec timer+2
	
	; makes sure all the timer bytes are < 10
	lda #9
	cmp timer 
	bcs @c0_1
	sta timer
	@c0_1:
	cmp timer+1 
	bcs @c1_1
	sta timer+1
	@c1_1:
	cmp timer+2
	bcs @c2_1
	sta timer+2
	@c2_1:
	
	@dontDecTimer:
		
	
	; controller input ;
	lda controller_input
	sta controller_input+1

	; change mystery box/coin palette ;
	lda timer_frames
	ldx mysterybox_no
	cpx #$00
	bne @notyellow
	cmp #8
	bne @dontChangeCoinPalette
	jmp @changeCoinPalette
	@notyellow:
	cmp #0
	beq @changeCoinPalette
	cmp #16
	beq @changeCoinPalette
	jmp @dontChangeCoinPalette

	@changeCoinPalette:
	lda #$11
	sta $9F22
	lda #$FA
	sta $9F21
	lda #$04
	sta $9F20

	inx
	cpx #$04
	bcc @n_loop
	ldx #$00
	@n_loop:
	stx mysterybox_no
	txa
	asl
	tax
	@l_mys:
	lda overworld_mysterybox,X
	sta $9F23
	inx
	lda overworld_mysterybox,X
	sta $9F23

	@dontChangeCoinPalette:

	lda mario_data
	bne @handleController
	lda mario_vel
	beq @handleController
	bpl @applyNegativeAcceleration
	cmp #256-4
	bcs @dontCap1
	lda #256-4
	@dontCap1:
	sta $10
	lda #$00
	sbc $10
	sta mario_accel
	jmp @handleController
	@applyNegativeAcceleration:
	cmp #04
	bcc @dontCap2
	lda #04
	@dontCap2:
	sta $10
	lda #$00
	sbc $10
	sta mario_accel

	@handleController:

	lda #$00
	jsr $FF56 ; get input from joystick ;
	cmp #00
	bne @doController
	jmp @doneWithJoy
	@doController:
	sta controller_input
	sta $9000

	; select button pressed ;
	lda controller_input
	and #SEL_BUTTON ; button pressed -> %0000 0000, not -> %0010 0000
	bne @selNotPressed
	lda #$00
	sta quit
	@selNotPressed:
	; left d-pad ;
	lda controller_input
	and #LT_BUTTON
	bne @leftNotPressed
	lda #256-2
	sta mario_accel
	@leftNotPressed:

	; right on d-pad ;
	lda controller_input
	and #RT_BUTTON
	bne @rightNotPressed
	lda #2
	sta mario_accel
	@rightNotPressed:

	; up on d pad for testing ;
	lda controller_input
	and #UP_BUTTON
	bne @upNotPressed
	@upNotPressed:

	; start button ;
	lda controller_input
	and #START_BUTTON
	bne @startNotPressed
	eor paused
	sta paused
	@startNotPressed:

	lda mario_data  
	bne @checkBPress
	lda #0
	sta mario_data+4 ; not running 
	@checkBPress:
	; b button ;
	lda controller_input
	and #B_BUTTON
	bne @bNotPressed
	lda #1
	sta mario_data+4
	@bNotPressed:

	; a button ;
	lda controller_input
	and #A_BUTTON
	bne @aNotPressed
	lda #$01
	lda mario_data ; check if mario is jumping ;
	jsr jump

	@aNotPressed:

	;lda mario_data
	;bne @doneWithJoy
	lda controller_input ; check if b button pressed
	and #B_BUTTON
	beq @doneWithJoy
	lda mario_vel
	bmi @capNegativeVel
	; cap positive velocity 
	lda mario_vel
	cmp #$13
	bcc @doneWithJoy
	lda #$13
	sta mario_vel
	jmp @doneWithJoy
	@capNegativeVel:
	lda mario_vel
	cmp #256-$13
	bcs @doneWithJoy
	lda #256-$13
	sta mario_vel

	@doneWithJoy:

	clc
	lda mario_vel
	adc mario_accel
	sta mario_vel

	bmi @check_minus
	; check positive x velocity ;
	cmp #$20
	bcc @done_vel_check
	lda #$20
	sta mario_vel
	jmp @done_vel_check
	@check_minus:
	; check negative x velocity ;
	cmp #256-$1E
	bcs @done_vel_check
	lda #256-$1E
	sta mario_vel
	@done_vel_check:


	lda mario_vel
	cmp #$FF
	bcs @setVelZero
	cmp #$02
	bcc @setVelZero
	jmp @applyVel
	@setVelZero:
	lda #$00
	sta mario_vel
	sta mario_accel

	@applyVel:
	; apply mario's velocity to marios position ;
	lda mario_vel
	bpl @rightwardsVel
	lda #$00
	sbc mario_vel
	sec
	sta $10 ; store this velocity
	lda player_x
	sbc $10 ; subtract it ;
	sta player_x
	lda player_x+1
	sbc #$00
	sta player_x+1
	jmp @velApplied
	@rightwardsVel:
	clc
	adc player_x
	sta player_x
	lda player_x+1
	adc #$00
	sta player_x+1

	@velApplied:

	lda player_x+1
	cmp #$FF
	bne @XnotOOB
	lda #$00
	sta player_x
	sta player_x+1
	@XnotOOB:
	lda player_y+1
	cmp #$FF
	bne @YnotOOB
	lda #$00
	sta player_y
	sta player_y+1
	@YnotOOB:

	lda mario_yVel ; yVel
	adc mario_yAccel
	sta mario_yVel


	jmp @yVelApplied ; dont move mario up and down ;
	lda mario_yVel
	bpl @downwardsVel
	lda #$00
	sbc mario_yVel
	sec
	sta $10 ; store this velocity
	lda player_y
	sbc $10 ; subtract it ;
	sta player_y
	lda player_y+1
	sbc #$00
	sta player_y+1
	jmp @yVelApplied
	@downwardsVel:
	clc
	adc player_y
	sta player_y
	lda player_y+1
	adc #$00
	sta player_y+1
	@yVelApplied:

	; draw mario ;
	lda mario_vel
	cmp #$00
	bne @Moving
	ldx #$00
	stx mario_data+1
	jmp @d0
	@Moving:
	lda controller_input
	and #B_BUTTON
	bne @notRunning
	
	ldy timer_frames
	lda timing_frame_dat,Y
	and #2
	bne @nextWalkFrame
	jmp @d0
	
	@notRunning: 
	
	ldy timer_frames
	lda timing_frame_dat,Y
	and #1
	bne @nextWalkFrame
	jmp @d0 
	
	@nextWalkFrame:
	ldx mario_data+1
	inx
	stx mario_data+1
	cpx #$03
	bne @d0
	ldx #$01
	stx mario_data+1

	@d0:
	lda mario_data+2 ; check powerup ;
	cmp #$02
	bcs @fire
	lda #$01
	@fire:
	lda #$00
	sta $17


	lda player_x
	sta $12
	lda player_x+1
	;sta $13

	lsr A
	sta $13
	ror $12
	lsr $13
	ror $12
	lsr $13
	ror $12
	lsr $13
	ror $12 ; divide x / 16

	lda player_y
	sta $14
	lda player_y+1
	;sta $15

	lsr A
	sta $15
	ror $14
	lsr $15
	ror $14
	lsr $15
	ror $14
	lsr $15
	ror $14 ; divide y / 16

	; scroll screen ;
	lda map_scroll
	sta map_scroll+2
	lda map_scroll+1
	sta map_scroll+3

	lda ScrollLock
	bne @noScroll

	sec
	lda $12
	sbc #SCROLL_POINT
	bcc @noScroll
	beq @noScroll
	sta $02
	lda $13
	sbc #$00
	sta $03

	clc
	lda $02
	adc map_scroll
	sta map_scroll
	lda $03
	adc map_scroll+1
	sta map_scroll+1

	lda #$00
	sta $13
	lda #SCROLL_POINT
	sta $12


	lda player_x
	and	#%00001111 ; 32-1
	clc
	adc #.lobyte(SCROLL_POINT * 16)
	sta player_x
	lda #.hibyte(SCROLL_POINT * 16)
	adc #0
	sta player_x+1
	@noScroll:

	lda map_scroll
	sta VERA_X_SCROLL_LO
	and #%11110000
	sta temp_scroll
	lda map_scroll+1 ; higher scroll values
	sta VERA_X_SCROLL_HI
	sta temp_scroll+1

	; draw more screen if scrolling ;
	
	sec 
	lda temp_scroll 
	cmp map_scroll+2 
	; since temp scroll only has the top four bytes itll only be greater if difference > 16 ;
	beq @n1 ; has to be greater, not just equal ;
	bcs @LoadMoreLevel
	@n1:
	lda temp_scroll+1
	cmp map_scroll+3
	beq @dontLoad 
	bcs @LoadMoreLevel
	
	lda temp_scroll+1
		
	jmp @dontLoad
	@LoadMoreLevel: 
	
	lda #$01
	sta LoadMoreAreaFlag
	
	
	@dontLoad: 
	; draw sprite now kinda sorta ;
	lda mario_vel
	cmp #$00
	beq @actuallyDrawSprite
	cmp #$80
	bcs @lVel
	lda #$00
	jmp @storeDirection
	@lVel:
	lda #$01
	@storeDirection:
	sta mario_data+3

	; check for super mario ;
	lda mario_data+2
	cmp #$00
	beq @a
	jmp @big
	@a:

	@actuallyDrawSprite:

	lda mario_data+3
	cmp #$01
	beq @facingLeft

	; @facingRight: ;
	lda #$00
	sta $16
	sta $17
	lda mario_data+1
	asl
	asl
	asl
	tay
	ldx #$00

	@l_drawLittleMario:
	lda frame_data,Y
	sta $18
	iny
	lda frame_data,Y
	eor mario_data+3
	sta $19
	iny
	stx $1A

	; 			mem, sprite, x, x-off, y, y-off, palette offset, flip
	;write_sprite $1A, $18, $12, $16, $14, $17, #$02, $19 ; draw sprite for real
	jsr drawSprite

	inx
	clc
	lda $16
	adc #$08
	sta $16
	cmp #$10
	bcc @l_drawLittleMario
	lda #$00
	sta $16
	lda $17
	adc #$07 ; carry has to be set ;
	sta $17
	cmp #$10
	bcc @l_drawLittleMario
	jmp @doneWithMarioSprite

	@facingLeft:
	lda #$00
	sta $16 ; x offset of sprite ;
	lda #$08
	sta $17  ; y offset ;

	lda mario_data+1
	clc
	adc #$01
	asl
	asl
	asl
	tay
	dey
	ldx #$03

	@l_drawLittleMarioLeft:
	lda frame_data,Y
	eor mario_data+3
	sta $19
	dey
	lda frame_data,Y
	sta $18
	dey
	stx $1A

	; 			 mem, sprite, x, x-off, y, y-off, palette offset, flip
	;write_sprite $1A, $18, $12, $16, $14, $17, #$02, $19 ; draw sprite for real
	jsr drawSprite

	dex
	clc
	lda $16
	adc #$08
	sta $16
	cmp #$10
	bcc @l_drawLittleMarioLeft
	lda #$00
	sta $16
	lda $17
	sbc #$08 ; carry has to be set
	sta $17
	cmp #$00
	beq @l_drawLittleMarioLeft

	jmp @doneWithMarioSprite

	@big:

	@doneWithMarioSprite:

	jsr updateHUD
	rts

jump:
	lda #$01
	cmp mario_data
	bcs @end
	sta mario_data

	@end:
	rts
	
progressLevel:
	ldx level
	cpx #3 ; 4 - 1
	bcs @nextWorld
	inx
	stx level
	jmp @end
	@nextWorld:
	ldx #0
	stx level
	inc world
	@end:
loadNewLevel:
	; initialize some variables ;
	lda #01
	sta inLevel 
	lda #4
	sta timer
	lda #0
	sta timer+1
	sta timer+2
	sta map_scroll
	sta map_scroll+1
	sta mario_data
	sta mario_data+1
	sta mario_data+3
	sta mysterybox_no
	sta ScrollLock
	sta paused
	; load the level ;
	lda #$01
	sta BackloadingFlag
	jsr LoadAreaPointer
	jsr InitializeArea
	@loop_loadLevel:
	pha 
	jsr loadMoreLevelData
	pla 
	inc A
	cmp #32
	bcc @loop_loadLevel
	
	; find starting position for mario ;
	lda #4		; 2
	sta $9F20	; x
	lda #27 	; 29 
	sta $9F21 	; y
	
	lda #$a8 ; autodecrement of 512 bytes, 2 rows 
	sta $9F22 
	@loop_checkGround:
	lda $9F21 
	cmp #5 
	bcc @finalizePlayerPosition
	
	lda $9F23 
	cmp #$24
	;tax 
	;lda tiles_data_table,X
	; and #%00000001
	bne @loop_checkGround
	
	@finalizePlayerPosition:
	lda #0 
	sta player_y+1
	lda $9F21
	
	asl A
	sta player_y
	rol player_y+1
	asl player_y
	rol player_y+1
	asl player_y
	rol player_y+1 ; y * 8 ; correct pixel position 
	
	asl player_y
	rol player_y+1
	asl player_y
	rol player_y+1
	asl player_y
	rol player_y+1
	asl player_y
	rol player_y+1 ; 16 subpixels per pixel 
	
	; 2 in $9F20 * 8 = 16, 16 subpixels per pixel 
	lda #<(16*16)
	sta player_x
	lda #>(16*16)
	sta player_x+1
	
	rts

loadMoreLevelData:
	jsr AreaParserCore
	jsr RenderAreaGraphics
	jsr IncrementColumnPos
	
	rts 
; ------------------------------------------------------------------------------------------- ;
; ORIGINAL SMB1 CODE;
InitializeArea:
    ldy #$4b                 ;clear all memory again, only as far as $074b
    jsr InitializeMemory     ;this is only necessary if branching from
    ldx #$21
    lda #$00
@ClrTimersLoop: 
	sta Timers,x             ;clear out memory between
    dex                      ;$0780 and $07a1
    bpl @ClrTimersLoop
    lda HalfwayPage
    ldy AltEntranceControl   ;if AltEntranceControl not set, use halfway page, if any found
    beq @StartPage
    lda EntrancePage         ;otherwise use saved entry page number here
@StartPage:     
	sta ScreenLeft_PageLoc   ;set as value here
    sta CurrentPageLoc       ;also set as current page
    sta BackloadingFlag      ;set flag here if halfway page or saved entry page number found
    jsr GetScreenPosition    ;get pixel coordinates for screen borders
    ldy #$20                 ;if on odd numbered page, use $2480 as start of rendering
    and #%00000001           ;otherwise use $2080, this address used later as name table
    beq @SetInitNTHigh        ;address for rendering of game area
    ldy #$24
@SetInitNTHigh: 
	sty CurrentNTAddr_High   ;store name table address
    ldy #$80
    sty CurrentNTAddr_Low
    asl                      ;store LSB of page number in high nybble
    asl                      ;of block buffer column position
    asl
    asl
    sta BlockBufferColumnPos
    dec AreaObjectLength     ;set area object lengths for all empty
    dec AreaObjectLength+1
    dec AreaObjectLength+2
    lda #$0b                 ;set value for renderer to update 12 column sets
    sta ColumnSets           ;12 column sets = 24 metatile columns = 1 1/2 screens
    jsr GetAreaDataAddrs     ;get enemy and level addresses and load header
    ;lda PrimaryHardMode      ;check to see if primary hard mode has been activated
    ;bne @SetSecHard           ;if so, activate the secondary no matter where we're at
    lda WorldNumber          ;otherwise check world number
    cmp #World5              ;if less than 5, do not activate secondary
    bcc @CheckHalfway
    bne @SetSecHard           ;if not equal to, then world > 5, thus activate
    lda LevelNumber          ;otherwise, world 5, so check level number
    cmp #Level3              ;if 1 or 2, do not set secondary hard mode flag
    bcc @CheckHalfway
@SetSecHard:    
	inc SecondaryHardMode    ;set secondary hard mode flag for areas 5-3 and beyond
@CheckHalfway:  
	lda HalfwayPage
    beq @DoneInitArea
    lda #$02                 ;if halfway page set, overwrite start position from header
    sta PlayerEntranceCtrl
@DoneInitArea:  
	;lda #Silence             ;silence music
    ;sta AreaMusicQueue
    lda #$01                 ;disable screen output
    sta DisableScreenFlag
    ;inc OperMode_Task        ;increment one of the modes
    rts
	
IncrementColumnPos:
    inc CurrentColumnPos     ;increment column where we're at
    lda CurrentColumnPos
    and #%00001111           ;mask out higher nybble
    bne @NoColWrap
    sta CurrentColumnPos     ;if no bits left set, wrap back to zero (0-f)
    inc CurrentPageLoc       ;and increment page number where we're at
@NoColWrap:
	inc BlockBufferColumnPos ;increment column offset where we're at
    lda BlockBufferColumnPos
    and #%00011111           ;mask out all but 5 LSB (0-1f)
    sta BlockBufferColumnPos ;and save
    rts

AreaParserCore:
	lda BackloadingFlag ;check to see if we are starting right of start
	beq RenderSceneryTerrain  	;if not, go ahead and render background, foreground and terrain
	jsr ProcessAreaData	       	;otherwise skip ahead and load level data
	
RenderSceneryTerrain:
	ldx #$0c
	lda #$00
@ClrMTBuf:
	sta MetatileBuffer,x       ;clear out metatile buffer
	dex
	bpl @ClrMTBuf
	ldy BackgroundScenery      ;do we need to render the background scenery?
	beq @RendFore               ;if not, skip to check the foreground
	lda CurrentPageLoc         ;otherwise check for every third page
@ThirdP:
	cmp #$03
	bmi @RendBack               ;if less than three we're there
	sec
	sbc #$03                   ;if 3 or more, subtract 3 and
	bpl @ThirdP                 ;do an unconditional branch
@RendBack: 
	asl                        ;move results to higher nybble
	asl
	asl
	asl
	adc BSceneDataOffsets-1,y  ;add to it offset loaded from here
	adc CurrentColumnPos       ;add to the result our current column position
	tax
	lda BackSceneryData,x      ;load data from sum of offsets
	beq @RendFore               ;if zero, no scenery for that part
	pha
	and #$0f                   ;save to stack and clear high nybble
	sec
	sbc #$01                   ;subtract one (because low nybble is $01-$0c)
	sta $02                    ;save low nybble
	asl                        ;multiply by three (shift to left and add result to old one)
	adc $02                    ;note that since d7 was nulled, the carry flag is always clear
	tax                        ;save as offset for background scenery metatile data
	pla                        ;get high nybble from stack, move low
	lsr
	lsr
	lsr
	lsr
	tay                        ;use as second offset (used to determine height)
	lda #$03                   ;use previously saved memory location for counter
	sta $02
@SceLoop1:
	lda BackSceneryMetatiles,x ;load metatile data from offset of (lsb - 1) * 3
	sta MetatileBuffer,y       ;store into buffer from offset of (msb / 16)
	inx
	iny
	cpy #$0b                   ;if at this location, leave loop
	beq @RendFore
	dec $02                    ;decrement until counter expires, barring exception
	bne @SceLoop1
@RendFore:
	ldx ForegroundScenery      ;check for foreground data needed or not
	beq @RendTerr               ;if not, skip this part
	ldy FSceneDataOffsets-1,x  ;load offset from location offset by header value, then
	ldx #$00                   ;reinit X
@SceLoop2:
	lda ForeSceneryData,y      ;load data until counter expires
	beq @NoFore                 ;do not store if zero found
	sta MetatileBuffer,x
@NoFore:
	iny
	inx
	cpx #$0d                   ;store up to end of metatile buffer
	bne @SceLoop2
@RendTerr:
	ldy AreaType               ;check world type for water level
	bne @TerMTile              ;if not water level, skip this part
	lda WorldNumber            ;check world number, if not world number eight
	cmp #World8                ;then skip this part
	bne @TerMTile
	lda #$62                   ;if set as water level and world number eight,
	jmp @StoreMT                ;use castle wall metatile as terrain type
@TerMTile:
	lda TerrainMetatiles,y     ;otherwise get appropriate metatile for area type
	ldy CloudTypeOverride      ;check for cloud type override
	beq @StoreMT                ;if not set, keep value otherwise
	lda #$88                   ;use cloud block terrain
@StoreMT:
	sta $07                    ;store value here
	ldx #$00                   ;initialize X, use as metatile buffer offset
	lda TerrainControl         ;use yet another value from the header
	asl                        ;multiply by 2 and use as yet another offset
	tay
@TerrLoop:
	lda TerrainRenderBits,y    ;get one of the terrain rendering bit data
	sta $02
	iny                        ;increment Y and use as offset next time around
	sty $03
	lda CloudTypeOverride      ;skip if value here is zero
	beq @NoCloud2
	cpx #$00                   ;otherwise, check if we're doing the ceiling byte
	beq @NoCloud2
	lda $02                    ;if not, mask out all but d3
	and #%00001000
	sta $02
@NoCloud2:
	ldy #$00                   ;start at beginning of bitmasks
@TerrBChk:
	lda Bitmasks,y             ;load bitmask, then perform AND on contents of first byte
	bit $02
	beq @NextTBit               ;if not set, skip this part (do not write terrain to buffer)
	lda $07
	sta MetatileBuffer,x       ;load terrain type metatile number and store into buffer here
@NextTBit:
	inx                        ;continue until end of buffer
	cpx #$0d
	beq @RendBBuf               ;if we're at the end, break out of this loop
	lda AreaType               ;check world type for underground area
	cmp #$02
	bne @EndUChk                ;if not underground, skip this part
	cpx #$0b
	bne @EndUChk                ;if we're at the bottom of the screen, override
	lda #$54                   ;old terrain type with ground level terrain type
	sta $07
@EndUChk:
	iny                        ;increment bitmasks offset in Y
	cpy #$08
	bne @TerrBChk               ;if not all bits checked, loop back
	ldy $03
	bne @TerrLoop               ;unconditional branch, use Y to load next byte
@RendBBuf:
	jsr ProcessAreaData        ;do the area data loading routine now
	lda BlockBufferColumnPos
	jsr GetBlockBufferAddr     ;get block buffer address from where we're at
	ldx #$00
	ldy #$00                   ;init index regs and start at beginning of smaller buffer
@ChkMTLow:
	sty $02
	lda MetatileBuffer,x       ;load stored metatile number
	and #%11000000             ;mask out all but 2 MSB
	asl
	rol                        ;make %xx000000 into %000000xx
	rol
	tay                        ;use as offset in Y
	lda MetatileBuffer,x       ;reload original unmasked value here
	cmp BlockBuffLowBounds,y   ;check for certain values depending on bits set
	bcs @StrBlock               ;if equal or greater, branch
	lda #$00                   ;if less, init value before storing
@StrBlock:
	ldy $02                    ;get offset for block buffer
	sta ($06),y                ;store value into block buffer
	tya
	clc                        ;add 16 (move down one row) to offset
	adc #$10
	tay
	inx                        ;increment column value
	cpx #$0d
	bcc @ChkMTLow               ;continue until we pass last row, then leave
	rts

; initialize memory stuff, written by me ; 
InitializeMemory:
	pha 
	
	; r0 = NES_RAM , r1 = $0800 ;
	; A = $00 ;
	ldx #<NES_RAM
	stx $02 
	ldx #>NES_RAM 
	stx $03 
	pla ; use a value to see where to fill up to 
	sta $04
	ldx #$07
	stx $05
	
	lda #$00
	jmp $FEE4 ; memory_fill kernal routine 
	;rts ; shouldnt return here since its jumping so not needed ;


GetScreenPosition:
      lda ScreenLeft_X_Pos    ;get coordinate of screen's left boundary
      clc
      adc #$ff                ;add 255 pixels
      sta ScreenRight_X_Pos   ;store as coordinate of screen's right boundary
      lda ScreenLeft_PageLoc  ;get page number where left boundary is
      adc #$00                ;add carry from before
      sta ScreenRight_PageLoc ;store as page number where right boundary is
      rts
	
;numbers lower than these with the same attribute bits
;will not be stored in the block buffer
BlockBuffLowBounds:
		      .byte $10, $51, $88, $c0

.include "AreaData.s" 	; all the code for ProcessAreaData
.include "EnemyData.s"	; code for ProcessEnemyData

; this draws MetatileBuffer to the screen ;
; this routine is written by me ;
RenderAreaGraphics:
	lda CurrentColumnPos 
	sta $ff 
	
	lda CurrentPageLoc
	asl 
	asl 
	asl 
	asl 
	clc 
	adc $ff ;CurrentColumnPos / 2
	asl
	asl
    sta $9F20 
	
	lda #$03
	sta $9F21 ; start drawing from the fourth tile from the top of the screen 
	lda #$10
	sta $9F22 
	
	ldx #$00
	stx $ff 
    @RenderLoop1:
	ldx $ff
	lda MetatileBuffer,X
	jsr fetchMetaTile
	ldy $02
	
	lda $03
	sta $9F23 
	sty $9F23 
	lda $05
	sta $9F23 
	sty $9F23 
	
	lda $9F20 
	sec 
	sbc #4
	sta $9F20
	bcc @di_1
	inc $9F21 
	@di_1:
	
	lda $04
	sta $9F23 
	sty $9F23 
	lda $06
	sta $9F23
	sty $9F23 
	
	lda $9F20 
	sec 
	sbc #4
	sta $9F20 
	bcc @di_2
	inc $9F21 
	@di_2:
	
	ldx $ff
	inx 
	stx $ff 
	cpx #13
	bcc @RenderLoop1
	rts 

; draws metatile at x-y register pair on l1	
drawMetaTile:
	pha 
	txa 
	asl 
	sta $9F20 
	tya 
	asl 
	sta $9F21
	pla 		
	jsr fetchMetaTile
	lda $03
	sta $9F23 
	sty $9F23 
	lda $05
	sta $9F23 
	sty $9F23 
	
	lda $9F20 
	sec 
	sbc #4
	sta $9F20
	bcc @di_1
	inc $9F21 
	@di_1:
	
	lda $04
	sta $9F23 
	sty $9F23 
	lda $06
	sta $9F23
	sty $9F23
	rts 
	
fetchMetaTile:
	; writes the bytes of a metatile from $02 to $06 ;
	; first byte is the palette index, second on are tiles ;
	pha
	and #%11000000
	asl
	rol A
	rol A
	tax
	ldy default_palette_table,X
	sty $02
	lda MetatileGraphics_Low,X
	sta $20
	lda MetatileGraphics_High,X
	sta $21
	pla
	and #%00111111
	asl
	asl
	tay
	lda ($20),Y
	sta $03
	iny
	lda ($20),Y
	sta $04
	iny
	lda ($20),Y
	sta $05
	iny
	lda ($20),Y
	sta $06

	rts

BlockBufferAddr:
	.byte <Block_Buffer_1, <Block_Buffer_2
	.byte >Block_Buffer_1, >Block_Buffer_2

GetBlockBufferAddr:
	pha                      ;take value of A, save
	lsr                      ;move high nybble to low
	lsr
	lsr
	lsr
	tay                      ;use nybble as pointer to high byte
	lda BlockBufferAddr+2,y  ;of indirect here
	sta $07
	pla
	and #%00001111           ;pull from stack, mask out high nybble
	clc
	adc BlockBufferAddr,y    ;add to low byte
	sta $06                  ;store here and leave
	rts

;----------------------------------------------------------------------------------;

AreaDataOfsLoopback:
	.byte $12, $36, $0e, $0e, $0e, $32, $32, $32, $0a, $26, $40

;----------------------------------------------------------------------------------;

LoadAreaPointer:
	jsr FindAreaPointer  ;find it and store it here
	sta AreaPointer
GetAreaType:
	and #%01100000       ;mask out all but d6 and d5
	asl
	rol
	rol
	rol                  ;make %0xx00000 into %000000xx
	sta AreaType         ;save 2 MSB as area type
	rts

FindAreaPointer:
	ldy world       ;load offset from world variable
	lda WorldAddrOffsets,y
	clc                    ;add area number used to find data
	adc level
	tay
	lda AreaAddrOffsets,y  ;from there we have our area pointer
	rts

JumpEngine:
	asl          ;shift bit from contents of A
	tay
	pla          ;pull saved return address from stack
	sta $04      ;save to indirect
	pla
	sta $05
	iny
	lda ($04),y  ;load pointer from indirect
	sta $06      ;note that if an RTS is performed in next routine
	iny          ;it will return to the execution before the sub
	lda ($04),y  ;that called this routine
	sta $07
 	jmp ($06)    ;jump to the address we loaded


createHUD:
	; $1 A0 00 is layer 0 mapbase start
	lda #$00
	sta $9F20
	lda #$A0
	sta $9F21
	lda #$21
	sta $9F22
	ldx #$00
	@hud_uppertext:
	lda hud_text,X
	sta $9F23
	inx
	cpx #(hud_text_end-hud_text)
	bcc @hud_uppertext
updateHUD:
	ldx #134
	stx $9F20
	ldx #$A0
	stx $9F21
	lda #$21
	sta $9F22

	clc
	lda score
	adc #$30
	sta $9F23
	lda score+1
	adc #$30
	sta $9F23
	lda score+2
	adc #$30
	sta $9F23
	lda score+3
	adc #$30
	sta $9F23
	lda score+4
	adc #$30
	sta $9F23
	lda score+5
	adc #$30
	sta $9F23

	ldx #152
	stx $9F20
	lda #$18 ; lowercase x
	sta $9F23
	
	lda player_y+1
	jsr hexChars
	sty $9F23 
	stx $9F23 
	lda player_y
	jsr hexChars
	sty $9F23 
	stx $9F23 
	;clc 
	;lda coins+1
	;adc #$30
	;sta $9F23
	;lda coins
	;adc #$30
	;sta $9F23

	ldx #166
	stx $9F20
	clc
	lda world
	adc #$31
	sta $9F23
	lda #45 ; ascii dash
	sta $9F23
	lda level ; world+1 in ram
	adc #$31
	sta $9F23


	ldx #182
	stx $9F20
	clc
	lda timer
	adc #$30
	sta $9F23
	lda timer+1
	adc #$30
	sta $9F23
	lda timer+2
	adc #$30
	sta $9F23

	rts
	
drawSprite:
	lda #$02
	sta $1B
	write_sprite $1A, $18, $12, $16, $14, $17, $1B, $19
	rts

hexChars:
	pha 
	and #$0F 
	clc 
	adc #$30 
	tax 
	pla 
	lsr 
	lsr 
	lsr 
	lsr 
	clc 
	adc #$30 
	tay 
	rts 