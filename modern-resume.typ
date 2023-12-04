#import "icons.typ": icon, linkIcon

#let colors = (
  primary: rgb("#313C4E"),
  secondary: rgb("#222A33"),
  accentColor: rgb("#449399"),
  textPrimary: black,
  textSecondary: rgb("#7C7C7C"),
  textTertiary: white,
)
#let pageMargin = 16pt
#let textSize = (
  Large: 24pt,
  large: 14pt,
  normal: 11pt,
  small: 9pt,
)

#let infoItem(iconName, msg) = {
  text(colors.textTertiary, [#icon(iconName, baseline: 0.25em) #msg])
}

#let circularAvatarImage(imagepath) = {
  block(
    radius: 50%,
    clip: true,
    stroke: 4pt + colors.accentColor
  )[
    #image(imagepath, width: 2cm)
  ]
}

#let headline(name, title, bio, imagepath: "") = {
  grid(
    columns: (1fr, auto),
    align(bottom)[
      #text(colors.textTertiary, name, size: textSize.Large)\
      #text(colors.accentColor, title)\
      #text(colors.textTertiary, bio)
    ],
    if imagepath != "" {
      circularAvatarImage(imagepath)
    }
  )
}

#let contactDetails(contactOptionsDict) = {
  if contactOptionsDict.len() == 0 {
    return
  }
  let contactOptionKeyToIconMap = (
    linkedin: "linkedin",
    email: "envelope",
    github: "github",
    mobile: "mobile",
    location: "location-dot",
    website: "globe",
  )

  // Evenly distribute the contact options among two columns.
  let contactOptionDictPairs = contactOptionsDict.pairs()
  let midIndex = calc.ceil(contactOptionsDict.len() / 2)
  let firstColumnContactOptionsDictPairs = contactOptionDictPairs.slice(0, midIndex)
  let secondColumnContactOptionsDictPairs = contactOptionDictPairs.slice(midIndex)

  let renderContactOptions(contactOptionDictPairs) = [
    #for (key, value) in contactOptionDictPairs [
        #infoItem(contactOptionKeyToIconMap.at(key), value)\
      ]
  ]

  grid(
    columns: (.5fr, .5fr),
    renderContactOptions(firstColumnContactOptionsDictPairs),
    renderContactOptions(secondColumnContactOptionsDictPairs),
  )
}

#let headerRibbon(color, content) = {
  block(
    width: 100%,
    fill: color,
    inset: (
      left: pageMargin,
      right: 8pt,
      top: 8pt,
      bottom: 8pt,
    ),
    content
  )
}

#let header(data) = {
  grid(
    columns: 1,
    rows: (auto, auto),
    headerRibbon(
      colors.primary,
      headline(data.name, data.jobTitle, data.at("bio", default: ""), imagepath: data.at("avatarImagePath", default: ""))
    ),
    headerRibbon(
      colors.secondary,
      contactDetails(data.at("contactOptions", default: ()))
    )
  )
}

#let pill(msg, fill: false) = {
  let content
  if fill {
    content = rect(
      fill: colors.primary.desaturate(1%),
      radius: 15%)[
        #text(colors.textTertiary)[#msg]
      ]
  } else {
    content = rect(
      stroke: 1pt + colors.textSecondary.desaturate(1%),
      radius: 15%)[#msg]
  }
  [
    #box(content)~
  ]
}

#let experience(
  title: "",
  subtitle: "",
  facilityDescription: "",
  taskDescription: "",
  dateFrom: "Present",
  dateTo: "Present",
  taskDescriptionLabel: "Courses") = [
  #text(size: textSize.large)[*#title*]\
  #subtitle\
  #text(style: "italic")[
    #text(colors.accentColor)[#dateFrom - #dateTo]\
    #if facilityDescription != "" [
      #set text(colors.textSecondary)
      #facilityDescription\
    ]
    #text(colors.accentColor)[#taskDescriptionLabel]\
  ]
  #taskDescription
]

#let educationalExperience(..args) = {
  experience(..args, taskDescriptionLabel: "Courses")
}

#let workExperience(..args) = {
  experience(..args, taskDescriptionLabel: "Achievements/Tasks")
}

#let project(title: "", description: "", subtitle: "", dateFrom: "", dateTo: "") = {
  let date = ""
  if dateFrom != "" and dateTo != "" {
    date = text(style: "italic")[(#dateFrom - #dateTo)]
  } else if dateFrom != "" {
    date = text(style: "italic")[(#dateFrom)]
  }

  text(size: textSize.large)[#title #date\ ]
  if subtitle != "" {
      set text(colors.textSecondary, style: "italic")
      text()[#subtitle\ ]
  }
  if description != "" {
    [#description]
  }
}


#let modern-resume(data, body) = {
  // Configuration
  set page(
    paper: "a4",
    margin: (
      top: 0cm,
      left: 0cm,
      right: 0cm,
      bottom: 1cm,
    ),
  )
  set text(
    font: "Roboto",
    size: textSize.normal,
  )
  set list(marker: (text(colors.accentColor)[•], text(colors.accentColor)[--]))

  show heading: it => {
    set text(colors.accentColor)
    pad(bottom: 0.5em)[
      #underline(stroke: 2pt + colors.accentColor, offset: 0.25em)[
        #upper(it.body)
      ]
    ]
  }

  // Header
  {
    show link: it => [
      #it #linkIcon("arrow-up-right-from-square")
    ]
    header(data)
  }
  // Main content
  {
    show link: it => [
      #it #linkIcon("arrow-up-right-from-square", color: colors.accentColor)
    ]
    pad(
      left: pageMargin,
      right: pageMargin,
      top: 8pt
    )[#columns(2, body)]
  }
}
