library(httr)
library(httpuv)
library(XML)

yahooFantasy_get_oauth_token <- function(cKey,cSecret) {
  # Creates Oauth Token for connecting to Yahoo API and saves it.
  #
  # Inputs:
  #   cKey <- Credential Key (register here: https://developer.yahoo.com/apps/create)
  #   cSecret <- Credential Secret
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
  page <-GET(inUrl,config(token=yahoo_token));
  retrievedXml <- content(page, as="text", encoding="utf-8");
  outList <- xmlToList(xmlRoot(xmlTreeParse(retrievedXml,useInternal=TRUE)));
  return(outList)
}

yahooFantasy_get_gameID <- function(sport,year,yahoo_token){
  # Ask Yahoo for the 3-digit game_ID based on the sport and season
  
  # hardcode MLB 2017
  
  if (year!=2017){
    stop("Not implemented. Dont know how to query Yahoo API for season except for current season");
  }
  thisUrl <- paste0("http://fantasysports.yahooapis.com/fantasy/v2/game/",sport);
  thisList <- yahooFantasy_query(thisUrl,yahoo_token);
  game_ID <- thisList$game$game_id
  return(game_ID)
}

yahooFantasy_get_leagueStandings <- function(leagueKey,yahoo_token){
  thisUrl <- paste0("http://fantasysports.yahooapis.com/fantasy/v2/league/",leagueKey,'/standings');
  thisList <- yahooFantasy_query(thisUrl,yahoo_token);
  paste('yo dawg');
}