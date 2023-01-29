#include <8051.h>
#include "preemptive.h"

__data __at (0x30) char sp[MAXTHREADS];	//takes up 0x30 ~ 0x33
__data __at (0x34) ThreadID curThreadID;
__data __at (0x35) char bitmap;
__data __at (0x36) ThreadID newThreadID;
__data __at (0x37) char i;
__data __at (0x38) char tmp;
__data __at (0x39) char tmp2;

#define SAVESTATE \
{ \
    __asm \
        push ACC \
        push B \
        push DPL \
        push DPH \
        push PSW \
    __endasm; \
    sp[curThreadID] = SP; \
}

#define RESTORESTATE \
{ \
    SP = sp[curThreadID]; \
    __asm \
        pop PSW \
        pop DPH \
        pop DPL \
        pop B \
        pop ACC \
    __endasm; \
}

extern void main(void);

void Bootstrap(void) {
	TMOD = 0;	//timer 0 mode 0
	IE = 0x82;	//enable timer 0 interrupt
	TR0 = 1;	//start running timer 0
	bitmap = 0b0000;
	curThreadID = ThreadCreate(main);
	RESTORESTATE;
}

ThreadID ThreadCreate(FunctionPtr fp) {
	if(bitmap == 0b1111){
        return -1;
    }

	__critical{
		for(i=0;i<MAXTHREADS;i++) {
			if((bitmap & (1<<i)) == 0) {
				bitmap |= (1<<i);
				newThreadID = i;
				break;
			}
		}

		tmp = SP;
		SP = 0x3F + (newThreadID<<4); //not 0x40, since push is pre increment

		__asm
			push DPL
			push DPH
			mov A, #0
			push A
			push A
			push A
			push A
		__endasm;

		tmp2 = (newThreadID<<3);
		__asm
			push _tmp2
		__endasm;
		
		sp[newThreadID] = SP;
		SP = tmp;
	}
	return newThreadID;
}

void ThreadYield(void) {
	__critical{
		SAVESTATE;
		do {
			curThreadID++;
			if(curThreadID == MAXTHREADS){
				curThreadID = 0;
			}

			if(bitmap & (1<<curThreadID)){
				break;
			}
		} while(1);
		RESTORESTATE;
	}
}

void ThreadExit(void) {
	__critical{
		bitmap ^= (1<<curThreadID);
		do {
			curThreadID++;
			if(curThreadID == MAXTHREADS){
				curThreadID = 0;
			}

			if(bitmap & (1<<curThreadID)){
				break;
			}
		} while(1);
		RESTORESTATE;
	}
}

void myTimer0Handler(void) {
		SAVESTATE;

		__asm
			mov ACC, r1
			mov B, r2
			mov DPL, r3
			mov DPH, r4
			mov PSW, r5
			mov _tmp, r6
			mov _tmp2, r7
		__endasm;

		do {
			curThreadID++;
			if(curThreadID == MAXTHREADS){
				curThreadID = 0;
			}

			if(bitmap & (1<<curThreadID)){
				break;
			}
		} while(1);

		__asm
			mov r1, ACC
			mov r2, B
			mov r3, DPL
			mov r4, DPH
			mov r5, PSW
			mov r6, _tmp
			mov r7, _tmp2
		__endasm;

		RESTORESTATE;

		__asm
			reti
		__endasm;
}