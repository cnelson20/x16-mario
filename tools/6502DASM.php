<?php
function gdechex($num) {
  return (strlen(dechex($num)) < 2 ? "0" : "") . dechex($num);
}
function dechex4($num) {
  $str = dechex($num);
  while (strlen($str) < 4) {$str = "0" . $str;}
  return $str;
}

if ($argc < 2) {
  echo "Usage: php -f DASM.php filename\n";
  exit(0);
}
$file_contents = file_get_contents($argv[1]);
$pc = ord($file_contents[1]) * 256 + ord($file_contents[0]);
if (explode(".",$argv[1])[1] == "prg") {
  $file_contents = substr($file_contents,14);
} else if (explode(".",$argv[1])[1] == "nes") {
  $file_contents = substr($file_contents,16,ord($file_contents[4])*16384);
}
//echo $file_contents;
$output = array();
while (strlen($file_contents) > 0) {
  //$file_contents = substr($file_contents,$pc);
  switch (ord($file_contents[0])) {
    //ADC
    case 0x69:
      $output[$pc] = "adc #$" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x65:
      $output[$pc] = "adc $" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x75:
      $output[$pc] = "adc $" . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x6D:
      $output[$pc] = "adc $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0x7D:
      $output[$pc] = "adc $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0x79:
      $output[$pc] = "adc $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",Y";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0x61:
      $output[$pc] = "adc ($" . gdechex(ord($file_contents[1])) . ",X)";
      $file_contents = substr($file_contents,2);
      $pc += 3;
      break;
    case 0x71:
      $output[$pc] = "adc ($" . gdechex(ord($file_contents[1])) . "),Y";
      $file_contents = substr($file_contents,2);
      $pc += 3;
      break;
    //AND
    case 0x29:
      $output[$pc] = "and #$" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x25:
      $output[$pc] = "and $" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x35:
      $output[$pc] = "and $" . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x2D:
      $output[$pc] = "and $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0x3D:
      $output[$pc] = "and $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0x39:
      $output[$pc] = "and $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",Y";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0x21:
      $output[$pc] = "and ($" . gdechex(ord($file_contents[1])) . ",X)";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x31:
      $output[$pc] = "and ($" . gdechex(ord($file_contents[1])) . "),Y";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    //ASL
    case 0x0A:
      $output[$pc] = "asl A";
      $file_contents = substr($file_contents,1);
      $pc++;
      break;
    case 0x06:
      $output[$pc] = "asl $" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x16:
      $output[$pc] = "asl $" . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x0E:
      $output[$pc] = "asl $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0x1E:
      $output[$pc] = "asl $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    //BIT
    case 0x24:
      $output[$pc] = "bit $" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x2C:
      $output[$pc] = "bit $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    //BRANCH INSTRUCTIONS
    case 0x10:
      $output[$pc] = "bpl $" . dechex4($pc + 2 + (ord($file_contents[1]) > 128 ? (-1 * (256 - ord($file_contents[1]))) : ord($file_contents[1])));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x30:
      $output[$pc] = "bmi $" . dechex4($pc + 2 + (ord($file_contents[1]) > 128 ? (-1 * (256 - ord($file_contents[1]))) : ord($file_contents[1])));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x50:
      $output[$pc] = "bvc $" . dechex4($pc + 2 + (ord($file_contents[1]) > 128 ? (-1 * (256 - ord($file_contents[1]))) : ord($file_contents[1])));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x70:
      $output[$pc] = "bvs $" . dechex4($pc + 2 + (ord($file_contents[1]) > 128 ? (-1 * (256 - ord($file_contents[1]))) : ord($file_contents[1])));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x90:
      $output[$pc] = "bcc $" . dechex4($pc + 2 + (ord($file_contents[1]) > 128 ? (-1 * (256 - ord($file_contents[1]))) : ord($file_contents[1])));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xB0:
      $output[$pc] = "bcs $" . dechex4($pc + 2 + (ord($file_contents[1]) > 128 ? (-1 * (256 - ord($file_contents[1]))) : ord($file_contents[1])));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xD0:
      $output[$pc] = "bne $" . dechex4($pc + 2 + (ord($file_contents[1]) > 128 ? (-1 * (256 - ord($file_contents[1]))) : ord($file_contents[1])));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xF0:
      $output[$pc] = "beq $" . dechex4($pc + 2 + (ord($file_contents[1]) > 128 ? (-1 * (256 - ord($file_contents[1]))) : ord($file_contents[1])));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    //BRK
    case 0x00:
      $output[$pc] = "brk";
      $file_contents = substr($file_contents,1);
      $pc++;
      break;
    //CMP
    case 0xC9:
      $output[$pc] = "cmp #$" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xC5:
      $output[$pc] = "cmp $" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xD5:
      $output[$pc] = "cmp $" . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xCD:
      $output[$pc] = "cmp $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0xDD:
      $output[$pc] = "cmp $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0xD9:
      $output[$pc] = "cmp $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",Y";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0xC1:
      $output[$pc] = "cmp ($" . gdechex(ord($file_contents[1])) . ",X)";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xD1:
      $output[$pc] = "cmp ($" . gdechex(ord($file_contents[1])) . "),Y";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    //CPX
    case 0xE0:
      $output[$pc] = "cpx #$" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xE4:
      $output[$pc] = "cpx $" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xEC:
      $output[$pc] = "cpx $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    //CPY
    case 0xC0:
      $output[$pc] = "cpy #$" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xC4:
      $output[$pc] = "cpy $" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xCC:
      $output[$pc] = "cpy $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    //DEC
    case 0xC6:
      $output[$pc] = "dec $" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xD6:
      $output[$pc] = "dec $" . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xCE:
      $output[$pc] = "Dec $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0xDE:
      $output[$pc] = "dec $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    //EOR
    case 0x49:
      $output[$pc] = "eor #$" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x45:
      $output[$pc] = "eor $" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x55:
      $output[$pc] = "eor $" . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x4D:
      $output[$pc] = "eor $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0x5D:
      $output[$pc] = "eor $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0x59:
      $output[$pc] = "eor $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",Y";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0x41:
      $output[$pc] = "eor ($" . gdechex(ord($file_contents[1])) . ",X)";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x51:
      $output[$pc] = "eor ($" . gdechex(ord($file_contents[1])) . "),Y";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    //FLAG INSTRUCTIONS
    case 0x18:
      $output[$pc] = "clc";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x38:
      $output[$pc] = "sec";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x58:
      $output[$pc] = "cli";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x78:
      $output[$pc] = "sei";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xB8:
      $output[$pc] = "clv";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xD8:
      $output[$pc] = "cld";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xF8:
      $output[$pc] = "sed";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    //INC
    case 0xE6:
      $output[$pc] = "inc $" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xF6:
      $output[$pc] = "inc $" . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xEE:
      $output[$pc] = "inc $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0xFE:
      $output[$pc] = "inc $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    //JMP
    case 0x4C:
      $output[$pc] = "jmp $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0x6C:
      $output[$pc] = "jmp ($" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ")";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    //JSR
    case 0x20:
      $output[$pc] = "jsr $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    //LDA
    case 0xA9:
      $output[$pc] = "lda #$" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xA5:
      $output[$pc] = "lda $" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xB5:
      $output[$pc] = "lda $" . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xAD:
      $output[$pc] = "lda $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0xBD:
      $output[$pc] = "lda $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0xB9:
      $output[$pc] = "lda $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",Y";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0xA1:
      $output[$pc] = "lda ($" . gdechex(ord($file_contents[1])) . ",X)";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xA1:
      $output[$pc] = "lda ($" . gdechex(ord($file_contents[1])) . "),Y";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    //LDX
    case 0xA2:
      $output[$pc] = "ldx #$" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xA6:
      $output[$pc] = "ldx $" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xB6:
      $output[$pc] = "ldx $" . gdechex(ord($file_contents[1])) . ",Y";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xAE:
      $output[$pc] = "ldx $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0xBE:
      $output[$pc] = "ldx $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",Y";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    //LDY
    case 0xA0:
      $output[$pc] = "ldy #$" . gdechex(ord($file_contents[1]));;
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xA4:
      $output[$pc] = "ldy $" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xB4:
      $output[$pc] = "ldy $" . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xAC:
      $output[$pc] = "ldy $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0xBC:
      $output[$pc] = "ldy $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    //LSR
    case 0x4A:
      $output[$pc] = "lsr A";
      $file_contents = substr($file_contents,1);
      $pc++;
      break;
    case 0x46:
      $output[$pc] = "lsr $" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x56:
      $output[$pc] = "lsr $" . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x4E:
      $output[$pc] = "lsr $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0x5E:
      $output[$pc] = "lsr $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;

    //ORA
    case 0x09:
      $output[$pc] = "lda #$" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x05:
      $output[$pc] = "lda $" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x15:
      $output[$pc] = "ora $" . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x0D:
      $output[$pc] = "ora $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0x1D:
      $output[$pc] = "ora $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0x19:
      $output[$pc] = "ora $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",Y";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0x01:
      $output[$pc] = "ora ($" . gdechex(ord($file_contents[1])) . ",X)";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x11:
      $output[$pc] = "ora ($" . gdechex(ord($file_contents[1])) . "),Y";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    //No Operation
    case 0xEA:
      $output[$pc] = "nop";
      $file_contents = substr($file_contents,1);
      $pc++;
    //REGISTER INSTRUCTIONS
    case 0xAA:
      $output[$pc] = "tax";
      $file_contents = substr($file_contents,1);
      $pc++;
      break;
    case 0x8A:
      $output[$pc] = "txa";
      $file_contents = substr($file_contents,1);
      $pc++;
      break;
    case 0xCA:
      $output[$pc] = "dex";
      $file_contents = substr($file_contents,1);
      break;
    case 0xE8:
      $output[$pc] = "inx";
      $file_contents = substr($file_contents,1);
      $pc++;
      break;
    case 0xA8:
      $output[$pc] = "tay";
      $file_contents = substr($file_contents,1);
      $pc++;
      break;
    case 0x98:
      $output[$pc] = "tya";
      $file_contents = substr($file_contents,1);
      $pc++;
      break;
    case 0x88:
      $output[$pc] = "dey";
      $file_contents = substr($file_contents,1);
      $pc++;
      break;
    case 0xC8:
      $output[$pc] = "iny";
      $file_contents = substr($file_contents,1);
      $pc++;
      break;

    //ROL
    case 0x2A:
      $output[$pc] = "rol A";
      $file_contents = substr($file_contents,1);
      $pc++;
      break;
    case 0x26:
      $output[$pc] = "rol $" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x36:
      $output[$pc] = "rol $" . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x2E:
      $output[$pc] = "rol $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0x3E:
      $output[$pc] = "rol $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    //ROR
    case 0x6A:
      $output[$pc] = "ror A";
      $file_contents = substr($file_contents,1);
      $pc++;
      break;
    case 0x66:
      $output[$pc] = "ror $" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x76:
      $output[$pc] = "ror $" . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,2);
      break;
    case 0x6E:
      $output[$pc] = "ror $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0x7E:
      $output[$pc] = "ror $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;

    //RTI
    case 0x40:
      $output[$pc] = "rti";
      $file_contents = substr($file_contents,1);
      $pc++;
      break;
    //RTS
    case 0x60:
      $output[$pc] = "rts";
      $file_contents = substr($file_contents,1);
      $pc++;
      break;

    //SBC
    case 0xE9:
      $output[$pc] = "sbc #$" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xE5:
      $output[$pc] = "sbc $" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xF5:
      $output[$pc] = "sbc $" . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xED:
      $output[$pc] = "sbc $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0xFD:
      $output[$pc] = "sbc $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0xF9:
      $output[$pc] = "sbc $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",Y";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0xE1:
      $output[$pc] = "sbc ($" . gdechex(ord($file_contents[1])) . ",X)";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0xF1:
      $output[$pc] = "sbc ($" . gdechex(ord($file_contents[1])) . "),Y";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;

    //STA
    case 0x85:
      $output[$pc] = "sta $" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x95:
      $output[$pc] = "sta $" . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x8D:
      $output[$pc] = "sta $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0x9D:
      $output[$pc] = "sta $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0x99:
      $output[$pc] = "sta $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1])) . ",Y";
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    case 0x81:
      $output[$pc] = "sta ($" . gdechex(ord($file_contents[1])) . ",X)";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x91:
      $output[$pc] = "sta ($" . gdechex(ord($file_contents[1])) . "),Y";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    //STX
    case 0x86:
      $output[$pc] = "stx $" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x96:
      $output[$pc] = "stx $" . gdechex(ord($file_contents[1])) . ",Y";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x8E:
      $output[$pc] = "stx $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;
    //STY
    case 0x84:
      $output[$pc] = "sty $" . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x94:
      $output[$pc] = "sty $" . gdechex(ord($file_contents[1])) . ",X";
      $file_contents = substr($file_contents,2);
      $pc += 2;
      break;
    case 0x8C:
      $output[$pc] = "sty $" . gdechex(ord($file_contents[2])) . gdechex(ord($file_contents[1]));
      $file_contents = substr($file_contents,3);
      $pc += 3;
      break;

    //STACK INSTRUCTIONS
    case 0x9A:
      $output[$pc] = "txs";
      $file_contents = substr($file_contents,1);
      $pc++;
      break;
    case 0xBA:
      $output[$pc] = "tsx";
      $file_contents = substr($file_contents,1);
      $pc++;
      break;
    case 0x48:
      $output[$pc] = "pha";
      $file_contents = substr($file_contents,1);
      $pc++;
      break;
    case 0x68:
      $output[$pc] = "pla";
      $file_contents = substr($file_contents,1);
      $pc++;
      break;
    case 0x08:
      $output[$pc] = "php";
      $file_contents = substr($file_contents,1);
      $pc++;
      break;
    case 0x28:
      $output[$pc] = "plp";
      $file_contents = substr($file_contents,1);
      $pc++;
      break;

    default:
      $output[$pc] = "_byte $" . gdechex(ord($file_contents[0]));
      $file_contents = substr($file_contents,1);
      $pc++;
      break;
    }
}
$file_data = "\n";
$branchAdresses = array();
$notBranchAddress = array();
$branch_commands = array("bpl","bmi","bvc","bvs","bcc","bcs","bne","beq");
$i = 0;
foreach ($output as $address => $command) {
  if (in_array(substr($command,0,3),$branch_commands)) {
    $branchAdresses["@" . $i . ":"] = "$" . substr($command,5);
    $i++;
  }
  $notBranchAddress["\n$" . dechex4($address)] = "\n  ";
  $file_data .= "$" . dechex4($address) . "  " . $command . "\n";
}
foreach (explode("\n",str_replace("  ","",$file_data)) as $command) {
  //echo $command . "\n";
  if ((substr($command,5,3) == "jmp" || substr($command,5,3) == "jsr") && str_contains($file_data,"\n" . substr($command,9))) {
    $branchAdresses["@" . $i . ":"] = substr($command,9);
    $i++;
  }
}
//var_dump($branchAdresses);
$file_data = str_replace(array_values($branchAdresses),array_keys($branchAdresses),$file_data);
$file_data = str_replace(array_keys($notBranchAddress),array_values($notBranchAddress),$file_data);
$o_file = explode(".",$argv[1])[0] . ".dasm";
if ($argc > 2) {$o_file = $argv[2];}
file_put_contents($o_file,substr($file_data,1));
echo filesize($o_file). " bytes written to \"$o_file\". \n";
