; Module strings_test.ll

;; External declarations
; llvmir_examples/utils/strings.ll
declare i64 @bufferWriteI32(ptr, i64, i64, i32)
declare i64 @bufferWriteStr(ptr, i64, i64, ptr)

; test/test_utils/assert.ll
declare void @assertEqStr(ptr, ptr) 

; libc
declare i32 @printf(ptr, ...)
declare noalias ptr @malloc(i64)

;; Strings
@nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@nl2 = private unnamed_addr constant [3 x i8] c"\0A\0A\00", align 1

; bufferWriteI32_test strings
@bufferWriteI32_test.header = private unnamed_addr constant [30 x i8] c"**** bufferWriteI32 test ****\00", align 1
@expectedStr1 = private unnamed_addr constant [8 x i8] c"5231092\00", align 1


; bufferWriteStr_test strings
@bufferWriteStr_test.header = private unnamed_addr constant [30 x i8] c"**** bufferWriteStr test ****\00", align 1
@str1 = private unnamed_addr constant [11 x i8] c"string 1, \00", align 1
@str2 = private unnamed_addr constant [9 x i8] c"string 2\00", align 1
@expectedStr2 = private unnamed_addr constant [19 x i8] c"string 1, string 2\00", align 1

define internal i32 @bufferWriteI32_test() {
  call i32 (ptr, ...) @printf(ptr @bufferWriteI32_test.header)
  call i32 (ptr, ...) @printf(ptr @nl)

  %buff = call ptr (i64) @malloc(i64 64)
  %i32StrLength = call i64 (ptr, i64, i64, i32) @bufferWriteI32(ptr %buff, i64 64, i64 0, i32 5)
  
  %i32StrLength.1 = call i64 (ptr, i64, i64, i32) @bufferWriteI32(ptr %buff, i64 64, i64 %i32StrLength, i32 23)
  %nextInd = add i64 %i32StrLength, %i32StrLength.1
  
  %i32StrLength.2 = call i64 (ptr, i64, i64, i32) @bufferWriteI32(ptr %buff, i64 64, i64 %nextInd, i32 1092)
  
  call void (ptr, ptr) @assertEqStr(ptr @expectedStr1, ptr %buff)

  call i32 (ptr, ...) @printf(ptr @nl2)
  ret i32 0
}

define internal i32 @bufferWriteStr_test() {
  call i32 (ptr, ...) @printf(ptr @bufferWriteStr_test.header)
  call i32 (ptr, ...) @printf(ptr @nl)

  %buff = call ptr (i64) @malloc(i64 64)
  %strLength = call i64 (ptr, i64, i64, ptr) @bufferWriteStr(ptr %buff, i64 64, i64 0, ptr @str1)
  %strLength.1 = call i64 (ptr, i64, i64, ptr) @bufferWriteStr(ptr %buff, i64 64, i64 %strLength, ptr @str2)
  
  call void (ptr, ptr) @assertEqStr(ptr @expectedStr2, ptr %buff)

  call i32 (ptr, ...) @printf(ptr @nl2)
  ret i32 0
}

define i32 @main() {
  call i32 () @bufferWriteI32_test()
  call i32 () @bufferWriteStr_test()
  ret i32 0
}