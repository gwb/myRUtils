require(ggplot2)
require(reshape2)
require(grid)
require(gridExtra)
require(scales)

theme_set(theme_bw())

# Stacking plots in a grid
stack_plots <- function(gs, nrow, ncol, fout=NULL, add_opts=function(){}, title.common=NULL, legend.common=NULL, axis.common=NULL, beautify=T){
  
  # Extract the common legen
  tmp <- ggplot_gtable(ggplot_build(gs[[1]]))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]

  # Applies add_opts to plots and beautify
  if (beautify){
    gs <- lapply(gs, function(x) x + custom_opts())
  }
  gs <- lapply(gs, function(x) x + add_opts())

  # MAYBE: Removes individual legend
  if (legend.common){
    
    gs <- lapply(gs, function(x) x + opts(legend.position="none"))
    
  }
  
  # MAYBE: Adds common title
  if (length(title.common) > 0){
    
    title.common <- textGrob(paste("\n", title.common, sep=""), gp=gpar(fontface="bold", cex=1.5), hjust= 0.7)
    title.space = 4
    
  }else{
    title.common <- textGrob("")
    title.space = 2
  }

  # MAYBE: Adds common axis label
  if (length(axis.common) > 0){
    
    gs <- lapply(gs, function (x) x + xlab("") + ylab(""))
    xlabel <- textGrob(paste(axis.common[1], "\n", sep=""), gp=gpar(fontface="bold"))
    ylabel <- textGrob(paste("\n", axis.common[2], sep=""), gp=gpar(fontface="bold"), rot=90)
    
  }else{
    xlabel <- textGrob("")
    ylabel <- textGrob("")
  }
  
  # Create the plots
  gs <- c(gs, nrow=nrow, ncol=ncol)
  main.grob <- do.call(arrangeGrob, gs)

  # --- if a filepath has been specified, opens the output device
  if(length(fout) > 0){
    pdf(fout, width=17, height=10)
  }

  # --- the plotting part
  if (length(legend.common)>0){
      grid.arrange(title.common,
                   arrangeGrob(ylabel, main.grob, legend, widths=unit.c(unit(2,"lines"), unit(1, "npc") - legend$width - unit(2,"lines"), legend$width), nrow=1),
                   xlabel,
                   heights=unit.c(unit(title.space,"lines"), unit(1,"npc") - unit(title.space,"lines") - unit(2, "lines"), unit(2,"lines")), nrow=3)
  }else{
      grid.arrange(title.common,
                   arrangeGrob(ylabel, main.grob, widths=unit.c(unit(2,"lines"), unit(1, "npc") - unit(2,"lines")), nrow=1),
                   xlabel,
                   heights=unit.c(unit(title.space,"lines"), unit(1,"npc") - unit(title.space,"lines") - unit(2, "lines"), unit(2,"lines")), nrow=3)
  }

  
  # --- closes the output device if specified
  if(length(fout) > 0){
    dev.off()
  }
  
}


# A set of custom options for ggplot
custom_opts <- function(...){
  opts(plot.title  = theme_text(vjust=1.5, face="bold"),
       axis.text.x= theme_text(angle=90, hjust=0.2, vjust = 0.5, colour="#696565"),
       axis.title.x = theme_text(vjust=0.2, face='bold'),
       axis.title.y = theme_text(vjust=0.2, face='bold', angle=90),
       axis.text.y = theme_text(colour="#696565"),
       legend.text = theme_text(colour="#505050"),
       axis.ticks = theme_segment(colour="#696565", size=0.1),
       panel.border = theme_rect(size=1))
}


# A re-implementation of an old function removed from ggplot 0.9
scale_y_log2 <- function(...){
  scale_y_continuous(trans="log2",
                     breaks=trans_breaks("log2", function(x) 2^x),
                     label=trans_format("log2", math_format(2^.x)))
}

scale_x_log2 <- function(...){
  scale_x_continuous(trans="log2",
                     breaks=trans_breaks("log2", function(x) 2^x),
                     label=trans_format("log2", math_format(2^.x)))
}

# A re-implementation of an old function removed from ggplot 0.9
scale_y_log10 <- function(...){
  scale_y_continuous(trans="log10",
                     breaks=trans_breaks("log10", function(x) 10^x),
                     label=trans_format("log10", math_format(10^.x)))
}

scale_x_log10 <- function(...){
  scale_x_continuous(trans="log10",
                     breaks=trans_breaks("log10", function(x) 10^x),
                     label=trans_format("log10", math_format(10^.x)))
}

# A re-implementation of an old function removed from ggplot 0.9
scale_y_log <- function(...){
  scale_y_continuous(trans="log",
                     breaks=trans_breaks("log", function(x) exp(x)),
                     label=trans_format("log", math_format(e^.x)))
}

scale_x_log <- function(...){
  scale_x_continuous(trans="log",
                     breaks=trans_breaks("log", function(x) exp(x)),
                     label=trans_format("log", math_format(e^.x)))
}
