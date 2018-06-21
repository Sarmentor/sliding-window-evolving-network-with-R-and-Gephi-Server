library(RODBC)

ch <- odbcConnect("<db name>",uid="<login>",pwd="<password>")


read_DB <- function(ch, tablename)
{
df <- sqlFetch(ch, tablename, colnames=FALSE,rownames=TRUE)
}




build_graph <- function(X){

  cmd <- c()

  #input to GEPHI server
  
  if(X[1] %in% nodes) {
    cmd <- paste('curl "http://localhost:8080/workspace0?operation=updateGraph"'," -d ",'\"{\\"an\\":{','\\"',X[1],'\\"',':{\\"label\\":\\"',X[1],'\\",\\"size\\":20','}}}\"')
  }else{
    cmd <- paste('curl "http://localhost:8080/workspace0?operation=updateGraph"'," -d ",'\"{\\"an\\":{','\\"',X[1],'\\"',':{\\"label\\":\\"',X[1],'\\",\\"size\\":10','}}}\"')
  }
  checked <- c(checked, X[1])
  system(cmd, intern=TRUE)
  
  if(X[2] %in% nodes) {
    cmd <- paste('curl "http://localhost:8080/workspace0?operation=updateGraph"'," -d ",'\"{\\"an\\":{','\\"',X[2],'\\"',':{\\"label\\":\\"',X[2],'\\",\\"size\\":20','}}}\"')
  }else{
    cmd <- paste('curl "http://localhost:8080/workspace0?operation=updateGraph"'," -d ",'\"{\\"an\\":{','\\"',X[2],'\\"',':{\\"label\\":\\"',X[2],'\\",\\"size\\":10','}}}\"')
  }
  checked <- c(checked, X[2])
  system(cmd, intern=TRUE)
  
  if(((X[1] %in% checked) && (X[2] %in% checked))){
  cmd <- paste('curl "http://localhost:8080/workspace0?operation=updateGraph"'," -d ",'\"{\\"ae\\":{\\"',X[1],'-',X[2],'\\":{\\"source\\":\\"',X[1],'\\",\\"target\\":\\"',X[2],'\\",\\"directed\\":true}}}\"')
  system(cmd, intern=TRUE)
  }
}

#if needed  - not called in this code
delete_nodes <- function(X){
  cmd <- c()
  
  #input to GEPHI server
  
  if(X[1] %in% nodes) {
    cmd <- paste('curl "http://localhost:8080/workspace0?operation=updateGraph"'," -d ",'\"{\\"dn\\":{','\\"',X[1],'\\"',':{\\"label\\":\\"',X[1],'\\",\\"size\\":20','}}}\"')
  }else{
    cmd <- paste('curl "http://localhost:8080/workspace0?operation=updateGraph"'," -d ",'\"{\\"dn\\":{','\\"',X[1],'\\"',':{\\"label\\":\\"',X[1],'\\",\\"size\\":10','}}}\"')
  }
  checked <- c(checked, X[1])
  system(cmd, intern=TRUE)

  if(X[2] %in% nodes){
    cmd <- paste('curl "http://localhost:8080/workspace0?operation=updateGraph"'," -d ",'\"{\\"dn\\":{','\\"',X[2],'\\"',':{\\"label\\":\\"',X[2],'\\",\\"size\\":20','}}}\"')
  }else{
    cmd <- paste('curl "http://localhost:8080/workspace0?operation=updateGraph"'," -d ",'\"{\\"dn\\":{','\\"',X[2],'\\"',':{\\"label\\":\\"',X[2],'\\",\\"size\\":10','}}}\"')
  }
  checked <- c(checked, X[2])
  system(cmd, intern=TRUE)
  
  if(((X[1] %in% checked) && (X[2] %in% checked))){
    cmd <- paste('curl "http://localhost:8080/workspace0?operation=updateGraph"'," -d ",'\"{\\"de\\":{\\"',X[1],'-',X[2],'\\":{\\"source\\":\\"',X[1],'\\",\\"target\\":\\"',X[2],'\\",\\"directed\\":true}}}\"')
    system(cmd, intern=TRUE)
  }
}

#if needed - not called in this code
add_nodes <- function(X){
  cmd <- c()
  
  #input to GEPHI server
  if(X[1] %in% nodes){
    cmd <- paste('curl "http://localhost:8080/workspace0?operation=updateGraph"'," -d ",'\"{\\"an\\":{','\\"',X[1],'\\"',':{\\"label\\":\\"',X[1],'\\",\\"size\\":20','}}}\"')
  }else{
    cmd <- paste('curl "http://localhost:8080/workspace0?operation=updateGraph"'," -d ",'\"{\\"an\\":{','\\"',X[1],'\\"',':{\\"label\\":\\"',X[1],'\\",\\"size\\":10','}}}\"')
  }
  checked <- c(checked, X[1])
  system(cmd, intern=TRUE)
  
  if(X[2] %in% nodes) {
    cmd <- paste('curl "http://localhost:8080/workspace0?operation=updateGraph"'," -d ",'\"{\\"an\\":{','\\"',X[2],'\\"',':{\\"label\\":\\"',X[2],'\\",\\"size\\":20','}}}\"')
  } else{
    cmd <- paste('curl "http://localhost:8080/workspace0?operation=updateGraph"'," -d ",'\"{\\"an\\":{','\\"',X[2],'\\"',':{\\"label\\":\\"',X[2],'\\",\\"size\\":10','}}}\"')
  }
  checked <- c(checked, X[2])
  system(cmd, intern=TRUE)
  
  if(((X[1] %in% checked) && (X[2] %in% checked))){
    cmd <- paste('curl "http://localhost:8080/workspace0?operation=updateGraph"'," -d ",'\"{\\"ae\\":{\\"',X[1],'-',X[2],'\\":{\\"source\\":\\"',X[1],'\\",\\"target\\":\\"',X[2],'\\",\\"directed\\":true}}}\"')
    system(cmd, intern=TRUE)
  }
}

go <- function(nodeID, start_date_time, window_size) {

  nodes <<- strsplit(nodeID, split = " ")[[1]]
  date_start <- strsplit(start_date_time, split = " ")[[1]][1]
  time_start <- strsplit(start_date_time, split = " ")[[1]][2]
  time_db <- as.POSIXlt(strptime(paste(date_start,time_start, sep=" "), format='%Y%m%d %H%M%S'))
  
  #We need to know the end date for the selected period
  #changes end date for query
  if(window_size == 5){
    time_db <- time_db + 60 * 5
  }
  if(window_size == 15){
    time_db <- time_db + 60 * 15
  }
  if(window_size == 30){
    time_db <- time_db + 60 * 30
  }
  if(window_size == 4){
    time_db <- time_db + 60*60*4
  }
  if(window_size == 1){
    time_db <- time_db + 60*60*24
  }
  if(window_size == 18){
    time_db <- time_db + 60*60*24*7
  }
  
  date_end <- strsplit(time_db, split = " ")[[1]][1]
  time_end <- strsplit(time_db, split = " ")[[1]][2]
  
  
  
  
  #Example for reading from DB with timestamps (date and time)
  #Please note this query would select edges in the DB where the node appears
  #This code will display 1rst and 2nd order neighbors of searched node' network
  
  rows_dados <- sqlQuery(ch,paste("select <origin>, <other_node> from <table> where <origin> =", nodeID ,"or <other_node> =", nodeID," and <date> >= ",as.numeric(date_start)," and <date> <= ",as.numeric(date_end)," and <time> <= ", as.numeric(gsub(time_end,pattern=":",replacement="", fixed=TRUE))," and <time> >= ", as.numeric(gsub(time_start,pattern=":",replacement="", fixed=TRUE)),";"))
  
  if (nrow(rows_dados)==0) stop("Period unavailable. Please restart the program with other time period.")
  #Table with 1rst query result
  aux_rows_dados <- rows_dados
  rows_dados <- c(unique(rows_dados[which(rows_dados[,1]==nodeID),2]),unique(rows_dados[which(rows_dados[,2]==nodeID),1]))
  
  #2nd query with connections of connections for search node connection
  nbrs <- sqlQuery(ch,paste("select <origin>, <other_node> from <table> where <origin> IN (",paste(rows_dados, collapse=","),") or <other_node> IN (",paste(rows_dados, collapse=","),") and <date> >= ",as.numeric(date_start)," and <date> <= ",as.numeric(date_end)," and <time> <= ", as.numeric(gsub(time_end,pattern=":",replacement="", fixed=TRUE)) ,"and <time> >= ", as.numeric(gsub(time_start,pattern=":",replacement="", fixed=TRUE))," ;"))
  
  
  #Table with 2nd query results
  aux_nbrs <- nbrs
  #takes out duplicate connections with source neighbor
  aux_nbrs <- aux_nbrs[which(aux_nbrs[,1]!=nodeID),]
  aux_nbrs <- aux_nbrs[which(aux_nbrs[,2]!=nodeID),]
  #takes out duplication of connections with source nodes first neighbors
  nbrs <- c(unique(aux_nbrs[which(!(aux_nbrs[,2] %in% rows_dados)),1]),unique(aux_nbrs[which(!(aux_nbrs[,1] %in% rows_dados)),2]))
  nbrs_2 <- sqlQuery(ch,paste("select <origin>, <other_node> from <table> where <origin> IN (",paste(nbrs, collapse=","),") or <other_node> IN (",paste(nbrs, collapse=","),") and <date> >= ",as.numeric(date_start)," and <date> <= ",as.numeric(date_end)," and <time> <= ", as.numeric(gsub(time_end,pattern=":",replacement="", fixed=TRUE))," and <time> >= ", as.numeric(gsub(time_start,pattern=":",replacement="", fixed=TRUE)),";"))
  nbrs_2 <- nbrs_2[which(nbrs_2[,1]!=nodeID),]
  nbrs_2 <- nbrs_2[which(!(nbrs_2[,1] %in% rows_dados)),]
  nbrs_2 <- nbrs_2[which(!(nbrs_2[,2] %in% rows_dados)),]
  
  checked <<- c()
  apply(aux_rows_dados,1, build_graph)
  
  checked <<- c()
  apply(aux_nbrs,1, build_graph)
  
  checked <<- c()
  
}

cmd <- paste('curl "http://localhost:8080/workspace0?operation=updateGraph"'," -d ",'\"{\\"dn\\":{\\"filter\\":\\"ALL\\"}}\"')
system(cmd, intern=TRUE)
cmd <- paste('curl "http://localhost:8080/workspace0?operation=updateGraph"'," -d ",'\"{\\"de\\":{\\"filter\\":\\"ALL\\"}}\"')
system(cmd, intern=TRUE)


go(readline("Sliding Window! What is the Node ID you want to search? Press enter immediately for the whole network sliding window!"),readline("Start Date and Time (yyyymmdd hh:mm:ss)?"),readline("Window Size. Choices are 5 min(5),15 min(15), 30 min(30), 4 hours(4), 1 day(1), 1 week(18)?"))

