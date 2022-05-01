####################
# Title: FigGen_AggTE.R
# Author: Robert Petit
# Desc: Graph for Agg treatment effects and their CIs
################

readRDS(file=here("Data/CS_ATTGT.RDS")) %>%
  aggte %>%
  ggdid %>%
  ggsave(here("Figures/CS_AggTE.png"), plot=., bg="white", width=8, height=4.5)