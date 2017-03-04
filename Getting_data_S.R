library(rvest)

# Creating the list of urls of rating websites from 2002 to 2017
urls= c()
for (i in 2002:2017){
  urls = c(urls, paste("http://www.sports-reference.com/cbb/seasons/",toString(i), "-advanced-school-stats.html",sep = ""))
}


years <- 2002:2017
for (i in 1:length(urls)){
  web <- read_html(urls[i])
  
  team <- html_nodes(web, '#adv_school_stats a')
  team <- html_text(team)
  
  win <- html_nodes(web, '.right:nth-child(4)')
  win <- as.numeric(html_text(win))
  
  lose <- html_nodes(web, '.right:nth-child(5)')
  lose <- as.numeric(html_text(lose))
  
  W_L_ratio <- html_nodes(web, '.right:nth-child(6)')
  W_L_ratio <- as.numeric(html_text(W_L_ratio))
  
  SRS<- html_nodes(web, '.right:nth-child(7)')
  SRS<- as.numeric(html_text(SRS))
  
  SOS<- html_nodes(web, '.right:nth-child(8)')
  SOS<- as.numeric(html_text(SOS))
  
  TM_pt<- html_nodes(web, '.right:nth-child(15)')
  TM_pt<- as.numeric(html_text(TM_pt))
  
  OPPO_pt<- html_nodes(web, '.right:nth-child(16)')
  OPPO_pt<- as.numeric(html_text(OPPO_pt))
  
  # Possession
  Poss<- html_nodes(web, '.right:nth-child(18)')
  Poss<- html_text(Poss)
  
  # True shooting percentage
  True_S<- html_nodes(web, '.right:nth-child(22)')
  True_S<- as.numeric(html_text(True_S))
  
  
  data <- data.frame('team' = team, 'W' = win, 'L' = lose, 'W_L_ratio' = W_L_ratio, 'SRS' = SRS, 'SOS' = SOS, 
                     'TM_pt' = TM_pt, 'OPPO_pt' = OPPO_pt, PT_Ratio = TM_pt/OPPO_pt,
                     'Poss' = as.numeric(Poss), "True_S" = True_S)
  write.csv(data,file = paste(years[i], "_Adv_data.csv", sep = ""))
}


