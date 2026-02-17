#import "../template.typ": term

= 规则归纳法

指称语义中的基本证明技巧是大家所熟悉的结构归纳法：通过考察词项的语法结构来给出证明。而操作语义中的基本证明技巧是规则归纳法 #link("Winskel 1993")[(Winskel, 1993)]，它不那么声名远扬但却同样实用，它通过考察语义规则的结构来进行证明。

我们先用一个简单的数值例子引入规则归纳法的概念，然后展示如何利用规则归纳法简化上一节中的语义证明。我们用以下两条规则归纳定义一个偶自然数集合 $EE$：

$
  () / (0 in EE) thin [EE"-Base"] wide wide
  (n in EE) / (n + 2 in EE) thin [EE"-Ind"]
$

第一条规则——也就是基础情况——声明 $0$ 在集合 $EE$ 中。第二条规则——也就是归纳情况——声明对于 $EE$ 中的任何数 $n$，数字 $n + 2$ 的结果也在 $EE$ 中。该定义的归纳性质意味着集合 $EE$ 中除了通过有限次应用这两条规则所能得到的数字之外，没有任何其他东西，这有时被称为该定义的#term[极值子句 (extremal clause)]。

对于归纳定义的集合 $EE$，规则归纳法的原则就是：要证明某项性质 $P$ 对 $EE$ 中所有元素成立，只需要先证明基础情况，也就是 $P$ 对于 $0$ 成立；然后再证明归纳情况，也就是若 $P$ 对任意元素 $n in EE$ #linebreak() 成立，则 $P$ 对 $n + 2$ 也成立。这样一来，我们就有了如下证明规则：

#let dt = $. thin$
#let qaq = $quad and quad$

$
  (P(0) wide forall n in EE dt P(n) => P(n + 2))
  /
  (forall n in EE dt P(n))
$

我们可以用规则归纳法来验证偶数集 $EE$ 对加法的封闭性，即两偶数之和仍是偶数：

$
  forall n in EE dt n + n in EE
$

注意到，这一性质不能用自然数上的数学归纳法来证明，因为该性质仅对偶数成立，而非对任意自然数成立。要证明这一点，首先我们要定义性质 $P$，然后应用规则归纳法，最后再展开 $P$ 的定义，得到两个条件：

$
  & forall n in EE dt n + n in E \
  & <=> quad { "define" P(n) <=> n + n in EE } \
  & forall n in EE dt P(n) \
  & <=> quad { "规则归纳法" } \
  & P(0) qaq forall n in EE dt P(n) => P(n + 2) \
  & <=> quad { "definition of" P } \
  & 0 + 0 in EE qaq forall n in EE dt n + n in EE => (n + 2) + (n + 2) in EE
$

第一个条件可以被化简为 $0 in EE$，由规则 $EE"-Base"$，它显然成立。第二个条件可以被重排成 #linebreak() $((n + n) + 2) + 2 in EE$，这个条件可以从归纳假设 $n + n in EE$ 出发，应用两次 $EE"-Ind"$ 得到。
