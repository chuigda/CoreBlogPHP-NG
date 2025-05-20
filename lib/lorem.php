<?php

$webpage_title = ucfirst($argv[2]).' - Chuigda Homepage';

function initMetadata() {
    global $argv;
    global $webpage_title;
    $file_name = $argv[1];
    $extension = pathinfo($file_name, PATHINFO_EXTENSION);

    if ($extension === 'md' || $extension === 'pdf') {
        $directory = pathinfo($file_name, PATHINFO_DIRNAME);
        $ini_file_name = pathinfo($file_name, PATHINFO_FILENAME) . '.ini';
        $ini = parse_ini_file($directory.'/'.$ini_file_name);
        if ($ini === false) {
            return;
        }
        $webpage_title = $ini['title'].' - Chuigda Homepage';
    }
}

initMetadata()

?>
