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

⚠ 注意：本文为早期草稿，内容不完且有措误，且#text(tracking: -0.15em)[排版]质量差。

⚠ Note: this is an early draft. It's known to be incomplet and incorrekt, and it has lots of b#text(tracking: -0.1em)[ad] fo#text(tracking: -0.1em)[rm]atting.

本文是文章 #link("https://people.cs.nott.ac.uk/pszgmh/123.pdf")[Programming language semantics: It's easy as 1, 2, 3] 的中文翻译，部分字句有所改动。#term[术语 (terminology)] 在正文中第一次出现的地方以#term[仿宋体（中文）]或 #emph[Italic (English)] 呈现，如果某个术语难以辨认，则总是会以#term[仿宋体]呈现。

= 摘要

#term[程序语言语义学 (programming language semantics)] 是计算机科学理论领域的重要话题之一，但新手却常常在入门时面临挑战。本文正是一篇程序语言语义学的入门教程，将整数和加法语言作为一个最小化的框架，以简明的方式呈现一系列语义概念。在这个框架下，一切就像“数数手指一二三”一样简单。

#set heading(numbering: "1.")

= 介绍

#term[语义学 (semantics)] 是对#term[意义 (meaning)] 进行研究的学科的总称。在计算机科学中，程序语言语义学旨在赋予程序精确的数学意义。在研究新的主题时，从简单的例子开始理解基本概念大有裨益，而本文正是要给出这样一个能被用来演示程序语言语义学中诸多主题的例子：由整数值和加法运算符构成的简单算术表达式语言。

多年以来，这门语言在我自己的工作中扮演着核心角色。起初，它被用来辅助解释语义概念，而随着时间的推移，它逐渐成为了我发现新思想的机制，并出现在我的许多出版物中。本文的目的是巩固这些经验，并展示如何使用这个简单的算术表达式语言以简单的方式呈现一系列语义概念。

使用最简洁的语言来探索语义概念，正是奥卡姆剃刀原理的一个例证 #link("https://people.cs.nott.ac.uk/pszgmh/123.pdf#cite.occams-razor")[(Duignan, 2018)]。奥卡姆剃刀原理是一种哲学原则，它倾向于用最简单的解释来阐明某种现象。尽管由整数和加法组成的语言没有提供实际编程所需的特性，但它却提供了恰好足以解释许多语义学概念的结构。特别地，整数提供了一个简单的“值”的概念，而加法运算符则提供了一个简单的“计算”的概念。这一语言在过去曾被许多作者使用，例如 #link("https://people.cs.nott.ac.uk/pszgmh/123.pdf#cite.mccarthy")[McCarthy 和 Painter (1967)], #link("https://people.cs.nott.ac.uk/pszgmh/123.pdf#cite.wand")[Wand (1982)] 和 #link("https://people.cs.nott.ac.uk/pszgmh/123.pdf#cite.expression-problem")[Wadler (1998)]，仅举几例。而本文开创了将这一语言作为通用工具，探索不同语义学话题的先例。

当然，也可以使用一个更复杂的最小语言，例如带有可变变量的简单命令式语言，或是基于 $lambda$ 演算的简单函数式语言。但这会引入许多其他概念，例如存储、环境、替换和变量捕获。学习这些当然也很重要，但我的经验一次又一次地证明，先将注意力集中在整数和加法的简单语言上大有裨益。只要这个框架下理解了基本概念，读者就可以自行扩展语言，加入其他感兴趣的特性。作者自己的许多工作已经证明了这一方法是行之有效的。

本文以教程形式撰写，不假定读者具备语义学方面的先验知识，面向高年级本科生和低年级博士生。不过，我希望经验丰富的读者也能从中获得对自己工作有用的灵感。初学者不妨先重点关注第 2 至 7 节，这些章节介绍并比较了一些广泛使用的语义学方法（#term[指称 denotational]、#term[小步 small-step]、#term[语境 contextual] 和#term[大步 big-step]），并阐述了如何运用归纳法进行语义推理。而更有经验的读者可能希望直接跳到第 8 节，该节提供了一个扩展示例，展示如何使用#term[续延 (continuation)] 和#term[去函数化 (defunctionalisation)] 从语义中系统地推导出#term[抽象机 (abstract machine)]。

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

例如，表达式 $1 + 2$ 可以被表示为 Haskell 项 `Add (Val 1) (Val 2)`。从现在起，我们主要考虑用 Haskell 表示的表达式。

#include "./pl-semantics-1-2-3/3-denotional.typ"
#include "./pl-semantics-1-2-3/4-small-step.typ"
#include "./pl-semantics-1-2-3/5-rule-induction.typ"
#include "./pl-semantics-1-2-3/6-contextual.typ"
#include "./pl-semantics-1-2-3/7-big-step.typ"
#include "./pl-semantics-1-2-3/8-abstract-machines.typ"