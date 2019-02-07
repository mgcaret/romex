
.pc02
.include  "iiee.defs"
rompatch  $d8f0,34,"patch_vartio"   ; patches over Applesoft VARTIO
.proc     vartio
          sec
          bra   gocx
.endproc
; enter assuming cxrom is on ($00) points to card slot ROM
; y contains byte index into card firmware
.proc     getslotbyte
          sta   setslotcxrom
          lda   ($00),y
          jmp   intcxrts
.endproc
.proc     gopickboot
          sta   setintcxrom
          jmp   $c604
.endproc
.assert *=$d901,error,.sprintf("PROGIO aligment problem, *=%x",*)
.proc     progio
          clc
          ; fall-through
.endproc
.proc     gocx
          sta   setintcxrom
          jmp   $c602               ; go to vartio/progio replacement
.endproc
.proc     fixdelkey
          jsr   rdchar
          cmp   #$ff
          bne   :+
          lda   #$88
:         rts
.endproc
endpatch