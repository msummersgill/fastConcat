## fastConcat

> *Hopefully* allows fast concatenation of data.table columns by re-purposing some of the `data.table` package internals.

One trick pony Based off stack overflow question [Fast Concatenation of data.table columns](https://stackoverflow.com/questions/48233309/fast-concatenation-of-data-table-columns).

One function, `fastConcat::concat`.

*All the elegant C code actually came from the `data.table` package internals.*

Works, if all you want to concatenate is single digit integers for now.
 
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

column_indices <- sapply(ConcatCols, FUN = function(x) { which(colnames(DT) == x )})

DT[, State := fastConcat::concat(DT, column_indices, sep = "")]
print(DT)
```

```
     x   y a b c d e f              State
1: foo bar 8 9 7 8 3 3 897833897833897833
2: foo bar 2 5 6 1 5 5 256155256155256155
3: foo bar 1 1 6 5 8 9 116589116589116589
4: foo bar 2 5 2 6 3 4 252634252634252634
5: foo bar 3 7 1 1 9 1 371191371191371191
```



