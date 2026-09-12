#import "@preview/iconify:0.5.3": icon, provide-icons

// ============================================================
// Resume template
// ============================================================

#let _left-pane-width = 45%
#let _left-pane-color = rgb("#B5CDC4")
#let _left-pane-title-color = rgb("#8EB2A4")
#let _left-pane-title-text-color = rgb("3D432F")

#let _left-pane-text-color = rgb("#746D40")
#let _right-pane-text-color = rgb("#222222")
#let _activity-title-text-color = rgb("#746D40")
#let _activity-subtitle-text-color = black
#let _activity-extra-text-color = black


#let saut-de-page = context {
  let pos = here().position()
  let total-height = page.height
  block(height: total-height - pos.y - 40pt)
}

// ============================================================
// Persistent page background
// ============================================================

#let _transparent-image(img, opacity) = context {
  let size = measure(img)
  stack(
    img,
    move(
      dy: -1000pt,
      box(
        width: 100%,
        height: 100%,
        fill: white.transparentize(opacity),
      ),
    ),
  )
}
#let _right-pane-background = context {
  // The page dimensions are available through `page`.
  let width = page.width
  let height = page.height

  rect(
    width: width * 2,
    height: height * 2,
    stroke: none,
    _transparent-image(image(width: width * 2, height : height * 2, "../assets/background-right-pane.jpg"), 20%),
  )

  place(
    top + left,
    rect(
      width: width * _left-pane-width,
      height: height,
      stroke: none,
      move(dx: -20pt, dy: -20pt, image("../assets/background-left-pane.jpg", fit: "stretch", height: 150%, width: 113%)),
    ),
  )
  place(
    top + left,
    rect(
      width: width * _left-pane-width,
      height: height,
      stroke: none,
      move(dx: -20pt, dy: -20pt, image(
        "../assets/background-left-pane-overlay.png",
        fit: "stretch",
        height: 150%,
        width: 111%,
      )),
    ),
  )
  // Sidebar background
}


#let _common-pane-heading(content) = {
  v(8pt)
  line(
    length: 90%,
    stroke: 2pt + black,
  )
  v(-4pt)
  align(center)[#text(weight: "bold", size: 10pt, fill: white)[
    #set text(
      font: "Book Antiqua",
      size: 14pt,
      fill: _left-pane-title-text-color,
    )
    #upper(content)
  ]]
  v(-12pt)
  line(
    length: 90%,
    stroke: 1pt + _left-pane-color,
  )
  v(8pt)
}
#let _left-pane-heading(spacing, content) = {
  v(-10pt + spacing)
  box(width: 110%, fill: _left-pane-title-color)[
    #_common-pane-heading(content)
  ]
  v(-14pt)
}
#let _right-pane-heading(spacing, content) = {
  v(spacing)
  box(width: 110%)[
    #_common-pane-heading(content)
  ]
  v(-14pt)
}

#let _presentation-separator = [
  // TOP
  #place(center, [#move(dx: -15%, [
      #line(length: 30%, stroke: 0.5pt + white, angle: -0.4deg)
    ])
  ])
  #place(center, [#move(dx: 15%, dy: -1.6pt, [
      #line(length: 30%, stroke: 0.5pt + white, angle: 0.4deg)
    ])
  ])

  // MID
  #place(center, [#move(dx: -15%, [
      #line(length: 30%, stroke: 0.5pt + white, angle: 0deg)
    ])
  ])
  #place(center, [#move(dx: 15%, [
      #line(length: 30%, stroke: 0.5pt + white, angle: 0deg)
    ])
  ])

  // BOTTOM
  #place(center, [#move(dx: -15%, [
      #line(length: 30%, stroke: 0.5pt + white, angle: 0.4deg)
    ])
  ])
  #place(center, [#move(dx: 15%, dy: 1.6pt, [
      #line(length: 30%, stroke: 0.5pt + white, angle: -0.4deg)
    ])
  ])

  #line(stroke: white.transparentize(100%))
]

#let presentation(
  prenom: none,
  nom: none,
  competences: none,
  prenom-espacement: 0pt,
  nom-espacement: 0pt,
  fin-espacement: 0pt,
) = {
  block(inset: (left: 10pt, right: 10pt))[
    #set text(fill: rgb("#3D432F"))

    #v(0.8cm)
    #text(font: "WalbaumDisplay", tracking: prenom-espacement, size: 28pt, fill: rgb("#5B6446"), upper(prenom))
    #v(-24pt)
    #text(font: "WalbaumDisplay", tracking: nom-espacement, size: 28pt, fill: rgb("#3D432F"), upper(nom))
    #v(-10pt)
    #text(
      font: "Book Antiqua",
      size: 13pt,
      strong([
        #competences.join([
          #v(1pt)
          #_presentation-separator
          #v(1pt)
        ])
      ]),
    )
    #v(fin-espacement)
  ]
}

#let contact(courriel: none, telephone: none, adresse: none) = {
  provide-icons(
    json("../assets/mdi-light.json"),
  )

  let elements = ()

  if courriel != none {
    elements.push(icon("mdi-light:email"))
    elements.push(courriel)
  }

  if telephone != none {
    elements.push(icon("mdi-light:phone"))
    elements.push(telephone)
  }

  if adresse != none {
    elements.push(icon("mdi-light:home"))
    elements.push(adresse)
  }

  align(left + horizon, table(
    columns: 2,
    column-gutter: 2pt,
    stroke: none,
    ..elements,
  ))
}

#let activite(
  content,
  date: none,
  lieu: none,
  extra: none,
  hide: false,
  fin-espacement: 0pt,
) = {
  if hide { return }

  align(left, [
    #set text(
      font: "Book Antiqua",
      size: 12pt,
      fill: _activity-title-text-color,
    )

    #content
    #box(width: 1fr)
    #if date != none {
      date
    }
    #move(dy: -12pt, line(length: 100%, stroke: 0.3pt))

    #if lieu != none {
      v(-18pt)
      text(fill: _activity-subtitle-text-color, emph(lieu))
    }

    #if extra != none {
      if lieu == none { v(-12pt) }
      text(
        size: 11pt,
        fill: _activity-extra-text-color,
        extra,
      )
    }
    #v(fin-espacement)
  ])
}

#let bloc-blanc(content) = {
  move(
    dx: -14%,
    block(
      width: 130%,
      inset: (left: 24pt, right: 12pt, top: 12pt, bottom: 12pt),
      fill: white,
      content,
    ),
  )
  v(-10pt)
}

#let cv(
  panneau-gauche-espacemement: 0pt,
  panneau-gauche: none,
  panneau-droit-espacemement: 0pt,
  panneau-droit: none,
) = context {
  set page(
    "us-letter",
    margin: 0pt,
    background: _right-pane-background,
  )

  let narrow-space = sym.space.nobreak.narrow
  show regex("\\s*\\:"): [#narrow-space:]
  show regex("\\s*\\;"): [#narrow-space;;]
  show regex("\\s*\\?"): [#narrow-space?]
  show regex("\\s*\\!"): [#narrow-space!]

  grid(
    columns: (
      _left-pane-width,
      1fr,
    ),

    // --------------------------------------------------------
    // Sidebar
    // --------------------------------------------------------

    block(
      inset: (
        top: 0cm,
        bottom: 1.2cm,
        left: 0cm,
        right: 0cm,
      ),
      align(center)[
        #show heading: content => {
          _left-pane-heading(panneau-gauche-espacemement, content)
        }
        #block(
          inset: (left: 24pt, right: 24pt),
          text(
            font: "Book Antiqua",
            size: 14pt,
            fill: _left-pane-text-color,
            panneau-gauche,
          ),
        )
      ],
    ),

    // --------------------------------------------------------
    // Main content
    // --------------------------------------------------------

    block(
      inset: (
        top: 1.2cm,
        bottom: 1.2cm,
        left: 1.0cm,
        right: 1.2cm,
      ),
      align(left)[
        #show heading: content => {
          _right-pane-heading(panneau-droit-espacemement, content)
        }
        #block(
          inset: (left: 12pt, right: 12pt), 
          panneau-droit
        )
      ],
    ),
  )
}

