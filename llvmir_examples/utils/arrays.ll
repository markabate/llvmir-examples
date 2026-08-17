; Module array

;; External declarations
; libc
declare noalias ptr @malloc(i64)
declare ptr @realloc(ptr, i64)
declare i32 @printf(ptr, ...)

; llvmir_examples/utils/strings.ll
declare i64 @bufferWriteI32(ptr %buff, i64 %buffSize, i64 %buffInd, i32 %num)
declare i64 @bufferWriteStr(ptr %buff, i64 %buffSize, i64 %buffInd, ptr %str)

; Strings
@arrStrDelim = private unnamed_addr constant [3 x i8] c", \00", align 1
@debugFmt1 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; arrayToStrI32:
; Convert i32 array to string
; parameters:
;   n           = length of array
;   arr         = i32 array (i32*) to convert to string
;   maxBuffSize = maximum string length to return, including null terminator '\0'
;
define ptr @arrayToStrI32(i32 %n, ptr %arr, i64 %maxBuffSize) {
entry:
  ; TODO: break string buffer into chunks
  %maxStrSize = sub i64 %maxBuffSize, 1  ; Leave space for \0 (null terminator)
  %buff = call ptr @malloc(i64 %maxBuffSize)  ; Allocate max size, shrink later
  
  ; If maxBuffSize == 0, return the result from malloc without writing 
  %nullPtrStr = icmp eq i64 %maxBuffSize, 0
  br i1 %nullPtrStr, label %exit, label %no.nullptr.str
  
no.nullptr.str:
  ; If maxBuffSize == 1, write the null terminator and exit
  %emptyStr = icmp eq i64 %maxBuffSize, 1 
  br i1 %emptyStr, label %write.null.term, label %write.open.brace

write.open.brace:
  ; maxBuffSize >= 2, so we begin by writing '{'
  %buffEl_p = getelementptr i8, ptr %buff, i64 0
  store i8 123, ptr %buffEl_p  ; write ASCII '{'

  ; If the string was only 1 char long, skip loop, since we already
  ; wrote '{'
  %strFull = icmp eq i64 %maxStrSize, 1
  br i1 %strFull, label %write.null.term, label %loop.body

loop.body:
  %arrInd = phi i32 [0, %write.open.brace], [%arrInd.1, %write.delimiter]
  %buffInd = phi i64 [1, %write.open.brace], [%buffInd.2, %write.delimiter]
  
  %arrEl_p = getelementptr i32, ptr %arr, i32 %arrInd
  %arrEl = load i32, ptr %arrEl_p

  %i32StrLength = call i64 (ptr, i64, i64, i32) @bufferWriteI32(ptr %buff, i64 %maxBuffSize, i64 %buffInd, i32 %arrEl)
  br label %loop.cond

loop.cond:
  %arrInd.1 = add i32 %arrInd, 1
  %buffInd.1 = add i64 %buffInd, %i32StrLength

  %cond1 = icmp slt i32 %arrInd.1, %n
  %cond2 = icmp slt i64 %buffInd.1, %maxStrSize
  %combinedCond = and i1 %cond1, %cond2
  
  br i1 %combinedCond, label %write.delimiter, label %loop.exit

  ; There are still array elements to write and buffer space, 
  ; so write delimiter ', '
write.delimiter:
  %delimStrLength = call i64 (ptr, i64, i64, ptr) @bufferWriteStr(ptr %buff, i64 %maxBuffSize, i64 %buffInd.1, ptr @arrStrDelim)
  %buffInd.2 = add i64 %buffInd.1, %delimStrLength
  %strNoOverflow = icmp slt i64 %buffInd.2, %maxStrSize
  br i1 %strNoOverflow, label %loop.body, label %loop.exit

loop.exit:
  %buffInd.3 = phi i64 [%buffInd.2, %write.delimiter], [%buffInd.1, %loop.cond]
  %strNoOverflow.1 = icmp slt i64 %buffInd.3, %maxStrSize 
  br i1 %strNoOverflow.1, label %write.close.brace, label %exit 

  ; The string hasn't filled yet, write close brace
write.close.brace:
  %buffEl_p.2 = getelementptr i8, ptr %buff, i64 %buffInd.3
  store i8 125, ptr %buffEl_p.2  ; ASCII '}'
  %buffInd.4 = add i64 %buffInd.3, 1
  br label %write.null.term

write.null.term:
  ; Null terminate string
  %buffInd.5 = phi i64 [0, %no.nullptr.str], [1, %write.open.brace], [%buffInd.4, %write.close.brace]
  %buffEl_p.3 = getelementptr i8, ptr %buff, i64 %buffInd.5
  store i8 0, ptr %buffEl_p.3
  
  ; TODO: Realloc buffer based on actual size written

  br label %exit

exit:
  ret ptr %buff
}
