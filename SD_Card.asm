
_Config:

;config.h,1 :: 		void Config() {
;config.h,5 :: 		trisa = 0b11011111;
	MOVLW       223
	MOVWF       TRISA+0 
;config.h,6 :: 		trisc = 0b11011000;
	MOVLW       216
	MOVWF       TRISC+0 
;config.h,7 :: 		trisd = 0b11111111;
	MOVLW       255
	MOVWF       TRISD+0 
;config.h,8 :: 		trise = 0b11111000;
	MOVLW       248
	MOVWF       TRISE+0 
;config.h,9 :: 		S1=0;S2=0;S3=0;S4=0;S5=0;S6=0;S7=0;S8=0;
	BCF         PORTC+0, 0 
	BCF         PORTC+0, 2 
	BCF         PORTC+0, 1 
	BCF         PORTA+0, 5 
	BCF         PORTE+0, 0 
	BCF         PORTE+0, 1 
	BCF         PORTE+0, 2 
	BCF         PORTC+0, 5 
;config.h,13 :: 		adcon1 = 0b00001110; cmcon = 0b00000111;
	MOVLW       14
	MOVWF       ADCON1+0 
	MOVLW       7
	MOVWF       CMCON+0 
;config.h,14 :: 		osccon=0b01100100; osctune=0;
	MOVLW       100
	MOVWF       OSCCON+0 
	CLRF        OSCTUNE+0 
;config.h,20 :: 		uart1_init(9600);
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       103
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;config.h,21 :: 		delay_ms(100);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_Config0:
	DECFSZ      R13, 1, 1
	BRA         L_Config0
	DECFSZ      R12, 1, 1
	BRA         L_Config0
	NOP
	NOP
;config.h,22 :: 		}
L_end_Config:
	RETURN      0
; end of _Config

_M_Check_User:

;sd.h,1 :: 		void M_Check_User(char *usr, char *pwd) {                                       /*** Verifica autenticidade de um usuário ***/
;sd.h,4 :: 		unsigned int i, x, flagUser, flagPass, flagPerm, flagPos = 0;
	CLRF        M_Check_User_flagPos_L0+0 
	CLRF        M_Check_User_flagPos_L0+1 
;sd.h,6 :: 		Mmc_Fat_Assign("USERS.TXT", 0);                                             // Abre o arquivo
	MOVLW       ?lstr1_SD_Card+0
	MOVWF       FARG_Mmc_Fat_Assign_name+0 
	MOVLW       hi_addr(?lstr1_SD_Card+0)
	MOVWF       FARG_Mmc_Fat_Assign_name+1 
	CLRF        FARG_Mmc_Fat_Assign_attrib+0 
	CALL        _Mmc_Fat_Assign+0, 0
;sd.h,7 :: 		Mmc_Fat_Reset(&size);                                                       // Se posiciona no início do arquivo
	MOVLW       _size+0
	MOVWF       FARG_Mmc_Fat_Reset_size+0 
	MOVLW       hi_addr(_size+0)
	MOVWF       FARG_Mmc_Fat_Reset_size+1 
	CALL        _Mmc_Fat_Reset+0, 0
;sd.h,9 :: 		for(i = 0; i < size; i++) {                                                 // Inicia um loop do tamanho do arquivo
	CLRF        M_Check_User_i_L0+0 
	CLRF        M_Check_User_i_L0+1 
L_M_Check_User1:
	MOVF        _size+1, 0 
	SUBWF       M_Check_User_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Check_User67
	MOVF        _size+0, 0 
	SUBWF       M_Check_User_i_L0+0, 0 
L__M_Check_User67:
	BTFSC       STATUS+0, 0 
	GOTO        L_M_Check_User2
;sd.h,10 :: 		Mmc_Fat_Read(&character);                                               // Faz a leitura do próximo caracter
	MOVLW       M_Check_User_character_L0+0
	MOVWF       FARG_Mmc_Fat_Read_fdata+0 
	MOVLW       hi_addr(M_Check_User_character_L0+0)
	MOVWF       FARG_Mmc_Fat_Read_fdata+1 
	CALL        _Mmc_Fat_Read+0, 0
;sd.h,12 :: 		if(character == '[' && flagPos == 0) {                                  // Identifica o início de um registro
	MOVF        M_Check_User_character_L0+0, 0 
	XORLW       91
	BTFSS       STATUS+0, 2 
	GOTO        L_M_Check_User6
	MOVLW       0
	XORWF       M_Check_User_flagPos_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Check_User68
	MOVLW       0
	XORWF       M_Check_User_flagPos_L0+0, 0 
L__M_Check_User68:
	BTFSS       STATUS+0, 2 
	GOTO        L_M_Check_User6
L__M_Check_User64:
;sd.h,13 :: 		flagPos = 1;                                                        // Seta a posição de leitura em usuário
	MOVLW       1
	MOVWF       M_Check_User_flagPos_L0+0 
	MOVLW       0
	MOVWF       M_Check_User_flagPos_L0+1 
;sd.h,14 :: 		flagUser = 0;                                                       // Zera o contador de caracteres
	CLRF        M_Check_User_flagUser_L0+0 
	CLRF        M_Check_User_flagUser_L0+1 
;sd.h,15 :: 		}
L_M_Check_User6:
;sd.h,16 :: 		if(character == '-' && flagPos == 1) {                                  // Identifica o início da senha
	MOVF        M_Check_User_character_L0+0, 0 
	XORLW       45
	BTFSS       STATUS+0, 2 
	GOTO        L_M_Check_User9
	MOVLW       0
	XORWF       M_Check_User_flagPos_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Check_User69
	MOVLW       1
	XORWF       M_Check_User_flagPos_L0+0, 0 
L__M_Check_User69:
	BTFSS       STATUS+0, 2 
	GOTO        L_M_Check_User9
L__M_Check_User63:
;sd.h,18 :: 		if(flagUser == strlen(usr)) {                                       // Confirma se o tamanho das suas strings coincidem
	MOVF        FARG_M_Check_User_usr+0, 0 
	MOVWF       FARG_strlen_s+0 
	MOVF        FARG_M_Check_User_usr+1, 0 
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVF        M_Check_User_flagUser_L0+1, 0 
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Check_User70
	MOVF        R0, 0 
	XORWF       M_Check_User_flagUser_L0+0, 0 
L__M_Check_User70:
	BTFSS       STATUS+0, 2 
	GOTO        L_M_Check_User10
;sd.h,19 :: 		for(x = 0; x < 21; x++) {                                       // Inicia um loop para conferência da string do usuário
	CLRF        M_Check_User_x_L0+0 
	CLRF        M_Check_User_x_L0+1 
L_M_Check_User11:
	MOVLW       0
	SUBWF       M_Check_User_x_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Check_User71
	MOVLW       21
	SUBWF       M_Check_User_x_L0+0, 0 
L__M_Check_User71:
	BTFSC       STATUS+0, 0 
	GOTO        L_M_Check_User12
;sd.h,20 :: 		if(user[x] != usr[x]) {                                     // Verifica a desigualdade dos caracteres e finaliza o processo
	MOVLW       M_Check_User_user_L0+0
	ADDWF       M_Check_User_x_L0+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(M_Check_User_user_L0+0)
	ADDWFC      M_Check_User_x_L0+1, 0 
	MOVWF       FSR0L+1 
	MOVF        M_Check_User_x_L0+0, 0 
	ADDWF       FARG_M_Check_User_usr+0, 0 
	MOVWF       FSR2L+0 
	MOVF        M_Check_User_x_L0+1, 0 
	ADDWFC      FARG_M_Check_User_usr+1, 0 
	MOVWF       FSR2L+1 
	MOVF        POSTINC0+0, 0 
	XORWF       POSTINC2+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_M_Check_User14
;sd.h,21 :: 		uart_write_text("\nERRO: 6"); break; }
	MOVLW       ?lstr2_SD_Card+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_SD_Card+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	GOTO        L_M_Check_User12
L_M_Check_User14:
;sd.h,22 :: 		if(user[x] == '\0') {                                       // Verifica o final da string e avança para a verificação da senha
	MOVLW       M_Check_User_user_L0+0
	ADDWF       M_Check_User_x_L0+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(M_Check_User_user_L0+0)
	ADDWFC      M_Check_User_x_L0+1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_M_Check_User15
;sd.h,23 :: 		flagPos = 2; flagPass = 0; S6 = 0; break; }
	MOVLW       2
	MOVWF       M_Check_User_flagPos_L0+0 
	MOVLW       0
	MOVWF       M_Check_User_flagPos_L0+1 
	CLRF        M_Check_User_flagPass_L0+0 
	CLRF        M_Check_User_flagPass_L0+1 
	BCF         PORTE+0, 1 
	GOTO        L_M_Check_User12
L_M_Check_User15:
;sd.h,19 :: 		for(x = 0; x < 21; x++) {                                       // Inicia um loop para conferência da string do usuário
	INFSNZ      M_Check_User_x_L0+0, 1 
	INCF        M_Check_User_x_L0+1, 1 
;sd.h,24 :: 		}
	GOTO        L_M_Check_User11
L_M_Check_User12:
;sd.h,25 :: 		} else { uart_write_text("\nERRO: 5"); flagPos = 0; }
	GOTO        L_M_Check_User16
L_M_Check_User10:
	MOVLW       ?lstr3_SD_Card+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_SD_Card+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	CLRF        M_Check_User_flagPos_L0+0 
	CLRF        M_Check_User_flagPos_L0+1 
L_M_Check_User16:
;sd.h,26 :: 		}
L_M_Check_User9:
;sd.h,27 :: 		if(character == '+' && flagPos == 2) {                                  // Identifica o início das permissões
	MOVF        M_Check_User_character_L0+0, 0 
	XORLW       43
	BTFSS       STATUS+0, 2 
	GOTO        L_M_Check_User19
	MOVLW       0
	XORWF       M_Check_User_flagPos_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Check_User72
	MOVLW       2
	XORWF       M_Check_User_flagPos_L0+0, 0 
L__M_Check_User72:
	BTFSS       STATUS+0, 2 
	GOTO        L_M_Check_User19
L__M_Check_User62:
;sd.h,29 :: 		if(flagPass == strlen(pwd)) {                                       // Confirma se o tamanho das suas strings coincidem
	MOVF        FARG_M_Check_User_pwd+0, 0 
	MOVWF       FARG_strlen_s+0 
	MOVF        FARG_M_Check_User_pwd+1, 0 
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVF        M_Check_User_flagPass_L0+1, 0 
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Check_User73
	MOVF        R0, 0 
	XORWF       M_Check_User_flagPass_L0+0, 0 
L__M_Check_User73:
	BTFSS       STATUS+0, 2 
	GOTO        L_M_Check_User20
;sd.h,30 :: 		for(x = 0; x < 7; x++) {                                        // Inicia um loop para conferência da string da senha
	CLRF        M_Check_User_x_L0+0 
	CLRF        M_Check_User_x_L0+1 
L_M_Check_User21:
	MOVLW       0
	SUBWF       M_Check_User_x_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Check_User74
	MOVLW       7
	SUBWF       M_Check_User_x_L0+0, 0 
L__M_Check_User74:
	BTFSC       STATUS+0, 0 
	GOTO        L_M_Check_User22
;sd.h,31 :: 		if(pass[x] != pwd[x]) {                                     // Verifica a desigualdade dos caracteres e finaliza o processo
	MOVLW       M_Check_User_pass_L0+0
	ADDWF       M_Check_User_x_L0+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(M_Check_User_pass_L0+0)
	ADDWFC      M_Check_User_x_L0+1, 0 
	MOVWF       FSR0L+1 
	MOVF        M_Check_User_x_L0+0, 0 
	ADDWF       FARG_M_Check_User_pwd+0, 0 
	MOVWF       FSR2L+0 
	MOVF        M_Check_User_x_L0+1, 0 
	ADDWFC      FARG_M_Check_User_pwd+1, 0 
	MOVWF       FSR2L+1 
	MOVF        POSTINC0+0, 0 
	XORWF       POSTINC2+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_M_Check_User24
;sd.h,32 :: 		uart_write_text("\nERRO: 8"); break; }
	MOVLW       ?lstr4_SD_Card+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr4_SD_Card+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	GOTO        L_M_Check_User22
L_M_Check_User24:
;sd.h,33 :: 		if(pass[x] == '\0') {                                       // Verifica o final da string e avança para a leitura das permissões
	MOVLW       M_Check_User_pass_L0+0
	ADDWF       M_Check_User_x_L0+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(M_Check_User_pass_L0+0)
	ADDWFC      M_Check_User_x_L0+1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_M_Check_User25
;sd.h,34 :: 		flagPos = 3; flagPerm = 0; S7 = 0; break; }
	MOVLW       3
	MOVWF       M_Check_User_flagPos_L0+0 
	MOVLW       0
	MOVWF       M_Check_User_flagPos_L0+1 
	CLRF        M_Check_User_flagPerm_L0+0 
	CLRF        M_Check_User_flagPerm_L0+1 
	BCF         PORTE+0, 2 
	GOTO        L_M_Check_User22
L_M_Check_User25:
;sd.h,30 :: 		for(x = 0; x < 7; x++) {                                        // Inicia um loop para conferência da string da senha
	INFSNZ      M_Check_User_x_L0+0, 1 
	INCF        M_Check_User_x_L0+1, 1 
;sd.h,35 :: 		}
	GOTO        L_M_Check_User21
L_M_Check_User22:
;sd.h,36 :: 		} else { uart_write_text("\nERRO: 7"); flagPos = 0; }
	GOTO        L_M_Check_User26
L_M_Check_User20:
	MOVLW       ?lstr5_SD_Card+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr5_SD_Card+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	CLRF        M_Check_User_flagPos_L0+0 
	CLRF        M_Check_User_flagPos_L0+1 
L_M_Check_User26:
;sd.h,37 :: 		}
L_M_Check_User19:
;sd.h,38 :: 		if(character == ']') {                                                  // Identifica o fim de um registro
	MOVF        M_Check_User_character_L0+0, 0 
	XORLW       93
	BTFSS       STATUS+0, 2 
	GOTO        L_M_Check_User27
;sd.h,40 :: 		if(flagPos == 3) {                                                  // Verifica sucesso nas comparações
	MOVLW       0
	XORWF       M_Check_User_flagPos_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Check_User75
	MOVLW       3
	XORWF       M_Check_User_flagPos_L0+0, 0 
L__M_Check_User75:
	BTFSS       STATUS+0, 2 
	GOTO        L_M_Check_User28
;sd.h,42 :: 		uart_write_text("\nUSUARIO AUTENTICADO: ");                     // Imprime que um usuário foi autenticado
	MOVLW       ?lstr6_SD_Card+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr6_SD_Card+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
;sd.h,43 :: 		for(x = 0; x < 20; x++) {
	CLRF        M_Check_User_x_L0+0 
	CLRF        M_Check_User_x_L0+1 
L_M_Check_User29:
	MOVLW       0
	SUBWF       M_Check_User_x_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Check_User76
	MOVLW       20
	SUBWF       M_Check_User_x_L0+0, 0 
L__M_Check_User76:
	BTFSC       STATUS+0, 0 
	GOTO        L_M_Check_User30
;sd.h,44 :: 		if(user[x] == '\0')
	MOVLW       M_Check_User_user_L0+0
	ADDWF       M_Check_User_x_L0+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(M_Check_User_user_L0+0)
	ADDWFC      M_Check_User_x_L0+1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_M_Check_User32
;sd.h,45 :: 		break;
	GOTO        L_M_Check_User30
L_M_Check_User32:
;sd.h,46 :: 		uart_write(user[x]);                                        // Imprime o nome de usuário do atual registro
	MOVLW       M_Check_User_user_L0+0
	ADDWF       M_Check_User_x_L0+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(M_Check_User_user_L0+0)
	ADDWFC      M_Check_User_x_L0+1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;sd.h,43 :: 		for(x = 0; x < 20; x++) {
	INFSNZ      M_Check_User_x_L0+0, 1 
	INCF        M_Check_User_x_L0+1, 1 
;sd.h,47 :: 		}
	GOTO        L_M_Check_User29
L_M_Check_User30:
;sd.h,48 :: 		uart_write_text(" - PERMISSOES: ");
	MOVLW       ?lstr7_SD_Card+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr7_SD_Card+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
;sd.h,49 :: 		for(x = 0; x < 3; x++) {
	CLRF        M_Check_User_x_L0+0 
	CLRF        M_Check_User_x_L0+1 
L_M_Check_User33:
	MOVLW       0
	SUBWF       M_Check_User_x_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Check_User77
	MOVLW       3
	SUBWF       M_Check_User_x_L0+0, 0 
L__M_Check_User77:
	BTFSC       STATUS+0, 0 
	GOTO        L_M_Check_User34
;sd.h,50 :: 		if(perm[x] == '\0')
	MOVLW       M_Check_User_perm_L0+0
	ADDWF       M_Check_User_x_L0+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(M_Check_User_perm_L0+0)
	ADDWFC      M_Check_User_x_L0+1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_M_Check_User36
;sd.h,51 :: 		break;
	GOTO        L_M_Check_User34
L_M_Check_User36:
;sd.h,52 :: 		uart_write(perm[x]);                                        // Imprime as permissões do atual registro
	MOVLW       M_Check_User_perm_L0+0
	ADDWF       M_Check_User_x_L0+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(M_Check_User_perm_L0+0)
	ADDWFC      M_Check_User_x_L0+1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;sd.h,49 :: 		for(x = 0; x < 3; x++) {
	INFSNZ      M_Check_User_x_L0+0, 1 
	INCF        M_Check_User_x_L0+1, 1 
;sd.h,53 :: 		}
	GOTO        L_M_Check_User33
L_M_Check_User34:
;sd.h,54 :: 		}
L_M_Check_User28:
;sd.h,56 :: 		flagPos = 0;                                                        // Reseta a posição de leitura
	CLRF        M_Check_User_flagPos_L0+0 
	CLRF        M_Check_User_flagPos_L0+1 
;sd.h,57 :: 		for(x = 0; x < 20; x++) user[x] = 0;                                // Reseta o vetor de usuário
	CLRF        M_Check_User_x_L0+0 
	CLRF        M_Check_User_x_L0+1 
L_M_Check_User37:
	MOVLW       0
	SUBWF       M_Check_User_x_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Check_User78
	MOVLW       20
	SUBWF       M_Check_User_x_L0+0, 0 
L__M_Check_User78:
	BTFSC       STATUS+0, 0 
	GOTO        L_M_Check_User38
	MOVLW       M_Check_User_user_L0+0
	ADDWF       M_Check_User_x_L0+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(M_Check_User_user_L0+0)
	ADDWFC      M_Check_User_x_L0+1, 0 
	MOVWF       FSR1L+1 
	CLRF        POSTINC1+0 
	INFSNZ      M_Check_User_x_L0+0, 1 
	INCF        M_Check_User_x_L0+1, 1 
	GOTO        L_M_Check_User37
L_M_Check_User38:
;sd.h,58 :: 		for(x = 0; x < 6; x++) pass[x] = 0;                                 // Reseta o vetor de senha
	CLRF        M_Check_User_x_L0+0 
	CLRF        M_Check_User_x_L0+1 
L_M_Check_User40:
	MOVLW       0
	SUBWF       M_Check_User_x_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Check_User79
	MOVLW       6
	SUBWF       M_Check_User_x_L0+0, 0 
L__M_Check_User79:
	BTFSC       STATUS+0, 0 
	GOTO        L_M_Check_User41
	MOVLW       M_Check_User_pass_L0+0
	ADDWF       M_Check_User_x_L0+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(M_Check_User_pass_L0+0)
	ADDWFC      M_Check_User_x_L0+1, 0 
	MOVWF       FSR1L+1 
	CLRF        POSTINC1+0 
	INFSNZ      M_Check_User_x_L0+0, 1 
	INCF        M_Check_User_x_L0+1, 1 
	GOTO        L_M_Check_User40
L_M_Check_User41:
;sd.h,59 :: 		for(x = 0; x < 3; x++) perm[x] = 0;                                 // Reseta o vetor de permissões
	CLRF        M_Check_User_x_L0+0 
	CLRF        M_Check_User_x_L0+1 
L_M_Check_User43:
	MOVLW       0
	SUBWF       M_Check_User_x_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Check_User80
	MOVLW       3
	SUBWF       M_Check_User_x_L0+0, 0 
L__M_Check_User80:
	BTFSC       STATUS+0, 0 
	GOTO        L_M_Check_User44
	MOVLW       M_Check_User_perm_L0+0
	ADDWF       M_Check_User_x_L0+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(M_Check_User_perm_L0+0)
	ADDWFC      M_Check_User_x_L0+1, 0 
	MOVWF       FSR1L+1 
	CLRF        POSTINC1+0 
	INFSNZ      M_Check_User_x_L0+0, 1 
	INCF        M_Check_User_x_L0+1, 1 
	GOTO        L_M_Check_User43
L_M_Check_User44:
;sd.h,60 :: 		}
L_M_Check_User27:
;sd.h,63 :: 		if(character != '[' && character != '-' && character != '+'             // Identifica caracteres exceto os sinalizadores ([, -, +, ])
	MOVF        M_Check_User_character_L0+0, 0 
	XORLW       91
	BTFSC       STATUS+0, 2 
	GOTO        L_M_Check_User48
	MOVF        M_Check_User_character_L0+0, 0 
	XORLW       45
	BTFSC       STATUS+0, 2 
	GOTO        L_M_Check_User48
	MOVF        M_Check_User_character_L0+0, 0 
	XORLW       43
	BTFSC       STATUS+0, 2 
	GOTO        L_M_Check_User48
;sd.h,64 :: 		&& character != ']') {
	MOVF        M_Check_User_character_L0+0, 0 
	XORLW       93
	BTFSC       STATUS+0, 2 
	GOTO        L_M_Check_User48
L__M_Check_User61:
;sd.h,66 :: 		if(flagPos == 1) {                                                  // Verifica a posição em usuário
	MOVLW       0
	XORWF       M_Check_User_flagPos_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Check_User81
	MOVLW       1
	XORWF       M_Check_User_flagPos_L0+0, 0 
L__M_Check_User81:
	BTFSS       STATUS+0, 2 
	GOTO        L_M_Check_User49
;sd.h,67 :: 		user[flagUser] = character;                                     // Preenche o vetor com o caracter lido
	MOVLW       M_Check_User_user_L0+0
	ADDWF       M_Check_User_flagUser_L0+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(M_Check_User_user_L0+0)
	ADDWFC      M_Check_User_flagUser_L0+1, 0 
	MOVWF       FSR1L+1 
	MOVF        M_Check_User_character_L0+0, 0 
	MOVWF       POSTINC1+0 
;sd.h,68 :: 		flagUser++;                                                     // Incrementa o contador de caracteres
	INFSNZ      M_Check_User_flagUser_L0+0, 1 
	INCF        M_Check_User_flagUser_L0+1, 1 
;sd.h,69 :: 		}
L_M_Check_User49:
;sd.h,70 :: 		if(flagPos == 2) {                                                  // Verifica a posição em senha
	MOVLW       0
	XORWF       M_Check_User_flagPos_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Check_User82
	MOVLW       2
	XORWF       M_Check_User_flagPos_L0+0, 0 
L__M_Check_User82:
	BTFSS       STATUS+0, 2 
	GOTO        L_M_Check_User50
;sd.h,71 :: 		pass[flagPass] = character;                                     // Preenche o vetor com o caracter lido
	MOVLW       M_Check_User_pass_L0+0
	ADDWF       M_Check_User_flagPass_L0+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(M_Check_User_pass_L0+0)
	ADDWFC      M_Check_User_flagPass_L0+1, 0 
	MOVWF       FSR1L+1 
	MOVF        M_Check_User_character_L0+0, 0 
	MOVWF       POSTINC1+0 
;sd.h,72 :: 		flagPass++;                                                     // Incrementa o contador de caracteres
	INFSNZ      M_Check_User_flagPass_L0+0, 1 
	INCF        M_Check_User_flagPass_L0+1, 1 
;sd.h,73 :: 		}
L_M_Check_User50:
;sd.h,74 :: 		if(flagPos == 3) {                                                  // Verifica a posição em permissões
	MOVLW       0
	XORWF       M_Check_User_flagPos_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Check_User83
	MOVLW       3
	XORWF       M_Check_User_flagPos_L0+0, 0 
L__M_Check_User83:
	BTFSS       STATUS+0, 2 
	GOTO        L_M_Check_User51
;sd.h,75 :: 		perm[flagPerm] = character;                                     // Preenche o vetor com o caracter lido
	MOVLW       M_Check_User_perm_L0+0
	ADDWF       M_Check_User_flagPerm_L0+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(M_Check_User_perm_L0+0)
	ADDWFC      M_Check_User_flagPerm_L0+1, 0 
	MOVWF       FSR1L+1 
	MOVF        M_Check_User_character_L0+0, 0 
	MOVWF       POSTINC1+0 
;sd.h,76 :: 		flagPerm++;                                                     // Incrementa o contador de caracteres
	INFSNZ      M_Check_User_flagPerm_L0+0, 1 
	INCF        M_Check_User_flagPerm_L0+1, 1 
;sd.h,77 :: 		}
L_M_Check_User51:
;sd.h,78 :: 		}
L_M_Check_User48:
;sd.h,9 :: 		for(i = 0; i < size; i++) {                                                 // Inicia um loop do tamanho do arquivo
	INFSNZ      M_Check_User_i_L0+0, 1 
	INCF        M_Check_User_i_L0+1, 1 
;sd.h,79 :: 		}
	GOTO        L_M_Check_User1
L_M_Check_User2:
;sd.h,80 :: 		}
L_end_M_Check_User:
	RETURN      0
; end of _M_Check_User

_StartSD:

;sd.h,82 :: 		void StartSD() {
;sd.h,84 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;sd.h,86 :: 		if (Mmc_Fat_Init() == 0) {
	CALL        _Mmc_Fat_Init+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_StartSD52
;sd.h,88 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV4, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	CLRF        FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;sd.h,89 :: 		delay_ms(1000);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_StartSD53:
	DECFSZ      R13, 1, 1
	BRA         L_StartSD53
	DECFSZ      R12, 1, 1
	BRA         L_StartSD53
	DECFSZ      R11, 1, 1
	BRA         L_StartSD53
	NOP
	NOP
;sd.h,92 :: 		M_Check_User("admin", "654321");
	MOVLW       ?lstr8_SD_Card+0
	MOVWF       FARG_M_Check_User_usr+0 
	MOVLW       hi_addr(?lstr8_SD_Card+0)
	MOVWF       FARG_M_Check_User_usr+1 
	MOVLW       ?lstr9_SD_Card+0
	MOVWF       FARG_M_Check_User_pwd+0 
	MOVLW       hi_addr(?lstr9_SD_Card+0)
	MOVWF       FARG_M_Check_User_pwd+1 
	CALL        _M_Check_User+0, 0
;sd.h,93 :: 		S2=0;
	BCF         PORTC+0, 2 
;sd.h,94 :: 		} else {
	GOTO        L_StartSD54
L_StartSD52:
;sd.h,95 :: 		S3=0;
	BCF         PORTC+0, 1 
;sd.h,96 :: 		}
L_StartSD54:
;sd.h,97 :: 		delay_ms(2500);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_StartSD55:
	DECFSZ      R13, 1, 1
	BRA         L_StartSD55
	DECFSZ      R12, 1, 1
	BRA         L_StartSD55
	DECFSZ      R11, 1, 1
	BRA         L_StartSD55
	NOP
;sd.h,98 :: 		}
L_end_StartSD:
	RETURN      0
; end of _StartSD

_main:

;SD_Card.c,15 :: 		void main() {
;SD_Card.c,17 :: 		Config();
	CALL        _Config+0, 0
;SD_Card.c,19 :: 		S1 = 1; S2 = 1; S3 = 1; S4 = 1; S5 = 1; S6 = 1; S7 = 1; S8 = 1;
	BSF         PORTC+0, 0 
	BSF         PORTC+0, 2 
	BSF         PORTC+0, 1 
	BSF         PORTA+0, 5 
	BSF         PORTE+0, 0 
	BSF         PORTE+0, 1 
	BSF         PORTE+0, 2 
	BSF         PORTC+0, 5 
;SD_Card.c,20 :: 		delay_ms(1000);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_main56:
	DECFSZ      R13, 1, 1
	BRA         L_main56
	DECFSZ      R12, 1, 1
	BRA         L_main56
	DECFSZ      R11, 1, 1
	BRA         L_main56
	NOP
	NOP
;SD_Card.c,21 :: 		StartSD();
	CALL        _StartSD+0, 0
;SD_Card.c,25 :: 		do{
L_main57:
;SD_Card.c,26 :: 		asm {clrwdt}
	CLRWDT
;SD_Card.c,27 :: 		S1 = !S1;
	BTG         PORTC+0, 0 
;SD_Card.c,28 :: 		delay_ms(1000);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_main60:
	DECFSZ      R13, 1, 1
	BRA         L_main60
	DECFSZ      R12, 1, 1
	BRA         L_main60
	DECFSZ      R11, 1, 1
	BRA         L_main60
	NOP
	NOP
;SD_Card.c,30 :: 		while(1);
	GOTO        L_main57
;SD_Card.c,31 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
