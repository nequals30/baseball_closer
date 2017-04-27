library(httr)
library(httpuv)

yahooFantasy_get_credential <- function() {
  
  options("httr_oob_default" = T);
  
  # Gets the yahoo credential and saves it ---------------------------------------------------
  cKey     <- readLines("myPrivateKey.txt")[1];
  cSecret  <- readLines("myPrivateKey.txt")[2];
  
  yahoo <- oauth_endpoints("yahoo");
  
  yahoo$request <- gsub("oauth/v2", "oauth2", yahoo$request);
  yahoo$authorize <- gsub("oauth/v2", "oauth2", yahoo$authorize);
  yahoo$access <- gsub("oauth/v2", "oauth2", yahoo$access);
  
  myapp <- oauth_app("yahoo", key=cKey, secret=cSecret);
  yahoo_token<- oauth2.0_token(yahoo, myapp, cache=T, use_oob = T);
  sig <- sign_oauth1.0(myapp, yahoo_token$oauth_token, yahoo_token$oauth_token_secret);
  
  save(sig,file="Fantasy.Rdata");
}