
"
Autor: Guillaume Basse
Date: 07 / 13 / 2012
Description: An infix operator for function composition

Example: 

> (`-` %o% abs %o% sum) (c(1,2,3))
=> -6


> (t %o% as.matrix) (c(1,2,3))
=>   [,1] [,2] [,3]
[1,]    1    2    3


# A more elaborate and interesting result

> a = list(c(1,2,3), c(4,5,6))
> lapply(a, ( `-` %o% abs %o% sum))    # instead of the ugly lapply(a, function (x) -abs(sum(x)))


# Functional kung-fu

> b = c(1,2,3)

> sply(b, as.matrix %o% (flip(rep) %p% 3), combine=2 )
=>   [,1] [,2] [,3]
[1,]    1    2    3
[2,]    1    2    3
[3,]    1    2    3


"




# The composition operator
"%o%" <- function(fn1, fn2){
  return(function(x) return(fn1(fn2(x))))
} 

# The partial application operator
"%p%" <- function(fn, a, ...){
  return(function(...) return(fn(a, ...)))
}

# Flips the parameters of a function
flip <- function(fn){
  return(function(a,b) return(fn(b,a))) 
}






# Examples
# (`-` %o% abs %o% sum) (c(1,2,3))
# (t %o% as.matrix) (c(1,2,3))
# a = list(c(1,2,3), c(4,5,6))
# lapply(a, ( `-` %o% sum))    # instead of the ugly lapply(a, function (x) -sum(x))
#b = c(1,2,3)
#sply(b, as.matrix %o% (flip(rep) %p% 3), combine=2 )
