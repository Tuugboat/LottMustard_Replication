####################
# Title: TableGen_LawRollout
# Author: Robert Petit
# Desc: Generates table 1 for LottMustardReplication_Writeup. \
# Note: Data is hand-transcribed from Lott Mustard 1997 and Cramer Kopel 1995
################

tribble(
  ~State, ~Rollout,
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
 
  "Alabama",0,
  "Connecticut",0,
  "Indiana",0,
  "New Hampshire",0,
  "North Dakota",0,
  "South Dakota",0,
  "Vermont",0,
  "Washington",0
) %>%
  arrange(Rollout) %>%
  mutate(Rollout=replace(Rollout, Rollout==0, "Pre-1977")) %>%
  

kbl(caption="Shall-Issue Law Rollouts by State",
       booktabs=T,
       format="latex",
       label="LawRollout") %>%
  kable_styling(latex_options=c("striped", "HOLD_position", "condensed")) %>%
  
  write_lines(here("Tables/Table_LawRollout.tex"))
  

