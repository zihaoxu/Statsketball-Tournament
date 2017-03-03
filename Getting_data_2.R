library(rvest)

# Creating the list of urls of rating websites from 2002 to 2017
urls= c()
for (i in 2002:2016){
  urls = c(urls, paste("http://www.sports-reference.com/cbb/postseason/",toString(i), "-ncaa.html", sep = ""))
}


years <- 2002:2017
for (i in 1:length(urls)){
  web <- read_html(urls[i])
  
  team_score <- html_nodes(web, '#bracket :nth-child(1) div div a')
  team_score <- html_text(team_score)
  team_score <- team_score[c(1:128)]
  
  team = c()
  score = c()
  for (j in 1:length(team_score)){
    if (j %% 2 == 1){
      team = c(team, team_score[j])
    }else{
      score = c(score, team_score[j])
    }
      
  }
  data <- data.frame('team' = team, 'score' = score)
  write.csv(data,file = paste(years[i], "_64_winner.csv", sep = ""))
}










