.pc02
.if ::no_tape
checkatalk  = $d8b7             ; actually checkatalk2...
atwait      = $d8b9
          rts                   ; so STORE returns
.else
; pressoa defined elsewhere
.endif
; we get here from patch at $fab6 (no tape) or $d8f0 (no diags)
.proc     pickboot
          stx   $00             ; is a zero
          sta   $01             ; is $c8
          lda   $02             ; 
          eor   $03
          cmp   #pwrbyte
          bne   goboot
dosel:    lda   $02
          cmp   #$b1
          bcc   goboot          ; check value right, but illegal value
          cmp   #$b8
          bcs   goboot
          eor   #$70            ; $b0 -> $c0
          inc   a
          sta   $01
.if ::no_tape
          ; if we are assembling over STORE/RECALL
          bit   $60             ; assembles an RTS at RECALL
.assert *-1=$f3bc,error,.sprintf("RECALL aligment problem, *=%x",*-1)
.endif
          sta   $02             ; so that next try has default behavior
          jsr   checkatalk      ; note ::no_tape version calls checkatalk2 here
          bcc   goboot          ; nope, just boot the slot
          sta   setaltchar      ; turn on mousetext
          jsr   atwait          ; Wait for open apple
goboot:
.if !::no_tape
          ; set up RTS trick
          lda   #>(sloop-1)
          pha
          lda   #<(sloop-1)
          pha
.endif
          ldx   $00
          lda   $01
.if ::no_tape
          jmp   sloop
.else
          jmp   slotcxrts       ; return to slot ROM and execute RTS trick
.endif
.endproc
