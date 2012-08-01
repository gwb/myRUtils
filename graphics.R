require(ggplot2)
require(reshape2)
require(grid)
require(scales)

theme_set(theme_bw())

# Stacking plots in a grid
stack_plots <- function(gs, nrow, ncol, fout=NULL, add_opts){
  # example: stack_plots(list(g1, g2, g3), 2, 2, function (x) opts(legend.position="bottom"))

  if(length(fout) > 0){
    pdf(fout, width=17, height=10)
  }

  grid.newpage()
  pushViewport(viewport(layout=grid.layout(nrow,ncol)))
  vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)

  curr_col = 1
  curr_row = 1
  for (i in seq(1, length(gs))){
    ng <- gs[[i]] + add_opts()
    print(ng, vp=vplayout(curr_row,curr_col))
    if (curr_col==ncol){
      curr_col = 1
      curr_row = curr_row + 1
    }else{
      curr_col = curr_col + 1
    }
  }
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
