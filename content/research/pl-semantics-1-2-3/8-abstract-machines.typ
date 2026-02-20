#import "../template.typ": term

= 抽象机

目前为止，我们的所有例子都侧重于解释语义学概念。而本节将展示如何利用整数和加法的语言来帮助发现语义概念。本节将展示如何将这一语言用作基础，发现如何实现抽象机 #link("(Landin, 1964)")，从而以明确定义的求值顺序对表达式求值。回顾第 3 节中的简单求值函数：

```haskell
eval :: Expr -> Integer
eval (Val n)   = n
eval (Add x y) = eval x + eval y
```

如前所述，定义并未指定 `Add x y` 中两个参数的求值顺序——求值顺序是元语言 Haskell 的实现决定的。若有必要，可以构建一个用于求值表达式的抽象机来明确求值顺序。

形式化地说，抽象机通常由一组语法重写规则定义，这些规则明确地描述了求值过程中的每一步。在 Haskell 中，可以在适当的数据结构上定义一组一阶尾递归函数来实现抽象机。本节将展示两个重要的语义概念——续延和去函数化，并展示如何使用基于这两个概念的两步过程，从求值函数系统地推导出抽象机。这一方法由 Danvy 及其合作者率先提出 #link("(Ager 等, 2003a)")。

== 第一步 -- 添加续延

为表达式语言构建抽象机的第一步，就是在语义中明确求值顺序。实现此目标的标准技术是将语义重写为#term[续延传递风格 (continuation passing style, CPS)] #link("(Reynolds, 1972)")。在我们的框架下，续延是将被应用于求值结果的函数。例如，根据表达式的语义，有等式：

$
  #[`eval (Add x y)`] = #[`eval x`] + #[`eval y`]
$

当第一个递归调用 `eval x` 被求值时，等式中右边剩下的部分 $+ #[`eval y`]$ 可被视为这一求值的续延，也就是说它是一个函数，将会被应用于 `eval x` 的结果。

更形式化地说，对于语义 `eval :: Expr -> Integer`，续延是一个类型为 `Integer -> Integer` 的函数，它会被应用于某步求值所得的整数，并返回一个新的整数。这一类型可进一步泛化为 `Integer -> a`，不过此处暂且不需要这种通用性。以下类型声明表达了这种续延的概念：

```haskell
type Cont = Integer -> Integer
```

接下来要定义新的语义函数 `eval'`，它比 `eval` 多接受一个 `Cont` 类型的参数，这个参数（续延）会被应用于表达式求值的结果。也就是说，函数具有如下类型：

```haskell
eval' :: Expr -> Cont -> Integer
```

而 `eval'` 应有的行为可由以下等式描述：

#let p-eval1 = $[P"-"#[`eval'`]]$

$
  #[`eval'`] e med c wide =  wide c med (#[`eval`] e) quad #(p-eval1)
$

也就是说，将 `eval'` 应用于一个表达式和一个续延，相当于将 `eval` 应用于表达式，得到表达式的#term[值]，再对该#term[值]应用续延。

在大多数演示中，此时会给出 `eval'` 的递归定义，并由此证明上述等式。然而，我们也可以将上述等式视作函数 `eval'` 的一个规范，并在此基础上寻找或者演算出一个满足该规范的定义。需要注意的是，上述规范存在多种可能的解，因为原始语义并未指定求值顺序。下文将展示一种可能的解，但其他解也同样存在。

要求解 `eval'` 的定义，我们从规范 #p-eval1 出发，对表达式 $e$ 应用结构归纳法。在每个情况下，我们都从词项 $#[`eval'`] e med c$ 出发，逐步应用等式推理，将其变换为一个不引用原始语义函数 `eval` 的词项 $t$，这样我们就可以将 $#[`eval`] e med c = t$ 作为 `eval'` 在该情况下的一个定义性等式。对于基准情况 $e = #[`Val n`]$，演算只须两步：

$
  & #[`eval' (Val n)`] c \
  & = quad { "规范" #(p-eval1) } \
  & c med (#[`eval (Val n)`]) \
  & = quad { "展开" #[`eval`] "的定义" } \
  & c med #[`n`]
$

如是我们便发现了 `eval'` 在基准情况下的如下定义：

$
  #[`eval' (Val n)`] c quad = quad c med #[`n`]
$

也就是说，若表达式是一个#term[值]，则简单地将续延应用于这个#term[值]。对于归纳情况 $e = #[`Add x y`]$，我们也以同样的方式着手：

$
  & #[`eval' (Add x y)`] c \
  & = quad { "规范" #(p-eval1) } \
  & c med (#[`eval (Add x y)`]) \
  & = quad { "展开" #[`eval`] "的定义" } \
  & c med (#[`eval x`] + #[`eval y`])
$

此时无法进一步应用定义。不过，因为我们是在进行归纳演算，所以我们还有参数表达式 `x` 和 `y` 的归纳假设可用：对于任意续延 $c', c''$，有 $#[`eval' x`] med c' = c' med (#[`eval x`])$ 和 #linebreak() $#[`eval' y`] med c'' = c'' med (#[`eval y`])$。要运用这些假设，我们须重写词项中的某些部分，使其形如 $c' med (#[`eval x`])$ 和 $c'' med (#[`eval y`])$。这可以通过用 $lambda$ 表达式对 `eval x` 和 `eval y` 抽象来实现。有了这些想法，余下的演算便势如破竹：

$
  & c med (#[`eval x`] + #[`eval y`]) \
  & = quad { "对" #[`eval x`] "抽象" } \
  & (lambda n -> c med (n + #[`eval y`])) #[`eval x`] \
  & = quad { "应用" #[`x`] "的归纳假设" } \
  & #[`eval' x`] (lambda n -> c med (n + #[`eval y`])) \
  & = quad { "对" #[`eval y`] "抽象" } \
  & #[`eval' x`] (lambda n -> (lambda m -> c med (n + m)) med (#[`eval y`])) \
  & = quad { "应用" #[`y`] "的归纳假设" } \
  & #[`eval' x`] (lambda n -> #[`eval' y`] (lambda m -> c med (n + m)))
$

最后所得的词项确是我们需要的形式——其中不包含 `eval`。如是我们便发现了 `eval'` 在归纳情况下的如下定义：

$
  #[`eval' (Add x y)`] med c quad = quad #[`eval' x`] (lambda n -> #[`eval' y`] (lambda m -> c med (n + m)))
$

#colbreak()

也就是说，若表达式形如 `Add x y`，则先求值其第一个参数 `x`，记其值为 $n$，再求值其第二个参数 `y`，记其值为 $m$，最后将续延 $c$ 应用于 $n$ 和 $m$ 的和。如此，语义中求值的顺序便明确了。综上所述，我们演算得到了如下定义：

```haskell
eval' :: Expr -> Cont -> Integer
eval' (Val n) c   = c n
eval' (Add x y) c = eval' x (λn -> eval' y (λm -> c (n + m)))
```

最后，若将恒等续延 $lambda n -> n$ 替换规范 #p-eval1 中的续延 $c$，便可从我们的新语义中还原出原本的语义。也就是说，原本的语义函数 `eval` 现可定义为：

```haskell
eval :: Expr -> Integer
eval e = eval' e (λn -> n)
```

== 第二步 -- 去函数化

在明确求值顺序后，我们距离抽象机更近了；但语义现在变成了一个接受续延作为参数的高阶函数，这却使我们离抽象机更远了。因此第二步正是要尽除续延以恢复原本语义的一阶性，同时保持续延所引入的明确求值顺序。

去函数化 #link("(Reynolds, 1972)") 是消除高阶函数参数的标准技术。这一技术基于以下观察：我们不需要支持任意的高阶函数参数，因为被用作实参的高阶函数只有寥寥几个。因此，我们可以用纯数据类型代替函数类型，来表示我们实际所需的高阶函数参数。

函数 `eval` 和 `eval'` 的定义实际上只用到了三种续延：$lambda n -> n$ 用于结束求值过程；#linebreak() $lambda n -> #[`eval y'`] ...$ 用于在加法的第一个参数求值完毕时继续求值过程；而 $lambda m -> c med (n + m)$ 用于将两个整数相加。我们先定义三个组合子 `halt`、`next` 和 `add`，用于构造这三种形式的续延：

```haskell
-- type Cont = Integer -> Integer

halt :: Cont
halt = λn -> n

next :: Expr -> Cont -> Cont
next y c = λn -> eval' y (add n c)

add :: Integer -> Cont -> Cont
add n c = λm -> c (n + m)
```
