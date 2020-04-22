void M_Check_User(char *usr, char *pwd) {                                       /*** Verifica autenticidade de um usuário ***/
  
    char character, user[20], pass[6], perm[3];
    unsigned int i, x, flagUser, flagPass, flagPerm, flagPos = 0;

    Mmc_Fat_Assign("USERS.TXT", 0);                                             // Abre o arquivo
    Mmc_Fat_Reset(&size);                                                       // Se posiciona no início do arquivo
    
    for(i = 0; i < size; i++) {                                                 // Inicia um loop do tamanho do arquivo
        Mmc_Fat_Read(&character);                                               // Faz a leitura do próximo caracter
        
        if(character == '[' && flagPos == 0) {                                  // Identifica o início de um registro
            flagPos = 1;                                                        // Seta a posição de leitura em usuário
            flagUser = 0;                                                       // Zera o contador de caracteres
        }
        if(character == '-' && flagPos == 1) {                                  // Identifica o início da senha

            if(flagUser == strlen(usr)) {                                       // Confirma se o tamanho das suas strings coincidem
                for(x = 0; x < 21; x++) {                                       // Inicia um loop para conferência da string do usuário
                    if(user[x] != usr[x]) {                                     // Verifica a desigualdade dos caracteres e finaliza o processo
                        uart_write_text("\nERRO: 6"); break; }
                    if(user[x] == '\0') {                                       // Verifica o final da string e avança para a verificação da senha
                        flagPos = 2; flagPass = 0; S6 = 0; break; }
                }
            } else { uart_write_text("\nERRO: 5"); flagPos = 0; }
        }
        if(character == '+' && flagPos == 2) {                                  // Identifica o início das permissões
        
            if(flagPass == strlen(pwd)) {                                       // Confirma se o tamanho das suas strings coincidem
                for(x = 0; x < 7; x++) {                                        // Inicia um loop para conferência da string da senha
                    if(pass[x] != pwd[x]) {                                     // Verifica a desigualdade dos caracteres e finaliza o processo
                        uart_write_text("\nERRO: 8"); break; }
                    if(pass[x] == '\0') {                                       // Verifica o final da string e avança para a leitura das permissões
                        flagPos = 3; flagPerm = 0; S7 = 0; break; }
                }
            } else { uart_write_text("\nERRO: 7"); flagPos = 0; }
        }
        if(character == ']') {                                                  // Identifica o fim de um registro

            if(flagPos == 3) {                                                  // Verifica sucesso nas comparações
            
                uart_write_text("\nUSUARIO AUTENTICADO: ");                     // Imprime que um usuário foi autenticado
                for(x = 0; x < 20; x++) {
                    if(user[x] == '\0')
                        break;
                    uart_write(user[x]);                                        // Imprime o nome de usuário do atual registro
                }
                uart_write_text(" - PERMISSOES: ");
                for(x = 0; x < 3; x++) {
                    if(perm[x] == '\0')
                        break;
                    uart_write(perm[x]);                                        // Imprime as permissões do atual registro
                }
                
                // AVANÇAR PARA AS PRÓXIMAS FUNÇÕES
            }
            
            flagPos = 0;                                                        // Reseta a posição de leitura
            for(x = 0; x < 20; x++) user[x] = 0;                                // Reseta o vetor de usuário
            for(x = 0; x < 6; x++) pass[x] = 0;                                 // Reseta o vetor de senha
            for(x = 0; x < 3; x++) perm[x] = 0;                                 // Reseta o vetor de permissões
        }


        if(character != '[' && character != '-' && character != '+'             // Identifica caracteres exceto os sinalizadores ([, -, +, ])
            && character != ']') {

            if(flagPos == 1) {                                                  // Verifica a posição em usuário
                user[flagUser] = character;                                     // Preenche o vetor com o caracter lido
                flagUser++;                                                     // Incrementa o contador de caracteres
            }
            if(flagPos == 2) {                                                  // Verifica a posição em senha
                pass[flagPass] = character;                                     // Preenche o vetor com o caracter lido
                flagPass++;                                                     // Incrementa o contador de caracteres
            }
            if(flagPos == 3) {                                                  // Verifica a posição em permissões
                perm[flagPerm] = character;                                     // Preenche o vetor com o caracter lido
                flagPerm++;                                                     // Incrementa o contador de caracteres
            }
        }
    }
}

void StartSD() {

    SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);

    if (Mmc_Fat_Init() == 0) {
    
        SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV4, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
        
        delay_ms(1000);
        M_Check_User("admin", "654321");
        S2=0;
    } else {
        S3=0;
    }
    delay_ms(2500);
}