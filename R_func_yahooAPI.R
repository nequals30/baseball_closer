library(httr)
library(httpuv)
library(XML)

yahooFantasy_get_oauth_token <- function(cKey,cSecret) {
  # Creates Oauth Token for connecting to Yahoo API and saves it.
  #
  # Inputs:
  #   cKey       Credential Key (register here: https://developer.yahoo.com/apps/create)
  #   cSecret    Credential Secret
  #
  # Outputs:
  #   yahoo_token

    yahoo <- oauth_endpoints("yahoo");
    
    myapp <- oauth_app("yahoo", key=cKey, secret=cSecret);
    yahoo_token<- oauth1.0_token(yahoo, myapp, cache=FALSE);
    
    save(yahoo_token,file="yahoo_token.Rdata");
    return(yahoo_token);
}



yahooFantasy_query <- function(inUrl,yahoo_token){
  # Internal helper function to query Yahoo for the data. 
  
  page <-GET(inUrl,config(token=yahoo_token));
  out <- content(page, as="text", encoding="utf-8");
  
  outXml<-xmlTreeParse(out,useInternal=TRUE);
  outNode <- xmlRoot(outXml);
  
  # if (substr(out,1,9)=="<!doctype"){
  #   stop('Yahoo sent back an error.')
  # }
  return(outNode)
}



yahooFantasy_get_gameID <- function(sport,year,yahoo_token){
  # Ask Yahoo for the 3-digit game_ID based on the sport and season.
  #
  # Args:
  #   sport: For example, 'mlb' or 'nfl'
  #   year:  For example, 2017
  #   yahoo_token:  yahoo token obtained from yahooFantasy_get_oauth_token
  #
  # Returns:
  #   game_ID: A string with a 3 digit number
  
  thisUrl <- paste0("http://fantasysports.yahooapis.com/fantasy/v2/game/",sport,'?season=',year);
  thisXml <- yahooFantasy_query(thisUrl,yahoo_token);
  game_ID <- xmlValue(thisXml[["game"]][["game_key"]]);
  return(game_ID)
}



yahooFantasy_get_allRelievers <- function(leagueKey,yahoo_token){
  # Ask yahoo for the list of all relief pitchers in your baseball lauge.
  
  thisUrl <- paste0("http://fantasysports.yahooapis.com/fantasy/v2/league/",leagueKey,'/players?&position=RP&count=5');
  thisXml <- yahooFantasy_query(thisUrl,yahoo_token);
  playerTbl <- xmlToDataFrame(thisXml[["league"]][["players"]]);
}
