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
;	preemptive.c:38: void Bootstrap(void) {
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
;	preemptive.c:39: TMOD = 0;	//timer 0 mode 0
	mov	_TMOD,#0x00
;	preemptive.c:40: IE = 0x82;	//enable timer 0 interrupt
	mov	_IE,#0x82
;	preemptive.c:41: TR0 = 1;	//start running timer 0
;	assignBit
	setb	_TR0
;	preemptive.c:42: bitmap = 0b0000;
	mov	_bitmap,#0x00
;	preemptive.c:43: curThreadID = ThreadCreate(main);
	mov	dptr,#_main
	lcall	_ThreadCreate
	mov	_curThreadID,dpl
;	preemptive.c:44: RESTORESTATE;
	mov	a,_curThreadID
	add	a,#_sp
	mov	r1,a
	mov	_SP,@r1
	pop PSW 
	pop DPH 
	pop DPL 
	pop B 
	pop ACC 
;	preemptive.c:45: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'ThreadCreate'
;------------------------------------------------------------
;fp                        Allocated to registers 
;------------------------------------------------------------
;	preemptive.c:47: ThreadID ThreadCreate(FunctionPtr fp) {
;	-----------------------------------------
;	 function ThreadCreate
;	-----------------------------------------
_ThreadCreate:
;	preemptive.c:48: if(bitmap == 0b1111){
	mov	a,#0x0f
	cjne	a,_bitmap,00102$
;	preemptive.c:49: return -1;
	mov	dpl,#0xff
	ret
00102$:
;	preemptive.c:81: }
	mov	r7,#0x01
	jbc	ea,00129$
	mov	r7,#0x00
00129$:
;	preemptive.c:53: for(i=0;i<MAXTHREADS;i++) {
	mov	_i,#0x00
00107$:
	mov	a,#0x100 - 0x04
	add	a,_i
	jc	00105$
;	preemptive.c:54: if((bitmap & (1<<i)) == 0) {
	mov	r6,_i
	mov	b,r6
	inc	b
	mov	r6,#0x01
	mov	r5,#0x00
	sjmp	00132$
00131$:
	mov	a,r6
	add	a,r6
	mov	r6,a
	mov	a,r5
	rlc	a
	mov	r5,a
00132$:
	djnz	b,00131$
	mov	r3,_bitmap
	mov	r4,#0x00
	mov	a,r3
	anl	ar6,a
	mov	a,r4
	anl	ar5,a
	mov	a,r6
	orl	a,r5
	jnz	00108$
;	preemptive.c:55: bitmap |= (1<<i);
	mov	r6,_i
	mov	b,r6
	inc	b
	mov	a,#0x01
	sjmp	00136$
00134$:
	add	a,acc
00136$:
	djnz	b,00134$
	mov	r6,a
	mov	r5,_bitmap
	orl	a,r5
	mov	_bitmap,a
;	preemptive.c:56: newThreadID = i;
	mov	_newThreadID,_i
;	preemptive.c:57: break;
	sjmp	00105$
00108$:
;	preemptive.c:53: for(i=0;i<MAXTHREADS;i++) {
	inc	_i
	sjmp	00107$
00105$:
;	preemptive.c:61: tmp = SP;
	mov	_tmp,_SP
;	preemptive.c:62: SP = 0x3F + (newThreadID<<4); //not 0x40, since push is pre increment
	mov	a,_newThreadID
	swap	a
	anl	a,#0xf0
	mov	r6,a
	add	a,#0x3f
	mov	_SP,a
;	preemptive.c:72: __endasm;
	push	DPL
	push	DPH
	mov	A, #0
	push	A
	push	A
	push	A
	push	A
;	preemptive.c:74: tmp2 = (newThreadID<<3);
	mov	a,_newThreadID
	mov	r6,a
	swap	a
	rr	a
	anl	a,#0xf8
	mov	_tmp2,a
;	preemptive.c:77: __endasm;
	push	_tmp2
;	preemptive.c:79: sp[newThreadID] = SP;
	mov	a,_newThreadID
	add	a,#_sp
	mov	r0,a
	mov	@r0,_SP
;	preemptive.c:80: SP = tmp;
	mov	_SP,_tmp
	mov	a,r7
	rrc	a
	mov	ea,c
;	preemptive.c:82: return newThreadID;
	mov	dpl,_newThreadID
;	preemptive.c:83: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'ThreadYield'
;------------------------------------------------------------
;	preemptive.c:85: void ThreadYield(void) {
;	-----------------------------------------
;	 function ThreadYield
;	-----------------------------------------
_ThreadYield:
;	preemptive.c:99: }
	mov	r7,#0x01
	jbc	ea,00122$
	mov	r7,#0x00
00122$:
;	preemptive.c:87: SAVESTATE;
	push ACC 
	push B 
	push DPL 
	push DPH 
	push PSW 
	mov	a,_curThreadID
	add	a,#_sp
	mov	r0,a
	mov	@r0,_SP
;	preemptive.c:88: do {
00105$:
;	preemptive.c:89: curThreadID++;
	inc	_curThreadID
;	preemptive.c:90: if(curThreadID == MAXTHREADS){
	mov	a,#0x04
	cjne	a,_curThreadID,00102$
;	preemptive.c:91: curThreadID = 0;
	mov	_curThreadID,#0x00
00102$:
;	preemptive.c:94: if(bitmap & (1<<curThreadID)){
	mov	r6,_curThreadID
	mov	b,r6
	inc	b
	mov	r6,#0x01
	mov	r5,#0x00
	sjmp	00126$
00125$:
	mov	a,r6
	add	a,r6
	mov	r6,a
	mov	a,r5
	rlc	a
	mov	r5,a
00126$:
	djnz	b,00125$
	mov	r3,_bitmap
	mov	r4,#0x00
	mov	a,r3
	anl	ar6,a
	mov	a,r4
	anl	ar5,a
	mov	a,r6
	orl	a,r5
	jz	00105$
;	preemptive.c:98: RESTORESTATE;
	mov	a,_curThreadID
	add	a,#_sp
	mov	r1,a
	mov	_SP,@r1
	pop PSW 
	pop DPH 
	pop DPL 
	pop B 
	pop ACC 
	mov	a,r7
	rrc	a
	mov	ea,c
;	preemptive.c:100: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'ThreadExit'
;------------------------------------------------------------
;	preemptive.c:102: void ThreadExit(void) {
;	-----------------------------------------
;	 function ThreadExit
;	-----------------------------------------
_ThreadExit:
;	preemptive.c:116: }
	mov	r7,#0x01
	jbc	ea,00122$
	mov	r7,#0x00
00122$:
;	preemptive.c:104: bitmap ^= (1<<curThreadID);
	mov	r6,_curThreadID
	mov	b,r6
	inc	b
	mov	a,#0x01
	sjmp	00125$
00123$:
	add	a,acc
00125$:
	djnz	b,00123$
	mov	r6,a
	mov	r5,_bitmap
	xrl	a,r5
	mov	_bitmap,a
;	preemptive.c:105: do {
00105$:
;	preemptive.c:106: curThreadID++;
	inc	_curThreadID
;	preemptive.c:107: if(curThreadID == MAXTHREADS){
	mov	a,#0x04
	cjne	a,_curThreadID,00102$
;	preemptive.c:108: curThreadID = 0;
	mov	_curThreadID,#0x00
00102$:
;	preemptive.c:111: if(bitmap & (1<<curThreadID)){
	mov	r6,_curThreadID
	mov	b,r6
	inc	b
	mov	r6,#0x01
	mov	r5,#0x00
	sjmp	00129$
00128$:
	mov	a,r6
	add	a,r6
	mov	r6,a
	mov	a,r5
	rlc	a
	mov	r5,a
00129$:
	djnz	b,00128$
	mov	r3,_bitmap
	mov	r4,#0x00
	mov	a,r3
	anl	ar6,a
	mov	a,r4
	anl	ar5,a
	mov	a,r6
	orl	a,r5
	jz	00105$
;	preemptive.c:115: RESTORESTATE;
	mov	a,_curThreadID
	add	a,#_sp
	mov	r1,a
	mov	_SP,@r1
	pop PSW 
	pop DPH 
	pop DPL 
	pop B 
	pop ACC 
	mov	a,r7
	rrc	a
	mov	ea,c
;	preemptive.c:117: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'myTimer0Handler'
;------------------------------------------------------------
;	preemptive.c:119: void myTimer0Handler(void) {
;	-----------------------------------------
;	 function myTimer0Handler
;	-----------------------------------------
_myTimer0Handler:
;	preemptive.c:120: SAVESTATE;
	push ACC 
	push B 
	push DPL 
	push DPH 
	push PSW 
	mov	a,_curThreadID
	add	a,#_sp
	mov	r0,a
	mov	@r0,_SP
;	preemptive.c:130: __endasm;
	mov	ACC, r1
	mov	B, r2
	mov	DPL, r3
	mov	DPH, r4
	mov	PSW, r5
	mov	_tmp, r6
	mov	_tmp2, r7
;	preemptive.c:132: do {
00105$:
;	preemptive.c:133: curThreadID++;
	inc	_curThreadID
;	preemptive.c:134: if(curThreadID == MAXTHREADS){
	mov	a,#0x04
	cjne	a,_curThreadID,00102$
;	preemptive.c:135: curThreadID = 0;
	mov	_curThreadID,#0x00
00102$:
;	preemptive.c:138: if(bitmap & (1<<curThreadID)){
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
;	preemptive.c:151: __endasm;
	mov	r1, ACC
	mov	r2, B
	mov	r3, DPL
	mov	r4, DPH
	mov	r5, PSW
	mov	r6, _tmp
	mov	r7, _tmp2
;	preemptive.c:153: RESTORESTATE;
	mov	a,_curThreadID
	add	a,#_sp
	mov	r1,a
	mov	_SP,@r1
	pop PSW 
	pop DPH 
	pop DPL 
	pop B 
	pop ACC 
;	preemptive.c:157: __endasm;
	reti
;	preemptive.c:158: }
	ret
	.area CSEG    (CODE)
	.area CONST   (CODE)
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
