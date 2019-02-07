; If building the version that removes the tape code,
; this lands outside of $Cxxx space, so we can directly query the slots
; If we are removing the diags, then this lands in $Cxxx space and must
; call the getslotbyte routine that lives outside of $Cxxx space.
; to facilitate this, a couple of AppleSoft tape I/O routines are relocated
; to $Cxxx space.
.pc02
.if ::no_tape
          rts                   ; so SAVE returns
          bra   checkblk        ; $d8b1
          bra   checkatalk      ; $d8b3
          bra   getslotbyte     ; $d8b5
          bra   checkatalk2     ; $d8b7, without cxrom stuff
          ; fall-through $d8b9 to atwait
.endif

; WS card requires open apple to be held to boot appletalk after the
; firmware diagnostics have passed.  Display wait msg and 
.proc     atwait
          jsr   title
.if ::no_tape
          jsr   $c502           ; display message
.else
          jsr   $c606           ; display messsage
.endif
:         bit   butn0
          bpl   :-
          rts
.endproc

.if ::no_tape
; enter assuming cxrom is on ($00) points to card slot ROM
; y contains byte index into card firmware
.proc     getslotbyte
          sta   setslotcxrom
          lda   ($00),y
          bra   cxexit
.endproc
.else
getslotbyte = $d8f3
.endif
      
; enter assuming cxrom is on, ($00) points to card slot ROM
; and y is usable
; exits with carry set if block device in slot, and z flag set if smartport
; carry clear otherwise
.proc     checkblk
.if ::no_tape
          sta   setslotcxrom
.endif
          ldy   #$05
:
.if ::no_tape
          lda   ($00),y
.else
          jsr   getslotbyte
.endif
          cmp   $fb01,y         ; Disk ID bytes
          beq   :+
          clc
          bcc   cxexit
:         dey                   ; note carry is set
          dey
          bpl   :--             ; until done or all bytes match
          ldy   #$07            ; carry still set here
.if ::no_tape          
          lda   ($00),y         ; get smartport
.else
          jsr   getslotbyte
.endif
cxexit:   
.if ::no_tape
          jmp   $f8cb           ; has sta setintcxrom then rts
.else
          rts
.endif
.endproc
cxexit = checkblk::cxexit

; enter assuming that cxrom is on, ($00) points to card slot ROM
; and y is usable
.proc     checkatalk
.if ::no_tape
          sta   setslotcxrom
          jsr   checkatalk2
          bra   cxexit
.endproc

; enter assuming ($00) points to card slot ROM
; and y is usable
.proc     checkatalk2
.endif
          ldy   #$F9            ; check $CnF9-$CnFC
at_chk:   
.if ::no_tape
          lda   ($00),y
.else
          jsr   getslotbyte
.endif
          cmp   atid-$F9,y
          clc                   ; anticipate failure
          bne   done
          iny
          cpy   #$FD
          bcc   at_chk
done:     rts
atid:     .byte "ATLK"
.endproc

