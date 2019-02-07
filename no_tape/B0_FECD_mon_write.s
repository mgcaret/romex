; Patch monitor WRITE code
.pc02
.include  "iiee.defs"
rompatch  $fecd,10,"mon_write"
          bra   $ff2d           ; print ERR
          sta   romin           ; at $fecf
          jmp   $f3a0           ; to boot selection hanndler
endpatch

