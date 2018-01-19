concat <- function(x,preallocated_target,columns,start_row,end_row){
  .Call("CfastConcat2",x,preallocated_target,columns,start_row,end_row)
}