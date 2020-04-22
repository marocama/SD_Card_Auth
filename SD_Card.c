// -----------------------------------------------------------------------------
// Projeto : SD Card
// Placa: CLP PIC 40
// Microcontrolador : 16F887
// Data : 14/04/2020
// Autor : Marcus Roberto
// Vers�o: 1.2
// Compilador: MikroC PRO for PIC v.6.6.2
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Declara��o de Vari�veis
//------------------------------------------------------------------------------
unsigned int size;
//------------------------------------------------------------------------------
// Includes
//------------------------------------------------------------------------------
#include "Defines.h"
#include "Config.h"
#include "SD.h"
//------------------------------------------------------------------------------
// In�cio de execu��o
//------------------------------------------------------------------------------
void main() {

   Config();
   
   S1 = 1; S2 = 1; S3 = 1; S4 = 1; S5 = 1; S6 = 1; S7 = 1; S8 = 1;
   delay_ms(1000);
   StartSD();
   //---------------------------------------------------------------------------
   // Loop de execu��o
   //---------------------------------------------------------------------------
   do{
      asm {clrwdt}
      S1 = !S1;
      delay_ms(1000);
   }
   while(1);
}