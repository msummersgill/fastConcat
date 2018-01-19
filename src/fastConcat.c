#include <R.h>
#include <Rdefines.h>
#include <R_ext/Error.h>
#include <stdio.h>
#include <string.h>

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

//end of data.table code. 

SEXP CfastConcat ( SEXP x, SEXP preallocated_target, SEXP columns, SEXP start_row, SEXP end_row, SEXP sep ) {
  const char * _sep = CHAR(asChar(sep));
  int _has_sep = strcmp(_sep,"");
  
  const size_t _start_row = INTEGER(start_row)[0] - 1;
  const size_t _end_row = INTEGER(end_row)[0];
  
  const int max_out_len = 256 * 256; //max length of the final string
  char buffer[max_out_len];
  const size_t num_elements = _end_row - _start_row;
  const size_t num_columns = LENGTH(columns);
  const int * _columns = INTEGER(columns);
  
  
  if (_has_sep == 0) { // skip writing delimiter
    for(size_t i = _start_row; i < _end_row; ++i) {
      char *buf_pos = buffer;
      for(size_t c = 0; c < num_columns; ++c) {
        writeInt32(INTEGER(VECTOR_ELT(x, _columns[c] - 1)), i, &buf_pos);
      }
      SET_STRING_ELT(preallocated_target,i, mkCharLen(buffer, buf_pos - buffer));
    }
    
  } else { // write passed delimiter
    for(size_t i = _start_row; i < _end_row; ++i) {
      char *buf_pos = buffer;
      for(size_t c = 0; c < num_columns; ++c) {
        if(c > 0) {
          buf_pos[0] = *_sep;
          ++buf_pos;
        }
        writeInt32(INTEGER(VECTOR_ELT(x, _columns[c] - 1)), i, &buf_pos);
      }
      SET_STRING_ELT(preallocated_target,i, mkCharLen(buffer, buf_pos - buffer));
    }
  }
  
  return preallocated_target;
  
  warning("your C program does not return anything!");
  return R_NilValue;
}
