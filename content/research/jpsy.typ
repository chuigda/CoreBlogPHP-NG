#let brand-green = rgb("#0099447F")

#let logo-cell(content, bg-color, text-color) = {
  rect(
    width: 100%,
    height: 100%,
    fill: bg-color,
    stroke: none,
    align(center + horizon, text(
      font: "Noto Serif CJK SC",
      weight: 500,
      size: 36pt, // 字体大小
      fill: text-color,
      content,
      stroke: none
    ))
  )
}

#align(right)[
  #box(
    width: 3cm,
    height: 3cm,
    stroke: 2pt + brand-green, // 外边框
  )[
    #grid(
      columns: (1fr, 1fr),
      rows: (1fr, 1fr),
      gutter: 0pt,

      logo-cell("精", white, brand-green),
      logo-cell("神", brand-green, white),
      logo-cell("药", brand-green, white),
      logo-cell("品", white, brand-green),
    )
  ]
]