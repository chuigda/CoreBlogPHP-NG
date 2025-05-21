<?php

$file_name = $argv[1];
$extension = pathinfo($file_name, PATHINFO_EXTENSION);
$webpage_title = 'Chuigda Homepage';

$file_name_parts = array_slice(explode('/', $file_name), 1);

function initMetadata() {
    global $file_name;
    global $webpage_title;
    global $file_name_parts;

    $extension = pathinfo($file_name, PATHINFO_EXTENSION);
    if ($extension === 'md' || $extension === 'pdf') {
        $directory = pathinfo($file_name, PATHINFO_DIRNAME);
        $ini_file_name = pathinfo($file_name, PATHINFO_FILENAME) . '.ini';
        $ini = parse_ini_file($directory.'/'.$ini_file_name);
        if ($ini === false) {
            return;
        }
        $webpage_title = $ini['title'].' - Chuigda Homepage';
    } else {
        // use the last part of $file_name_parts, do not modify the array
        $last_part = $file_name_parts[count($file_name_parts) - 1];
        $name_without_extension = pathinfo($last_part, PATHINFO_FILENAME);

        $webpage_title = ucfirst($name_without_extension).' - Chuigda Homepage';
    }
}

initMetadata()

?>
