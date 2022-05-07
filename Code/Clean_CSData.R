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
      "Alabama",1970,
      "Connecticut",1970,
      "Indiana",1970,
      "New Hampshire",1970,
      "North Dakota",1970,
      "South Dakota",1970,
      "Vermont",1970,
      "Washington",1970
    ),
    by="state") %>%
  mutate(GTime = coalesce(FirstTreat, GTime)) %>%
  select(-FirstTreat) %>%
  select(fipsstat, state, year, GTime, starts_with("lRat")) %>%
  write_dta(here("Data/CSData.dta"))
