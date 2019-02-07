.include  "iiee.defs"
.pc02

rompatch  $c500,256,"romx_main"
          bra resete0x
.include  "../common/romx_main.s"
endpatch
