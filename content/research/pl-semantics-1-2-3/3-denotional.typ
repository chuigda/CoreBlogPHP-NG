#import "../template.typ": term

= 指称语义

在文章的第一部分，我们展示了如何使用我们简单的表达式语言，来解释和比较多种不同的为语言赋予语义的方法。在本节中，我们将探讨语义学的指称方法 #link("https://people.cs.nott.ac.uk/pszgmh/123.pdf#cite.strachey")[(Scott 和 Strachey, 1971)]——使用#term[值化函数 (valuation function)] 将语言中的#term[词项 (term)] 映射到适当的#term[语义域 (semantic domain)] 中的#term[值 (value)] 来定义词项的#term[意义]。

形式化地说，对于由#term[语法项 (syntactic term)] 构成的语言 $T$，其指称语义由两部分组成：一个#term[语义值 (semantic value)] 集合 $V$，以及一个类型为 $T -> V$ 的值化函数，该函数将词项映射到以#term[值]表示的#term[意义]。值化函数通常写作 $[| t |]$——将词项用#term[语义括号 (semantic bracket)] 括起来，表示对词项 $t$ 应用值化函数的结果。语义括号也被称作牛津括号或斯特雷奇括号，以纪念克里斯托弗·斯特雷奇在指称方法上的开创性工作。

值化函数必须是#term[组合性的 (compositional)]：复合词项的#term[意义]完全由其子项的#term[意义]决定。组合性确保了语义的模块化，因而有助于理解，同时也支持了使用简单的等式推理来证明语义的性质。当语义值集合明确时，指称语义常被视同于其值化函数。

类型 `Expr` 的算术表达式有一个非常简单的指称语义：设语义域 $V$ 为 Haskell 的整数类型 `Integer`，并按以下两个等式，定义类型为 `Expr -> Integer` 的值化函数：

$
  & [| #[`Val n`] |] & = & n && wide ["V-Val"] \
  & [| #[`Add x y`] |] & = & [| #[`x`] |] + [| #[`y`] |] && wide ["V-Add"]
$

等式 $["V-Val"]$ 声明整数的#term[值]就是该整数自身，而等式 $["V-Add"]$ 声明一个加法表达式的#term[值]是其两个子表达式的#term[值]相加。这一定义显然满足组合性要求，因为复合表达式 `Add x y` 的#term[意义]完全是由将运算符 $+$ 应用于两个子表达式 `x` 和 `y` 各自的#term[意义]定义的。

#colbreak()

组合性简化了推理过程，因为它允许#term[等价代换 (replace equals by equals)]。例如，我们的表达式语义满足以下特性：

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
eval :: Expr -> Integer
eval (Val n)   = n
eval (Add x y) = eval x + eval y
```

更一般地说，指称语义可以被视为一个由函数式语言编写的#term[求值器 (evaluator)] 或解释器。例如，使用上述定义，我们有 $`#[`eval (Add (Val 1) (Add (Val 2) (Val 3)))`] = 1 + (2 + 3) = 6$，或者可以这样画成图：

_(译者不会用 Typst 画图，暂时对照原论文看吧)_

在这个例子中我们注意到表达式的求值方式：将每个 `Add` #term[构造子 (constructor)] 替换为整数加法函数 `+`，并移除 `Val` 构造子——或者说，将每个 `Val` 替换成整数上的恒等函数 `id`。这也就是说，尽管函数 `eval` 是递归定义的，因为语义是组合性的，其行为可以被理解为简单地用其他函数替换表达式中的构造子。用这种方式，指称语义也可以被视为一个通过“#term[折叠 (fold)]”源语言的语法来定义的求值函数：

```haskell
eval :: Expr -> Integer
eval = fold id (+)
```

`fold` 算子 (#link("https://people.cs.nott.ac.uk/pszgmh/123.pdf#cite.bananas")[Meijer et al., 1991]) 体现了用其他函数替换语言中构造子的思想。这里，构造子 `Val` 和 `Add` 分别被函数 $f$ 和 $g$ 替换：

```haskell
fold :: (Integer -> a) -> (a -> a -> a) -> Expr -> a
fold f g (Val n) = f n
fold f g (Add x y) = g (fold f g x) (fold f g y)
```

注意由 `fold` 定义的语义在定义上就是组合性的，因为表达式 `Add x y` 的折叠结果完全是将给定的函数 `g` 应用于两个参数表达式 `x` 和 `y` 的折叠结果来定义的。

本节最后我们补充两点。首先，如果我们把文法 $E ::= ZZ | E + E$ 而不是类型 `Expr` 定义为源语言，那么指称语义写出来就是这样：

$
  & [| n |] & = & n \
  & [| x + y |] & = & [| x |] + [| y |]
$

在这个版本中，同一个符号 $+$ 现在被用于两个不同的用途：在左边，它是一个#term[语法性 (syntactic)] 的构造子，用来构造词项；而在右边，它是一个#term[语义算子 (semantic operator)]，用来计算整数加法。我们选择类型 `Expr` 作为源语言，它提供了专用于构造表达式的构造子 `Val` 和 `Add`，使得语法和语义之间泾渭分明。

其次，注意到，上述语义并未指定求值顺序——也就是说，我们并未指定加法的两个参数应以何种顺序求值。在这个例子中，求值顺序对最后得到的值没有影响。若要显式指定求值顺序，就要向语义中引入额外的结构，我们将在第 8 节讨论抽象机时探讨这一点。

*延伸阅读* #h(1em) 关于指称语义的标准参考文献是 #link("dummy")[Schmidt (1986)]，而 #link("dummy")[Winskel (1993)] 的形式语义教科书则对该方法进行了简明扼要的介绍。为 $lambda$ 演算赋予指称语义的问题，特别是递归定义函数和类型所引出的技术问题，促成了域论的发展 #link("dummy")[(Abramsky & Jung, 1994)]。

#link("dummy")[Hutton (1998)] 进一步探讨了使用折叠算子定义指称语义的思想。简单的整数和加法语言也被用作研究一系列其他语言特性的基础，包括异常 #link("dummy")[(Hutton & Wright, 2004)]、中断 #link("dummy")[(Hutton & Wright, 2007)]、事务 #link("dummy")[(Hu & Hutton, 2009)]、非确定性 #link("dummy")[(Hu & Hutton, 2010)] 和状态 #link("dummy")[(Bahr & Hutton, 2015)]。
