library(dplyr)
library(httr)
library(jsonlite)
AAA_hit_api <- "https://www.fangraphs.com/api/leaders/minor-league/data?pos=all&level=1&lg=2,4,5,6,7,8,9,10,11,14,12,13,15,16,17,18,30,32&stats=bat&qual=y&type=0&team=&season=2025&seasonEnd=2025&org=&ind=0&splitTeam=false"
r <- GET(AAA_hit_api)
AAA_hit <- fromJSON(content(r, as = "text"))
AAA_hit <- as.data.frame(AAA_hit)
AAA_hit_final <- AAA_hit %>%
  select(PlayerName, `K%`, `BB%`) %>%
  arrange(desc(`BB%`))