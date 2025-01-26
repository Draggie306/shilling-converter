DEFW    shilling_intro_txt "Welcome to the shilling converter\n",0
DEFW    how_to_convert   "Would you like to convert from old English currency to the metric equivalent (1) or the present-day metric system to the pre-1971 system (2)? Input a number.",0
DEFW    choice_prompt    "Enter your choice: ",0
DEFW    chosen_metric_to_shilling "\nConverting from metric to shilling confirmed.\n",0
DEFW    chosen_shilling_to_metric "\nConverting from shilling to metric confirmed.\n",0
DEFW    result_txt      "\nResult: £",0
DEFW    and_txt         " and ",0
DEFW    shillings_txt   " shillings ",0
DEFW    pence_txt       " pence\n",0

; Metric units
DEFW    enter_pounds    "Enter the number of pounds: ",0
DEFW    enter_pence     "Enter the number of pence: ",0
DEFW    enter_shillings "Enter the number of shillings: ",0

    ALIGN
main
    ; Print welcome message
    ADRL   R0, shilling_intro_txt
    SWI    3

    ADRL   R0, how_to_convert
    SWI    3

    ; Read choice
    ADRL   R0, choice_prompt
    SWI    3
    BL     ReadIn

    CMP    R0, #2
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
ReadIn
    STMFD  R13!, {R1-R4, LR}
    MOV    R1, #0    ; Initialize result

ReadLoop
    SWI    1         ; Read character
    CMP    R0, #13   ; Check for enter key
    BEQ    endReadIn
    
    CMP    R0, #'0'  ; Check if digit
    BLT    ReadLoop
    CMP    R0, #'9'
    BGT    ReadLoop
    
    SWI    0         ; ALlow the user to 
    
    SUB    R0, R0, #'0'     ; Convert to number
    MOV    R2, R1, LSL #3   ; Multiply current by 8
    ADD    R2, R2, R1, LSL #1  ; Add current * 2 (total * 10)
    ADD    R1, R0, R2       ; Add new digit
    
    B      ReadLoop

endReadIn
    MOV    R0, R1
    LDMFD  R13!, {R1-R4, LR}
    MOV    PC, LR

ConvertToDecimal
    ; R0 = pounds, R1 = shillings, R2 = pence
    STMFD  R13!, {R4-R6, LR}
    
    ; Convert shillings to pence (1 shilling = 12 pence)
    MOV    R4, R1, LSL #3   ; R4 = shillings * 8
    ADD    R4, R4, R1, LSL #2  ; R4 = shillings * 12
    
    ; Add all pence
    ADD    R2, R2, R4

    ADRL   R0, result_txt
    SWI    3
    
    LDMFD  R13!, {R4-R6, LR}
    MOV    PC, LR

ConvertToOld
    ; R0 = pounds, R1 = pence
    STMFD  R13!, {R4-R6, LR}
    
    ; Convert to old system (1 shilling = 12 pence)
    MOV    R4, R1           ; Store pence
    MOV    R5, R4, LSR #3   ; Divide by 12 (approximate)
    MUL    R6, R5, #12      ; Calculate remainder
    SUB    R6, R4, R6       ; R6 = remaining pence

    
    LDMFD  R13!, {R4-R6, LR}
    MOV    PC, LR

end
    SWI    2