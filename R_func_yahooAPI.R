library(httr)
library(httpuv)

yahooFantasy_get_credential <- function() {
  
  # Gets the yahoo credential and saves it ---------------------------------------------------
  cKey     <- readLines("myPrivateKey.txt")[1];
  cSecret  <- readLines("myPrivateKey.txt")[2];
  
  yahoo <- oauth_endpoints("yahoo");
  
  myapp <- oauth_app("yahoo", key=cKey, secret=cSecret);
  yahoo_token<- oauth1.0_token(yahoo, myapp, cache=FALSE);
  
  save(yahoo_token,file="Fantasy.Rdata");
  
}