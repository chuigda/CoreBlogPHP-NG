<div class="toc-content">
<?php

$tocData = json_decode(file_get_contents(__DIR__.'/../tmp/toc.json'));
$toc_data_assoc = [];
foreach ($tocData->children as $value) {
    $value->title=ucfirst($value->title);
    $toc_data_assoc[$value->ident] = $value;
}
$toc_data_assoc['index']->title = 'Overview';

$current_toc_item = pathinfo(basename($file_name), PATHINFO_FILENAME);

function tocdfs($toc_node, $path) {
    global $file_name_parts;
    global $current_toc_item;

    if ($toc_node->isTail) {
        $current_cls = $current_toc_item == $toc_node->ident ?
            ' class="current"' :
            '';
        $title_text = '<a '.$current_cls.' href="'.$path.'/'.$toc_node->ident.'.html">'.$toc_node->title.'</a>';
    } else {
        $title_text = $toc_node->title;
    }

    if (empty($toc_node->children)) {
        echo '<div>'.$title_text.'</div>';
    } else {
        $should_open = ($current_toc_item == $toc_node->ident) || in_array($toc_node->ident, $file_name_parts);
        $open = $should_open ? ' open' : '';
        echo '<details'.$open.'>';
        echo '<summary>'.$title_text.'</summary>';
        foreach ($toc_node->children as $child) {
            tocdfs($child, $path.'/'.$toc_node->ident);
        }
        echo '</details>';
    }
}

tocdfs($toc_data_assoc['index'], '');
tocdfs($toc_data_assoc['research'], '');
tocdfs($toc_data_assoc['literature'], '');
tocdfs($toc_data_assoc['resume'], '');
tocdfs($toc_data_assoc['friends'], '');
tocdfs($toc_data_assoc['about'], '');

?>
</div>
