#include <stdarg.h>
#include <stdbool.h>
#include <stdio.h>

void vfassert(bool cond, const char *restrict errMsgFmt, va_list vargs) {
  if (cond)
    return;
  
  vfprintf(stderr, errMsgFmt, vargs);
}

void fassert(bool cond, const char *restrict errMsgFmt, ...) {
  if (cond)
    return;

  va_list vargs;
  va_start(vargs, errMsgFmt);
  vfprintf(stderr, errMsgFmt, vargs);
  va_end(vargs);
}