void Config() {
    //-------------------------------
    // Configuração de portas
    // ------------------------------
    trisa = 0b11011111;
    trisc = 0b11011000;
    trisd = 0b11111111;
    trise = 0b11111000;
    S1=0;S2=0;S3=0;S4=0;S5=0;S6=0;S7=0;S8=0;
    //-------------------------------
    // Registradores
    //-------------------------------
    adcon1 = 0b00001110; cmcon = 0b00000111;
    osccon=0b01100100; osctune=0;
    //INTCON.GIE = 1; INTCON.PEIE = 1; PIE1.RCIE = 1;                                 // Interrupção
    //PIE1.TMR2IE = 1; IPR1.TMR2IP = 0; T2CON = 0b00000101; PR2 = 249; RCON.IPEN = 1; // Timer 2
    //-------------------------------
    // Inicializações
    //-------------------------------
    uart1_init(9600);
    delay_ms(100);
}