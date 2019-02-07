; patch GETLN1 to call delete key handler
.code
.include "iiee.defs"
	.org  $fd75
	jsr   $feff

