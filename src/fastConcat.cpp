#include <Rcpp.h>
#include <R.h>
#include <Rdefines.h>
#include <Rmath.h>
#define USE_RINTERNALS
#include <Rinternals.h>
#include <stdbool.h>   // true and false
#include <stdint.h>    // INT32_MIN
#include <math.h>      // isfinite, isnan
#include <stdlib.h>    // abs
#include <string.h>    // strlen, strerror
#include "fastConcat.h"

using namespace Rcpp;

// [[Rcpp::export]]
SEXP fastConcat(DataFrame x,
                char preallocated_target,
                int columns,
                int start_row,
                int end_row) {
  
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
}
