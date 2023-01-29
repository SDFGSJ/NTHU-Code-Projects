#include <8051.h>
#include "preemptive.h"

__data __at (0x30) char sp[MAXTHREADS];	//takes up 0x30 ~ 0x33
__data __at (0x34) ThreadID curThreadID;
__data __at (0x35) char bitmap;
__data __at (0x36) ThreadID newThreadID;
__data __at (0x37) char i;
__data __at (0x38) char tmp;
__data __at (0x39) char tmp2;

// saving the context of the current thread
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

// restoring the context of the current thread
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

// declare as an extern so we can reference its symbol when creating a thread for it
extern void main(void);

// Bootstrap is jumped to by the startup code to make the thread for main,
// and restore its context so the thread can run
void Bootstrap(void) {
	TMOD = 0;	//timer 0 mode 0
	IE = 0x82;	//enable timer 0 interrupt
	TR0 = 1;	//start running timer 0
	bitmap = 0b0000;
	curThreadID = ThreadCreate(main);
	RESTORESTATE;
}

// creates a thread data structure so it is ready to be restored (context switched in)
ThreadID ThreadCreate(FunctionPtr fp) {
	if(bitmap == 0b1111){
        return -1;
    }

	EA=0;
		// find a thread ID that is not in use
		for(i=0;i<MAXTHREADS;i++) {
			if((bitmap & (1<<i)) == 0) {
				bitmap |= (1<<i);
				newThreadID = i;
				break;
			}
		}

		// save the current SP in a temporary
		// calculate the starting stack location for new thread
		tmp = SP;
		SP = 0x3F + (newThreadID<<4); //not 0x40, since push is pre increment

		// push the return address fp (DPL, DPH) so we can return
		// init the stack to 0 for ACC,B,DPL,DPH
		__asm
			push DPL
			push DPH
			mov A, #0
			push A
			push A
			push A
			push A
		__endasm;

		// tmp2 act as PSW, select the register bank
		tmp2 = (newThreadID<<3);
		__asm
			push _tmp2
		__endasm;
		
		// write the current stack pointer to the saved stack
        // pointer array for this newly created thread ID
		sp[newThreadID] = SP;
		SP = tmp;
	EA=1;
	return newThreadID;
}

void ThreadYield(void) {
	EA=0;
		SAVESTATE;
		// likely to use reg r0,r1 here due to indexing operation[]
		// need to save them during timer0handler
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
	EA=1;
}

void ThreadExit(void) {
	EA=0;
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
	EA=1;
}

void myTimer0Handler(void) {
	SAVESTATE;

	// preserve the value of any such registers by copying them to registers that have been saved
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

	// copy them back to those registers
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