####################
# Title: TableGen_CSEstimation_Pro
# Author: Robert Petit
# Desc: Generates the table of ATTGTs for property crimes
################

readRDS(file=here("Data/CS_ATTGTList.RDS")) %$% list(CS_Prop, CS_Rob, CS_Aut, CS_Bur, CS_Lar) %>%
  foreach(x=., name=c("Vio", "Mur", "Rap", "Aga", "Prop", "Rob", "Aut", "Bur", "Lar"), .combine="cbind") %do% {
    x %>% aggte %$% cbind(att.egt, se.egt) -> IterColumn
    colnames(IterColumn) <- c(glue("{name}.ATT"), glue("{name}.SE"))
    IterColumn
  } %>% as.data.frame %>%
  mutate(year = 1987:1991) %>%
  select(year, everything()) %>%
  mutate_all(round, 2) %>%
  
  kbl(caption="Aggregate Group ATTs, Property Crimes", 
      col.names = c("Group", "ATT", "SE", "ATT", "SE", "ATT", "SE","ATT", "SE","ATT", "SE"),
      booktabs=T,
      format="latex",
      label="CSEst") %>%
  kable_styling(latex_options=c("striped", "hold_position", "condensed")) %>%
  add_header_above(header=c(" ","Property"=2,"Robery"=2,"Auto"=2,"Burglary"=2,"Larceny"=2)) %>%
  
  write_lines(here("Tables/Table_CSEst_Pro.tex"))
