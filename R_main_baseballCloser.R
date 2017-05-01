
closer_analysis <- function(){

## Enter your information here --------------------------------------------------------
  league_ID <- 30362;
  league_sport <- 'mlb';
  league_year <- 2017;

  # Get Yahoo Credentials:
  # NOTE: You can just paste yours in here instead of storing them in a file like me.
  cKey     <- readLines("myPrivateKey.txt")[1];
  cSecret  <- readLines("myPrivateKey.txt")[2];
  
## Authenticate Yahoo API credentials -------------------------------------------------

  # If our token is already saved, use it. Otherwise, get it again.
  yahoo_token <- tryCatch({
    load("yahoo_token.Rdata");
    yahoo_token;
    
  }, error =function(e){
    yahoo_token <- yahooFantasy_get_oauth_token(cKey,cSecret);
    return(yahoo_token);
  })
  
## Figure out the correct Game_ID ----------------------------------------------------
  
  game_ID <- yahooFantasy_get_gameID(league_sport,league_year,yahoo_token);
  
  leagueKey <- paste0(game_ID,'.l.',league_ID);
  
  standings <- yahooFantasy_get_leagueStandings(leagueKey,yahoo_token);
  
  paste("yo dawg");
  
}