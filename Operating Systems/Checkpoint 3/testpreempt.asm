;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.8.0 #10562 (Linux)
;--------------------------------------------------------
	.module testpreempt
	.optsdcc -mmcs51 --model-small
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _timer0_ISR
	.globl __mcs51_genXRAMCLEAR
	.globl __mcs51_genXINIT
	.globl __mcs51_genRAMCLEAR
	.globl __sdcc_gsinit_startup
	.globl _main
	.globl _Consumer
	.globl _Producer
	.globl _ThreadCreate
	.globl _CY
	.globl _AC
	.globl _F0
	.globl _RS1
	.globl _RS0
	.globl _OV
	.globl _F1
	.globl _P
	.globl _PS
	.globl _PT1
	.globl _PX1
	.globl _PT0
	.globl _PX0
	.globl _RD
	.globl _WR
	.globl _T1
	.globl _T0
	.globl _INT1
	.globl _INT0
	.globl _TXD
	.globl _RXD
	.globl _P3_7
	.globl _P3_6
	.globl _P3_5
	.globl _P3_4
	.globl _P3_3
	.globl _P3_2
	.globl _P3_1
	.globl _P3_0
	.globl _EA
	.globl _ES
	.globl _ET1
	.globl _EX1
	.globl _ET0
	.globl _EX0
	.globl _P2_7
	.globl _P2_6
	.globl _P2_5
	.globl _P2_4
	.globl _P2_3
	.globl _P2_2
	.globl _P2_1
	.globl _P2_0
	.globl _SM0
	.globl _SM1
	.globl _SM2
	.globl _REN
	.globl _TB8
	.globl _RB8
	.globl _TI
	.globl _RI
	.globl _P1_7
	.globl _P1_6
	.globl _P1_5
	.globl _P1_4
	.globl _P1_3
	.globl _P1_2
	.globl _P1_1
	.globl _P1_0
	.globl _TF1
	.globl _TR1
	.globl _TF0
	.globl _TR0
	.globl _IE1
	.globl _IT1
	.globl _IE0
	.globl _IT0
	.globl _P0_7
	.globl _P0_6
	.globl _P0_5
	.globl _P0_4
	.globl _P0_3
	.globl _P0_2
	.globl _P0_1
	.globl _P0_0
	.globl _B
	.globl _ACC
	.globl _PSW
	.globl _IP
	.globl _P3
	.globl _IE
	.globl _P2
	.globl _SBUF
	.globl _SCON
	.globl _P1
	.globl _TH1
	.globl _TH0
	.globl _TL1
	.globl _TL0
	.globl _TMOD
	.globl _TCON
	.globl _PCON
	.globl _DPH
	.globl _DPL
	.globl _SP
	.globl _P0
	.globl _ch
	.globl _tail
	.globl _head
	.globl _buf
	.globl _empty
	.globl _full
	.globl _mutex
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
_P0	=	0x0080
_SP	=	0x0081
_DPL	=	0x0082
_DPH	=	0x0083
_PCON	=	0x0087
_TCON	=	0x0088
_TMOD	=	0x0089
_TL0	=	0x008a
_TL1	=	0x008b
_TH0	=	0x008c
_TH1	=	0x008d
_P1	=	0x0090
_SCON	=	0x0098
_SBUF	=	0x0099
_P2	=	0x00a0
_IE	=	0x00a8
_P3	=	0x00b0
_IP	=	0x00b8
_PSW	=	0x00d0
_ACC	=	0x00e0
_B	=	0x00f0
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
_P0_0	=	0x0080
_P0_1	=	0x0081
_P0_2	=	0x0082
_P0_3	=	0x0083
_P0_4	=	0x0084
_P0_5	=	0x0085
_P0_6	=	0x0086
_P0_7	=	0x0087
_IT0	=	0x0088
_IE0	=	0x0089
_IT1	=	0x008a
_IE1	=	0x008b
_TR0	=	0x008c
_TF0	=	0x008d
_TR1	=	0x008e
_TF1	=	0x008f
_P1_0	=	0x0090
_P1_1	=	0x0091
_P1_2	=	0x0092
_P1_3	=	0x0093
_P1_4	=	0x0094
_P1_5	=	0x0095
_P1_6	=	0x0096
_P1_7	=	0x0097
_RI	=	0x0098
_TI	=	0x0099
_RB8	=	0x009a
_TB8	=	0x009b
_REN	=	0x009c
_SM2	=	0x009d
_SM1	=	0x009e
_SM0	=	0x009f
_P2_0	=	0x00a0
_P2_1	=	0x00a1
_P2_2	=	0x00a2
_P2_3	=	0x00a3
_P2_4	=	0x00a4
_P2_5	=	0x00a5
_P2_6	=	0x00a6
_P2_7	=	0x00a7
_EX0	=	0x00a8
_ET0	=	0x00a9
_EX1	=	0x00aa
_ET1	=	0x00ab
_ES	=	0x00ac
_EA	=	0x00af
_P3_0	=	0x00b0
_P3_1	=	0x00b1
_P3_2	=	0x00b2
_P3_3	=	0x00b3
_P3_4	=	0x00b4
_P3_5	=	0x00b5
_P3_6	=	0x00b6
_P3_7	=	0x00b7
_RXD	=	0x00b0
_TXD	=	0x00b1
_INT0	=	0x00b2
_INT1	=	0x00b3
_T0	=	0x00b4
_T1	=	0x00b5
_WR	=	0x00b6
_RD	=	0x00b7
_PX0	=	0x00b8
_PT0	=	0x00b9
_PX1	=	0x00ba
_PT1	=	0x00bb
_PS	=	0x00bc
_P	=	0x00d0
_F1	=	0x00d1
_OV	=	0x00d2
_RS0	=	0x00d3
_RS1	=	0x00d4
_F0	=	0x00d5
_AC	=	0x00d6
_CY	=	0x00d7
;--------------------------------------------------------
; overlayable register banks
;--------------------------------------------------------
	.area REG_BANK_0	(REL,OVR,DATA)
	.ds 8
;--------------------------------------------------------
; internal ram data
;--------------------------------------------------------
	.area DSEG    (DATA)
_mutex	=	0x0020
_full	=	0x0021
_empty	=	0x0022
_buf	=	0x0023
_head	=	0x0026
_tail	=	0x0027
_ch	=	0x0028
;--------------------------------------------------------
; overlayable items in internal ram 
;--------------------------------------------------------
;--------------------------------------------------------
; Stack segment in internal ram 
;--------------------------------------------------------
	.area	SSEG
__start__stack:
	.ds	1

;--------------------------------------------------------
; indirectly addressable internal ram data
;--------------------------------------------------------
	.area ISEG    (DATA)
;--------------------------------------------------------
; absolute internal ram data
;--------------------------------------------------------
	.area IABS    (ABS,DATA)
	.area IABS    (ABS,DATA)
;--------------------------------------------------------
; bit data
;--------------------------------------------------------
	.area BSEG    (BIT)
;--------------------------------------------------------
; paged external ram data
;--------------------------------------------------------
	.area PSEG    (PAG,XDATA)
;--------------------------------------------------------
; external ram data
;--------------------------------------------------------
	.area XSEG    (XDATA)
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area XABS    (ABS,XDATA)
;--------------------------------------------------------
; external initialized ram data
;--------------------------------------------------------
	.area XISEG   (XDATA)
	.area HOME    (CODE)
	.area GSINIT0 (CODE)
	.area GSINIT1 (CODE)
	.area GSINIT2 (CODE)
	.area GSINIT3 (CODE)
	.area GSINIT4 (CODE)
	.area GSINIT5 (CODE)
	.area GSINIT  (CODE)
	.area GSFINAL (CODE)
	.area CSEG    (CODE)
;--------------------------------------------------------
; interrupt vector 
;--------------------------------------------------------
	.area HOME    (CODE)
__interrupt_vect:
	ljmp	__sdcc_gsinit_startup
	reti
	.ds	7
	ljmp	_timer0_ISR
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME    (CODE)
	.area GSINIT  (CODE)
	.area GSFINAL (CODE)
	.area GSINIT  (CODE)
	.globl __sdcc_gsinit_startup
	.globl __sdcc_program_startup
	.globl __start__stack
	.globl __mcs51_genXINIT
	.globl __mcs51_genXRAMCLEAR
	.globl __mcs51_genRAMCLEAR
	.area GSFINAL (CODE)
	ljmp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME    (CODE)
	.area HOME    (CODE)
__sdcc_program_startup:
	ljmp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CSEG    (CODE)
;------------------------------------------------------------
;Allocation info for local variables in function 'Producer'
;------------------------------------------------------------
;	testpreempt.c:12: void Producer(void){
;	-----------------------------------------
;	 function Producer
;	-----------------------------------------
_Producer:
	ar7 = 0x07
	ar6 = 0x06
	ar5 = 0x05
	ar4 = 0x04
	ar3 = 0x03
	ar2 = 0x02
	ar1 = 0x01
	ar0 = 0x00
;	testpreempt.c:13: ch = 'A';
	mov	_ch,#0x41
;	testpreempt.c:14: while(1){
00107$:
;	testpreempt.c:15: SemaphoreWait(empty);
		0$:
	mov a, _empty 
	jz 0$ 
	jb ACC.7, 0$ 
	dec _empty 
;	testpreempt.c:25: }
	mov	r7,#0x01
	jbc	ea,00123$
	mov	r7,#0x00
00123$:
;	testpreempt.c:18: SemaphoreWait(mutex);
		1$:
	mov a, _mutex 
	jz 1$ 
	jb ACC.7, 1$ 
	dec _mutex 
;	testpreempt.c:19: buf[head] = ch;
	mov	a,_head
	add	a,#_buf
	mov	r0,a
	mov	@r0,_ch
;	testpreempt.c:20: head++;
	inc	_head
;	testpreempt.c:21: if(head == 3){
	mov	a,#0x03
	cjne	a,_head,00102$
;	testpreempt.c:22: head = 0;
	mov	_head,#0x00
00102$:
;	testpreempt.c:24: SemaphoreSignal(mutex);
	inc _mutex 
	mov	a,r7
	rrc	a
	mov	ea,c
;	testpreempt.c:27: SemaphoreSignal(full);
	inc _full 
;	testpreempt.c:28: if(ch == 'Z'){
	mov	a,#0x5a
	cjne	a,_ch,00104$
;	testpreempt.c:29: ch = 'A';
	mov	_ch,#0x41
	sjmp	00107$
00104$:
;	testpreempt.c:31: ch += 1;
	mov	a,_ch
	mov	r7,a
	inc	a
	mov	_ch,a
;	testpreempt.c:34: }
	sjmp	00107$
;------------------------------------------------------------
;Allocation info for local variables in function 'Consumer'
;------------------------------------------------------------
;	testpreempt.c:36: void Consumer(void) {
;	-----------------------------------------
;	 function Consumer
;	-----------------------------------------
_Consumer:
;	testpreempt.c:37: TMOD |= 0x20;
	mov	r6,_TMOD
	mov	r7,#0x00
	orl	ar6,#0x20
	mov	_TMOD,r6
;	testpreempt.c:38: TH1 = -6;
	mov	_TH1,#0xfa
;	testpreempt.c:39: SCON = 0x50;
	mov	_SCON,#0x50
;	testpreempt.c:40: TR1 = 1;
;	assignBit
	setb	_TR1
;	testpreempt.c:41: while (1) {
00107$:
;	testpreempt.c:42: SemaphoreWait(full);
		2$:
	mov a, _full 
	jz 2$ 
	jb ACC.7, 2$ 
	dec _full 
;	testpreempt.c:54: }
	mov	r7,#0x01
	jbc	ea,00127$
	mov	r7,#0x00
00127$:
;	testpreempt.c:45: SemaphoreWait(mutex);
		3$:
	mov a, _mutex 
	jz 3$ 
	jb ACC.7, 3$ 
	dec _mutex 
;	testpreempt.c:46: SBUF = buf[tail];
	mov	a,_tail
	add	a,#_buf
	mov	r1,a
	mov	_SBUF,@r1
;	testpreempt.c:47: while(!TI){}
00101$:
;	testpreempt.c:48: TI = 0;
;	assignBit
	jbc	_TI,00128$
	sjmp	00101$
00128$:
;	testpreempt.c:49: tail++;
	inc	_tail
;	testpreempt.c:50: if(tail == 3){
	mov	a,#0x03
	cjne	a,_tail,00105$
;	testpreempt.c:51: tail = 0;
	mov	_tail,#0x00
00105$:
;	testpreempt.c:53: SemaphoreSignal(mutex);
	inc _mutex 
	mov	a,r7
	rrc	a
	mov	ea,c
;	testpreempt.c:56: SemaphoreSignal(empty);
	inc _empty 
;	testpreempt.c:58: }
	sjmp	00107$
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;i                         Allocated to registers r5 r6 
;------------------------------------------------------------
;	testpreempt.c:60: void main(void) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	testpreempt.c:70: }
	mov	r7,#0x01
	jbc	ea,00116$
	mov	r7,#0x00
00116$:
;	testpreempt.c:62: for(int i=0;i<3;i++){
	mov	r5,#0x00
	mov	r6,#0x00
00103$:
	clr	c
	mov	a,r5
	subb	a,#0x03
	mov	a,r6
	xrl	a,#0x80
	subb	a,#0x80
	jnc	00101$
;	testpreempt.c:63: buf[i] = '\0';
	mov	a,r5
	add	a,#_buf
	mov	r0,a
	mov	@r0,#0x00
;	testpreempt.c:62: for(int i=0;i<3;i++){
	inc	r5
	cjne	r5,#0x00,00103$
	inc	r6
	sjmp	00103$
00101$:
;	testpreempt.c:65: head = 0;
	mov	_head,#0x00
;	testpreempt.c:66: tail = 0;
	mov	_tail,#0x00
;	testpreempt.c:67: SemaphoreCreate(mutex, 1);
	mov	_mutex,#0x01
;	testpreempt.c:68: SemaphoreCreate(full, 0);
	mov	_full,#0x00
;	testpreempt.c:69: SemaphoreCreate(empty, 3);
	mov	_empty,#0x03
	mov	a,r7
	rrc	a
	mov	ea,c
;	testpreempt.c:71: ThreadCreate(Producer);
	mov	dptr,#_Producer
	lcall	_ThreadCreate
;	testpreempt.c:72: Consumer();
;	testpreempt.c:73: }
	ljmp	_Consumer
;------------------------------------------------------------
;Allocation info for local variables in function '_sdcc_gsinit_startup'
;------------------------------------------------------------
;	testpreempt.c:75: void _sdcc_gsinit_startup(void) {
;	-----------------------------------------
;	 function _sdcc_gsinit_startup
;	-----------------------------------------
__sdcc_gsinit_startup:
;	testpreempt.c:78: __endasm;
	ljmp	_Bootstrap
;	testpreempt.c:79: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function '_mcs51_genRAMCLEAR'
;------------------------------------------------------------
;	testpreempt.c:81: void _mcs51_genRAMCLEAR(void) {}
;	-----------------------------------------
;	 function _mcs51_genRAMCLEAR
;	-----------------------------------------
__mcs51_genRAMCLEAR:
	ret
;------------------------------------------------------------
;Allocation info for local variables in function '_mcs51_genXINIT'
;------------------------------------------------------------
;	testpreempt.c:82: void _mcs51_genXINIT(void) {}
;	-----------------------------------------
;	 function _mcs51_genXINIT
;	-----------------------------------------
__mcs51_genXINIT:
	ret
;------------------------------------------------------------
;Allocation info for local variables in function '_mcs51_genXRAMCLEAR'
;------------------------------------------------------------
;	testpreempt.c:83: void _mcs51_genXRAMCLEAR(void) {}
;	-----------------------------------------
;	 function _mcs51_genXRAMCLEAR
;	-----------------------------------------
__mcs51_genXRAMCLEAR:
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'timer0_ISR'
;------------------------------------------------------------
;	testpreempt.c:85: void timer0_ISR(void) __interrupt(1) {
;	-----------------------------------------
;	 function timer0_ISR
;	-----------------------------------------
_timer0_ISR:
;	testpreempt.c:88: __endasm;
	ljmp	_myTimer0Handler
;	testpreempt.c:89: }
	reti
;	eliminated unneeded mov psw,# (no regs used in bank)
;	eliminated unneeded push/pop psw
;	eliminated unneeded push/pop dpl
;	eliminated unneeded push/pop dph
;	eliminated unneeded push/pop b
;	eliminated unneeded push/pop acc
	.area CSEG    (CODE)
	.area CONST   (CODE)
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
