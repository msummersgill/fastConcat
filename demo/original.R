library(inline)
library(data.table)
library(stringi)

header <- "

//Taken from https://github.com/Rdatatable/data.table/blob/master/src/fwrite.c
static inline void reverse(char *upp, char *low)
{
  upp--;
  while (upp>low) {
  char tmp = *upp;
  *upp = *low;
  *low = tmp;
  upp--;
  low++;
  }
}

void writeInt32(int *col, size_t row, char **pch)
{
  char *ch = *pch;
  int x = col[row];
  if (x == INT_MIN) {
  *ch++ = 'N';
  *ch++ = 'A';
  } else {
  if (x<0) { *ch++ = '-'; x=-x; }
  // Avoid log() for speed. Write backwards then reverse when we know how long.
  char *low = ch;
  do { *ch++ = '0'+x%10; x/=10; } while (x>0);
  reverse(ch, low);
  }
  *pch = ch;
}

//end of copied code 

"



worker_fun <- inline::cxxfunction( signature(x = "list", preallocated_target = "character", columns = "integer", start_row = "integer", end_row = "integer"), includes = header , "
                                   const size_t _start_row = INTEGER(start_row)[0] - 1;
                                   const size_t _end_row = INTEGER(end_row)[0];
                                   
                                   const int max_out_len = 256 * 256; //max length of the final string
                                   char buffer[max_out_len];
                                   const size_t num_elements = _end_row - _start_row;
                                   const size_t num_columns = LENGTH(columns);
                                   const int * _columns = INTEGER(columns);
                                   
                                   for(size_t i = _start_row; i < _end_row; ++i) {
                                   char *buf_pos = buffer;
                                   for(size_t c = 0; c < num_columns; ++c) {
                                   if(c > 0) {
                                   buf_pos[0] = ',';
                                   ++buf_pos;
                                   }
                                   writeInt32(INTEGER(VECTOR_ELT(x, _columns[c] - 1)), i, &buf_pos);
                                   }
                                   SET_STRING_ELT(preallocated_target,i, mkCharLen(buffer, buf_pos - buffer));
                                   }
                                   return preallocated_target;
                                   " )

inline::getDynLib(worker_fun)
inline::code(worker_fun)

#Test with the same data

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
x <- worker_fun(DT, preallocated_target, column_indices, as.integer(1), as.integer(RowCount))
DT[, State := preallocated_target]
