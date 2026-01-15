#align(center)[= 五种容易混淆的符号]

#linebreak()

这五种符号分别是：
- 箭头 (arrow) $->$
  - KaTeX: `\rightarrow`
  - Typst: `->`
- 十字转门 (turnstile，常用于相继式 sequent) $tack$
  - KaTeX: `\vdash`
  - Typst: `tack`
- 魔法横线 (推理线 inference bar，好玩的横杠，魔法平衡木) $(Gamma, A tack B) / (Gamma tack A -> B)$
  - KaTeX: `\frac{...}{...}`，_你用 bussproofs 一类的包效果会更好_
  - Typst: `(...) / (...)`，_你用 Proof Trees 一类的包效果会更好_
- 竖线箭头 $|->$
  - KaTeX: `\mapsto`
  - Typst: `|->`
- 长双箭头 $==>$
  - KaTeX: `\Longrightarrow`
  - Typst: `==>`

== 蕴含

箭头 $->$、十字转门 $tack$ 和推理横线（inference line）都在某种程度上表达了“蕴含”或“推导”的关系。但它们分属三个不同的层级：
- 箭头 $->$ 描述的是*对象语言*（object language）——即我们当前正在研究的语言（如 $lambda$-calculus）——中的词项。例如，$A -> B$ 可以表示“一个接受 A，输出 B 的函数”（在 $lambda$-calculus 中），或者“命题：若 A 成立，则 B 成立”（在命题逻辑中）。
- 十字转门 $tack$ 描述的是*判断*（judgment），位于*元语言*（meta language）。例如，$Gamma tack A$ 是在说，“从环境 $Gamma$ 可以推导出 $A$”。$Gamma, A tack B$ 就是在作出如下判断：“在环境 $Gamma$ 中，若我们添加假设 $A$，则可以得到 $B$”。
- 魔法横线描述的则是*判断之规则* (rule of judgement)，是*元语言的元语言*。例如，$(Gamma, med A tack B) / (Gamma tack A -> B)$ 是在说，“如果‘在环境 $Gamma$ 中，若我们添加假设 $A$，则可以得到 $B$’，那么‘从环境 $Gamma$ 中可以推导出 $A -> B$’。”

== 小坑

在命题逻辑里，有时候你会看到这两种东西：

$
  (A -> B wide A) / B wide "versus" wide A -> B, A tack B
$

然后你可能会想，“这不是一个意思吗？这两种符号难道不可以混用吗？”

不行的。判断就像是一道数学题的答案，而推理规则就像是解题的方法。你不能把"答案"和"方法"混为一谈。又比如说，判断就像是菜，推理规则就像是菜谱，照着菜谱可以做菜，甚至做出来的菜能跟菜谱上的照片一模一样，但是你不能直接啃菜谱（除非你是啮齿类）。

更进一步地，左边的这一条可以更加严格地写成：

$
  (Gamma tack A -> B wide Gamma tack A) / (Gamma tack B)
$

这样就清楚多了。

在命题逻辑这个阶段，$Gamma$ 这个东西（管自由变量的）在开头阶段用的比较少，加上大家发明了 $Gamma tack$ 以外“替代方案”（见下文）来表示“引入假设则可得出……”，引起了这种混淆。

== 其他的“引入假设”的写法

$
  ([A] #linebreak() dots.v #linebreak() B) / (A -> B) "根岑的记号"

  wide

  (#box(stroke: 1pt, outset: 0.4em, inset: 0.2em)[$display(A #linebreak() dots.v #linebreak() B)$] #linebreak() #linebreak()) / (A -> B) "Huth & Ryan 的记号"
$

_丑死了，还是十字转门好看，还不浪费垂直空间。_

== 竖线箭头

这个可以用于符号对象语言中“一切看起来像 $->$ 但又不是的东西”，常见的两种用法是：
- 集合映射 (maps to)：对象语言中*元素层面*的映射，例如函数定义 $x |-> x + 1$。类型 $#[`int`] -> #[`int`]$ 指的是“这个函数接受一个整数，返回一个整数”，而 $x |-> x + 1$ 指的是“这个函数把输入*值* $x$ 映射为输出*值* $x + 1$”。
- 环境绑定 (environment binding)：例如在替换中，变量 $x$ 被映射为值 $v$，记作 $x |-> v$。

如果你见到的用法跟这不一样，翻作者的术语表。如果术语表里没有，你可以辱骂作者。

== 长双箭头

*如果没有另外定义*，这是一个非正式符号，描述粗略的“蕴含”/“可推导出”/“综上所述”/“规约可得”，可以在说明性文本里用一下，最好别放进公式块。*如果作者有另外的定义，按作者的定义来。*如果作者没定义就乱用，你可以辱骂作者。

#align(center)[= 下课。]
