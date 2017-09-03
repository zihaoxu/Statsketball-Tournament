library(rvest)

# Creating the list of urls of rating websites from 2002 to 2017
urls= c()
for (i in 2002:2016){
  urls = c(urls, paste("http://kenpom.com/index.php?y=",toString(i), sep = ""))
}
urls = c(urls,"http://kenpom.com/index.php")

years <- 2002:2017
for (i in 1:length(urls)){
  web <- read_html(urls[i])
  
  team <- html_nodes(web, 'td:nth-child(2) a')
  team <- html_text(team)
  
  W_L <- html_nodes(web, 'td:nth-child(4)')
  W_L <- html_text(W_L)
  
  AdjEM<- html_nodes(web, 'td:nth-child(5)')
  AdjEM<- html_text(AdjEM)
  
  AdjO<- html_nodes(web, '.td-left:nth-child(6)')
  AdjO<- html_text(AdjO)
  
  AdjD<- html_nodes(web, '.td-left:nth-child(8)')
  AdjD<- html_text(AdjD)
  
  AdjT<- html_nodes(web, '.td-left:nth-child(10)')
  AdjT<- html_text(AdjT)
  
  luck<- html_nodes(web, '.td-left:nth-child(12)')
  luck<- html_text(luck)
  
  data <- data.frame('team' = team, 'W_L' = W_L, 'AdjEM' = AdjEM, 'AdjO' = AdjO, 
                         'AdjD' = AdjD, 'AdjT' = AdjT, 'luck' = luck)
  write.csv(data,file = paste(years[i], "_data.csv", sep = ""))
}


