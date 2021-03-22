<?php
/*
NOTES:
to view both modes in yychr use 
MSX graphics format for 4bpp x16 
NGP graphics for 2bpp x16
*/
function fix($int1,$int2) {
	$byte1 = "00000000";
	$byte2 = "00000000";
	for ($i = 0; $i<4; $i++) {
		$byte1[2*$i] = (($int1 & (2 ** (7 - $i))) > 0) ? "1" : "0";
		$byte1[2*$i+1] = (($int2 & (2 ** (7 - $i))) > 0) ? "1" : "0";
	}
	for ($i = 0; $i<4; $i++) {
		$byte2[2*$i] = (($int1 & (2 ** (3 - $i))) > 0) ? "1" : "0";
		$byte2[2*$i+1] = (($int2 & (2 ** (3 - $i))) > 0) ? "1" : "0";
	}
	if ($GLOBALS["argc"] > 2 && $GLOBALS["argv"][2] == "-4bpp") {
		for ($i = 0; $i < 16; $i += 4) {
			$byte1 = substr($byte1,0,$i) . "00" . substr($byte1,$i);
			$byte2 = substr($byte2,0,$i) . "00" . substr($byte2,$i);
		}
		return array(
			bindec(substr($byte1,0,8)),
			bindec(substr($byte1,8)),
			bindec(substr($byte2,0,8)),
			bindec(substr($byte2,8))
		);
	}
	return array(bindec($byte1),bindec($byte2));
}
if ($argc < 2) {echo "Usage: php -f nestopacked.php filename";exit(1);}
$byte_arr = unpack("C" . filesize($argv[1]),file_get_contents($argv[1]));
$plane0 = array();
$plane1 = array();
foreach ($byte_arr as $index => $byte) {
	if (($index-1) % 16 < 8) {
		$plane0[floor(($index-1)/16)][] = $byte;
	} else {
		$plane1[floor(($index-1)/16)][] = $byte;
	}
}
$final = array();
for ($i = 0; $i < count($plane0); $i++) {
	for ($j = 0; $j < 8; $j++) {
		$temp = fix($plane0[$i][$j],$plane1[$i][$j]);
		
		foreach ($temp as $byte) {$final[] = $byte;}
	}
}
$output = "";
foreach ($final as $byte) {
	$output .= chr($byte);
}
file_put_contents($argv[1] . ".fixed",$output);
?>
