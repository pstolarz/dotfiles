set radix 16
set disassembly-flavor intel
set print asm-demangle on

tui new-layout my_layout regs 3 src 5 asm 5 cmd 1
winheight cmd 10
layout my_layout
tui disable
