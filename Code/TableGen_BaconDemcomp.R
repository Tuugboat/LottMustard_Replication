read_dta(here("Data/TWFE_Data_Factor.dta")) %>%
  filter(!is.na(year)) %>%
  bacon(lRatPro ~ shalll, data=.,
                     id_var="fipsstat", time_var="year", quietly=T) %>%
  group_by(type) %>%
  summarize(Weight = sum(weight), AvgEst = mean(estimate)) %>%
  kbl(caption="Bacon Decomposition", 
      col.names = c("Type", "Weight", "Average Est"),
      booktabs=T,
      format="latex",
      label="BDec") %>%
  kable_styling(latex_options=c("striped", "hold_position", "condensed")) %>%
  
  write_lines(here("Tables/Table_BaconDecomp.tex"))
