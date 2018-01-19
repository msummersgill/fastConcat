concat <- function(x,preallocated_target,columns,start_row,end_row){
  .Call("CfastConcat",x,preallocated_target,columns,start_row,end_row, sep)
}