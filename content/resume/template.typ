#let zh-fonts = ("Noto Serif", "Noto Serif SC", "Noto Serif CJK SC")

#let project(name: "", contacts: (), body) = {
  set page(numbering: "1", number-align: center)
  set text(lang: "en", font: "Libertinus Serif")
  set text(lang: "zh", font: zh-fonts)
  show raw: set text(lang: "zh", size: 11pt)

  set par(spacing: 0.9em)

  set par(leading: 0.58em)

  align(center)[
    #block(text(weight: 700, 1.65em, name))
  ]

  align(center, pad(
    top: 0.3em,
    bottom: 0.3em,
    x: 2em,
    grid(
      columns: (1fr,) * calc.min(4, contacts.len()),
      gutter: 1em,
      ..contacts.map(contact => {
        let target = contact.at("link", default: "none")
        if (target == "none") {
          align(center)[
            *#contact.type* \
            #contact.value
          ]
        }
        else {
          align(center)[
            *#contact.type* \
            #link(target, text(blue, contact.value))
          ]
        }
      }),
    ),
  ))

  // Main body.
  set par(justify: true)
  body
}