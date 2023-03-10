#include <8051.h>
#include "cooperative.h"

__data __at (0x3E) char buf;
__data __at (0x3F) char ch;

void Producer(void){
	ch = 'A';
	while (1) {
		while(buf != '\0'){
			ThreadYield();
		}
		buf = ch;
		if(ch == 'Z'){
			ch= 'A';
		}else{
			ch+=1;
		}
		ThreadYield();
	}
}

void Consumer(void) {
	TMOD = 0x20;
	TH1 = -6;
	SCON = 0x50;
	TR1 = 1;
	while (1) {
		while(buf == '\0'){
			ThreadYield();
		}
		SBUF = buf;
		buf = '\0';
		while(!TI){
			ThreadYield();
		}
		TI = 0;
	}
}

void main(void) {
	buf = '\0';
	ThreadCreate(Producer);
	Consumer();
}

void _sdcc_gsinit_startup(void) {
    __asm
        ljmp  _Bootstrap
    __endasm;
}

void _mcs51_genRAMCLEAR(void) {}
void _mcs51_genXINIT(void) {}
void _mcs51_genXRAMCLEAR(void) {}