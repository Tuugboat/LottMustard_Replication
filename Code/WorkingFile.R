############################################################################
#Name: WorkingFile.R
#Author: Robert Petit
#Description: THERE IS NOTHING IMPORTANT HERE. This file is /entirely/ for data exploration and notes for later
############################################################################

StateCrime = read_dta(here("Data/UpdatedStateLevelData-2010.dta"))
colnames(StateCrime)

#################################################
# Working with did

#Callaway-Sant'anna estimator

YearTable <- tribble(
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
  
  # Rollout years of 0 are for states that already had Shall-issue laws in place
  # Before out sample starts in 1977. 
  # 0 values are replaced by a string after sorting
  
  "Alabama",1977,
  "Connecticut",1977,
  "Indiana",1977,
  "New Hampshire",1977,
  "North Dakota",1977,
  "South Dakota",1977,
  "Vermont",1977,
  "Washington",1977
)

StateCrime <- read_dta(here("Data/UpdatedStateLevelData-2010.dta")) %>%
  mutate(GTime = 0) %>%
  left_join(YearTable, by="state") %>%
  mutate(GTime = coalesce(FirstTreat, GTime)) %>%
  select(-FirstTreat)

cs_atts <- att_gt(yname = "vio",
               tname = "year",
               idname = "fipsstat",
               gname = "GTime",
               data = StateCrime,
               #xformla = ~ i.id + i.date,
               est_method = "dr",
               control_group = "notyettreated",
               bstrap = FALSE,
               #biters = nboot,
               print_details = F,
               clustervars = NULL,
               panel = TRUE)

summary(aggte(cs_atts)) # Aggregate ATT

#Important summary to data frame
CS_Frame <- cs_atts %>%
  aggte %>%
  # Note for future: putting this inside the brackets is what makes this interperet correctly
  # Otherwise it is read as data.frame(aggte, Group=aggte$egt ...)
  # See the tidyverse pipe reference 'using dot for secondary purposes' for full text
  { data.frame(Group= .$egt, ATT= .$att.egt, SE= .$se.egt) }

CS_FancyFrame <- cs_atts %>%
  aggte %$%
  # Alternate functionality with the exploding pipe
  data.frame(Group= egt, ATT= att.egt, SE= se.egt) %>%


# OLD GRAPHS OF COUNTY/STATE CRIME
CountyCrime = read_dta(here("Data/UpdatedCountyCrimeData-2010.dta"))

CountyCrime %<>% filter(year<1993)

CountyCrime_ByYear = CountyCrime %>%
  group_by(year) %>%
  summarize(Avg_RatMur = mean(ratmur))

head(CountyCrime_ByYear, 16)

 CountyCrime_ByYear_Line = ggplot(data=CountyCrime_ByYear,mapping=aes(year, Avg_RatMur)) +
  geom_line(mapping=aes(year, Avg_RatMur), col='red') +
  #geom_line(mapping=aes(year, Avg_RatRap), col='blue') +
  #geom_line(mapping=aes(year, Avg_RatAga), col='blue') +
  theme_minimal() +
  labs(title="Average Murder Rate per county by year")
CountyCrime_ByYear_Line

#################################################
#Working through State Level data to check the differences between the state and county (assumed that county has more measurement error)



Murder_ByState_Avg = StateCrime %>%
  group_by(state, year) %>%
  summarize(MurRate = murder/(popstate/1000000)) %>%
  group_by(year) %>%
  summarize(MurRate_Avg = mean(MurRate))

Murder_ByState_Plot = ggplot(data=Murder_ByState_Avg) +
  geom_line(aes(year, MurRate_Avg)) +
  theme_minimal()
Murder_ByState_Plot

#################################################
# Nate-provided code to help understand some important functions for building tables

summary_table <-
  mtcars %>%
  summarize(across(
    c(mpg, cyl, hp),
    list(
      "N. Obs" = length,
      "Mean" = mean,
      "Std. Dev" = sd
    )
  )) %>%
  pivot_longer(
    cols = everything(),
    names_sep = "_",
    names_to = c("Variable", ".value")
  )

translation_table <- tribble(
  ~short_name, ~long_name,
  "mpg", "Miles per Gallon",
  "cyl", "Cylinders"
)     

renamed_table <-
  summary_table %>%
  left_join(translation_table, c("Variable"="short_name")) %>%
  mutate(Variable=coalesce(long_name, Variable)) %>%
  select(-long_name)
