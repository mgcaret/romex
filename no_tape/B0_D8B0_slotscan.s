.pc02
.include  "iiee.defs"
rompatch  $d8b0,98,"slotscan"   ; patches over Applesoft SAVE, LOAD,and VARTIO
.include "../common/slotscan.s"
endpatch
