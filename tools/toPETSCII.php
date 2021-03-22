<?php

$string = readline("");
$string = str_replace("\\n",chr(0x0d),$string);
for ($i = 0; $i < strlen($string); $i++) {
	if (ctype_upper($string[$i])) {
		$string[$i] = chr(ord($string[$i])+32);
	} else if (ctype_alpha($string[$i])){
		$string[$i] = chr(ord($string[$i])-32);
	}
}
file_put_contents("script.out.bin",$string);
echo "strlen() = " . strlen($string);
