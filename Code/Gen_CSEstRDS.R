####################
# Title: Gen_CSEstRDS
# Author: Robert Petit
# Desc: Generates the CS Estimator (See Callaway and Sant'anna 2021) to load into other figures
# This is useful since the same estimation is used for a few figures and I want it all in one place
# Saving to an RDS is probably not the most efficient way to accomplish this
################
read_dta(here("Data/UpdatedStateLevelData-2010.dta")) %>%
  mutate(GTime = 0) %>%
  left_join(
    # This tribble originates from _LawRollout.R
    # Still trying to find a better way to do this all at one without having the huge tribble in the middle
    tribble(
      ~state, ~FirstTreat,
      "Florida", 1987,
      "Georgia", 1989,
      "Idaho", 1990,
      "Maine", 1989,
      "Mississipi", 1990,
      "Montana", 1991,
      "Oregon", 1989,
      "Pennsylvania", 1989,
      "Virginia", 1988,
      "West Virginia", 1989,
      "Alabama",1977,
      "Connecticut",1977,
      "Indiana",1977,
      "New Hampshire",1977,
      "North Dakota",1977,
      "South Dakota",1977,
      "Vermont",1977,
      "Washington",1977
    ),
    by="state") %>%
  mutate(GTime = coalesce(FirstTreat, GTime)) %>%
  select(-FirstTreat) %>%
  
  # Compute ATTs
  att_gt(yname = "vio",
         tname = "year",
         idname = "fipsstat",
         gname = "GTime",
         data = .,
         #xformla = ~ i.id + i.date,
         est_method = "dr",
         control_group = "notyettreated",
         bstrap = FALSE,
         #biters = nboot,
         print_details = F,
         clustervars = NULL,
         panel = TRUE) %>%
  
  saveRDS(file=here("Data/CS_ATTGT.RDS"))
