                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 3.8.0 #10562 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module test3threads
                                      6 	.optsdcc -mmcs51 --model-small
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _timer0_ISR
                                     12 	.globl __mcs51_genXRAMCLEAR
                                     13 	.globl __mcs51_genXINIT
                                     14 	.globl __mcs51_genRAMCLEAR
                                     15 	.globl __sdcc_gsinit_startup
                                     16 	.globl _main
                                     17 	.globl _Consumer
                                     18 	.globl _Producer2
                                     19 	.globl _Producer1
                                     20 	.globl _ThreadYield
                                     21 	.globl _ThreadCreate
                                     22 	.globl _CY
                                     23 	.globl _AC
                                     24 	.globl _F0
                                     25 	.globl _RS1
                                     26 	.globl _RS0
                                     27 	.globl _OV
                                     28 	.globl _F1
                                     29 	.globl _P
                                     30 	.globl _PS
                                     31 	.globl _PT1
                                     32 	.globl _PX1
                                     33 	.globl _PT0
                                     34 	.globl _PX0
                                     35 	.globl _RD
                                     36 	.globl _WR
                                     37 	.globl _T1
                                     38 	.globl _T0
                                     39 	.globl _INT1
                                     40 	.globl _INT0
                                     41 	.globl _TXD
                                     42 	.globl _RXD
                                     43 	.globl _P3_7
                                     44 	.globl _P3_6
                                     45 	.globl _P3_5
                                     46 	.globl _P3_4
                                     47 	.globl _P3_3
                                     48 	.globl _P3_2
                                     49 	.globl _P3_1
                                     50 	.globl _P3_0
                                     51 	.globl _EA
                                     52 	.globl _ES
                                     53 	.globl _ET1
                                     54 	.globl _EX1
                                     55 	.globl _ET0
                                     56 	.globl _EX0
                                     57 	.globl _P2_7
                                     58 	.globl _P2_6
                                     59 	.globl _P2_5
                                     60 	.globl _P2_4
                                     61 	.globl _P2_3
                                     62 	.globl _P2_2
                                     63 	.globl _P2_1
                                     64 	.globl _P2_0
                                     65 	.globl _SM0
                                     66 	.globl _SM1
                                     67 	.globl _SM2
                                     68 	.globl _REN
                                     69 	.globl _TB8
                                     70 	.globl _RB8
                                     71 	.globl _TI
                                     72 	.globl _RI
                                     73 	.globl _P1_7
                                     74 	.globl _P1_6
                                     75 	.globl _P1_5
                                     76 	.globl _P1_4
                                     77 	.globl _P1_3
                                     78 	.globl _P1_2
                                     79 	.globl _P1_1
                                     80 	.globl _P1_0
                                     81 	.globl _TF1
                                     82 	.globl _TR1
                                     83 	.globl _TF0
                                     84 	.globl _TR0
                                     85 	.globl _IE1
                                     86 	.globl _IT1
                                     87 	.globl _IE0
                                     88 	.globl _IT0
                                     89 	.globl _P0_7
                                     90 	.globl _P0_6
                                     91 	.globl _P0_5
                                     92 	.globl _P0_4
                                     93 	.globl _P0_3
                                     94 	.globl _P0_2
                                     95 	.globl _P0_1
                                     96 	.globl _P0_0
                                     97 	.globl _B
                                     98 	.globl _ACC
                                     99 	.globl _PSW
                                    100 	.globl _IP
                                    101 	.globl _P3
                                    102 	.globl _IE
                                    103 	.globl _P2
                                    104 	.globl _SBUF
                                    105 	.globl _SCON
                                    106 	.globl _P1
                                    107 	.globl _TH1
                                    108 	.globl _TH0
                                    109 	.globl _TL1
                                    110 	.globl _TL0
                                    111 	.globl _TMOD
                                    112 	.globl _TCON
                                    113 	.globl _PCON
                                    114 	.globl _DPH
                                    115 	.globl _DPL
                                    116 	.globl _SP
                                    117 	.globl _P0
                                    118 	.globl _num
                                    119 	.globl _ch
                                    120 	.globl _tail
                                    121 	.globl _head
                                    122 	.globl _buf
                                    123 	.globl _empty
                                    124 	.globl _full
                                    125 	.globl _mutex
                                    126 ;--------------------------------------------------------
                                    127 ; special function registers
                                    128 ;--------------------------------------------------------
                                    129 	.area RSEG    (ABS,DATA)
      000000                        130 	.org 0x0000
                           000080   131 _P0	=	0x0080
                           000081   132 _SP	=	0x0081
                           000082   133 _DPL	=	0x0082
                           000083   134 _DPH	=	0x0083
                           000087   135 _PCON	=	0x0087
                           000088   136 _TCON	=	0x0088
                           000089   137 _TMOD	=	0x0089
                           00008A   138 _TL0	=	0x008a
                           00008B   139 _TL1	=	0x008b
                           00008C   140 _TH0	=	0x008c
                           00008D   141 _TH1	=	0x008d
                           000090   142 _P1	=	0x0090
                           000098   143 _SCON	=	0x0098
                           000099   144 _SBUF	=	0x0099
                           0000A0   145 _P2	=	0x00a0
                           0000A8   146 _IE	=	0x00a8
                           0000B0   147 _P3	=	0x00b0
                           0000B8   148 _IP	=	0x00b8
                           0000D0   149 _PSW	=	0x00d0
                           0000E0   150 _ACC	=	0x00e0
                           0000F0   151 _B	=	0x00f0
                                    152 ;--------------------------------------------------------
                                    153 ; special function bits
                                    154 ;--------------------------------------------------------
                                    155 	.area RSEG    (ABS,DATA)
      000000                        156 	.org 0x0000
                           000080   157 _P0_0	=	0x0080
                           000081   158 _P0_1	=	0x0081
                           000082   159 _P0_2	=	0x0082
                           000083   160 _P0_3	=	0x0083
                           000084   161 _P0_4	=	0x0084
                           000085   162 _P0_5	=	0x0085
                           000086   163 _P0_6	=	0x0086
                           000087   164 _P0_7	=	0x0087
                           000088   165 _IT0	=	0x0088
                           000089   166 _IE0	=	0x0089
                           00008A   167 _IT1	=	0x008a
                           00008B   168 _IE1	=	0x008b
                           00008C   169 _TR0	=	0x008c
                           00008D   170 _TF0	=	0x008d
                           00008E   171 _TR1	=	0x008e
                           00008F   172 _TF1	=	0x008f
                           000090   173 _P1_0	=	0x0090
                           000091   174 _P1_1	=	0x0091
                           000092   175 _P1_2	=	0x0092
                           000093   176 _P1_3	=	0x0093
                           000094   177 _P1_4	=	0x0094
                           000095   178 _P1_5	=	0x0095
                           000096   179 _P1_6	=	0x0096
                           000097   180 _P1_7	=	0x0097
                           000098   181 _RI	=	0x0098
                           000099   182 _TI	=	0x0099
                           00009A   183 _RB8	=	0x009a
                           00009B   184 _TB8	=	0x009b
                           00009C   185 _REN	=	0x009c
                           00009D   186 _SM2	=	0x009d
                           00009E   187 _SM1	=	0x009e
                           00009F   188 _SM0	=	0x009f
                           0000A0   189 _P2_0	=	0x00a0
                           0000A1   190 _P2_1	=	0x00a1
                           0000A2   191 _P2_2	=	0x00a2
                           0000A3   192 _P2_3	=	0x00a3
                           0000A4   193 _P2_4	=	0x00a4
                           0000A5   194 _P2_5	=	0x00a5
                           0000A6   195 _P2_6	=	0x00a6
                           0000A7   196 _P2_7	=	0x00a7
                           0000A8   197 _EX0	=	0x00a8
                           0000A9   198 _ET0	=	0x00a9
                           0000AA   199 _EX1	=	0x00aa
                           0000AB   200 _ET1	=	0x00ab
                           0000AC   201 _ES	=	0x00ac
                           0000AF   202 _EA	=	0x00af
                           0000B0   203 _P3_0	=	0x00b0
                           0000B1   204 _P3_1	=	0x00b1
                           0000B2   205 _P3_2	=	0x00b2
                           0000B3   206 _P3_3	=	0x00b3
                           0000B4   207 _P3_4	=	0x00b4
                           0000B5   208 _P3_5	=	0x00b5
                           0000B6   209 _P3_6	=	0x00b6
                           0000B7   210 _P3_7	=	0x00b7
                           0000B0   211 _RXD	=	0x00b0
                           0000B1   212 _TXD	=	0x00b1
                           0000B2   213 _INT0	=	0x00b2
                           0000B3   214 _INT1	=	0x00b3
                           0000B4   215 _T0	=	0x00b4
                           0000B5   216 _T1	=	0x00b5
                           0000B6   217 _WR	=	0x00b6
                           0000B7   218 _RD	=	0x00b7
                           0000B8   219 _PX0	=	0x00b8
                           0000B9   220 _PT0	=	0x00b9
                           0000BA   221 _PX1	=	0x00ba
                           0000BB   222 _PT1	=	0x00bb
                           0000BC   223 _PS	=	0x00bc
                           0000D0   224 _P	=	0x00d0
                           0000D1   225 _F1	=	0x00d1
                           0000D2   226 _OV	=	0x00d2
                           0000D3   227 _RS0	=	0x00d3
                           0000D4   228 _RS1	=	0x00d4
                           0000D5   229 _F0	=	0x00d5
                           0000D6   230 _AC	=	0x00d6
                           0000D7   231 _CY	=	0x00d7
                                    232 ;--------------------------------------------------------
                                    233 ; overlayable register banks
                                    234 ;--------------------------------------------------------
                                    235 	.area REG_BANK_0	(REL,OVR,DATA)
      000000                        236 	.ds 8
                                    237 ;--------------------------------------------------------
                                    238 ; internal ram data
                                    239 ;--------------------------------------------------------
                                    240 	.area DSEG    (DATA)
                           000020   241 _mutex	=	0x0020
                           000021   242 _full	=	0x0021
                           000022   243 _empty	=	0x0022
                           000023   244 _buf	=	0x0023
                           000026   245 _head	=	0x0026
                           000027   246 _tail	=	0x0027
                           000028   247 _ch	=	0x0028
                           000029   248 _num	=	0x0029
                                    249 ;--------------------------------------------------------
                                    250 ; overlayable items in internal ram 
                                    251 ;--------------------------------------------------------
                                    252 ;--------------------------------------------------------
                                    253 ; Stack segment in internal ram 
                                    254 ;--------------------------------------------------------
                                    255 	.area	SSEG
      000008                        256 __start__stack:
      000008                        257 	.ds	1
                                    258 
                                    259 ;--------------------------------------------------------
                                    260 ; indirectly addressable internal ram data
                                    261 ;--------------------------------------------------------
                                    262 	.area ISEG    (DATA)
                                    263 ;--------------------------------------------------------
                                    264 ; absolute internal ram data
                                    265 ;--------------------------------------------------------
                                    266 	.area IABS    (ABS,DATA)
                                    267 	.area IABS    (ABS,DATA)
                                    268 ;--------------------------------------------------------
                                    269 ; bit data
                                    270 ;--------------------------------------------------------
                                    271 	.area BSEG    (BIT)
                                    272 ;--------------------------------------------------------
                                    273 ; paged external ram data
                                    274 ;--------------------------------------------------------
                                    275 	.area PSEG    (PAG,XDATA)
                                    276 ;--------------------------------------------------------
                                    277 ; external ram data
                                    278 ;--------------------------------------------------------
                                    279 	.area XSEG    (XDATA)
                                    280 ;--------------------------------------------------------
                                    281 ; absolute external ram data
                                    282 ;--------------------------------------------------------
                                    283 	.area XABS    (ABS,XDATA)
                                    284 ;--------------------------------------------------------
                                    285 ; external initialized ram data
                                    286 ;--------------------------------------------------------
                                    287 	.area XISEG   (XDATA)
                                    288 	.area HOME    (CODE)
                                    289 	.area GSINIT0 (CODE)
                                    290 	.area GSINIT1 (CODE)
                                    291 	.area GSINIT2 (CODE)
                                    292 	.area GSINIT3 (CODE)
                                    293 	.area GSINIT4 (CODE)
                                    294 	.area GSINIT5 (CODE)
                                    295 	.area GSINIT  (CODE)
                                    296 	.area GSFINAL (CODE)
                                    297 	.area CSEG    (CODE)
                                    298 ;--------------------------------------------------------
                                    299 ; interrupt vector 
                                    300 ;--------------------------------------------------------
                                    301 	.area HOME    (CODE)
      000000                        302 __interrupt_vect:
      000000 02 01 1B         [24]  303 	ljmp	__sdcc_gsinit_startup
      000003 32               [24]  304 	reti
      000004                        305 	.ds	7
      00000B 02 01 22         [24]  306 	ljmp	_timer0_ISR
                                    307 ;--------------------------------------------------------
                                    308 ; global & static initialisations
                                    309 ;--------------------------------------------------------
                                    310 	.area HOME    (CODE)
                                    311 	.area GSINIT  (CODE)
                                    312 	.area GSFINAL (CODE)
                                    313 	.area GSINIT  (CODE)
                                    314 	.globl __sdcc_gsinit_startup
                                    315 	.globl __sdcc_program_startup
                                    316 	.globl __start__stack
                                    317 	.globl __mcs51_genXINIT
                                    318 	.globl __mcs51_genXRAMCLEAR
                                    319 	.globl __mcs51_genRAMCLEAR
                                    320 	.area GSFINAL (CODE)
      000011 02 00 0E         [24]  321 	ljmp	__sdcc_program_startup
                                    322 ;--------------------------------------------------------
                                    323 ; Home
                                    324 ;--------------------------------------------------------
                                    325 	.area HOME    (CODE)
                                    326 	.area HOME    (CODE)
      00000E                        327 __sdcc_program_startup:
      00000E 02 00 DD         [24]  328 	ljmp	_main
                                    329 ;	return from main will return to caller
                                    330 ;--------------------------------------------------------
                                    331 ; code
                                    332 ;--------------------------------------------------------
                                    333 	.area CSEG    (CODE)
                                    334 ;------------------------------------------------------------
                                    335 ;Allocation info for local variables in function 'Producer1'
                                    336 ;------------------------------------------------------------
                                    337 ;	test3threads.c:13: void Producer1(void){
                                    338 ;	-----------------------------------------
                                    339 ;	 function Producer1
                                    340 ;	-----------------------------------------
      000014                        341 _Producer1:
                           000007   342 	ar7 = 0x07
                           000006   343 	ar6 = 0x06
                           000005   344 	ar5 = 0x05
                           000004   345 	ar4 = 0x04
                           000003   346 	ar3 = 0x03
                           000002   347 	ar2 = 0x02
                           000001   348 	ar1 = 0x01
                           000000   349 	ar0 = 0x00
                                    350 ;	test3threads.c:14: ch = 'A';
      000014 75 28 41         [24]  351 	mov	_ch,#0x41
                                    352 ;	test3threads.c:15: while(1){
      000017                        353 00107$:
                                    354 ;	test3threads.c:16: SemaphoreWait(empty);
      000017                        355 		0$:
      000017 E5 22            [12]  356 	mov a, _empty 
      000019 60 FC            [24]  357 	jz 0$ 
      00001B 20 E7 F9         [24]  358 	jb ACC.7, 0$ 
      00001E 15 22            [12]  359 	dec _empty 
                                    360 ;	test3threads.c:18: EA=0;
                                    361 ;	assignBit
      000020 C2 AF            [12]  362 	clr	_EA
                                    363 ;	test3threads.c:19: SemaphoreWait(mutex);
      000022                        364 		1$:
      000022 E5 20            [12]  365 	mov a, _mutex 
      000024 60 FC            [24]  366 	jz 1$ 
      000026 20 E7 F9         [24]  367 	jb ACC.7, 1$ 
      000029 15 20            [12]  368 	dec _mutex 
                                    369 ;	test3threads.c:20: buf[head] = ch;
      00002B E5 26            [12]  370 	mov	a,_head
      00002D 24 23            [12]  371 	add	a,#_buf
      00002F F8               [12]  372 	mov	r0,a
      000030 A6 28            [24]  373 	mov	@r0,_ch
                                    374 ;	test3threads.c:22: head++;
      000032 05 26            [12]  375 	inc	_head
                                    376 ;	test3threads.c:23: if(head == 3){
      000034 74 03            [12]  377 	mov	a,#0x03
      000036 B5 26 03         [24]  378 	cjne	a,_head,00102$
                                    379 ;	test3threads.c:24: head = 0;
      000039 75 26 00         [24]  380 	mov	_head,#0x00
      00003C                        381 00102$:
                                    382 ;	test3threads.c:26: SemaphoreSignal(mutex);
      00003C 05 20            [12]  383 	inc _mutex 
                                    384 ;	test3threads.c:27: EA=1;
                                    385 ;	assignBit
      00003E D2 AF            [12]  386 	setb	_EA
                                    387 ;	test3threads.c:29: SemaphoreSignal(full);
      000040 05 21            [12]  388 	inc _full 
                                    389 ;	test3threads.c:30: if(ch == 'Z'){
      000042 74 5A            [12]  390 	mov	a,#0x5a
      000044 B5 28 05         [24]  391 	cjne	a,_ch,00104$
                                    392 ;	test3threads.c:31: ch = 'A';
      000047 75 28 41         [24]  393 	mov	_ch,#0x41
      00004A 80 06            [24]  394 	sjmp	00105$
      00004C                        395 00104$:
                                    396 ;	test3threads.c:33: ch += 1;
      00004C E5 28            [12]  397 	mov	a,_ch
      00004E FF               [12]  398 	mov	r7,a
      00004F 04               [12]  399 	inc	a
      000050 F5 28            [12]  400 	mov	_ch,a
      000052                        401 00105$:
                                    402 ;	test3threads.c:35: ThreadYield();
      000052 12 01 D7         [24]  403 	lcall	_ThreadYield
                                    404 ;	test3threads.c:37: }
      000055 80 C0            [24]  405 	sjmp	00107$
                                    406 ;------------------------------------------------------------
                                    407 ;Allocation info for local variables in function 'Producer2'
                                    408 ;------------------------------------------------------------
                                    409 ;	test3threads.c:39: void Producer2(void){
                                    410 ;	-----------------------------------------
                                    411 ;	 function Producer2
                                    412 ;	-----------------------------------------
      000057                        413 _Producer2:
                                    414 ;	test3threads.c:40: num = '0';
      000057 75 29 30         [24]  415 	mov	_num,#0x30
                                    416 ;	test3threads.c:41: while(1){
      00005A                        417 00107$:
                                    418 ;	test3threads.c:42: SemaphoreWait(empty);
      00005A                        419 		2$:
      00005A E5 22            [12]  420 	mov a, _empty 
      00005C 60 FC            [24]  421 	jz 2$ 
      00005E 20 E7 F9         [24]  422 	jb ACC.7, 2$ 
      000061 15 22            [12]  423 	dec _empty 
                                    424 ;	test3threads.c:44: EA=0;
                                    425 ;	assignBit
      000063 C2 AF            [12]  426 	clr	_EA
                                    427 ;	test3threads.c:45: SemaphoreWait(mutex);
      000065                        428 		3$:
      000065 E5 20            [12]  429 	mov a, _mutex 
      000067 60 FC            [24]  430 	jz 3$ 
      000069 20 E7 F9         [24]  431 	jb ACC.7, 3$ 
      00006C 15 20            [12]  432 	dec _mutex 
                                    433 ;	test3threads.c:46: buf[head] = num;
      00006E E5 26            [12]  434 	mov	a,_head
      000070 24 23            [12]  435 	add	a,#_buf
      000072 F8               [12]  436 	mov	r0,a
      000073 A6 29            [24]  437 	mov	@r0,_num
                                    438 ;	test3threads.c:48: head++;
      000075 05 26            [12]  439 	inc	_head
                                    440 ;	test3threads.c:49: if(head == 3){
      000077 74 03            [12]  441 	mov	a,#0x03
      000079 B5 26 03         [24]  442 	cjne	a,_head,00102$
                                    443 ;	test3threads.c:50: head = 0;
      00007C 75 26 00         [24]  444 	mov	_head,#0x00
      00007F                        445 00102$:
                                    446 ;	test3threads.c:52: SemaphoreSignal(mutex);
      00007F 05 20            [12]  447 	inc _mutex 
                                    448 ;	test3threads.c:53: EA=1;
                                    449 ;	assignBit
      000081 D2 AF            [12]  450 	setb	_EA
                                    451 ;	test3threads.c:55: SemaphoreSignal(full);
      000083 05 21            [12]  452 	inc _full 
                                    453 ;	test3threads.c:56: if(num == '9'){
      000085 74 39            [12]  454 	mov	a,#0x39
      000087 B5 29 05         [24]  455 	cjne	a,_num,00104$
                                    456 ;	test3threads.c:57: num = '0';
      00008A 75 29 30         [24]  457 	mov	_num,#0x30
      00008D 80 06            [24]  458 	sjmp	00105$
      00008F                        459 00104$:
                                    460 ;	test3threads.c:59: num += 1;
      00008F E5 29            [12]  461 	mov	a,_num
      000091 FF               [12]  462 	mov	r7,a
      000092 04               [12]  463 	inc	a
      000093 F5 29            [12]  464 	mov	_num,a
      000095                        465 00105$:
                                    466 ;	test3threads.c:61: ThreadYield();
      000095 12 01 D7         [24]  467 	lcall	_ThreadYield
                                    468 ;	test3threads.c:63: }
      000098 80 C0            [24]  469 	sjmp	00107$
                                    470 ;------------------------------------------------------------
                                    471 ;Allocation info for local variables in function 'Consumer'
                                    472 ;------------------------------------------------------------
                                    473 ;	test3threads.c:65: void Consumer(void) {
                                    474 ;	-----------------------------------------
                                    475 ;	 function Consumer
                                    476 ;	-----------------------------------------
      00009A                        477 _Consumer:
                                    478 ;	test3threads.c:66: TMOD |= 0x20;
      00009A AE 89            [24]  479 	mov	r6,_TMOD
      00009C 7F 00            [12]  480 	mov	r7,#0x00
      00009E 43 06 20         [24]  481 	orl	ar6,#0x20
      0000A1 8E 89            [24]  482 	mov	_TMOD,r6
                                    483 ;	test3threads.c:67: TH1 = -6;
      0000A3 75 8D FA         [24]  484 	mov	_TH1,#0xfa
                                    485 ;	test3threads.c:68: SCON = 0x50;
      0000A6 75 98 50         [24]  486 	mov	_SCON,#0x50
                                    487 ;	test3threads.c:69: TR1 = 1;
                                    488 ;	assignBit
      0000A9 D2 8E            [12]  489 	setb	_TR1
                                    490 ;	test3threads.c:70: while (1) {
      0000AB                        491 00107$:
                                    492 ;	test3threads.c:71: SemaphoreWait(full);
      0000AB                        493 		4$:
      0000AB E5 21            [12]  494 	mov a, _full 
      0000AD 60 FC            [24]  495 	jz 4$ 
      0000AF 20 E7 F9         [24]  496 	jb ACC.7, 4$ 
      0000B2 15 21            [12]  497 	dec _full 
                                    498 ;	test3threads.c:73: EA=0;
                                    499 ;	assignBit
      0000B4 C2 AF            [12]  500 	clr	_EA
                                    501 ;	test3threads.c:74: SemaphoreWait(mutex);
      0000B6                        502 		5$:
      0000B6 E5 20            [12]  503 	mov a, _mutex 
      0000B8 60 FC            [24]  504 	jz 5$ 
      0000BA 20 E7 F9         [24]  505 	jb ACC.7, 5$ 
      0000BD 15 20            [12]  506 	dec _mutex 
                                    507 ;	test3threads.c:75: SBUF = buf[tail];
      0000BF E5 27            [12]  508 	mov	a,_tail
      0000C1 24 23            [12]  509 	add	a,#_buf
      0000C3 F9               [12]  510 	mov	r1,a
      0000C4 87 99            [24]  511 	mov	_SBUF,@r1
                                    512 ;	test3threads.c:76: while(!TI){}
      0000C6                        513 00101$:
                                    514 ;	test3threads.c:77: TI = 0;
                                    515 ;	assignBit
      0000C6 10 99 02         [24]  516 	jbc	_TI,00127$
      0000C9 80 FB            [24]  517 	sjmp	00101$
      0000CB                        518 00127$:
                                    519 ;	test3threads.c:79: tail++;
      0000CB 05 27            [12]  520 	inc	_tail
                                    521 ;	test3threads.c:80: if(tail == 3){
      0000CD 74 03            [12]  522 	mov	a,#0x03
      0000CF B5 27 03         [24]  523 	cjne	a,_tail,00105$
                                    524 ;	test3threads.c:81: tail = 0;
      0000D2 75 27 00         [24]  525 	mov	_tail,#0x00
      0000D5                        526 00105$:
                                    527 ;	test3threads.c:83: SemaphoreSignal(mutex);
      0000D5 05 20            [12]  528 	inc _mutex 
                                    529 ;	test3threads.c:84: EA=1;
                                    530 ;	assignBit
      0000D7 D2 AF            [12]  531 	setb	_EA
                                    532 ;	test3threads.c:86: SemaphoreSignal(empty);
      0000D9 05 22            [12]  533 	inc _empty 
                                    534 ;	test3threads.c:88: }
      0000DB 80 CE            [24]  535 	sjmp	00107$
                                    536 ;------------------------------------------------------------
                                    537 ;Allocation info for local variables in function 'main'
                                    538 ;------------------------------------------------------------
                                    539 ;i                         Allocated to registers r6 r7 
                                    540 ;------------------------------------------------------------
                                    541 ;	test3threads.c:91: void main(void) {
                                    542 ;	-----------------------------------------
                                    543 ;	 function main
                                    544 ;	-----------------------------------------
      0000DD                        545 _main:
                                    546 ;	test3threads.c:92: EA=0;
                                    547 ;	assignBit
      0000DD C2 AF            [12]  548 	clr	_EA
                                    549 ;	test3threads.c:93: for(int i=0;i<3;i++){
      0000DF 7E 00            [12]  550 	mov	r6,#0x00
      0000E1 7F 00            [12]  551 	mov	r7,#0x00
      0000E3                        552 00103$:
      0000E3 C3               [12]  553 	clr	c
      0000E4 EE               [12]  554 	mov	a,r6
      0000E5 94 03            [12]  555 	subb	a,#0x03
      0000E7 EF               [12]  556 	mov	a,r7
      0000E8 64 80            [12]  557 	xrl	a,#0x80
      0000EA 94 80            [12]  558 	subb	a,#0x80
      0000EC 50 0D            [24]  559 	jnc	00101$
                                    560 ;	test3threads.c:94: buf[i] = '\0';
      0000EE EE               [12]  561 	mov	a,r6
      0000EF 24 23            [12]  562 	add	a,#_buf
      0000F1 F8               [12]  563 	mov	r0,a
      0000F2 76 00            [12]  564 	mov	@r0,#0x00
                                    565 ;	test3threads.c:93: for(int i=0;i<3;i++){
      0000F4 0E               [12]  566 	inc	r6
      0000F5 BE 00 EB         [24]  567 	cjne	r6,#0x00,00103$
      0000F8 0F               [12]  568 	inc	r7
      0000F9 80 E8            [24]  569 	sjmp	00103$
      0000FB                        570 00101$:
                                    571 ;	test3threads.c:96: head = 0;
      0000FB 75 26 00         [24]  572 	mov	_head,#0x00
                                    573 ;	test3threads.c:97: tail = 0;
      0000FE 75 27 00         [24]  574 	mov	_tail,#0x00
                                    575 ;	test3threads.c:98: SemaphoreCreate(mutex, 1);
      000101 75 20 01         [24]  576 	mov	_mutex,#0x01
                                    577 ;	test3threads.c:99: SemaphoreCreate(full, 0);
      000104 75 21 00         [24]  578 	mov	_full,#0x00
                                    579 ;	test3threads.c:100: SemaphoreCreate(empty, 3);
      000107 75 22 03         [24]  580 	mov	_empty,#0x03
                                    581 ;	test3threads.c:101: EA=1;
                                    582 ;	assignBit
      00010A D2 AF            [12]  583 	setb	_EA
                                    584 ;	test3threads.c:102: ThreadCreate(Producer2);
      00010C 90 00 57         [24]  585 	mov	dptr,#_Producer2
      00010F 12 01 4C         [24]  586 	lcall	_ThreadCreate
                                    587 ;	test3threads.c:103: ThreadCreate(Producer1);
      000112 90 00 14         [24]  588 	mov	dptr,#_Producer1
      000115 12 01 4C         [24]  589 	lcall	_ThreadCreate
                                    590 ;	test3threads.c:105: Consumer();
                                    591 ;	test3threads.c:106: }
      000118 02 00 9A         [24]  592 	ljmp	_Consumer
                                    593 ;------------------------------------------------------------
                                    594 ;Allocation info for local variables in function '_sdcc_gsinit_startup'
                                    595 ;------------------------------------------------------------
                                    596 ;	test3threads.c:108: void _sdcc_gsinit_startup(void) {
                                    597 ;	-----------------------------------------
                                    598 ;	 function _sdcc_gsinit_startup
                                    599 ;	-----------------------------------------
      00011B                        600 __sdcc_gsinit_startup:
                                    601 ;	test3threads.c:111: __endasm;
      00011B 02 01 26         [24]  602 	ljmp	_Bootstrap
                                    603 ;	test3threads.c:112: }
      00011E 22               [24]  604 	ret
                                    605 ;------------------------------------------------------------
                                    606 ;Allocation info for local variables in function '_mcs51_genRAMCLEAR'
                                    607 ;------------------------------------------------------------
                                    608 ;	test3threads.c:114: void _mcs51_genRAMCLEAR(void) {}
                                    609 ;	-----------------------------------------
                                    610 ;	 function _mcs51_genRAMCLEAR
                                    611 ;	-----------------------------------------
      00011F                        612 __mcs51_genRAMCLEAR:
      00011F 22               [24]  613 	ret
                                    614 ;------------------------------------------------------------
                                    615 ;Allocation info for local variables in function '_mcs51_genXINIT'
                                    616 ;------------------------------------------------------------
                                    617 ;	test3threads.c:115: void _mcs51_genXINIT(void) {}
                                    618 ;	-----------------------------------------
                                    619 ;	 function _mcs51_genXINIT
                                    620 ;	-----------------------------------------
      000120                        621 __mcs51_genXINIT:
      000120 22               [24]  622 	ret
                                    623 ;------------------------------------------------------------
                                    624 ;Allocation info for local variables in function '_mcs51_genXRAMCLEAR'
                                    625 ;------------------------------------------------------------
                                    626 ;	test3threads.c:116: void _mcs51_genXRAMCLEAR(void) {}
                                    627 ;	-----------------------------------------
                                    628 ;	 function _mcs51_genXRAMCLEAR
                                    629 ;	-----------------------------------------
      000121                        630 __mcs51_genXRAMCLEAR:
      000121 22               [24]  631 	ret
                                    632 ;------------------------------------------------------------
                                    633 ;Allocation info for local variables in function 'timer0_ISR'
                                    634 ;------------------------------------------------------------
                                    635 ;	test3threads.c:118: void timer0_ISR(void) __interrupt(1) {
                                    636 ;	-----------------------------------------
                                    637 ;	 function timer0_ISR
                                    638 ;	-----------------------------------------
      000122                        639 _timer0_ISR:
                                    640 ;	test3threads.c:121: __endasm;
      000122 02 02 83         [24]  641 	ljmp	_myTimer0Handler
                                    642 ;	test3threads.c:122: }
      000125 32               [24]  643 	reti
                                    644 ;	eliminated unneeded mov psw,# (no regs used in bank)
                                    645 ;	eliminated unneeded push/pop psw
                                    646 ;	eliminated unneeded push/pop dpl
                                    647 ;	eliminated unneeded push/pop dph
                                    648 ;	eliminated unneeded push/pop b
                                    649 ;	eliminated unneeded push/pop acc
                                    650 	.area CSEG    (CODE)
                                    651 	.area CONST   (CODE)
                                    652 	.area XINIT   (CODE)
                                    653 	.area CABS    (ABS,CODE)
