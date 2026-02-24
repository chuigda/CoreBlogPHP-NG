#import "../template.typ": term

= 抽象机

目前为止，我们的所有例子都侧重于解释语义学概念。而本节将展示如何利用整数和加法的语言来帮助发现语义概念：将这一语言用作基础，发现如何实现抽象机 #link("(Landin, 1964)")，从而以明确定义的求值顺序对表达式求值。回顾第 3 节中的简单求值函数：

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
  #[`eval'`] e med c quad = quad c med (#[`eval`] e) wide #(p-eval1)
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

每种续延中的自由变量都变成了组合子的参数。使用以上定义，续延语义现可重写为：

```haskell
eval :: Expr -> Integer
eval e = eval' e halt

eval' :: Expr -> Cont -> Integer
eval' (Val n)   c = c n
eval' (Add x y) c = eval' x (next y c)
```

下一步便是定义一种一阶数据类型，其构造子对应于三种组合子：

```haskell
data CONT where
  HALT :: CONT
  NEXT :: Expr -> CONT -> CONT
  ADD  :: Integer -> CONT -> CONT
```

注意到 `CONT` 的构造子和三种 `Cont` 组合子具有相同的名称和类型，只是现在名字换成了大写。而以下函数为数据类型 `CONT` 定义了一个指称语义，形式化地阐述了 `CONT` 类型的值如何用于表示 `Cont` 类型的续延：

```haskell
exec :: CONT -> Cont
exec HALT       = halt
exec (NEXT y c) = next y (exec c)
exec (ADD n c)  = add n (exec c)
```

在文献中这一函数常被称作 `apply` #link("(Reynolds, 1972)")：若将 `exec` 的类型展开成 #linebreak() `CONT -> Integer -> Integer`，则这一函数可被视作将续延应用于一个整数，以得到另一个整数。而本文选用 `exec` 的缘由稍后便会揭晓。

下一步就是定义一个新的语义 `eval''`，它和 `eval'` 的行为一致，但使用 `CONT` 类型的值，而不是 `Cont` 类型的续延：

```haskell
eval'' :: Expr -> CONT -> Integer
```

而 `eval'` 的行为可由以下等式描述：

#let p-eval2 = $[P"-"#[`eval''`]]$

$
  #[`eval''`] e med c quad = quad #[`eval'`] e med #[`(exec`] c #[`)`] wide #(p-eval2)
$

也就是说，将 `eval''` 应用于一个表达式 $e$ 和一个以 `CONT` 表示的续延 $c$，所得的结果应与将 `eval'` 应用于该表达式和续延 $#[`exec`] c$ 的结果相同。

和之前一样，我们对表达式 $e$ 作结构归纳来得到 `eval''` 的定义。基准情况 $e = #[`Val n`]$ 的处理简单直接：

$
  & #[`eval'' (Val n)`] c \
  & = quad { "规范" #(p-eval2) } \
  & #[`eval' (Val n) (exec`] c #[`)`] \
  & = quad { #[`eval'`] "的定义" } \
  & #[`exec`] c med #[`n`]
$

而归纳情况 $e = #[`Add x y`]$ 中则须展开 `exec` 的定义，从而允许应用归纳假设：

$
  & #[`eval'' (Add x y)`] med c \
  & = quad { "规范" #(p-eval2) } \
  & #[`eval' (Add x y) (exec`] c #[`)`] \
  & = quad { #[`eval'`] "的定义" } \
  & #[`eval' x (next y (exec `] c #[`))`] \
  & = quad { #[`exec`] "的定义" } \
  & #[`eval' x (exec (NEXT y `] c #[`))`] \
  & = { "应用" #[`x`] "的归纳假设" } \
  & #[`eval'' x (NEXT y`] c #[`)`]
$

然而，`exec` 的定义中有组合子 `next`，而 `next` 的定义中仍然包含 `eval'`。我们可以对 `CONT` 参数作分类讨论（无须归纳），为 `exec` 演算出一个使用 `eval''`（而非 `eval'`）的定义：

$
  & #[`exec HALT`] n \
  & = quad { #[`exec`] "的定义" } \
  & #[`halt`] n \
  & = quad { #[`halt`] "的定义" } \
  & n
  \ \ \
  & #[`exec (NEXT y c)`] n \
  & = quad { #[`exec`] "的定义" } \
  & #[`next y (exec c)`] n \
  & = quad { #[`next`] "的定义" } \
  & #[`eval' y (add`] n #[`(exec c))`] \
  & = quad { #[`exec`] "的定义" } \
  & #[`eval' y (exec (ADD`] n #[`c))`] \
  & = quad { "规范" #(p-eval2) } \
  & #[`eval'' y (ADD`] n #[`c)`]
  \ \ \
  & #[`exec (ADD n c)`] m \
  & = quad { #[`exec`] "的定义" } \
  & #[`add n (exec c)`] m \
  & = quad { #[`add`] "的定义" } \
  & #[`exec c (n + `]m #[`)`]
$

最后，原本的语义 `eval` 可由新语义 `eval''` 经如下演算还原：

$
  & #[`eval`] e \
  & = quad { #[`eval`] "的旧定义" } \
  & #[`eval'`] e (lambda n -> n) \
  & = quad { #[`halt`] "的定义" } \
  & #[`eval'`] e #h(0.5em) #[`halt`] \
  & = quad { #[`exec`] "的定义" } \
  & #[`eval'`] e #[`(exec HALT)`] \
  & = quad { "规范" #(p-eval2) } \
  & #[`eval''`] e #h(0.5em) #[`HALT`]
$

总结即得如下新定义：

```haskell
eval :: Expr -> Integer
eval e = eval'' e HALT

eval'' :: Expr -> CONT -> Integer
eval'' (Val n)   c = exec c n
eval'' (Add x y) c = eval'' x (NEXT y c)

exec :: CONT -> Integer -> Integer
exec HALT       n = n
exec (NEXT y c) n = eval'' y (ADD n c)
exec (ADD n c)  m = exec c (n + m)
```

这三个定义和 `CONT` 类型一共构成了一个用于求值表达式的抽象机。这四个组件可分别理解为：

- `CONT` 是#term[控制栈 (control stack)] 的类型，控制栈中的指令决定抽象机在求值当前表达式后应如何继续。因此，这种抽象机有时也被称为#term[“求值/继续”机 ("eval/continue" machine)]。控制栈的类型也可重构为一系列指令：

  ```haskell
  type CONT = [INST]
  data INST = ADD Integer | NEXT Expr
  ```

  不过本文仍使用 `CONT` 原本的定义，因为它是以系统的方式得出的，并且只需要声明一种类型。
- `eval` 以给定的表达式和空控制栈 `HALT` 调用 `eval''`，将表达式求值为整数。
- `eval''` 以一个控制栈 `c` 为语境，对表达式求值。若表达式是整数值，则以该整数为参数#term[执行 (execute)] 控制栈。若表达式是一个加法，则首先求值其第一个参数 `x`，并将指令 `NEXT y` 置于控制栈顶，表示当 `x` 求值完毕时应求值第二个参数 `y`。
- `exec` 以一个整数参数 `n` 为语境，#term[执行]控制栈 。若控制栈为空，由指令 `HALT` 表示，则将整数参数作为#term[执行]的结果返回；若栈顶是指令 `NEXT y`，则求值表达式 `y` 并将 `ADD n` 置于栈顶，表示当 `y` 求值完毕时，应将当前整数 `n` 与之相加；最后，若栈顶是指令 `ADD n`，这表明加法的两个参数的求值均已完成，则将两数之和作为语境，#term[执行]余下的控制栈。

注意 `eval''` 和 `exec` 是互递归的，对应于抽象机的两种模式：抽象机的行动取决于表达式结构还是控制栈。例如，对表达式 $1 + 2$：

```haskell
  eval (Add (Val 1) (Val 2))
= eval'' (Add (Val 1) (Val 2)) HALT
= eval'' (Val 1) (NEXT (Val 2) HALT)
= exec (NEXT (Val 2) HALT) 1
= eval'' (Val 2) (ADD 1 HALT)
= exec (ADD 1 HALT) 2
= exec HALT 3
= 3
```

总而言之，我们展示了如何演算出一个用于求值算术表达式的抽象机，所有实现机制都自然而然地从实现中涌现了出来。我们无须事先了解任何实现思路，因为这些思路是在演算过程中被系统地发现的。

最后我们补充一点：抽象机所用的控制栈和第 6 节语境语义中的语境具有相似的形式。若将控制栈写成普通的代数数据类型：

```haskell
data CONT = HALT | NEXT Expr CONT | ADD Integer CONT
```

并以与第 6 节末尾相同的风格写出指定从左到右求值顺序的求值语境类型：

```haskell
data Con = Hole | AddL Con Expr | AddR Integer Con
```

注意到这两个类型是同构的，也就是说其值之间存在一一对应关系。这一同构表明了求值语境即是去函数化的续延，这并不仅限于此例，而是揭示了一种深层次的语义联系。下文引用的多篇文章对此进行了深入探讨。

*延伸阅读* #h(1em) Reynolds 的开创性论文 #link("(1972)") 引入了三项关键技术：#term[定义性解释器 (definitional interpreter)]、续延传递风格和去函数化。Danvy 和他的合作者后来揭示出 Reynolds 的论文实际上包含了从求值器推导出抽象机的蓝图 #link("(Ager 等, 2003a)")，并继续就相关主题发表了一系列有影响力的论文，包括从求值器推导出编译器 #link("(Ager 等, 2003b)")、从小步语义推导出抽象机 #link("(Danvy & Nielsen, 2004)") 以及去函数化的对偶性 #link("(Danvy & Millikin, 2009)")；更多参考文献可在 Danvy 的特邀论文 #link("(2008)") 中找到。#link("McBride (2008)") 利用数据类型剖析的思想，开发了一种将使用 `fold` 算子表示的指称语义转换为等价抽象机的通用方法。

本节基于 #link("(Hutton & Wright, 2006; Hutton & Bahr, 2016)")，这些文献也展示了如何演算出扩展后的表达式语言的抽象机，以及如何将两步转换融合成一步。类似的技术可用于为栈机 #link("(Bahr & Hutton, 2015)")、寄存器机 #link("(Hutton & Bahr, 2017; Bahr & Hutton, 2020)")、类型化语言 #link("(Pickard & Hutton, 2021)"), 非终止语言 #link("(Bahr & Hutton, 2022)") 和并发语言 #link("(Bahr & Hutton, 2023)") 演算编译器。
