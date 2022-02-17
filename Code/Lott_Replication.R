############################################################################
#Name: Lott_Replication.R
#Author: Robert Petit
#Description: Replicating lott and mustard data
#Last updated Feb 16, 2022
############################################################################
CountyCrime = read_dta(here("Data/UpdatedCountyCrimeData-2010.dta"))

CountyCrime %<>% filter(year<1993) %>% arrange(desc(year))

CountyCrime_ByYear = CountyCrime %>%
  group_by(year) %>%
  summarize(Avg_RatMur = mean(ratmur, na.rm=TRUE),
            Avg_RatRap = mean(ratrap, na.rm=TRUE),
            Avg_RatAgg = mean(ratagg, na.rm=TRUE))

head(CountyCrime_ByYear, 16)

CountyCrime_ByYear_Line = ggplot(data=CountyCrime_ByYear,mapping=aes(year, Avg_RatMur)) +
  geom_line(mapping=aes(year, Avg_RatMur), col='red') +
  geom_line(mapping=aes(year, Avg_RatRap), col='blue') +
  geom_line(mapping=aes(year, Avg_RatAgg), col='blue') +
  theme_minimal()
CountyCrime_ByYear_Line
