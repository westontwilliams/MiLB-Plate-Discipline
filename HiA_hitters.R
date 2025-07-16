library(dplyr)
library(httr)
library(jsonlite)
library(ggplot2)
library(ggrepel)
HiA_hit_api <- "https://www.fangraphs.com/api/leaders/minor-league/data?pos=all&level=3&lg=2,4,5,6,7,8,9,10,11,14,12,13,15,16,17,18,30,32&stats=bat&qual=y&type=0&team=&season=2025&seasonEnd=2025&org=&ind=0&splitTeam=false"
r <- GET(HiA_hit_api)
HiA_hit <- fromJSON(content(r, as = "text"))
HiA_hit <- as.data.frame(HiA_hit)
HiA_hit_final <- HiA_hit %>%
  select(PlayerName, AffAbbName, `K%`, `BB%`) %>%
  arrange(desc(`BB%`))

ggplot(HiA_hit_final, aes(`K%`, `BB%`, label = paste0(PlayerName, ' (', AffAbbName, ')'))) + 
  geom_point() + 
  scale_x_reverse() +
  geom_text_repel(data=subset(HiA_hit_final, `K%` < 0.125 | `BB%` > 0.185),
                  size=3, box.padding = 0.5) +
  geom_hline(yintercept = mean(HiA_hit_final$`BB%`, na.rm = TRUE), linewidth=0.2) +
  geom_vline(xintercept = mean(HiA_hit_final$`K%`, na.rm = TRUE), linewidth=0.2) +
  theme_bw()