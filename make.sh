set -x
cl65 mario.s -o mario.prg;
cp mario.prg ../x16emu;
../x16emu/x16emu.exe -debug -prg mario.prg -run;
