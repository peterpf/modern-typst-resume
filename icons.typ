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

#let linkIcon(..args) = {
  icon(..args, width: 1.25em / 2, baseline: 0.125em * 3)
}
