//------------------------------------------------------------------------------
// Declaração das I/Os
//------------------------------------------------------------------------------
#define E1      portd.f0  //
#define E2      portd.f1  //
#define E3      portd.f2  //
#define E4      portd.f3  //
#define E5      portd.f4  //
#define E6      portd.f5  //
#define E7      portd.f6  //
#define E8      portd.f7  //
#define E9      porta.f1  //
#define E10     porta.f2  //
#define E11     porta.f4  //
#define E12     porta.f3  //

#define S1      portc.f0  //
#define S2      portc.f2  //
#define S3      portc.f1  //
#define S4      porta.f5  //
#define S5      porte.f0  //
#define S6      porte.f1  //
#define S7      porte.f2  //
#define S8      portc.f5  //
//------------------------------------------------------------------------------
// Configuração do LCD
//------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------
// Configuração do SD Card
//------------------------------------------------------------------------------
sbit Mmc_Chip_Select           at LATC0_bit;
sbit Mmc_Chip_Select_Direction at TRISC0_bit;
//------------------------------------------------------------------------------