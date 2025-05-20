#!/usr/bin/env php

<?php include './lib/lorem.php' ?>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title><?php echo $webpage_title; ?></title>
        <meta name="description" content="<?php echo $webpage_title ?>" />
        <meta name="google-site-verification" content="zweSq9tV-4NYWcoheVVgcIR6Z9HQx5z9B5pHxfZKRM8" />
        <?php include './lib/color-scheme.php' ?>
        <?php include './lib/stylesheets/common.php' ?>
        <?php include './lib/stylesheets/iexplorer.php' ?>
    </head>
    <body>
        <?php include './lib/navbar.php' ?>
        <div class="main-layout">
            <div class="tree-view" aria-label="sidebar navigator">
                <?php include './lib/toc.php' ?>
            </div>
            <article>
                <?php include './page-content.php' ?>
            </article>
        </div>
        <?php include './lib/footbar.php' ?>
    </body>
</html>
