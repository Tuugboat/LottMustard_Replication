####################
# Title: TableGen_CSEstimation
# Author: Robert Petit
# Desc: Generates the table of ATTGTs for the CS estimator
################

readRDS(file=here("Data/CS_ATTGT.RDS")) %>%
  aggte %$% # gets the aggregate time effects and explodes the object to read into a df
  
  data.frame(Group= egt, ATT= att.egt, SE= se.egt) %>% 
  
  mutate_all(round, 2) %>%
  
  kbl(caption="Aggregate Group ATTs", 
      col.names = c("Group", "Aggregate ATT", "SE"),
      booktabs=T,
      format="latex",
      label="CSEst") %>%
  kable_styling(latex_options=c("striped", "hold_position", "condensed")) %>%
  
  write_lines(here("Tables/Table_CSEst.tex"))
