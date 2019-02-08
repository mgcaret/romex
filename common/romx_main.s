.pc02

.if no_tape
checkblk    = $d8b1
checkatalk  = $d8b3
getslotbyte = $d8b5
checkatalk2 = $d8b7 ; not used here
atwait      = $d8b9
.else
; above must be defined by including file
.endif

.proc     pressoa
          ldx   #msg7-msg0      ; Press open apple
          jmp   Disp
.endproc
.proc     resete0x
.if ::no_tape
          ; if we are over tape code, we still have diags so allow access
          bit   butn0           ; open apple also pressed?
          bpl   :+              ; nope, just ca/option
          jmp   $c600           ; do diags
.endif
:         jsr   title
          ldx   #msg0-msg0      ; basic parts of menu
          jsr   Disp
          ; display slots now
          stz   $00             ; zero low byte of slot ptr
          ldx   #$07
:         phx
          jsr   dslot
          dec   cv
          jsr   vtab            ; wrecks y
          lda   #menucol
          sta   ch
          plx
          dex
          bne   :-
          jsr   rdkey
          cmp   #$b0            ; is 0 or less?
          bcc   :--             ; less than, re-draw
          bne   :+              ; not zero, skip
          jmp   monitor         ; do not pass go, do not collect $200
:         cmp   #$b8            ; 8 or higher
          bcs   :---            ; yep, re-draw
          sta   $02             ; put in $02
          eor   #pwrbyte        ; make check byte
          sta   $03             ; put in $03
          lda   #$80            ; flag to open-apple+reset
          jmp   $c2c6           ; back to resetx
.endproc
; entered with slot # in x, and scanslots having been called
.proc     dslot
          txa
          jsr   prhex
          lda   #$a0            ; space
          jsr   cout
          txa
          ora   #$c0            ; to ref
          sta   $01             ; high nibble of ptr
          jsr   checkatalk
          bcc   :+              ; skip if not
          ldx   #msg2-msg0
          jsr   Disp            ; print it
:         jsr   checkblk        ; is block device
          bcs   block
          ldy   #$0b            ; check for Pascal 1.1 FW protocol
          jsr   getslotbyte     ; get byte (cxrom is on!)
          dec   a
          beq   pascal
exit:     rts
pascal:   ldx   #msg5-msg0
          jsr   Disp
          ldy   #$0c            ; Pascal card ID
          jsr   getslotbyte
          jmp   prbyte
block:    beq   smart
          ldy   #$ff            ; last byte of firmware
          jsr   getslotbyte
          beq   disk            ; $00 = 16-sector
          inc   a               ; is $FF?
          beq   disk            ; yes 13-sector
          ldx   #msg3-msg0      ; generic block device
          .byte $2c             ; BIT Absolute opcode
disk:     ldx   #msg4-msg0
          .byte $2c
smart:    ldx   #msg6-msg0
          ; fall-through
.endproc
.proc     Disp
          lda   msg0,x
          bne   :+
          rts
:         inx                   ; set up for next message byte
          cmp   #$18            ; last line + 1
          bcc   repos
          eor   #$80
          jsr   cout            ; not supposed to change any regs
          bra   Disp
repos:    jsr   tabv            ; destroys a and y, but not x
          lda   msg0,x          ; get horizontal
          sta   ch              ; and write
          inx                   ; next message byte
          bra   Disp
.endproc
.if no_tape
msg0:     .byte 3,menucol,"0 Mon"
.else
msg0:     .byte 3,menucol,"0 Monitor"
.endif
          .byte 5,menucol,"Slots:"
          .byte 22,16,"By M.G."
msg1:     .byte 23,13,"ROM eX 02-19B",13,menucol,$00
.if no_tape
msg2:     .byte "AT ",$00
.else
msg2:     .byte "AppleTalk ",$00
.endif
msg3:     .byte "Block",$00
msg4:     .byte "Disk II",$00
.if no_tape
msg5:     .byte "Pas $",$00
.else
msg5:     .byte "Pascal $",$00
.endif
.if no_tape
msg6:     .byte "Smart",$00
.else
msg6:     .byte "SmartPort",$00
.endif
msg7:     .byte 3,15,"Press ",$C1,"+",$CD,$00
