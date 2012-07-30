

# A set of custom options for ggplot
custom_opts <- function(...){
  opts(plot.title  = theme_text(vjust=1.5, face="bold"),
       axis.text.x= theme_text(angle=90, hjust=0.2, vjust = 0.5, colour="#646060"),
       axis.title.x = theme_text(vjust=0.2, face='bold'),
       axis.title.y = theme_text(vjust=0.2, face='bold', angle=90),
       axis.text.y = theme_text(colour="#696565"),
       axis.ticks = theme_segment(colour="#696565", size=0.1),
       panel.border = theme_rect(size=1))
}


# A re-implementation of an old function removed from ggplot 0.9
scale_y_log2 <- function(...){
  scale_y_continuous(trans="log2",
                     breaks=trans_breaks("log2", function(x) 2^x),
                     label=trans_format("log2", math_format(2^.x)))
}
