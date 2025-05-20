<div class="toc-content">
<?php

$tocData = json_decode(file_get_contents(__DIR__.'/../tmp/toc.json'));
$tocDataAssoc = [];
foreach ($tocData->children as $value) {
    $value->title=ucfirst($value->title);
    $tocDataAssoc[$value->ident] = $value;
}
$tocDataAssoc['index']->title = 'Overview';

$tocDataSorted = [];
$tocDataSorted[] = $tocDataAssoc['index'];
$tocDataSorted[] = $tocDataAssoc['research'];
$tocDataSorted[] = $tocDataAssoc['literature'];
$tocDataSorted[] = $tocDataAssoc['resume'];
$tocDataSorted[] = $tocDataAssoc['friends'];
$tocDataSorted[] = $tocDataAssoc['about'];

$tocData->children = $tocDataSorted;

$current = pathinfo(basename($argv[1]), PATHINFO_FILENAME);

function tocdfs($tocNode, $path) {
    echo '<ul>';
    foreach ($tocNode->children as $idx => $child) {
        if ($child->isTail) {
            global $current;
            $currentCls = $current == $child->ident ?
                ' class="current"' :
                '';

            echo '<li><a '.$currentCls.'href="'.$path.'/'.$child->ident.'.html">'.$child->title.'</a>';
        } else {
            echo '<li>'.$child->title;
        }

        $hasChildren = !empty($child->children);
        if ($hasChildren) {
            tocdfs($child, $path.'/'.$child->ident);
        }

        echo '</li>';
    }
    echo '</ul>';
}

tocdfs($tocData, '');

?>
</div>