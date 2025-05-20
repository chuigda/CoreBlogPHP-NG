<?php

include __DIR__.'/bcad.php';

function metafolder($dir) {
    $dir_name = basename($dir);
    $meta_files = glob($dir.'/*.ini');
    $metadata_array = [];
    foreach ($meta_files as $meta_file) {
        $metadata = parse_ini_file($meta_file);
        $bcad = bcadtime($metadata['time']);
        $metadata['publish_time'] = $bcad['time'];
        $metadata['bc'] = $bcad['bc'];
        $metadata['ident'] = pathinfo(basename($meta_file), PATHINFO_FILENAME);

        $metadata_array[] = $metadata;
    }

    usort($metadata_array, function ($a, $b) {
        if ($a['bc'] && $b['bc']) {
            return $a['publish_time'] - $b['publish_time'];
        } elseif ($a['bc']) {
            return 1;
        } elseif ($b['bc']) {
            return -1;
        } else {
            return $b['publish_time'] - $a['publish_time'];
        }
    });

    echo '<div class="passage-list">';
    foreach ($metadata_array as $metadata) {
        $ident = $metadata['ident'];

        $publish_date = date('F j, Y', $metadata['publish_time']);
        $published_by = 'Published by';
        $bc = $metadata['bc'] ? ' BC' : '';

        if (strstr(strtolower($metadata['author']), 'chuigda') === false) {
            $publish_date = date('Y', $metadata['publish_time']);
            $published_by = 'Originally created by';
        }

        echo '<div class="passage">';
        echo '<h3 class="title"><a href="'.$dir_name.'/'.$ident.'.html">'.$metadata['title'].'</a></h3>';
        echo '<p>'.$metadata['brief'].'</p>';
        echo '<small>'.$published_by.' <span>'.$metadata['author'].'</span> at <span>'.$publish_date.$bc.'</span></small>';
        echo '</div>';
    }
    echo '<div class="placeholder">&nbsp;</div>';
    echo '</div>';
}

?>
