#import "../template.typ": term

= 大步语义

#let evalto = math.arrow.b.double

小步语义关注每个执行步骤，而#term[大步操作语义 (big-step operational semantics)] 则规定了如何在一大步中完全地执行词项。形式化地说，对于由语法项构成的语言 $T$，其大步语义或称“自然语义” #link("(Kahn, 1987)") 由两部分组成：一个#term[值]集 $V$，以及一个 $T$ 与 $V$ 之间的#term[求值关系 (evaluation relation)]，该关系将每个词项与其完全求值后所得到的#term[值]关联起来。若词项 $t$ 与#term[值] $v$ 处于该关系中，则称 $t$ 可求值为 $v$，记作 $t evalto v$。

算术表达式有一个非常简单的大步操作语义：设#term[值]集 $V$ 为 Haskell 的整数类型 `Integer`，并按以下两条推理规则定义 `Expr` 和 `Integer` 之间的求值关系：

$
  ()
  /
  (#[`Val n`] evalto #[`n`]) quad [E"-Val"]
  wide
  (#[`x`] evalto #[`n`] wide #[`y`] evalto #[`m`])
  /
  (#[`Add x y`] evalto #[`n`] + #[`m`]) quad [E"-Add"]
$

就这个简单的表达式语言而言，大步语义看似与第 3 节所讲论的指称语义如出一辙，不过是把等式换成了推理规则。然而，组合性是指称语义的关键性质，而大步语义不必是组合性的，当讨论更复杂的语言时，这一区分就会变得尤为明显。例如，Bahr 和 Hutton 的 $lambda$ 演算编译器 #link("Bahr Hutton 2015")[(2015)] 就基于一个大步形式的非组合性语义。

我们可以将表达式语言的指称语义和大步语义之间的等价性形式化地写作：

$
  [| e |] = n quad <=> quad e evalto n
$

也就是说，若表达式可求值为某个整数值，则这个值就是该表达式的指称。要证明这一性质，我们分别讨论两个方向。要证明 $[| e |] = n #h(0.5em) => #h(0.5em) e evalto n$，首先用假设 $n = [| e |]$ 替换结论 $e evalto n$ 中的 $n$，得到 $e evalto [| e |]$，这一性质可通过对表达式 $e$ 运用结构归纳法证明。对于基准情况 $e = #[`Val n`]$，有：

$
  & #[`Val n`] evalto [| #[`Val n`] |] \
  & <=> quad { "规则" [V"-Val"] } \
  & #[`Val n`] evalto #[`n`] \
  & <=> quad { "规则" [E"-Val"] } \
  & "Reflexivity"
$

而对于归纳情况 $e = #[`Add x y`]$，可作如下推理：

#let qaq = $quad and quad$

$
  & #[`Add x y`] evalto [| #[`Add x y`] |] \
  & <=> quad { "规则" [V"-Add"] } \
  & #[`Add x y`] evalto [| #[`x`] |] + [| #[`y`] |] \
  & <=> quad { "规则" [E"-Add"] } \
  & #[`x`] evalto [| #[`x`] |] qaq #[`y`] evalto [| #[`y`] |] \
  & <=> quad { "应用归纳假设" } \
  & "Tautology"
$

#let dt = $. thin$

而对于另一方向 $e evalto n #h(0.5em) => #h(0.5em) [| e |] = n$，我们可以先用第 5 节引入的简写形式，将其写作 #linebreak() $forall e evalto n dt [| e |] = n$，这一性质可通过对表达式的大步语义运用规则归纳法证明：

$
  & forall e evalto n dt [| e |] = n \
  & <=> quad { "定义" P(e, n) <=> [| e |] = n } \
  & forall e evalto n dt P(e, n) \
  & <=> quad { "对" evalto "作规则归纳" } \
  & P(#[`Val n`], #[`n`]) qaq forall x evalto #[`n`], y evalto #[`m`] dt P(x, #[`n`]) and P(y, #[`m`]) => P(#[`Add`] x med y, #[`n`] + #[`m`]) \
  & <=> quad { "展开" P "的定义" } \
  & [| #[`Val n`] |] = #[`n`] qaq forall x evalto #[`n`], y evalto #[`m`] dt [| x |] = #[`n`] and [| y |] = #[`m`] => [| #[`Add`] x med y |] = #[`n`] + #[`m`]
$

最后的两个条件都可以简单地应用规则 $[V"-Val"]$ 和 $[V"-Add"]$ 来验证。

*延伸阅读* #h(1em) 当我们只关注执行的最终结果而不关心执行的具体细节时，大步语义很有用。在本文中，我们主要关注指称性和操作性的语义学方法，但还有很多其他的语义学方法，包括#term[公理 (axiomatic)] 语义 #link("Hoare 1969")[(Hoare, 1969)]、#term[代数 (algebraic)] 语义 #link("Goguen Malcolm 1996")[(Goguen & Malcolm, 1996)]、#term[模块化 (modular)] 语义 #link("Mosses 2004")[(Mosses, 2004)]、#term[动作 (action)] 语义 #link("Mosses 2005")[(Mosses, 2005)] 和#term[游戏 (game)] 语义 #link("(Abramsky & McCusker, 1999)")。
