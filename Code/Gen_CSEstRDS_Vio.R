read_dta(here("Data/CSData.dta")) %>% 
    att_gt(yname = "lRatVio",
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
                    panel=FALSE) %>%
  
  saveRDS(file=here("Data/CS_ATTGT.RDS"))
