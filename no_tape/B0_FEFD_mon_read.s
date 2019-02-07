; Patch monitor READ code
.pc02
.include  "iiee.defs"
rompatch  $fefd,13,"mon_read"
          bra   $ff2d           ; print ERR
          ; delete key patch
          jsr   $fd35           ; RDCHAR
          cmp #$ff
	        bne :+
          lda #$88
:         rts
endpatch
