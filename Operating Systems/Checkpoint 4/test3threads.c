#include <8051.h>
#include "preemptive.h"

__data __at (0x20) Semaphore mutex;
__data __at (0x21) Semaphore full;
__data __at (0x22) Semaphore empty;
__data __at (0x23) char buf[3];	//takes up 0x23 ~ 0x25
__data __at (0x26) char head;
__data __at (0x27) char tail;
__data __at (0x28) char ch;
__data __at (0x29) char num;

void Producer1(void){
	ch = 'A';
	while(1){
		SemaphoreWait(empty);
		
		EA=0;
			SemaphoreWait(mutex);
			buf[head] = ch;
			
			head++;
			if(head == 3){
				head = 0;
			}
			SemaphoreSignal(mutex);
		EA=1;
		
		SemaphoreSignal(full);
		if(ch == 'Z'){
			ch = 'A';
		}else{
			ch += 1;
		}
		ThreadYield();
	}
}

void Producer2(void){
	num = '0';
	while(1){
		SemaphoreWait(empty);
		
		EA=0;
			SemaphoreWait(mutex);
			buf[head] = num;

			head++;
			if(head == 3){
				head = 0;
			}
			SemaphoreSignal(mutex);
		EA=1;
		
		SemaphoreSignal(full);
		if(num == '9'){
			num = '0';
		}else{
			num += 1;
		}
		ThreadYield();
	}
}

void Consumer(void) {
	TMOD |= 0x20;
	TH1 = -6;
	SCON = 0x50;
	TR1 = 1;
	while (1) {
		SemaphoreWait(full);
		
		EA=0;
			SemaphoreWait(mutex);
			SBUF = buf[tail];
			while(!TI){}
			TI = 0;

			tail++;
			if(tail == 3){
				tail = 0;
			}
			SemaphoreSignal(mutex);
		EA=1;
		
		SemaphoreSignal(empty);
	}
}

// main is started by the thread bootstrapper as thread-0
void main(void) {
	EA=0;
		for(int i=0;i<3;i++){
			buf[i] = '\0';
		}
		head = 0;
		tail = 0;
		SemaphoreCreate(mutex, 1);
		SemaphoreCreate(full, 0);
		SemaphoreCreate(empty, 3);
	EA=1;
	ThreadCreate(Producer2);
	ThreadCreate(Producer1);
	
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

void timer0_ISR(void) __interrupt(1) {
	__asm
		ljmp _myTimer0Handler
	__endasm;
}