<style>
article {
    padding: 1em;

    display: flex;
    flex-direction: row;
    justify-content: center;
}

.passage-list {
    display: flex;
    flex-direction: column;
    row-gap: 1em;
    max-width: 800px;
}

.passage {
    border: 1px solid var(--border-color);
    background-color: var(--section-background-color);

    display: flex;
    flex-direction: column;
    row-gap: 0.5em;
    padding: 1em 0.5em;
}

.passage p,h3,small {
    margin: 0;
}

.passage small > span {
    text-decoration: underline;
}
</style>
