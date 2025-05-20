<?php

function bcadtime($time) {
    if (strpos($time, '-') === 0) {
        $time = strtotime(substr($time, 1));
        $bc = true;
    } else {
        $time = strtotime($time);
        $bc = false;
    }

    return [
        'time' => $time,
        'bc' => $bc
    ];
}

?>