library(rvest)

# Creating the list of urls of rating websites from 2002 to 2017
urls= c()
for (i in 2002:2016){
  urls = c(urls, paste("http://www.sports-reference.com/cbb/postseason/",toString(i), "-ncaa.html", sep = ""))
}

# Initializing some useful vectors
years <- 2002:2016
rank <- c(1,16,8,9,5,12,4,13,6,11,3,14,7,10,2,15)
ranking <- c(rank,rank,rank,rank)

# Creating the data frames from online urls
for (i in 1:length(urls)){
  web <- read_html(urls[i])
  
  team_score <- html_nodes(web, '#bracket :nth-child(1) div div a')
  team_score <- html_text(team_score)
  team_score <- team_score[c(1:128)]
  
  # Separating team as scores
  team = c()
  score = c()
  for (j in 1:length(team_score)){
    if (j %% 2 == 1){
      team = c(team, team_score[j])
    }else{
      score = c(score, as.numeric(team_score[j]))
    }
  }

  # Computing point difference and game results 
  point_diff = c()
  result = c()
  for (ss in 1:length(score)){
    if (ss %% 2 == 1){
      first_score = score[ss]
      second_score = score[ss+1]
      diff = max(first_score,second_score)-min(first_score,second_score)
      if (first_score >= second_score){
        result = c(result, 1, 0)
        point_diff = c(point_diff, diff, -diff)
      }else{
        result = c(result, 0, 1)
        point_diff = c(point_diff, -diff, diff)
      }
        
    }
  }
  
  data <- data.frame('team' = team, seed = ranking, 'score' = score, 'point_diff' = point_diff, 
                     'result' = result)
  write.csv(data,file = paste(years[i], "_bracket_data.csv", sep = ""))
}

