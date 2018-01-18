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
