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
                                    304 ;	preemptive.c:43: void Bootstrap(void) {
                                    305 ;	-----------------------------------------
                                    306 ;	 function Bootstrap
                                    307 ;	-----------------------------------------
      000126                        308 _Bootstrap:
                           000007   309 	ar7 = 0x07
                           000006   310 	ar6 = 0x06
                           000005   311 	ar5 = 0x05
                           000004   312 	ar4 = 0x04
                           000003   313 	ar3 = 0x03
                           000002   314 	ar2 = 0x02
                           000001   315 	ar1 = 0x01
                           000000   316 	ar0 = 0x00
                                    317 ;	preemptive.c:44: TMOD = 0;	//timer 0 mode 0
      000126 75 89 00         [24]  318 	mov	_TMOD,#0x00
                                    319 ;	preemptive.c:45: IE = 0x82;	//enable timer 0 interrupt
      000129 75 A8 82         [24]  320 	mov	_IE,#0x82
                                    321 ;	preemptive.c:46: TR0 = 1;	//start running timer 0
                                    322 ;	assignBit
      00012C D2 8C            [12]  323 	setb	_TR0
                                    324 ;	preemptive.c:47: bitmap = 0b0000;
      00012E 75 35 00         [24]  325 	mov	_bitmap,#0x00
                                    326 ;	preemptive.c:48: curThreadID = ThreadCreate(main);
      000131 90 00 DD         [24]  327 	mov	dptr,#_main
      000134 12 01 4C         [24]  328 	lcall	_ThreadCreate
      000137 85 82 34         [24]  329 	mov	_curThreadID,dpl
                                    330 ;	preemptive.c:49: RESTORESTATE;
      00013A E5 34            [12]  331 	mov	a,_curThreadID
      00013C 24 30            [12]  332 	add	a,#_sp
      00013E F9               [12]  333 	mov	r1,a
      00013F 87 81            [24]  334 	mov	_SP,@r1
      000141 D0 D0            [24]  335 	pop PSW 
      000143 D0 83            [24]  336 	pop DPH 
      000145 D0 82            [24]  337 	pop DPL 
      000147 D0 F0            [24]  338 	pop B 
      000149 D0 E0            [24]  339 	pop ACC 
                                    340 ;	preemptive.c:50: }
      00014B 22               [24]  341 	ret
                                    342 ;------------------------------------------------------------
                                    343 ;Allocation info for local variables in function 'ThreadCreate'
                                    344 ;------------------------------------------------------------
                                    345 ;fp                        Allocated to registers 
                                    346 ;------------------------------------------------------------
                                    347 ;	preemptive.c:53: ThreadID ThreadCreate(FunctionPtr fp) {
                                    348 ;	-----------------------------------------
                                    349 ;	 function ThreadCreate
                                    350 ;	-----------------------------------------
      00014C                        351 _ThreadCreate:
                                    352 ;	preemptive.c:54: if(bitmap == 0b1111){
      00014C 74 0F            [12]  353 	mov	a,#0x0f
      00014E B5 35 04         [24]  354 	cjne	a,_bitmap,00102$
                                    355 ;	preemptive.c:55: return -1;
      000151 75 82 FF         [24]  356 	mov	dpl,#0xff
      000154 22               [24]  357 	ret
      000155                        358 00102$:
                                    359 ;	preemptive.c:58: EA=0;
                                    360 ;	assignBit
      000155 C2 AF            [12]  361 	clr	_EA
                                    362 ;	preemptive.c:60: for(i=0;i<MAXTHREADS;i++) {
      000157 75 37 00         [24]  363 	mov	_i,#0x00
      00015A                        364 00107$:
      00015A 74 FC            [12]  365 	mov	a,#0x100 - 0x04
      00015C 25 37            [12]  366 	add	a,_i
      00015E 40 41            [24]  367 	jc	00105$
                                    368 ;	preemptive.c:61: if((bitmap & (1<<i)) == 0) {
      000160 AF 37            [24]  369 	mov	r7,_i
      000162 8F F0            [24]  370 	mov	b,r7
      000164 05 F0            [12]  371 	inc	b
      000166 7F 01            [12]  372 	mov	r7,#0x01
      000168 7E 00            [12]  373 	mov	r6,#0x00
      00016A 80 06            [24]  374 	sjmp	00131$
      00016C                        375 00130$:
      00016C EF               [12]  376 	mov	a,r7
      00016D 2F               [12]  377 	add	a,r7
      00016E FF               [12]  378 	mov	r7,a
      00016F EE               [12]  379 	mov	a,r6
      000170 33               [12]  380 	rlc	a
      000171 FE               [12]  381 	mov	r6,a
      000172                        382 00131$:
      000172 D5 F0 F7         [24]  383 	djnz	b,00130$
      000175 AC 35            [24]  384 	mov	r4,_bitmap
      000177 7D 00            [12]  385 	mov	r5,#0x00
      000179 EC               [12]  386 	mov	a,r4
      00017A 52 07            [12]  387 	anl	ar7,a
      00017C ED               [12]  388 	mov	a,r5
      00017D 52 06            [12]  389 	anl	ar6,a
      00017F EF               [12]  390 	mov	a,r7
      000180 4E               [12]  391 	orl	a,r6
      000181 70 1A            [24]  392 	jnz	00108$
                                    393 ;	preemptive.c:62: bitmap |= (1<<i);
      000183 AF 37            [24]  394 	mov	r7,_i
      000185 8F F0            [24]  395 	mov	b,r7
      000187 05 F0            [12]  396 	inc	b
      000189 74 01            [12]  397 	mov	a,#0x01
      00018B 80 02            [24]  398 	sjmp	00135$
      00018D                        399 00133$:
      00018D 25 E0            [12]  400 	add	a,acc
      00018F                        401 00135$:
      00018F D5 F0 FB         [24]  402 	djnz	b,00133$
      000192 FF               [12]  403 	mov	r7,a
      000193 AE 35            [24]  404 	mov	r6,_bitmap
      000195 4E               [12]  405 	orl	a,r6
      000196 F5 35            [12]  406 	mov	_bitmap,a
                                    407 ;	preemptive.c:63: newThreadID = i;
      000198 85 37 36         [24]  408 	mov	_newThreadID,_i
                                    409 ;	preemptive.c:64: break;
      00019B 80 04            [24]  410 	sjmp	00105$
      00019D                        411 00108$:
                                    412 ;	preemptive.c:60: for(i=0;i<MAXTHREADS;i++) {
      00019D 05 37            [12]  413 	inc	_i
      00019F 80 B9            [24]  414 	sjmp	00107$
      0001A1                        415 00105$:
                                    416 ;	preemptive.c:70: tmp = SP;
      0001A1 85 81 38         [24]  417 	mov	_tmp,_SP
                                    418 ;	preemptive.c:71: SP = 0x3F + (newThreadID<<4); //not 0x40, since push is pre increment
      0001A4 E5 36            [12]  419 	mov	a,_newThreadID
      0001A6 C4               [12]  420 	swap	a
      0001A7 54 F0            [12]  421 	anl	a,#0xf0
      0001A9 FF               [12]  422 	mov	r7,a
      0001AA 24 3F            [12]  423 	add	a,#0x3f
      0001AC F5 81            [12]  424 	mov	_SP,a
                                    425 ;	preemptive.c:83: __endasm;
      0001AE C0 82            [24]  426 	push	DPL
      0001B0 C0 83            [24]  427 	push	DPH
      0001B2 74 00            [12]  428 	mov	A, #0
      0001B4 C0 E0            [24]  429 	push	A
      0001B6 C0 E0            [24]  430 	push	A
      0001B8 C0 E0            [24]  431 	push	A
      0001BA C0 E0            [24]  432 	push	A
                                    433 ;	preemptive.c:86: tmp2 = (newThreadID<<3);
      0001BC E5 36            [12]  434 	mov	a,_newThreadID
      0001BE FF               [12]  435 	mov	r7,a
      0001BF C4               [12]  436 	swap	a
      0001C0 03               [12]  437 	rr	a
      0001C1 54 F8            [12]  438 	anl	a,#0xf8
      0001C3 F5 39            [12]  439 	mov	_tmp2,a
                                    440 ;	preemptive.c:89: __endasm;
      0001C5 C0 39            [24]  441 	push	_tmp2
                                    442 ;	preemptive.c:93: sp[newThreadID] = SP;
      0001C7 E5 36            [12]  443 	mov	a,_newThreadID
      0001C9 24 30            [12]  444 	add	a,#_sp
      0001CB F8               [12]  445 	mov	r0,a
      0001CC A6 81            [24]  446 	mov	@r0,_SP
                                    447 ;	preemptive.c:94: SP = tmp;
      0001CE 85 38 81         [24]  448 	mov	_SP,_tmp
                                    449 ;	preemptive.c:95: EA=1;
                                    450 ;	assignBit
      0001D1 D2 AF            [12]  451 	setb	_EA
                                    452 ;	preemptive.c:96: return newThreadID;
      0001D3 85 36 82         [24]  453 	mov	dpl,_newThreadID
                                    454 ;	preemptive.c:97: }
      0001D6 22               [24]  455 	ret
                                    456 ;------------------------------------------------------------
                                    457 ;Allocation info for local variables in function 'ThreadYield'
                                    458 ;------------------------------------------------------------
                                    459 ;	preemptive.c:99: void ThreadYield(void) {
                                    460 ;	-----------------------------------------
                                    461 ;	 function ThreadYield
                                    462 ;	-----------------------------------------
      0001D7                        463 _ThreadYield:
                                    464 ;	preemptive.c:100: EA=0;
                                    465 ;	assignBit
      0001D7 C2 AF            [12]  466 	clr	_EA
                                    467 ;	preemptive.c:101: SAVESTATE;
      0001D9 C0 E0            [24]  468 	push ACC 
      0001DB C0 F0            [24]  469 	push B 
      0001DD C0 82            [24]  470 	push DPL 
      0001DF C0 83            [24]  471 	push DPH 
      0001E1 C0 D0            [24]  472 	push PSW 
      0001E3 E5 34            [12]  473 	mov	a,_curThreadID
      0001E5 24 30            [12]  474 	add	a,#_sp
      0001E7 F8               [12]  475 	mov	r0,a
      0001E8 A6 81            [24]  476 	mov	@r0,_SP
                                    477 ;	preemptive.c:104: do {
      0001EA                        478 00105$:
                                    479 ;	preemptive.c:105: curThreadID++;
      0001EA 05 34            [12]  480 	inc	_curThreadID
                                    481 ;	preemptive.c:106: if(curThreadID == MAXTHREADS){
      0001EC 74 04            [12]  482 	mov	a,#0x04
      0001EE B5 34 03         [24]  483 	cjne	a,_curThreadID,00102$
                                    484 ;	preemptive.c:107: curThreadID = 0;
      0001F1 75 34 00         [24]  485 	mov	_curThreadID,#0x00
      0001F4                        486 00102$:
                                    487 ;	preemptive.c:110: if(bitmap & (1<<curThreadID)){
      0001F4 AF 34            [24]  488 	mov	r7,_curThreadID
      0001F6 8F F0            [24]  489 	mov	b,r7
      0001F8 05 F0            [12]  490 	inc	b
      0001FA 7F 01            [12]  491 	mov	r7,#0x01
      0001FC 7E 00            [12]  492 	mov	r6,#0x00
      0001FE 80 06            [24]  493 	sjmp	00125$
      000200                        494 00124$:
      000200 EF               [12]  495 	mov	a,r7
      000201 2F               [12]  496 	add	a,r7
      000202 FF               [12]  497 	mov	r7,a
      000203 EE               [12]  498 	mov	a,r6
      000204 33               [12]  499 	rlc	a
      000205 FE               [12]  500 	mov	r6,a
      000206                        501 00125$:
      000206 D5 F0 F7         [24]  502 	djnz	b,00124$
      000209 AC 35            [24]  503 	mov	r4,_bitmap
      00020B 7D 00            [12]  504 	mov	r5,#0x00
      00020D EC               [12]  505 	mov	a,r4
      00020E 52 07            [12]  506 	anl	ar7,a
      000210 ED               [12]  507 	mov	a,r5
      000211 52 06            [12]  508 	anl	ar6,a
      000213 EF               [12]  509 	mov	a,r7
      000214 4E               [12]  510 	orl	a,r6
      000215 60 D3            [24]  511 	jz	00105$
                                    512 ;	preemptive.c:114: RESTORESTATE;
      000217 E5 34            [12]  513 	mov	a,_curThreadID
      000219 24 30            [12]  514 	add	a,#_sp
      00021B F9               [12]  515 	mov	r1,a
      00021C 87 81            [24]  516 	mov	_SP,@r1
      00021E D0 D0            [24]  517 	pop PSW 
      000220 D0 83            [24]  518 	pop DPH 
      000222 D0 82            [24]  519 	pop DPL 
      000224 D0 F0            [24]  520 	pop B 
      000226 D0 E0            [24]  521 	pop ACC 
                                    522 ;	preemptive.c:115: EA=1;
                                    523 ;	assignBit
      000228 D2 AF            [12]  524 	setb	_EA
                                    525 ;	preemptive.c:116: }
      00022A 22               [24]  526 	ret
                                    527 ;------------------------------------------------------------
                                    528 ;Allocation info for local variables in function 'ThreadExit'
                                    529 ;------------------------------------------------------------
                                    530 ;	preemptive.c:118: void ThreadExit(void) {
                                    531 ;	-----------------------------------------
                                    532 ;	 function ThreadExit
                                    533 ;	-----------------------------------------
      00022B                        534 _ThreadExit:
                                    535 ;	preemptive.c:119: EA=0;
                                    536 ;	assignBit
      00022B C2 AF            [12]  537 	clr	_EA
                                    538 ;	preemptive.c:120: bitmap ^= (1<<curThreadID);
      00022D AF 34            [24]  539 	mov	r7,_curThreadID
      00022F 8F F0            [24]  540 	mov	b,r7
      000231 05 F0            [12]  541 	inc	b
      000233 74 01            [12]  542 	mov	a,#0x01
      000235 80 02            [24]  543 	sjmp	00124$
      000237                        544 00122$:
      000237 25 E0            [12]  545 	add	a,acc
      000239                        546 00124$:
      000239 D5 F0 FB         [24]  547 	djnz	b,00122$
      00023C FF               [12]  548 	mov	r7,a
      00023D AE 35            [24]  549 	mov	r6,_bitmap
      00023F 6E               [12]  550 	xrl	a,r6
      000240 F5 35            [12]  551 	mov	_bitmap,a
                                    552 ;	preemptive.c:121: do {
      000242                        553 00105$:
                                    554 ;	preemptive.c:122: curThreadID++;
      000242 05 34            [12]  555 	inc	_curThreadID
                                    556 ;	preemptive.c:123: if(curThreadID == MAXTHREADS){
      000244 74 04            [12]  557 	mov	a,#0x04
      000246 B5 34 03         [24]  558 	cjne	a,_curThreadID,00102$
                                    559 ;	preemptive.c:124: curThreadID = 0;
      000249 75 34 00         [24]  560 	mov	_curThreadID,#0x00
      00024C                        561 00102$:
                                    562 ;	preemptive.c:127: if(bitmap & (1<<curThreadID)){
      00024C AF 34            [24]  563 	mov	r7,_curThreadID
      00024E 8F F0            [24]  564 	mov	b,r7
      000250 05 F0            [12]  565 	inc	b
      000252 7F 01            [12]  566 	mov	r7,#0x01
      000254 7E 00            [12]  567 	mov	r6,#0x00
      000256 80 06            [24]  568 	sjmp	00128$
      000258                        569 00127$:
      000258 EF               [12]  570 	mov	a,r7
      000259 2F               [12]  571 	add	a,r7
      00025A FF               [12]  572 	mov	r7,a
      00025B EE               [12]  573 	mov	a,r6
      00025C 33               [12]  574 	rlc	a
      00025D FE               [12]  575 	mov	r6,a
      00025E                        576 00128$:
      00025E D5 F0 F7         [24]  577 	djnz	b,00127$
      000261 AC 35            [24]  578 	mov	r4,_bitmap
      000263 7D 00            [12]  579 	mov	r5,#0x00
      000265 EC               [12]  580 	mov	a,r4
      000266 52 07            [12]  581 	anl	ar7,a
      000268 ED               [12]  582 	mov	a,r5
      000269 52 06            [12]  583 	anl	ar6,a
      00026B EF               [12]  584 	mov	a,r7
      00026C 4E               [12]  585 	orl	a,r6
      00026D 60 D3            [24]  586 	jz	00105$
                                    587 ;	preemptive.c:131: RESTORESTATE;
      00026F E5 34            [12]  588 	mov	a,_curThreadID
      000271 24 30            [12]  589 	add	a,#_sp
      000273 F9               [12]  590 	mov	r1,a
      000274 87 81            [24]  591 	mov	_SP,@r1
      000276 D0 D0            [24]  592 	pop PSW 
      000278 D0 83            [24]  593 	pop DPH 
      00027A D0 82            [24]  594 	pop DPL 
      00027C D0 F0            [24]  595 	pop B 
      00027E D0 E0            [24]  596 	pop ACC 
                                    597 ;	preemptive.c:132: EA=1;
                                    598 ;	assignBit
      000280 D2 AF            [12]  599 	setb	_EA
                                    600 ;	preemptive.c:133: }
      000282 22               [24]  601 	ret
                                    602 ;------------------------------------------------------------
                                    603 ;Allocation info for local variables in function 'myTimer0Handler'
                                    604 ;------------------------------------------------------------
                                    605 ;	preemptive.c:135: void myTimer0Handler(void) {
                                    606 ;	-----------------------------------------
                                    607 ;	 function myTimer0Handler
                                    608 ;	-----------------------------------------
      000283                        609 _myTimer0Handler:
                                    610 ;	preemptive.c:136: SAVESTATE;
      000283 C0 E0            [24]  611 	push ACC 
      000285 C0 F0            [24]  612 	push B 
      000287 C0 82            [24]  613 	push DPL 
      000289 C0 83            [24]  614 	push DPH 
      00028B C0 D0            [24]  615 	push PSW 
      00028D E5 34            [12]  616 	mov	a,_curThreadID
      00028F 24 30            [12]  617 	add	a,#_sp
      000291 F8               [12]  618 	mov	r0,a
      000292 A6 81            [24]  619 	mov	@r0,_SP
                                    620 ;	preemptive.c:147: __endasm;
      000294 89 E0            [24]  621 	mov	ACC, r1
      000296 8A F0            [24]  622 	mov	B, r2
      000298 8B 82            [24]  623 	mov	DPL, r3
      00029A 8C 83            [24]  624 	mov	DPH, r4
      00029C 8D D0            [24]  625 	mov	PSW, r5
      00029E 8E 38            [24]  626 	mov	_tmp, r6
      0002A0 8F 39            [24]  627 	mov	_tmp2, r7
                                    628 ;	preemptive.c:149: do {
      0002A2                        629 00105$:
                                    630 ;	preemptive.c:150: curThreadID++;
      0002A2 05 34            [12]  631 	inc	_curThreadID
                                    632 ;	preemptive.c:151: if(curThreadID == MAXTHREADS){
      0002A4 74 04            [12]  633 	mov	a,#0x04
      0002A6 B5 34 03         [24]  634 	cjne	a,_curThreadID,00102$
                                    635 ;	preemptive.c:152: curThreadID = 0;
      0002A9 75 34 00         [24]  636 	mov	_curThreadID,#0x00
      0002AC                        637 00102$:
                                    638 ;	preemptive.c:155: if(bitmap & (1<<curThreadID)){
      0002AC AF 34            [24]  639 	mov	r7,_curThreadID
      0002AE 8F F0            [24]  640 	mov	b,r7
      0002B0 05 F0            [12]  641 	inc	b
      0002B2 7F 01            [12]  642 	mov	r7,#0x01
      0002B4 7E 00            [12]  643 	mov	r6,#0x00
      0002B6 80 06            [24]  644 	sjmp	00125$
      0002B8                        645 00124$:
      0002B8 EF               [12]  646 	mov	a,r7
      0002B9 2F               [12]  647 	add	a,r7
      0002BA FF               [12]  648 	mov	r7,a
      0002BB EE               [12]  649 	mov	a,r6
      0002BC 33               [12]  650 	rlc	a
      0002BD FE               [12]  651 	mov	r6,a
      0002BE                        652 00125$:
      0002BE D5 F0 F7         [24]  653 	djnz	b,00124$
      0002C1 AC 35            [24]  654 	mov	r4,_bitmap
      0002C3 7D 00            [12]  655 	mov	r5,#0x00
      0002C5 EC               [12]  656 	mov	a,r4
      0002C6 52 07            [12]  657 	anl	ar7,a
      0002C8 ED               [12]  658 	mov	a,r5
      0002C9 52 06            [12]  659 	anl	ar6,a
      0002CB EF               [12]  660 	mov	a,r7
      0002CC 4E               [12]  661 	orl	a,r6
      0002CD 60 D3            [24]  662 	jz	00105$
                                    663 ;	preemptive.c:169: __endasm;
      0002CF A9 E0            [24]  664 	mov	r1, ACC
      0002D1 AA F0            [24]  665 	mov	r2, B
      0002D3 AB 82            [24]  666 	mov	r3, DPL
      0002D5 AC 83            [24]  667 	mov	r4, DPH
      0002D7 AD D0            [24]  668 	mov	r5, PSW
      0002D9 AE 38            [24]  669 	mov	r6, _tmp
      0002DB AF 39            [24]  670 	mov	r7, _tmp2
                                    671 ;	preemptive.c:171: RESTORESTATE;
      0002DD E5 34            [12]  672 	mov	a,_curThreadID
      0002DF 24 30            [12]  673 	add	a,#_sp
      0002E1 F9               [12]  674 	mov	r1,a
      0002E2 87 81            [24]  675 	mov	_SP,@r1
      0002E4 D0 D0            [24]  676 	pop PSW 
      0002E6 D0 83            [24]  677 	pop DPH 
      0002E8 D0 82            [24]  678 	pop DPL 
      0002EA D0 F0            [24]  679 	pop B 
      0002EC D0 E0            [24]  680 	pop ACC 
                                    681 ;	preemptive.c:175: __endasm;
      0002EE 32               [24]  682 	reti
                                    683 ;	preemptive.c:176: }
      0002EF 22               [24]  684 	ret
                                    685 	.area CSEG    (CODE)
                                    686 	.area CONST   (CODE)
                                    687 	.area XINIT   (CODE)
                                    688 	.area CABS    (ABS,CODE)
