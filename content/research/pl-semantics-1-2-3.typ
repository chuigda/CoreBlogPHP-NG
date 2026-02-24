#import "template.typ": *

#show: project.with(
  title: "程序语言语义学：数数手指一二三",
  author-cols: 3,
  authors: (
    (name: "Graham Hutton", contrib: "原作者", affiliation: "诺丁汉大学"),
    (name: "Chuigda Whitegive", contrib: "翻译", affiliation: "第七通用设计局"),
    (name: "CAIMEO", contrib: "翻译提议、校对", affiliation: ""),
    (name: "gjz010", contrib: "Typst 技术支持", affiliation: ""),
    (name: "Gemini", contrib: "校对", affiliation: "Google Deepmind"),
    (name: "Claude", contrib: "校对", affiliation: "Anthropic")
  )
)

#show link: set text(fill: rgb(0, 127, 255))
#show math.equation.where(block: true): set block(breakable: false)
#show raw.where(block: true): set block(breakable: false)
#show raw.where(block: true): it => pad(left: 2em, it)
#show raw.where(lang: none): it => raw(it.text, lang: "hs", block: it.block)
#set par(spacing: 1.2em)

= 译者前言

本文是文章 #link("https://people.cs.nott.ac.uk/pszgmh/123.pdf")[Programming language semantics: It's easy as 1, 2, 3] 的中文翻译，部分字句有所改动。#term[术语 (terminology)] 在正文中第一次出现的地方以#term[仿宋体（中文）]或 #emph[Italic (English)] 呈现，如果某个术语难以辨认，则总是会以#term[仿宋体]呈现。如遇翻译或排版质量问题，请在 #link("https://github.com/chuigda/CoreBlogPHP-NG/issues") 向译者报告。

= 摘要

#term[程序语言语义学 (programming language semantics)] 是计算机科学理论领域的重要话题之一，但新手却常常在入门时面临挑战。本文正是一篇程序语言语义学的入门教程，将整数和加法语言作为一个最小化的框架，以简明的方式呈现一系列语义概念。在这个框架下，一切就像“数数手指一二三”一样简单。

#set heading(numbering: "1.")

= 介绍

#term[语义学 (semantics)] 是对#term[意义 (meaning)] 进行研究的学科的总称。在计算机科学中，程序语言语义学旨在赋予程序精确的数学意义。在研究新的主题时，从简单的例子开始理解基本概念大有裨益，而本文正是要给出这样一个能被用来演示程序语言语义学中诸多主题的例子：由整数值和加法运算符构成的简单算术表达式语言。

多年以来，这门语言在我自己的工作中扮演着核心角色。起初，它被用来辅助解释语义概念，而随着时间的推移，它也逐渐成为了我发现新思想的机制，并出现在我的许多出版物中。本文的目的是巩固这些经验，并展示如何使用这个简单的算术表达式语言以简单的方式呈现一系列语义概念。

使用最简洁的语言来探索语义概念，正是奥卡姆剃刀原理的一个例证 #link("(Duignan, 2018)")。奥卡姆剃刀原理是一种哲学原则，它倾向于用最简单的解释来阐明某种现象。尽管由整数和加法组成的语言没有提供实际编程所需的特性，但它却提供了恰好足以解释许多语义学概念的结构。特别地，整数提供了一个简单的“值”的概念，而加法运算符则提供了一个简单的“计算”的概念。这一语言在过去曾被许多作者使用，例如 #link("McCarthy & Painter (1967)"), #link("Wand (1982)") 和 #link("Wadler (1998)")，仅举几例。而本文首次将这一语言作为通用工具来探索不同语义学话题。

当然，也可以使用一个更复杂的最小语言，例如带有可变变量的简单命令式语言，或是基于 $lambda$ 演算的简单函数式语言。但这会引入许多其他概念，例如存储、环境、替换和变量捕获。学习这些当然也很重要，但我的经验一次又一次地证明，先将注意力集中在整数和加法的简单语言上大有裨益。只要这个框架下理解了基本概念，读者就可以自行扩展语言，加入其他感兴趣的特性。作者自己的许多工作已经证明了这一方法是行之有效的。

本文以教程形式撰写，不假定读者具备语义学方面的背景知识，面向高年级本科生和博士新生。不过，我希望经验丰富的读者也能从中获得对自己工作有用的灵感。初学者不妨先重点关注第 2 至 7 节，这些章节介绍并比较了一些广泛使用的语义学方法（#term[指称 denotational]、#term[小步 small-step]、#term[语境 contextual] 和#term[大步 big-step]），并阐述了如何运用归纳法进行语义推理。而更有经验的读者可能希望直接跳到第 8 节，该节提供了一个扩展示例，展示如何使用#term[续延 (continuation)] 和#term[去函数化 (defunctionalisation)] 从语义中系统地推导出#term[抽象机 (abstract machine)]。

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

= 总结

本文用整数和加法的简单语言展示了一系列语义学概念，考察了多种语义学方法、归纳原理如何被用于分析语义，以及如何将语义转换为实现。最小语言的运用规避了更复杂的语言会带来的额外复杂性，使得简明扼要地阐述这些思想成为可能。

当然，使用简单的语言亦有局限。例如这一语言不足以阐述不同语义学方法之间的差异：在讨论算术表达式的大步语义时，我们注意到其与指称语义相去无几，不同之处仅仅是将等式换作推理规则。此外，简单的语言不会像更复杂的语言那样引出语义学上的问题和挑战。例如，从语义角度看，可变状态、变量绑定和并发等特性尤其有趣，当它们组合使用时尤其如此。

对于有兴趣深入了解语义学的读者，有很多优秀的教科书可供选择，例如 #link("(Winskel, 1993; Reynolds, 1998; Pierce, 2002; Harper, 2016)")。此外还有各种暑期学校，例如俄勒冈编程语言暑期学校 #link("(OPLSS, 2023)") 和米德兰兹研究生院 #link("(MGS, 2022)")，以及大量的在线资源。我们希望我们开发的简单语言能够为其他人提供一个有用的入口和工具，以探索程序语言语义学的更多方面。在这个框架下，一切就像“数数手指一二三”一样简单。

#set heading(numbering: none)

= 致谢

我要感谢 Jeremy Gibbons, Ralf Hinze, Peter Thiemann, Andrew Tolmach 和众多匿名审稿人，他们给出了许多有用的评论和建议，显著提升了本文的质量。这项工作由 EPSRC 拨款 EP/P00587X/1 资助，项目名称为“关于程序正确性和效率的统一推理”。

= 补充材料

本文的补充材料参见 #link("http://doi.org/10.1017/S0956796823000072")。

= 参考文献

Abbott, M. G., Altenkirch, T., McBride, C. & Ghani, N. (2005) δ for data: Differentiating data structures. _Fundam. Inform._ 65(1-2), 1–28.

Abramsky, S. & Jung, A. (1994) Domain theory. In _Handbook of Logic in Computer Science_, vol. 3. Clarendon, pp. 1–168.

Abramsky, S. & McCusker, G. (1999) Game semantics. _Comput. Logic_ 165, 1–55.

Ager, M. S., Biernacki, D., Danvy, O., & Midtgaard, J. (2003a) A functional correspondence between evaluators and abstract machines. In _Proceedings of the 5th ACM SIGPLAN International Conference on Principles and Practice of Declarative Programming_.

Ager, M. S., Biernacki, D., Danvy, O. & Midtgaard, J. (2003b) _From Interpreter to Compiler and Virtual Machine: A Functional Derivation_. Research Report RS-03-14. BRICS, Department of Computer Science, University of Aarhus.

Bahr, P. & Hutton, G. (2015) Calculating correct compilers. _J. Funct. Program._ 25.

Bahr, P. & Hutton, G. (2020) Calculating correct compilers II: Return of the register machines. _J. Funct. Program._ 30.

Bahr, P. & Hutton, G. (2022) Monadic compiler calculation. _Proc. ACM Program. Lang._ 6(ICFP), 80–108.

Bahr, P. & Hutton, G. (2023) Calculating compilers for concurrency. _Proc. ACM Program. Lang._ 7(ICFP), 740–767.

Burstall, R. (1969) Proving properties of programs by structural induction. _Comput. J._ 12(1), 41–48.

Danvy, O. (2008) Defunctionalized interpreters for programming languages. In _Proceedings of the 13th ACM SIGPLAN International Conference on Functional Programming_.

Danvy, O. & Millikin, K. (2009) Refunctionalization at work. _Sci. Comput. Program._ 74(8), 534–549.

Danvy, O. & Nielsen, L. R. (2004) _Refocusing in Reduction Semantics_. Research Report RS-04-26. BRICS, Department of Computer Science, University of Aarhus.

Duignan, B. (2018) _Occam's Razor_. Encyclopedia Britannica. Available at: https://www.britannica.com/topic/Occams-razor.

Dybjer, P. (1994) Inductive families. _Formal Aspects Comput._ 6(4), 440–465.

Felleisen, M. & Hieb, R. (1992) The revised report on the syntactic theories of sequential control and state. _Theoret. Comput. Sci._ 103(2), 235–271.

Gibbons, J. & Jones, G. (1998) The under-appreciated unfold. In _Proceedings of the Third ACM SIGPLAN International Conference on Functional Programming_.

Goguen, J. & Malcolm, G. (1996) _Algebraic Semantics of Imperative Programs_. MIT.

Harper, R. (2016) _Practical Foundations for Programming Languages_, 2nd ed. Cambridge University.

Hoare, T. (1969) An axiomatic basis for computer programming. _Commun. ACM_ 12, 576–583.

Hope, C. (2008) _A Functional Semantics for Space and Time_. Ph.D. thesis, University of Nottingham.

Hope, C. & Hutton, G. (2006) Accurate step counting. In _Implementation and Application of Functional Languages_. LNCS, vol. 4015. Berlin/Heidelberg: Springer, pp. 91–105.

Hu, L. & Hutton, G. (2009) Towards a verified implementation of software transactional memory. In _Trends in Functional Programming Volume 9_. Intellect, pp. 129–143.

Hu, L. & Hutton, G. (2010) Compiling concurrency correctly: Cutting out the middle man. In _Trends in Functional Programming Volume 10_. Intellect, pp. 17–32.

Huet, G. (1997) The zipper. _J. Funct. Program._ 7(5), 549–554.

Hutton, G. (1998) Fold and unfold for program semantics. In _Proceedings of the 3rd International Conference on Functional Programming_.

Hutton, G. & Bahr, P. (2016) Cutting out continuations. In _A List of Successes That Can Change the World_. LNCS, vol. 9600. Springer, pp. 187–200.

Hutton, G. & Bahr, P. (2017) Compiling a 50-year journey. _J. Funct. Program._ 27.

Hutton, G. & Wright, J. (2004) Compiling exceptions correctly. In _Proceedings of the 7th International Conference on Mathematics of Program Construction_. LNCS, vol. 3125. Springer.

Hutton, G. & Wright, J. (2006) Calculating an Exceptional Machine. In _Trends in Functional Programming Volume 5_. Intellect, pp. 49–64.

Hutton, G. & Wright, J. (2007) What is the meaning of these constant interruptions? _J. Funct. Program._ 17(6), 777–792.

Kahn, G. (1987) Natural semantics. In _Proceedings of the 4th Annual Symposium on Theoretical Aspects of Computer Science_.

Landin, P. (1964) The mechanical evaluation of expressions. _Comput. J._ 6, 308–320.

McBride, C. (2008) Clowns to the left of me, jokers to the right: Dissecting data structures. In _Proceedings of the Symposium on Principles of Programming Languages_.

McCarthy, J. & Painter, J. (1967) Correctness of a compiler for arithmetic expressions. In _Mathematical Aspects of Computer Science_. Proceedings of Symposia in Applied Mathematics, vol. 19. American Mathematical Society, pp. 33–41.

Meijer, E., Fokkinga, M. & Paterson, R. (1991) Functional programming with bananas, lenses, envelopes and barbed wire. In _Proceedings of the Conference on Functional Programming and Computer Architecture_.

MGS. (2022) _Midlands Graduate School in the Foundations of Computing Science_. Available at: http://www.cs.nott.ac.uk/MGS/.

Milner, R. (1999) _Communicating and Mobile Systems: The Pi Calculus_. Cambridge University.

Moran, A. (1998) _Call-By-Name, Call-By-Need, and McCarthy's Amb_. Ph.D. thesis, Chalmers University of Technology.

Mosses, P. (2004) Modular structural operational semantics. _J. Logic Algebraic Program._ 60-61, 195–228.

Mosses, P. (2005) _Action Semantics_. Cambridge University.

Norell, U. (2007) _Towards a Practical Programming Language Based on Dependent Type Theory_. Ph.D. thesis, Department of Computer Science and Engineering, Chalmers University of Technology.

OPLSS. (2023) _Oregon Programming Languages Summer School_. Available at: https://www.cs.uoregon.edu/research/summerschool/archives.html.

Pickard, M. & Hutton, G. (2021) Calculating dependently-typed compilers. _Proc. ACM Program. Lang._ 5(ICFP), 1–27.

Pierce, B. (2002) _Types and Programming Languages_. MIT.

Plotkin, G. (1981) _A Structured Approach to Operational Semantics_. Report DAIMI-FN-19. Computer Science Department, Aarhus University, Denmark, pp. 3–15.

Plotkin, G. (2004) The origins of structural operational semantics. _J. Logic Algebraic Program._ 60-61.

Reynolds, J. C. (1972) Definitional interpreters for higher-order programming languages. In _Proceedings of the ACM Annual Conference_.

Reynolds, J. C. (1998) _Theories of Programming Languages_. Cambridge University.

Schmidt, D. A. (1986) _Denotational Semantics: A Methodology for Language Development_. Allyn and Bacon, Inc.

Scott, D. & Strachey, C. (1971) _Toward a Mathematical Semantics for Computer Languages_. Technical Monograph PRG-6. Oxford Programming Research Group.

Wadler, P. (1998) _The Expression Problem_. Available at: http://homepages.inf.ed.ac.uk/wadler/papers/expression/expression.txt.

Wand, M. (1982) Deriving target code as a representation of continuation semantics. _ACM Trans. Program. Lang. Syst._ 4(3), 496–517.

Winskel, G. (1993) _The Formal Semantics of Programming Languages: An Introduction_. MIT.

Wright, J. (2005) _Compiling and Reasoning about Exceptions and Interrupts_. Ph.D. thesis, University of Nottingham.
