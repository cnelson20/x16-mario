<?php
$red = readline("Red:");
$green = readline("Green:");
$blue = readline("Blue:");
echo "$" . dechex(round(hexdec($blue)/16)) . dechex(round(hexdec($green)/16)) 
. " $0" . dechex(round(hexdec($red)/16)) . "\n";
