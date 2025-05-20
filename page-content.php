<?php

require './parsedown-1.7.4/Parsedown.php';

$file_name = $argv[1];
$extension = pathinfo($file_name, PATHINFO_EXTENSION);

if ($extension === 'php') {
    include $file_name;
} elseif ($extension === 'html') {
    echo file_get_contents($file_name);
} elseif ($extension === 'md') {
    $content = file_get_contents($file_name);
    $parsedown = new Parsedown();

    $literature_class = $argv[2] === 'literature' ? ' literature' : '';
    echo '<div class="article-content'.$literature_class.'">';
    echo $parsedown->text($content);
    echo '<p class="placeholder">&nbsp;</p>';
    echo '</div>';

    include './lib/stylesheets/passage.php';
} elseif ($extension === 'pdf') {
    $basename = basename($file_name);
    echo '<iframe src="'.$basename.'" width="100%" height="100%"></iframe>';
    echo '<style>article { padding: 0; overflow: hidden; } iframe { border: none; }</style>';
} else {
    throw new Exception('Unsupported file type $extension');
}

?>
