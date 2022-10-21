; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Atari Keyboard driver, Maciej Witkowiak, 2022

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "atari.inc"

;.import KbdScanHelp6	; case change?
;.import KbdScanHelp5	; scan for modifiers and put in r1H bit 7=shift, 6=cbm, 5=ctrl
.import KbdScanHelp2	; insert into queue
;.import KbdNextKey
;.import KbdQueFlag

.global _DoKeyboardScan

.import KbdDecodeTab
.import KbdDecodeTab_SHIFT
.import KbdDecodeTab_CTRL

.segment "keyboard1"

; we enter here from IRQ with tmpPOKEY_IRQST value in A to check for BREAK (bit7=0) but we don't care

_DoKeyboardScan:
	; check for shift/control first, keep GEOS mapping
	; todo: modify by cbm key (how?)
	lda POKEY_KBCODE
	tax
	and #%11000000		; top 2 bits, 0=pressed
	sta r1H
	txa
	and #%00111111
	tax
	bbsf 6, r1H, @shift
	bbsf 7, r1H, @ctrl
	; no modifiers
	lda KbdDecodeTab, x
	bra :+
@shift:	lda KbdDecodeTab_SHIFT, x
	bra :+
@ctrl:	lda KbdDecodeTab_CTRL, x
:	jsr KbdScanHelp2
	rts

; KbdNextKey, KbdQueFlag, KBDbncTab, KBDmultTab = free space for variables

.if 0=1
_DoKeyboardScan:
	lda KbdQueFlag
	bne @1
	lda KbdNextKey
	jsr KbdScanHelp2
	LoadB KbdQueFlag, 15
@1:	LoadB r1H, 0
	jsr KbdScanRow
	bne @5
	jsr KbdScanHelp5
	ldy #7
@2:	jsr KbdScanRow
	bne @5
	lda KbdTestTab,y
	sta cia1base+0
@Z:	lda cia1base+1
	cmp KbdDBncTab,y
	sta KbdDBncTab,y
	bne @4
	cmp KbdDMltTab,y
	beq @4
	pha
	eor KbdDMltTab,y
	beq @3
	jsr KbdScanHelp1
@3:	pla
	sta KbdDMltTab,y
@4:	dey
	bpl @2
@5:
	rts

KbdScanRow:			; anything pressed?
	LoadB cia1base+0, $ff
	CmpBI cia1base+1, $ff
	rts

KbdScanHelp1:
	sta r0L
	LoadB r1L, 7
@1:	lda r0L
	ldx r1L
	and BitMaskPow2,x
	beq @A	; really dirty trick...
@Y:	tya
	asl
	asl
	asl
	adc r1L
	tax
	bbrf 7, r1H, @2		; bit7=shift, take shifted or unshifed table
	lda KbdDecodeTab2,x
	bra @3
@2:	lda KbdDecodeTab1,x
@3:	sta r0H
	bbrf 5, r1H, @4
	lda r0H
	jsr KbdScanHelp6
	cmp #'A'
	bcc @4
	cmp #'Z'+1
	bcs @4
	subv $40
	sta r0H
@4:	bbrf 6, r1H, @5
	smbf_ 7, r0H
@5:	lda r0H
	sty r0H
	ldy #8
@6:	cmp KbdTab1,y
	beq @7
	dey
	bpl @6
	bmi @8
@7:	lda KbdTab2,y
@8:	ldy r0H
	sta r0H
	and #%01111111
	cmp #%00011111
	beq @9
	ldx r1L
	lda r0L
	and BitMaskPow2,x
	and KbdDMltTab,y
	beq @9
	LoadB KbdQueFlag, 15
	MoveB r0H, KbdNextKey
	jsr KbdScanHelp2
	bra @A
@9:	LoadB KbdQueFlag, $ff
	LoadB KbdNextKey, 0
@A:	dec r1L
	bmi @B
	jmp @1
@B:
	rts
.endif
