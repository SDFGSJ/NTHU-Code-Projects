                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 3.8.0 #10562 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module cooperative
                                      6 	.optsdcc -mmcs51 --model-small
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _Bootstrap
                                     12 	.globl _main
                                     13 	.globl _CY
                                     14 	.globl _AC
                                     15 	.globl _F0
                                     16 	.globl _RS1
                                     17 	.globl _RS0
                                     18 	.globl _OV
                                     19 	.globl _F1
                                     20 	.globl _P
                                     21 	.globl _PS
                                     22 	.globl _PT1
                                     23 	.globl _PX1
                                     24 	.globl _PT0
                                     25 	.globl _PX0
                                     26 	.globl _RD
                                     27 	.globl _WR
                                     28 	.globl _T1
                                     29 	.globl _T0
                                     30 	.globl _INT1
                                     31 	.globl _INT0
                                     32 	.globl _TXD
                                     33 	.globl _RXD
                                     34 	.globl _P3_7
                                     35 	.globl _P3_6
                                     36 	.globl _P3_5
                                     37 	.globl _P3_4
                                     38 	.globl _P3_3
                                     39 	.globl _P3_2
                                     40 	.globl _P3_1
                                     41 	.globl _P3_0
                                     42 	.globl _EA
                                     43 	.globl _ES
                                     44 	.globl _ET1
                                     45 	.globl _EX1
                                     46 	.globl _ET0
                                     47 	.globl _EX0
                                     48 	.globl _P2_7
                                     49 	.globl _P2_6
                                     50 	.globl _P2_5
                                     51 	.globl _P2_4
                                     52 	.globl _P2_3
                                     53 	.globl _P2_2
                                     54 	.globl _P2_1
                                     55 	.globl _P2_0
                                     56 	.globl _SM0
                                     57 	.globl _SM1
                                     58 	.globl _SM2
                                     59 	.globl _REN
                                     60 	.globl _TB8
                                     61 	.globl _RB8
                                     62 	.globl _TI
                                     63 	.globl _RI
                                     64 	.globl _P1_7
                                     65 	.globl _P1_6
                                     66 	.globl _P1_5
                                     67 	.globl _P1_4
                                     68 	.globl _P1_3
                                     69 	.globl _P1_2
                                     70 	.globl _P1_1
                                     71 	.globl _P1_0
                                     72 	.globl _TF1
                                     73 	.globl _TR1
                                     74 	.globl _TF0
                                     75 	.globl _TR0
                                     76 	.globl _IE1
                                     77 	.globl _IT1
                                     78 	.globl _IE0
                                     79 	.globl _IT0
                                     80 	.globl _P0_7
                                     81 	.globl _P0_6
                                     82 	.globl _P0_5
                                     83 	.globl _P0_4
                                     84 	.globl _P0_3
                                     85 	.globl _P0_2
                                     86 	.globl _P0_1
                                     87 	.globl _P0_0
                                     88 	.globl _B
                                     89 	.globl _ACC
                                     90 	.globl _PSW
                                     91 	.globl _IP
                                     92 	.globl _P3
                                     93 	.globl _IE
                                     94 	.globl _P2
                                     95 	.globl _SBUF
                                     96 	.globl _SCON
                                     97 	.globl _P1
                                     98 	.globl _TH1
                                     99 	.globl _TH0
                                    100 	.globl _TL1
                                    101 	.globl _TL0
                                    102 	.globl _TMOD
                                    103 	.globl _TCON
                                    104 	.globl _PCON
                                    105 	.globl _DPH
                                    106 	.globl _DPL
                                    107 	.globl _SP
                                    108 	.globl _P0
                                    109 	.globl _tmp2
                                    110 	.globl _tmp
                                    111 	.globl _i
                                    112 	.globl _newThread
                                    113 	.globl _bitmap
                                    114 	.globl _curThread
                                    115 	.globl _sp
                                    116 	.globl _ThreadCreate
                                    117 	.globl _ThreadYield
                                    118 	.globl _ThreadExit
                                    119 ;--------------------------------------------------------
                                    120 ; special function registers
                                    121 ;--------------------------------------------------------
                                    122 	.area RSEG    (ABS,DATA)
      000000                        123 	.org 0x0000
                           000080   124 _P0	=	0x0080
                           000081   125 _SP	=	0x0081
                           000082   126 _DPL	=	0x0082
                           000083   127 _DPH	=	0x0083
                           000087   128 _PCON	=	0x0087
                           000088   129 _TCON	=	0x0088
                           000089   130 _TMOD	=	0x0089
                           00008A   131 _TL0	=	0x008a
                           00008B   132 _TL1	=	0x008b
                           00008C   133 _TH0	=	0x008c
                           00008D   134 _TH1	=	0x008d
                           000090   135 _P1	=	0x0090
                           000098   136 _SCON	=	0x0098
                           000099   137 _SBUF	=	0x0099
                           0000A0   138 _P2	=	0x00a0
                           0000A8   139 _IE	=	0x00a8
                           0000B0   140 _P3	=	0x00b0
                           0000B8   141 _IP	=	0x00b8
                           0000D0   142 _PSW	=	0x00d0
                           0000E0   143 _ACC	=	0x00e0
                           0000F0   144 _B	=	0x00f0
                                    145 ;--------------------------------------------------------
                                    146 ; special function bits
                                    147 ;--------------------------------------------------------
                                    148 	.area RSEG    (ABS,DATA)
      000000                        149 	.org 0x0000
                           000080   150 _P0_0	=	0x0080
                           000081   151 _P0_1	=	0x0081
                           000082   152 _P0_2	=	0x0082
                           000083   153 _P0_3	=	0x0083
                           000084   154 _P0_4	=	0x0084
                           000085   155 _P0_5	=	0x0085
                           000086   156 _P0_6	=	0x0086
                           000087   157 _P0_7	=	0x0087
                           000088   158 _IT0	=	0x0088
                           000089   159 _IE0	=	0x0089
                           00008A   160 _IT1	=	0x008a
                           00008B   161 _IE1	=	0x008b
                           00008C   162 _TR0	=	0x008c
                           00008D   163 _TF0	=	0x008d
                           00008E   164 _TR1	=	0x008e
                           00008F   165 _TF1	=	0x008f
                           000090   166 _P1_0	=	0x0090
                           000091   167 _P1_1	=	0x0091
                           000092   168 _P1_2	=	0x0092
                           000093   169 _P1_3	=	0x0093
                           000094   170 _P1_4	=	0x0094
                           000095   171 _P1_5	=	0x0095
                           000096   172 _P1_6	=	0x0096
                           000097   173 _P1_7	=	0x0097
                           000098   174 _RI	=	0x0098
                           000099   175 _TI	=	0x0099
                           00009A   176 _RB8	=	0x009a
                           00009B   177 _TB8	=	0x009b
                           00009C   178 _REN	=	0x009c
                           00009D   179 _SM2	=	0x009d
                           00009E   180 _SM1	=	0x009e
                           00009F   181 _SM0	=	0x009f
                           0000A0   182 _P2_0	=	0x00a0
                           0000A1   183 _P2_1	=	0x00a1
                           0000A2   184 _P2_2	=	0x00a2
                           0000A3   185 _P2_3	=	0x00a3
                           0000A4   186 _P2_4	=	0x00a4
                           0000A5   187 _P2_5	=	0x00a5
                           0000A6   188 _P2_6	=	0x00a6
                           0000A7   189 _P2_7	=	0x00a7
                           0000A8   190 _EX0	=	0x00a8
                           0000A9   191 _ET0	=	0x00a9
                           0000AA   192 _EX1	=	0x00aa
                           0000AB   193 _ET1	=	0x00ab
                           0000AC   194 _ES	=	0x00ac
                           0000AF   195 _EA	=	0x00af
                           0000B0   196 _P3_0	=	0x00b0
                           0000B1   197 _P3_1	=	0x00b1
                           0000B2   198 _P3_2	=	0x00b2
                           0000B3   199 _P3_3	=	0x00b3
                           0000B4   200 _P3_4	=	0x00b4
                           0000B5   201 _P3_5	=	0x00b5
                           0000B6   202 _P3_6	=	0x00b6
                           0000B7   203 _P3_7	=	0x00b7
                           0000B0   204 _RXD	=	0x00b0
                           0000B1   205 _TXD	=	0x00b1
                           0000B2   206 _INT0	=	0x00b2
                           0000B3   207 _INT1	=	0x00b3
                           0000B4   208 _T0	=	0x00b4
                           0000B5   209 _T1	=	0x00b5
                           0000B6   210 _WR	=	0x00b6
                           0000B7   211 _RD	=	0x00b7
                           0000B8   212 _PX0	=	0x00b8
                           0000B9   213 _PT0	=	0x00b9
                           0000BA   214 _PX1	=	0x00ba
                           0000BB   215 _PT1	=	0x00bb
                           0000BC   216 _PS	=	0x00bc
                           0000D0   217 _P	=	0x00d0
                           0000D1   218 _F1	=	0x00d1
                           0000D2   219 _OV	=	0x00d2
                           0000D3   220 _RS0	=	0x00d3
                           0000D4   221 _RS1	=	0x00d4
                           0000D5   222 _F0	=	0x00d5
                           0000D6   223 _AC	=	0x00d6
                           0000D7   224 _CY	=	0x00d7
                                    225 ;--------------------------------------------------------
                                    226 ; overlayable register banks
                                    227 ;--------------------------------------------------------
                                    228 	.area REG_BANK_0	(REL,OVR,DATA)
      000000                        229 	.ds 8
                                    230 ;--------------------------------------------------------
                                    231 ; internal ram data
                                    232 ;--------------------------------------------------------
                                    233 	.area DSEG    (DATA)
                           000030   234 _sp	=	0x0030
                           000034   235 _curThread	=	0x0034
                           000035   236 _bitmap	=	0x0035
                           000036   237 _newThread	=	0x0036
                           000037   238 _i	=	0x0037
                           000038   239 _tmp	=	0x0038
                           000039   240 _tmp2	=	0x0039
                                    241 ;--------------------------------------------------------
                                    242 ; overlayable items in internal ram 
                                    243 ;--------------------------------------------------------
                                    244 	.area	OSEG    (OVR,DATA)
                                    245 ;--------------------------------------------------------
                                    246 ; indirectly addressable internal ram data
                                    247 ;--------------------------------------------------------
                                    248 	.area ISEG    (DATA)
                                    249 ;--------------------------------------------------------
                                    250 ; absolute internal ram data
                                    251 ;--------------------------------------------------------
                                    252 	.area IABS    (ABS,DATA)
                                    253 	.area IABS    (ABS,DATA)
                                    254 ;--------------------------------------------------------
                                    255 ; bit data
                                    256 ;--------------------------------------------------------
                                    257 	.area BSEG    (BIT)
                                    258 ;--------------------------------------------------------
                                    259 ; paged external ram data
                                    260 ;--------------------------------------------------------
                                    261 	.area PSEG    (PAG,XDATA)
                                    262 ;--------------------------------------------------------
                                    263 ; external ram data
                                    264 ;--------------------------------------------------------
                                    265 	.area XSEG    (XDATA)
                                    266 ;--------------------------------------------------------
                                    267 ; absolute external ram data
                                    268 ;--------------------------------------------------------
                                    269 	.area XABS    (ABS,XDATA)
                                    270 ;--------------------------------------------------------
                                    271 ; external initialized ram data
                                    272 ;--------------------------------------------------------
                                    273 	.area XISEG   (XDATA)
                                    274 	.area HOME    (CODE)
                                    275 	.area GSINIT0 (CODE)
                                    276 	.area GSINIT1 (CODE)
                                    277 	.area GSINIT2 (CODE)
                                    278 	.area GSINIT3 (CODE)
                                    279 	.area GSINIT4 (CODE)
                                    280 	.area GSINIT5 (CODE)
                                    281 	.area GSINIT  (CODE)
                                    282 	.area GSFINAL (CODE)
                                    283 	.area CSEG    (CODE)
                                    284 ;--------------------------------------------------------
                                    285 ; global & static initialisations
                                    286 ;--------------------------------------------------------
                                    287 	.area HOME    (CODE)
                                    288 	.area GSINIT  (CODE)
                                    289 	.area GSFINAL (CODE)
                                    290 	.area GSINIT  (CODE)
                                    291 ;--------------------------------------------------------
                                    292 ; Home
                                    293 ;--------------------------------------------------------
                                    294 	.area HOME    (CODE)
                                    295 	.area HOME    (CODE)
                                    296 ;--------------------------------------------------------
                                    297 ; code
                                    298 ;--------------------------------------------------------
                                    299 	.area CSEG    (CODE)
                                    300 ;------------------------------------------------------------
                                    301 ;Allocation info for local variables in function 'Bootstrap'
                                    302 ;------------------------------------------------------------
                                    303 ;	cooperative.c:38: void Bootstrap(void) {
                                    304 ;	-----------------------------------------
                                    305 ;	 function Bootstrap
                                    306 ;	-----------------------------------------
      000066                        307 _Bootstrap:
                           000007   308 	ar7 = 0x07
                           000006   309 	ar6 = 0x06
                           000005   310 	ar5 = 0x05
                           000004   311 	ar4 = 0x04
                           000003   312 	ar3 = 0x03
                           000002   313 	ar2 = 0x02
                           000001   314 	ar1 = 0x01
                           000000   315 	ar0 = 0x00
                                    316 ;	cooperative.c:39: bitmap = 0b0000;
      000066 75 35 00         [24]  317 	mov	_bitmap,#0x00
                                    318 ;	cooperative.c:40: curThread = ThreadCreate(main);
      000069 90 00 53         [24]  319 	mov	dptr,#_main
      00006C 12 00 84         [24]  320 	lcall	_ThreadCreate
      00006F 85 82 34         [24]  321 	mov	_curThread,dpl
                                    322 ;	cooperative.c:41: RESTORESTATE;
      000072 E5 34            [12]  323 	mov	a,_curThread
      000074 24 30            [12]  324 	add	a,#_sp
      000076 F9               [12]  325 	mov	r1,a
      000077 87 81            [24]  326 	mov	_SP,@r1
      000079 D0 D0            [24]  327 	pop PSW 
      00007B D0 83            [24]  328 	pop DPH 
      00007D D0 82            [24]  329 	pop DPL 
      00007F D0 F0            [24]  330 	pop B 
      000081 D0 E0            [24]  331 	pop ACC 
                                    332 ;	cooperative.c:42: }
      000083 22               [24]  333 	ret
                                    334 ;------------------------------------------------------------
                                    335 ;Allocation info for local variables in function 'ThreadCreate'
                                    336 ;------------------------------------------------------------
                                    337 ;fp                        Allocated to registers 
                                    338 ;------------------------------------------------------------
                                    339 ;	cooperative.c:44: ThreadID ThreadCreate(FunctionPtr fp) {
                                    340 ;	-----------------------------------------
                                    341 ;	 function ThreadCreate
                                    342 ;	-----------------------------------------
      000084                        343 _ThreadCreate:
                                    344 ;	cooperative.c:45: if(bitmap == 0b1111){
      000084 74 0F            [12]  345 	mov	a,#0x0f
      000086 B5 35 04         [24]  346 	cjne	a,_bitmap,00102$
                                    347 ;	cooperative.c:46: return -1;
      000089 75 82 FF         [24]  348 	mov	dpl,#0xff
      00008C 22               [24]  349 	ret
      00008D                        350 00102$:
                                    351 ;	cooperative.c:49: for(i=0;i<MAXTHREADS;i++){
      00008D 75 37 00         [24]  352 	mov	_i,#0x00
      000090                        353 00107$:
      000090 74 FC            [12]  354 	mov	a,#0x100 - 0x04
      000092 25 37            [12]  355 	add	a,_i
      000094 40 41            [24]  356 	jc	00105$
                                    357 ;	cooperative.c:50: if((bitmap & (1<<i)) == 0){
      000096 AF 37            [24]  358 	mov	r7,_i
      000098 8F F0            [24]  359 	mov	b,r7
      00009A 05 F0            [12]  360 	inc	b
      00009C 7F 01            [12]  361 	mov	r7,#0x01
      00009E 7E 00            [12]  362 	mov	r6,#0x00
      0000A0 80 06            [24]  363 	sjmp	00131$
      0000A2                        364 00130$:
      0000A2 EF               [12]  365 	mov	a,r7
      0000A3 2F               [12]  366 	add	a,r7
      0000A4 FF               [12]  367 	mov	r7,a
      0000A5 EE               [12]  368 	mov	a,r6
      0000A6 33               [12]  369 	rlc	a
      0000A7 FE               [12]  370 	mov	r6,a
      0000A8                        371 00131$:
      0000A8 D5 F0 F7         [24]  372 	djnz	b,00130$
      0000AB AC 35            [24]  373 	mov	r4,_bitmap
      0000AD 7D 00            [12]  374 	mov	r5,#0x00
      0000AF EC               [12]  375 	mov	a,r4
      0000B0 52 07            [12]  376 	anl	ar7,a
      0000B2 ED               [12]  377 	mov	a,r5
      0000B3 52 06            [12]  378 	anl	ar6,a
      0000B5 EF               [12]  379 	mov	a,r7
      0000B6 4E               [12]  380 	orl	a,r6
      0000B7 70 1A            [24]  381 	jnz	00108$
                                    382 ;	cooperative.c:51: bitmap |= (1<<i);
      0000B9 AF 37            [24]  383 	mov	r7,_i
      0000BB 8F F0            [24]  384 	mov	b,r7
      0000BD 05 F0            [12]  385 	inc	b
      0000BF 74 01            [12]  386 	mov	a,#0x01
      0000C1 80 02            [24]  387 	sjmp	00135$
      0000C3                        388 00133$:
      0000C3 25 E0            [12]  389 	add	a,acc
      0000C5                        390 00135$:
      0000C5 D5 F0 FB         [24]  391 	djnz	b,00133$
      0000C8 FF               [12]  392 	mov	r7,a
      0000C9 AE 35            [24]  393 	mov	r6,_bitmap
      0000CB 4E               [12]  394 	orl	a,r6
      0000CC F5 35            [12]  395 	mov	_bitmap,a
                                    396 ;	cooperative.c:52: newThread = i;
      0000CE 85 37 36         [24]  397 	mov	_newThread,_i
                                    398 ;	cooperative.c:53: break;
      0000D1 80 04            [24]  399 	sjmp	00105$
      0000D3                        400 00108$:
                                    401 ;	cooperative.c:49: for(i=0;i<MAXTHREADS;i++){
      0000D3 05 37            [12]  402 	inc	_i
      0000D5 80 B9            [24]  403 	sjmp	00107$
      0000D7                        404 00105$:
                                    405 ;	cooperative.c:56: tmp = SP;
      0000D7 85 81 38         [24]  406 	mov	_tmp,_SP
                                    407 ;	cooperative.c:57: SP = 0x3F + (i<<4);
      0000DA E5 37            [12]  408 	mov	a,_i
      0000DC C4               [12]  409 	swap	a
      0000DD 54 F0            [12]  410 	anl	a,#0xf0
      0000DF FF               [12]  411 	mov	r7,a
      0000E0 24 3F            [12]  412 	add	a,#0x3f
      0000E2 F5 81            [12]  413 	mov	_SP,a
                                    414 ;	cooperative.c:66: __endasm;
      0000E4 C0 82            [24]  415 	push	DPL
      0000E6 C0 83            [24]  416 	push	DPH
      0000E8 74 00            [12]  417 	mov	A, #0
      0000EA C0 E0            [24]  418 	push	A
      0000EC C0 E0            [24]  419 	push	A
      0000EE C0 E0            [24]  420 	push	A
      0000F0 C0 E0            [24]  421 	push	A
                                    422 ;	cooperative.c:68: tmp2 = (i<<3);
      0000F2 E5 37            [12]  423 	mov	a,_i
      0000F4 FF               [12]  424 	mov	r7,a
      0000F5 C4               [12]  425 	swap	a
      0000F6 03               [12]  426 	rr	a
      0000F7 54 F8            [12]  427 	anl	a,#0xf8
      0000F9 F5 39            [12]  428 	mov	_tmp2,a
                                    429 ;	cooperative.c:72: __endasm;
      0000FB C0 39            [24]  430 	push	_tmp2
                                    431 ;	cooperative.c:74: sp[newThread] = SP;
      0000FD E5 36            [12]  432 	mov	a,_newThread
      0000FF 24 30            [12]  433 	add	a,#_sp
      000101 F8               [12]  434 	mov	r0,a
      000102 A6 81            [24]  435 	mov	@r0,_SP
                                    436 ;	cooperative.c:75: SP = tmp;
      000104 85 38 81         [24]  437 	mov	_SP,_tmp
                                    438 ;	cooperative.c:76: return newThread;
      000107 85 36 82         [24]  439 	mov	dpl,_newThread
                                    440 ;	cooperative.c:77: }
      00010A 22               [24]  441 	ret
                                    442 ;------------------------------------------------------------
                                    443 ;Allocation info for local variables in function 'ThreadYield'
                                    444 ;------------------------------------------------------------
                                    445 ;	cooperative.c:79: void ThreadYield(void) {
                                    446 ;	-----------------------------------------
                                    447 ;	 function ThreadYield
                                    448 ;	-----------------------------------------
      00010B                        449 _ThreadYield:
                                    450 ;	cooperative.c:80: SAVESTATE;
      00010B C0 E0            [24]  451 	push ACC 
      00010D C0 F0            [24]  452 	push B 
      00010F C0 82            [24]  453 	push DPL 
      000111 C0 83            [24]  454 	push DPH 
      000113 C0 D0            [24]  455 	push PSW 
      000115 E5 34            [12]  456 	mov	a,_curThread
      000117 24 30            [12]  457 	add	a,#_sp
      000119 F8               [12]  458 	mov	r0,a
      00011A A6 81            [24]  459 	mov	@r0,_SP
                                    460 ;	cooperative.c:81: do {
      00011C                        461 00105$:
                                    462 ;	cooperative.c:82: curThread++;
      00011C 05 34            [12]  463 	inc	_curThread
                                    464 ;	cooperative.c:83: if(curThread == MAXTHREADS){
      00011E 74 04            [12]  465 	mov	a,#0x04
      000120 B5 34 03         [24]  466 	cjne	a,_curThread,00102$
                                    467 ;	cooperative.c:84: curThread = 0;
      000123 75 34 00         [24]  468 	mov	_curThread,#0x00
      000126                        469 00102$:
                                    470 ;	cooperative.c:86: if(bitmap & (1<<curThread)) break;
      000126 AF 34            [24]  471 	mov	r7,_curThread
      000128 8F F0            [24]  472 	mov	b,r7
      00012A 05 F0            [12]  473 	inc	b
      00012C 7F 01            [12]  474 	mov	r7,#0x01
      00012E 7E 00            [12]  475 	mov	r6,#0x00
      000130 80 06            [24]  476 	sjmp	00125$
      000132                        477 00124$:
      000132 EF               [12]  478 	mov	a,r7
      000133 2F               [12]  479 	add	a,r7
      000134 FF               [12]  480 	mov	r7,a
      000135 EE               [12]  481 	mov	a,r6
      000136 33               [12]  482 	rlc	a
      000137 FE               [12]  483 	mov	r6,a
      000138                        484 00125$:
      000138 D5 F0 F7         [24]  485 	djnz	b,00124$
      00013B AC 35            [24]  486 	mov	r4,_bitmap
      00013D 7D 00            [12]  487 	mov	r5,#0x00
      00013F EC               [12]  488 	mov	a,r4
      000140 52 07            [12]  489 	anl	ar7,a
      000142 ED               [12]  490 	mov	a,r5
      000143 52 06            [12]  491 	anl	ar6,a
      000145 EF               [12]  492 	mov	a,r7
      000146 4E               [12]  493 	orl	a,r6
      000147 60 D3            [24]  494 	jz	00105$
                                    495 ;	cooperative.c:88: RESTORESTATE;
      000149 E5 34            [12]  496 	mov	a,_curThread
      00014B 24 30            [12]  497 	add	a,#_sp
      00014D F9               [12]  498 	mov	r1,a
      00014E 87 81            [24]  499 	mov	_SP,@r1
      000150 D0 D0            [24]  500 	pop PSW 
      000152 D0 83            [24]  501 	pop DPH 
      000154 D0 82            [24]  502 	pop DPL 
      000156 D0 F0            [24]  503 	pop B 
      000158 D0 E0            [24]  504 	pop ACC 
                                    505 ;	cooperative.c:89: }
      00015A 22               [24]  506 	ret
                                    507 ;------------------------------------------------------------
                                    508 ;Allocation info for local variables in function 'ThreadExit'
                                    509 ;------------------------------------------------------------
                                    510 ;	cooperative.c:91: void ThreadExit(void) {
                                    511 ;	-----------------------------------------
                                    512 ;	 function ThreadExit
                                    513 ;	-----------------------------------------
      00015B                        514 _ThreadExit:
                                    515 ;	cooperative.c:92: bitmap ^= (1<<curThread);
      00015B AF 34            [24]  516 	mov	r7,_curThread
      00015D 8F F0            [24]  517 	mov	b,r7
      00015F 05 F0            [12]  518 	inc	b
      000161 74 01            [12]  519 	mov	a,#0x01
      000163 80 02            [24]  520 	sjmp	00124$
      000165                        521 00122$:
      000165 25 E0            [12]  522 	add	a,acc
      000167                        523 00124$:
      000167 D5 F0 FB         [24]  524 	djnz	b,00122$
      00016A FF               [12]  525 	mov	r7,a
      00016B AE 35            [24]  526 	mov	r6,_bitmap
      00016D 6E               [12]  527 	xrl	a,r6
      00016E F5 35            [12]  528 	mov	_bitmap,a
                                    529 ;	cooperative.c:93: do {
      000170                        530 00105$:
                                    531 ;	cooperative.c:94: curThread++;
      000170 05 34            [12]  532 	inc	_curThread
                                    533 ;	cooperative.c:95: if(curThread == MAXTHREADS){
      000172 74 04            [12]  534 	mov	a,#0x04
      000174 B5 34 03         [24]  535 	cjne	a,_curThread,00102$
                                    536 ;	cooperative.c:96: curThread = 0;
      000177 75 34 00         [24]  537 	mov	_curThread,#0x00
      00017A                        538 00102$:
                                    539 ;	cooperative.c:98: if(bitmap & (1<<curThread)) break;
      00017A AF 34            [24]  540 	mov	r7,_curThread
      00017C 8F F0            [24]  541 	mov	b,r7
      00017E 05 F0            [12]  542 	inc	b
      000180 7F 01            [12]  543 	mov	r7,#0x01
      000182 7E 00            [12]  544 	mov	r6,#0x00
      000184 80 06            [24]  545 	sjmp	00128$
      000186                        546 00127$:
      000186 EF               [12]  547 	mov	a,r7
      000187 2F               [12]  548 	add	a,r7
      000188 FF               [12]  549 	mov	r7,a
      000189 EE               [12]  550 	mov	a,r6
      00018A 33               [12]  551 	rlc	a
      00018B FE               [12]  552 	mov	r6,a
      00018C                        553 00128$:
      00018C D5 F0 F7         [24]  554 	djnz	b,00127$
      00018F AC 35            [24]  555 	mov	r4,_bitmap
      000191 7D 00            [12]  556 	mov	r5,#0x00
      000193 EC               [12]  557 	mov	a,r4
      000194 52 07            [12]  558 	anl	ar7,a
      000196 ED               [12]  559 	mov	a,r5
      000197 52 06            [12]  560 	anl	ar6,a
      000199 EF               [12]  561 	mov	a,r7
      00019A 4E               [12]  562 	orl	a,r6
      00019B 60 D3            [24]  563 	jz	00105$
                                    564 ;	cooperative.c:100: RESTORESTATE;
      00019D E5 34            [12]  565 	mov	a,_curThread
      00019F 24 30            [12]  566 	add	a,#_sp
      0001A1 F9               [12]  567 	mov	r1,a
      0001A2 87 81            [24]  568 	mov	_SP,@r1
      0001A4 D0 D0            [24]  569 	pop PSW 
      0001A6 D0 83            [24]  570 	pop DPH 
      0001A8 D0 82            [24]  571 	pop DPL 
      0001AA D0 F0            [24]  572 	pop B 
      0001AC D0 E0            [24]  573 	pop ACC 
                                    574 ;	cooperative.c:101: }
      0001AE 22               [24]  575 	ret
                                    576 	.area CSEG    (CODE)
                                    577 	.area CONST   (CODE)
                                    578 	.area XINIT   (CODE)
                                    579 	.area CABS    (ABS,CODE)
