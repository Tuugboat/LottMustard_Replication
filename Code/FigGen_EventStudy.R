readRDS(here("Data/CS_ATTGT.RDS")) %>%
  event_study_CS() %>%
{ ggplot2::ggplot(.$out_tibble,
                aes(x=event_time, y=es_coeff, ymin = lower_simult,
                    ymax = upper_simult)) +
  geom_line(aes(x=event_time, y=es_coeff), size = 1.5, colour = "red2") +
  geom_hline(yintercept = 0, colour="black", size = 0.5, linetype = "dashed")+
  geom_vline(xintercept = 0, colour="black", size = 0.5, linetype = "dashed")+
  geom_ribbon(aes(ymin= lower_pointwise, 
                  ymax= upper_pointwise), alpha = 0.4) +
  geom_ribbon(aes(ymin= lower_simult, 
                  ymax= upper_simult), alpha = 0.35) +
  theme_minimal()+
  #theme(axis.title = element_text(color="black",  size=15))+
  #theme(axis.text.y = element_text(size = 12, face = "bold", color="black"))+
  #theme(axis.text.x = element_text(size = 12, face = "bold",color="black"))+
  theme(plot.caption = element_text(size = 12, face = "bold",color="black"))+
  scale_x_continuous("Event time",
                     breaks = seq(min(.$event_time), max(.$event_time), by = 1)) +
  scale_y_continuous("Event-study coefficients", breaks = scales::pretty_breaks()) + 
  labs(caption = glue("Overall Effect: {round(.$es_aggte, 4)}
                      CI: [{round(.$es_aggte - .$pointwise_cv_es * .$se_aggte_es, 4)},\\
                      {round(.$es_aggte + .$pointwise_cv_es * .$se_aggte_es, 4)}]"))
} %>%
  ggsave(here("Figures/SA_EventStudy.png"), plot=., bg="white", width=8, height=4.5)
