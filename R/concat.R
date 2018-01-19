concat <- function(l, columns, sep){
  .Call("CfastConcat",l, columns, sep)
}