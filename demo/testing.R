library(fastConcat)
library(data.table)

RowCount <- RowCount <- 5
DT <- data.table(x = "foo",
                 y = "bar",
                 a = sample.int(9, RowCount, TRUE),
                 b = sample.int(9, RowCount, TRUE),
                 c = sample.int(9, RowCount, TRUE),
                 d = sample.int(9, RowCount, TRUE),
                 e = sample.int(9, RowCount, TRUE),
                 f = sample.int(9, RowCount, TRUE))

## Generate an expression to paste an arbitrary list of columns together
ConcatCols <- list("a","b","c","d","e","f")
## Do it 3x as many times
ConcatCols <- c(ConcatCols,ConcatCols,ConcatCols)

## using fastConcat::concat

column_indices <- sapply(ConcatCols, FUN = function(x) { which(colnames(DT) == x )})
fastConcat::concat(DT, column_indices, ",")


column_indices
DT[,fastConcat::concat(DT,columns = c(3L,4L,5L), sep = ",")]


# Full 5 million rows -----------------------------------------------------

library(fastConcat)
library(data.table)

RowCount <- RowCount <- 5e6
DT <- data.table(x = "foo",
                 y = "bar",
                 a = sample.int(9, RowCount, TRUE),
                 b = sample.int(9, RowCount, TRUE),
                 c = sample.int(9, RowCount, TRUE),
                 d = sample.int(9, RowCount, TRUE),
                 e = sample.int(9, RowCount, TRUE),
                 f = sample.int(9, RowCount, TRUE))

## Generate an expression to paste an arbitrary list of columns together
ConcatCols <- list("a","b","c","d","e","f")
## Do it 3x as many times
ConcatCols <- c(ConcatCols,ConcatCols,ConcatCols)

## using fastConcat::concat with empty

preallocated_target <- character(RowCount)
column_indices <- sapply(ConcatCols, FUN = function(x) { which(colnames(DT) == x )})

DT[, State := fastConcat::concat(DT, preallocated_target, column_indices, as.integer(1), as.integer(RowCount), "")]




# Print  -----------------------------------------------------

library(fastConcat)
library(data.table)

RowCount <- 5
DT <- data.table(x = "foo",
                 y = "bar",
                 a = sample.int(9, RowCount, TRUE),
                 b = sample.int(9, RowCount, TRUE),
                 c = sample.int(9, RowCount, TRUE),
                 d = sample.int(9, RowCount, TRUE),
                 e = sample.int(9, RowCount, TRUE),
                 f = sample.int(9, RowCount, TRUE))

## Generate an expression to paste an arbitrary list of columns together
ConcatCols <- list("a","b","c","d","e","f")
## Do it 3x as many times
ConcatCols <- c(ConcatCols,ConcatCols,ConcatCols)

## using fastConcat::concat with empty

preallocated_target <- character(RowCount)
column_indices <- sapply(ConcatCols, FUN = function(x) { which(colnames(DT) == x )})

DT[, State := fastConcat::concat(DT, preallocated_target, column_indices, as.integer(1), as.integer(RowCount), "")]
print(DT)



# New SO Proposal ---------------------------------------------------------


library(data.table)

RowCount <- 1e7
DT <- data.table(x = "foo",
                 y = "bar",
                 a = sample.int(4, RowCount, TRUE),
                 b = sample.int(4, RowCount, TRUE),
                 c = sample.int(3, RowCount, TRUE),
                 d = sample.int(3, RowCount, TRUE),
                 e = sample.int(2, RowCount, TRUE),
                 f = sample.int(2, RowCount, TRUE),
                 g = sample.int(2, RowCount, TRUE),
                 h = sample.int(2, RowCount, TRUE),
                 i = sample.int(2, RowCount, TRUE),
                 j = sample.int(2, RowCount, TRUE),
                 k = 0L,
                 l = 0L,
                 m = 0L,
                 n = 0L,
                 o = 0L,
                 p = 0L,
                 q = 0L,
                 r = 0L)

## Generate an expression to paste an arbitrary list of columns together
ConcatCols <- c("a","b","c","d","e","f","g","h","i","j","l","l","m","n","o","p","q","r")

system.time({
  setkeyv(DT, ConcatCols)
  DTunique <- unique(DT[, ConcatCols, with=FALSE], by = key(DT))
  DTunique[, State :=  do.call(paste0, c(DTunique))]
  DT[DTunique, State := i.State, on = ConcatCols]
})



# Representative Data fastConcat::concat -----------------------------------------------------

library(fastConcat)
library(data.table)

RowCount <- 1e7
DT <- data.table(x = "foo",
                 y = "bar",
                 a = sample.int(4, RowCount, TRUE),
                 b = sample.int(4, RowCount, TRUE),
                 c = sample.int(3, RowCount, TRUE),
                 d = sample.int(3, RowCount, TRUE),
                 e = sample.int(2, RowCount, TRUE),
                 f = sample.int(2, RowCount, TRUE),
                 g = sample.int(2, RowCount, TRUE),
                 h = sample.int(2, RowCount, TRUE),
                 i = sample.int(2, RowCount, TRUE),
                 j = sample.int(2, RowCount, TRUE),
                 k = 0L,
                 l = 0L,
                 m = 0L,
                 n = 0L,
                 o = 0L,
                 p = 0L,
                 q = 0L,
                 r = 0L)

## Generate an expression to paste an arbitrary list of columns together
ConcatCols <- c("a","b","c","d","e","f","g","h","i","j","l","l","m","n","o","p","q","r")

## using fastConcat::concat with empty
system.time({
  preallocated_target <- character(RowCount)
  column_indices <- sapply(ConcatCols, FUN = function(x) { which(colnames(DT) == x )})
  DT[, State := fastConcat::concat(DT, preallocated_target, column_indices, as.integer(1), as.integer(RowCount), "")]
})


# rleid testing -----------------------------------------------------------

library(data.table)

a <- c(1,1,1,2,2,2,3,3,1,3,1,1,1)
b <- c(0,1,1,1,1,1,1,1,1,1,1,1,0)


rleid()
