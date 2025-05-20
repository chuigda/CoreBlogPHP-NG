// The project function defines how your document looks.
// It takes your content and some metadata and formats it.
// Go ahead and customize it to your liking!
#let zh-fonts = ("Noto Serif", "Noto Serif SC", "Noto Serif CJK SC")

#let project(title: "", authors: (), body) = {
  // Set the document's basic properties.
  set document(author: authors.map(a => a.name), title: title)
  set page(numbering: "1", number-align: center)
  set text(lang: "en", font: "Libertinus Serif")
  set text(lang: "zh", font: zh-fonts)

  // Set paragraph spacing.
  set par(spacing: 0.9em)
  set par(leading: 0.58em)

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
        #author.contrib
      ]),
    ),
  ))

  // Main body.
  set par(justify: true)
  show: columns.with(1)

  body
}

#let defn(content) = par(first-line-indent: 1.5em, hanging-indent: 1.5em)[#content]
