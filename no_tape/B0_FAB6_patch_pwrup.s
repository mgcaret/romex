; patch PWRUP to go to romx boot code
.code
.include "iiee.defs"
	.org  $fab6
	jmp   $f3a0
	nop

