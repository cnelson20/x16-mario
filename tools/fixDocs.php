<?php
if ($argc < 2) {exit(1);}
$text = substr(file_get_contents($argv[1]),2);
for ($i = 80; $i < strlen($text); $i +=  81) {
	$text = substr($text,0,$i+1) . "\n" . substr($text,$i+1);
}
file_put_contents($argv[1] . ".fixed", $text);
