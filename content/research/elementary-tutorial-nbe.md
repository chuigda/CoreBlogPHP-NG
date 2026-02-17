# 基于求值的正规化 (NbE) 初级教程

<!-- This tutorial was originally meant as a five-minute introduction to normalization-by-evaluation (NBE) for undergraduates. It is elementary because it assumes only the elementary school Math as background. No programming experience is necessary either. This tutorial can even be played as a game with shells on a seashore. The rules are elementary, but the game is not always simple. Playing on a seashore may well be a good occasion to see that computation, reduction, normalization, proofs of progress and preservation -- are just games of shuffling symbols. -->

本教程最初是为本科生准备的，旨在用五分钟时间介绍基于评估的正规化 (Normalisation-by-evaluation, NbE)。它之所以简单易懂，是因为它只需要小学数学基础。也不需要任何编程经验。这个教程甚至可以像在海边玩贝壳游戏一样进行。规则很简单，但游戏玩法却并非总是如此轻松。在海边玩耍或许能让你更好地理解：计算、归约、正规化、前进性与保型性的证明 (proofs of progresion and preservation)——其实都只是排列符号的游戏。

<!-- There may be some who peer beyond symbols, who view them as shadows of real things, who look for intuitions behind the seemingly arbitrary rules and seek to grasp the meaning of the game. Such people are no doubt to discover NBE -- as it has been done many times before. This tutorial is to prompt the rediscovery. -->

或许有些人能够超越符号的表象，将它们视为真实事物的影子，在看似武断的规则背后探寻直觉，力图把握游戏的真谛。这些人无疑会发现基于求值的正规化——正如之前无数次那样。本教程旨在促成这一发现。

## 开始

<!-- Let us start with a game/puzzle, which is a simple version of many an exercises in elementary school. It is played with bags and bundles. A bag may be empty, which we write as [], or containing one or more shells, written as #. Shells are game tokens without distinctions: two bags with three shells each are two copies of the same bag, and written identically as [###]. A bundle is either a bag, or a tie-up of two bundles, shown by writing the two bundles side-by-side separated by a comma, with the parentheses around. Here are a few sample bundles: [##], ([##],[]), ([##],([###],[#])); the first one is also a bag. Let us be pedantic and say that nothing else is a bundle (resp. bag); for example, [[]] or (#,[&]) are not bundles because they are not made of zero or more # enclosed in brackets, possibly paired up.  -->

我们从一个游戏开始，这个游戏是许多小学练习的简化版本。玩这个游戏需要袋子和包袱。一个袋子可能是空的，记作 `[]`，也可能装有一个或多个贝壳 `#`。贝壳是一种游戏代币，相互之间没有区别。如果两个袋子里都装着三个贝壳，那么它们就是同一个袋子的两个副本，都可以写作 `[###]`。一个包袱要么是一个袋子，要么由两个包袱打包而成，记法是将两个包袱并排写出来，用逗号隔开，并用括号括起来。以下是一些例子：`[##]`，`([##], [])`，`([##],([###],[#]))`；第一个包袱同时也是一个袋子。让我们咬文嚼字地说，其他任何东西都不是包袱（或者袋子）：例如，`[[]]` 和 `(#, [&])` 都不是包袱，因为他们不是由零个或多个用括号括起来的、成对出现的 `#` 构成的。

<!-- The game is thus: given a bundle find another one that is `equivalent', or `equal', but `simpler' -- ultimately, the simplest. Great many games, er, exercises in school, are of this form. For example, we would be given a `bundle' like 5x - 3 = 3x + 7 and asked to find the equivalent but simplest (x = 5, in our case). -->

这个游戏就是：给你一个包袱，你找到一个和它“等价 (equivalent)”或者“相等 (equal)”但是“更简单”的包袱——归根结底，是要找到最简单的包袱。很多游戏，额，我是说学校练习，都是这种形式的。例如，给你一个类似于 `5x - 3 = 3x + 7` 的“包袱”，你找到与它等价但最简单的形式（在这个例子里就是 `x = 5`）。

<!-- To start playing we have to say exactly what it means for two bundles to be equal, and to be simpler. -->

在开始玩游戏之前，我们还必须明确说明什么样的两个包袱是等价的，以及什么样的包袱更简单。

#### 参考文献

<!-- Our game is actually a variation on Chap. 3 of B. Pierce's `Types and Programming Languages'. That whole textbook is a collection of progressively more complicated symbol-shuffling games -- although they are not called as such. -->

我们的游戏本质上就是 B. Pierce 的《类型与程序设计语言》第三章的一个变体。整本书就是一系列越来越复杂的符号排列游戏 —— 虽然人们不这么称呼他们。

## 相等

<!-- It is entirely up to us to make the rules of our game, in particular, to define the `sameness', or the equality, of bundles. We can do it by pointing at two bundles and declaring them equal -- or, by writing the two bundles around the ~ sign: ([#],([##],[###])) ~ ([##],([#],[###])). To state many such equality declarations we need a more concise way of writing them, like the following. -->

游戏的规则——特别是两个包袱是否“相等”的规则——完全由我们自己定义。我们可以给出两个包袱，宣布它们是相等的 —— 我们把这两个包袱写在符号 `~` 两侧：`([#],([##],[###])) ~ ([##],([#],[###]))`。这样的规则可能有很多，我们需要一种更简洁的表达方式，例如以下形式：

<!-- We declare that ([],[S]) is equal to [S] where S stands for an arbitrary number of shells including zero. We further declare that ([#S],([T],[U])) ~ ([S],([#T],[U])), where where S and T and U stand for an arbitrary number of shells, and #S stands for one more shell than S (the same for #T). Finally, we say that in a tie-up of two bags, the order is irrelevant. With fewer words, the declarations may be written as -->

我们宣布 `([], [S])` 和 `[S]` 是相等的，其中 `S` 表示任意数量的（可以是 0 个）贝壳。接着，我们宣布 `([#S],([T],[U])) ~ ([S],([#T],[U]))`，其中 `S`、`T` 和 `U` 是任意数量的贝壳，而 `#S` 表示比 `S` 多一个贝壳（`#T` 也是一样）。最后，我们宣布两个打包在一起的袋子之间的次序不重要。这些宣称可以简写成：

```
    (Ax0)  ([],[S]) ~ [S]
    (Ax1)  ([#S],([T],[U])) ~ ([S],([#T],[U]))
    (AxS)  ([S],[T]) ~ ([T],[S])
```
