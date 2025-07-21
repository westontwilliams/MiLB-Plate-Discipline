library(dplyr)
library(httr)
library(jsonlite)
library(ggplot2)
library(ggrepel)
AAA_hit_api <- "https://www.fangraphs.com/api/leaders/minor-league/data?pos=all&level=1&lg=2,4,5,6,7,8,9,10,11,14,12,13,15,16,17,18,30,32&stats=bat&qual=y&type=0&team=&season=2025&seasonEnd=2025&org=&ind=0&splitTeam=false"
r <- GET(AAA_hit_api)
AAA_hit <- fromJSON(content(r, as = "text"))
AAA_hit <- as.data.frame(AAA_hit)
AAA_hit_final <- AAA_hit %>%
  select(PlayerName, AffAbbName, `K%`, `BB%`) %>%
  arrange(desc(`BB%`))

ggplot(AAA_hit_final, aes(`K%`, `BB%`, label = paste0(PlayerName, ' (', AffAbbName, ')'))) + 
  geom_point(color = "gray") + 
  scale_x_reverse() +
  geom_text_repel(data=subset(AAA_hit_final, `K%` < 0.1 | `BB%` > 0.175),
                  size=3, box.padding = 0.5, fontface = "bold") +
  geom_hline(yintercept = mean(AAA_hit_final$`BB%`, na.rm = TRUE), linewidth=0.2) +
  geom_vline(xintercept = mean(AAA_hit_final$`K%`, na.rm = TRUE), linewidth=0.2) +
  theme_bw()