<!-- IE5 to IE9 support. There'll be an ugly horizontal scroll bar on IE6/7, quite unfortunate -->
<!--[if gte IE 5]>
<style type="text/css">
body { box-sizing: border-box; padding: 0.5em; overflow: auto; }
.tree-view { display: none; }
.passage { margin: 1em; border: 1px solid black; }
</style>
<![endif]-->

<!-- IE10/11 support. Using @media since IE10/11 does not support if condition any more. -->
<style>
@media all and (-ms-high-contrast: none), (-ms-high-contrast: active) {
    body { box-sizing: border-box; padding: 0.5em; overflow: auto; }
    .tree-view { display: none; }
    .passage { margin: 1em; border: 1px solid black; }
}
</style>
