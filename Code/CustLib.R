####################
# Title: CustLib
# Author: Robert Petit
# Desc: Handwritten functions that we want loaded at startup. A lot of these are for use with did
# Code pulled from Cunninghams /Code
################

# event
event_study_CS <- function(atts,
                           time = c(-Inf, Inf), 
                           nboot = 1000, 
                           alp = 0.05){
  
  # First, let's run the aggte function in the did package
  es <- did::aggte(atts, type = "dynamic", bstrap = FALSE, alp = alp, clustervars = NULL,
                   cband = FALSE, na.rm = TRUE)
  # do the selection of event times using the "time" argument of the function
  e_select <- (es$egt >= time[1]) & (es$egt <= time[2])
  egt <- es$egt[e_select]
  # get the event-study estimates and their influence functions
  es_att <- es$att.egt[e_select]
  es_inf_function <- es$inf.function$dynamic.inf.func.e[, e_select]
  
  # Now, do the bootstrap
  parameters_boot <- atts$DIDparams
  parameters_boot$biters <- nboot
  parameters_boot$alp <- alp
  parameters_boot$cband <- TRUE
  parameters_boot$bstrap <- TRUE
  bootst_es <- did::mboot(es_inf_function, parameters_boot)
  
  # Compute the aggregated summary measure (average over the positive event-times selected)
  epost <- (es$egt >= time[1]) & (es$egt <= time[2]) & (es$egt >= 0)
  egt_post <- es$egt[epost]
  aggte_es <- base::mean(es$att.egt[epost])
  aggte_es_inf_function <- base::rowMeans(es$inf.function$dynamic.inf.func.e[, epost])
  
  # bootstrap for the aggregated summary measure
  bootst_es_aggte <- did::mboot(aggte_es_inf_function, parameters_boot)
  
  # Put all the results into a tibble
  event_study_out <-
    tibble::tibble(
      event_time      = egt,
      es_coeff        = es_att,
      se_es           = bootst_es$se,
      simult_cv_es    = bootst_es$crit.val,
      pointwise_cv_es = stats::qnorm(1 - (alp/2))
    ) %>%
    mutate(
      lower_pointwise   = es_coeff - pointwise_cv_es * se_es,
      upper_pointwise   = es_coeff + pointwise_cv_es * se_es,
      lower_simult      = es_coeff - simult_cv_es * se_es,
      upper_simult      = es_coeff + simult_cv_es * se_es
    ) %>%
    filter(event_time >= time[1], event_time <= time[2])
  
  out <- list(
    event_time      = egt,
    es_coeff        = es_att,
    se_es           = bootst_es$se,
    simult_cv_es    = bootst_es$crit.val,
    pointwise_cv_es = stats::qnorm(1 - (alp/2)),
    es_aggte        = aggte_es,
    se_aggte_es     = bootst_es_aggte$se,
    out_tibble      = event_study_out
  )
  return (out)
}
