; patch PWRUP to go to romx boot code
.code
.include "iiee.defs"
rompatch $fab6,4,"patch_pwrup"
	jmp   $d8fb
	nop
endpatch
