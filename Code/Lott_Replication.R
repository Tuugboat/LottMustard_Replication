############################################################################
#Name: Lott_Replication.R
#Author: Robert Petit
#Description: Replicating lott and mustard data
#Last updated Feb 16, 2022
############################################################################
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

StateCrime = read_dta(here("Data/UpdatedStateLevelData-2010.dta"))

Murder_ByState_Avg = StateCrime %>%
  group_by(state, year) %>%
  summarize(MurRate = murder/(popstate/1000000)) %>%
  group_by(year) %>%
  summarize(MurRate_Avg = mean(MurRate))

Murder_ByState_Plot = ggplot(data=Murder_ByState_Avg) +
  geom_line(aes(year, MurRate_Avg)) +
  theme_minimal()
Murder_ByState_Plot
