#A collection of helper functions in R.

## graphics.R
A collection of functions for working with graphics (mainly ggplot2)
  - scale\_y\_log2: A reimplementation of the function removed from ggplot2 v0.9
  - custom_opts: A set of custom options for ggplot2

## sply.R
A function for dataframes manipulations
  - sply: similar to the *ply function, but allows the mapping function to have any shape. See examples

## compose.R: 
A collection of functions and operators providing an erzats of functional programming syntax
  - %o% : the composition operator.
  - %p% : the partial application operator.
  - flip : a higher order function that flip the arguments of a function.

examples:
```r
lapply( list( c(1,2,3), c(2,3,4) ), `-` %o% abs %o% sum)
sply(c(1,2,3), as.matrix %o% (flip(rep) %p% 3), combine=2) 
```
