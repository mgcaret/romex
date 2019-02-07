.include  "iiee.defs"

rompatch  $c600,512,"romx_main"
.pc02
; if we get here, we know that the closed apple/option key was held down
; and CX ROM is already active
          bra   resete0x        ; $C600
          bra   tapestuff       ; $C602
          bra   pickboot        ; $C604
          bra   pressoa         ; $C606
; Replacement tape routines
.proc     tapestuff
          bcc   progio
          ; fall-through
.endproc
.proc     vartio
          lda   #$50          ; LINNUM
          ldy   #$00
          sta   $3C           ; A1L
          sty   $3D           ; A1H
          lda   #$52          ; TMPPT (lock byte)
          sty   $D6           ; LOCK
seta2:    sta   $3E           ; A2L
          sty   $3F           ; A2H
          jmp   slotcxrts
.endproc
.proc     progio
          lda   $67           ; TXTTAB
          ldy   $68
          sta   $3C           ; A1L
          sta   $3D           ; A1H
          lda   $69           ; VARTAB
          ldy   $6A
          bra   vartio::seta2
.endproc
.include  "../common/pickboot.s"
.include  "../common/romx_main.s"
.include  "../common/slotscan.s"
endpatch
