library(dplyr)
library(httr)
library(jsonlite)
library(ggplot2)
library(ggrepel)
A_hit_api <- "https://www.fangraphs.com/api/leaders/minor-league/data?pos=all&level=4&lg=2,4,5,6,7,8,9,10,11,14,12,13,15,16,17,18,30,32&stats=bat&qual=y&type=0&team=&season=2025&seasonEnd=2025&org=&ind=0&splitTeam=false"
r <- GET(A_hit_api)
A_hit <- fromJSON(content(r, as = "text"))
A_hit <- as.data.frame(A_hit)
A_hit_final <- A_hit %>%
  select(PlayerName, AffAbbName, `K%`, `BB%`) %>%
  arrange(desc(`BB%`))

ggplot(A_hit_final, aes(`K%`, `BB%`, label = paste0(PlayerName, ' (', AffAbbName, ')'))) + 
  geom_point(color = "gray") + 
  scale_x_reverse() +
  geom_text_repel(data=subset(A_hit_final, (`K%` < 0.125 | `BB%` > 0.185) | (`BB%` > `K%`)),
                  size=3, box.padding = 0.5, fontface = "bold") +
  geom_hline(yintercept = mean(A_hit_final$`BB%`, na.rm = TRUE), linewidth=0.2) +
  geom_vline(xintercept = mean(A_hit_final$`K%`, na.rm = TRUE), linewidth=0.2) +
  theme_bw()