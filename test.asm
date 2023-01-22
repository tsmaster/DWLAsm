          ;; test of DWL Assembler
          
label0:   FOO                     ;fake opcode
          BAR
          BAZ
          JMP label0              ; JMP to label 0
          LDA $00
          TAX
          LDA #00
          TAY

label1:   FOO
          BAR
          BAZ
