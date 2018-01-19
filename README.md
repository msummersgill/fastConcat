## fastConcat

> *Hopefully* allows fast concatenation of data.table columns.

One trick pony Based off stack overflow question [Fast Concatenation of data.table columns](https://stackoverflow.com/questions/48233309/fast-concatenation-of-data-table-columns).

One function, `fastConcat::concat`.

All the elegant C code actually came from the `data.table` package internals.

 Works, if all you want to concatenate is single digit integers.
 
```r
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

preallocated_target <- character(RowCount)
column_indices <- sapply(ConcatCols, FUN = function(x) { which(colnames(DT) == x )})

DT[, State := fastConcat::concat(DT, preallocated_target, column_indices, as.integer(1), as.integer(RowCount))]
print(DT)
```

```
     x   y a b c d e f                               State
1: foo bar 3 7 6 5 4 3 3,7,6,5,4,3,3,7,6,5,4,3,3,7,6,5,4,3
2: foo bar 2 4 1 1 7 1 2,4,1,1,7,1,2,4,1,1,7,1,2,4,1,1,7,1
3: foo bar 8 6 2 9 7 6 8,6,2,9,7,6,8,6,2,9,7,6,8,6,2,9,7,6
4: foo bar 7 3 5 5 2 8 7,3,5,5,2,8,7,3,5,5,2,8,7,3,5,5,2,8
5: foo bar 9 5 3 6 9 1 9,5,3,6,9,1,9,5,3,6,9,1,9,5,3,6,9,1
```



