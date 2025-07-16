library(dplyr)
library(httr)
library(jsonlite)
library(ggplot2)
library(ggrepel)
A_hit_api <- "https://www.fangraphs.com/api/leaders/minor-league/data?pos=all&level=3&lg=2,4,5,6,7,8,9,10,11,14,12,13,15,16,17,18,30,32&stats=bat&qual=y&type=0&team=&season=2025&seasonEnd=2025&org=&ind=0&splitTeam=false"
r <- GET(A_hit_api)
A_hit <- fromJSON(content(r, as = "text"))
A_hit <- as.data.frame(A_hit)
A_hit_final <- A_hit %>%
  select(PlayerName, TeamName, `K%`, `BB%`) %>%
  arrange(desc(`BB%`))

ggplot(A_hit_final, aes(`K%`, `BB%`, label = PlayerName)) + 
  geom_point() + 
  geom_text_repel(data=subset(A_hit_final, `K%` > 0.35 | `BB%` > 0.185),
                  size = 3)