; patch GETLN1 to call delete key handler
.code
.include "iiee.defs"
rompatch $fd75,3,"patch_getln1"
	jsr   $d908
endpatch
