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

// Load an icon by 'name' and set its color.
#let icon(
  name,
  color: white,
  baseline: 0.125em,
  height: 1.0em,
  width: 1.25em) = {
    let originalImage = read("icons/" + name + ".svg")
    let colorizedImage = originalImage.replace(
      "#ffffff",
      color.to-hex(),
    )
    box(
      baseline: baseline,
      height: height,
      width: width,
      image.decode(colorizedImage)
    )
}

// Use this method for icons in links to adjust their size.
#let linkIcon(..args) = {
  icon(..args, width: 1.25em / 2, baseline: 0.125em * 3)
}

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

#let header(author, job-title, bio: none, avatar: none, contact-options: ()) = {
  let avatarImagePath = ""
  if avatar != none {
    avatarImagePath = avatar
  }
  grid(
    columns: 1,
    rows: (auto, auto),
    headerRibbon(
      colors.primary,
      headline(author, job-title, bio, imagepath: avatarImagePath)
    ),
    headerRibbon(colors.secondary, contactDetails(contact-options))
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


#let modern-resume(
  // The person's full name as a string.
  author: "John Doe",

  // A short description of your profession.
  job-title: [Data Scientist],

  // A short description about your background/experience/skills, or none.
  bio: none,
  // A avatar that is pictures in the top-right corner of the resume, or none.
  avatar: none,

  // A list of contact options.
  contact-options: (),

  // The resume's content.
  body
) = {
  // Set document metadata.
  set document(title: "Resume of " + author, author: author)

  // Set the body font.
  set text(font: "Roboto", size: textSize.normal)

  // Configure the page.
  set page(
    paper: "a4",
    margin: (
      top: 0cm,
      left: 0cm,
      right: 0cm,
      bottom: 1cm,
    ),
  )

  // Set the marker color for lists.
  set list(marker: (text(colors.accentColor)[•], text(colors.accentColor)[--]))

  // Set the heading.
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
    header(author, job-title, bio: bio, avatar: avatar, contact-options: contact-options)
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
