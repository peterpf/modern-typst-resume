// load_color_theme loads the color theme from the configuration dictionary.
#let load_color_theme(config) = {
  let theme = (
    "primary": rgb(config.theme.primary),
    "secondary": rgb(config.theme.secondary),
    "accentColor": rgb(config.theme.accentColor),
    "textPrimary": rgb(config.theme.textPrimary),
    "textSecondary": rgb(config.theme.textSecondary),
    "textTertiary": rgb(config.theme.textTertiary),
  )
  for pair in config.theme.pairs() {
    let key = pair.at(0)
    let color = rgb(pair.at(1))
    theme.insert(key, color)
  }
  return theme
}

// load_config parses the template configuration object from the `filepath`.
#let load_config(filepath) = {
  let cfg = yaml(filepath)

  let config = (
    theme: (
      primary: rgb(cfg.theme.at("primary", default: "#313C4E")),
      secondary: rgb(cfg.theme.at("secondary", default: "#222A33")),
      accentColor: rgb(cfg.theme.at("accentColor", default: "#449399")),
      textPrimary: rgb(cfg.theme.at("textPrimary", default: "#000000")),
      textSecondary: rgb(cfg.theme.at("textSecondary", default: "#7C7C7C")),
      textTertiary: rgb(cfg.theme.at("textTertiary", default: "#ffffff")),
    ),
  )
  return config
}

// joinPath joins the arguments to a valid system path.
#let joinPath(..parts) = {
  let path = ""
  let pathSeparator = "/"
  for part in parts.pos() {
    if part.at(part.len() - 1) == pathSeparator {
      path += part
    } else {
      path += part + pathSeparator
    }
  }
  return path
}
