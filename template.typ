// url预处理
#let url(url-str) = {
  let prefix = regex("http[s]?://")

  // url必须以http:// 或 https://开头
  if not url-str.starts-with(prefix) {
    panic("url must start with http:// or https://")
  }

  url-str = url-str.replace(prefix, "")
  // 去掉末尾的/
  if url-str.ends-with("/") {
    url-str = url-str.slice(0, url.len() - 1)
  }

  if url-str.starts-with("github.com/") {
    url-str = url-str.replace("github.com/", "")
  }

  return url-str
}

// github 链接
#let github(url-str) = {
  let prefix = regex("http[s]?://github.com/")
  if not url-str.starts-with(prefix) {
    panic("github url must start with http[s]://github.com/")
  }

  return link(url-str)[
    #set box(height: 1em)
    #box(image("./icons/github.svg"), baseline: 0.75pt)
    #text(weight: "regular")[
      #url(url-str)
    ]
  ]
}

// 分节信息
#let section-header(title: "", icon: "") = {
  grid(
    columns: (1fr),
    row-gutter: 6pt,
    align(left)[
      #if icon != "" {
        box(image(icon), height: 1.4em, baseline: 2pt)
        h(1pt)
      }
      #text(weight: "black", 1.4em, title)
    ],
    line(stroke: 0.5pt+gray, length: 100%)
  )
}


#let cv(name: "",  email: "", website: "", school: "", avatar: "", body) = {
  set document(title: name)
  set page(paper: "a4", margin: (x: 2.1cm, y: 1.2cm))
  set text(font: "LXGW WenKai", 0.9em, weight: "regular");
  set par(justify: true, linebreaks: "optimized")

  align(center)[
    // 名字
    #block(text(weight: "black", 2.4em, name))
    #if avatar != "" {
      place(top + right, dy: -3em)[
        #block(image(avatar), height: 5em, width: 6em)
      ]
    }
    

    // 其他信息
    #set text(size: 0.9em)
    #set box(baseline: 0.1em, height: 1em)
    #grid(
      columns: (auto, auto, auto, auto, auto, auto, auto),
      column-gutter: 0.8em,
      link("mailto:" + email)[
        #box(image("./icons/envelope.svg"))
        #email
      ],
      text(weight: "regular", baseline: 2pt)[
        ·
      ],
      link("")[
        #box(image("./icons/school.png"))
        #school
      ],
      text(weight: "regular", baseline: 2pt)[
        ·
      ],
      link(website)[
        #box(image("./icons/website.svg"))
        #url(website)
      ]
    )
  ]
  body
}

#let interests(interests) = {
  section-header(title: "Research Interests", icon: "./icons/focus.png")
  set text(1.05em)

  for interest in interests {
    block[
      #text(interest.text)
      #h(3pt)
    ]
  }
  v(3pt)
}

#let jr_publications(me, publications) = {
  section-header(title: "Journal Publications", icon: "./icons/jr_pub.png")
  set text(1.05em)

  let n = 1
  for pub in publications {

    block[
	  #text("[" + str(n) + "]")
	  #h(3pt)
  	  #for author in pub.author_list.split(",") {
		if author.contains(me) {
			text(weight: "black", author + ",")
		} else {
			text(author + ",")
	  	}
	  }
      #h(3pt)
	  #text("\"" + pub.name + "\"")
	  #h(3pt)
	  #text(emph(pub.where))
	  #h(1pt)
	  #text("(")
	  #text(weight: "black", emph(pub.abbr + " '" + pub.year.slice(-2)))
	  #text(")")
    ]
	n = n + 1
  }
  v(3pt)
}

#let under_review(me, publications) = {
  section-header(title: "Under Review", icon: "./icons/submission.png")
  set text(1.05em)

  let n = 1
  for pub in publications {
    block[
	  #text("[" + str(n) + "]")
	  #h(3pt)
  	  #for author in pub.author_list.split(",") {
		if author.contains(me) {
			text(weight: "black", author + ",")
		} else {
			text(author + ",")
	  	}
	  }
      #h(3pt)
	  #text("\"" + pub.name + "\"")
    ]
	n = n + 1
  }
  v(3pt)
}


// 教育背景
#let educations(educations) = {
  section-header(title: "Education", icon: "./icons/education.svg")
  set text(1.05em)

  for education in educations {
    block[
      #text(weight: "black", education.school + ",")
      #h(3pt)
      #education.major
      #h(1fr)
      #text(education.degree)
	  #if education.footnote != "" {
        footnote(education.footnote)
      }
      #h(3pt)
      #text(0.9em, weight: "thin", emph(education.date))
      #v(-4pt)
    ]
  }

  v(3pt)
}

// 项目经历
#let h_projects(projects) = {
  section-header(title: "Consulting Project", icon: "./icons/project.svg")

  set list(indent: 1em, tight: true)

  for project in projects {
    block[
	  #text(weight: "black", project.role + ".")
//	  #text(".")
//	  #h(3pt)
	  #text(weight: "black", project.status + ".")
//	  #text(".")
//	  #h(3pt)
      #text(project.name)
      #h(1fr)
      #text(weight: "thin", emph(project.date))	  
      #v(-5pt)
      #text("Supported by " + project.company)

      #for point in project.points.map(x => "[" + x + "]")  {
        list(eval(point))
      }
      #v(2pt)
    ]
  }
}

#let projects(projects) = {
  section-header(title: "Project", icon: "./icons/project.svg")

  set list(indent: 1em, tight: true)

  for project in projects {
    block[
      #text(1.25em, weight: "black", project.name)
      #if project.url != "" {
        h(3pt)
        github(project.url)
      }
      #h(1fr)
      #text(weight: "thin", emph(project.date))

      #if project.desc != "" {
        v(-5pt)
        text(weight: "black", project.desc)
      }

      #for point in project.points.map(x => "[" + x + "]")  {
        list(eval(point))
      }
      #v(3pt)
    ]
  }
}

// 实习经历
#let internships(internships) = {
  section-header(title: "Internship", icon: "./icons/internship.svg")
  set list(indent: 1em, tight: true)

  for internship in internships {
    block[
      #text(1.25em, weight: "black", internship.company)
      #h(3pt)
      #internship.jobtitle
      #h(1fr)
      #text(weight: "thin", emph(internship.date))
      
      #for point in internship.points.map(x => "[" + x + "]") {
        list(eval(point))
      }

      #v(3pt)
    ]
  }
}

// 荣誉奖项
#let awards(awards) = {
  section-header(title: "Awards", icon: "./icons/award.svg")
  set list(tight: true, marker: none, body-indent: 0pt)

  for award in awards {
    list[
      #award.name
      #h(1fr)
      #text(weight: "thin", emph(award.date))
      #v(2pt)
    ]
  }
}

// 个人技能
#let skills(skills) = {
  section-header(title: "Skill", icon: "./icons/skill.svg")
  set list(tight: true, marker: none, body-indent: 0pt)

  for skill in skills {
    list[
      #skill.name
      #h(1fr)
      #text(weight: "regular", emph(skill.desc))
      #v(2pt)
    ]
  }
}


#let teachings(teachings) = {
  section-header(title: "Teaching", icon: "./icons/skill.svg")
  set list(tight: true, marker: none, body-indent: 0pt)
  text(emph("Teaching Assistant: "))
  for teaching in teachings {
    list[
	  #h(5pt)
      #teaching.name
      #h(1fr)
      #text(weight: "regular", emph(teaching.date))
      #v(2pt)
    ]
  }
}