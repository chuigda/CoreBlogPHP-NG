#!/usr/bin/env php
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
<?php

include './lib/bcad.php';

$toc_content = file_get_contents(__DIR__.'/tmp/toc.txt');
$lines = explode(PHP_EOL, $toc_content);

foreach ($lines as $line) {
    $line = trim($line);
    if ($line == "") {
        continue;
    }

    $suffix = pathinfo($line, PATHINFO_EXTENSION);
    $filename = pathinfo($line, PATHINFO_FILENAME);
    $directory = pathinfo(preg_replace('/^content\//', '', $line), PATHINFO_DIRNAME);

    $index_page = true;
    $title = ucfirst($filename);
    if ($directory == '.') {
        $url = 'https://chuigda.doki7.club/'.$filename.'.html';
    } else {
        $url = 'https://chuigda.doki7.club/'.$directory.'/'.$filename.'.html';
    }

    $lastmod = date('Y-m-d');
    if ($suffix === 'ini') {
        $ini = parse_ini_file(__DIR__.'/'.$line);

        $index_page = false;
        $title = $ini['title'];
        $bcad = bcadtime($ini['time']);
        if ($bcad['bc'] || $bcad['time'] < strtotime('1980-01-01')) {
            $lastmod = '1980-01-01';
        } else {
            $lastmod = date('Y-m-d', $bcad['time']);
        }
    }

    echo '<url>'.PHP_EOL;
    echo '<loc>'.$url.'</loc>'.PHP_EOL;
    echo '<lastmod>'.$lastmod.'</lastmod>'.PHP_EOL;
    if ($index_page) {
        echo '<changefreq>weekly</changefreq>'.PHP_EOL;
        echo '<priority>1.0</priority>'.PHP_EOL;
    } else {
        echo '<changefreq>monthly</changefreq>'.PHP_EOL;
        echo '<priority>0.8</priority>'.PHP_EOL;
    }
    echo '</url>'.PHP_EOL;
}

?>
</urlset>
