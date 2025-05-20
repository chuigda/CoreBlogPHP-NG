#!/usr/bin/env php

<?php

include './lib/bcad.php';

$content = file_get_contents(__DIR__.'/tmp/toc.txt');
$lines = explode(PHP_EOL, $content);
$tree = new TreeNode();

class TreeNode {
    public $title = "";
    public $ident = "";
    public $createTime = null;
    public $children = [];
    public $isTail = false;
}

foreach ($lines as $line) {
    $line = trim($line);
    $line = preg_replace('/^content\//', '', $line);

    if ($line == "") {
        continue;
    }

    $currentNode = $tree;
    $parts = explode('/', trim($line));
    for ($i = 0; $i < count($parts); $i++) {
        $part = trim($parts[$i]);
        $ident = pathinfo(basename($part), PATHINFO_FILENAME);

        if (!isset($currentNode->children[$ident])) {
            $newNode = new TreeNode();
            $newNode->title = $ident;
            $newNode->ident = $ident;
            $currentNode->children[$ident] = $newNode;
            $currentNode = $newNode;
        } else {
            $currentNode = $currentNode->children[$ident];
        }

        if ($i === count($parts) - 1) {
            if (str_ends_with($part, '.ini')) {
                $metadata = parse_ini_file('content/'.$line);
                $currentNode->title = $metadata['title'];
                $currentNode->createTime = $metadata['time'];
            }
            $currentNode->isTail = true;
        }
    }
}

function sortChildren($node) {
    foreach ($node->children as $child) {
        sortChildren($child);
    }

    usort($node->children, function($a, $b) {
        if ($a->createTime && $b->createTime) {
            $createTimeA = bcadtime($a->createTime);
            $createTimeB = bcadtime($b->createTime);

            $timeA = $createTimeA['time'];
            $timeB = $createTimeB['time'];
            $bcA = $createTimeA['bc'];
            $bcB = $createTimeB['bc'];

            if ($bcA && $bcB) {
                return $timeA - $timeB;
            } elseif ($bcA) {
                return 1;
            } elseif ($bcB) {
                return -1;
            } else {
                return $timeB - $timeA;
            }
        } else {
            return strcmp($a->title, $b->title);
        }
    });
}

sortChildren($tree);
echo json_encode($tree, JSON_PRETTY_PRINT);

?>
