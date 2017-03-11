############## function:
merge.with.order <- function(x,y, ..., sort = T, keep_order)
{
  # this function works just like merge, only that it adds the option to return the merged data.frame ordered by x (1) or by y (2)
  add.id.column.to.data <- function(DATA)
  {
    data.frame(DATA, id... = seq_len(nrow(DATA)))
  }
  # add.id.column.to.data(data.frame(x = rnorm(5), x2 = rnorm(5)))
  order.by.id...and.remove.it <- function(DATA)
  {
    # gets in a data.frame with the "id..." column.  Orders by it and returns it
    if(!any(colnames(DATA)=="id...")) stop("The function order.by.id...and.remove.it only works with data.frame objects which includes the 'id...' order column")
    
    ss_r <- order(DATA$id...)
    ss_c <- colnames(DATA) != "id..."
    DATA[ss_r, ss_c]
  }
  
  # tmp <- function(x) x==1; 1	# why we must check what to do if it is missing or not...
  # tmp()
  
  if(!missing(keep_order))
  {
    if(keep_order == 1) return(order.by.id...and.remove.it(merge(x=add.id.column.to.data(x),y=y,..., sort = FALSE)))
    if(keep_order == 2) return(order.by.id...and.remove.it(merge(x=x,y=add.id.column.to.data(y),..., sort = FALSE)))
    # if you didn't get "return" by now - issue a warning.
    warning("The function merge.with.order only accepts NULL/1/2 values for the keep_order variable")
  } else {return(merge(x=x,y=y,..., sort = sort))}
}

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
  
  Master <- merge.with.order(S , B, by = 'team', all.y = TRUE, keep_order = 2)
  Master <- merge.with.order(K, Master, by = 'team', all.y = TRUE, keep_order = 2)
  
  Master_F <- data.frame(row.names = 1:(length(Master)/2))
  col_names <- colnames(Master)
  for (i in 1:nrow(Master)){
    if (i%%2 == 1){
      row_num = (1+i)/2

      Master_F[row_num, 'team_X'] = Master[i,'team']
      Master_F[row_num, 'team_Y'] = Master[i+1,'team']
      Master_F[row_num, 'AdjEM_x-y'] = Master[i, 'AdjEM'] - Master[i+1, 'AdjEM']
      Master_F[row_num, 'AdjO_x-y'] = Master[i, 'AdjO'] - Master[i+1, 'AdjO']
      Master_F[row_num, 'AdjD_x-y'] = Master[i, 'AdjD'] - Master[i+1, 'AdjD']
      Master_F[row_num, 'AdjT_x-y'] = Master[i, 'AdjT'] - Master[i+1, 'AdjT']
      Master_F[row_num, 'luck_x-y'] = Master[i, 'luck'] - Master[i+1, 'luck']
      Master_F[row_num, 'W_x-y'] = Master[i, 'W'] - Master[i+1, 'W']
      Master_F[row_num, 'L_x-y'] = Master[i, 'L'] - Master[i+1, 'L']
      Master_F[row_num, 'W_L_ratio_x-y'] = Master[i, 'W_L_ratio'] - Master[i+1, 'W_L_ratio']
      Master_F[row_num, 'SRS_x-y'] = Master[i, 'SRS'] - Master[i+1, 'SRS']
      Master_F[row_num, 'SOS_x-y'] = Master[i, 'SOS'] - Master[i+1, 'SOS']
      Master_F[row_num, 'TM_pt_x-y'] = Master[i, 'TM_pt'] - Master[i+1, 'TM_pt']
      Master_F[row_num, 'OPPO_pt_x-y'] = Master[i, 'OPPO_pt'] - Master[i+1, 'OPPO_pt']
      Master_F[row_num, 'PT_Ratio_x-y'] = Master[i, 'PT_Ratio'] - Master[i+1, 'PT_Ratio']
      Master_F[row_num, 'True_S_x-y'] = Master[i, 'True_S'] - Master[i+1, 'True_S']
      Master_F[row_num, 'seed_x-y'] = Master[i, 'seed'] - Master[i+1, 'seed']
      Master_F[row_num, 'point_diff_x-y'] = Master[i, 'score'] - Master[i+1, 'score']
      
      if(Master[i, 'result'] == 1){
        Master_F[row_num,'result'] = 'X'
      }else{
        Master_F[row_num,'result'] = 'Y'
      }
  
    }
  }
  write.csv(Master_F, file = paste(year, "_master.csv", sep = ""))
}
