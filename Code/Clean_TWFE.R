read_dta(here("Data/UpdatedStateLevelData-2010.dta")) %>%
  # Calculating the outcomes of interest (log crime rate)
  mutate(lRatMur = log(ratmur),
         lRatRap = log(ratrap),
         lRatAga = log(rataga),
         lRatRob = log(ratrob),
         lRatAut = log(rataut),
         lRatBur = log(ratbur),
         lRatLar = log(ratlar),
         lRatVio = log(ratvio),
         lRatPro = log(ratpro)) %>%
  select(shalll, # Treat variable
         starts_with("lRat"), # Outcome of interest
         starts_with("ao"), # Endogenous Control
         # Demographic controls
         rpcpi, rpcui, rpcim, rpcrpo,
         starts_with("ppb"),
         starts_with("ppw"),
         starts_with("ppn"),
         year,
         fipsstat) %>%
  mutate(year=factor(year), fipsstat=factor(fipsstat)) %>%
  write_dta(here("Data/TWFE_Data_Factor.dta"))

# # If, for some reason, factors don't work, the below will do fine.
# read_dta(here("Data/UpdatedStateLevelData-2010.dta")) %>%
#   # Calculating the outcomes of interest (log crime rate)
#   mutate(lRatMur = log(ratmur),
#          lRatRap = log(ratrap),
#          lRatAga = log(rataga),
#          lRatRob = log(ratrob),
#          lRatAut = log(rataut),
#          lRatBur = log(ratbur),
#          lRatLar = log(ratlar),
#          lRatVio = log(ratvio),
#          lRatPro = log(ratpro)) %>%
#   select(shalll, # Treat variable
#          starts_with("lRat"), # Outcome of interest
#          starts_with("ao"), # Endogenous Control
#          # Demographic controls
#          rpcpi, rpcui, rpcim, rpcrpo,
#          starts_with("ppb"),
#          starts_with("ppw"),
#          starts_with("ppn"),
#          # Year dummies (For first FE)
#          starts_with("yr"),
#          # State dummies (For second FE)
#          AK,AL,AZ,AR,CA,CO,CT,DE,FL,GA,DC,HI,IA,ID,IL,IN,KS,KY,
#          LA,MA,MD,ME,MI,MN,MO,MS,MT,NC,ND,NE,NH,NJ,NM,NV,NY,
#          OH,OK,OR,PA,RI,SC,SD,TN,TX,UT,VA,VT,WA,WI,WV,WY
#   ) %>%
#   write_dta(here("Data/TWFE_Data.dta"))