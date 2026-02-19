#import "../template.typ": term

= 大步语义

小步语义关注每个执行步骤，而#term[大步操作语义 (big-step operational semantics)] 则规定了如何在一大步中完全地执行词项。形式化地说，对于对于由语法项构成的语言 $T$，其大步语义或称“自然语义” #link("Kahn 1987")[(Kahn 1987)] 由两部分组成：一个#term[值]集 $V$