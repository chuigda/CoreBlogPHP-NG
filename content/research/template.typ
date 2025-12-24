// The project function defines how your document looks.
// It takes your content and some metadata and formats it.
// Go ahead and customize it to your liking!
#let zh-fonts = ("New Computer Modern", "Noto Serif", "Noto Serif SC", "Noto Serif CJK SC")

#let project(title: "", authors: (), body) = {
  // Set the document's basic properties.
  set document(author: authors.map(a => a.name), title: title)
  set page(numbering: "1", number-align: center)
  set text(lang: "en", font: ("New Computer Modern", "Libertinus Serif"))
  set text(lang: "zh", font: zh-fonts)

  // Set paragraph spacing.
  set par(spacing: 0.9em)
  set par(leading: 0.58em)
  show raw: text.with(font: "New Computer Modern Mono", size: 11pt, ligatures: false, features: (liga: 0,  dlig: 0, clig: 0, calt: 0))
  show math.equation: text.with(font: ("New Computer Modern"))

  // Title row.
  align(center)[
    #block(text(weight: 700, 1.65em, title))
  ]

  // Author information.
  align(center, pad(
    top: 2em,
    bottom: 2em,
    x: 4em,
    grid(
      align: center,
      columns: (1fr,) * calc.min(3, authors.len()),
      gutter: 1em,
      ..authors.map(author => [
        *#author.name* \
        #author.contrib \
        #author.affiliation
      ]),
    ),
  ))

  // Main body.
  set par(justify: true)
  show: columns.with(1)

  body
}

#let defn(content) = par(first-line-indent: 1.5em, hanging-indent: 1.5em)[#content]
#let term = text.with(font: ("New Computer Modern", "Zhuque Fangsong (technical preview)"), style: "italic")
#let rs = text.with(font: "New Computer Modern Mono", size: 9pt, lang: "hs")
