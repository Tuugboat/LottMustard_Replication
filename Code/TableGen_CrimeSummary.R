####################
# Title: TableGen_CrimeSummary
# Author: Robert Petit
# Desc: Builds a table of summary statistics for the state level crime data
################

read_dta(here("Data/UpdatedStateLevelData-2010.dta")) %>%

  # First we just isolate the variables that we want
  select(vio, prop, murder, rape, assault, rob, auto, burg, larc, starts_with("rat")) %>% #These are the important variables that we want to summarize
  select(-ratrap2, -ratgaga) %>% 
  #we drop ratrap2 which *seems* to be identical to ratrap. 
  # ragaga comes from g_assault and I cannot find what it is. Regardless, agaravated assault is included and it doesn't seem like we need anything else
  
  # Summarizing variables
  # Syntax is weird here because across() and summarize() work together for some cool voodoo
  # The basic idea is to get [Variable]_[Summary] for each of the important statistics nationwide
  summarize(across(everything(),
    list(
      "N. Obs" = length,
      "Mean" = function(x) { mean(x, na.rm=T) }, #I can't figure out another way to pass the na.rm flag in this context. There are certainly cleaner ways but this works
      "Std. Dev" = function(x) {sd(x, na.rm=T)}
    )
    )) %>%
  
  # This is very similiar to melt(), but better to learn.
  # Note that the excel pivot is allegedly the same, but the tidyverse vignette is /far/ more informative
  pivot_longer(
    cols=everything(),
    names_sep="_",
    names_to = c("Variable", ".value")
  ) %>%
  
  #Finally, we need to rename the variables with left_join() and coalesce() (coalesce is pretty much the same as SQL)
  left_join(
    
    # We build the tribble in place because we are just FULL of bad ideas today
    # Sort variables help us to ensure that all of the variables appear in the order that we want
    tribble(~Plain, ~Fancy, ~Sort,
            "vio", "Violent Crimes", 1,
            "prop", "Property Crimes", 2,
            "murder", "Murder", 3,
            "rape", "Rape", 4,
            "assault", "Assault", 5,
            "rob", "Robbery", 6,
            "auto", "Auto Theft", 7,
            "burg", "Burglary", 8,
            "larc", "Larceny", 9,
            "ratmur", "Murder Rate", 12,
            "ratrap", "Rape Rate", 13,
            "rataga", "Assault Rate", 14,
            "ratrob", "Robbery Rate", 15,
            "rataut", "Auto Theft Rate", 16,
            "ratbur", "Burglary Rate", 17,
            "ratlar", "Larceny Rate", 18,
            "ratvio", "Violent Crime Rate", 10,
            "ratpro", "Property Crime Rate", 11),
  c("Variable" = "Plain")) %>%
  
  #We like coalesce because it stops errors from being thrown (generally)
  mutate(Variable = coalesce(Fancy, Variable)) %>%
  arrange(Sort) %>%
  select(-Fancy, -Sort) %>% #Drop the working variables
  
  #Last transformation is to just round to the appropriate length to make the table pretty
  mutate_if(is.numeric, round, 2) %>%
  
  kbl(caption="Summary Statistics for Statewide Yearly Crimes and Crime Rates",
      booktabs=T,
      format="latex",
      label="CrimeSummary") %>%
  kable_styling(latex_options=c("striped", "hold_position")) %>%
  
  kableExtra::group_rows("Crime Counts", 1, 9) %>%
  kableExtra::group_rows("Crime Rates", 10, 18) %>%
  
  write_lines(here("Tables/Table_CrimeSummary.tex"))
