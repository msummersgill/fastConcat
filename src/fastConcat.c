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

SEXP CfastConcat ( SEXP l, SEXP columns, SEXP sep ) {
  
  const char * _sep = CHAR(asChar(sep));
  int _has_sep = strcmp(_sep,"");
  
  R_len_t nrow = length(VECTOR_ELT(l,0)), ncol = length(l);
  SEXP _result = PROTECT(allocVector(STRSXP, nrow));
  
  const int max_out_len = 1024; //max length of the final string
  char buffer[max_out_len];
  const int * _columns = INTEGER(columns);
  const size_t num_columns = LENGTH(columns);
  
  if (_has_sep == 0) { // skip writing delimiter
    for(int i = 0; i < nrow; ++i) {
      char *buf_pos = buffer;
      for(int c = 0; c < num_columns; ++c) {
        writeInt32(INTEGER(VECTOR_ELT(l, _columns[c] - 1)), i, &buf_pos);
      }
      SET_STRING_ELT(_result,i, mkCharLen(buffer, buf_pos - buffer));
    }
  } else { // write passed delimiter
    for(int i = 0; i < nrow; ++i) {
      char *buf_pos = buffer;
      for(int c = 0; c < num_columns; ++c) {
        if(c > 0) {
          buf_pos[0] = *_sep;
          ++buf_pos;
        }
        writeInt32(INTEGER(VECTOR_ELT(l, _columns[c] - 1)), i, &buf_pos);
      }
      SET_STRING_ELT(_result,i, mkCharLen(buffer, buf_pos - buffer));
    }
  }
  UNPROTECT(1);
  return _result;
  
}
