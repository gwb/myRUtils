
"
Autor: Guillaume Basse
Date: 07 / 13 / 2012

Description: A function of the *ply family. The function takes a matrix, splits it by 'margins' ( 0 -> rows, 1 -> columns), 
             applies the function 'fn' on each slice, and then 'combine' the result (0 -> rbind, 1 -> cbind)

Arguments: 
  data     <- a matrix -- matrix to be processed
  margins  <- 1 or 2   -- how to split the original data (1 -> rows, 2 -> columns)
  fn       <- function -- a function that operates on the given slice. Note that the function can return *anything* that can be cbinded or rbinded. 
  combine  <- 1 or 2   -- how to combine the transformed data (1 -> rbind, 2 -> cbind)

Example:

# Example with a matrix
> a <- matrix(c(1,2,3,4), nrow=2, ncol=2, byrow=T)
=> a
     [,1] [,2]
[1,]    1    2
[2,]    3    4

> test.fn <- function (x){
  return(cbind(x[1], x[2], c(1,2,3)))
}

> test.fn(c(1,2))
=> 1 2 1
   1 2 2
   1 2 3

> sply(a, test.fn, 1, 1)
=>   [,1] [,2] [,3]
[1,]    1    2    1
[2,]    1    2    2
[3,]    1    2    3
[4,]    3    4    1
[5,]    3    4    2
[6,]    3    4    3

> sply(a, test.fn, 1, 2)
=>   [,1] [,2] [,3] [,4] [,5] [,6]
[1,]    1    2    1    3    4    1
[2,]    1    2    2    3    4    2
[3,]    1    2    3    3    4    3

# Example with a vector
> b <- c(1,2,3)

> test.fn2 <- function (x) {
  return(c(x+1, x+2, x+3))
}

> test.fn2(1)
=> [1] 2 3 4

sply(b, test.fn2, combine=1)
=>[,1] [,2] [,3]
1    2    3    4
2    3    4    5
3    4    5    6
sply(b, test.fn2, combine=2)


"

source("/Users/gwb/Hacks/Projects/RUtils/compose.R")

sply <- function(data, fn, margins=2, combine=2){
  
  ### If the data is a vector, convert it to a matrix of dimension (nrow = 1, ncol = length(data))
  data <- if (is.vector(data))  t(as.matrix(data)) else data
  
  ### Split the matrix into a list of elements on which the functions
  ### will be applied
  
  splitby <- if (margins == 1) row(data) else col(data)
  original_item_list = split(data, splitby)
  
  ### Apply the transforming function to each item of the list
  
  transformed_item_list = lapply(original_item_list, fn)
  
  ### Combine
  
  # cbind behavior is annoying if the items are not matrices
  transformed_item_list <- if (combine == 2 && is.vector(transformed_item_list[[1]])) lapply(transformed_item_list, t %o% as.matrix) else transformed_item_list
  
  transformed_data <- if (combine == 1) do.call("rbind", transformed_item_list) else do.call("cbind", transformed_item_list)
  
  # Remove the labels that got transfered the final matrix
  dimnames(transformed_data) <- NULL
  
  return(transformed_data) 
}


### Example

a <- matrix(c(1,2,3,4), nrow=2, ncol=2, byrow=T)
test.fn <- function (x){
  return(cbind(x[1], x[2], c(1,2,3)))
}
sply(a, test.fn, 1, 1)
sply(a, test.fn, 1, 2)


b <- c(1,2,3)
test.fn2 <- function (x) {
  return(c(x+1, x+2, x+3))
}
sply(b, test.fn2, combine=1)
sply(b, test.fn2, combine=2)

