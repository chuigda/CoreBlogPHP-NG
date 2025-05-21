<style>
body {
    font-family: var(--body-font-family);
    background-color: var(--body-background-color);
    color: var(--body-text-color);
}

h1, h2, h3, h4, h5, h6 {
    color: var(--title-color);
}

h1 {
    font-size: 1.5em;
    text-align: center;
}

h2 {
    font-size: 1.33em;
}

h3 {
    font-size: 1.17em;
}

a {
    color: var(--link-color);
    text-decoration: none;
}

pre {
    background-color: var(--snippet-background-color);
    color: var(--snippet-text-color);
    padding: 1em;

    overflow-x: auto;
}

blockquote {
    background-color: var(--detail-background-color);
    color: var(--block-text-color);
    border-left: 4px solid var(--border-color);
    padding: 0.5em 1em;
    margin-left: 0;
    margin-right: 0;
}

code {
    font-family: var(--code-font-family);
}

html {
    width: 100vw;
    height: 100vh;
    max-width: 100vw;
    max-height: 100vh;
}

body {
    display: flex;
    flex-direction: column;
    margin: 0;
    padding: 0;
    width: 100%;
    height: 100%;
    overflow: hidden;
}

nav.top,footer {
    padding: 0.5em;
    user-select: none;
}

nav.top,footer {
    background-color: var(--navbar-background-color);
}

nav.top a {
    color: var(--navbar-text-color);
    text-decoration: none;
    padding: 0.5em;
    text-align: center;
    text-transform: uppercase;
    display: inline-block;
}

nav.top a:hover {
    color: var(--link-color);
}

nav.top a.current {
    background-color: var(--selected-background-color);
    color: var(--selected-link-color);
}

.main-layout {
    display: flex;
    flex-direction: row;
    flex: 1 1 auto;
    min-height: 0;
}

.tree-view {
    display: block;
    flex: 0 0 300px;
    background-color: var(--section-background-color);
    border-right: 2px solid var(--border-color);

    overflow: auto;
    font-family: var(--code-font-family);
    font-size: 12pt;
    user-select: none;
    padding: 0.5em 1em 0.5em 0.5em;
    text-wrap: nowrap;
}

.tree-view details > :not(summary)::before {
    content: '├╴';
}

.tree-view details > :not(summary):last-child::before {
    content: '└╴';
}

.tree-view a.current {
    background-color: var(--selected-background-color);
    color: var(--selected-text-color);
}

@media(max-width: calc(1024px)) {
    .tree-view {
        display: none;
    }
}

@media(orientation: portrait) {
    .tree-view {
        display: none;
    }
}

article {
    flex-grow: 1;
    overflow-y: auto;
    padding-left: 1em;
    padding-right: 1em;
}
</style>
