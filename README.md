# A modern typst CV template

[![Build Typst document](https://github.com/peterpf/modern-typst-resume/actions/workflows/build.yaml/badge.svg)](https://github.com/peterpf/modern-typst-resume/actions/workflows/build.yaml)

![Cover](docs/images/cover.png)

## Requirements

To compile this project you need the following:

- Typst
- Roboto font family

Run the following command to build the typst file whenever saving changes

```bash
typst watch main.typ
```

## Usage

This is a typst template that provides the general page style and several elements out-of-the-box.

The following code provides a minimum working example:

```typst
#import "modern-resume.typ": modern-resume

#let data = (
  name: "John Doe",
  jobTitle: "Data Scientist",
  bio: lorem(5),                  // Optional parameter
  avatarImagePath: "avatar.png",  // Optional parameter
  contactOptions: (               // Optional parameter, all entries are optional
    email: link("mailto:john.doe@gmail.com")[john.doe\@gmail.com],
    mobile: "+43 1234 5678",
    location: "Austria",
    linkedin: link("https://www.linkedin.com/in/jdoe")[linkedin/jdoe],
    github: link("https://github.com/jdoe")[github.com/jdoe],
    website: link("https://jdoe.dev")[jdoe.dev],
  ),
)

#show: doc => modern-resume(data, doc)

// Your content goes here
```

See [main.typ](./main.typ) for a full example that showcases all available elements.

### Elements

This section introduces the visual elements that are part of this template.

#### Pills

Import this element from the template module with `pill`.

![pills](docs/images/pills.png)

```typst
#pill("German (native)")
#pill("English (C1)")
```

![pills filled](docs/images/pills-filled.png)

```typst
#pill("Teamwork", fill: true)
#pill("Critical thinking", fill: true)
```

#### Educational/work experience

Import the elements from the template module with `educationalExperience` and `workExperience` respectively.

![educational experience](docs/images/educational-experience.png)

```typst
#educationalExperience(
  title: "Master's degree",
  subtitle: "University of Sciences",
  taskDescription: [
    - Short summary of the most important courses
    - Explanation of master thesis topic
  ],
  dateFrom: "10/2021",
  dateTo: "07/2023",
)
```

![work experience](docs/images/work-experience.png)

```typst
#workExperience(
  title: "Full Stack Software Engineer",
  subtitle: [#link("https://www.google.com")[Some IT Company]],
  facilityDescription: "Company operating in sector XY",
  taskDescription: [
    - Short summary of your responsibilities
  ],
  dateFrom: "09/2018",
  dateTo: "07/2021",
)
```

#### Project

Import this element from the template module with `project`.


![project](docs/images/project.png)

```typst
#project(
  title: "Project 2",
  subtitle: "Data Visualization, Data Engineering",
  description: [
    - #lorem(20)
  ],
  dateFrom: "08/2022",
  dateTo: "09/2022",
)
```

### Theming

Customize the color theme by changing the values of the `color` dictionary in [modern-resume](modern-resume.typ). For example:

- The default color palette:

  ```typst
  #let colors = (
    primary: rgb("#313C4E"),
    secondary: rgb("#222A33"),
    accentColor: rgb("#449399"),
    textPrimary: black,
    textSecondary: rgb("#7C7C7C"),
    textTertiary: white,
  )
  ```

- A pink color palette:

  ```typst
  #let colors = (
    primary: rgb("#e755e0"),
    secondary: rgb("#ad00c2"),
    accentColor: rgb("#00d032"),
    textPrimary: black,
    textSecondary: rgb("#7C7C7C"),
    textTertiary: white,
  )
  ```

## Contributing

I'm grateful for any improvements and suggestions.