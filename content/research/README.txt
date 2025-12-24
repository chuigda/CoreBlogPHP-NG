The lambda-pi.typ uses a modified version of codly 1.3.0 to generate

modification:

      if collection != none and (i + len >= hl.end or last) {
        if tag == none {
          let content = box(
            radius: highlight-radius,
            clip: highlight-clip,
            fill: fill,
            stroke: stroke,
            - inset: highlight-inset,
            + // inset: highlight-inset,
            outset: highlight-outset,
            - baseline: highlight-baseline,
            + // baseline: highlight-baseline,
            collection.join() + label,
          )