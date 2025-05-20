<h1>My friends</h1>

<div class="friends">
<?php

$friends = json_decode(file_get_contents(__DIR__.'/friends.json'));

foreach ($friends as $friend) {
    $name = $friend->name;
    $avatar = $friend->avatar;
    $link = $friend->link;
    $description = $friend->description;

    echo '<div class="link-item">';
    echo '<img class="avatar" src='.$avatar.' alt='.$name.' />';
    echo '<div class="link-content">';
    echo '<a href='.$link.'><b>'.$name.'</b></a>';

    if ($description) {
        echo $description;
    } else {
        echo '<i>This friend tend to keep itself secret.</i>';
    }

    echo '</div>';
    echo '</div>';
}

?>
</div>

<style>
.friends {
    display: grid;
    grid-template-columns: repeat(auto-fill, 360px);
    align-content: flex-start;
    justify-content: center;
    row-gap: 1em;
    column-gap: 1em;
    margin-bottom: 2em;
    overflow: auto;

    user-select: none;
}

.link-item {
    height: 7em;
    border: 1px solid var(--border-color);
    background-color: var(--section-background-color);

    display: flex;
    align-items: center;
}

.link-item > .avatar {
    width: 5em;
    height: 5em;

    margin: 1em;
}

.link-item > .link-content {
    height: 100%;
    margin-left: 1em;
    margin-right: 1em;

    display: flex;
    flex-direction: column;
    justify-content: center;
}

.link-item:last-child {
    margin-bottom: 200px;
}
</style>