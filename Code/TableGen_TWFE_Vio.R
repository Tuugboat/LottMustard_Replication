####################
# Title: TableGen_TWFE
# Author: Robert Petit
# Desc: Doing and outputting the coefficients from the TWFE model
################

read_dta(here("Data/TWFE_Data_Factor.dta")) %>%
  mutate(year=factor(year), fipsstat=factor(fipsstat)) %>% 
  # One list to rule them  all
  { list(
  TWFE_Vio = feols(lRatVio ~ shalll + aovio + ppb + 
          ppbm1019 + ppbm2029 + ppbm3039 + ppbm4049 + ppbm5064 + ppbm65o +
          ppbf1019 + ppbf2029 + ppbf3039 + ppbf4049 + ppbf5064 + ppbf65o +
          ppwm1019 + ppwm2029 + ppwm3039 + ppwm4049 + ppwm5064 + ppwm65o +
          ppwf1019 + ppwf2029 + ppwf3039 + ppwf4049 + ppwf5064 + ppwf65o +
          ppnm1019 + ppnm2029 + ppnm3039 + ppnm4049 + ppnm5064 + ppnm65o +
          ppnf1019 + ppnf2029 + ppnf3039 + ppnf4049 + ppnf5064 + ppnf65o
        | year + fipsstat, data=., se="twoway"),
  
  TWFE_Mur = feols(lRatMur ~ shalll + aomur + ppb + 
             ppbm1019 + ppbm2029 + ppbm3039 + ppbm4049 + ppbm5064 + ppbm65o +
             ppbf1019 + ppbf2029 + ppbf3039 + ppbf4049 + ppbf5064 + ppbf65o +
             ppwm1019 + ppwm2029 + ppwm3039 + ppwm4049 + ppwm5064 + ppwm65o +
             ppwf1019 + ppwf2029 + ppwf3039 + ppwf4049 + ppwf5064 + ppwf65o +
             ppnm1019 + ppnm2029 + ppnm3039 + ppnm4049 + ppnm5064 + ppnm65o +
             ppnf1019 + ppnf2029 + ppnf3039 + ppnf4049 + ppnf5064 + ppnf65o
           | year + fipsstat, data=., se="twoway"),
  
  TWFE_Rap = feols(lRatRap ~ shalll + aorap + ppb + 
                    ppbm1019 + ppbm2029 + ppbm3039 + ppbm4049 + ppbm5064 + ppbm65o +
                    ppbf1019 + ppbf2029 + ppbf3039 + ppbf4049 + ppbf5064 + ppbf65o +
                    ppwm1019 + ppwm2029 + ppwm3039 + ppwm4049 + ppwm5064 + ppwm65o +
                    ppwf1019 + ppwf2029 + ppwf3039 + ppwf4049 + ppwf5064 + ppwf65o +
                    ppnm1019 + ppnm2029 + ppnm3039 + ppnm4049 + ppnm5064 + ppnm65o +
                    ppnf1019 + ppnf2029 + ppnf3039 + ppnf4049 + ppnf5064 + ppnf65o
                  | year + fipsstat, data=., se="twoway"),
  
  TWFE_Aga = feols(lRatAga ~ shalll + aoaga + ppb + 
          ppbm1019 + ppbm2029 + ppbm3039 + ppbm4049 + ppbm5064 + ppbm65o +
          ppbf1019 + ppbf2029 + ppbf3039 + ppbf4049 + ppbf5064 + ppbf65o +
          ppwm1019 + ppwm2029 + ppwm3039 + ppwm4049 + ppwm5064 + ppwm65o +
          ppwf1019 + ppwf2029 + ppwf3039 + ppwf4049 + ppwf5064 + ppwf65o +
          ppnm1019 + ppnm2029 + ppnm3039 + ppnm4049 + ppnm5064 + ppnm65o +
          ppnf1019 + ppnf2029 + ppnf3039 + ppnf4049 + ppnf5064 + ppnf65o
        | year + fipsstat, data=., se="twoway")
  ) } %>%
  # Send this to a table
  etable(coefstat="se",
                 dict=c(shalll="Treatment",
                        lRatVio="Violent",
                        lRatPro = "Property",
                        lRatMur = "Murder",
                        lRatRap = "Rape",
                        lRatAga = "Assault",
                        lRatRob = "Robbery",
                        lRatAut = "Auto",
                        lRatBur = "Burglary",
                        lRatLar = "Larceny"),
                 keep="(Treatment)",
         tex=T, file=here("Tables/Table_TWFEVio.tex"))

































