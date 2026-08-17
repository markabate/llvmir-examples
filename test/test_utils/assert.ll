; Module assert

;; External declarations
; libc
declare i32 @strcmp(ptr, ptr)

; assert_helpers.c
declare void @fassert(i1 %cond, ptr %errMsgFmt, ...) 

; Strings
@errFmt = private unnamed_addr constant [11 x i8] c"Error: %s\0A\00", align 1
@assertEqStrErrFmt = private unnamed_addr constant [35 x i8] c"Expected string: %s ;  Actual: %s\0A\00", align 1

define void @assertEqStr(ptr %expected, ptr %actual) {
  %strcmpRes = call i32 (ptr, ptr) @strcmp(ptr %expected, ptr %actual)
  %strEq = icmp eq i32 %strcmpRes, 0
  call void (i1, ptr, ...) @fassert(i1 %strEq, ptr @assertEqStrErrFmt, ptr %expected, ptr %actual)
  ret void
}
