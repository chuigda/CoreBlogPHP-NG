#import "template.typ": *

#show: project.with(
  title: "如何阅读类型系统符号",
  author-cols: 3,
  authors: (
    (name: "Alexis King", contrib: "原作者", affiliation: ""),
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
#set par(spacing: 1.2em)

== 译者前言

本文是 StackExchange 提问及回答 #link("https://langdev.stackexchange.com/a/2693")[How should I read type system notation] 的中文翻译，部分字句有所改动。译者还增补了几个常用的符号。#term[术语 (terminology)] 在正文中第一次出现的地方以#term[仿宋体（中文）]或 #emph[Italic (English)] 呈现。如遇翻译或排版质量问题，请在 #link("https://github.com/chuigda/CoreBlogPHP-NG/issues") 向译者报告。

== 前言

用于描述类型系统的符号因不同的表示方法而异，因此不可能给出全面的概述。不过，大多数表示方法之间都有许多共通之处，本回答会尝试提供足够的基础知识，以便理解常见的各种变体。

== 语法和文法

应用于程序设计语言的类型系统是#term[语法性 (syntactic)] 系统，也就是说，类型系统是定义在程序设计语言（抽象）语法之上的一组规则。因此，对类型系统的全面论述首先会使用#link("https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_form")[#term[巴科斯-瑙尔表示法 (Backus Naur Form, BNF)]]#footnote[译注：#link("https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_form#History")[BNF 不是一种#term[范式 / 正规形式 (Normal Form)]]。] 提供类型系统所考虑的所有#term[语法构造 (syntactic construct)] 的#link("https://en.wikipedia.org/wiki/Formal_grammar")[#term[文法 (grammar)]]。在最简单的类型化语言中，语法仅用于两件事：表达式和类型。

例如，考虑如下只包括布尔和整数的简单语言的文法：

$
  e ::= & "true" | "false" & wide & "布尔字面量" \
      | & 0 | 1 | -1 | 2 | -2 & wide & "整数字面量" \
      | & #[`if`] e #[`then`] e #[`else`] e & wide & "条件" \
      | & e + e | e - e | e times e & wide & "算术" \
      | & e = e | e < e | e > e & wide & "比较" \
  \
  tau ::= & "Bool" & wide & "布尔" \
        | & "Int" & wide & "整数"
$

这里，$e$ 对应于表达式，而 $tau$ 对应于类型，这是标准的符号约定。有的表示方法会为类型选用不同的符号，如 $t$, $T$, $sigma$ 或者其他小写希腊字母，但总体结构大致相同。

更复杂的语言自然会有更复杂的文法：命令式语言需要#term[语句 (statement)] 的文法，支持模式匹配的语言需要模式的文法，诸如此类。而我们上面的简单语言里甚至连变量都没有！然而，在文法上区分#term[词项 (term, 具有类型的东西)] 和类型是必要的，因为类型系统正是要定义词项和类型间的关系。

#colbreak()

== 关系、判断、公理和推理规则

指定文法之后，下一步就是定义#term[类型关系 (typing relation)]。类型关系通常写作 $e : tau$，可以读作“$e$ 的类型是 $tau$”。直觉上，我们能够理解，一些陈述是“有意义”的，另一些则没有：

- $1 + 2 : "Int"$ 表示“$1 + 2$ 的类型是 Int”，这当然是有意义的。
- $1 + 2 : "Bool"$ 表示“$1 + 2$ 的类型是 Bool”，而这是没有意义的。
- $"true" + 2 : "Int"$ 表示“$"true" + 2$ 的类型是 Int”，这更没有意义，因为 $"true" + 2$ 本来就是无稽之谈，根本不应该有类型。

我们应该写一些能准确捕捉我们“哪些陈述有意义，哪些没有”直觉的规则。为此，我们定义#term[类型判断 (typing judgement)]，写作：

$
  tack e : tau
$

这里，$tack$ 可以读作“以下陈述是正确的”。这里的 $tack$ 可能显得有点多余，并且在简单的类型系统（比如现在我们讨论的这个）当中也确实可以省略，但它接下来会发挥更重要的作用。

用这种符号，我们就可以为我们的类型系统写一些#term[类型规则 (typing rule)]了：

$
  \
  () / (tack "true" : "Bool") wide
  () / (tack "false" : "Bool")
$

这两条规则上面都有一条横线，而横线上空无一物，这表示它们恒成立，也就是说它们是#term[公理 (axiom)]。对于整数字面量，我们也可以有无数这样的公理：

$
  \
  () / (tack 0 : "Int") wide
  () / (tack 1 : "Int") wide
  () / (tack -1 : "Int") wide
  () / (tack 2 : "Int") wide
  …
$

当然，字面量的类型规则相当无聊。但当表达式里包含子表达式的时候，事情就变得有意思了！以下是 $+$ 和 $<$ 的类型规则：

$
  (tack e_1 : "Int" \
   tack e_2 : "Int")
  /
  (tack e_1 + e_2 : "Int")
  wide
  (tack e_1 : "Int" \
   tack e_2 : "Int")
  /
  (tack e_1 < e_2 : "Bool")
$

现在，横线上下都有东西了，它们就成为了#term[推理规则 (inference rule)]。它们表示有条件的类型规则：*如果*横线上的所有陈述成立，*则*横线下面的陈述成立。例如，第一条规则可以读作“如果 $e_1 : "Int"$ 成立且 $e_2 : "Int"$ 成立，则 $e_1 + e_2: "Int"$ 成立”，希望这符合直觉。

$-$，$times$，$=$ 和 $>$ 的规则和上面的两条规则大致相同。但 `if` … `then` … `else` 的规则要再复杂一点。这是因为 `if` 表达式的两个分支可以具有任何类型，只要两个分支的类型相同。也就是说，

$
  #[`if`] "true" #[`then`] 1 #[`else`] 2
$

和

$
  #[`if`] "true" #[`then`] "false" #[`else`] "true"
$

是合法的，但

$
  #[`if`] "true" #[`then`] 1 #[`else`] "true"
$

是不合法的。

#colbreak()

要描述这一点，类型规则用一个变量来表示分支的类型：

$
  (& tack e_1 : "Bool" \
   & tack e_2 : tau \
   & tack e_3 : tau)
  /
  (tack #[`if`] e_1 #[`then`] e_2 #[`else`] e_3 : tau)
$

应用这条规则时，我们可以为 $tau$ 选取任何类型，只要它在两个分支之间保持一致就行。

这种符号起源于#term[形式逻辑 (formal logic)]，特别地，用于类型系统的符号风格上与#link("https://en.wikipedia.org/wiki/Natural_deduction")[#term[自然演绎 (natural deduction)]] 最为接近。虽然我不会在本答案中详细介绍符号的具体细节，但以这种形式表达的规则可以被用来构建关于系统属性的形式化证明，这对于证明#link("https://en.wikipedia.org/wiki/Type_safety")[#term[类型健全性 (type soundness)]] 之类的属性非常重要。

== 作为算法规范的判断

到目前为止，我一直在刻意避免谈及类型判断的计算解释。一般而言，判断只是逻辑规则，而某些以这种方式指定的类型系统并不直接对应于#term[可判定的 (decidable)] 类型检查算法。然而，如果你不习惯思考证明系统，这种纯逻辑的视角可能不太直观。

幸运地，很多时候，你都可以用一种方法照着类型规则写出类型检查算法：我们可以把 $tack e : tau$ 解释成一个从表达式 $e$ 到其类型 $tau$ 的#term[函数 (function)]。通常表达式文法中的每种情况都有相应的一条规则，我们可以将整个类型规则转写成一个递归的类型检查函数，每条规则对应于这个递归函数中的一条分支。

例如，考虑以上我们小小语言的规则。它直接对应于一个这样的 `infer` 函数：

$
  & "infer" : "Expr" -> "Type" \
  & "infer"(e) = #[`match`] e #[`where`] \
  & wide "true" | "false" & |-> & "Bool" \
  & wide 0 | 1 | -1 | 2 | ... & |-> & "Int" \
  & wide e_1 + e_2 & |-> & #[`assert`] "infer"(e_1) = "Int"; \
  &                &     & #[`assert`] "infer"(e_2) = "Int"; \
  &                &     & "Int" \
  & wide e_1 < e_2 & |-> & #[`assert`] "infer"(e_1) = "Int"; \
  &                &     & #[`assert`] "infer"(e_2) = "Int"; \
  &                &     & "Bool" \
  & wide #[`if`] e_1 #[`then`] e_2 #[`else`] e_3 & |-> & #[`assert`] "infer"(e_1) = "Bool"; \
  &                                              &     & #[`let`] tau = "infer"(e_2); \
  &                                              &     & #[`assert`] "infer"(e_3) = tau; \
  &                                              &     & tau
$

即使无法将类型规则直接转换为类型检查算法，在对逻辑判断进行推理时考虑信息流仍然非常有用：对于判断 $tack e : tau$，$e$ 可以被视为判断的“输入”，而 $tau$ 可以被视为“输出”。这种严格的方向性并不总适用于类型系统中的每条规则，但通常它适用于多数规则，并且是理解规则含义的一种有效方法。

#colbreak()

== 变量和语境

目前为止，我们用作例子的语言异常地简单。此前我一直在有意规避#term[变量 (variable)] 这一复杂性，但如果我们要为任何有用的程序设计语言编写类型规则，那么我们就不能逃避。所以接下来让我们扩展我们的小小语言，向其中加入函数，使其成为#link("https://en.wikipedia.org/wiki/Simply_typed_lambda_calculus")[#term[简单类型 $lambda$ 演算 (Simply-typed lambda calculus, STLC)]] 的一个变体。这需要向语言的文法中添加如下内容：

#let tdt = $thin . thin$

$
  e ::= ... \
      | & x & wide & "变量" \
      | & lambda x : tau tdt e & wide & "函数抽象" \
      | & e med e & wide & "函数应用"
  \
  tau ::= ... \
        | & tau -> tau & wide & "函数类型"
$

这里 $x$ 代表“某个变量”。如果你不熟悉 $lambda$ 演算，这些符号可能看起来有点怪，但它其实没有看上去那么陌生：简单类型 $lambda$ 演算中的语法 $lambda x : tau tdt e$ 直接对应于 TypeScript 中的 `(x : τ) => e`，而 $f med x$ 则对应于 `f(x)`。

在扩充文法之后，#term[类型关系]所用的符号不需要改变——仍然形如 $e : tau$。但是，#term[类型判断]的结构必须相应地进行扩展。我们会在为变量编写类型规则时遇到麻烦：

$
  \
  () / (tack x : "???")
$

问题在于，变量的类型取决于它出现时所处的#term[语境 (context)]。因此，我们需要扩展类型判断，来追踪作用域内所有变量的类型，我们用使用以下符号：

$
  Gamma tack e : tau
$

$Gamma$ 被称为“语境”或者“类型环境”，而 $tack$ 所扮演的角色现在更明确了：它把#term[语境假设 (contextual assumptions)] 从待证陈述里分离了出去。因此，扩展后的判断可以读作“在语境 $Gamma$ 中，表达式 $e$ 具有类型 $tau$”，而在算法上，$Gamma$ 可以被视为判断的一个额外的“输入”，具有类型 `Map<Variable, Type>`。然而，正式地说，任何类型规则都必须被语法性地定义。类型规则中的语境可以显式地定义为如下的语法结构：

#let wideemptyset = text(features: ("cv01",), $nothing$)

$
  Gamma ::= & wideemptyset & wide & "空语境" \
          | & Gamma, x : tau & wide & "变量绑定"
$

有时，空语境会使用符号 $circle.filled.small$ 而不是 $wideemptyset$。

在这种表示方法下，语境本质上是一个#link("https://en.wikipedia.org/wiki/Association_list")[#term[关联列表 (association list)]]，它将变量名映射到其类型。

大部分类型规则都无需关心语境：大部分推理规则只是简单地传递语境，不作任何更改；而大部分公理也同样无视语境。例如，以下是几条根据我们新的判断调整的类型规则：

$
  () / (Gamma tack "true" : "Bool") wide
  (Gamma tack e_1 : "Int" \
   Gamma tack e_2 : "Int")
  /
  (Gamma tack e_1 + e_2 : "Int")
$

然而，语境对于两种新增结构——变量使用和 $lambda$ 表达式——的类型规则是必须的：

$
  (x : tau in Gamma) / (Gamma tack x : tau) wide
  (Gamma, x : tau_1 tack e : tau_2) / (Gamma tack (lambda x : tau_1 tdt e) : tau_1 -> tau_2)
$

右边的那条规则是最复杂的，因为它包含了所有关键的机制：在对 $lambda$ 表达式的 #term[函数体 (body)] 进行类型检查时，语境会被扩展，新的绑定 $x : tau_1$ 会被引入。之后在检查表达式 $e$ 的过程中，这一信息会被左边的规则使用，这条规则实质上是说，若当前语境中存在*变量绑定* $x$，其类型为 $tau$（因此 $x$ 在作用域内），则*表达式* $x$ 具有类型 $tau$。换句话说，语境是这两条规则之间用来传递信息的一种通信机制。

（细心的读者可能会注意到，这一模型无法处理变量遮蔽。这是因为以这种方式指定的类型系统通常假定所有变量都已被解析并唯一。）

如果你仍然感到困惑，不妨考虑一下这些新增内容对我们之前提到的 $"infer"$ 函数的影响：

$
  & "infer" : ("Context", "Expr") -> "Type" \
  & "infer"(Gamma, e) = #[`match`] e #[`where`] \
  & wide x & |-> & "lookup"(Gamma, x) \
  & wide lambda x : tau_1 tdt e' & |-> & #[`let`] Gamma' = "extend"(Gamma, x, tau_1); \
  &                              &     & #[`let`] tau_2 = "infer"(Gamma', e'); \
  &                              &     & tau_1 -> tau_2
$

接下来我们还要添加一条函数应用的类型规则：

$
  (& Gamma tack e_1 : tau_1 -> tau_2 \
   & Gamma tack e_2 : tau_1)
   /
   (Gamma tack e_1 med e_2 : tau_2)
$

== 其他常见符号和注意事项

目前为止，本答案已经描述了绝大多数用于描述类型系统的符号，但对符号的修改和扩展极其常见。要涵盖所有修改和扩展是不可能的，但幸运的是，优秀的论文通常会先解释它们引入的任何非标准符号。然而，有些约定俗成的惯例十分普遍，以至于人们常常不加解释就使用它们，本节会尝试提供一个基本概述，并描述一些符号上的怪癖。

这不是一个详尽的列表，也永远不可能是。如果你发现此处未涵盖某些符号，请另行提问！

=== 推理规则的布局

目前为止，本答案中所有的例子都以非常规整的垂直方式列出了推理规则。然而，“一个条件一行”并不是某种强制性的要求，多个条件可以并排出现在同一行上：

$
  (Gamma tack e_1 : "Int" wide Gamma tack e_2 : "Int")
  /
  (Gamma tack e_1 + e_2 : "Int")
$

在同一条规则中，垂直排列和水平排列甚至可能同时出现。

=== 附加条件

通常，推理规则横线上面出现的条件必须是能通过公理和推理规则的某种组合来满足的判断。然而，事情并不总是如此：规则中也可能包含任意的布尔表达式，我们称之为#term[附加条件 (side conditions)]，只有所有附加条件都满足，才能应用推理规则。例如在我们的类型规则中，$x : tau in Gamma$ 就是一个附加条件。

#term[算法性 (algorithmic)] 的类型系统中有时会出现一种特殊的附加条件：$alpha #[`fresh`]$ 或者 $"fresh"(alpha)$。这表示 $alpha$ 是一个全新的类型变量，也就是它和既存的所有类型变量都不同。

=== 子类型

#term[子类型 (subtyping)] 引入了一种比严格相等性更弱的类型一致性概念。子类型关系必须被显式定义，通常记作 $tau_1 <: tau_2$ 或者 $tau_1 prec.eq tau_2$，可以读作“$tau_1$ 是 $tau_2$ 的子类型”。

子类型关系通常也使用推理规则的形式来定义。例如，一个非常简单的子类型关系可能引入两个特殊的类型，$top$（读作“#term[顶 / top]”）和 $bot$（读作“#term[底 / bottom]”）。$top$ 是所有类型的#term[超类型 (supertype)]，而 $bot$ 是所有类型的#term[子类型 (subtype)]。这一关系可以用以下三条简单公理表示：

$
  \
  () / (tau <: tau) wide
  () / (tau <: top) wide
  () / (bot <: tau)
$

第一条规则是#term[自反性 (reflexive)] 规则，通常简写为“refl”，它声明每个类型都是自身的子类型。这条规则确保了子类型关系严格弱于全等关系。

然后，在所有允许子类型的规则中，都必须显式地使用如上定义的子类型关系。例如，支持子类型的系统可以用以下规则来实现函数应用：

$
  (& Gamma tack e_1 : tau_2 -> tau_3 \
   & Gamma tack e_2 : tau_1 \
   & tau_1 <: tau_2
   )
  /
  (Gamma tack e_1 med e_2 : tau_3)
$

=== 多语境

有些类型系统所定义的类型判断涉及到多个语境。第二个语境通常被命名为 $Delta$。常用于表示多语境的符号是 $Gamma; Delta tack e : tau$（当两个语境都是“输入”时）和 $Gamma tack e : tau tack.l Delta$（当 $Delta$ 是“输出”时）。

第二个语境可能有多种不同的用途。例如，某些变量可能在某些表达式中被引用，而其他表达式则不行；又或者，输出语境可在#term[资源感知型 (resource-aware)] 程序设计语言中被用于跟踪哪些变量被“消耗”了。

=== 双向类型检查

#let tin = $#math.op(sym.colon, limits: false)_arrow.b$
#let tout = $#math.op(sym.colon, limits: false)_arrow.t$

#link("https://arxiv.org/abs/1908.05839")[#term[双向类型检查 (Bidirectional typechecking)]] 是一种不依赖约束求解器的、有限的非局部类型推理技术。一个双向系统将通常的类型判断 $Gamma tack e : tau$ 分为两个特化的判断：
- $Gamma tack e arrow.l.double tau$（或作 $Gamma tack e arrow.b tau$，$Gamma tack e tin tau$）是#term[检查 (checking)] 判断，它检查表达式 $e$ 是否具有期望的类型 $tau$。算法上，$tau$ 是判断的输入。
- $Gamma tack e arrow.r.double tau$（或作 $Gamma tack e arrow.t tau$，$Gamma tack e tout tau$） 是#term[推导 (inference)] 判断，在“不知道期望类型是什么”的时候使用。算法上，$tau$ 是判断的输出。

两个判断以互递归的方式定义，双向传播类型信息，因此允许在某些时候省略类型注解。例如，$lambda$ 抽象的类型规则的检查变体允许省略变量绑定上的类型注解，因为变量的类型可以根据期望的类型确定：

$
  (Gamma, x : tau_1 tack e arrow.l.double tau_2)
  /
  (Gamma tack (lambda x tdt e) arrow.l.double tau_1 -> tau_2)
$
