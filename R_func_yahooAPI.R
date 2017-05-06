library(httr)
library(httpuv)
library(jsonlite)

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
  # Internal helper function to 
  page <-GET(inUrl,config(token=yahoo_token));
  retrievedJSON <- content(page, as="text", encoding="utf-8");
  if (substr(retrievedJSON,1,9)=="<!doctype"){
    stop('Yahoo sent back an error.')
  }
  if (substr(retrievedJSON,1,5)!="{\"fan"){
    stop("What Yahoo sent back is not a JSON.");
  }
  outList <- fromJSON(retrievedJSON);
  return(outList)
}


yahooFantasy_get_gameID <- function(sport,year,yahoo_token){
  # Ask Yahoo for the 3-digit game_ID based on the sport and season
  
  if (year!=2017){
    stop("Not implemented. Dont know how to query Yahoo API for season except for current season");
  }
  thisUrl <- paste0("http://fantasysports.yahooapis.com/fantasy/v2/game/",sport,'?format=json');
  gameInfoList <- yahooFantasy_query(thisUrl,yahoo_token);
  game_ID <- gameInfoList$fantasy_content$game$game_key
  return(game_ID)
}


yahooFantasy_get_allPlayers <- function(leagueKey,yahoo_token){
  thisUrl <- paste0("http://fantasysports.yahooapis.com/fantasy/v2/league/",leagueKey,'/players?format=json');
  playerList <- yahooFantasy_query(thisUrl,yahoo_token);
}
