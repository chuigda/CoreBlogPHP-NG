#import "template.typ": *

#show: project.with(
  title: "十分钟速成魔术回路",
  authors: (
    (name: "Chuigda Whitegive", contrib: "作者", affiliation: "第七通用设计局"),
    (name: "Cousin Ze", contrib: "作者", affiliation: "第七通用设计局"),
  )
)
#show link: set text(fill: rgb(0, 127, 255))
#show math.equation.where(block: true): set block(breakable: false)
#show raw.where(block: true): set block(breakable: false)
#show raw.where(block: true): it => pad(left: 2em, it)
#set par(spacing: 1.2em)
#set quote(block: true)
#show quote: set align(center)
#show quote: set pad(x: 2em)

// 最高指示
// 1. 谁没有智慧就敢妄言程序设计语言理论，他就为自己在火狱中预备了位置
// 2. 只有时时刻刻把读者当弱智，才能不让读者把你当弱智

= 前言

已经是  2025 年了。#strike[随着 TypeScript 和 Rust 等工具在 JavaScript Kiddies 圈子的普及，]现在基本上是个人就能在类型论方面胡吹两句。作为一名野心勃勃的计算机科学家#footnote[甭管是不是，至少你应该这么称呼自己，而不是管自己叫程序员。]，你当然不甘心屈居人下，希望掌握一些普通人#strike[尤其是 JavaScript Kiddies] 绝对看不懂的东西，好让你在跟这些图样图森破的人谈笑风生的时候一眼看出他们的暴论，并从更高的理论层面把他们批判一番。然而，当你打开各种各样关于程序设计语言理论的书籍、博客和论文的时候，像这样的: $e := v | lambda x -> e | e thin e'$，这样的: $lambda f. lambda x. f (f x)$ 还有这样的: $(Gamma tack tau) / (Gamma tack x : tau)$ 公式却属实让你猛打退堂鼓，怀疑自己不是这块料。同时你又实在不肯放下面子去看#link("https://thelittletyper.com/")[儿童读物]。

如果你遇到了这种情况，这说明你对程序设计语言领域常见的行业黑话缺乏理解。用菌类的话来说，就是你缺少基本的#term[魔术回路 (Magic Circuit)]。别担心，本文正是要帮助你在十分钟内速成魔术回路，从而让你有能力阅读和理解程序设计语言理论领域的入门级资料（比如#link("https://www.andres-loeh.de/LambdaPi/LambdaPi.pdf")[这一篇]#footnote[我们也翻译了这篇论文: #link("https://chuigda.doki7.club/research/lambda-pi.pdf")[https://chuigda.doki7.club/research/lambda-pi.pdf]。]）。

#set heading(numbering: "1.")

= 巴科斯-瑙尔表示法

== 这是啥

我们从最简单的东西——#term[巴科斯-瑙尔表示法 (Backus-Naur Form, BNF)]#footnote[又称#term[巴科斯范式 (Backs Normal Form)]，但#link("https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_form#History")[高德纳认为]它不是一种#link("https://en.wikipedia.org/wiki/Normal_form_(abstract_rewriting)")[#term[范式 (Normal form)]。我也这么认为。]]#footnote[顺带一提，我们把 #term[Normal Form] 一词翻译为 #term[正规形式]。] 开始。如果这玩意你看不懂，那你编译原理肯定逃课了。不过国内编译原理课程在讲到 BNF 的时候大多都在死磕#strike[傻逼]“四类文法”和“推导产生”的定义，听的人昏昏欲睡，你逃课也是可以理解的。

BNF 起初主要是用来表示程序设计语言的#term[语法 (syntax)]的，当然也可以用来表示其他的东西。它的基本形式是这样：

$
  & "一个东西" med & ::= med & "另一个东西" \
  &               &     med | & "再一个东西" \
  &               &     med | & ...
$

或者有时候作者会把所有东西塞在一行里：

$
  "一个东西" med ::= med "另一个东西" | "再一个东西" | ...
$

这种形式很好理解，你只要把 $::=$ 读作“可以是”，把 $|$ 读作“或者”就行了。举个例子：

$
  & "expr" med & ::= med & "value" \
  &            &     med | & "expr" med #[`+`] med "value" \
  &            &     med | & "expr" med #[`-`] med "value"
$

你可以这么读：“一个 expr 可以是一个 value，或者是一个 expr 加上一个 value，或者是一个 expr 减去一个 value。”

如你所见，$::=$ 符号右边的东西可以包含 $::=$ 左边的那个符号，因此 BNF 可以通过这种方式来定义#term[递归的 (recursive)] 结构。如果你对递归没概念（那你翘的课可能有亿点多），那也没关系，接下来马上你就看到递归有什么用了。

== 怎么用

这种记法最直接的用途就是以一种比较正式的方式介绍“一个 A 可以是 B，可以是 C……”这种规则。

比如说，你的 C 语言老师说：

#quote(attribution: [你的 C 语言老师])[一条 C 语言语句可以是一个 `if` 语句、可以是一个 `while` 语句、可以是一个语句块#footnote[实际上 C 语言的语法规则比这复杂得多，这里只是为了演示 BNF 的用法，所以对规则作了简化。]…… 一个 `if` 语句以关键字 `if` 开头，后面跟着一对圆括号，括号里是一个表达式，接着是另一条语句……]

显然，用语言来描述不但繁琐容易出错，而且逼格不够容易被人看不起。你写成 BNF，一下子就高大上了：

$
  & "stmt" med & ::= med   & med "if-stmt" ^#footnote[再次强调，这是用于演示 BNF 用法的*简化规则*。如果你拿这玩意去跟人讨论 C 语言，必挨语言律师的骂。] \
  &            &     med | & med "while-stmt" \
  &            &     med | & med "block-stmt" \
  &            &     med | & med "other-stmt" \
  \
  & "if-stmt" med & ::= med   & med #[`if`] med #[`(`] med "expr" med #[`)`] med "stmt" \
  &               &     med | & med #[`if`] med #[`(`] med "expr" med #[`)`] med "stmt" med #[`else`] med "stmt" \
  \
  & "while-stmt" med & ::= med   & med #[`while`] med #[`(`] med "expr" med #[`)`] med "stmt" \
  \
  & "block-stmt" med & ::= med   & med #[`{`] med "stmt-list" med #[`}`] \
  \
  & "stmt-list" med & ::= med   & med "stmt-list" med "stmt" \
  &                 &     med | & med epsilon
$

在 BNF 里，希腊字母 $epsilon$（读作“埃普西隆”）通常表示“空字符串”，也就是“什么都没有”。$"stmt-list" ::= epsilon$ 这句话也就是再说“一个语句列表可以是空的，里面没有任何语句”。

这个 BNF 有几个有意思的地方：stmt 的右边有 if-stmt、while-stmt，而 if-stmt、while-stmt 的右边又都有 stmt。这样一来，你就可以用 stmt 来表示任意复杂的嵌套语句结构。比如说，对于这段程序：

```c
while (x --> 0)
  if (x % 2 == 0)
    if (x % 3 == 0)
      do_something;
```

#colbreak()

你可以这样展开 stmt，让它匹配上面这段代码：

$
  & "stmt" & = & "while-stmt" \
  &        & = & #[`while`] med #[`(`] med "expr" med #[`)`] med "stmt"_1 \
  &        & = & #[`while`] med #[`(`] med "expr" med #[`)`] med "if-stmt"_1 \
  &        & = & #[`while`] med #[`(`] med "expr" med #[`)`] med [ #[`if`] med #[`(`] med "expr" med #[`)`] med "stmt"_2 ]_"if-stmt1" \
  &        & = & #[`while`] med #[`(`] med "expr" med #[`)`] med [ #[`if`] med #[`(`] med "expr" med #[`)`] med "if-stmt"_2 ]_"if-stmt1" \
  &        & = & #[`while`] med #[`(`] med "expr" med #[`)`] med [ #[`if`] med #[`(`] med "expr" med #[`)`] med [ #[`if`] med #[`(`] med "expr" med #[`)`] med "stmt"_3 ]_"if-stmt2" ]_"if-stmt1" \
  &        & = & #[`while`] med #[`(`] med "expr" med #[`)`] med [ #[`if`] med #[`(`] med "expr" med #[`)`] med [ #[`if`] med #[`(`] med "expr" med #[`)`] med "other-stmt"_3 ]_"if-stmt2" ]_"if-stmt1"
$

而 stmt-list 的右边有一条规则是 stmt-list stmt，用这种方式，我们可以用 stmt-list 表示任意多条语句的序列，比如说，对于这段程序：

```c
// {
  while (x --> 0) y += 2 * x;
  while (y --> 0) z += 3 * y;
  if (z == magic_number) do_magic();
// }
```

你可以这样展开 stmt-list，让它匹配上面这段代码：

$
  & "stmt-list" & = & "stmt-list"_1 med "stmt"_1 \
  &             & = & ["stmt-list"_2 med "stmt"_2]_"stmt-list1" med "stmt"_1 \
  &             & = & [ ["stmt-list"_3 med "stmt"_3]_"stmt-list2" med "stmt"_2 ]_"stmt-list1" med "stmt"_1 \
  &             & = & [ [ epsilon_"stmt-list3" med "stmt"_3 ]_"stmt-list2" med "stmt"_2 ]_"stmt-list1" med "stmt"_1 \
  &             & = & epsilon med "stmt"_3 med "stmt"_2 med "stmt"_1 \
  &             & = & epsilon med "while-stmt"_3 med "while-stmt"_2 med "if-stmt"_1 \
  &             & = & med "while-stmt"_3 med "while-stmt"_2 med "if-stmt"_1
$

除了用于表示语法以外，BNF 还可以用来表示一些其他的东西，比如#term[类型]：

$
  & "type" med & ::= med & #[`int`] \
  &            &     med | & #[`bool`] \
  &            &     med | & "type" med #[`->`] med "type"
$

如果你又感觉头晕了，那就回到 1.1 节，重温一下规则，然后开始读：“一个 type 可以是 `int`，或者 `bool`，或者一个 ‘type `->` type’#footnote[这个 `->` 箭头是什么意思我们等会再解释。]”。