####################
# Title: TableGen_CSEstimation_Full
# Author: Robert Petit
# Desc: Generates the table of ATTGTs for all of the crimes covered
################

readRDS(file=here("Data/CS_ATTGTList.RDS")) %$% list(CS_Vio, CS_Mur, CS_Rap, CS_Aga) %>%
  foreach(x=., name=c("Vio", "Mur", "Rap", "Aga", "Prop", "Rob", "Aut", "Bur", "Lar"), .combine="cbind") %do% {
    x %>% aggte %$% cbind(att.egt, se.egt) -> IterColumn
    colnames(IterColumn) <- c(glue("{name}.ATT"), glue("{name}.SE"))
    IterColumn
  } %>% as.data.frame %>%
  mutate(year = 1987:1991) %>%
  select(year, everything()) %>%
  mutate_all(round, 2) %>%
  
  kbl(caption="Aggregate Group ATTs, Violent Crimes", 
      col.names = c("Group", "ATT", "SE","ATT", "SE", "ATT", "SE", "ATT", "SE"),
      booktabs=T,
      format="latex",
      label="CSEst") %>%
  kable_styling(latex_options=c("striped", "hold_position", "condensed")) %>%
  add_header_above(header=c(" ", "Violent"=2,"Murder"=2,"Rape"=2,"Assault"=2)) %>%
  
  write_lines(here("Tables/Table_CSEst_Vio.tex"))


  