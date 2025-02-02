B   main

shilling_intro_txt  DEFB "Welcome to the shilling converter\n",0
how_to_convert      DEFB  "Would you like to:\n1) Convert from old English currency to the metric equivalent\n\n--or--\n\n2) Convert the present-day metric system to the pre-1971 system?\n",0
choice_prompt       DEFB   "\nEnter your choice: ",0
chosen_metric_to_shilling DEFB "\nConverting from metric to shilling confirmed.\n",0
chosen_shilling_to_metric DEFB "\nConverting from shilling to metric confirmed.\n",0
result_txt          DEFB     "\n\nFINAL RESULT: ",0
pounds_txt          DEFB     "£ (pounds) ",0
and_txt             DEFB         " and ",0
shillings_txt       DEFB   "s (shillings) ",0
pence_txt           DEFB       "d (pence)\n",0

; Units
enter_pounds        DEFB  "Enter the number of pounds: ",0
enter_pence         DEFB   "\nEnter the number of pence: ",0
enter_shillings     DEFB "Enter the number of shillings: ",0

    ALIGN


main MOV             R13,#0x10000
    ; Print welcome message
    ADRL    R0, shilling_intro_txt
    SWI     3

    ADRL    R0, how_to_convert
    SWI     3

    ; Read choice
    ADRL    R0, choice_prompt
    SWI     3 ; print string
    SWI     1   ; read in 

    SWI     0   ; out char
    ; BL     ReadIn

    CMP    R0, #'2'
    BEQ    metric_to_shilling

shilling_to_metric
    ADRL   R0, chosen_shilling_to_metric
    SWI    3

    ; Get pounds
    ADRL   R0, enter_pounds
    SWI    3
    BL     ReadIn
    MOV    R4, R0    ; Store pounds

    ; Get shillings
    ADRL   R0, enter_shillings
    SWI    3
    BL     ReadIn
    MOV    R5, R0    ; Store shillings

    ; Get pence
    ADRL   R0, enter_pence
    SWI    3
    BL     ReadIn
    MOV    R6, R0    ; Store pence

    ; Convert to decimal pounds
    MOV    R0, R4    ; Pounds
    MOV    R1, R5    ; Shillings
    MOV    R2, R6    ; Pence
    BL     ConvertToDecimal

    ; end of func so we need to go to end to avoid going in the next one
    B      end

metric_to_shilling
    ADRL   R0, chosen_metric_to_shilling
    SWI    3

    ; Get decimal pounds
    ADRL   R0, enter_pounds
    SWI    3
    BL     ReadIn
    MOV    R4, R0    ; Store pounds

    ; Get pence
    ADRL   R0, enter_pence
    SWI    3
    BL     ReadIn

    ; Convert to old currency
    MOV    R1, R0    ; Pence
    MOV    R0, R4    ; Pounds
    BL     ConvertToOld
    B      end

; ReadIn subroutine
ReadIn     STMFD  R13!, {R1-R4, LR}
    MOV    R1, #0    ; initialise result

ReadLoop
    SWI    1         ; reads
    CMP    R0, #10
    BEQ    endReadIn
    CMP    R0, #13    ; CRLF
    BEQ    endReadIn

    CMP    R0, #'.'  ; special case for .
    BEQ    decimal
    CMP    R0, #'0'  
    BLT    ReadLoop
    CMP    R0, #'9'
    BGT    ReadLoop
    B next

decimal
    SWI 0
    B ReadLoop
next
    SWI    0         ; Echo char out

    SUB    R0, R0, #'0'     
    MOV    R2, R1, LSL #3   
    ADD    R2, R2, R1, LSL #1  
    ADD    R1, R0, R2       
    B      ReadLoop

endReadIn
    MOV    R0, R1
    LDMFD  R13!, {R1-R4, LR}
    MOV PC, LR

ConvertToDecimal
    STMFD  R13!, {R4-R6, LR}
    ; Convert pounds to pence and add shillings and pence:
    ; 1 pound = 240 pence
    MOV    R7, #240          ; load immediate 240 into R7
    MUL    R3, R0, R7        ; mult pounds (R0) by 240, result in R3
    MOV    R4, R1, LSL #3    ; shillings * 8 (temporary for shillings * 12)
    ADD    R4, R4, R1, LSL #2; add shillings * 4 to get shillings * 12
    ADD    R3, R3, R4        ; total pence from pounds and shillings
    ADD    R3, R3, R2        ; add remaining pence
    ADRL   R0, result_txt
    SWI    3

    LDMFD  R13!, {R4-R6, LR}
    MOV    PC, LR
ConvertToOld
    STMFD  R13!, {R4-R6, LR}
    MOV    R4, R1           ; copy pence into R4
    MOV    R8, R1           ; save original pence in R8 for later remainder calc
    MOV    R5, #0          ; initialise shillings counter once
division_loop
loop_check
    CMP    R4, #12
    BLT    loop_end
    SUB    R4, R4, #12
    ADD    R5, R5, #1
    B      loop_check
loop_end
    ; Now, R5 contains shillings and R4 is the remainder.
    ; remainder is R8 - (R5 * 12)

    ADRL   R0, result_txt 
    SWI    3

    ADRL   R0, pounds_txt    ; £ (pounds) 
    SWI    3

    ADRL   R0, shillings_txt ; s (shillings)
    SWI    3
    MOV    R0, R5            ; R5 is shillings value
    SWI    4

    ADRL   R0, pence_txt     ; d (pence)
    SWI    3
    MOV    R0, R4            ; R4 is remainder pence
    SWI    4
    
    LDMFD  R13!, {R4-R6, LR}
    MOV    PC, LR

end
SWI    2