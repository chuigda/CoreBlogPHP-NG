#import "template.typ": *

#show: project.with(
  title: [面向对象五十弦],
  authors: (
    (name: "Lesley Lai", contrib: "原作者", affiliation: ""),
    (name: "Chuigda Whitegive", contrib: "翻译", affiliation: "第七通用设计局"),
    (name: "CAIMEO", contrib: "翻译提议", affiliation: ""),
  )
)

#show link: set text(fill: rgb(0, 127, 255))
#show math.equation.where(block: true): set block(breakable: false)
#show raw.where(block: true): set block(breakable: false)
#show raw.where(block: true): it => pad(left: 2em, it)
#show raw.where(lang: none): it => raw(it.text, lang: "hs", block: it.block)
#set par(spacing: 1.2em)

#let small(content) = text(size: 10pt)[#content]

⚠ 注意：本文为早期草稿，内容不完且有措误，且#text(tracking: -0.15em)[排版]质量差。

⚠ Note: this is an early draft. It's known to be incomplet and incorrekt, and it has lots of b#text(tracking: -0.1em)[ad] fo#text(tracking: -0.1em)[rm]atting.

== 译者前言

本文是文章 #link("https://lesleylai.info/en/fifty_shades_of_oop/")[Fifty Shades of OOP] 的中文翻译。#term[术语 (terminology)] 在正文中第一次出现的地方以#term[仿宋体（中文）]或 #emph[Italic (English)] 呈现，如果某个术语难以辨认，则总是会以#term[仿宋体]呈现。如遇翻译或排版质量问题，请在 #link("https://github.com/chuigda/CoreBlogPHP-NG/issues") 向译者报告。

== 前言

如今，批倒批臭#term[面向对象编程 (Object Oriented Programming, OOP)] 似乎成为了某种潮流。读过 Lobster 上的两篇关于面向对象编程的文章之后，我决定写这篇文章。我无意抨击或是捍卫面向对象编程，但我希望能发表一点个人拙见，提供一个更客观全面的视角。

工业界和学术界用“面向对象”一词来表示多种不同的含义。而相关的讨论如此低效，正是因为人们对“面向对象编程究竟是什么”缺乏共识。

什么是面向对象编程？#link("https://en.wikipedia.org/wiki/Object-oriented_programming")[维基百科]将其定义为“基于对象概念的编程范式”。这个定义不尽人意，它没有定义“对象”是什么，也未能涵盖这一术语在工业界的不同使用方式。Alan Kay 还给出过一个#link("https://www.purl.org/stefan_ram/pub/doc_kay_oop_en")[这样的视角]。然而，大多数人使用这个术语的方式已经出现了偏移。我不想因为坚持单一的“真实”含义，而陷入#link("https://en.wikipedia.org/wiki/Essentialism")[本质主义]或者#link("https://en.wikipedia.org/wiki/Etymological_fallacy")[词源学谬误]。

#small[
  有意思的是，本文发布之后，部分评论针对“对象”的权威定义展开了争论，且各自基于截然不同的标准，例如：(i) Alan Kay 的#term[消息传递 (message passing)]；(ii) 任何能提供#term[封装 (encapsulation)] 的事物（包括#term[闭包 closure ]与#term[模块 module]）; (iii) #term[动态派发 (dynamic dispatch)]；(iv) #term[方法 (method)]。
]

与其执着于单一定义，不如把面向对象编程当作一系列彼此相关的思想的混合体，并逐一单独考察每种思想。接下来，我将考察一些和面向对象编程相关的思想，并（主观地）探讨其优缺点。

#colbreak()

== 类

#set quote(block: true)
#quote(attribution: [Grady Booch])[Object-oriented programming is a method of implementation in which programs are organized as cooperative collections of objects, each of which represents an instance of some class, and whose classes are all members of a hierarchy of classes united via inheritance relationships.

面向对象编程是一种实现方法：程序被组织为对象的协作集合，每个对象代表某个#term[类 (class)] 的一个#term[实例 (instance)]，并且其类都是通过#term[继承 (inheritance)] 关系聚合起来的#term[类层次结构 (hierarchy of classes)] 的成员。]

#term[类]扩展了“#term[结构体 (struct)]”或者“#term[记录 (record)]”的定义，加入了方法语法、信息隐藏和继承。这些具体特性我们稍后讨论。

类也可以视作对象的蓝图。这不是唯一的做法——#term[原型 (prototype)] 是 #link("https://en.wikipedia.org/wiki/Self_(programming_language)")[Self 语言]首创的方案，并因其被 JavaScript 使用而广为人知。我个人的感受是，相比于#term[类]，原型更难理解。即使是 JavaScript 也引入了 ES6 class, 努力向初学者隐藏其原型的使用。

#small[当我学习 JavaScript 的时候，原型继承和 `this` 的语义是我最困扰的两个主题。]

== 方法语法

#quote(attribution: link("https://evrone.com/blog/yukihiro-matsumoto-interview")[Yukihiro Matsumoto])[
  In Japanese, we have sentence chaining, which is similar to method chaining in Ruby.

  日语中有 _⚠ TODO sentence chaining ⚠_，这和 Ruby 中的#term[方法链 (method chaining)] 很像
]