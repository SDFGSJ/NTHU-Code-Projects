                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 3.8.0 #10562 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module testpreempt
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
                                     18 	.globl _Producer
                                     19 	.globl _ThreadCreate
                                     20 	.globl _CY
                                     21 	.globl _AC
                                     22 	.globl _F0
                                     23 	.globl _RS1
                                     24 	.globl _RS0
                                     25 	.globl _OV
                                     26 	.globl _F1
                                     27 	.globl _P
                                     28 	.globl _PS
                                     29 	.globl _PT1
                                     30 	.globl _PX1
                                     31 	.globl _PT0
                                     32 	.globl _PX0
                                     33 	.globl _RD
                                     34 	.globl _WR
                                     35 	.globl _T1
                                     36 	.globl _T0
                                     37 	.globl _INT1
                                     38 	.globl _INT0
                                     39 	.globl _TXD
                                     40 	.globl _RXD
                                     41 	.globl _P3_7
                                     42 	.globl _P3_6
                                     43 	.globl _P3_5
                                     44 	.globl _P3_4
                                     45 	.globl _P3_3
                                     46 	.globl _P3_2
                                     47 	.globl _P3_1
                                     48 	.globl _P3_0
                                     49 	.globl _EA
                                     50 	.globl _ES
                                     51 	.globl _ET1
                                     52 	.globl _EX1
                                     53 	.globl _ET0
                                     54 	.globl _EX0
                                     55 	.globl _P2_7
                                     56 	.globl _P2_6
                                     57 	.globl _P2_5
                                     58 	.globl _P2_4
                                     59 	.globl _P2_3
                                     60 	.globl _P2_2
                                     61 	.globl _P2_1
                                     62 	.globl _P2_0
                                     63 	.globl _SM0
                                     64 	.globl _SM1
                                     65 	.globl _SM2
                                     66 	.globl _REN
                                     67 	.globl _TB8
                                     68 	.globl _RB8
                                     69 	.globl _TI
                                     70 	.globl _RI
                                     71 	.globl _P1_7
                                     72 	.globl _P1_6
                                     73 	.globl _P1_5
                                     74 	.globl _P1_4
                                     75 	.globl _P1_3
                                     76 	.globl _P1_2
                                     77 	.globl _P1_1
                                     78 	.globl _P1_0
                                     79 	.globl _TF1
                                     80 	.globl _TR1
                                     81 	.globl _TF0
                                     82 	.globl _TR0
                                     83 	.globl _IE1
                                     84 	.globl _IT1
                                     85 	.globl _IE0
                                     86 	.globl _IT0
                                     87 	.globl _P0_7
                                     88 	.globl _P0_6
                                     89 	.globl _P0_5
                                     90 	.globl _P0_4
                                     91 	.globl _P0_3
                                     92 	.globl _P0_2
                                     93 	.globl _P0_1
                                     94 	.globl _P0_0
                                     95 	.globl _B
                                     96 	.globl _ACC
                                     97 	.globl _PSW
                                     98 	.globl _IP
                                     99 	.globl _P3
                                    100 	.globl _IE
                                    101 	.globl _P2
                                    102 	.globl _SBUF
                                    103 	.globl _SCON
                                    104 	.globl _P1
                                    105 	.globl _TH1
                                    106 	.globl _TH0
                                    107 	.globl _TL1
                                    108 	.globl _TL0
                                    109 	.globl _TMOD
                                    110 	.globl _TCON
                                    111 	.globl _PCON
                                    112 	.globl _DPH
                                    113 	.globl _DPL
                                    114 	.globl _SP
                                    115 	.globl _P0
                                    116 	.globl _ch
                                    117 	.globl _tail
                                    118 	.globl _head
                                    119 	.globl _buf
                                    120 	.globl _empty
                                    121 	.globl _full
                                    122 	.globl _mutex
                                    123 ;--------------------------------------------------------
                                    124 ; special function registers
                                    125 ;--------------------------------------------------------
                                    126 	.area RSEG    (ABS,DATA)
      000000                        127 	.org 0x0000
                           000080   128 _P0	=	0x0080
                           000081   129 _SP	=	0x0081
                           000082   130 _DPL	=	0x0082
                           000083   131 _DPH	=	0x0083
                           000087   132 _PCON	=	0x0087
                           000088   133 _TCON	=	0x0088
                           000089   134 _TMOD	=	0x0089
                           00008A   135 _TL0	=	0x008a
                           00008B   136 _TL1	=	0x008b
                           00008C   137 _TH0	=	0x008c
                           00008D   138 _TH1	=	0x008d
                           000090   139 _P1	=	0x0090
                           000098   140 _SCON	=	0x0098
                           000099   141 _SBUF	=	0x0099
                           0000A0   142 _P2	=	0x00a0
                           0000A8   143 _IE	=	0x00a8
                           0000B0   144 _P3	=	0x00b0
                           0000B8   145 _IP	=	0x00b8
                           0000D0   146 _PSW	=	0x00d0
                           0000E0   147 _ACC	=	0x00e0
                           0000F0   148 _B	=	0x00f0
                                    149 ;--------------------------------------------------------
                                    150 ; special function bits
                                    151 ;--------------------------------------------------------
                                    152 	.area RSEG    (ABS,DATA)
      000000                        153 	.org 0x0000
                           000080   154 _P0_0	=	0x0080
                           000081   155 _P0_1	=	0x0081
                           000082   156 _P0_2	=	0x0082
                           000083   157 _P0_3	=	0x0083
                           000084   158 _P0_4	=	0x0084
                           000085   159 _P0_5	=	0x0085
                           000086   160 _P0_6	=	0x0086
                           000087   161 _P0_7	=	0x0087
                           000088   162 _IT0	=	0x0088
                           000089   163 _IE0	=	0x0089
                           00008A   164 _IT1	=	0x008a
                           00008B   165 _IE1	=	0x008b
                           00008C   166 _TR0	=	0x008c
                           00008D   167 _TF0	=	0x008d
                           00008E   168 _TR1	=	0x008e
                           00008F   169 _TF1	=	0x008f
                           000090   170 _P1_0	=	0x0090
                           000091   171 _P1_1	=	0x0091
                           000092   172 _P1_2	=	0x0092
                           000093   173 _P1_3	=	0x0093
                           000094   174 _P1_4	=	0x0094
                           000095   175 _P1_5	=	0x0095
                           000096   176 _P1_6	=	0x0096
                           000097   177 _P1_7	=	0x0097
                           000098   178 _RI	=	0x0098
                           000099   179 _TI	=	0x0099
                           00009A   180 _RB8	=	0x009a
                           00009B   181 _TB8	=	0x009b
                           00009C   182 _REN	=	0x009c
                           00009D   183 _SM2	=	0x009d
                           00009E   184 _SM1	=	0x009e
                           00009F   185 _SM0	=	0x009f
                           0000A0   186 _P2_0	=	0x00a0
                           0000A1   187 _P2_1	=	0x00a1
                           0000A2   188 _P2_2	=	0x00a2
                           0000A3   189 _P2_3	=	0x00a3
                           0000A4   190 _P2_4	=	0x00a4
                           0000A5   191 _P2_5	=	0x00a5
                           0000A6   192 _P2_6	=	0x00a6
                           0000A7   193 _P2_7	=	0x00a7
                           0000A8   194 _EX0	=	0x00a8
                           0000A9   195 _ET0	=	0x00a9
                           0000AA   196 _EX1	=	0x00aa
                           0000AB   197 _ET1	=	0x00ab
                           0000AC   198 _ES	=	0x00ac
                           0000AF   199 _EA	=	0x00af
                           0000B0   200 _P3_0	=	0x00b0
                           0000B1   201 _P3_1	=	0x00b1
                           0000B2   202 _P3_2	=	0x00b2
                           0000B3   203 _P3_3	=	0x00b3
                           0000B4   204 _P3_4	=	0x00b4
                           0000B5   205 _P3_5	=	0x00b5
                           0000B6   206 _P3_6	=	0x00b6
                           0000B7   207 _P3_7	=	0x00b7
                           0000B0   208 _RXD	=	0x00b0
                           0000B1   209 _TXD	=	0x00b1
                           0000B2   210 _INT0	=	0x00b2
                           0000B3   211 _INT1	=	0x00b3
                           0000B4   212 _T0	=	0x00b4
                           0000B5   213 _T1	=	0x00b5
                           0000B6   214 _WR	=	0x00b6
                           0000B7   215 _RD	=	0x00b7
                           0000B8   216 _PX0	=	0x00b8
                           0000B9   217 _PT0	=	0x00b9
                           0000BA   218 _PX1	=	0x00ba
                           0000BB   219 _PT1	=	0x00bb
                           0000BC   220 _PS	=	0x00bc
                           0000D0   221 _P	=	0x00d0
                           0000D1   222 _F1	=	0x00d1
                           0000D2   223 _OV	=	0x00d2
                           0000D3   224 _RS0	=	0x00d3
                           0000D4   225 _RS1	=	0x00d4
                           0000D5   226 _F0	=	0x00d5
                           0000D6   227 _AC	=	0x00d6
                           0000D7   228 _CY	=	0x00d7
                                    229 ;--------------------------------------------------------
                                    230 ; overlayable register banks
                                    231 ;--------------------------------------------------------
                                    232 	.area REG_BANK_0	(REL,OVR,DATA)
      000000                        233 	.ds 8
                                    234 ;--------------------------------------------------------
                                    235 ; internal ram data
                                    236 ;--------------------------------------------------------
                                    237 	.area DSEG    (DATA)
                           000020   238 _mutex	=	0x0020
                           000021   239 _full	=	0x0021
                           000022   240 _empty	=	0x0022
                           000023   241 _buf	=	0x0023
                           000026   242 _head	=	0x0026
                           000027   243 _tail	=	0x0027
                           000028   244 _ch	=	0x0028
                                    245 ;--------------------------------------------------------
                                    246 ; overlayable items in internal ram 
                                    247 ;--------------------------------------------------------
                                    248 ;--------------------------------------------------------
                                    249 ; Stack segment in internal ram 
                                    250 ;--------------------------------------------------------
                                    251 	.area	SSEG
      000008                        252 __start__stack:
      000008                        253 	.ds	1
                                    254 
                                    255 ;--------------------------------------------------------
                                    256 ; indirectly addressable internal ram data
                                    257 ;--------------------------------------------------------
                                    258 	.area ISEG    (DATA)
                                    259 ;--------------------------------------------------------
                                    260 ; absolute internal ram data
                                    261 ;--------------------------------------------------------
                                    262 	.area IABS    (ABS,DATA)
                                    263 	.area IABS    (ABS,DATA)
                                    264 ;--------------------------------------------------------
                                    265 ; bit data
                                    266 ;--------------------------------------------------------
                                    267 	.area BSEG    (BIT)
                                    268 ;--------------------------------------------------------
                                    269 ; paged external ram data
                                    270 ;--------------------------------------------------------
                                    271 	.area PSEG    (PAG,XDATA)
                                    272 ;--------------------------------------------------------
                                    273 ; external ram data
                                    274 ;--------------------------------------------------------
                                    275 	.area XSEG    (XDATA)
                                    276 ;--------------------------------------------------------
                                    277 ; absolute external ram data
                                    278 ;--------------------------------------------------------
                                    279 	.area XABS    (ABS,XDATA)
                                    280 ;--------------------------------------------------------
                                    281 ; external initialized ram data
                                    282 ;--------------------------------------------------------
                                    283 	.area XISEG   (XDATA)
                                    284 	.area HOME    (CODE)
                                    285 	.area GSINIT0 (CODE)
                                    286 	.area GSINIT1 (CODE)
                                    287 	.area GSINIT2 (CODE)
                                    288 	.area GSINIT3 (CODE)
                                    289 	.area GSINIT4 (CODE)
                                    290 	.area GSINIT5 (CODE)
                                    291 	.area GSINIT  (CODE)
                                    292 	.area GSFINAL (CODE)
                                    293 	.area CSEG    (CODE)
                                    294 ;--------------------------------------------------------
                                    295 ; interrupt vector 
                                    296 ;--------------------------------------------------------
                                    297 	.area HOME    (CODE)
      000000                        298 __interrupt_vect:
      000000 02 00 E4         [24]  299 	ljmp	__sdcc_gsinit_startup
      000003 32               [24]  300 	reti
      000004                        301 	.ds	7
      00000B 02 00 EB         [24]  302 	ljmp	_timer0_ISR
                                    303 ;--------------------------------------------------------
                                    304 ; global & static initialisations
                                    305 ;--------------------------------------------------------
                                    306 	.area HOME    (CODE)
                                    307 	.area GSINIT  (CODE)
                                    308 	.area GSFINAL (CODE)
                                    309 	.area GSINIT  (CODE)
                                    310 	.globl __sdcc_gsinit_startup
                                    311 	.globl __sdcc_program_startup
                                    312 	.globl __start__stack
                                    313 	.globl __mcs51_genXINIT
                                    314 	.globl __mcs51_genXRAMCLEAR
                                    315 	.globl __mcs51_genRAMCLEAR
                                    316 	.area GSFINAL (CODE)
      000011 02 00 0E         [24]  317 	ljmp	__sdcc_program_startup
                                    318 ;--------------------------------------------------------
                                    319 ; Home
                                    320 ;--------------------------------------------------------
                                    321 	.area HOME    (CODE)
                                    322 	.area HOME    (CODE)
      00000E                        323 __sdcc_program_startup:
      00000E 02 00 A5         [24]  324 	ljmp	_main
                                    325 ;	return from main will return to caller
                                    326 ;--------------------------------------------------------
                                    327 ; code
                                    328 ;--------------------------------------------------------
                                    329 	.area CSEG    (CODE)
                                    330 ;------------------------------------------------------------
                                    331 ;Allocation info for local variables in function 'Producer'
                                    332 ;------------------------------------------------------------
                                    333 ;	testpreempt.c:12: void Producer(void){
                                    334 ;	-----------------------------------------
                                    335 ;	 function Producer
                                    336 ;	-----------------------------------------
      000014                        337 _Producer:
                           000007   338 	ar7 = 0x07
                           000006   339 	ar6 = 0x06
                           000005   340 	ar5 = 0x05
                           000004   341 	ar4 = 0x04
                           000003   342 	ar3 = 0x03
                           000002   343 	ar2 = 0x02
                           000001   344 	ar1 = 0x01
                           000000   345 	ar0 = 0x00
                                    346 ;	testpreempt.c:13: ch = 'A';
      000014 75 28 41         [24]  347 	mov	_ch,#0x41
                                    348 ;	testpreempt.c:14: while(1){
      000017                        349 00107$:
                                    350 ;	testpreempt.c:15: SemaphoreWait(empty);
      000017                        351 		0$:
      000017 E5 22            [12]  352 	mov a, _empty 
      000019 60 FC            [24]  353 	jz 0$ 
      00001B 20 E7 F9         [24]  354 	jb ACC.7, 0$ 
      00001E 15 22            [12]  355 	dec _empty 
                                    356 ;	testpreempt.c:25: }
      000020 7F 01            [12]  357 	mov	r7,#0x01
      000022 10 AF 02         [24]  358 	jbc	ea,00123$
      000025 7F 00            [12]  359 	mov	r7,#0x00
      000027                        360 00123$:
                                    361 ;	testpreempt.c:18: SemaphoreWait(mutex);
      000027                        362 		1$:
      000027 E5 20            [12]  363 	mov a, _mutex 
      000029 60 FC            [24]  364 	jz 1$ 
      00002B 20 E7 F9         [24]  365 	jb ACC.7, 1$ 
      00002E 15 20            [12]  366 	dec _mutex 
                                    367 ;	testpreempt.c:19: buf[head] = ch;
      000030 E5 26            [12]  368 	mov	a,_head
      000032 24 23            [12]  369 	add	a,#_buf
      000034 F8               [12]  370 	mov	r0,a
      000035 A6 28            [24]  371 	mov	@r0,_ch
                                    372 ;	testpreempt.c:20: head++;
      000037 05 26            [12]  373 	inc	_head
                                    374 ;	testpreempt.c:21: if(head == 3){
      000039 74 03            [12]  375 	mov	a,#0x03
      00003B B5 26 03         [24]  376 	cjne	a,_head,00102$
                                    377 ;	testpreempt.c:22: head = 0;
      00003E 75 26 00         [24]  378 	mov	_head,#0x00
      000041                        379 00102$:
                                    380 ;	testpreempt.c:24: SemaphoreSignal(mutex);
      000041 05 20            [12]  381 	inc _mutex 
      000043 EF               [12]  382 	mov	a,r7
      000044 13               [12]  383 	rrc	a
      000045 92 AF            [24]  384 	mov	ea,c
                                    385 ;	testpreempt.c:27: SemaphoreSignal(full);
      000047 05 21            [12]  386 	inc _full 
                                    387 ;	testpreempt.c:28: if(ch == 'Z'){
      000049 74 5A            [12]  388 	mov	a,#0x5a
      00004B B5 28 05         [24]  389 	cjne	a,_ch,00104$
                                    390 ;	testpreempt.c:29: ch = 'A';
      00004E 75 28 41         [24]  391 	mov	_ch,#0x41
      000051 80 C4            [24]  392 	sjmp	00107$
      000053                        393 00104$:
                                    394 ;	testpreempt.c:31: ch += 1;
      000053 E5 28            [12]  395 	mov	a,_ch
      000055 FF               [12]  396 	mov	r7,a
      000056 04               [12]  397 	inc	a
      000057 F5 28            [12]  398 	mov	_ch,a
                                    399 ;	testpreempt.c:34: }
      000059 80 BC            [24]  400 	sjmp	00107$
                                    401 ;------------------------------------------------------------
                                    402 ;Allocation info for local variables in function 'Consumer'
                                    403 ;------------------------------------------------------------
                                    404 ;	testpreempt.c:36: void Consumer(void) {
                                    405 ;	-----------------------------------------
                                    406 ;	 function Consumer
                                    407 ;	-----------------------------------------
      00005B                        408 _Consumer:
                                    409 ;	testpreempt.c:37: TMOD |= 0x20;
      00005B AE 89            [24]  410 	mov	r6,_TMOD
      00005D 7F 00            [12]  411 	mov	r7,#0x00
      00005F 43 06 20         [24]  412 	orl	ar6,#0x20
      000062 8E 89            [24]  413 	mov	_TMOD,r6
                                    414 ;	testpreempt.c:38: TH1 = -6;
      000064 75 8D FA         [24]  415 	mov	_TH1,#0xfa
                                    416 ;	testpreempt.c:39: SCON = 0x50;
      000067 75 98 50         [24]  417 	mov	_SCON,#0x50
                                    418 ;	testpreempt.c:40: TR1 = 1;
                                    419 ;	assignBit
      00006A D2 8E            [12]  420 	setb	_TR1
                                    421 ;	testpreempt.c:41: while (1) {
      00006C                        422 00107$:
                                    423 ;	testpreempt.c:42: SemaphoreWait(full);
      00006C                        424 		2$:
      00006C E5 21            [12]  425 	mov a, _full 
      00006E 60 FC            [24]  426 	jz 2$ 
      000070 20 E7 F9         [24]  427 	jb ACC.7, 2$ 
      000073 15 21            [12]  428 	dec _full 
                                    429 ;	testpreempt.c:54: }
      000075 7F 01            [12]  430 	mov	r7,#0x01
      000077 10 AF 02         [24]  431 	jbc	ea,00127$
      00007A 7F 00            [12]  432 	mov	r7,#0x00
      00007C                        433 00127$:
                                    434 ;	testpreempt.c:45: SemaphoreWait(mutex);
      00007C                        435 		3$:
      00007C E5 20            [12]  436 	mov a, _mutex 
      00007E 60 FC            [24]  437 	jz 3$ 
      000080 20 E7 F9         [24]  438 	jb ACC.7, 3$ 
      000083 15 20            [12]  439 	dec _mutex 
                                    440 ;	testpreempt.c:46: SBUF = buf[tail];
      000085 E5 27            [12]  441 	mov	a,_tail
      000087 24 23            [12]  442 	add	a,#_buf
      000089 F9               [12]  443 	mov	r1,a
      00008A 87 99            [24]  444 	mov	_SBUF,@r1
                                    445 ;	testpreempt.c:47: while(!TI){}
      00008C                        446 00101$:
                                    447 ;	testpreempt.c:48: TI = 0;
                                    448 ;	assignBit
      00008C 10 99 02         [24]  449 	jbc	_TI,00128$
      00008F 80 FB            [24]  450 	sjmp	00101$
      000091                        451 00128$:
                                    452 ;	testpreempt.c:49: tail++;
      000091 05 27            [12]  453 	inc	_tail
                                    454 ;	testpreempt.c:50: if(tail == 3){
      000093 74 03            [12]  455 	mov	a,#0x03
      000095 B5 27 03         [24]  456 	cjne	a,_tail,00105$
                                    457 ;	testpreempt.c:51: tail = 0;
      000098 75 27 00         [24]  458 	mov	_tail,#0x00
      00009B                        459 00105$:
                                    460 ;	testpreempt.c:53: SemaphoreSignal(mutex);
      00009B 05 20            [12]  461 	inc _mutex 
      00009D EF               [12]  462 	mov	a,r7
      00009E 13               [12]  463 	rrc	a
      00009F 92 AF            [24]  464 	mov	ea,c
                                    465 ;	testpreempt.c:56: SemaphoreSignal(empty);
      0000A1 05 22            [12]  466 	inc _empty 
                                    467 ;	testpreempt.c:58: }
      0000A3 80 C7            [24]  468 	sjmp	00107$
                                    469 ;------------------------------------------------------------
                                    470 ;Allocation info for local variables in function 'main'
                                    471 ;------------------------------------------------------------
                                    472 ;i                         Allocated to registers r5 r6 
                                    473 ;------------------------------------------------------------
                                    474 ;	testpreempt.c:60: void main(void) {
                                    475 ;	-----------------------------------------
                                    476 ;	 function main
                                    477 ;	-----------------------------------------
      0000A5                        478 _main:
                                    479 ;	testpreempt.c:70: }
      0000A5 7F 01            [12]  480 	mov	r7,#0x01
      0000A7 10 AF 02         [24]  481 	jbc	ea,00116$
      0000AA 7F 00            [12]  482 	mov	r7,#0x00
      0000AC                        483 00116$:
                                    484 ;	testpreempt.c:62: for(int i=0;i<3;i++){
      0000AC 7D 00            [12]  485 	mov	r5,#0x00
      0000AE 7E 00            [12]  486 	mov	r6,#0x00
      0000B0                        487 00103$:
      0000B0 C3               [12]  488 	clr	c
      0000B1 ED               [12]  489 	mov	a,r5
      0000B2 94 03            [12]  490 	subb	a,#0x03
      0000B4 EE               [12]  491 	mov	a,r6
      0000B5 64 80            [12]  492 	xrl	a,#0x80
      0000B7 94 80            [12]  493 	subb	a,#0x80
      0000B9 50 0D            [24]  494 	jnc	00101$
                                    495 ;	testpreempt.c:63: buf[i] = '\0';
      0000BB ED               [12]  496 	mov	a,r5
      0000BC 24 23            [12]  497 	add	a,#_buf
      0000BE F8               [12]  498 	mov	r0,a
      0000BF 76 00            [12]  499 	mov	@r0,#0x00
                                    500 ;	testpreempt.c:62: for(int i=0;i<3;i++){
      0000C1 0D               [12]  501 	inc	r5
      0000C2 BD 00 EB         [24]  502 	cjne	r5,#0x00,00103$
      0000C5 0E               [12]  503 	inc	r6
      0000C6 80 E8            [24]  504 	sjmp	00103$
      0000C8                        505 00101$:
                                    506 ;	testpreempt.c:65: head = 0;
      0000C8 75 26 00         [24]  507 	mov	_head,#0x00
                                    508 ;	testpreempt.c:66: tail = 0;
      0000CB 75 27 00         [24]  509 	mov	_tail,#0x00
                                    510 ;	testpreempt.c:67: SemaphoreCreate(mutex, 1);
      0000CE 75 20 01         [24]  511 	mov	_mutex,#0x01
                                    512 ;	testpreempt.c:68: SemaphoreCreate(full, 0);
      0000D1 75 21 00         [24]  513 	mov	_full,#0x00
                                    514 ;	testpreempt.c:69: SemaphoreCreate(empty, 3);
      0000D4 75 22 03         [24]  515 	mov	_empty,#0x03
      0000D7 EF               [12]  516 	mov	a,r7
      0000D8 13               [12]  517 	rrc	a
      0000D9 92 AF            [24]  518 	mov	ea,c
                                    519 ;	testpreempt.c:71: ThreadCreate(Producer);
      0000DB 90 00 14         [24]  520 	mov	dptr,#_Producer
      0000DE 12 01 15         [24]  521 	lcall	_ThreadCreate
                                    522 ;	testpreempt.c:72: Consumer();
                                    523 ;	testpreempt.c:73: }
      0000E1 02 00 5B         [24]  524 	ljmp	_Consumer
                                    525 ;------------------------------------------------------------
                                    526 ;Allocation info for local variables in function '_sdcc_gsinit_startup'
                                    527 ;------------------------------------------------------------
                                    528 ;	testpreempt.c:75: void _sdcc_gsinit_startup(void) {
                                    529 ;	-----------------------------------------
                                    530 ;	 function _sdcc_gsinit_startup
                                    531 ;	-----------------------------------------
      0000E4                        532 __sdcc_gsinit_startup:
                                    533 ;	testpreempt.c:78: __endasm;
      0000E4 02 00 EF         [24]  534 	ljmp	_Bootstrap
                                    535 ;	testpreempt.c:79: }
      0000E7 22               [24]  536 	ret
                                    537 ;------------------------------------------------------------
                                    538 ;Allocation info for local variables in function '_mcs51_genRAMCLEAR'
                                    539 ;------------------------------------------------------------
                                    540 ;	testpreempt.c:81: void _mcs51_genRAMCLEAR(void) {}
                                    541 ;	-----------------------------------------
                                    542 ;	 function _mcs51_genRAMCLEAR
                                    543 ;	-----------------------------------------
      0000E8                        544 __mcs51_genRAMCLEAR:
      0000E8 22               [24]  545 	ret
                                    546 ;------------------------------------------------------------
                                    547 ;Allocation info for local variables in function '_mcs51_genXINIT'
                                    548 ;------------------------------------------------------------
                                    549 ;	testpreempt.c:82: void _mcs51_genXINIT(void) {}
                                    550 ;	-----------------------------------------
                                    551 ;	 function _mcs51_genXINIT
                                    552 ;	-----------------------------------------
      0000E9                        553 __mcs51_genXINIT:
      0000E9 22               [24]  554 	ret
                                    555 ;------------------------------------------------------------
                                    556 ;Allocation info for local variables in function '_mcs51_genXRAMCLEAR'
                                    557 ;------------------------------------------------------------
                                    558 ;	testpreempt.c:83: void _mcs51_genXRAMCLEAR(void) {}
                                    559 ;	-----------------------------------------
                                    560 ;	 function _mcs51_genXRAMCLEAR
                                    561 ;	-----------------------------------------
      0000EA                        562 __mcs51_genXRAMCLEAR:
      0000EA 22               [24]  563 	ret
                                    564 ;------------------------------------------------------------
                                    565 ;Allocation info for local variables in function 'timer0_ISR'
                                    566 ;------------------------------------------------------------
                                    567 ;	testpreempt.c:85: void timer0_ISR(void) __interrupt(1) {
                                    568 ;	-----------------------------------------
                                    569 ;	 function timer0_ISR
                                    570 ;	-----------------------------------------
      0000EB                        571 _timer0_ISR:
                                    572 ;	testpreempt.c:88: __endasm;
      0000EB 02 02 61         [24]  573 	ljmp	_myTimer0Handler
                                    574 ;	testpreempt.c:89: }
      0000EE 32               [24]  575 	reti
                                    576 ;	eliminated unneeded mov psw,# (no regs used in bank)
                                    577 ;	eliminated unneeded push/pop psw
                                    578 ;	eliminated unneeded push/pop dpl
                                    579 ;	eliminated unneeded push/pop dph
                                    580 ;	eliminated unneeded push/pop b
                                    581 ;	eliminated unneeded push/pop acc
                                    582 	.area CSEG    (CODE)
                                    583 	.area CONST   (CODE)
                                    584 	.area XINIT   (CODE)
                                    585 	.area CABS    (ABS,CODE)
