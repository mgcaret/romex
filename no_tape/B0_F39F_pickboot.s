.pc02
.include  "iiee.defs"
; correlate these with the text patch
rompatch  $f39f,57,"pickboot"   ; patches over AppleSoft STORE and RECALL
.include "../common/pickboot.s"
endpatch