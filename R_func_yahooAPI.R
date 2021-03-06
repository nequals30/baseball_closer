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
  #
  # Inputs:
  #   inUrl         String URL
  #   yahoo_token   yahoo_token produced by yahooFantasy_get_oauth_token
  #
  # Outputs: 
  #   outNode       xml node object which contains query results
  
  page <-GET(inUrl,config(token=yahoo_token));
  out <- content(page, as="text", encoding="utf-8");
  
  outXml<-xmlTreeParse(out,useInternal=TRUE);
  outNode <- xmlRoot(outXml);
  
  return(outNode)
}



yahooFantasy_get_gameID <- function(sport,year,yahoo_token){
  # Ask Yahoo for the 3-digit game_ID based on the sport and season.
  #
  # Inputs:
  #   sport: For example, 'mlb' or 'nfl'
  #   year:  For example, 2017
  #   yahoo_token:  yahoo token obtained from yahooFantasy_get_oauth_token
  #
  # Outputs:
  #   game_ID: A string with a 3 digit number
  
  thisUrl <- paste0("http://fantasysports.yahooapis.com/fantasy/v2/game/",sport,'?season=',year);
  thisXml <- yahooFantasy_query(thisUrl,yahoo_token);
  game_ID <- xmlValue(thisXml[["game"]][["game_key"]]);
  return(game_ID)
}



yahooFantasy_get_allRelievers <- function(leagueKey,yahoo_token){
  # Ask yahoo for the list of all relief pitchers in your baseball lauge.
  
  i <- 0;
  tempTbl <- data.frame(0);
  while (nrow(tempTbl)!=0){
    thisUrl <- paste0("http://fantasysports.yahooapis.com/fantasy/v2/league/",leagueKey,'/players?&position=RP&start=',i);
    thisXml <- yahooFantasy_query(thisUrl,yahoo_token);
    tempTbl <- xmlToDataFrame(thisXml[["league"]][["players"]]);
    tempTbl <- tempTbl[,!names(tempTbl)=='has_recent_player_notes'];
    if (i==0) {
      playerTbl <- tempTbl;
    } else {
      playerTbl <- rbind(playerTbl,tempTbl)
    }
    i <- i+25;
    cat(paste0('count=',i));
  }

}
