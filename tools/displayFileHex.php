<?php
$i = 0;
foreach (str_split(file_get_contents($argv[1])) as $byte) {
echo "$" . (strlen(dechex(ord($byte))) < 2 ? "0" : "") . dechex(ord($byte)) . " ";
$i++;
if ($i % 20 == 0) {echo "\n";}
}
