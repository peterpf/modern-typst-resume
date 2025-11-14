
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
