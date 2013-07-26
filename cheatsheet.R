"
------------
R cheatsheet
------------

I see the following as a collection of intersting / useful snippets, that are very helpful, and
that often involve non-trivial R idioms. This is intended as a reference for all these helpful
constructs.
"


"
tapply

Description:
Essentially, tapply takes a sequence X, and a template sequence, INDEX. It factors the sequence INDEX, and apply
the same factorization to X, thus extracting the groups described in the INDEX sequence.

Note:
I identified 2 strategies for tapply. The benefits of the second strategie may not appear obvious at
first sight, but in practice, this strategy offers much more flexibility than the first one.
"

g <- expand.grid(transition=seq(1,5), peptide=seq(1,3), protein=seq(1,2))

# Strategy 1: Set X to be the values to extract from the groups
tapply(X=g$transition, INDEX=g$protein, FUN = function (x) mean(x))

# Strategy 2: set X to be the indices of the groups, instead of the values themselves
tapply(X=seq(along=g$transition), INDEX=g$protein, FUN = function (x) mean(g$transition[x]))



"
seq(along=x)

Description: exactly equivalent to:  seq(1, length(x))
"

x <- seq(1,10)
seq(along=x)


"
with(dt, ...)

Description: puts the names columns of the dataframe dt into scope. It is equivalent to:

attach(dt)
...
detach(dt)

"

dt <- dataframe(y=c(1,2,3), z=c(4,5,6))
with(dt, y + z)


"
rep(1:n, each=k)

Description: cycle through 1:n, repeating each elements k times
"

rep(1:5, each=3)


"
split(m, rep(1:n, each=k))

Description: an interesting combination that allows to split a matrix
by groups of columns or rows, using the implicit fact that a matrix is 
a vector (read by columns)
"

m <- matrix(c(1,2,3,4,5,6,7,8,9,10,11,12), nrow=4, byrow=T)
split(m, rep(1:2, each=2))


"
lapply(split(m, rep(1:n, each=k)), function (x) matrix(x, nrow=k))

Description: same as above, except that we reform the matrix in each element of the 
list (instead of leaving it as a vector).

This is also an opportunity to illustrate the use of lapply: simply applies a function 
to each item of a list (as opposed to vector)
"

lapply( split(m, rep(1:2, each=2)), function (x) matrix(x, nrow=2))


"
do.call(fun, lst)

Description: calls the function fun with the arguments in lst. Very, very useful function
"

do.call("cbind", list(c(1,2,3), c(1,2,3)))


"
ddply:  transform vs summarise vs custom

Description: transform adds columns while summarise creates a new dtframe with only the specified columns
a custom approch can also be used.

dt:

age     gender    weight   height
...

"

# this expression computes the mean weight and height for people of the same age and gender,
# and returns the same dt frame as before with *two extra columns*
ddply(dt, c(age, gender), transform, m.weight=mean(weight), m.height=mean(height))

# This computes the same columns as above, but returns a dataframe with *only these two new columns* 
ddply(dt, c(age, gender), summarise, m.weight=mean(weight), m.height=mean(height))

# note that we only have to worry about the "apply" part of split-apply-aggregate
ddply(dt, c(age, gender), function(ndt) return(data.frame(foo = mean(ndt$weight), bar = ndt$age[1])))


"
suppressPackageStartupMessages

description: loads a module without printing simple messages (still prints warnings)
"

suppressPackageStartupMessages(require(plyr))
