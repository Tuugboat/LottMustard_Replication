####################
# Title: TableGen_CSEventStudy
# Author: Robert Petit
# Desc: Generates table for the Event study
################

readRDS(here("Data/CS_ATTGT.RDS")) %>%
  #Grabs the out_tibble from the event_study data structure (the kable-relevant chunk)
  event_study_CS() %$%
  out_tibble %>%
  
  #The only table-relevant columns
  select(event_time, es_coeff, se_es, lower_pointwise, upper_pointwise) %>%
  
  # Trim the table's ends for convenience
  filter(event_time>=-5, event_time<=10) %>%
  
  # Table shenanigans
  kbl(caption="Event Study",
      col.names=c("Event Time", "Coefficient", "SE", "Lower", "Upper"),
      booktabs=T,
      format="latex",
      label="SAEst") %>%
  kable_styling(latex_options=c("striped", "condensed")) %>%
  add_header_above(header=c(" " =3, "95% Confidence Interval"=2)) %>%
  
  write_lines(here("Tables/Table_SA_ES.tex"))
  
