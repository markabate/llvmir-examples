; Module utils_test

;; External declarations
; libc
declare i32 @printf(ptr, ...)

; test/test_utils/assert.ll
declare void @assertEqStr(ptr, ptr) 

; llvmir_examples/utils/arrays.ll
declare ptr @arrayToStrI32(i32, ptr, i64)

;; Strings
@nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@nl2 = private unnamed_addr constant [3 x i8] c"\0A\0A\00", align 1

; arrayToStrI32_test strings
@arrayToStrI32_test.header = private unnamed_addr constant [29 x i8] c"**** arrayToStrI32 test ****\00", align 1
@expectedStr1 = private unnamed_addr constant [18 x i8] c"{9, 27, 7934, 123}", align 1

define internal i32 @arrayToStrI32_test() {
  call i32 (ptr, ...) @printf(ptr @arrayToStrI32_test.header)
  call i32 (ptr, ...) @printf(ptr @nl)

  %arr = alloca [4 x i32], align 4 ; Allocate array of ints
  %arrEl0_p = getelementptr [4 x i32], ptr %arr, i64 0, i64 0
  store i32 9, ptr %arrEl0_p

  %arrEl1_p = getelementptr [4 x i32], ptr %arr, i64 0, i64 1
  store i32 27, ptr %arrEl1_p

  %arrEl2_p = getelementptr [4 x i32], ptr %arr, i64 0, i64 2
  store i32 7934, ptr %arrEl2_p

   %arrEl3_p = getelementptr [4 x i32], ptr %arr, i64 0, i64 3
  store i32 123, ptr %arrEl3_p
  
  %arrStr = call ptr (i32, ptr, i64) @arrayToStrI32(i32 4, ptr %arr, i64 128)

  call void (ptr, ptr) @assertEqStr(ptr @expectedStr1, ptr %arrStr)
  
  call i32 @printf(ptr @nl2)

  ret i32 0
}

define i32 @main() {
  call i32 () @arrayToStrI32_test()
  ret i32 0
}
