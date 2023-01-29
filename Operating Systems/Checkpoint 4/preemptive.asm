;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.8.0 #10562 (Linux)
;--------------------------------------------------------
	.module preemptive
	.optsdcc -mmcs51 --model-small
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _myTimer0Handler
	.globl _Bootstrap
	.globl _main
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
	.globl _tmp2
	.globl _tmp
	.globl _i
	.globl _newThreadID
	.globl _bitmap
	.globl _curThreadID
	.globl _sp
	.globl _ThreadCreate
	.globl _ThreadYield
	.globl _ThreadExit
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
_sp	=	0x0030
_curThreadID	=	0x0034
_bitmap	=	0x0035
_newThreadID	=	0x0036
_i	=	0x0037
_tmp	=	0x0038
_tmp2	=	0x0039
;--------------------------------------------------------
; overlayable items in internal ram 
;--------------------------------------------------------
	.area	OSEG    (OVR,DATA)
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
; global & static initialisations
;--------------------------------------------------------
	.area HOME    (CODE)
	.area GSINIT  (CODE)
	.area GSFINAL (CODE)
	.area GSINIT  (CODE)
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME    (CODE)
	.area HOME    (CODE)
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CSEG    (CODE)
;------------------------------------------------------------
;Allocation info for local variables in function 'Bootstrap'
;------------------------------------------------------------
;	preemptive.c:43: void Bootstrap(void) {
;	-----------------------------------------
;	 function Bootstrap
;	-----------------------------------------
_Bootstrap:
	ar7 = 0x07
	ar6 = 0x06
	ar5 = 0x05
	ar4 = 0x04
	ar3 = 0x03
	ar2 = 0x02
	ar1 = 0x01
	ar0 = 0x00
;	preemptive.c:44: TMOD = 0;	//timer 0 mode 0
	mov	_TMOD,#0x00
;	preemptive.c:45: IE = 0x82;	//enable timer 0 interrupt
	mov	_IE,#0x82
;	preemptive.c:46: TR0 = 1;	//start running timer 0
;	assignBit
	setb	_TR0
;	preemptive.c:47: bitmap = 0b0000;
	mov	_bitmap,#0x00
;	preemptive.c:48: curThreadID = ThreadCreate(main);
	mov	dptr,#_main
	lcall	_ThreadCreate
	mov	_curThreadID,dpl
;	preemptive.c:49: RESTORESTATE;
	mov	a,_curThreadID
	add	a,#_sp
	mov	r1,a
	mov	_SP,@r1
	pop PSW 
	pop DPH 
	pop DPL 
	pop B 
	pop ACC 
;	preemptive.c:50: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'ThreadCreate'
;------------------------------------------------------------
;fp                        Allocated to registers 
;------------------------------------------------------------
;	preemptive.c:53: ThreadID ThreadCreate(FunctionPtr fp) {
;	-----------------------------------------
;	 function ThreadCreate
;	-----------------------------------------
_ThreadCreate:
;	preemptive.c:54: if(bitmap == 0b1111){
	mov	a,#0x0f
	cjne	a,_bitmap,00102$
;	preemptive.c:55: return -1;
	mov	dpl,#0xff
	ret
00102$:
;	preemptive.c:58: EA=0;
;	assignBit
	clr	_EA
;	preemptive.c:60: for(i=0;i<MAXTHREADS;i++) {
	mov	_i,#0x00
00107$:
	mov	a,#0x100 - 0x04
	add	a,_i
	jc	00105$
;	preemptive.c:61: if((bitmap & (1<<i)) == 0) {
	mov	r7,_i
	mov	b,r7
	inc	b
	mov	r7,#0x01
	mov	r6,#0x00
	sjmp	00131$
00130$:
	mov	a,r7
	add	a,r7
	mov	r7,a
	mov	a,r6
	rlc	a
	mov	r6,a
00131$:
	djnz	b,00130$
	mov	r4,_bitmap
	mov	r5,#0x00
	mov	a,r4
	anl	ar7,a
	mov	a,r5
	anl	ar6,a
	mov	a,r7
	orl	a,r6
	jnz	00108$
;	preemptive.c:62: bitmap |= (1<<i);
	mov	r7,_i
	mov	b,r7
	inc	b
	mov	a,#0x01
	sjmp	00135$
00133$:
	add	a,acc
00135$:
	djnz	b,00133$
	mov	r7,a
	mov	r6,_bitmap
	orl	a,r6
	mov	_bitmap,a
;	preemptive.c:63: newThreadID = i;
	mov	_newThreadID,_i
;	preemptive.c:64: break;
	sjmp	00105$
00108$:
;	preemptive.c:60: for(i=0;i<MAXTHREADS;i++) {
	inc	_i
	sjmp	00107$
00105$:
;	preemptive.c:70: tmp = SP;
	mov	_tmp,_SP
;	preemptive.c:71: SP = 0x3F + (newThreadID<<4); //not 0x40, since push is pre increment
	mov	a,_newThreadID
	swap	a
	anl	a,#0xf0
	mov	r7,a
	add	a,#0x3f
	mov	_SP,a
;	preemptive.c:83: __endasm;
	push	DPL
	push	DPH
	mov	A, #0
	push	A
	push	A
	push	A
	push	A
;	preemptive.c:86: tmp2 = (newThreadID<<3);
	mov	a,_newThreadID
	mov	r7,a
	swap	a
	rr	a
	anl	a,#0xf8
	mov	_tmp2,a
;	preemptive.c:89: __endasm;
	push	_tmp2
;	preemptive.c:93: sp[newThreadID] = SP;
	mov	a,_newThreadID
	add	a,#_sp
	mov	r0,a
	mov	@r0,_SP
;	preemptive.c:94: SP = tmp;
	mov	_SP,_tmp
;	preemptive.c:95: EA=1;
;	assignBit
	setb	_EA
;	preemptive.c:96: return newThreadID;
	mov	dpl,_newThreadID
;	preemptive.c:97: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'ThreadYield'
;------------------------------------------------------------
;	preemptive.c:99: void ThreadYield(void) {
;	-----------------------------------------
;	 function ThreadYield
;	-----------------------------------------
_ThreadYield:
;	preemptive.c:100: EA=0;
;	assignBit
	clr	_EA
;	preemptive.c:101: SAVESTATE;
	push ACC 
	push B 
	push DPL 
	push DPH 
	push PSW 
	mov	a,_curThreadID
	add	a,#_sp
	mov	r0,a
	mov	@r0,_SP
;	preemptive.c:104: do {
00105$:
;	preemptive.c:105: curThreadID++;
	inc	_curThreadID
;	preemptive.c:106: if(curThreadID == MAXTHREADS){
	mov	a,#0x04
	cjne	a,_curThreadID,00102$
;	preemptive.c:107: curThreadID = 0;
	mov	_curThreadID,#0x00
00102$:
;	preemptive.c:110: if(bitmap & (1<<curThreadID)){
	mov	r7,_curThreadID
	mov	b,r7
	inc	b
	mov	r7,#0x01
	mov	r6,#0x00
	sjmp	00125$
00124$:
	mov	a,r7
	add	a,r7
	mov	r7,a
	mov	a,r6
	rlc	a
	mov	r6,a
00125$:
	djnz	b,00124$
	mov	r4,_bitmap
	mov	r5,#0x00
	mov	a,r4
	anl	ar7,a
	mov	a,r5
	anl	ar6,a
	mov	a,r7
	orl	a,r6
	jz	00105$
;	preemptive.c:114: RESTORESTATE;
	mov	a,_curThreadID
	add	a,#_sp
	mov	r1,a
	mov	_SP,@r1
	pop PSW 
	pop DPH 
	pop DPL 
	pop B 
	pop ACC 
;	preemptive.c:115: EA=1;
;	assignBit
	setb	_EA
;	preemptive.c:116: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'ThreadExit'
;------------------------------------------------------------
;	preemptive.c:118: void ThreadExit(void) {
;	-----------------------------------------
;	 function ThreadExit
;	-----------------------------------------
_ThreadExit:
;	preemptive.c:119: EA=0;
;	assignBit
	clr	_EA
;	preemptive.c:120: bitmap ^= (1<<curThreadID);
	mov	r7,_curThreadID
	mov	b,r7
	inc	b
	mov	a,#0x01
	sjmp	00124$
00122$:
	add	a,acc
00124$:
	djnz	b,00122$
	mov	r7,a
	mov	r6,_bitmap
	xrl	a,r6
	mov	_bitmap,a
;	preemptive.c:121: do {
00105$:
;	preemptive.c:122: curThreadID++;
	inc	_curThreadID
;	preemptive.c:123: if(curThreadID == MAXTHREADS){
	mov	a,#0x04
	cjne	a,_curThreadID,00102$
;	preemptive.c:124: curThreadID = 0;
	mov	_curThreadID,#0x00
00102$:
;	preemptive.c:127: if(bitmap & (1<<curThreadID)){
	mov	r7,_curThreadID
	mov	b,r7
	inc	b
	mov	r7,#0x01
	mov	r6,#0x00
	sjmp	00128$
00127$:
	mov	a,r7
	add	a,r7
	mov	r7,a
	mov	a,r6
	rlc	a
	mov	r6,a
00128$:
	djnz	b,00127$
	mov	r4,_bitmap
	mov	r5,#0x00
	mov	a,r4
	anl	ar7,a
	mov	a,r5
	anl	ar6,a
	mov	a,r7
	orl	a,r6
	jz	00105$
;	preemptive.c:131: RESTORESTATE;
	mov	a,_curThreadID
	add	a,#_sp
	mov	r1,a
	mov	_SP,@r1
	pop PSW 
	pop DPH 
	pop DPL 
	pop B 
	pop ACC 
;	preemptive.c:132: EA=1;
;	assignBit
	setb	_EA
;	preemptive.c:133: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'myTimer0Handler'
;------------------------------------------------------------
;	preemptive.c:135: void myTimer0Handler(void) {
;	-----------------------------------------
;	 function myTimer0Handler
;	-----------------------------------------
_myTimer0Handler:
;	preemptive.c:136: SAVESTATE;
	push ACC 
	push B 
	push DPL 
	push DPH 
	push PSW 
	mov	a,_curThreadID
	add	a,#_sp
	mov	r0,a
	mov	@r0,_SP
;	preemptive.c:147: __endasm;
	mov	ACC, r1
	mov	B, r2
	mov	DPL, r3
	mov	DPH, r4
	mov	PSW, r5
	mov	_tmp, r6
	mov	_tmp2, r7
;	preemptive.c:149: do {
00105$:
;	preemptive.c:150: curThreadID++;
	inc	_curThreadID
;	preemptive.c:151: if(curThreadID == MAXTHREADS){
	mov	a,#0x04
	cjne	a,_curThreadID,00102$
;	preemptive.c:152: curThreadID = 0;
	mov	_curThreadID,#0x00
00102$:
;	preemptive.c:155: if(bitmap & (1<<curThreadID)){
	mov	r7,_curThreadID
	mov	b,r7
	inc	b
	mov	r7,#0x01
	mov	r6,#0x00
	sjmp	00125$
00124$:
	mov	a,r7
	add	a,r7
	mov	r7,a
	mov	a,r6
	rlc	a
	mov	r6,a
00125$:
	djnz	b,00124$
	mov	r4,_bitmap
	mov	r5,#0x00
	mov	a,r4
	anl	ar7,a
	mov	a,r5
	anl	ar6,a
	mov	a,r7
	orl	a,r6
	jz	00105$
;	preemptive.c:169: __endasm;
	mov	r1, ACC
	mov	r2, B
	mov	r3, DPL
	mov	r4, DPH
	mov	r5, PSW
	mov	r6, _tmp
	mov	r7, _tmp2
;	preemptive.c:171: RESTORESTATE;
	mov	a,_curThreadID
	add	a,#_sp
	mov	r1,a
	mov	_SP,@r1
	pop PSW 
	pop DPH 
	pop DPL 
	pop B 
	pop ACC 
;	preemptive.c:175: __endasm;
	reti
;	preemptive.c:176: }
	ret
	.area CSEG    (CODE)
	.area CONST   (CODE)
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
