#linebreak() 注意：本文为早期草稿，内容不完且有措误，且#text(tracking: -0.2em)[排版]质量差。

Note: this is an early draft. It's known to be incomplet and incorrekt, and it has lots of b#text(tracking: -0.15em)[ad] fo#text(tracking: -0.15em)[rm]atting.

// #linebreak() *Notations*

// $
//   tau & : && "types" \
//   alpha, alpha', alpha_1, alpha_2 & : && "ἄτομος types" \
//   e, e', e_1, e_2 & : && "expressions" \
//   xi, xi_1, xi_2 & : && "totality" \
//   tau_underline(xi), underline(xi) & : && "totality" xi "is relevant" \
//   tau, tau_xi, xi & : && "totality" xi "is irrelevant"
// $

#linebreak() *Informal semantics*

#let nbot = math.cancel(math.bot)

$
  nbot & "means" && "total" \
  bot = "False" & "means" &&  "partial / impure" \
  tau_xi = chevron.l tau, xi chevron.r & "means" && "type" tau "with totality" xi
$

*Normalisation*

$
  () / (nbot + nbot --> nbot) wide () / (bot + bot --> bot) wide () / (nbot + bot --> bot) wide () / (bot + nbot --> bot)

$

*Typing*

$
  \
  \

  (Gamma, x : tau_nbot tack e : tau'_nbot)
  /
  (Gamma tack lambda x. med e : tau_nbot -> tau'_nbot) & wide "define total function"

  \
  \

  (Gamma, x : tau_nbot tack e : tau'_xi)
  /
  (Gamma tack lambda_bot x. med e : tau_nbot -> tau'_bot) & wide "define partial function"

  \
  \

  (Gamma tack e : (tau_nbot -> tau'_underline(xi 1))_underline(xi f) wide Gamma tack e' : tau_underline(xi 2))
  /
  (Gamma tack e med e' : tau'_underline(xi f + xi 1 + xi 2)) & wide "application"

  \
  \

  (Gamma tack e : ((tau_nbot -> tau'_(xi r))_nbot -> tau''_underline(xi 1))_underline(xi_f)
   Gamma tack e' : (tau_nbot -> tau'_(xi r'))_underline(xi_2) \
   xi_r' prec.eq xi_r
  )
  /
  (Gamma tack e med e' : tau''_underline(xi_f + xi_1 + xi_2)) & wide "high order application\n(first order only)"

  \
  \

  (Gamma tack e : tau_underline(xi 1) wide Gamma tack e' : tau'_underline(xi 2))
  /
  (Gamma tack e ";" e' : tau'_underline(xi 1 + xi 2)) & wide "sequential composition"

  \
  \

  (Gamma tack v : tau_underline(xi))
  /
  (Gamma tack "box" v : ("ref" tau_nbot)_xi) & wide "create reference"

  \
  \

  (Gamma tack r : ("ref" tau_nbot)_xi)
  /
  (Gamma tack "read" r : tau_bot)

  wide

  (Gamma tack r : ("ref" tau_nbot)_(xi 1) wide Gamma tack v : tau_(xi 2))
  /
  (Gamma tack "write" r med v : "unit"_bot)

  & wide "mutable references"
$
