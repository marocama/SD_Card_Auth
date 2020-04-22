#line 1 "C:/Users/Public/Documents/Mikroelektronika/mikroC PRO for PIC/Projects/SD_Card/V2/SD_Card.c"




unsigned int size;
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/projects/sd_card/v2/defines.h"
#line 28 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/projects/sd_card/v2/defines.h"
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;
sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;



sbit Mmc_Chip_Select at LATC0_bit;
sbit Mmc_Chip_Select_Direction at TRISC0_bit;
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/projects/sd_card/v2/config.h"
void Config() {



 trisa = 0b11011111;
 trisc = 0b11011000;
 trisd = 0b11111111;
 trise = 0b11111000;
  portc.f0 =0; portc.f2 =0; portc.f1 =0; porta.f5 =0; porte.f0 =0; porte.f1 =0; porte.f2 =0; portc.f5 =0;



 adcon1 = 0b00001110; cmcon = 0b00000111;
 osccon=0b01100100; osctune=0;





 uart1_init(9600);
 delay_ms(100);
}
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/projects/sd_card/v2/sd.h"
void M_Check_User(char *usr, char *pwd) {

 char character, user[20], pass[6], perm[3];
 unsigned int i, x, flagUser, flagPass, flagPerm, flagPos = 0;

 Mmc_Fat_Assign("USERS.TXT", 0);
 Mmc_Fat_Reset(&size);

 for(i = 0; i < size; i++) {
 Mmc_Fat_Read(&character);

 if(character == '[' && flagPos == 0) {
 flagPos = 1;
 flagUser = 0;
 }
 if(character == '-' && flagPos == 1) {

 if(flagUser == strlen(usr)) {
 for(x = 0; x < 21; x++) {
 if(user[x] != usr[x]) {
 uart_write_text("\nERRO: 6"); break; }
 if(user[x] == '\0') {
 flagPos = 2; flagPass = 0;  porte.f1  = 0; break; }
 }
 } else { uart_write_text("\nERRO: 5"); flagPos = 0; }
 }
 if(character == '+' && flagPos == 2) {

 if(flagPass == strlen(pwd)) {
 for(x = 0; x < 7; x++) {
 if(pass[x] != pwd[x]) {
 uart_write_text("\nERRO: 8"); break; }
 if(pass[x] == '\0') {
 flagPos = 3; flagPerm = 0;  porte.f2  = 0; break; }
 }
 } else { uart_write_text("\nERRO: 7"); flagPos = 0; }
 }
 if(character == ']') {

 if(flagPos == 3) {

 uart_write_text("\nUSUARIO AUTENTICADO: ");
 for(x = 0; x < 20; x++) {
 if(user[x] == '\0')
 break;
 uart_write(user[x]);
 }
 uart_write_text(" - PERMISSOES: ");
 for(x = 0; x < 3; x++) {
 if(perm[x] == '\0')
 break;
 uart_write(perm[x]);
 }
 }

 flagPos = 0;
 for(x = 0; x < 20; x++) user[x] = 0;
 for(x = 0; x < 6; x++) pass[x] = 0;
 for(x = 0; x < 3; x++) perm[x] = 0;
 }


 if(character != '[' && character != '-' && character != '+'
 && character != ']') {

 if(flagPos == 1) {
 user[flagUser] = character;
 flagUser++;
 }
 if(flagPos == 2) {
 pass[flagPass] = character;
 flagPass++;
 }
 if(flagPos == 3) {
 perm[flagPerm] = character;
 flagPerm++;
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
  portc.f2 =0;
 } else {
  portc.f1 =0;
 }
 delay_ms(2500);
}
#line 15 "C:/Users/Public/Documents/Mikroelektronika/mikroC PRO for PIC/Projects/SD_Card/V2/SD_Card.c"
void main() {

 Config();

  portc.f0  = 1;  portc.f2  = 1;  portc.f1  = 1;  porta.f5  = 1;  porte.f0  = 1;  porte.f1  = 1;  porte.f2  = 1;  portc.f5  = 1;
 delay_ms(1000);
 StartSD();



 do{
 asm {clrwdt}
  portc.f0  = ! portc.f0 ;
 delay_ms(1000);
 }
 while(1);
}
