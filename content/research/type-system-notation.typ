#import "template.typ": *

#show: project.with(
  title: "如何阅读类型系统记号",
  authors: (
    (name: "Alexis King", contrib: "原作者", affiliation: ""),
    (name: "Chuigda Whitegive", contrib: "翻译", affiliation: "第七通用设计局"),
    (name: "Gemini", contrib: "校对", affiliation: "Google Deepmind")
  )
)

#show link: set text(fill: rgb(0, 127, 255))
#show math.equation.where(block: true): set block(breakable: false)
#show raw.where(block: true): set block(breakable: false)
#show raw.where(block: true): set pad(left: 2em)
#set par(spacing: 1.2em)

注意：本文为早期草稿，内容不完且有措误，且#text(tracking: -0.2em)[排版]质量差。

Note: this is an early draft. It's known to be incomplet and incorrekt, and it has lots of b#text(tracking: -0.15em)[ad] fo#text(tracking: -0.15em)[rm]atting.

本文是对 StackExchange 提问及回答 #link("https://langdev.stackexchange.com/a/2693")[How should I read type system notation] 的翻译。

= 前言

用于描述类型系统的符号因不同的表示方法而异，因此不可能给出全面的概述。不过，大多数表示方法之间都有许多共通之处，本回答会尝试提供足够的基础知识，以便理解常见的各种变体。

= 语法和文法

应用于程序设计语言的类型系统是#term[语法性 (syntactic)] 的系统，也就是说，类型系统是作用于程序设计语言的（抽象）语法上的一系列规则。因此，对类型系统的全面论述首先会使用#link("https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_form")[#term[巴科斯-瑙尔表示法 (Backus Naur Form, BNF)]] 提供类型系统所考虑的所有语法构造的#link("https://en.wikipedia.org/wiki/Formal_grammar")[#term[文法 (grammar)]]。在最简单的类型化语言中，语法仅用于两件事：表达式和类型。

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

这里，$e$ 对应于表达式，而 $tau$ 对应于类型，这是标准的记号约定。有的表示方法会为类型选用不同的符号，如 $t$, $T$, $sigma$ 或者其他小写希腊字母，但总体结构大致相同。

更复杂的语言自然会有更复杂的文法：命令式语言需要#term[语句 (statement)] 的文法，支持模式匹配的语言需要模式的文法，诸如此类。而我们上面的简单语言里甚至连变量都没有！然而，在文法上区分#term[词项 (term, 具有类型的东西)] 和类型是必要的，因为类型系统正是要定义词项和类型间的关系。

#colbreak()

= 关系，判断，公理和推理规则

指定文法之后，下一步就是定义#term[类型关系 (typing relation)]。类型关系通常写作 $e : tau$，可以读作“$e$ 的类型是 $tau$”。直觉上，我们能够理解，一些陈述是“有意义”的，另一些则没有：

- $1 + 2 : "Int"$ 表示“$1 + 2$ 的类型是 Int”，这当然是有意义的。
- $1 + 2 : "Bool"$ 表示“$1 + 2$ 的类型是 Bool”，而这是没有意义的。
- $"true" + 2 : "Int"$ 表示“$"true" + 2$ 的类型是 Int”，这更没有意义，因为 $"true" + 2$ 本来就是无稽之谈，根本不应该有类型。

我们应该系一些能准确捕捉我们“哪些陈述有意义，哪些没有”直觉的规则。为此，我们定义#term[类型判断 (typing judgement)]，写作：

$
  tack e : tau
$

这里，$tack$ 可以读作“以下陈述是正确的”。这里的 $tack$ 可能显得有点多余，并且在简单的类型系统（比如现在我们讨论的这个）当中也确实可以省略，但它接下来会发挥更重要的作用。

用这种记号，我们就可以为我们的类型系统写一些#term[类型规则 (typing rule)]了：

$
  \
  () / (tack "true" : "Bool") wide
  () / (tack "false" : "Bool")
$

这两条规则上面都有一条横线，而横线上空无一物，这表示它们恒为真，也就是说它们是#term[公理 (axiom)]。对于整数字面量，我们也可以有无数这样的公理：

$
  \
  () / (0 : "Int") wide
  () / (1 : "Int") wide
  () / (-1 : "Int") wide
  () / (2 : "Int") wide
  …
$

当然，字面量的类型规则相当无聊。但当表达式里包含子表达式的时候，事情就变得有意思了！以下是 $+$ 和 $<$ 的类型规则：

$
  (tack e_1 : "Int" \
   tack e_2 : "Int")
  /
  (e_1 + e_2 : "Int")
  wide
  (tack e_1 : "Int" \
   tack e_2 : "Int")
  /
  (e_1 < e_2 : "Bool")
$

现在，横线上下都有东西了，它们就成为了#term[推理规则 (inference rule)]。它们表示有条件的类型规则：*如果*横线上的所有陈述为真，*则*横线下面的陈述为真。例如，第一条规则可以读作“如果 $e_1 : "Int"$ 为真且 $e_2 : "Int"$ 为真，则 $e_1 + e_2: "Int"$ 为真”，希望这符合直觉。

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
  (tack e_1 : "Bool" \
   tack e_2 : tau \
   tack e_3 : tau)
  /
  (tack #[`if`] e_1 #[`then`] e_2 #[`else`] e_3 : tau)
$

应用这条规则时，我们可以为 $tau$ 选取任何类型，只要它在两个分支之间保持一致就行。

这种记号起源于#term[形式逻辑 (formal logic)]，特别地，用于类型系统的记号风格上与#link("https://en.wikipedia.org/wiki/Natural_deduction")[#term[自然演绎 (natural deduction)]] 最为接近。虽然我不会在本答案中详细介绍符号的具体细节，但以这种形式表达的规则可以被用来构建关于系统属性的形式化证明，这对于证明#link("https://en.wikipedia.org/wiki/Type_safety")[#term[类型健全性 (type soundness)]] 之类的属性非常重要。

= 作为算法规范的判断

到目前为止，我一直在刻意避免谈及类型判断的计算解释。一般而言，判断只是逻辑规则，而某些以这种方式指定的类型系统并不直接对应于#term[可判定的 (decidable)] 类型检查算法。然而，如果你不习惯思考证明系统，这种视角可能会非常难以理解。

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
  &                                              & |-> & #[`let`] tau = "infer"(e_2); \
  &                                              & |-> & #[`assert`] "infer"(e_3) = tau; \
  &                                              & |-> & tau
$

即使无法将类型规则直接转换为类型检查算法，在对逻辑判断进行推理时考虑信息流仍然非常有用：对于判断 $tack e : tau$，$e$ 可以被视为判断的“输入”，而 $tau$ 可以被视为“输出”。这种严格的方向性并并不总适用于类型系统中的每条规则，但通常它适用于多数规则，并且是理解规则含义的一种有效方法。

#colbreak()

= 变量、语境和环境

目前为止，我们用作例子的语言异常地简单。目前为止，我都在有意规避#term[变量 (variable)] 这一复杂性，但如果我们要为任何有用的程序设计语言编写类型规则，那么我们就不能逃避。所以接下来让我们扩展我们的小小语言，向其中加入函数，使其成为#link("https://en.wikipedia.org/wiki/Simply_typed_lambda_calculus")[#term[简单类型 $lambda$ 演算 (Simply-typed lambdada calculus, STLC)]] 的一个变体。这需要向语言的文法中添加如下内容：

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

在扩充文法之后，#term[类型关系]所用的记号不需要改变——仍然形如 $e : tau$。但是，#term[类型判断]的结构必须相应地进行扩展。我们会在为变量编写类型规则时遇到麻烦：

$
  \
  () / (tack x : "???")
$

问题在于，变量的类型取决于它出现时所处的#term[语境 (context)]。因此，我们需要扩展类型判断，来追踪作用域内所有变量的类型，我们用使用以下记号：

$
  Gamma tack e : tau
$

$Gamma$ 被称为“语境”或者“类型环境”，而 $tack$ 所扮演的角色现在更明确了：它把#term[语境假设 (contextual assumptions)] 从待证陈述里分离了出去。因此，扩展后的判断可以读作“在语境 $Gamma$ 中，表达式 $e$ 具有类型 $tau$”，而在算法上，$Gamma$ 可以被视为判断的一个额外的“输入”，具有类型 `Map<Varaible, Type>`。然而，正式地说，任何类型规则都必须被语法性地定义。类型规则中的语境可以显式地定义为如下的语法结构：

#let wideemptyset = text(features: ("cv01",), $nothing$)

$
  Gamma ::= & wideemptyset & wide & "空语境" \
          | & Gamma, x : tau & wide & "变量绑定"
$

有时空语境会使用符号 $circle.filled$ 而不是 $wideemptyset$。

在这种表示方法下，语境本质上是一个#link("https://en.wikipedia.org/wiki/Association_list")[#term[关联列表 (association list)]]，它将变量名映射到其类型。

大部分类型规则都无需关心语境：大部分推理规则只是简单地传递语境，不作任何更改；而大部分公理也同样无视语境。例如，以下是几条根据我们新的判断调整的类型规则：

$
  () / (Gamma tack "true" : "Bool") wide
  (tack e_1 : "Int" \
   tack e_2 : "Int")
  /
  (e_1 + e_2 : "Int")
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
