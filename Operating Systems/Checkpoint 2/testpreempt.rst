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
                                    117 	.globl _buf
                                    118 ;--------------------------------------------------------
                                    119 ; special function registers
                                    120 ;--------------------------------------------------------
                                    121 	.area RSEG    (ABS,DATA)
      000000                        122 	.org 0x0000
                           000080   123 _P0	=	0x0080
                           000081   124 _SP	=	0x0081
                           000082   125 _DPL	=	0x0082
                           000083   126 _DPH	=	0x0083
                           000087   127 _PCON	=	0x0087
                           000088   128 _TCON	=	0x0088
                           000089   129 _TMOD	=	0x0089
                           00008A   130 _TL0	=	0x008a
                           00008B   131 _TL1	=	0x008b
                           00008C   132 _TH0	=	0x008c
                           00008D   133 _TH1	=	0x008d
                           000090   134 _P1	=	0x0090
                           000098   135 _SCON	=	0x0098
                           000099   136 _SBUF	=	0x0099
                           0000A0   137 _P2	=	0x00a0
                           0000A8   138 _IE	=	0x00a8
                           0000B0   139 _P3	=	0x00b0
                           0000B8   140 _IP	=	0x00b8
                           0000D0   141 _PSW	=	0x00d0
                           0000E0   142 _ACC	=	0x00e0
                           0000F0   143 _B	=	0x00f0
                                    144 ;--------------------------------------------------------
                                    145 ; special function bits
                                    146 ;--------------------------------------------------------
                                    147 	.area RSEG    (ABS,DATA)
      000000                        148 	.org 0x0000
                           000080   149 _P0_0	=	0x0080
                           000081   150 _P0_1	=	0x0081
                           000082   151 _P0_2	=	0x0082
                           000083   152 _P0_3	=	0x0083
                           000084   153 _P0_4	=	0x0084
                           000085   154 _P0_5	=	0x0085
                           000086   155 _P0_6	=	0x0086
                           000087   156 _P0_7	=	0x0087
                           000088   157 _IT0	=	0x0088
                           000089   158 _IE0	=	0x0089
                           00008A   159 _IT1	=	0x008a
                           00008B   160 _IE1	=	0x008b
                           00008C   161 _TR0	=	0x008c
                           00008D   162 _TF0	=	0x008d
                           00008E   163 _TR1	=	0x008e
                           00008F   164 _TF1	=	0x008f
                           000090   165 _P1_0	=	0x0090
                           000091   166 _P1_1	=	0x0091
                           000092   167 _P1_2	=	0x0092
                           000093   168 _P1_3	=	0x0093
                           000094   169 _P1_4	=	0x0094
                           000095   170 _P1_5	=	0x0095
                           000096   171 _P1_6	=	0x0096
                           000097   172 _P1_7	=	0x0097
                           000098   173 _RI	=	0x0098
                           000099   174 _TI	=	0x0099
                           00009A   175 _RB8	=	0x009a
                           00009B   176 _TB8	=	0x009b
                           00009C   177 _REN	=	0x009c
                           00009D   178 _SM2	=	0x009d
                           00009E   179 _SM1	=	0x009e
                           00009F   180 _SM0	=	0x009f
                           0000A0   181 _P2_0	=	0x00a0
                           0000A1   182 _P2_1	=	0x00a1
                           0000A2   183 _P2_2	=	0x00a2
                           0000A3   184 _P2_3	=	0x00a3
                           0000A4   185 _P2_4	=	0x00a4
                           0000A5   186 _P2_5	=	0x00a5
                           0000A6   187 _P2_6	=	0x00a6
                           0000A7   188 _P2_7	=	0x00a7
                           0000A8   189 _EX0	=	0x00a8
                           0000A9   190 _ET0	=	0x00a9
                           0000AA   191 _EX1	=	0x00aa
                           0000AB   192 _ET1	=	0x00ab
                           0000AC   193 _ES	=	0x00ac
                           0000AF   194 _EA	=	0x00af
                           0000B0   195 _P3_0	=	0x00b0
                           0000B1   196 _P3_1	=	0x00b1
                           0000B2   197 _P3_2	=	0x00b2
                           0000B3   198 _P3_3	=	0x00b3
                           0000B4   199 _P3_4	=	0x00b4
                           0000B5   200 _P3_5	=	0x00b5
                           0000B6   201 _P3_6	=	0x00b6
                           0000B7   202 _P3_7	=	0x00b7
                           0000B0   203 _RXD	=	0x00b0
                           0000B1   204 _TXD	=	0x00b1
                           0000B2   205 _INT0	=	0x00b2
                           0000B3   206 _INT1	=	0x00b3
                           0000B4   207 _T0	=	0x00b4
                           0000B5   208 _T1	=	0x00b5
                           0000B6   209 _WR	=	0x00b6
                           0000B7   210 _RD	=	0x00b7
                           0000B8   211 _PX0	=	0x00b8
                           0000B9   212 _PT0	=	0x00b9
                           0000BA   213 _PX1	=	0x00ba
                           0000BB   214 _PT1	=	0x00bb
                           0000BC   215 _PS	=	0x00bc
                           0000D0   216 _P	=	0x00d0
                           0000D1   217 _F1	=	0x00d1
                           0000D2   218 _OV	=	0x00d2
                           0000D3   219 _RS0	=	0x00d3
                           0000D4   220 _RS1	=	0x00d4
                           0000D5   221 _F0	=	0x00d5
                           0000D6   222 _AC	=	0x00d6
                           0000D7   223 _CY	=	0x00d7
                                    224 ;--------------------------------------------------------
                                    225 ; overlayable register banks
                                    226 ;--------------------------------------------------------
                                    227 	.area REG_BANK_0	(REL,OVR,DATA)
      000000                        228 	.ds 8
                                    229 ;--------------------------------------------------------
                                    230 ; internal ram data
                                    231 ;--------------------------------------------------------
                                    232 	.area DSEG    (DATA)
                           00003E   233 _buf	=	0x003e
                           00003F   234 _ch	=	0x003f
                                    235 ;--------------------------------------------------------
                                    236 ; overlayable items in internal ram 
                                    237 ;--------------------------------------------------------
                                    238 ;--------------------------------------------------------
                                    239 ; Stack segment in internal ram 
                                    240 ;--------------------------------------------------------
                                    241 	.area	SSEG
      000008                        242 __start__stack:
      000008                        243 	.ds	1
                                    244 
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
                                    285 ; interrupt vector 
                                    286 ;--------------------------------------------------------
                                    287 	.area HOME    (CODE)
      000000                        288 __interrupt_vect:
      000000 02 00 7D         [24]  289 	ljmp	__sdcc_gsinit_startup
      000003 32               [24]  290 	reti
      000004                        291 	.ds	7
      00000B 02 00 84         [24]  292 	ljmp	_timer0_ISR
                                    293 ;--------------------------------------------------------
                                    294 ; global & static initialisations
                                    295 ;--------------------------------------------------------
                                    296 	.area HOME    (CODE)
                                    297 	.area GSINIT  (CODE)
                                    298 	.area GSFINAL (CODE)
                                    299 	.area GSINIT  (CODE)
                                    300 	.globl __sdcc_gsinit_startup
                                    301 	.globl __sdcc_program_startup
                                    302 	.globl __start__stack
                                    303 	.globl __mcs51_genXINIT
                                    304 	.globl __mcs51_genXRAMCLEAR
                                    305 	.globl __mcs51_genRAMCLEAR
                                    306 	.area GSFINAL (CODE)
      000011 02 00 0E         [24]  307 	ljmp	__sdcc_program_startup
                                    308 ;--------------------------------------------------------
                                    309 ; Home
                                    310 ;--------------------------------------------------------
                                    311 	.area HOME    (CODE)
                                    312 	.area HOME    (CODE)
      00000E                        313 __sdcc_program_startup:
      00000E 02 00 66         [24]  314 	ljmp	_main
                                    315 ;	return from main will return to caller
                                    316 ;--------------------------------------------------------
                                    317 ; code
                                    318 ;--------------------------------------------------------
                                    319 	.area CSEG    (CODE)
                                    320 ;------------------------------------------------------------
                                    321 ;Allocation info for local variables in function 'Producer'
                                    322 ;------------------------------------------------------------
                                    323 ;	testpreempt.c:7: void Producer(void){
                                    324 ;	-----------------------------------------
                                    325 ;	 function Producer
                                    326 ;	-----------------------------------------
      000014                        327 _Producer:
                           000007   328 	ar7 = 0x07
                           000006   329 	ar6 = 0x06
                           000005   330 	ar5 = 0x05
                           000004   331 	ar4 = 0x04
                           000003   332 	ar3 = 0x03
                           000002   333 	ar2 = 0x02
                           000001   334 	ar1 = 0x01
                           000000   335 	ar0 = 0x00
                                    336 ;	testpreempt.c:8: ch = 'A';
      000014 75 3F 41         [24]  337 	mov	_ch,#0x41
                                    338 ;	testpreempt.c:10: while(buf != '\0'){}
      000017                        339 00101$:
      000017 E5 3E            [12]  340 	mov	a,_buf
      000019 70 FC            [24]  341 	jnz	00101$
                                    342 ;	testpreempt.c:13: }
      00001B 7F 01            [12]  343 	mov	r7,#0x01
      00001D 10 AF 02         [24]  344 	jbc	ea,00125$
      000020 7F 00            [12]  345 	mov	r7,#0x00
      000022                        346 00125$:
                                    347 ;	testpreempt.c:12: buf = ch;
      000022 85 3F 3E         [24]  348 	mov	_buf,_ch
      000025 EF               [12]  349 	mov	a,r7
      000026 13               [12]  350 	rrc	a
      000027 92 AF            [24]  351 	mov	ea,c
                                    352 ;	testpreempt.c:14: if(ch == 'Z'){
      000029 74 5A            [12]  353 	mov	a,#0x5a
      00002B B5 3F 05         [24]  354 	cjne	a,_ch,00105$
                                    355 ;	testpreempt.c:15: ch = 'A';
      00002E 75 3F 41         [24]  356 	mov	_ch,#0x41
      000031 80 E4            [24]  357 	sjmp	00101$
      000033                        358 00105$:
                                    359 ;	testpreempt.c:17: ch += 1;
      000033 E5 3F            [12]  360 	mov	a,_ch
      000035 FF               [12]  361 	mov	r7,a
      000036 04               [12]  362 	inc	a
      000037 F5 3F            [12]  363 	mov	_ch,a
                                    364 ;	testpreempt.c:20: }
      000039 80 DC            [24]  365 	sjmp	00101$
                                    366 ;------------------------------------------------------------
                                    367 ;Allocation info for local variables in function 'Consumer'
                                    368 ;------------------------------------------------------------
                                    369 ;	testpreempt.c:22: void Consumer(void) {
                                    370 ;	-----------------------------------------
                                    371 ;	 function Consumer
                                    372 ;	-----------------------------------------
      00003B                        373 _Consumer:
                                    374 ;	testpreempt.c:23: TMOD |= 0x20;
      00003B AE 89            [24]  375 	mov	r6,_TMOD
      00003D 7F 00            [12]  376 	mov	r7,#0x00
      00003F 43 06 20         [24]  377 	orl	ar6,#0x20
      000042 8E 89            [24]  378 	mov	_TMOD,r6
                                    379 ;	testpreempt.c:24: TH1 = -6;
      000044 75 8D FA         [24]  380 	mov	_TH1,#0xfa
                                    381 ;	testpreempt.c:25: SCON = 0x50;
      000047 75 98 50         [24]  382 	mov	_SCON,#0x50
                                    383 ;	testpreempt.c:26: TR1 = 1;
                                    384 ;	assignBit
      00004A D2 8E            [12]  385 	setb	_TR1
                                    386 ;	testpreempt.c:28: while(buf == '\0'){}
      00004C                        387 00101$:
      00004C E5 3E            [12]  388 	mov	a,_buf
      00004E 60 FC            [24]  389 	jz	00101$
                                    390 ;	testpreempt.c:32: }
      000050 7F 01            [12]  391 	mov	r7,#0x01
      000052 10 AF 02         [24]  392 	jbc	ea,00129$
      000055 7F 00            [12]  393 	mov	r7,#0x00
      000057                        394 00129$:
                                    395 ;	testpreempt.c:30: SBUF = buf;
      000057 85 3E 99         [24]  396 	mov	_SBUF,_buf
                                    397 ;	testpreempt.c:31: buf = '\0';
      00005A 75 3E 00         [24]  398 	mov	_buf,#0x00
      00005D EF               [12]  399 	mov	a,r7
      00005E 13               [12]  400 	rrc	a
      00005F 92 AF            [24]  401 	mov	ea,c
                                    402 ;	testpreempt.c:33: while(!TI){}
      000061                        403 00104$:
                                    404 ;	testpreempt.c:34: TI = 0;
                                    405 ;	assignBit
      000061 10 99 E8         [24]  406 	jbc	_TI,00101$
                                    407 ;	testpreempt.c:36: }
      000064 80 FB            [24]  408 	sjmp	00104$
                                    409 ;------------------------------------------------------------
                                    410 ;Allocation info for local variables in function 'main'
                                    411 ;------------------------------------------------------------
                                    412 ;	testpreempt.c:38: void main(void) {
                                    413 ;	-----------------------------------------
                                    414 ;	 function main
                                    415 ;	-----------------------------------------
      000066                        416 _main:
                                    417 ;	testpreempt.c:41: }
      000066 7F 01            [12]  418 	mov	r7,#0x01
      000068 10 AF 02         [24]  419 	jbc	ea,00103$
      00006B 7F 00            [12]  420 	mov	r7,#0x00
      00006D                        421 00103$:
                                    422 ;	testpreempt.c:40: buf = '\0';
      00006D 75 3E 00         [24]  423 	mov	_buf,#0x00
      000070 EF               [12]  424 	mov	a,r7
      000071 13               [12]  425 	rrc	a
      000072 92 AF            [24]  426 	mov	ea,c
                                    427 ;	testpreempt.c:42: ThreadCreate(Producer);
      000074 90 00 14         [24]  428 	mov	dptr,#_Producer
      000077 12 00 AE         [24]  429 	lcall	_ThreadCreate
                                    430 ;	testpreempt.c:43: Consumer();
                                    431 ;	testpreempt.c:44: }
      00007A 02 00 3B         [24]  432 	ljmp	_Consumer
                                    433 ;------------------------------------------------------------
                                    434 ;Allocation info for local variables in function '_sdcc_gsinit_startup'
                                    435 ;------------------------------------------------------------
                                    436 ;	testpreempt.c:46: void _sdcc_gsinit_startup(void) {
                                    437 ;	-----------------------------------------
                                    438 ;	 function _sdcc_gsinit_startup
                                    439 ;	-----------------------------------------
      00007D                        440 __sdcc_gsinit_startup:
                                    441 ;	testpreempt.c:49: __endasm;
      00007D 02 00 88         [24]  442 	ljmp	_Bootstrap
                                    443 ;	testpreempt.c:50: }
      000080 22               [24]  444 	ret
                                    445 ;------------------------------------------------------------
                                    446 ;Allocation info for local variables in function '_mcs51_genRAMCLEAR'
                                    447 ;------------------------------------------------------------
                                    448 ;	testpreempt.c:52: void _mcs51_genRAMCLEAR(void) {}
                                    449 ;	-----------------------------------------
                                    450 ;	 function _mcs51_genRAMCLEAR
                                    451 ;	-----------------------------------------
      000081                        452 __mcs51_genRAMCLEAR:
      000081 22               [24]  453 	ret
                                    454 ;------------------------------------------------------------
                                    455 ;Allocation info for local variables in function '_mcs51_genXINIT'
                                    456 ;------------------------------------------------------------
                                    457 ;	testpreempt.c:53: void _mcs51_genXINIT(void) {}
                                    458 ;	-----------------------------------------
                                    459 ;	 function _mcs51_genXINIT
                                    460 ;	-----------------------------------------
      000082                        461 __mcs51_genXINIT:
      000082 22               [24]  462 	ret
                                    463 ;------------------------------------------------------------
                                    464 ;Allocation info for local variables in function '_mcs51_genXRAMCLEAR'
                                    465 ;------------------------------------------------------------
                                    466 ;	testpreempt.c:54: void _mcs51_genXRAMCLEAR(void) {}
                                    467 ;	-----------------------------------------
                                    468 ;	 function _mcs51_genXRAMCLEAR
                                    469 ;	-----------------------------------------
      000083                        470 __mcs51_genXRAMCLEAR:
      000083 22               [24]  471 	ret
                                    472 ;------------------------------------------------------------
                                    473 ;Allocation info for local variables in function 'timer0_ISR'
                                    474 ;------------------------------------------------------------
                                    475 ;	testpreempt.c:56: void timer0_ISR(void) __interrupt(1) {
                                    476 ;	-----------------------------------------
                                    477 ;	 function timer0_ISR
                                    478 ;	-----------------------------------------
      000084                        479 _timer0_ISR:
                                    480 ;	testpreempt.c:59: __endasm;
      000084 02 01 FA         [24]  481 	ljmp	_myTimer0Handler
                                    482 ;	testpreempt.c:60: }
      000087 32               [24]  483 	reti
                                    484 ;	eliminated unneeded mov psw,# (no regs used in bank)
                                    485 ;	eliminated unneeded push/pop psw
                                    486 ;	eliminated unneeded push/pop dpl
                                    487 ;	eliminated unneeded push/pop dph
                                    488 ;	eliminated unneeded push/pop b
                                    489 ;	eliminated unneeded push/pop acc
                                    490 	.area CSEG    (CODE)
                                    491 	.area CONST   (CODE)
                                    492 	.area XINIT   (CODE)
                                    493 	.area CABS    (ABS,CODE)
