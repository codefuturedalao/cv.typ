#import "template_ch.typ": *

// 加载数据
#let data = toml("main_ch.toml")

#let (name, email, website, school, avatar) = data.cv;
#show: cv.with(
  name: name, 
  email: email, 
  website: website,
  school: school,
  avatar: avatar
)

#interests(data.interests)
#educations(data.educations)
//#under_review(name, data.under_reviews)
#jr_publications("Qianlong Sang", data.jr_publications)
#h_projects(data.h_projects)
#projects(data.projects)
#internships(data.internships)
//#teachings(data.teachings)
#awards(data.awards)
