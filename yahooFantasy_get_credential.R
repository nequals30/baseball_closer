library(httr)
library(httpuv)

yahooFantasy_get_credential <- function() {
# Gets the yahoo credential and saves it ---------------------------------------------------
  cKey     <- readLines("myPrivateKey.txt")[1];
  cSecret  <- readLines("myPrivateKey.txt")[2];
  
  yahoo <- oauth_endpoints("yahoo");
  
  myapp <- oauth_app("yahoo", key=cKey, secret=cSecret);
  yahoo_token<- oauth1.0_token(yahoo, myapp, cache=T);
  sig <- sign_oauth1.0(myapp, yahoo_token$oauth_token, yahoo_token$oauth_token_secret);
  
  save(sig,file="Fantasy.Rdata");
}