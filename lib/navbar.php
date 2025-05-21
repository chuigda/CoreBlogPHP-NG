<?php
function mkcurrent() {
    echo 'class="current"';
}

$current_navbar = pathinfo($file_name_parts[0], PATHINFO_FILENAME);
?>

<nav id="nav-bar" class="top">
    <a <?php if ($current_navbar === 'index') mkcurrent() ?> href="/index.html">Overview</a>
    <a <?php if ($current_navbar === 'research') mkcurrent() ?> href="/research.html">Research</a>
    <a <?php if ($current_navbar === 'literature') mkcurrent() ?> href="/literature.html">Literature</a>
    <a <?php if ($current_navbar === 'resume') mkcurrent() ?> href="/resume.html">Resume</a>
    <a <?php if ($current_navbar === 'friends') mkcurrent() ?> href="/friends.html">Friends</a>
    <a <?php if ($current_navbar === 'about') mkcurrent() ?> href="/about.html">About</a>
</nav>
