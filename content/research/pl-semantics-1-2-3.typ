#import "template.typ": *

#show: project.with(
  title: "程序语言语义学：数数手指一二三",
  author-cols: 3,
  authors: (
    (name: "Graham Hutton", contrib: "原作者", affiliation: "诺丁汉大学"),
    (name: "Chuigda Whitegive", contrib: "翻译", affiliation: "第七通用设计局"),
    (name: "CAIMEO", contrib: "翻译提议、校对", affiliation: ""),
  )
)

#align(center, pad(
  top: -2em,
  x: 4em,
  grid(
    align: center,
    columns: (1fr,) * 2,
    gutter: 1em,
    [
      *Gemini* \
      校对 \
      Google Deepmind
    ],
    [
      *Claude* \
      校对 \
      Anthropic
    ]
  ),
))

#show link: set text(fill: rgb(0, 127, 255))
#show math.equation.where(block: true): set block(breakable: false)
#show raw.where(block: true): set block(breakable: false)
#show raw.where(block: true): set pad(left: 2em)
#show raw.where(lang: none): it => raw(it.text, lang: "hs", block: it.block)
#set par(spacing: 1.2em)

= 译者前言

⚠️注意：本文为早期草稿，内容不完且有措误，且#text(tracking: -0.15em)[排版]质量差。

⚠️Note: this is an early draft. It's known to be incomplet and incorrekt, and it has lots of b#text(tracking: -0.1em)[ad] fo#text(tracking: -0.1em)[rm]atting.

本文是文章 #link("https://people.cs.nott.ac.uk/pszgmh/123.pdf")[Programming language semantics: It's easy as 1, 2, 3] 的中文翻译，部分字句有所改动。#term[术语 (terminology)] 在正文中第一次出现的地方以#term[仿宋体（中文）]或 #emph[Italic (English)] 呈现，如果某个术语难以辨认，则总是会以#term[仿宋体]呈现。

= 摘要

#term[程序语言语义学 (programming language semantics)] 是计算机科学理论领域的重要话题之一，但新手却常常在入门时面临挑战。本文正是一篇程序语言语义学的入门教程，将整数和加法语言作为一个最小化的框架，以简明的方式呈现一系列语义概念。在这个框架下，一切就像“数数手指一二三”一样简单。

#set heading(numbering: "1.")

= 介绍

#term[语义学 (semantics)] 是对#term[意义 (meaning)] 进行研究的学科的总称。在计算机科学中，程序语言语义学旨在赋予程序精确的数学意义。在研究新的主题时，从简单的例子开始理解基本概念大有裨益，而本文正是要给出这样一个能被用来演示程序语言语义学中诸多主题的例子：由整数值和加法运算符构成的简单算术表达式语言。

多年以来，这门语言在我自己的工作中扮演着核心角色。起初，它被用来辅助解释语义概念，而随着时间的推移，它逐渐成为了我发现新思想的机制，并出现在了我的许多出版物中。本文的目的是巩固这些经验，并展示如何使用这个简单的算术表达式语言以简单的方式呈现一系列语义概念。

使用最简洁的语言来探索语义概念，正是奥卡姆剃刀原理的一个例证 #link("https://people.cs.nott.ac.uk/pszgmh/123.pdf#cite.occams-razor")[(Duignan, 2018)]。奥卡姆剃刀原理是一种哲学原则，它倾向于用最简单的解释来阐明某种现象。尽管由证书和加法组成的语言没有提供实际编程所需的特性，但它却提供了恰好足以解释许多语义学概念的结构。特别地，整数提供了一个简单的“值”的概念，而加法运算符则提供了一个简单的“计算”的概念。这一语言在过去曾被许多作者使用，例如 #link("https://people.cs.nott.ac.uk/pszgmh/123.pdf#cite.mccarthy")[McCarthy 和 Painter (1967)], #link("https://people.cs.nott.ac.uk/pszgmh/123.pdf#cite.wand")[Wand (1982)] 和 #link("https://people.cs.nott.ac.uk/pszgmh/123.pdf#cite.expression-problem")[Wadler (1998)]，仅举几例。而本文开创了将这一语言作为通用工具，探索不同语义学话题的先例。

当然，也可以使用一个更复杂的最小语言，例如带有可变变量的简单命令式语言，或是基于 $lambda$ 演算的简单函数式语言。但这会引入许多其他概念，例如存储、环境、替换和变量捕获。学习这些当然也很重要，但我的经验一次又一次地证明，先将注意力集中在关于整数和加法的简单语言上大有裨益。只要这个框架下理解了基本概念，读者就可以自行扩展语言每，加入其他感兴趣的特性。作者自己的许多工作已经证明了这一方法是行之有效的。

本文以教程形式撰写，不假定读者具备语义学方面的先验知识，面向高年级本科生和低年级博士生。不过，我希望经验丰富的读者也能从中获得对自己工作有用的灵感。初学者不妨先重点关注第 2 至 7 节，这些章节介绍并比较了一些广泛使用的语义学方法（#term[指称 denotional]、#term[小步 small-step]、#term[语境 contextual] 和#term[大步 big-step]），并阐述了如何运用归纳法进行语义推理。而更有经验的读者可能希望直接跳到第 8 节，该节提供了一个扩展示例，展示如何使用#term[续延 (continuation)] 和#term[去函数化 (defunctionalisation)] 从语义中系统地推导出#term[抽象机 (abstract machine)]。

请注意，本文并非旨在全面或深入地阐述语义学，而是旨在总结极简方法的基本思想和优势，并提供进一步阅读的参考资料。本文通篇使用 Haskell 作为元语言来实现语义学思想，这有助于使这些思想更加具体并得以实现。所有代码均可在补充材料中在线获取。

= 算术表达式

我们首先定义要研究的语言：使用加法运算符 $+$ 由整数集 $ZZ$ 构建的简单算术表达式。形式化地说，这些表达式的语言 $E$ 可由如下上下文无关文法定义：

$
  E ::= ZZ | E + E
$

也就是说，一个表达式要么是一个整数值，要么是两个子表达式相加。表达式以常规的文本形式书写，例如 $1 + (2 + 3)$ ——我们假设可以根据需要自由使用括号以消除歧义。表达式的文法也可被直接翻译成 Haskell 数据类型声明，这里我们使用内建的 `Integer` 类型来表示任意精度的整数：

```haskell
data Expr = Val Integer | Add Expr Expr
```

例如，表达式 1 + 2 可以被表示为 Haskell 项 `Add (Val 1) (Val 2)`。从现在起，我们主要考虑用 Haskell 表示的表达式。

= 指称语义

在文章的第一部分，我们展示了如何使用我们简单的表达式语言，来解释和比较多种不同的为语言赋予语义的方法。在本节中，我们将探讨语义学的指称方法 #link("https://people.cs.nott.ac.uk/pszgmh/123.pdf#cite.strachey")[(Scott 和 Strachey, 1971)]——使用#term[值化函数 (valuation function)] 将语言中的#term[词项 (term)] 映射到适当的#term[语义域 (semantic domain)] 中的#term[值 (value)] 来定义词项的#term[意义]。

形式化地说，对于由#term[语法项 (syntactic term)] 构成的语言 $T$，其指称语义由两部分组成：一个#term[语义值 (semantic value)] 集合 $V$，和一个类型为 $T -> V$ 的值化函数，该函数将词项映射到以#term[值]表示的#term[意义]。值化函数通常写作 $[| t |]$——将词项用#term[语义括号 (semantic bracket)] 括起来，表示对词项 $t$ 应用值化函数的结果。语义括号也被称作牛津括号或斯特雷奇括号，以纪念克里斯托弗·斯特雷奇在指称方法上的开创性工作。

值化函数必须是#term[组合性的 (compositional)]：复合词项的#term[意义]完全由其子项的#term[意义]决定。组合性确保了语义的模块化，因而有助于理解，同时也支持了使用简单的等式推理来证明语义的性质。当语义值集合明确时，指称语义常常被视同于其值化函数。

类型 `Expr` 的算术表达式有一个非常简单的指称语义：我们设语义域 $V$ 为 Haskell 的整数类型 `Integer`，并按以下两个等式，定义类型为 `Expr -> Integer` 的值化函数：

$
  & [| #[`Val n`] |] & = & n \
  & [| #[`Add x y`] |] & = & [| #[`x`] |] + [| #[`y`] |]
$

第一个等式声明整数的#term[值]就是该整数自身，而第二个等式声明一个加法表达式的#term[值]是其两个子表达式的#term[值]相加。这一定义显然满足组合性要求，因为复合表达式 `Add x y` 的#term[意义]完全是由将运算符 $+$ 应用于两个子表达式 `x` 和 `y` 各自的#term[意义]定义的。

#colbreak()

组合性简化了推理过程，因为它允许“#term[以等换等 (replace equals by equals)]”的替换。例如，我们的表达式予以满足以下特性：

$
  ([| #[`x`] |] = [| #[`x'`] |] wide [| #[`y`] |] = [| #[`y'`] |])
  /
  ([| #[`Add x y`] |] = [| #[`Add x' y'`] |])
$

也就是说，我们可以随意将加法表达式的两个参数表达式替换成具有相同#term[意义]的其他表达式，而不会改变整个加法的#term[意义]。这一性质可用简单的等式推理，根据值化函数的定义和参数表达式的假设 $[| #[`x`] |] = [| #[`x'`] |]$ 和 $[| #[`y`] |] = [| #[`y'`] |]$ 证得：

$
  & [| #[`Add x y`] |] \
  & = quad { [| - |] "的定义" } \
  & [| #[`x`] |] + [| #[`y`] |] \
  & = quad { "两条假设" } \
  & [| #[`x'`] |] + [| #[`y'`] |] \
  & = quad { [| - |] "的定义" } \
  & [| #[`Add x' y'`] |] \
$

在实践中，由于词项的语义是归纳地构建的，指称语义的证明常用#term[结构归纳法 (structural induction)] 进行 #link("https://people.cs.nott.ac.uk/pszgmh/123.pdf#cite.induction")[(Burstall, 1969)]。作为例子，让我们看看如何证明这个表达式语言的语义是#term[全函数的 (total)]：对于任何表达式 $e$，都存在整数 $n$，使得 $[| e |] = n$。

#term[全函数性 (totality)] 的证明通过对表达式 $e$ 的结构进行归纳来进行。对于#term[基准情况 (base case)] #linebreak() $e = #[`Val n`]$，根据值化函数的定义，等式 $[|#[`Val n`]|]  = n$ 显然成立。对于#term[归纳情况 (inductive case)] $e = #[`Add x y`]$，由归纳假设可得，存在整数 $n, m$，使得 $[| #[`x`] |] = n$ 且 $[| #[`y`] |] = m$，接着应用值化函数，有 $[| #[`Add x y`] |] = [| #[`x`] |] + [| #[`y`] |] = n + m$，从而归纳情况也得证。

值化函数也可以直接翻译成 Haskell 函数定义，只须简单地将数学定义改写成 Haskell 代码：

```haskell
eval :: Expr -> Interger
eval (Val n)   = N
eval (Add x y) = eval x + eval y
```

更一般地说，指称语义可以被视为一个由函数式语言编写的#term[求值器 (evaluator)] 或解释器。例如，使用上述定义，我们有 $`#[`eval (Add (Val 1) (Add (Val 2) (Val 3)))`] = 1 + (2 + 3) = 6$，或者可以这样画成图：

_(译者不会用 Typst 画图，暂时对照原论文看吧)_

在这个例子中我们注意到表达式的求值方式：将每个 `Add` #term[构造子 (constructor)] 替换为整数加法函数 `+`，并移除 `Val` 构造子——或者说，将每个 `Val` 替换成整数上的恒等函数 `id`。这也就是说，尽管函数 `eval` 是递归定义的，因为语义是组合性的，其行为可以被理解为简单地用其他函数替换表达式中的构造子。用这种方式，指称语义也可以被视为一个通过“#term[折叠 (fold)]”源语言的语法来定义的求值函数：

```haskell
eval :: Expr -> Interger
eval = fold id (+)
```

`fold` 算子 (#link("https://people.cs.nott.ac.uk/pszgmh/123.pdf#cite.bananas")[Meijer et al., 1991]) 体现了用其他函数替换语言中构造子的思想。这里，构造子 `Val` 和 `Add` 分别被函数 $f$ 和 $g$ 替换：

```haskell
fold :: (Integer -> a) -> (a -> a -> a) -> Expr -> a
fold f g (Val n) = f n
fold f g (Add x y) = g (fold f g x) (fold f g y)
```

注意由 `fold` 定义的语义上在定义上就是组合性的，因为表达式 `Add x y` 的折叠结果完全是将给定的函数 `g` 应用于两个参数表达式 `x` 和 `y` 的折叠结果来定义的。

本节最后我们补充两点。首先，如果我们把文法 $E ::= ZZ | E + E$ 而不是类型 `Expr` 定义为源语言，那么指称语义写出来就是这样：

$
  & [| n |] & = & n \
  & [| x + y |] & = & [| x |] + [| y |]
$

在这个版本中，同一个符号 $+$ 现在被用于两个不同的用途：在左边，它是一个#term[语法性 (syntactic)] 的构造子，用来构造词项；而在右边，它是一个语义算子，用来计算整数加法。我们选择类型 `Expr` 作为源语言，它提供了专用于构造表达式的的构造子 `Val` 和 `Add`，使得语法和语义之间泾渭分明。

其次，注意到，上述语义并未指定求值顺序——也就是说，我们并未知指定加法的两个参数应以何种顺序求值。在这个例子中，求值顺序对最后得到的值没有影响。若要显式指定求值顺序，就要向语义中引入额外的结构，我们将在第 8 节讨论抽象机时探讨这一点。

*延伸阅读* 关于指称语义的标准参考文献是 #link("dummy")[Schmidt (1986)]，而 #link("dummy")[Winskel (1993)] 的形式语义教科书则对该方法进行了简明扼要的介绍。为 $lambda$ 演算赋予指称语义的问题，特别是递归定义函数和类型所引出的技术问题，促成了域论的发展 #link("dummy")[(Abramsky & Jung, 1994)]。

#link("dummy")[Hutton (1998)] 进一步探讨了使用折叠算子定义指称语义的思想。简单的整数和加法语言也被用作研究一系列其他语言特性的基础，包括异常 #link("dummy")[(Hutton & Wright, 2004)]、中断 #link("dummy")[(Hutton & Wright, 2007)]、事务 #link("dummy")[(Hu & Hutton, 2009)]、非确定性 #link("dummy")[(Hu & Hutton, 2010)] 和状态 #link("dummy")[(Bahr & Hutton, 2015)]。

= 小步语义

另一种流行的语义学方法是#term[操作]方法 #link("dummy")[(Plotkin, 1981)]。在这一方法中，词项的#term[意义]是由词项如何在一个适当的机器模型上执行来定义的。操作语义有两种基本形式：#term[小步 (small-step)] 语义描述执行的每个步骤，#term[大步 (big-step)] 语义描述执行的总体结果。在本节中，我们将讨论小步语义——或称“#term[结构化操作语义 (structural operational semantics)]”，并在第 7 节时再回到大步语义。