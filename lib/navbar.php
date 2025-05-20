<?php
function mkcurrent() {
    echo 'class="current"';
}
?>

<nav id="nav-bar" class="top">
    <a <?php if ($argv[2] === 'index') mkcurrent() ?> href="/index.html">Overview</a>
    <a <?php if ($argv[2] === 'research') mkcurrent() ?> href="/research.html">Research</a>
    <a <?php if ($argv[2] === 'literature') mkcurrent() ?> href="/literature.html">Literature</a>
    <a <?php if ($argv[2] === 'resume') mkcurrent() ?> href="/resume.html">Resume</a>
    <a <?php if ($argv[2] === 'friends') mkcurrent() ?> href="/friends.html">Friends</a>
    <a <?php if ($argv[2] === 'about') mkcurrent() ?> href="/about.html">About</a>
</nav>
