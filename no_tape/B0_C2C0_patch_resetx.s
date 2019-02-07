.pc02
.include  "iiee.defs"
; correlate these with the text patch
rompatch  $c2c0,3,"resetx"
          jmp   $c500           ; intercept diags hook
endpatch
