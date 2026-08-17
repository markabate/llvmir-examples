; Module strings.ll
; Common utilities for reading and writing to string buffers

;; External declarations
; libc
declare i64 @snprintf(ptr, i64, ptr, ...)
declare i32 @printf(ptr, ...)

; Strings
@i32PrintFmt = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@debugFmt1 = private unnamed_addr constant [7 x i8] c"x %ld\0A\00", align 1

; Write num as string to char array buff starting at buffInd
; Returns chars written, excluding \0
define i64 @bufferWriteI32(ptr %buff, i64 %buffSize, i64 %buffInd, i32 %num) {
entry:
  %indexValid = icmp ult i64 %buffInd, %buffSize
  br i1 %indexValid, label %index.valid, label %exit

  ; This index is valid, write to the buffer
index.valid:
  %remBuffSize = sub i64 %buffSize, %buffInd
  %buffEl_p = getelementptr i8, ptr %buff, i64 %buffInd
  %strLength = call i64 (ptr, i64, ptr, ...) @snprintf(ptr %buffEl_p, i64 %remBuffSize, ptr @i32PrintFmt, i32 %num)
  br label %exit

exit:
  %retVal = phi i64 [%strLength, %index.valid], [0, %entry]
  ret i64 %retVal
}

define i64 @bufferWriteStr(ptr %buff, i64 %buffSize, i64 %buffInd, ptr %str) {
entry:
  %indexValid = icmp ult i64 %buffInd, %buffSize
  br i1 %indexValid, label %index.valid, label %exit

  ; This index is valid, write to the buffer
index.valid:
  %buffEl_p = getelementptr i8, ptr %buff, i64 %buffInd 
  %remBuffSize = sub i64 %buffSize, %buffInd
  %strLength = call i64 (ptr, i64, ptr, ...) @snprintf(ptr %buffEl_p, i64 %remBuffSize, ptr %str)
  br label %exit

exit:
  %retVal = phi i64 [%strLength, %index.valid], [0, %entry]
  ret i64 %retVal
}
