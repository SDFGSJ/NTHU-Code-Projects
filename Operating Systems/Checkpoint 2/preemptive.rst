                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 3.8.0 #10562 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module preemptive
                                      6 	.optsdcc -mmcs51 --model-small
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _myTimer0Handler
                                     12 	.globl _Bootstrap
                                     13 	.globl _main
                                     14 	.globl _CY
                                     15 	.globl _AC
                                     16 	.globl _F0
                                     17 	.globl _RS1
                                     18 	.globl _RS0
                                     19 	.globl _OV
                                     20 	.globl _F1
                                     21 	.globl _P
                                     22 	.globl _PS
                                     23 	.globl _PT1
                                     24 	.globl _PX1
                                     25 	.globl _PT0
                                     26 	.globl _PX0
                                     27 	.globl _RD
                                     28 	.globl _WR
                                     29 	.globl _T1
                                     30 	.globl _T0
                                     31 	.globl _INT1
                                     32 	.globl _INT0
                                     33 	.globl _TXD
                                     34 	.globl _RXD
                                     35 	.globl _P3_7
                                     36 	.globl _P3_6
                                     37 	.globl _P3_5
                                     38 	.globl _P3_4
                                     39 	.globl _P3_3
                                     40 	.globl _P3_2
                                     41 	.globl _P3_1
                                     42 	.globl _P3_0
                                     43 	.globl _EA
                                     44 	.globl _ES
                                     45 	.globl _ET1
                                     46 	.globl _EX1
                                     47 	.globl _ET0
                                     48 	.globl _EX0
                                     49 	.globl _P2_7
                                     50 	.globl _P2_6
                                     51 	.globl _P2_5
                                     52 	.globl _P2_4
                                     53 	.globl _P2_3
                                     54 	.globl _P2_2
                                     55 	.globl _P2_1
                                     56 	.globl _P2_0
                                     57 	.globl _SM0
                                     58 	.globl _SM1
                                     59 	.globl _SM2
                                     60 	.globl _REN
                                     61 	.globl _TB8
                                     62 	.globl _RB8
                                     63 	.globl _TI
                                     64 	.globl _RI
                                     65 	.globl _P1_7
                                     66 	.globl _P1_6
                                     67 	.globl _P1_5
                                     68 	.globl _P1_4
                                     69 	.globl _P1_3
                                     70 	.globl _P1_2
                                     71 	.globl _P1_1
                                     72 	.globl _P1_0
                                     73 	.globl _TF1
                                     74 	.globl _TR1
                                     75 	.globl _TF0
                                     76 	.globl _TR0
                                     77 	.globl _IE1
                                     78 	.globl _IT1
                                     79 	.globl _IE0
                                     80 	.globl _IT0
                                     81 	.globl _P0_7
                                     82 	.globl _P0_6
                                     83 	.globl _P0_5
                                     84 	.globl _P0_4
                                     85 	.globl _P0_3
                                     86 	.globl _P0_2
                                     87 	.globl _P0_1
                                     88 	.globl _P0_0
                                     89 	.globl _B
                                     90 	.globl _ACC
                                     91 	.globl _PSW
                                     92 	.globl _IP
                                     93 	.globl _P3
                                     94 	.globl _IE
                                     95 	.globl _P2
                                     96 	.globl _SBUF
                                     97 	.globl _SCON
                                     98 	.globl _P1
                                     99 	.globl _TH1
                                    100 	.globl _TH0
                                    101 	.globl _TL1
                                    102 	.globl _TL0
                                    103 	.globl _TMOD
                                    104 	.globl _TCON
                                    105 	.globl _PCON
                                    106 	.globl _DPH
                                    107 	.globl _DPL
                                    108 	.globl _SP
                                    109 	.globl _P0
                                    110 	.globl _tmp2
                                    111 	.globl _tmp
                                    112 	.globl _i
                                    113 	.globl _newThreadID
                                    114 	.globl _bitmap
                                    115 	.globl _curThreadID
                                    116 	.globl _sp
                                    117 	.globl _ThreadCreate
                                    118 	.globl _ThreadYield
                                    119 	.globl _ThreadExit
                                    120 ;--------------------------------------------------------
                                    121 ; special function registers
                                    122 ;--------------------------------------------------------
                                    123 	.area RSEG    (ABS,DATA)
      000000                        124 	.org 0x0000
                           000080   125 _P0	=	0x0080
                           000081   126 _SP	=	0x0081
                           000082   127 _DPL	=	0x0082
                           000083   128 _DPH	=	0x0083
                           000087   129 _PCON	=	0x0087
                           000088   130 _TCON	=	0x0088
                           000089   131 _TMOD	=	0x0089
                           00008A   132 _TL0	=	0x008a
                           00008B   133 _TL1	=	0x008b
                           00008C   134 _TH0	=	0x008c
                           00008D   135 _TH1	=	0x008d
                           000090   136 _P1	=	0x0090
                           000098   137 _SCON	=	0x0098
                           000099   138 _SBUF	=	0x0099
                           0000A0   139 _P2	=	0x00a0
                           0000A8   140 _IE	=	0x00a8
                           0000B0   141 _P3	=	0x00b0
                           0000B8   142 _IP	=	0x00b8
                           0000D0   143 _PSW	=	0x00d0
                           0000E0   144 _ACC	=	0x00e0
                           0000F0   145 _B	=	0x00f0
                                    146 ;--------------------------------------------------------
                                    147 ; special function bits
                                    148 ;--------------------------------------------------------
                                    149 	.area RSEG    (ABS,DATA)
      000000                        150 	.org 0x0000
                           000080   151 _P0_0	=	0x0080
                           000081   152 _P0_1	=	0x0081
                           000082   153 _P0_2	=	0x0082
                           000083   154 _P0_3	=	0x0083
                           000084   155 _P0_4	=	0x0084
                           000085   156 _P0_5	=	0x0085
                           000086   157 _P0_6	=	0x0086
                           000087   158 _P0_7	=	0x0087
                           000088   159 _IT0	=	0x0088
                           000089   160 _IE0	=	0x0089
                           00008A   161 _IT1	=	0x008a
                           00008B   162 _IE1	=	0x008b
                           00008C   163 _TR0	=	0x008c
                           00008D   164 _TF0	=	0x008d
                           00008E   165 _TR1	=	0x008e
                           00008F   166 _TF1	=	0x008f
                           000090   167 _P1_0	=	0x0090
                           000091   168 _P1_1	=	0x0091
                           000092   169 _P1_2	=	0x0092
                           000093   170 _P1_3	=	0x0093
                           000094   171 _P1_4	=	0x0094
                           000095   172 _P1_5	=	0x0095
                           000096   173 _P1_6	=	0x0096
                           000097   174 _P1_7	=	0x0097
                           000098   175 _RI	=	0x0098
                           000099   176 _TI	=	0x0099
                           00009A   177 _RB8	=	0x009a
                           00009B   178 _TB8	=	0x009b
                           00009C   179 _REN	=	0x009c
                           00009D   180 _SM2	=	0x009d
                           00009E   181 _SM1	=	0x009e
                           00009F   182 _SM0	=	0x009f
                           0000A0   183 _P2_0	=	0x00a0
                           0000A1   184 _P2_1	=	0x00a1
                           0000A2   185 _P2_2	=	0x00a2
                           0000A3   186 _P2_3	=	0x00a3
                           0000A4   187 _P2_4	=	0x00a4
                           0000A5   188 _P2_5	=	0x00a5
                           0000A6   189 _P2_6	=	0x00a6
                           0000A7   190 _P2_7	=	0x00a7
                           0000A8   191 _EX0	=	0x00a8
                           0000A9   192 _ET0	=	0x00a9
                           0000AA   193 _EX1	=	0x00aa
                           0000AB   194 _ET1	=	0x00ab
                           0000AC   195 _ES	=	0x00ac
                           0000AF   196 _EA	=	0x00af
                           0000B0   197 _P3_0	=	0x00b0
                           0000B1   198 _P3_1	=	0x00b1
                           0000B2   199 _P3_2	=	0x00b2
                           0000B3   200 _P3_3	=	0x00b3
                           0000B4   201 _P3_4	=	0x00b4
                           0000B5   202 _P3_5	=	0x00b5
                           0000B6   203 _P3_6	=	0x00b6
                           0000B7   204 _P3_7	=	0x00b7
                           0000B0   205 _RXD	=	0x00b0
                           0000B1   206 _TXD	=	0x00b1
                           0000B2   207 _INT0	=	0x00b2
                           0000B3   208 _INT1	=	0x00b3
                           0000B4   209 _T0	=	0x00b4
                           0000B5   210 _T1	=	0x00b5
                           0000B6   211 _WR	=	0x00b6
                           0000B7   212 _RD	=	0x00b7
                           0000B8   213 _PX0	=	0x00b8
                           0000B9   214 _PT0	=	0x00b9
                           0000BA   215 _PX1	=	0x00ba
                           0000BB   216 _PT1	=	0x00bb
                           0000BC   217 _PS	=	0x00bc
                           0000D0   218 _P	=	0x00d0
                           0000D1   219 _F1	=	0x00d1
                           0000D2   220 _OV	=	0x00d2
                           0000D3   221 _RS0	=	0x00d3
                           0000D4   222 _RS1	=	0x00d4
                           0000D5   223 _F0	=	0x00d5
                           0000D6   224 _AC	=	0x00d6
                           0000D7   225 _CY	=	0x00d7
                                    226 ;--------------------------------------------------------
                                    227 ; overlayable register banks
                                    228 ;--------------------------------------------------------
                                    229 	.area REG_BANK_0	(REL,OVR,DATA)
      000000                        230 	.ds 8
                                    231 ;--------------------------------------------------------
                                    232 ; internal ram data
                                    233 ;--------------------------------------------------------
                                    234 	.area DSEG    (DATA)
                           000030   235 _sp	=	0x0030
                           000034   236 _curThreadID	=	0x0034
                           000035   237 _bitmap	=	0x0035
                           000036   238 _newThreadID	=	0x0036
                           000037   239 _i	=	0x0037
                           000038   240 _tmp	=	0x0038
                           000039   241 _tmp2	=	0x0039
                                    242 ;--------------------------------------------------------
                                    243 ; overlayable items in internal ram 
                                    244 ;--------------------------------------------------------
                                    245 	.area	OSEG    (OVR,DATA)
                                    246 ;--------------------------------------------------------
                                    247 ; indirectly addressable internal ram data
                                    248 ;--------------------------------------------------------
                                    249 	.area ISEG    (DATA)
                                    250 ;--------------------------------------------------------
                                    251 ; absolute internal ram data
                                    252 ;--------------------------------------------------------
                                    253 	.area IABS    (ABS,DATA)
                                    254 	.area IABS    (ABS,DATA)
                                    255 ;--------------------------------------------------------
                                    256 ; bit data
                                    257 ;--------------------------------------------------------
                                    258 	.area BSEG    (BIT)
                                    259 ;--------------------------------------------------------
                                    260 ; paged external ram data
                                    261 ;--------------------------------------------------------
                                    262 	.area PSEG    (PAG,XDATA)
                                    263 ;--------------------------------------------------------
                                    264 ; external ram data
                                    265 ;--------------------------------------------------------
                                    266 	.area XSEG    (XDATA)
                                    267 ;--------------------------------------------------------
                                    268 ; absolute external ram data
                                    269 ;--------------------------------------------------------
                                    270 	.area XABS    (ABS,XDATA)
                                    271 ;--------------------------------------------------------
                                    272 ; external initialized ram data
                                    273 ;--------------------------------------------------------
                                    274 	.area XISEG   (XDATA)
                                    275 	.area HOME    (CODE)
                                    276 	.area GSINIT0 (CODE)
                                    277 	.area GSINIT1 (CODE)
                                    278 	.area GSINIT2 (CODE)
                                    279 	.area GSINIT3 (CODE)
                                    280 	.area GSINIT4 (CODE)
                                    281 	.area GSINIT5 (CODE)
                                    282 	.area GSINIT  (CODE)
                                    283 	.area GSFINAL (CODE)
                                    284 	.area CSEG    (CODE)
                                    285 ;--------------------------------------------------------
                                    286 ; global & static initialisations
                                    287 ;--------------------------------------------------------
                                    288 	.area HOME    (CODE)
                                    289 	.area GSINIT  (CODE)
                                    290 	.area GSFINAL (CODE)
                                    291 	.area GSINIT  (CODE)
                                    292 ;--------------------------------------------------------
                                    293 ; Home
                                    294 ;--------------------------------------------------------
                                    295 	.area HOME    (CODE)
                                    296 	.area HOME    (CODE)
                                    297 ;--------------------------------------------------------
                                    298 ; code
                                    299 ;--------------------------------------------------------
                                    300 	.area CSEG    (CODE)
                                    301 ;------------------------------------------------------------
                                    302 ;Allocation info for local variables in function 'Bootstrap'
                                    303 ;------------------------------------------------------------
                                    304 ;	preemptive.c:38: void Bootstrap(void) {
                                    305 ;	-----------------------------------------
                                    306 ;	 function Bootstrap
                                    307 ;	-----------------------------------------
      000088                        308 _Bootstrap:
                           000007   309 	ar7 = 0x07
                           000006   310 	ar6 = 0x06
                           000005   311 	ar5 = 0x05
                           000004   312 	ar4 = 0x04
                           000003   313 	ar3 = 0x03
                           000002   314 	ar2 = 0x02
                           000001   315 	ar1 = 0x01
                           000000   316 	ar0 = 0x00
                                    317 ;	preemptive.c:39: TMOD = 0;	//timer 0 mode 0
      000088 75 89 00         [24]  318 	mov	_TMOD,#0x00
                                    319 ;	preemptive.c:40: IE = 0x82;	//enable timer 0 interrupt
      00008B 75 A8 82         [24]  320 	mov	_IE,#0x82
                                    321 ;	preemptive.c:41: TR0 = 1;	//start running timer 0
                                    322 ;	assignBit
      00008E D2 8C            [12]  323 	setb	_TR0
                                    324 ;	preemptive.c:42: bitmap = 0b0000;
      000090 75 35 00         [24]  325 	mov	_bitmap,#0x00
                                    326 ;	preemptive.c:43: curThreadID = ThreadCreate(main);
      000093 90 00 66         [24]  327 	mov	dptr,#_main
      000096 12 00 AE         [24]  328 	lcall	_ThreadCreate
      000099 85 82 34         [24]  329 	mov	_curThreadID,dpl
                                    330 ;	preemptive.c:44: RESTORESTATE;
      00009C E5 34            [12]  331 	mov	a,_curThreadID
      00009E 24 30            [12]  332 	add	a,#_sp
      0000A0 F9               [12]  333 	mov	r1,a
      0000A1 87 81            [24]  334 	mov	_SP,@r1
      0000A3 D0 D0            [24]  335 	pop PSW 
      0000A5 D0 83            [24]  336 	pop DPH 
      0000A7 D0 82            [24]  337 	pop DPL 
      0000A9 D0 F0            [24]  338 	pop B 
      0000AB D0 E0            [24]  339 	pop ACC 
                                    340 ;	preemptive.c:45: }
      0000AD 22               [24]  341 	ret
                                    342 ;------------------------------------------------------------
                                    343 ;Allocation info for local variables in function 'ThreadCreate'
                                    344 ;------------------------------------------------------------
                                    345 ;fp                        Allocated to registers 
                                    346 ;------------------------------------------------------------
                                    347 ;	preemptive.c:47: ThreadID ThreadCreate(FunctionPtr fp) {
                                    348 ;	-----------------------------------------
                                    349 ;	 function ThreadCreate
                                    350 ;	-----------------------------------------
      0000AE                        351 _ThreadCreate:
                                    352 ;	preemptive.c:48: if(bitmap == 0b1111){
      0000AE 74 0F            [12]  353 	mov	a,#0x0f
      0000B0 B5 35 04         [24]  354 	cjne	a,_bitmap,00102$
                                    355 ;	preemptive.c:49: return -1;
      0000B3 75 82 FF         [24]  356 	mov	dpl,#0xff
      0000B6 22               [24]  357 	ret
      0000B7                        358 00102$:
                                    359 ;	preemptive.c:81: }
      0000B7 7F 01            [12]  360 	mov	r7,#0x01
      0000B9 10 AF 02         [24]  361 	jbc	ea,00129$
      0000BC 7F 00            [12]  362 	mov	r7,#0x00
      0000BE                        363 00129$:
                                    364 ;	preemptive.c:53: for(i=0;i<MAXTHREADS;i++) {
      0000BE 75 37 00         [24]  365 	mov	_i,#0x00
      0000C1                        366 00107$:
      0000C1 74 FC            [12]  367 	mov	a,#0x100 - 0x04
      0000C3 25 37            [12]  368 	add	a,_i
      0000C5 40 41            [24]  369 	jc	00105$
                                    370 ;	preemptive.c:54: if((bitmap & (1<<i)) == 0) {
      0000C7 AE 37            [24]  371 	mov	r6,_i
      0000C9 8E F0            [24]  372 	mov	b,r6
      0000CB 05 F0            [12]  373 	inc	b
      0000CD 7E 01            [12]  374 	mov	r6,#0x01
      0000CF 7D 00            [12]  375 	mov	r5,#0x00
      0000D1 80 06            [24]  376 	sjmp	00132$
      0000D3                        377 00131$:
      0000D3 EE               [12]  378 	mov	a,r6
      0000D4 2E               [12]  379 	add	a,r6
      0000D5 FE               [12]  380 	mov	r6,a
      0000D6 ED               [12]  381 	mov	a,r5
      0000D7 33               [12]  382 	rlc	a
      0000D8 FD               [12]  383 	mov	r5,a
      0000D9                        384 00132$:
      0000D9 D5 F0 F7         [24]  385 	djnz	b,00131$
      0000DC AB 35            [24]  386 	mov	r3,_bitmap
      0000DE 7C 00            [12]  387 	mov	r4,#0x00
      0000E0 EB               [12]  388 	mov	a,r3
      0000E1 52 06            [12]  389 	anl	ar6,a
      0000E3 EC               [12]  390 	mov	a,r4
      0000E4 52 05            [12]  391 	anl	ar5,a
      0000E6 EE               [12]  392 	mov	a,r6
      0000E7 4D               [12]  393 	orl	a,r5
      0000E8 70 1A            [24]  394 	jnz	00108$
                                    395 ;	preemptive.c:55: bitmap |= (1<<i);
      0000EA AE 37            [24]  396 	mov	r6,_i
      0000EC 8E F0            [24]  397 	mov	b,r6
      0000EE 05 F0            [12]  398 	inc	b
      0000F0 74 01            [12]  399 	mov	a,#0x01
      0000F2 80 02            [24]  400 	sjmp	00136$
      0000F4                        401 00134$:
      0000F4 25 E0            [12]  402 	add	a,acc
      0000F6                        403 00136$:
      0000F6 D5 F0 FB         [24]  404 	djnz	b,00134$
      0000F9 FE               [12]  405 	mov	r6,a
      0000FA AD 35            [24]  406 	mov	r5,_bitmap
      0000FC 4D               [12]  407 	orl	a,r5
      0000FD F5 35            [12]  408 	mov	_bitmap,a
                                    409 ;	preemptive.c:56: newThreadID = i;
      0000FF 85 37 36         [24]  410 	mov	_newThreadID,_i
                                    411 ;	preemptive.c:57: break;
      000102 80 04            [24]  412 	sjmp	00105$
      000104                        413 00108$:
                                    414 ;	preemptive.c:53: for(i=0;i<MAXTHREADS;i++) {
      000104 05 37            [12]  415 	inc	_i
      000106 80 B9            [24]  416 	sjmp	00107$
      000108                        417 00105$:
                                    418 ;	preemptive.c:61: tmp = SP;
      000108 85 81 38         [24]  419 	mov	_tmp,_SP
                                    420 ;	preemptive.c:62: SP = 0x3F + (newThreadID<<4); //not 0x40, since push is pre increment
      00010B E5 36            [12]  421 	mov	a,_newThreadID
      00010D C4               [12]  422 	swap	a
      00010E 54 F0            [12]  423 	anl	a,#0xf0
      000110 FE               [12]  424 	mov	r6,a
      000111 24 3F            [12]  425 	add	a,#0x3f
      000113 F5 81            [12]  426 	mov	_SP,a
                                    427 ;	preemptive.c:72: __endasm;
      000115 C0 82            [24]  428 	push	DPL
      000117 C0 83            [24]  429 	push	DPH
      000119 74 00            [12]  430 	mov	A, #0
      00011B C0 E0            [24]  431 	push	A
      00011D C0 E0            [24]  432 	push	A
      00011F C0 E0            [24]  433 	push	A
      000121 C0 E0            [24]  434 	push	A
                                    435 ;	preemptive.c:74: tmp2 = (newThreadID<<3);
      000123 E5 36            [12]  436 	mov	a,_newThreadID
      000125 FE               [12]  437 	mov	r6,a
      000126 C4               [12]  438 	swap	a
      000127 03               [12]  439 	rr	a
      000128 54 F8            [12]  440 	anl	a,#0xf8
      00012A F5 39            [12]  441 	mov	_tmp2,a
                                    442 ;	preemptive.c:77: __endasm;
      00012C C0 39            [24]  443 	push	_tmp2
                                    444 ;	preemptive.c:79: sp[newThreadID] = SP;
      00012E E5 36            [12]  445 	mov	a,_newThreadID
      000130 24 30            [12]  446 	add	a,#_sp
      000132 F8               [12]  447 	mov	r0,a
      000133 A6 81            [24]  448 	mov	@r0,_SP
                                    449 ;	preemptive.c:80: SP = tmp;
      000135 85 38 81         [24]  450 	mov	_SP,_tmp
      000138 EF               [12]  451 	mov	a,r7
      000139 13               [12]  452 	rrc	a
      00013A 92 AF            [24]  453 	mov	ea,c
                                    454 ;	preemptive.c:82: return newThreadID;
      00013C 85 36 82         [24]  455 	mov	dpl,_newThreadID
                                    456 ;	preemptive.c:83: }
      00013F 22               [24]  457 	ret
                                    458 ;------------------------------------------------------------
                                    459 ;Allocation info for local variables in function 'ThreadYield'
                                    460 ;------------------------------------------------------------
                                    461 ;	preemptive.c:85: void ThreadYield(void) {
                                    462 ;	-----------------------------------------
                                    463 ;	 function ThreadYield
                                    464 ;	-----------------------------------------
      000140                        465 _ThreadYield:
                                    466 ;	preemptive.c:99: }
      000140 7F 01            [12]  467 	mov	r7,#0x01
      000142 10 AF 02         [24]  468 	jbc	ea,00122$
      000145 7F 00            [12]  469 	mov	r7,#0x00
      000147                        470 00122$:
                                    471 ;	preemptive.c:87: SAVESTATE;
      000147 C0 E0            [24]  472 	push ACC 
      000149 C0 F0            [24]  473 	push B 
      00014B C0 82            [24]  474 	push DPL 
      00014D C0 83            [24]  475 	push DPH 
      00014F C0 D0            [24]  476 	push PSW 
      000151 E5 34            [12]  477 	mov	a,_curThreadID
      000153 24 30            [12]  478 	add	a,#_sp
      000155 F8               [12]  479 	mov	r0,a
      000156 A6 81            [24]  480 	mov	@r0,_SP
                                    481 ;	preemptive.c:88: do {
      000158                        482 00105$:
                                    483 ;	preemptive.c:89: curThreadID++;
      000158 05 34            [12]  484 	inc	_curThreadID
                                    485 ;	preemptive.c:90: if(curThreadID == MAXTHREADS){
      00015A 74 04            [12]  486 	mov	a,#0x04
      00015C B5 34 03         [24]  487 	cjne	a,_curThreadID,00102$
                                    488 ;	preemptive.c:91: curThreadID = 0;
      00015F 75 34 00         [24]  489 	mov	_curThreadID,#0x00
      000162                        490 00102$:
                                    491 ;	preemptive.c:94: if(bitmap & (1<<curThreadID)){
      000162 AE 34            [24]  492 	mov	r6,_curThreadID
      000164 8E F0            [24]  493 	mov	b,r6
      000166 05 F0            [12]  494 	inc	b
      000168 7E 01            [12]  495 	mov	r6,#0x01
      00016A 7D 00            [12]  496 	mov	r5,#0x00
      00016C 80 06            [24]  497 	sjmp	00126$
      00016E                        498 00125$:
      00016E EE               [12]  499 	mov	a,r6
      00016F 2E               [12]  500 	add	a,r6
      000170 FE               [12]  501 	mov	r6,a
      000171 ED               [12]  502 	mov	a,r5
      000172 33               [12]  503 	rlc	a
      000173 FD               [12]  504 	mov	r5,a
      000174                        505 00126$:
      000174 D5 F0 F7         [24]  506 	djnz	b,00125$
      000177 AB 35            [24]  507 	mov	r3,_bitmap
      000179 7C 00            [12]  508 	mov	r4,#0x00
      00017B EB               [12]  509 	mov	a,r3
      00017C 52 06            [12]  510 	anl	ar6,a
      00017E EC               [12]  511 	mov	a,r4
      00017F 52 05            [12]  512 	anl	ar5,a
      000181 EE               [12]  513 	mov	a,r6
      000182 4D               [12]  514 	orl	a,r5
      000183 60 D3            [24]  515 	jz	00105$
                                    516 ;	preemptive.c:98: RESTORESTATE;
      000185 E5 34            [12]  517 	mov	a,_curThreadID
      000187 24 30            [12]  518 	add	a,#_sp
      000189 F9               [12]  519 	mov	r1,a
      00018A 87 81            [24]  520 	mov	_SP,@r1
      00018C D0 D0            [24]  521 	pop PSW 
      00018E D0 83            [24]  522 	pop DPH 
      000190 D0 82            [24]  523 	pop DPL 
      000192 D0 F0            [24]  524 	pop B 
      000194 D0 E0            [24]  525 	pop ACC 
      000196 EF               [12]  526 	mov	a,r7
      000197 13               [12]  527 	rrc	a
      000198 92 AF            [24]  528 	mov	ea,c
                                    529 ;	preemptive.c:100: }
      00019A 22               [24]  530 	ret
                                    531 ;------------------------------------------------------------
                                    532 ;Allocation info for local variables in function 'ThreadExit'
                                    533 ;------------------------------------------------------------
                                    534 ;	preemptive.c:102: void ThreadExit(void) {
                                    535 ;	-----------------------------------------
                                    536 ;	 function ThreadExit
                                    537 ;	-----------------------------------------
      00019B                        538 _ThreadExit:
                                    539 ;	preemptive.c:116: }
      00019B 7F 01            [12]  540 	mov	r7,#0x01
      00019D 10 AF 02         [24]  541 	jbc	ea,00122$
      0001A0 7F 00            [12]  542 	mov	r7,#0x00
      0001A2                        543 00122$:
                                    544 ;	preemptive.c:104: bitmap ^= (1<<curThreadID);
      0001A2 AE 34            [24]  545 	mov	r6,_curThreadID
      0001A4 8E F0            [24]  546 	mov	b,r6
      0001A6 05 F0            [12]  547 	inc	b
      0001A8 74 01            [12]  548 	mov	a,#0x01
      0001AA 80 02            [24]  549 	sjmp	00125$
      0001AC                        550 00123$:
      0001AC 25 E0            [12]  551 	add	a,acc
      0001AE                        552 00125$:
      0001AE D5 F0 FB         [24]  553 	djnz	b,00123$
      0001B1 FE               [12]  554 	mov	r6,a
      0001B2 AD 35            [24]  555 	mov	r5,_bitmap
      0001B4 6D               [12]  556 	xrl	a,r5
      0001B5 F5 35            [12]  557 	mov	_bitmap,a
                                    558 ;	preemptive.c:105: do {
      0001B7                        559 00105$:
                                    560 ;	preemptive.c:106: curThreadID++;
      0001B7 05 34            [12]  561 	inc	_curThreadID
                                    562 ;	preemptive.c:107: if(curThreadID == MAXTHREADS){
      0001B9 74 04            [12]  563 	mov	a,#0x04
      0001BB B5 34 03         [24]  564 	cjne	a,_curThreadID,00102$
                                    565 ;	preemptive.c:108: curThreadID = 0;
      0001BE 75 34 00         [24]  566 	mov	_curThreadID,#0x00
      0001C1                        567 00102$:
                                    568 ;	preemptive.c:111: if(bitmap & (1<<curThreadID)){
      0001C1 AE 34            [24]  569 	mov	r6,_curThreadID
      0001C3 8E F0            [24]  570 	mov	b,r6
      0001C5 05 F0            [12]  571 	inc	b
      0001C7 7E 01            [12]  572 	mov	r6,#0x01
      0001C9 7D 00            [12]  573 	mov	r5,#0x00
      0001CB 80 06            [24]  574 	sjmp	00129$
      0001CD                        575 00128$:
      0001CD EE               [12]  576 	mov	a,r6
      0001CE 2E               [12]  577 	add	a,r6
      0001CF FE               [12]  578 	mov	r6,a
      0001D0 ED               [12]  579 	mov	a,r5
      0001D1 33               [12]  580 	rlc	a
      0001D2 FD               [12]  581 	mov	r5,a
      0001D3                        582 00129$:
      0001D3 D5 F0 F7         [24]  583 	djnz	b,00128$
      0001D6 AB 35            [24]  584 	mov	r3,_bitmap
      0001D8 7C 00            [12]  585 	mov	r4,#0x00
      0001DA EB               [12]  586 	mov	a,r3
      0001DB 52 06            [12]  587 	anl	ar6,a
      0001DD EC               [12]  588 	mov	a,r4
      0001DE 52 05            [12]  589 	anl	ar5,a
      0001E0 EE               [12]  590 	mov	a,r6
      0001E1 4D               [12]  591 	orl	a,r5
      0001E2 60 D3            [24]  592 	jz	00105$
                                    593 ;	preemptive.c:115: RESTORESTATE;
      0001E4 E5 34            [12]  594 	mov	a,_curThreadID
      0001E6 24 30            [12]  595 	add	a,#_sp
      0001E8 F9               [12]  596 	mov	r1,a
      0001E9 87 81            [24]  597 	mov	_SP,@r1
      0001EB D0 D0            [24]  598 	pop PSW 
      0001ED D0 83            [24]  599 	pop DPH 
      0001EF D0 82            [24]  600 	pop DPL 
      0001F1 D0 F0            [24]  601 	pop B 
      0001F3 D0 E0            [24]  602 	pop ACC 
      0001F5 EF               [12]  603 	mov	a,r7
      0001F6 13               [12]  604 	rrc	a
      0001F7 92 AF            [24]  605 	mov	ea,c
                                    606 ;	preemptive.c:117: }
      0001F9 22               [24]  607 	ret
                                    608 ;------------------------------------------------------------
                                    609 ;Allocation info for local variables in function 'myTimer0Handler'
                                    610 ;------------------------------------------------------------
                                    611 ;	preemptive.c:119: void myTimer0Handler(void) {
                                    612 ;	-----------------------------------------
                                    613 ;	 function myTimer0Handler
                                    614 ;	-----------------------------------------
      0001FA                        615 _myTimer0Handler:
                                    616 ;	preemptive.c:120: SAVESTATE;
      0001FA C0 E0            [24]  617 	push ACC 
      0001FC C0 F0            [24]  618 	push B 
      0001FE C0 82            [24]  619 	push DPL 
      000200 C0 83            [24]  620 	push DPH 
      000202 C0 D0            [24]  621 	push PSW 
      000204 E5 34            [12]  622 	mov	a,_curThreadID
      000206 24 30            [12]  623 	add	a,#_sp
      000208 F8               [12]  624 	mov	r0,a
      000209 A6 81            [24]  625 	mov	@r0,_SP
                                    626 ;	preemptive.c:130: __endasm;
      00020B 89 E0            [24]  627 	mov	ACC, r1
      00020D 8A F0            [24]  628 	mov	B, r2
      00020F 8B 82            [24]  629 	mov	DPL, r3
      000211 8C 83            [24]  630 	mov	DPH, r4
      000213 8D D0            [24]  631 	mov	PSW, r5
      000215 8E 38            [24]  632 	mov	_tmp, r6
      000217 8F 39            [24]  633 	mov	_tmp2, r7
                                    634 ;	preemptive.c:132: do {
      000219                        635 00105$:
                                    636 ;	preemptive.c:133: curThreadID++;
      000219 05 34            [12]  637 	inc	_curThreadID
                                    638 ;	preemptive.c:134: if(curThreadID == MAXTHREADS){
      00021B 74 04            [12]  639 	mov	a,#0x04
      00021D B5 34 03         [24]  640 	cjne	a,_curThreadID,00102$
                                    641 ;	preemptive.c:135: curThreadID = 0;
      000220 75 34 00         [24]  642 	mov	_curThreadID,#0x00
      000223                        643 00102$:
                                    644 ;	preemptive.c:138: if(bitmap & (1<<curThreadID)){
      000223 AF 34            [24]  645 	mov	r7,_curThreadID
      000225 8F F0            [24]  646 	mov	b,r7
      000227 05 F0            [12]  647 	inc	b
      000229 7F 01            [12]  648 	mov	r7,#0x01
      00022B 7E 00            [12]  649 	mov	r6,#0x00
      00022D 80 06            [24]  650 	sjmp	00125$
      00022F                        651 00124$:
      00022F EF               [12]  652 	mov	a,r7
      000230 2F               [12]  653 	add	a,r7
      000231 FF               [12]  654 	mov	r7,a
      000232 EE               [12]  655 	mov	a,r6
      000233 33               [12]  656 	rlc	a
      000234 FE               [12]  657 	mov	r6,a
      000235                        658 00125$:
      000235 D5 F0 F7         [24]  659 	djnz	b,00124$
      000238 AC 35            [24]  660 	mov	r4,_bitmap
      00023A 7D 00            [12]  661 	mov	r5,#0x00
      00023C EC               [12]  662 	mov	a,r4
      00023D 52 07            [12]  663 	anl	ar7,a
      00023F ED               [12]  664 	mov	a,r5
      000240 52 06            [12]  665 	anl	ar6,a
      000242 EF               [12]  666 	mov	a,r7
      000243 4E               [12]  667 	orl	a,r6
      000244 60 D3            [24]  668 	jz	00105$
                                    669 ;	preemptive.c:151: __endasm;
      000246 A9 E0            [24]  670 	mov	r1, ACC
      000248 AA F0            [24]  671 	mov	r2, B
      00024A AB 82            [24]  672 	mov	r3, DPL
      00024C AC 83            [24]  673 	mov	r4, DPH
      00024E AD D0            [24]  674 	mov	r5, PSW
      000250 AE 38            [24]  675 	mov	r6, _tmp
      000252 AF 39            [24]  676 	mov	r7, _tmp2
                                    677 ;	preemptive.c:153: RESTORESTATE;
      000254 E5 34            [12]  678 	mov	a,_curThreadID
      000256 24 30            [12]  679 	add	a,#_sp
      000258 F9               [12]  680 	mov	r1,a
      000259 87 81            [24]  681 	mov	_SP,@r1
      00025B D0 D0            [24]  682 	pop PSW 
      00025D D0 83            [24]  683 	pop DPH 
      00025F D0 82            [24]  684 	pop DPL 
      000261 D0 F0            [24]  685 	pop B 
      000263 D0 E0            [24]  686 	pop ACC 
                                    687 ;	preemptive.c:157: __endasm;
      000265 32               [24]  688 	reti
                                    689 ;	preemptive.c:158: }
      000266 22               [24]  690 	ret
                                    691 	.area CSEG    (CODE)
                                    692 	.area CONST   (CODE)
                                    693 	.area XINIT   (CODE)
                                    694 	.area CABS    (ABS,CODE)
