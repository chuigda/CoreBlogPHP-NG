#import "template.typ": *

#show: project.with(
  title: "程序语言语义学：数数手指一二三",
  author-cols: 3,
  authors: (
    (name: "Graham Hutton", contrib: "原作者", affiliation: "诺丁汉大学"),
    (name: "Chuigda Whitegive", contrib: "翻译", affiliation: "第七通用设计局"),
    (name: "CAIMEO", contrib: "翻译提议、校对", affiliation: ""),
  )
)

#align(center, pad(
  top: -2em,
  x: 4em,
  grid(
    align: center,
    columns: (1fr,) * 2,
    gutter: 1em,
    [
      *Gemini* \
      校对 \
      Google Deepmind
    ],
    [
      *Claude* \
      校对 \
      Anthropic
    ]
  ),
))

#show link: set text(fill: rgb(0, 127, 255))
#show math.equation.where(block: true): set block(breakable: false)
#show raw.where(block: true): set block(breakable: false)
#show raw.where(block: true): set pad(left: 2em)
#set par(spacing: 1.2em)

= 摘要

#term[程序语言语义学 (programming language semantics)] 是计算机科学理论领域的重要话题之一，但新手却常常在入门时面临挑战。本文正是一篇程序语言语义学的入门教程，将整数和加法语言作为一个最小化的框架，以简明的方式呈现一系列语义概念。在这个框架下，一切就像数数手指一二三一样简单。

#set heading(numbering: "1.")

= 介绍

#term[语义学 (semantics)] 是