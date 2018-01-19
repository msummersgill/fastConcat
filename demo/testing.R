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

preallocated_target <- character(RowCount)
column_indices <- sapply(ConcatCols, FUN = function(x) { which(colnames(DT) == x )})
fastConcat::concat(DT, preallocated_target, column_indices, as.integer(1), as.integer(RowCount), "")



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

## using fastConcat::concat with empty

preallocated_target <- character(RowCount)
column_indices <- sapply(ConcatCols, FUN = function(x) { which(colnames(DT) == x )})

DT[, State := fastConcat::concat(DT, preallocated_target, column_indices, as.integer(1), as.integer(RowCount), "")]
print(DT)
