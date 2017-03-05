years = 2002:2016

B_url <- "/Users/zihaoxu/Statsketball/Statsketball-Tournament/Bracket_Data/"
K_url <- "/Users/zihaoxu/Statsketball/Statsketball-Tournament/Kenpom_Data/"
S_url <- "/Users/zihaoxu/Statsketball/Statsketball-Tournament/Sports_Reference_Data/"

for (year in years){
  B <- read.csv(file = paste(B_url,year,"_bracket_data.csv", sep = ""), header = TRUE)
  B <- within(B, rm('X'))
  
  K <- read.csv(file = paste(K_url,year,"_data.csv", sep = ""), header = TRUE)
  K <- within(K, rm('X'))
  
  S <- read.csv(file = paste(S_url,year,"_Adv_data.csv", sep = ""), header = TRUE)
  S <- within(S, rm('X'))
  
  Master <- merge(B, S, by = 'team', all.x = TRUE)
  Master <- merge(Master, K, by = 'team', all.x = TRUE)
  
  write.csv(Master, file = paste(year, "_master.csv", sep = ""))
}
