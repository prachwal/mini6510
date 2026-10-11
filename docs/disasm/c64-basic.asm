; C64 BASIC V2 ROM ($A000-$BFFF), linear disassembly (py65). BASIC does NOT talk to the drive itself: LOAD/SAVE/OPEN/PRINT#/GET# call KERNAL vectors (SETLFS $FFBA, SETNAM $FFBD, OPEN $FFC0, CHKIN/CHKOUT $FFC6/$FFC9, LOAD $FFD5, SAVE $FFD8).

A000  94 E3     STY $e3,X
A002  7B        ???
A003  E3        ???
A004  43        ???
A005  42        ???
A006  4D 42 41  EOR $4142
A009  53        ???
A00A  49 43     EOR #$43
A00C  30 A8     BMI $9fb6
A00E  41 A7     EOR ($a7,X)
A010  1D AD F7  ORA $f7ad,X
A013  A8        TAY
A014  A4 AB     LDY $ab
A016  BE AB 80  LDX $80ab,Y
A019  B0 05     BCS $a020
A01B  AC A4 A9  LDY $a9a4
A01E  9F        ???
A01F  A8        TAY
A020  70 A8     BVS $9fca
A022  27        ???
A023  A9 1C     LDA #$1c
A025  A8        TAY
A026  82        ???
A027  A8        TAY
A028  D1 A8     CMP ($a8),Y
A02A  3A        ???
A02B  A9 2E     LDA #$2e
A02D  A8        TAY
A02E  4A        LSR A
A02F  A9 2C     LDA #$2c
A031  B8        CLV
A032  67        ???
A033  E1 55     SBC ($55,X)
A035  E1 64     SBC ($64,X)
A037  E1 B2     SBC ($b2,X)
A039  B3        ???
A03A  23        ???
A03B  B8        CLV
A03C  7F        ???
A03D  AA        TAX
A03E  9F        ???
A03F  AA        TAX
A040  56 A8     LSR $a8,X
A042  9B        ???
A043  A6 5D     LDX $5d
A045  A6 85     LDX $85
A047  AA        TAX
A048  29 E1     AND #$e1
A04A  BD E1 C6  LDA $c6e1,X
A04D  E1 7A     SBC ($7a,X)
A04F  AB        ???
A050  41 A6     EOR ($a6,X)
A052  39 BC CC  AND $ccbc,Y
A055  BC 58 BC  LDY $bc58,X
A058  10 03     BPL $a05d
A05A  7D B3 9E  ADC $9eb3,X
A05D  B3        ???
A05E  71 BF     ADC ($bf),Y
A060  97        ???
A061  E0 EA     CPX #$ea
A063  B9 ED BF  LDA $bfed,Y
A066  64        ???
A067  E2        ???
A068  6B        ???
A069  E2        ???
A06A  B4 E2     LDY $e2,X
A06C  0E E3 0D  ASL $0de3
A06F  B8        CLV
A070  7C        ???
A071  B7        ???
A072  65 B4     ADC $b4
A074  AD B7 8B  LDA $8bb7
A077  B7        ???
A078  EC B6 00  CPX $00b6
A07B  B7        ???
A07C  2C B7 37  BIT $37b7
A07F  B7        ???
A080  79 69 B8  ADC $b869,Y
A083  79 52 B8  ADC $b852,Y
A086  7B        ???
A087  2A        ROL A
A088  BA        TSX
A089  7B        ???
A08A  11 BB     ORA ($bb),Y
A08C  7F        ???
A08D  7A        ???
A08E  BF        ???
A08F  50 E8     BVC $a079
A091  AF        ???
A092  46 E5     LSR $e5
A094  AF        ???
A095  7D B3 BF  ADC $bfb3,X
A098  5A        ???
A099  D3        ???
A09A  AE 64 15  LDX $1564
A09D  B0 45     BCS $a0e4
A09F  4E C4 46  LSR $46c4
A0A2  4F        ???
A0A3  D2        ???
A0A4  4E 45 58  LSR $5845
A0A7  D4        ???
A0A8  44        ???
A0A9  41 54     EOR ($54,X)
A0AB  C1 49     CMP ($49,X)
A0AD  4E 50 55  LSR $5550
A0B0  54        ???
A0B1  A3        ???
A0B2  49 4E     EOR #$4e
A0B4  50 55     BVC $a10b
A0B6  D4        ???
A0B7  44        ???
A0B8  49 CD     EOR #$cd
A0BA  52        ???
A0BB  45 41     EOR $41
A0BD  C4 4C     CPY $4c
A0BF  45 D4     EOR $d4
A0C1  47        ???
A0C2  4F        ???
A0C3  54        ???
A0C4  CF        ???
A0C5  52        ???
A0C6  55 CE     EOR $ce,X
A0C8  49 C6     EOR #$c6
A0CA  52        ???
A0CB  45 53     EOR $53
A0CD  54        ???
A0CE  4F        ???
A0CF  52        ???
A0D0  C5 47     CMP $47
A0D2  4F        ???
A0D3  53        ???
A0D4  55 C2     EOR $c2,X
A0D6  52        ???
A0D7  45 54     EOR $54
A0D9  55 52     EOR $52,X
A0DB  CE 52 45  DEC $4552
A0DE  CD 53 54  CMP $5453
A0E1  4F        ???
A0E2  D0 4F     BNE $a133
A0E4  CE 57 41  DEC $4157
A0E7  49 D4     EOR #$d4
A0E9  4C 4F 41  JMP $414f
A0EC  C4 53     CPY $53
A0EE  41 56     EOR ($56,X)
A0F0  C5 56     CMP $56
A0F2  45 52     EOR $52
A0F4  49 46     EOR #$46
A0F6  D9 44 45  CMP $4544,Y
A0F9  C6 50     DEC $50
A0FB  4F        ???
A0FC  4B        ???
A0FD  C5 50     CMP $50
A0FF  52        ???
A100  49 4E     EOR #$4e
A102  54        ???
A103  A3        ???
A104  50 52     BVC $a158
A106  49 4E     EOR #$4e
A108  D4        ???
A109  43        ???
A10A  4F        ???
A10B  4E D4 4C  LSR $4cd4
A10E  49 53     EOR #$53
A110  D4        ???
A111  43        ???
A112  4C D2 43  JMP $43d2
A115  4D C4 53  EOR $53c4
A118  59 D3 4F  EOR $4fd3,Y
A11B  50 45     BVC $a162
A11D  CE 43 4C  DEC $4c43
A120  4F        ???
A121  53        ???
A122  C5 47     CMP $47
A124  45 D4     EOR $d4
A126  4E 45 D7  LSR $d745
A129  54        ???
A12A  41 42     EOR ($42,X)
A12C  A8        TAY
A12D  54        ???
A12E  CF        ???
A12F  46 CE     LSR $ce
A131  53        ???
A132  50 43     BVC $a177
A134  A8        TAY
A135  54        ???
A136  48        PHA
A137  45 CE     EOR $ce
A139  4E 4F D4  LSR $d44f
A13C  53        ???
A13D  54        ???
A13E  45 D0     EOR $d0
A140  AB        ???
A141  AD AA AF  LDA $afaa
A144  DE 41 4E  DEC $4e41,X
A147  C4 4F     CPY $4f
A149  D2        ???
A14A  BE BD BC  LDX $bcbd,Y
A14D  53        ???
A14E  47        ???
A14F  CE 49 4E  DEC $4e49
A152  D4        ???
A153  41 42     EOR ($42,X)
A155  D3        ???
A156  55 53     EOR $53,X
A158  D2        ???
A159  46 52     LSR $52
A15B  C5 50     CMP $50
A15D  4F        ???
A15E  D3        ???
A15F  53        ???
A160  51 D2     EOR ($d2),Y
A162  52        ???
A163  4E C4 4C  LSR $4cc4
A166  4F        ???
A167  C7        ???
A168  45 58     EOR $58
A16A  D0 43     BNE $a1af
A16C  4F        ???
A16D  D3        ???
A16E  53        ???
A16F  49 CE     EOR #$ce
A171  54        ???
A172  41 CE     EOR ($ce,X)
A174  41 54     EOR ($54,X)
A176  CE 50 45  DEC $4550
A179  45 CB     EOR $cb
A17B  4C 45 CE  JMP $ce45
A17E  53        ???
A17F  54        ???
A180  52        ???
A181  A4 56     LDY $56
A183  41 CC     EOR ($cc,X)
A185  41 53     EOR ($53,X)
A187  C3        ???
A188  43        ???
A189  48        PHA
A18A  52        ???
A18B  A4 4C     LDY $4c
A18D  45 46     EOR $46
A18F  54        ???
A190  A4 52     LDY $52
A192  49 47     EOR #$47
A194  48        PHA
A195  54        ???
A196  A4 4D     LDY $4d
A198  49 44     EOR #$44
A19A  A4 47     LDY $47
A19C  CF        ???
A19D  00        BRK
A19E  54        ???
A19F  4F        ???
A1A0  4F        ???
A1A1  20 4D 41  JSR $414d
A1A4  4E 59 20  LSR $2059
A1A7  46 49     LSR $49
A1A9  4C 45 D3  JMP $d345
A1AC  46 49     LSR $49
A1AE  4C 45 20  JMP $2045
A1B1  4F        ???
A1B2  50 45     BVC $a1f9
A1B4  CE 46 49  DEC $4946
A1B7  4C 45 20  JMP $2045
A1BA  4E 4F 54  LSR $544f
A1BD  20 4F 50  JSR $504f
A1C0  45 CE     EOR $ce
A1C2  46 49     LSR $49
A1C4  4C 45 20  JMP $2045
A1C7  4E 4F 54  LSR $544f
A1CA  20 46 4F  JSR $4f46
A1CD  55 4E     EOR $4e,X
A1CF  C4 44     CPY $44
A1D1  45 56     EOR $56
A1D3  49 43     EOR #$43
A1D5  45 20     EOR $20
A1D7  4E 4F 54  LSR $544f
A1DA  20 50 52  JSR $5250
A1DD  45 53     EOR $53
A1DF  45 4E     EOR $4e
A1E1  D4        ???
A1E2  4E 4F 54  LSR $544f
A1E5  20 49 4E  JSR $4e49
A1E8  50 55     BVC $a23f
A1EA  54        ???
A1EB  20 46 49  JSR $4946
A1EE  4C C5 4E  JMP $4ec5
A1F1  4F        ???
A1F2  54        ???
A1F3  20 4F 55  JSR $554f
A1F6  54        ???
A1F7  50 55     BVC $a24e
A1F9  54        ???
A1FA  20 46 49  JSR $4946
A1FD  4C C5 4D  JMP $4dc5
A200  49 53     EOR #$53
A202  53        ???
A203  49 4E     EOR #$4e
A205  47        ???
A206  20 46 49  JSR $4946
A209  4C 45 20  JMP $2045
A20C  4E 41 4D  LSR $4d41
A20F  C5 49     CMP $49
A211  4C 4C 45  JMP $454c
A214  47        ???
A215  41 4C     EOR ($4c,X)
A217  20 44 45  JSR $4544
A21A  56 49     LSR $49,X
A21C  43        ???
A21D  45 20     EOR $20
A21F  4E 55 4D  LSR $4d55
A222  42        ???
A223  45 D2     EOR $d2
A225  4E 45 58  LSR $5845
A228  54        ???
A229  20 57 49  JSR $4957
A22C  54        ???
A22D  48        PHA
A22E  4F        ???
A22F  55 54     EOR $54,X
A231  20 46 4F  JSR $4f46
A234  D2        ???
A235  53        ???
A236  59 4E 54  EOR $544e,Y
A239  41 D8     EOR ($d8,X)
A23B  52        ???
A23C  45 54     EOR $54
A23E  55 52     EOR $52,X
A240  4E 20 57  LSR $5720
A243  49 54     EOR #$54
A245  48        PHA
A246  4F        ???
A247  55 54     EOR $54,X
A249  20 47 4F  JSR $4f47
A24C  53        ???
A24D  55 C2     EOR $c2,X
A24F  4F        ???
A250  55 54     EOR $54,X
A252  20 4F 46  JSR $464f
A255  20 44 41  JSR $4144
A258  54        ???
A259  C1 49     CMP ($49,X)
A25B  4C 4C 45  JMP $454c
A25E  47        ???
A25F  41 4C     EOR ($4c,X)
A261  20 51 55  JSR $5551
A264  41 4E     EOR ($4e,X)
A266  54        ???
A267  49 54     EOR #$54
A269  D9 4F 56  CMP $564f,Y
A26C  45 52     EOR $52
A26E  46 4C     LSR $4c
A270  4F        ???
A271  D7        ???
A272  4F        ???
A273  55 54     EOR $54,X
A275  20 4F 46  JSR $464f
A278  20 4D 45  JSR $454d
A27B  4D 4F 52  EOR $524f
A27E  D9 55 4E  CMP $4e55,Y
A281  44        ???
A282  45 46     EOR $46
A284  27        ???
A285  44        ???
A286  20 53 54  JSR $5453
A289  41 54     EOR ($54,X)
A28B  45 4D     EOR $4d
A28D  45 4E     EOR $4e
A28F  D4        ???
A290  42        ???
A291  41 44     EOR ($44,X)
A293  20 53 55  JSR $5553
A296  42        ???
A297  53        ???
A298  43        ???
A299  52        ???
A29A  49 50     EOR #$50
A29C  D4        ???
A29D  52        ???
A29E  45 44     EOR $44
A2A0  49 4D     EOR #$4d
A2A2  27        ???
A2A3  44        ???
A2A4  20 41 52  JSR $5241
A2A7  52        ???
A2A8  41 D9     EOR ($d9,X)
A2AA  44        ???
A2AB  49 56     EOR #$56
A2AD  49 53     EOR #$53
A2AF  49 4F     EOR #$4f
A2B1  4E 20 42  LSR $4220
A2B4  59 20 5A  EOR $5a20,Y
A2B7  45 52     EOR $52
A2B9  CF        ???
A2BA  49 4C     EOR #$4c
A2BC  4C 45 47  JMP $4745
A2BF  41 4C     EOR ($4c,X)
A2C1  20 44 49  JSR $4944
A2C4  52        ???
A2C5  45 43     EOR $43
A2C7  D4        ???
A2C8  54        ???
A2C9  59 50 45  EOR $4550,Y
A2CC  20 4D 49  JSR $494d
A2CF  53        ???
A2D0  4D 41 54  EOR $5441
A2D3  43        ???
A2D4  C8        INY
A2D5  53        ???
A2D6  54        ???
A2D7  52        ???
A2D8  49 4E     EOR #$4e
A2DA  47        ???
A2DB  20 54 4F  JSR $4f54
A2DE  4F        ???
A2DF  20 4C 4F  JSR $4f4c
A2E2  4E C7 46  LSR $46c7
A2E5  49 4C     EOR #$4c
A2E7  45 20     EOR $20
A2E9  44        ???
A2EA  41 54     EOR ($54,X)
A2EC  C1 46     CMP ($46,X)
A2EE  4F        ???
A2EF  52        ???
A2F0  4D 55 4C  EOR $4c55
A2F3  41 20     EOR ($20,X)
A2F5  54        ???
A2F6  4F        ???
A2F7  4F        ???
A2F8  20 43 4F  JSR $4f43
A2FB  4D 50 4C  EOR $4c50
A2FE  45 D8     EOR $d8
A300  43        ???
A301  41 4E     EOR ($4e,X)
A303  27        ???
A304  54        ???
A305  20 43 4F  JSR $4f43
A308  4E 54 49  LSR $4954
A30B  4E 55 C5  LSR $c555
A30E  55 4E     EOR $4e,X
A310  44        ???
A311  45 46     EOR $46
A313  27        ???
A314  44        ???
A315  20 46 55  JSR $5546
A318  4E 43 54  LSR $5443
A31B  49 4F     EOR #$4f
A31D  CE 56 45  DEC $4556
A320  52        ???
A321  49 46     EOR #$46
A323  D9 4C 4F  CMP $4f4c,Y
A326  41 C4     EOR ($c4,X)
A328  9E        ???
A329  A1 AC     LDA ($ac,X)
A32B  A1 B5     LDA ($b5,X)
A32D  A1 C2     LDA ($c2,X)
A32F  A1 D0     LDA ($d0,X)
A331  A1 E2     LDA ($e2,X)
A333  A1 F0     LDA ($f0,X)
A335  A1 FF     LDA ($ff,X)
A337  A1 10     LDA ($10,X)
A339  A2 25     LDX #$25
A33B  A2 35     LDX #$35
A33D  A2 3B     LDX #$3b
A33F  A2 4F     LDX #$4f
A341  A2 5A     LDX #$5a
A343  A2 6A     LDX #$6a
A345  A2 72     LDX #$72
A347  A2 7F     LDX #$7f
A349  A2 90     LDX #$90
A34B  A2 9D     LDX #$9d
A34D  A2 AA     LDX #$aa
A34F  A2 BA     LDX #$ba
A351  A2 C8     LDX #$c8
A353  A2 D5     LDX #$d5
A355  A2 E4     LDX #$e4
A357  A2 ED     LDX #$ed
A359  A2 00     LDX #$00
A35B  A3        ???
A35C  0E A3 1E  ASL $1ea3
A35F  A3        ???
A360  24 A3     BIT $a3
A362  83        ???
A363  A3        ???
A364  0D 4F 4B  ORA $4b4f
A367  0D 00 20  ORA $2000
A36A  20 45 52  JSR $5245
A36D  52        ???
A36E  4F        ???
A36F  52        ???
A370  00        BRK
A371  20 49 4E  JSR $4e49
A374  20 00 0D  JSR $0d00
A377  0A        ASL A
A378  52        ???
A379  45 41     EOR $41
A37B  44        ???
A37C  59 2E 0D  EOR $0d2e,Y
A37F  0A        ASL A
A380  00        BRK
A381  0D 0A 42  ORA $420a
A384  52        ???
A385  45 41     EOR $41
A387  4B        ???
A388  00        BRK
A389  A0 BA     LDY #$ba
A38B  E8        INX
A38C  E8        INX
A38D  E8        INX
A38E  E8        INX
A38F  BD 01 01  LDA $0101,X
A392  C9 81     CMP #$81
A394  D0 21     BNE $a3b7
A396  A5 4A     LDA $4a
A398  D0 0A     BNE $a3a4
A39A  BD 02 01  LDA $0102,X
A39D  85 49     STA $49
A39F  BD 03 01  LDA $0103,X
A3A2  85 4A     STA $4a
A3A4  DD 03 01  CMP $0103,X
A3A7  D0 07     BNE $a3b0
A3A9  A5 49     LDA $49
A3AB  DD 02 01  CMP $0102,X
A3AE  F0 07     BEQ $a3b7
A3B0  8A        TXA
A3B1  18        CLC
A3B2  69 12     ADC #$12
A3B4  AA        TAX
A3B5  D0 D8     BNE $a38f
A3B7  60        RTS
A3B8  20 08 A4  JSR $a408
A3BB  85 31     STA $31
A3BD  84 32     STY $32
A3BF  38        SEC
A3C0  A5 5A     LDA $5a
A3C2  E5 5F     SBC $5f
A3C4  85 22     STA $22
A3C6  A8        TAY
A3C7  A5 5B     LDA $5b
A3C9  E5 60     SBC $60
A3CB  AA        TAX
A3CC  E8        INX
A3CD  98        TYA
A3CE  F0 23     BEQ $a3f3
A3D0  A5 5A     LDA $5a
A3D2  38        SEC
A3D3  E5 22     SBC $22
A3D5  85 5A     STA $5a
A3D7  B0 03     BCS $a3dc
A3D9  C6 5B     DEC $5b
A3DB  38        SEC
A3DC  A5 58     LDA $58
A3DE  E5 22     SBC $22
A3E0  85 58     STA $58
A3E2  B0 08     BCS $a3ec
A3E4  C6 59     DEC $59
A3E6  90 04     BCC $a3ec
A3E8  B1 5A     LDA ($5a),Y
A3EA  91 58     STA ($58),Y
A3EC  88        DEY
A3ED  D0 F9     BNE $a3e8
A3EF  B1 5A     LDA ($5a),Y
A3F1  91 58     STA ($58),Y
A3F3  C6 5B     DEC $5b
A3F5  C6 59     DEC $59
A3F7  CA        DEX
A3F8  D0 F2     BNE $a3ec
A3FA  60        RTS
A3FB  0A        ASL A
A3FC  69 3E     ADC #$3e
A3FE  B0 35     BCS $a435
A400  85 22     STA $22
A402  BA        TSX
A403  E4 22     CPX $22
A405  90 2E     BCC $a435
A407  60        RTS
A408  C4 34     CPY $34
A40A  90 28     BCC $a434
A40C  D0 04     BNE $a412
A40E  C5 33     CMP $33
A410  90 22     BCC $a434
A412  48        PHA
A413  A2 09     LDX #$09
A415  98        TYA
A416  48        PHA
A417  B5 57     LDA $57,X
A419  CA        DEX
A41A  10 FA     BPL $a416
A41C  20 26 B5  JSR $b526
A41F  A2 F7     LDX #$f7
A421  68        PLA
A422  95 61     STA $61,X
A424  E8        INX
A425  30 FA     BMI $a421
A427  68        PLA
A428  A8        TAY
A429  68        PLA
A42A  C4 34     CPY $34
A42C  90 06     BCC $a434
A42E  D0 05     BNE $a435
A430  C5 33     CMP $33
A432  B0 01     BCS $a435
A434  60        RTS
A435  A2 10     LDX #$10
A437  6C 00 03  JMP ($0300)
A43A  8A        TXA
A43B  0A        ASL A
A43C  AA        TAX
A43D  BD 26 A3  LDA $a326,X
A440  85 22     STA $22
A442  BD 27 A3  LDA $a327,X
A445  85 23     STA $23
A447  20 CC FF  JSR $ffcc
A44A  A9 00     LDA #$00
A44C  85 13     STA $13
A44E  20 D7 AA  JSR $aad7
A451  20 45 AB  JSR $ab45
A454  A0 00     LDY #$00
A456  B1 22     LDA ($22),Y
A458  48        PHA
A459  29 7F     AND #$7f
A45B  20 47 AB  JSR $ab47
A45E  C8        INY
A45F  68        PLA
A460  10 F4     BPL $a456
A462  20 7A A6  JSR $a67a
A465  A9 69     LDA #$69
A467  A0 A3     LDY #$a3
A469  20 1E AB  JSR $ab1e
A46C  A4 3A     LDY $3a
A46E  C8        INY
A46F  F0 03     BEQ $a474
A471  20 C2 BD  JSR $bdc2
A474  A9 76     LDA #$76
A476  A0 A3     LDY #$a3
A478  20 1E AB  JSR $ab1e
A47B  A9 80     LDA #$80
A47D  20 90 FF  JSR $ff90
A480  6C 02 03  JMP ($0302)
A483  20 60 A5  JSR $a560
A486  86 7A     STX $7a
A488  84 7B     STY $7b
A48A  20 73 00  JSR $0073
A48D  AA        TAX
A48E  F0 F0     BEQ $a480
A490  A2 FF     LDX #$ff
A492  86 3A     STX $3a
A494  90 06     BCC $a49c
A496  20 79 A5  JSR $a579
A499  4C E1 A7  JMP $a7e1
A49C  20 6B A9  JSR $a96b
A49F  20 79 A5  JSR $a579
A4A2  84 0B     STY $0b
A4A4  20 13 A6  JSR $a613
A4A7  90 44     BCC $a4ed
A4A9  A0 01     LDY #$01
A4AB  B1 5F     LDA ($5f),Y
A4AD  85 23     STA $23
A4AF  A5 2D     LDA $2d
A4B1  85 22     STA $22
A4B3  A5 60     LDA $60
A4B5  85 25     STA $25
A4B7  A5 5F     LDA $5f
A4B9  88        DEY
A4BA  F1 5F     SBC ($5f),Y
A4BC  18        CLC
A4BD  65 2D     ADC $2d
A4BF  85 2D     STA $2d
A4C1  85 24     STA $24
A4C3  A5 2E     LDA $2e
A4C5  69 FF     ADC #$ff
A4C7  85 2E     STA $2e
A4C9  E5 60     SBC $60
A4CB  AA        TAX
A4CC  38        SEC
A4CD  A5 5F     LDA $5f
A4CF  E5 2D     SBC $2d
A4D1  A8        TAY
A4D2  B0 03     BCS $a4d7
A4D4  E8        INX
A4D5  C6 25     DEC $25
A4D7  18        CLC
A4D8  65 22     ADC $22
A4DA  90 03     BCC $a4df
A4DC  C6 23     DEC $23
A4DE  18        CLC
A4DF  B1 22     LDA ($22),Y
A4E1  91 24     STA ($24),Y
A4E3  C8        INY
A4E4  D0 F9     BNE $a4df
A4E6  E6 23     INC $23
A4E8  E6 25     INC $25
A4EA  CA        DEX
A4EB  D0 F2     BNE $a4df
A4ED  20 59 A6  JSR $a659
A4F0  20 33 A5  JSR $a533
A4F3  AD 00 02  LDA $0200
A4F6  F0 88     BEQ $a480
A4F8  18        CLC
A4F9  A5 2D     LDA $2d
A4FB  85 5A     STA $5a
A4FD  65 0B     ADC $0b
A4FF  85 58     STA $58
A501  A4 2E     LDY $2e
A503  84 5B     STY $5b
A505  90 01     BCC $a508
A507  C8        INY
A508  84 59     STY $59
A50A  20 B8 A3  JSR $a3b8
A50D  A5 14     LDA $14
A50F  A4 15     LDY $15
A511  8D FE 01  STA $01fe
A514  8C FF 01  STY $01ff
A517  A5 31     LDA $31
A519  A4 32     LDY $32
A51B  85 2D     STA $2d
A51D  84 2E     STY $2e
A51F  A4 0B     LDY $0b
A521  88        DEY
A522  B9 FC 01  LDA $01fc,Y
A525  91 5F     STA ($5f),Y
A527  88        DEY
A528  10 F8     BPL $a522
A52A  20 59 A6  JSR $a659
A52D  20 33 A5  JSR $a533
A530  4C 80 A4  JMP $a480
A533  A5 2B     LDA $2b
A535  A4 2C     LDY $2c
A537  85 22     STA $22
A539  84 23     STY $23
A53B  18        CLC
A53C  A0 01     LDY #$01
A53E  B1 22     LDA ($22),Y
A540  F0 1D     BEQ $a55f
A542  A0 04     LDY #$04
A544  C8        INY
A545  B1 22     LDA ($22),Y
A547  D0 FB     BNE $a544
A549  C8        INY
A54A  98        TYA
A54B  65 22     ADC $22
A54D  AA        TAX
A54E  A0 00     LDY #$00
A550  91 22     STA ($22),Y
A552  A5 23     LDA $23
A554  69 00     ADC #$00
A556  C8        INY
A557  91 22     STA ($22),Y
A559  86 22     STX $22
A55B  85 23     STA $23
A55D  90 DD     BCC $a53c
A55F  60        RTS
A560  A2 00     LDX #$00
A562  20 12 E1  JSR $e112
A565  C9 0D     CMP #$0d
A567  F0 0D     BEQ $a576
A569  9D 00 02  STA $0200,X
A56C  E8        INX
A56D  E0 59     CPX #$59
A56F  90 F1     BCC $a562
A571  A2 17     LDX #$17
A573  4C 37 A4  JMP $a437
A576  4C CA AA  JMP $aaca
A579  6C 04 03  JMP ($0304)
A57C  A6 7A     LDX $7a
A57E  A0 04     LDY #$04
A580  84 0F     STY $0f
A582  BD 00 02  LDA $0200,X
A585  10 07     BPL $a58e
A587  C9 FF     CMP #$ff
A589  F0 3E     BEQ $a5c9
A58B  E8        INX
A58C  D0 F4     BNE $a582
A58E  C9 20     CMP #$20
A590  F0 37     BEQ $a5c9
A592  85 08     STA $08
A594  C9 22     CMP #$22
A596  F0 56     BEQ $a5ee
A598  24 0F     BIT $0f
A59A  70 2D     BVS $a5c9
A59C  C9 3F     CMP #$3f
A59E  D0 04     BNE $a5a4
A5A0  A9 99     LDA #$99
A5A2  D0 25     BNE $a5c9
A5A4  C9 30     CMP #$30
A5A6  90 04     BCC $a5ac
A5A8  C9 3C     CMP #$3c
A5AA  90 1D     BCC $a5c9
A5AC  84 71     STY $71
A5AE  A0 00     LDY #$00
A5B0  84 0B     STY $0b
A5B2  88        DEY
A5B3  86 7A     STX $7a
A5B5  CA        DEX
A5B6  C8        INY
A5B7  E8        INX
A5B8  BD 00 02  LDA $0200,X
A5BB  38        SEC
A5BC  F9 9E A0  SBC $a09e,Y
A5BF  F0 F5     BEQ $a5b6
A5C1  C9 80     CMP #$80
A5C3  D0 30     BNE $a5f5
A5C5  05 0B     ORA $0b
A5C7  A4 71     LDY $71
A5C9  E8        INX
A5CA  C8        INY
A5CB  99 FB 01  STA $01fb,Y
A5CE  B9 FB 01  LDA $01fb,Y
A5D1  F0 36     BEQ $a609
A5D3  38        SEC
A5D4  E9 3A     SBC #$3a
A5D6  F0 04     BEQ $a5dc
A5D8  C9 49     CMP #$49
A5DA  D0 02     BNE $a5de
A5DC  85 0F     STA $0f
A5DE  38        SEC
A5DF  E9 55     SBC #$55
A5E1  D0 9F     BNE $a582
A5E3  85 08     STA $08
A5E5  BD 00 02  LDA $0200,X
A5E8  F0 DF     BEQ $a5c9
A5EA  C5 08     CMP $08
A5EC  F0 DB     BEQ $a5c9
A5EE  C8        INY
A5EF  99 FB 01  STA $01fb,Y
A5F2  E8        INX
A5F3  D0 F0     BNE $a5e5
A5F5  A6 7A     LDX $7a
A5F7  E6 0B     INC $0b
A5F9  C8        INY
A5FA  B9 9D A0  LDA $a09d,Y
A5FD  10 FA     BPL $a5f9
A5FF  B9 9E A0  LDA $a09e,Y
A602  D0 B4     BNE $a5b8
A604  BD 00 02  LDA $0200,X
A607  10 BE     BPL $a5c7
A609  99 FD 01  STA $01fd,Y
A60C  C6 7B     DEC $7b
A60E  A9 FF     LDA #$ff
A610  85 7A     STA $7a
A612  60        RTS
A613  A5 2B     LDA $2b
A615  A6 2C     LDX $2c
A617  A0 01     LDY #$01
A619  85 5F     STA $5f
A61B  86 60     STX $60
A61D  B1 5F     LDA ($5f),Y
A61F  F0 1F     BEQ $a640
A621  C8        INY
A622  C8        INY
A623  A5 15     LDA $15
A625  D1 5F     CMP ($5f),Y
A627  90 18     BCC $a641
A629  F0 03     BEQ $a62e
A62B  88        DEY
A62C  D0 09     BNE $a637
A62E  A5 14     LDA $14
A630  88        DEY
A631  D1 5F     CMP ($5f),Y
A633  90 0C     BCC $a641
A635  F0 0A     BEQ $a641
A637  88        DEY
A638  B1 5F     LDA ($5f),Y
A63A  AA        TAX
A63B  88        DEY
A63C  B1 5F     LDA ($5f),Y
A63E  B0 D7     BCS $a617
A640  18        CLC
A641  60        RTS
A642  D0 FD     BNE $a641
A644  A9 00     LDA #$00
A646  A8        TAY
A647  91 2B     STA ($2b),Y
A649  C8        INY
A64A  91 2B     STA ($2b),Y
A64C  A5 2B     LDA $2b
A64E  18        CLC
A64F  69 02     ADC #$02
A651  85 2D     STA $2d
A653  A5 2C     LDA $2c
A655  69 00     ADC #$00
A657  85 2E     STA $2e
A659  20 8E A6  JSR $a68e
A65C  A9 00     LDA #$00
A65E  D0 2D     BNE $a68d
A660  20 E7 FF  JSR $ffe7
A663  A5 37     LDA $37
A665  A4 38     LDY $38
A667  85 33     STA $33
A669  84 34     STY $34
A66B  A5 2D     LDA $2d
A66D  A4 2E     LDY $2e
A66F  85 2F     STA $2f
A671  84 30     STY $30
A673  85 31     STA $31
A675  84 32     STY $32
A677  20 1D A8  JSR $a81d
A67A  A2 19     LDX #$19
A67C  86 16     STX $16
A67E  68        PLA
A67F  A8        TAY
A680  68        PLA
A681  A2 FA     LDX #$fa
A683  9A        TXS
A684  48        PHA
A685  98        TYA
A686  48        PHA
A687  A9 00     LDA #$00
A689  85 3E     STA $3e
A68B  85 10     STA $10
A68D  60        RTS
A68E  18        CLC
A68F  A5 2B     LDA $2b
A691  69 FF     ADC #$ff
A693  85 7A     STA $7a
A695  A5 2C     LDA $2c
A697  69 FF     ADC #$ff
A699  85 7B     STA $7b
A69B  60        RTS
A69C  90 06     BCC $a6a4
A69E  F0 04     BEQ $a6a4
A6A0  C9 AB     CMP #$ab
A6A2  D0 E9     BNE $a68d
A6A4  20 6B A9  JSR $a96b
A6A7  20 13 A6  JSR $a613
A6AA  20 79 00  JSR $0079
A6AD  F0 0C     BEQ $a6bb
A6AF  C9 AB     CMP #$ab
A6B1  D0 8E     BNE $a641
A6B3  20 73 00  JSR $0073
A6B6  20 6B A9  JSR $a96b
A6B9  D0 86     BNE $a641
A6BB  68        PLA
A6BC  68        PLA
A6BD  A5 14     LDA $14
A6BF  05 15     ORA $15
A6C1  D0 06     BNE $a6c9
A6C3  A9 FF     LDA #$ff
A6C5  85 14     STA $14
A6C7  85 15     STA $15
A6C9  A0 01     LDY #$01
A6CB  84 0F     STY $0f
A6CD  B1 5F     LDA ($5f),Y
A6CF  F0 43     BEQ $a714
A6D1  20 2C A8  JSR $a82c
A6D4  20 D7 AA  JSR $aad7
A6D7  C8        INY
A6D8  B1 5F     LDA ($5f),Y
A6DA  AA        TAX
A6DB  C8        INY
A6DC  B1 5F     LDA ($5f),Y
A6DE  C5 15     CMP $15
A6E0  D0 04     BNE $a6e6
A6E2  E4 14     CPX $14
A6E4  F0 02     BEQ $a6e8
A6E6  B0 2C     BCS $a714
A6E8  84 49     STY $49
A6EA  20 CD BD  JSR $bdcd
A6ED  A9 20     LDA #$20
A6EF  A4 49     LDY $49
A6F1  29 7F     AND #$7f
A6F3  20 47 AB  JSR $ab47
A6F6  C9 22     CMP #$22
A6F8  D0 06     BNE $a700
A6FA  A5 0F     LDA $0f
A6FC  49 FF     EOR #$ff
A6FE  85 0F     STA $0f
A700  C8        INY
A701  F0 11     BEQ $a714
A703  B1 5F     LDA ($5f),Y
A705  D0 10     BNE $a717
A707  A8        TAY
A708  B1 5F     LDA ($5f),Y
A70A  AA        TAX
A70B  C8        INY
A70C  B1 5F     LDA ($5f),Y
A70E  86 5F     STX $5f
A710  85 60     STA $60
A712  D0 B5     BNE $a6c9
A714  4C 86 E3  JMP $e386
A717  6C 06 03  JMP ($0306)
A71A  10 D7     BPL $a6f3
A71C  C9 FF     CMP #$ff
A71E  F0 D3     BEQ $a6f3
A720  24 0F     BIT $0f
A722  30 CF     BMI $a6f3
A724  38        SEC
A725  E9 7F     SBC #$7f
A727  AA        TAX
A728  84 49     STY $49
A72A  A0 FF     LDY #$ff
A72C  CA        DEX
A72D  F0 08     BEQ $a737
A72F  C8        INY
A730  B9 9E A0  LDA $a09e,Y
A733  10 FA     BPL $a72f
A735  30 F5     BMI $a72c
A737  C8        INY
A738  B9 9E A0  LDA $a09e,Y
A73B  30 B2     BMI $a6ef
A73D  20 47 AB  JSR $ab47
A740  D0 F5     BNE $a737
A742  A9 80     LDA #$80
A744  85 10     STA $10
A746  20 A5 A9  JSR $a9a5
A749  20 8A A3  JSR $a38a
A74C  D0 05     BNE $a753
A74E  8A        TXA
A74F  69 0F     ADC #$0f
A751  AA        TAX
A752  9A        TXS
A753  68        PLA
A754  68        PLA
A755  A9 09     LDA #$09
A757  20 FB A3  JSR $a3fb
A75A  20 06 A9  JSR $a906
A75D  18        CLC
A75E  98        TYA
A75F  65 7A     ADC $7a
A761  48        PHA
A762  A5 7B     LDA $7b
A764  69 00     ADC #$00
A766  48        PHA
A767  A5 3A     LDA $3a
A769  48        PHA
A76A  A5 39     LDA $39
A76C  48        PHA
A76D  A9 A4     LDA #$a4
A76F  20 FF AE  JSR $aeff
A772  20 8D AD  JSR $ad8d
A775  20 8A AD  JSR $ad8a
A778  A5 66     LDA $66
A77A  09 7F     ORA #$7f
A77C  25 62     AND $62
A77E  85 62     STA $62
A780  A9 8B     LDA #$8b
A782  A0 A7     LDY #$a7
A784  85 22     STA $22
A786  84 23     STY $23
A788  4C 43 AE  JMP $ae43
A78B  A9 BC     LDA #$bc
A78D  A0 B9     LDY #$b9
A78F  20 A2 BB  JSR $bba2
A792  20 79 00  JSR $0079
A795  C9 A9     CMP #$a9
A797  D0 06     BNE $a79f
A799  20 73 00  JSR $0073
A79C  20 8A AD  JSR $ad8a
A79F  20 2B BC  JSR $bc2b
A7A2  20 38 AE  JSR $ae38
A7A5  A5 4A     LDA $4a
A7A7  48        PHA
A7A8  A5 49     LDA $49
A7AA  48        PHA
A7AB  A9 81     LDA #$81
A7AD  48        PHA
A7AE  20 2C A8  JSR $a82c
A7B1  A5 7A     LDA $7a
A7B3  A4 7B     LDY $7b
A7B5  C0 02     CPY #$02
A7B7  EA        NOP
A7B8  F0 04     BEQ $a7be
A7BA  85 3D     STA $3d
A7BC  84 3E     STY $3e
A7BE  A0 00     LDY #$00
A7C0  B1 7A     LDA ($7a),Y
A7C2  D0 43     BNE $a807
A7C4  A0 02     LDY #$02
A7C6  B1 7A     LDA ($7a),Y
A7C8  18        CLC
A7C9  D0 03     BNE $a7ce
A7CB  4C 4B A8  JMP $a84b
A7CE  C8        INY
A7CF  B1 7A     LDA ($7a),Y
A7D1  85 39     STA $39
A7D3  C8        INY
A7D4  B1 7A     LDA ($7a),Y
A7D6  85 3A     STA $3a
A7D8  98        TYA
A7D9  65 7A     ADC $7a
A7DB  85 7A     STA $7a
A7DD  90 02     BCC $a7e1
A7DF  E6 7B     INC $7b
A7E1  6C 08 03  JMP ($0308)
A7E4  20 73 00  JSR $0073
A7E7  20 ED A7  JSR $a7ed
A7EA  4C AE A7  JMP $a7ae
A7ED  F0 3C     BEQ $a82b
A7EF  E9 80     SBC #$80
A7F1  90 11     BCC $a804
A7F3  C9 23     CMP #$23
A7F5  B0 17     BCS $a80e
A7F7  0A        ASL A
A7F8  A8        TAY
A7F9  B9 0D A0  LDA $a00d,Y
A7FC  48        PHA
A7FD  B9 0C A0  LDA $a00c,Y
A800  48        PHA
A801  4C 73 00  JMP $0073
A804  4C A5 A9  JMP $a9a5
A807  C9 3A     CMP #$3a
A809  F0 D6     BEQ $a7e1
A80B  4C 08 AF  JMP $af08
A80E  C9 4B     CMP #$4b
A810  D0 F9     BNE $a80b
A812  20 73 00  JSR $0073
A815  A9 A4     LDA #$a4
A817  20 FF AE  JSR $aeff
A81A  4C A0 A8  JMP $a8a0
A81D  38        SEC
A81E  A5 2B     LDA $2b
A820  E9 01     SBC #$01
A822  A4 2C     LDY $2c
A824  B0 01     BCS $a827
A826  88        DEY
A827  85 41     STA $41
A829  84 42     STY $42
A82B  60        RTS
A82C  20 E1 FF  JSR $ffe1
A82F  B0 01     BCS $a832
A831  18        CLC
A832  D0 3C     BNE $a870
A834  A5 7A     LDA $7a
A836  A4 7B     LDY $7b
A838  A6 3A     LDX $3a
A83A  E8        INX
A83B  F0 0C     BEQ $a849
A83D  85 3D     STA $3d
A83F  84 3E     STY $3e
A841  A5 39     LDA $39
A843  A4 3A     LDY $3a
A845  85 3B     STA $3b
A847  84 3C     STY $3c
A849  68        PLA
A84A  68        PLA
A84B  A9 81     LDA #$81
A84D  A0 A3     LDY #$a3
A84F  90 03     BCC $a854
A851  4C 69 A4  JMP $a469
A854  4C 86 E3  JMP $e386
A857  D0 17     BNE $a870
A859  A2 1A     LDX #$1a
A85B  A4 3E     LDY $3e
A85D  D0 03     BNE $a862
A85F  4C 37 A4  JMP $a437
A862  A5 3D     LDA $3d
A864  85 7A     STA $7a
A866  84 7B     STY $7b
A868  A5 3B     LDA $3b
A86A  A4 3C     LDY $3c
A86C  85 39     STA $39
A86E  84 3A     STY $3a
A870  60        RTS
A871  08        PHP
A872  A9 00     LDA #$00
A874  20 90 FF  JSR $ff90
A877  28        PLP
A878  D0 03     BNE $a87d
A87A  4C 59 A6  JMP $a659
A87D  20 60 A6  JSR $a660
A880  4C 97 A8  JMP $a897
A883  A9 03     LDA #$03
A885  20 FB A3  JSR $a3fb
A888  A5 7B     LDA $7b
A88A  48        PHA
A88B  A5 7A     LDA $7a
A88D  48        PHA
A88E  A5 3A     LDA $3a
A890  48        PHA
A891  A5 39     LDA $39
A893  48        PHA
A894  A9 8D     LDA #$8d
A896  48        PHA
A897  20 79 00  JSR $0079
A89A  20 A0 A8  JSR $a8a0
A89D  4C AE A7  JMP $a7ae
A8A0  20 6B A9  JSR $a96b
A8A3  20 09 A9  JSR $a909
A8A6  38        SEC
A8A7  A5 39     LDA $39
A8A9  E5 14     SBC $14
A8AB  A5 3A     LDA $3a
A8AD  E5 15     SBC $15
A8AF  B0 0B     BCS $a8bc
A8B1  98        TYA
A8B2  38        SEC
A8B3  65 7A     ADC $7a
A8B5  A6 7B     LDX $7b
A8B7  90 07     BCC $a8c0
A8B9  E8        INX
A8BA  B0 04     BCS $a8c0
A8BC  A5 2B     LDA $2b
A8BE  A6 2C     LDX $2c
A8C0  20 17 A6  JSR $a617
A8C3  90 1E     BCC $a8e3
A8C5  A5 5F     LDA $5f
A8C7  E9 01     SBC #$01
A8C9  85 7A     STA $7a
A8CB  A5 60     LDA $60
A8CD  E9 00     SBC #$00
A8CF  85 7B     STA $7b
A8D1  60        RTS
A8D2  D0 FD     BNE $a8d1
A8D4  A9 FF     LDA #$ff
A8D6  85 4A     STA $4a
A8D8  20 8A A3  JSR $a38a
A8DB  9A        TXS
A8DC  C9 8D     CMP #$8d
A8DE  F0 0B     BEQ $a8eb
A8E0  A2 0C     LDX #$0c
A8E2  2C A2 11  BIT $11a2
A8E5  4C 37 A4  JMP $a437
A8E8  4C 08 AF  JMP $af08
A8EB  68        PLA
A8EC  68        PLA
A8ED  85 39     STA $39
A8EF  68        PLA
A8F0  85 3A     STA $3a
A8F2  68        PLA
A8F3  85 7A     STA $7a
A8F5  68        PLA
A8F6  85 7B     STA $7b
A8F8  20 06 A9  JSR $a906
A8FB  98        TYA
A8FC  18        CLC
A8FD  65 7A     ADC $7a
A8FF  85 7A     STA $7a
A901  90 02     BCC $a905
A903  E6 7B     INC $7b
A905  60        RTS
A906  A2 3A     LDX #$3a
A908  2C A2 00  BIT $00a2
A90B  86 07     STX $07
A90D  A0 00     LDY #$00
A90F  84 08     STY $08
A911  A5 08     LDA $08
A913  A6 07     LDX $07
A915  85 07     STA $07
A917  86 08     STX $08
A919  B1 7A     LDA ($7a),Y
A91B  F0 E8     BEQ $a905
A91D  C5 08     CMP $08
A91F  F0 E4     BEQ $a905
A921  C8        INY
A922  C9 22     CMP #$22
A924  D0 F3     BNE $a919
A926  F0 E9     BEQ $a911
A928  20 9E AD  JSR $ad9e
A92B  20 79 00  JSR $0079
A92E  C9 89     CMP #$89
A930  F0 05     BEQ $a937
A932  A9 A7     LDA #$a7
A934  20 FF AE  JSR $aeff
A937  A5 61     LDA $61
A939  D0 05     BNE $a940
A93B  20 09 A9  JSR $a909
A93E  F0 BB     BEQ $a8fb
A940  20 79 00  JSR $0079
A943  B0 03     BCS $a948
A945  4C A0 A8  JMP $a8a0
A948  4C ED A7  JMP $a7ed
A94B  20 9E B7  JSR $b79e
A94E  48        PHA
A94F  C9 8D     CMP #$8d
A951  F0 04     BEQ $a957
A953  C9 89     CMP #$89
A955  D0 91     BNE $a8e8
A957  C6 65     DEC $65
A959  D0 04     BNE $a95f
A95B  68        PLA
A95C  4C EF A7  JMP $a7ef
A95F  20 73 00  JSR $0073
A962  20 6B A9  JSR $a96b
A965  C9 2C     CMP #$2c
A967  F0 EE     BEQ $a957
A969  68        PLA
A96A  60        RTS
A96B  A2 00     LDX #$00
A96D  86 14     STX $14
A96F  86 15     STX $15
A971  B0 F7     BCS $a96a
A973  E9 2F     SBC #$2f
A975  85 07     STA $07
A977  A5 15     LDA $15
A979  85 22     STA $22
A97B  C9 19     CMP #$19
A97D  B0 D4     BCS $a953
A97F  A5 14     LDA $14
A981  0A        ASL A
A982  26 22     ROL $22
A984  0A        ASL A
A985  26 22     ROL $22
A987  65 14     ADC $14
A989  85 14     STA $14
A98B  A5 22     LDA $22
A98D  65 15     ADC $15
A98F  85 15     STA $15
A991  06 14     ASL $14
A993  26 15     ROL $15
A995  A5 14     LDA $14
A997  65 07     ADC $07
A999  85 14     STA $14
A99B  90 02     BCC $a99f
A99D  E6 15     INC $15
A99F  20 73 00  JSR $0073
A9A2  4C 71 A9  JMP $a971
A9A5  20 8B B0  JSR $b08b
A9A8  85 49     STA $49
A9AA  84 4A     STY $4a
A9AC  A9 B2     LDA #$b2
A9AE  20 FF AE  JSR $aeff
A9B1  A5 0E     LDA $0e
A9B3  48        PHA
A9B4  A5 0D     LDA $0d
A9B6  48        PHA
A9B7  20 9E AD  JSR $ad9e
A9BA  68        PLA
A9BB  2A        ROL A
A9BC  20 90 AD  JSR $ad90
A9BF  D0 18     BNE $a9d9
A9C1  68        PLA
A9C2  10 12     BPL $a9d6
A9C4  20 1B BC  JSR $bc1b
A9C7  20 BF B1  JSR $b1bf
A9CA  A0 00     LDY #$00
A9CC  A5 64     LDA $64
A9CE  91 49     STA ($49),Y
A9D0  C8        INY
A9D1  A5 65     LDA $65
A9D3  91 49     STA ($49),Y
A9D5  60        RTS
A9D6  4C D0 BB  JMP $bbd0
A9D9  68        PLA
A9DA  A4 4A     LDY $4a
A9DC  C0 BF     CPY #$bf
A9DE  D0 4C     BNE $aa2c
A9E0  20 A6 B6  JSR $b6a6
A9E3  C9 06     CMP #$06
A9E5  D0 3D     BNE $aa24
A9E7  A0 00     LDY #$00
A9E9  84 61     STY $61
A9EB  84 66     STY $66
A9ED  84 71     STY $71
A9EF  20 1D AA  JSR $aa1d
A9F2  20 E2 BA  JSR $bae2
A9F5  E6 71     INC $71
A9F7  A4 71     LDY $71
A9F9  20 1D AA  JSR $aa1d
A9FC  20 0C BC  JSR $bc0c
A9FF  AA        TAX
AA00  F0 05     BEQ $aa07
AA02  E8        INX
AA03  8A        TXA
AA04  20 ED BA  JSR $baed
AA07  A4 71     LDY $71
AA09  C8        INY
AA0A  C0 06     CPY #$06
AA0C  D0 DF     BNE $a9ed
AA0E  20 E2 BA  JSR $bae2
AA11  20 9B BC  JSR $bc9b
AA14  A6 64     LDX $64
AA16  A4 63     LDY $63
AA18  A5 65     LDA $65
AA1A  4C DB FF  JMP $ffdb
AA1D  B1 22     LDA ($22),Y
AA1F  20 80 00  JSR $0080
AA22  90 03     BCC $aa27
AA24  4C 48 B2  JMP $b248
AA27  E9 2F     SBC #$2f
AA29  4C 7E BD  JMP $bd7e
AA2C  A0 02     LDY #$02
AA2E  B1 64     LDA ($64),Y
AA30  C5 34     CMP $34
AA32  90 17     BCC $aa4b
AA34  D0 07     BNE $aa3d
AA36  88        DEY
AA37  B1 64     LDA ($64),Y
AA39  C5 33     CMP $33
AA3B  90 0E     BCC $aa4b
AA3D  A4 65     LDY $65
AA3F  C4 2E     CPY $2e
AA41  90 08     BCC $aa4b
AA43  D0 0D     BNE $aa52
AA45  A5 64     LDA $64
AA47  C5 2D     CMP $2d
AA49  B0 07     BCS $aa52
AA4B  A5 64     LDA $64
AA4D  A4 65     LDY $65
AA4F  4C 68 AA  JMP $aa68
AA52  A0 00     LDY #$00
AA54  B1 64     LDA ($64),Y
AA56  20 75 B4  JSR $b475
AA59  A5 50     LDA $50
AA5B  A4 51     LDY $51
AA5D  85 6F     STA $6f
AA5F  84 70     STY $70
AA61  20 7A B6  JSR $b67a
AA64  A9 61     LDA #$61
AA66  A0 00     LDY #$00
AA68  85 50     STA $50
AA6A  84 51     STY $51
AA6C  20 DB B6  JSR $b6db
AA6F  A0 00     LDY #$00
AA71  B1 50     LDA ($50),Y
AA73  91 49     STA ($49),Y
AA75  C8        INY
AA76  B1 50     LDA ($50),Y
AA78  91 49     STA ($49),Y
AA7A  C8        INY
AA7B  B1 50     LDA ($50),Y
AA7D  91 49     STA ($49),Y
AA7F  60        RTS
AA80  20 86 AA  JSR $aa86
AA83  4C B5 AB  JMP $abb5
AA86  20 9E B7  JSR $b79e
AA89  F0 05     BEQ $aa90
AA8B  A9 2C     LDA #$2c
AA8D  20 FF AE  JSR $aeff
AA90  08        PHP
AA91  86 13     STX $13
AA93  20 18 E1  JSR $e118
AA96  28        PLP
AA97  4C A0 AA  JMP $aaa0
AA9A  20 21 AB  JSR $ab21
AA9D  20 79 00  JSR $0079
AAA0  F0 35     BEQ $aad7
AAA2  F0 43     BEQ $aae7
AAA4  C9 A3     CMP #$a3
AAA6  F0 50     BEQ $aaf8
AAA8  C9 A6     CMP #$a6
AAAA  18        CLC
AAAB  F0 4B     BEQ $aaf8
AAAD  C9 2C     CMP #$2c
AAAF  F0 37     BEQ $aae8
AAB1  C9 3B     CMP #$3b
AAB3  F0 5E     BEQ $ab13
AAB5  20 9E AD  JSR $ad9e
AAB8  24 0D     BIT $0d
AABA  30 DE     BMI $aa9a
AABC  20 DD BD  JSR $bddd
AABF  20 87 B4  JSR $b487
AAC2  20 21 AB  JSR $ab21
AAC5  20 3B AB  JSR $ab3b
AAC8  D0 D3     BNE $aa9d
AACA  A9 00     LDA #$00
AACC  9D 00 02  STA $0200,X
AACF  A2 FF     LDX #$ff
AAD1  A0 01     LDY #$01
AAD3  A5 13     LDA $13
AAD5  D0 10     BNE $aae7
AAD7  A9 0D     LDA #$0d
AAD9  20 47 AB  JSR $ab47
AADC  24 13     BIT $13
AADE  10 05     BPL $aae5
AAE0  A9 0A     LDA #$0a
AAE2  20 47 AB  JSR $ab47
AAE5  49 FF     EOR #$ff
AAE7  60        RTS
AAE8  38        SEC
AAE9  20 F0 FF  JSR $fff0
AAEC  98        TYA
AAED  38        SEC
AAEE  E9 0A     SBC #$0a
AAF0  B0 FC     BCS $aaee
AAF2  49 FF     EOR #$ff
AAF4  69 01     ADC #$01
AAF6  D0 16     BNE $ab0e
AAF8  08        PHP
AAF9  38        SEC
AAFA  20 F0 FF  JSR $fff0
AAFD  84 09     STY $09
AAFF  20 9B B7  JSR $b79b
AB02  C9 29     CMP #$29
AB04  D0 59     BNE $ab5f
AB06  28        PLP
AB07  90 06     BCC $ab0f
AB09  8A        TXA
AB0A  E5 09     SBC $09
AB0C  90 05     BCC $ab13
AB0E  AA        TAX
AB0F  E8        INX
AB10  CA        DEX
AB11  D0 06     BNE $ab19
AB13  20 73 00  JSR $0073
AB16  4C A2 AA  JMP $aaa2
AB19  20 3B AB  JSR $ab3b
AB1C  D0 F2     BNE $ab10
AB1E  20 87 B4  JSR $b487
AB21  20 A6 B6  JSR $b6a6
AB24  AA        TAX
AB25  A0 00     LDY #$00
AB27  E8        INX
AB28  CA        DEX
AB29  F0 BC     BEQ $aae7
AB2B  B1 22     LDA ($22),Y
AB2D  20 47 AB  JSR $ab47
AB30  C8        INY
AB31  C9 0D     CMP #$0d
AB33  D0 F3     BNE $ab28
AB35  20 E5 AA  JSR $aae5
AB38  4C 28 AB  JMP $ab28
AB3B  A5 13     LDA $13
AB3D  F0 03     BEQ $ab42
AB3F  A9 20     LDA #$20
AB41  2C A9 1D  BIT $1da9
AB44  2C A9 3F  BIT $3fa9
AB47  20 0C E1  JSR $e10c
AB4A  29 FF     AND #$ff
AB4C  60        RTS
AB4D  A5 11     LDA $11
AB4F  F0 11     BEQ $ab62
AB51  30 04     BMI $ab57
AB53  A0 FF     LDY #$ff
AB55  D0 04     BNE $ab5b
AB57  A5 3F     LDA $3f
AB59  A4 40     LDY $40
AB5B  85 39     STA $39
AB5D  84 3A     STY $3a
AB5F  4C 08 AF  JMP $af08
AB62  A5 13     LDA $13
AB64  F0 05     BEQ $ab6b
AB66  A2 18     LDX #$18
AB68  4C 37 A4  JMP $a437
AB6B  A9 0C     LDA #$0c
AB6D  A0 AD     LDY #$ad
AB6F  20 1E AB  JSR $ab1e
AB72  A5 3D     LDA $3d
AB74  A4 3E     LDY $3e
AB76  85 7A     STA $7a
AB78  84 7B     STY $7b
AB7A  60        RTS
AB7B  20 A6 B3  JSR $b3a6
AB7E  C9 23     CMP #$23
AB80  D0 10     BNE $ab92
AB82  20 73 00  JSR $0073
AB85  20 9E B7  JSR $b79e
AB88  A9 2C     LDA #$2c
AB8A  20 FF AE  JSR $aeff
AB8D  86 13     STX $13
AB8F  20 1E E1  JSR $e11e
AB92  A2 01     LDX #$01
AB94  A0 02     LDY #$02
AB96  A9 00     LDA #$00
AB98  8D 01 02  STA $0201
AB9B  A9 40     LDA #$40
AB9D  20 0F AC  JSR $ac0f
ABA0  A6 13     LDX $13
ABA2  D0 13     BNE $abb7
ABA4  60        RTS
ABA5  20 9E B7  JSR $b79e
ABA8  A9 2C     LDA #$2c
ABAA  20 FF AE  JSR $aeff
ABAD  86 13     STX $13
ABAF  20 1E E1  JSR $e11e
ABB2  20 CE AB  JSR $abce
ABB5  A5 13     LDA $13
ABB7  20 CC FF  JSR $ffcc
ABBA  A2 00     LDX #$00
ABBC  86 13     STX $13
ABBE  60        RTS
ABBF  C9 22     CMP #$22
ABC1  D0 0B     BNE $abce
ABC3  20 BD AE  JSR $aebd
ABC6  A9 3B     LDA #$3b
ABC8  20 FF AE  JSR $aeff
ABCB  20 21 AB  JSR $ab21
ABCE  20 A6 B3  JSR $b3a6
ABD1  A9 2C     LDA #$2c
ABD3  8D FF 01  STA $01ff
ABD6  20 F9 AB  JSR $abf9
ABD9  A5 13     LDA $13
ABDB  F0 0D     BEQ $abea
ABDD  20 B7 FF  JSR $ffb7
ABE0  29 02     AND #$02
ABE2  F0 06     BEQ $abea
ABE4  20 B5 AB  JSR $abb5
ABE7  4C F8 A8  JMP $a8f8
ABEA  AD 00 02  LDA $0200
ABED  D0 1E     BNE $ac0d
ABEF  A5 13     LDA $13
ABF1  D0 E3     BNE $abd6
ABF3  20 06 A9  JSR $a906
ABF6  4C FB A8  JMP $a8fb
ABF9  A5 13     LDA $13
ABFB  D0 06     BNE $ac03
ABFD  20 45 AB  JSR $ab45
AC00  20 3B AB  JSR $ab3b
AC03  4C 60 A5  JMP $a560
AC06  A6 41     LDX $41
AC08  A4 42     LDY $42
AC0A  A9 98     LDA #$98
AC0C  2C A9 00  BIT $00a9
AC0F  85 11     STA $11
AC11  86 43     STX $43
AC13  84 44     STY $44
AC15  20 8B B0  JSR $b08b
AC18  85 49     STA $49
AC1A  84 4A     STY $4a
AC1C  A5 7A     LDA $7a
AC1E  A4 7B     LDY $7b
AC20  85 4B     STA $4b
AC22  84 4C     STY $4c
AC24  A6 43     LDX $43
AC26  A4 44     LDY $44
AC28  86 7A     STX $7a
AC2A  84 7B     STY $7b
AC2C  20 79 00  JSR $0079
AC2F  D0 20     BNE $ac51
AC31  24 11     BIT $11
AC33  50 0C     BVC $ac41
AC35  20 24 E1  JSR $e124
AC38  8D 00 02  STA $0200
AC3B  A2 FF     LDX #$ff
AC3D  A0 01     LDY #$01
AC3F  D0 0C     BNE $ac4d
AC41  30 75     BMI $acb8
AC43  A5 13     LDA $13
AC45  D0 03     BNE $ac4a
AC47  20 45 AB  JSR $ab45
AC4A  20 F9 AB  JSR $abf9
AC4D  86 7A     STX $7a
AC4F  84 7B     STY $7b
AC51  20 73 00  JSR $0073
AC54  24 0D     BIT $0d
AC56  10 31     BPL $ac89
AC58  24 11     BIT $11
AC5A  50 09     BVC $ac65
AC5C  E8        INX
AC5D  86 7A     STX $7a
AC5F  A9 00     LDA #$00
AC61  85 07     STA $07
AC63  F0 0C     BEQ $ac71
AC65  85 07     STA $07
AC67  C9 22     CMP #$22
AC69  F0 07     BEQ $ac72
AC6B  A9 3A     LDA #$3a
AC6D  85 07     STA $07
AC6F  A9 2C     LDA #$2c
AC71  18        CLC
AC72  85 08     STA $08
AC74  A5 7A     LDA $7a
AC76  A4 7B     LDY $7b
AC78  69 00     ADC #$00
AC7A  90 01     BCC $ac7d
AC7C  C8        INY
AC7D  20 8D B4  JSR $b48d
AC80  20 E2 B7  JSR $b7e2
AC83  20 DA A9  JSR $a9da
AC86  4C 91 AC  JMP $ac91
AC89  20 F3 BC  JSR $bcf3
AC8C  A5 0E     LDA $0e
AC8E  20 C2 A9  JSR $a9c2
AC91  20 79 00  JSR $0079
AC94  F0 07     BEQ $ac9d
AC96  C9 2C     CMP #$2c
AC98  F0 03     BEQ $ac9d
AC9A  4C 4D AB  JMP $ab4d
AC9D  A5 7A     LDA $7a
AC9F  A4 7B     LDY $7b
ACA1  85 43     STA $43
ACA3  84 44     STY $44
ACA5  A5 4B     LDA $4b
ACA7  A4 4C     LDY $4c
ACA9  85 7A     STA $7a
ACAB  84 7B     STY $7b
ACAD  20 79 00  JSR $0079
ACB0  F0 2D     BEQ $acdf
ACB2  20 FD AE  JSR $aefd
ACB5  4C 15 AC  JMP $ac15
ACB8  20 06 A9  JSR $a906
ACBB  C8        INY
ACBC  AA        TAX
ACBD  D0 12     BNE $acd1
ACBF  A2 0D     LDX #$0d
ACC1  C8        INY
ACC2  B1 7A     LDA ($7a),Y
ACC4  F0 6C     BEQ $ad32
ACC6  C8        INY
ACC7  B1 7A     LDA ($7a),Y
ACC9  85 3F     STA $3f
ACCB  C8        INY
ACCC  B1 7A     LDA ($7a),Y
ACCE  C8        INY
ACCF  85 40     STA $40
ACD1  20 FB A8  JSR $a8fb
ACD4  20 79 00  JSR $0079
ACD7  AA        TAX
ACD8  E0 83     CPX #$83
ACDA  D0 DC     BNE $acb8
ACDC  4C 51 AC  JMP $ac51
ACDF  A5 43     LDA $43
ACE1  A4 44     LDY $44
ACE3  A6 11     LDX $11
ACE5  10 03     BPL $acea
ACE7  4C 27 A8  JMP $a827
ACEA  A0 00     LDY #$00
ACEC  B1 43     LDA ($43),Y
ACEE  F0 0B     BEQ $acfb
ACF0  A5 13     LDA $13
ACF2  D0 07     BNE $acfb
ACF4  A9 FC     LDA #$fc
ACF6  A0 AC     LDY #$ac
ACF8  4C 1E AB  JMP $ab1e
ACFB  60        RTS
ACFC  3F        ???
ACFD  45 58     EOR $58
ACFF  54        ???
AD00  52        ???
AD01  41 20     EOR ($20,X)
AD03  49 47     EOR #$47
AD05  4E 4F 52  LSR $524f
AD08  45 44     EOR $44
AD0A  0D 00 3F  ORA $3f00
AD0D  52        ???
AD0E  45 44     EOR $44
AD10  4F        ???
AD11  20 46 52  JSR $5246
AD14  4F        ???
AD15  4D 20 53  EOR $5320
AD18  54        ???
AD19  41 52     EOR ($52,X)
AD1B  54        ???
AD1C  0D 00 D0  ORA $d000
AD1F  04        ???
AD20  A0 00     LDY #$00
AD22  F0 03     BEQ $ad27
AD24  20 8B B0  JSR $b08b
AD27  85 49     STA $49
AD29  84 4A     STY $4a
AD2B  20 8A A3  JSR $a38a
AD2E  F0 05     BEQ $ad35
AD30  A2 0A     LDX #$0a
AD32  4C 37 A4  JMP $a437
AD35  9A        TXS
AD36  8A        TXA
AD37  18        CLC
AD38  69 04     ADC #$04
AD3A  48        PHA
AD3B  69 06     ADC #$06
AD3D  85 24     STA $24
AD3F  68        PLA
AD40  A0 01     LDY #$01
AD42  20 A2 BB  JSR $bba2
AD45  BA        TSX
AD46  BD 09 01  LDA $0109,X
AD49  85 66     STA $66
AD4B  A5 49     LDA $49
AD4D  A4 4A     LDY $4a
AD4F  20 67 B8  JSR $b867
AD52  20 D0 BB  JSR $bbd0
AD55  A0 01     LDY #$01
AD57  20 5D BC  JSR $bc5d
AD5A  BA        TSX
AD5B  38        SEC
AD5C  FD 09 01  SBC $0109,X
AD5F  F0 17     BEQ $ad78
AD61  BD 0F 01  LDA $010f,X
AD64  85 39     STA $39
AD66  BD 10 01  LDA $0110,X
AD69  85 3A     STA $3a
AD6B  BD 12 01  LDA $0112,X
AD6E  85 7A     STA $7a
AD70  BD 11 01  LDA $0111,X
AD73  85 7B     STA $7b
AD75  4C AE A7  JMP $a7ae
AD78  8A        TXA
AD79  69 11     ADC #$11
AD7B  AA        TAX
AD7C  9A        TXS
AD7D  20 79 00  JSR $0079
AD80  C9 2C     CMP #$2c
AD82  D0 F1     BNE $ad75
AD84  20 73 00  JSR $0073
AD87  20 24 AD  JSR $ad24
AD8A  20 9E AD  JSR $ad9e
AD8D  18        CLC
AD8E  24 38     BIT $38
AD90  24 0D     BIT $0d
AD92  30 03     BMI $ad97
AD94  B0 03     BCS $ad99
AD96  60        RTS
AD97  B0 FD     BCS $ad96
AD99  A2 16     LDX #$16
AD9B  4C 37 A4  JMP $a437
AD9E  A6 7A     LDX $7a
ADA0  D0 02     BNE $ada4
ADA2  C6 7B     DEC $7b
ADA4  C6 7A     DEC $7a
ADA6  A2 00     LDX #$00
ADA8  24 48     BIT $48
ADAA  8A        TXA
ADAB  48        PHA
ADAC  A9 01     LDA #$01
ADAE  20 FB A3  JSR $a3fb
ADB1  20 83 AE  JSR $ae83
ADB4  A9 00     LDA #$00
ADB6  85 4D     STA $4d
ADB8  20 79 00  JSR $0079
ADBB  38        SEC
ADBC  E9 B1     SBC #$b1
ADBE  90 17     BCC $add7
ADC0  C9 03     CMP #$03
ADC2  B0 13     BCS $add7
ADC4  C9 01     CMP #$01
ADC6  2A        ROL A
ADC7  49 01     EOR #$01
ADC9  45 4D     EOR $4d
ADCB  C5 4D     CMP $4d
ADCD  90 61     BCC $ae30
ADCF  85 4D     STA $4d
ADD1  20 73 00  JSR $0073
ADD4  4C BB AD  JMP $adbb
ADD7  A6 4D     LDX $4d
ADD9  D0 2C     BNE $ae07
ADDB  B0 7B     BCS $ae58
ADDD  69 07     ADC #$07
ADDF  90 77     BCC $ae58
ADE1  65 0D     ADC $0d
ADE3  D0 03     BNE $ade8
ADE5  4C 3D B6  JMP $b63d
ADE8  69 FF     ADC #$ff
ADEA  85 22     STA $22
ADEC  0A        ASL A
ADED  65 22     ADC $22
ADEF  A8        TAY
ADF0  68        PLA
ADF1  D9 80 A0  CMP $a080,Y
ADF4  B0 67     BCS $ae5d
ADF6  20 8D AD  JSR $ad8d
ADF9  48        PHA
ADFA  20 20 AE  JSR $ae20
ADFD  68        PLA
ADFE  A4 4B     LDY $4b
AE00  10 17     BPL $ae19
AE02  AA        TAX
AE03  F0 56     BEQ $ae5b
AE05  D0 5F     BNE $ae66
AE07  46 0D     LSR $0d
AE09  8A        TXA
AE0A  2A        ROL A
AE0B  A6 7A     LDX $7a
AE0D  D0 02     BNE $ae11
AE0F  C6 7B     DEC $7b
AE11  C6 7A     DEC $7a
AE13  A0 1B     LDY #$1b
AE15  85 4D     STA $4d
AE17  D0 D7     BNE $adf0
AE19  D9 80 A0  CMP $a080,Y
AE1C  B0 48     BCS $ae66
AE1E  90 D9     BCC $adf9
AE20  B9 82 A0  LDA $a082,Y
AE23  48        PHA
AE24  B9 81 A0  LDA $a081,Y
AE27  48        PHA
AE28  20 33 AE  JSR $ae33
AE2B  A5 4D     LDA $4d
AE2D  4C A9 AD  JMP $ada9
AE30  4C 08 AF  JMP $af08
AE33  A5 66     LDA $66
AE35  BE 80 A0  LDX $a080,Y
AE38  A8        TAY
AE39  68        PLA
AE3A  85 22     STA $22
AE3C  E6 22     INC $22
AE3E  68        PLA
AE3F  85 23     STA $23
AE41  98        TYA
AE42  48        PHA
AE43  20 1B BC  JSR $bc1b
AE46  A5 65     LDA $65
AE48  48        PHA
AE49  A5 64     LDA $64
AE4B  48        PHA
AE4C  A5 63     LDA $63
AE4E  48        PHA
AE4F  A5 62     LDA $62
AE51  48        PHA
AE52  A5 61     LDA $61
AE54  48        PHA
AE55  6C 22 00  JMP ($0022)
AE58  A0 FF     LDY #$ff
AE5A  68        PLA
AE5B  F0 23     BEQ $ae80
AE5D  C9 64     CMP #$64
AE5F  F0 03     BEQ $ae64
AE61  20 8D AD  JSR $ad8d
AE64  84 4B     STY $4b
AE66  68        PLA
AE67  4A        LSR A
AE68  85 12     STA $12
AE6A  68        PLA
AE6B  85 69     STA $69
AE6D  68        PLA
AE6E  85 6A     STA $6a
AE70  68        PLA
AE71  85 6B     STA $6b
AE73  68        PLA
AE74  85 6C     STA $6c
AE76  68        PLA
AE77  85 6D     STA $6d
AE79  68        PLA
AE7A  85 6E     STA $6e
AE7C  45 66     EOR $66
AE7E  85 6F     STA $6f
AE80  A5 61     LDA $61
AE82  60        RTS
AE83  6C 0A 03  JMP ($030a)
AE86  A9 00     LDA #$00
AE88  85 0D     STA $0d
AE8A  20 73 00  JSR $0073
AE8D  B0 03     BCS $ae92
AE8F  4C F3 BC  JMP $bcf3
AE92  20 13 B1  JSR $b113
AE95  90 03     BCC $ae9a
AE97  4C 28 AF  JMP $af28
AE9A  C9 FF     CMP #$ff
AE9C  D0 0F     BNE $aead
AE9E  A9 A8     LDA #$a8
AEA0  A0 AE     LDY #$ae
AEA2  20 A2 BB  JSR $bba2
AEA5  4C 73 00  JMP $0073
AEA8  82        ???
AEA9  49 0F     EOR #$0f
AEAB  DA        ???
AEAC  A1 C9     LDA ($c9,X)
AEAE  2E F0 DE  ROL $def0
AEB1  C9 AB     CMP #$ab
AEB3  F0 58     BEQ $af0d
AEB5  C9 AA     CMP #$aa
AEB7  F0 D1     BEQ $ae8a
AEB9  C9 22     CMP #$22
AEBB  D0 0F     BNE $aecc
AEBD  A5 7A     LDA $7a
AEBF  A4 7B     LDY $7b
AEC1  69 00     ADC #$00
AEC3  90 01     BCC $aec6
AEC5  C8        INY
AEC6  20 87 B4  JSR $b487
AEC9  4C E2 B7  JMP $b7e2
AECC  C9 A8     CMP #$a8
AECE  D0 13     BNE $aee3
AED0  A0 18     LDY #$18
AED2  D0 3B     BNE $af0f
AED4  20 BF B1  JSR $b1bf
AED7  A5 65     LDA $65
AED9  49 FF     EOR #$ff
AEDB  A8        TAY
AEDC  A5 64     LDA $64
AEDE  49 FF     EOR #$ff
AEE0  4C 91 B3  JMP $b391
AEE3  C9 A5     CMP #$a5
AEE5  D0 03     BNE $aeea
AEE7  4C F4 B3  JMP $b3f4
AEEA  C9 B4     CMP #$b4
AEEC  90 03     BCC $aef1
AEEE  4C A7 AF  JMP $afa7
AEF1  20 FA AE  JSR $aefa
AEF4  20 9E AD  JSR $ad9e
AEF7  A9 29     LDA #$29
AEF9  2C A9 28  BIT $28a9
AEFC  2C A9 2C  BIT $2ca9
AEFF  A0 00     LDY #$00
AF01  D1 7A     CMP ($7a),Y
AF03  D0 03     BNE $af08
AF05  4C 73 00  JMP $0073
AF08  A2 0B     LDX #$0b
AF0A  4C 37 A4  JMP $a437
AF0D  A0 15     LDY #$15
AF0F  68        PLA
AF10  68        PLA
AF11  4C FA AD  JMP $adfa
AF14  38        SEC
AF15  A5 64     LDA $64
AF17  E9 00     SBC #$00
AF19  A5 65     LDA $65
AF1B  E9 A0     SBC #$a0
AF1D  90 08     BCC $af27
AF1F  A9 A2     LDA #$a2
AF21  E5 64     SBC $64
AF23  A9 E3     LDA #$e3
AF25  E5 65     SBC $65
AF27  60        RTS
AF28  20 8B B0  JSR $b08b
AF2B  85 64     STA $64
AF2D  84 65     STY $65
AF2F  A6 45     LDX $45
AF31  A4 46     LDY $46
AF33  A5 0D     LDA $0d
AF35  F0 26     BEQ $af5d
AF37  A9 00     LDA #$00
AF39  85 70     STA $70
AF3B  20 14 AF  JSR $af14
AF3E  90 1C     BCC $af5c
AF40  E0 54     CPX #$54
AF42  D0 18     BNE $af5c
AF44  C0 C9     CPY #$c9
AF46  D0 14     BNE $af5c
AF48  20 84 AF  JSR $af84
AF4B  84 5E     STY $5e
AF4D  88        DEY
AF4E  84 71     STY $71
AF50  A0 06     LDY #$06
AF52  84 5D     STY $5d
AF54  A0 24     LDY #$24
AF56  20 68 BE  JSR $be68
AF59  4C 6F B4  JMP $b46f
AF5C  60        RTS
AF5D  24 0E     BIT $0e
AF5F  10 0D     BPL $af6e
AF61  A0 00     LDY #$00
AF63  B1 64     LDA ($64),Y
AF65  AA        TAX
AF66  C8        INY
AF67  B1 64     LDA ($64),Y
AF69  A8        TAY
AF6A  8A        TXA
AF6B  4C 91 B3  JMP $b391
AF6E  20 14 AF  JSR $af14
AF71  90 2D     BCC $afa0
AF73  E0 54     CPX #$54
AF75  D0 1B     BNE $af92
AF77  C0 49     CPY #$49
AF79  D0 25     BNE $afa0
AF7B  20 84 AF  JSR $af84
AF7E  98        TYA
AF7F  A2 A0     LDX #$a0
AF81  4C 4F BC  JMP $bc4f
AF84  20 DE FF  JSR $ffde
AF87  86 64     STX $64
AF89  84 63     STY $63
AF8B  85 65     STA $65
AF8D  A0 00     LDY #$00
AF8F  84 62     STY $62
AF91  60        RTS
AF92  E0 53     CPX #$53
AF94  D0 0A     BNE $afa0
AF96  C0 54     CPY #$54
AF98  D0 06     BNE $afa0
AF9A  20 B7 FF  JSR $ffb7
AF9D  4C 3C BC  JMP $bc3c
AFA0  A5 64     LDA $64
AFA2  A4 65     LDY $65
AFA4  4C A2 BB  JMP $bba2
AFA7  0A        ASL A
AFA8  48        PHA
AFA9  AA        TAX
AFAA  20 73 00  JSR $0073
AFAD  E0 8F     CPX #$8f
AFAF  90 20     BCC $afd1
AFB1  20 FA AE  JSR $aefa
AFB4  20 9E AD  JSR $ad9e
AFB7  20 FD AE  JSR $aefd
AFBA  20 8F AD  JSR $ad8f
AFBD  68        PLA
AFBE  AA        TAX
AFBF  A5 65     LDA $65
AFC1  48        PHA
AFC2  A5 64     LDA $64
AFC4  48        PHA
AFC5  8A        TXA
AFC6  48        PHA
AFC7  20 9E B7  JSR $b79e
AFCA  68        PLA
AFCB  A8        TAY
AFCC  8A        TXA
AFCD  48        PHA
AFCE  4C D6 AF  JMP $afd6
AFD1  20 F1 AE  JSR $aef1
AFD4  68        PLA
AFD5  A8        TAY
AFD6  B9 EA 9F  LDA $9fea,Y
AFD9  85 55     STA $55
AFDB  B9 EB 9F  LDA $9feb,Y
AFDE  85 56     STA $56
AFE0  20 54 00  JSR $0054
AFE3  4C 8D AD  JMP $ad8d
AFE6  A0 FF     LDY #$ff
AFE8  2C A0 00  BIT $00a0
AFEB  84 0B     STY $0b
AFED  20 BF B1  JSR $b1bf
AFF0  A5 64     LDA $64
AFF2  45 0B     EOR $0b
AFF4  85 07     STA $07
AFF6  A5 65     LDA $65
AFF8  45 0B     EOR $0b
AFFA  85 08     STA $08
AFFC  20 FC BB  JSR $bbfc
AFFF  20 BF B1  JSR $b1bf
B002  A5 65     LDA $65
B004  45 0B     EOR $0b
B006  25 08     AND $08
B008  45 0B     EOR $0b
B00A  A8        TAY
B00B  A5 64     LDA $64
B00D  45 0B     EOR $0b
B00F  25 07     AND $07
B011  45 0B     EOR $0b
B013  4C 91 B3  JMP $b391
B016  20 90 AD  JSR $ad90
B019  B0 13     BCS $b02e
B01B  A5 6E     LDA $6e
B01D  09 7F     ORA #$7f
B01F  25 6A     AND $6a
B021  85 6A     STA $6a
B023  A9 69     LDA #$69
B025  A0 00     LDY #$00
B027  20 5B BC  JSR $bc5b
B02A  AA        TAX
B02B  4C 61 B0  JMP $b061
B02E  A9 00     LDA #$00
B030  85 0D     STA $0d
B032  C6 4D     DEC $4d
B034  20 A6 B6  JSR $b6a6
B037  85 61     STA $61
B039  86 62     STX $62
B03B  84 63     STY $63
B03D  A5 6C     LDA $6c
B03F  A4 6D     LDY $6d
B041  20 AA B6  JSR $b6aa
B044  86 6C     STX $6c
B046  84 6D     STY $6d
B048  AA        TAX
B049  38        SEC
B04A  E5 61     SBC $61
B04C  F0 08     BEQ $b056
B04E  A9 01     LDA #$01
B050  90 04     BCC $b056
B052  A6 61     LDX $61
B054  A9 FF     LDA #$ff
B056  85 66     STA $66
B058  A0 FF     LDY #$ff
B05A  E8        INX
B05B  C8        INY
B05C  CA        DEX
B05D  D0 07     BNE $b066
B05F  A6 66     LDX $66
B061  30 0F     BMI $b072
B063  18        CLC
B064  90 0C     BCC $b072
B066  B1 6C     LDA ($6c),Y
B068  D1 62     CMP ($62),Y
B06A  F0 EF     BEQ $b05b
B06C  A2 FF     LDX #$ff
B06E  B0 02     BCS $b072
B070  A2 01     LDX #$01
B072  E8        INX
B073  8A        TXA
B074  2A        ROL A
B075  25 12     AND $12
B077  F0 02     BEQ $b07b
B079  A9 FF     LDA #$ff
B07B  4C 3C BC  JMP $bc3c
B07E  20 FD AE  JSR $aefd
B081  AA        TAX
B082  20 90 B0  JSR $b090
B085  20 79 00  JSR $0079
B088  D0 F4     BNE $b07e
B08A  60        RTS
B08B  A2 00     LDX #$00
B08D  20 79 00  JSR $0079
B090  86 0C     STX $0c
B092  85 45     STA $45
B094  20 79 00  JSR $0079
B097  20 13 B1  JSR $b113
B09A  B0 03     BCS $b09f
B09C  4C 08 AF  JMP $af08
B09F  A2 00     LDX #$00
B0A1  86 0D     STX $0d
B0A3  86 0E     STX $0e
B0A5  20 73 00  JSR $0073
B0A8  90 05     BCC $b0af
B0AA  20 13 B1  JSR $b113
B0AD  90 0B     BCC $b0ba
B0AF  AA        TAX
B0B0  20 73 00  JSR $0073
B0B3  90 FB     BCC $b0b0
B0B5  20 13 B1  JSR $b113
B0B8  B0 F6     BCS $b0b0
B0BA  C9 24     CMP #$24
B0BC  D0 06     BNE $b0c4
B0BE  A9 FF     LDA #$ff
B0C0  85 0D     STA $0d
B0C2  D0 10     BNE $b0d4
B0C4  C9 25     CMP #$25
B0C6  D0 13     BNE $b0db
B0C8  A5 10     LDA $10
B0CA  D0 D0     BNE $b09c
B0CC  A9 80     LDA #$80
B0CE  85 0E     STA $0e
B0D0  05 45     ORA $45
B0D2  85 45     STA $45
B0D4  8A        TXA
B0D5  09 80     ORA #$80
B0D7  AA        TAX
B0D8  20 73 00  JSR $0073
B0DB  86 46     STX $46
B0DD  38        SEC
B0DE  05 10     ORA $10
B0E0  E9 28     SBC #$28
B0E2  D0 03     BNE $b0e7
B0E4  4C D1 B1  JMP $b1d1
B0E7  A0 00     LDY #$00
B0E9  84 10     STY $10
B0EB  A5 2D     LDA $2d
B0ED  A6 2E     LDX $2e
B0EF  86 60     STX $60
B0F1  85 5F     STA $5f
B0F3  E4 30     CPX $30
B0F5  D0 04     BNE $b0fb
B0F7  C5 2F     CMP $2f
B0F9  F0 22     BEQ $b11d
B0FB  A5 45     LDA $45
B0FD  D1 5F     CMP ($5f),Y
B0FF  D0 08     BNE $b109
B101  A5 46     LDA $46
B103  C8        INY
B104  D1 5F     CMP ($5f),Y
B106  F0 7D     BEQ $b185
B108  88        DEY
B109  18        CLC
B10A  A5 5F     LDA $5f
B10C  69 07     ADC #$07
B10E  90 E1     BCC $b0f1
B110  E8        INX
B111  D0 DC     BNE $b0ef
B113  C9 41     CMP #$41
B115  90 05     BCC $b11c
B117  E9 5B     SBC #$5b
B119  38        SEC
B11A  E9 A5     SBC #$a5
B11C  60        RTS
B11D  68        PLA
B11E  48        PHA
B11F  C9 2A     CMP #$2a
B121  D0 05     BNE $b128
B123  A9 13     LDA #$13
B125  A0 BF     LDY #$bf
B127  60        RTS
B128  A5 45     LDA $45
B12A  A4 46     LDY $46
B12C  C9 54     CMP #$54
B12E  D0 0B     BNE $b13b
B130  C0 C9     CPY #$c9
B132  F0 EF     BEQ $b123
B134  C0 49     CPY #$49
B136  D0 03     BNE $b13b
B138  4C 08 AF  JMP $af08
B13B  C9 53     CMP #$53
B13D  D0 04     BNE $b143
B13F  C0 54     CPY #$54
B141  F0 F5     BEQ $b138
B143  A5 2F     LDA $2f
B145  A4 30     LDY $30
B147  85 5F     STA $5f
B149  84 60     STY $60
B14B  A5 31     LDA $31
B14D  A4 32     LDY $32
B14F  85 5A     STA $5a
B151  84 5B     STY $5b
B153  18        CLC
B154  69 07     ADC #$07
B156  90 01     BCC $b159
B158  C8        INY
B159  85 58     STA $58
B15B  84 59     STY $59
B15D  20 B8 A3  JSR $a3b8
B160  A5 58     LDA $58
B162  A4 59     LDY $59
B164  C8        INY
B165  85 2F     STA $2f
B167  84 30     STY $30
B169  A0 00     LDY #$00
B16B  A5 45     LDA $45
B16D  91 5F     STA ($5f),Y
B16F  C8        INY
B170  A5 46     LDA $46
B172  91 5F     STA ($5f),Y
B174  A9 00     LDA #$00
B176  C8        INY
B177  91 5F     STA ($5f),Y
B179  C8        INY
B17A  91 5F     STA ($5f),Y
B17C  C8        INY
B17D  91 5F     STA ($5f),Y
B17F  C8        INY
B180  91 5F     STA ($5f),Y
B182  C8        INY
B183  91 5F     STA ($5f),Y
B185  A5 5F     LDA $5f
B187  18        CLC
B188  69 02     ADC #$02
B18A  A4 60     LDY $60
B18C  90 01     BCC $b18f
B18E  C8        INY
B18F  85 47     STA $47
B191  84 48     STY $48
B193  60        RTS
B194  A5 0B     LDA $0b
B196  0A        ASL A
B197  69 05     ADC #$05
B199  65 5F     ADC $5f
B19B  A4 60     LDY $60
B19D  90 01     BCC $b1a0
B19F  C8        INY
B1A0  85 58     STA $58
B1A2  84 59     STY $59
B1A4  60        RTS
B1A5  90 80     BCC $b127
B1A7  00        BRK
B1A8  00        BRK
B1A9  00        BRK
B1AA  20 BF B1  JSR $b1bf
B1AD  A5 64     LDA $64
B1AF  A4 65     LDY $65
B1B1  60        RTS
B1B2  20 73 00  JSR $0073
B1B5  20 9E AD  JSR $ad9e
B1B8  20 8D AD  JSR $ad8d
B1BB  A5 66     LDA $66
B1BD  30 0D     BMI $b1cc
B1BF  A5 61     LDA $61
B1C1  C9 90     CMP #$90
B1C3  90 09     BCC $b1ce
B1C5  A9 A5     LDA #$a5
B1C7  A0 B1     LDY #$b1
B1C9  20 5B BC  JSR $bc5b
B1CC  D0 7A     BNE $b248
B1CE  4C 9B BC  JMP $bc9b
B1D1  A5 0C     LDA $0c
B1D3  05 0E     ORA $0e
B1D5  48        PHA
B1D6  A5 0D     LDA $0d
B1D8  48        PHA
B1D9  A0 00     LDY #$00
B1DB  98        TYA
B1DC  48        PHA
B1DD  A5 46     LDA $46
B1DF  48        PHA
B1E0  A5 45     LDA $45
B1E2  48        PHA
B1E3  20 B2 B1  JSR $b1b2
B1E6  68        PLA
B1E7  85 45     STA $45
B1E9  68        PLA
B1EA  85 46     STA $46
B1EC  68        PLA
B1ED  A8        TAY
B1EE  BA        TSX
B1EF  BD 02 01  LDA $0102,X
B1F2  48        PHA
B1F3  BD 01 01  LDA $0101,X
B1F6  48        PHA
B1F7  A5 64     LDA $64
B1F9  9D 02 01  STA $0102,X
B1FC  A5 65     LDA $65
B1FE  9D 01 01  STA $0101,X
B201  C8        INY
B202  20 79 00  JSR $0079
B205  C9 2C     CMP #$2c
B207  F0 D2     BEQ $b1db
B209  84 0B     STY $0b
B20B  20 F7 AE  JSR $aef7
B20E  68        PLA
B20F  85 0D     STA $0d
B211  68        PLA
B212  85 0E     STA $0e
B214  29 7F     AND #$7f
B216  85 0C     STA $0c
B218  A6 2F     LDX $2f
B21A  A5 30     LDA $30
B21C  86 5F     STX $5f
B21E  85 60     STA $60
B220  C5 32     CMP $32
B222  D0 04     BNE $b228
B224  E4 31     CPX $31
B226  F0 39     BEQ $b261
B228  A0 00     LDY #$00
B22A  B1 5F     LDA ($5f),Y
B22C  C8        INY
B22D  C5 45     CMP $45
B22F  D0 06     BNE $b237
B231  A5 46     LDA $46
B233  D1 5F     CMP ($5f),Y
B235  F0 16     BEQ $b24d
B237  C8        INY
B238  B1 5F     LDA ($5f),Y
B23A  18        CLC
B23B  65 5F     ADC $5f
B23D  AA        TAX
B23E  C8        INY
B23F  B1 5F     LDA ($5f),Y
B241  65 60     ADC $60
B243  90 D7     BCC $b21c
B245  A2 12     LDX #$12
B247  2C A2 0E  BIT $0ea2
B24A  4C 37 A4  JMP $a437
B24D  A2 13     LDX #$13
B24F  A5 0C     LDA $0c
B251  D0 F7     BNE $b24a
B253  20 94 B1  JSR $b194
B256  A5 0B     LDA $0b
B258  A0 04     LDY #$04
B25A  D1 5F     CMP ($5f),Y
B25C  D0 E7     BNE $b245
B25E  4C EA B2  JMP $b2ea
B261  20 94 B1  JSR $b194
B264  20 08 A4  JSR $a408
B267  A0 00     LDY #$00
B269  84 72     STY $72
B26B  A2 05     LDX #$05
B26D  A5 45     LDA $45
B26F  91 5F     STA ($5f),Y
B271  10 01     BPL $b274
B273  CA        DEX
B274  C8        INY
B275  A5 46     LDA $46
B277  91 5F     STA ($5f),Y
B279  10 02     BPL $b27d
B27B  CA        DEX
B27C  CA        DEX
B27D  86 71     STX $71
B27F  A5 0B     LDA $0b
B281  C8        INY
B282  C8        INY
B283  C8        INY
B284  91 5F     STA ($5f),Y
B286  A2 0B     LDX #$0b
B288  A9 00     LDA #$00
B28A  24 0C     BIT $0c
B28C  50 08     BVC $b296
B28E  68        PLA
B28F  18        CLC
B290  69 01     ADC #$01
B292  AA        TAX
B293  68        PLA
B294  69 00     ADC #$00
B296  C8        INY
B297  91 5F     STA ($5f),Y
B299  C8        INY
B29A  8A        TXA
B29B  91 5F     STA ($5f),Y
B29D  20 4C B3  JSR $b34c
B2A0  86 71     STX $71
B2A2  85 72     STA $72
B2A4  A4 22     LDY $22
B2A6  C6 0B     DEC $0b
B2A8  D0 DC     BNE $b286
B2AA  65 59     ADC $59
B2AC  B0 5D     BCS $b30b
B2AE  85 59     STA $59
B2B0  A8        TAY
B2B1  8A        TXA
B2B2  65 58     ADC $58
B2B4  90 03     BCC $b2b9
B2B6  C8        INY
B2B7  F0 52     BEQ $b30b
B2B9  20 08 A4  JSR $a408
B2BC  85 31     STA $31
B2BE  84 32     STY $32
B2C0  A9 00     LDA #$00
B2C2  E6 72     INC $72
B2C4  A4 71     LDY $71
B2C6  F0 05     BEQ $b2cd
B2C8  88        DEY
B2C9  91 58     STA ($58),Y
B2CB  D0 FB     BNE $b2c8
B2CD  C6 59     DEC $59
B2CF  C6 72     DEC $72
B2D1  D0 F5     BNE $b2c8
B2D3  E6 59     INC $59
B2D5  38        SEC
B2D6  A5 31     LDA $31
B2D8  E5 5F     SBC $5f
B2DA  A0 02     LDY #$02
B2DC  91 5F     STA ($5f),Y
B2DE  A5 32     LDA $32
B2E0  C8        INY
B2E1  E5 60     SBC $60
B2E3  91 5F     STA ($5f),Y
B2E5  A5 0C     LDA $0c
B2E7  D0 62     BNE $b34b
B2E9  C8        INY
B2EA  B1 5F     LDA ($5f),Y
B2EC  85 0B     STA $0b
B2EE  A9 00     LDA #$00
B2F0  85 71     STA $71
B2F2  85 72     STA $72
B2F4  C8        INY
B2F5  68        PLA
B2F6  AA        TAX
B2F7  85 64     STA $64
B2F9  68        PLA
B2FA  85 65     STA $65
B2FC  D1 5F     CMP ($5f),Y
B2FE  90 0E     BCC $b30e
B300  D0 06     BNE $b308
B302  C8        INY
B303  8A        TXA
B304  D1 5F     CMP ($5f),Y
B306  90 07     BCC $b30f
B308  4C 45 B2  JMP $b245
B30B  4C 35 A4  JMP $a435
B30E  C8        INY
B30F  A5 72     LDA $72
B311  05 71     ORA $71
B313  18        CLC
B314  F0 0A     BEQ $b320
B316  20 4C B3  JSR $b34c
B319  8A        TXA
B31A  65 64     ADC $64
B31C  AA        TAX
B31D  98        TYA
B31E  A4 22     LDY $22
B320  65 65     ADC $65
B322  86 71     STX $71
B324  C6 0B     DEC $0b
B326  D0 CA     BNE $b2f2
B328  85 72     STA $72
B32A  A2 05     LDX #$05
B32C  A5 45     LDA $45
B32E  10 01     BPL $b331
B330  CA        DEX
B331  A5 46     LDA $46
B333  10 02     BPL $b337
B335  CA        DEX
B336  CA        DEX
B337  86 28     STX $28
B339  A9 00     LDA #$00
B33B  20 55 B3  JSR $b355
B33E  8A        TXA
B33F  65 58     ADC $58
B341  85 47     STA $47
B343  98        TYA
B344  65 59     ADC $59
B346  85 48     STA $48
B348  A8        TAY
B349  A5 47     LDA $47
B34B  60        RTS
B34C  84 22     STY $22
B34E  B1 5F     LDA ($5f),Y
B350  85 28     STA $28
B352  88        DEY
B353  B1 5F     LDA ($5f),Y
B355  85 29     STA $29
B357  A9 10     LDA #$10
B359  85 5D     STA $5d
B35B  A2 00     LDX #$00
B35D  A0 00     LDY #$00
B35F  8A        TXA
B360  0A        ASL A
B361  AA        TAX
B362  98        TYA
B363  2A        ROL A
B364  A8        TAY
B365  B0 A4     BCS $b30b
B367  06 71     ASL $71
B369  26 72     ROL $72
B36B  90 0B     BCC $b378
B36D  18        CLC
B36E  8A        TXA
B36F  65 28     ADC $28
B371  AA        TAX
B372  98        TYA
B373  65 29     ADC $29
B375  A8        TAY
B376  B0 93     BCS $b30b
B378  C6 5D     DEC $5d
B37A  D0 E3     BNE $b35f
B37C  60        RTS
B37D  A5 0D     LDA $0d
B37F  F0 03     BEQ $b384
B381  20 A6 B6  JSR $b6a6
B384  20 26 B5  JSR $b526
B387  38        SEC
B388  A5 33     LDA $33
B38A  E5 31     SBC $31
B38C  A8        TAY
B38D  A5 34     LDA $34
B38F  E5 32     SBC $32
B391  A2 00     LDX #$00
B393  86 0D     STX $0d
B395  85 62     STA $62
B397  84 63     STY $63
B399  A2 90     LDX #$90
B39B  4C 44 BC  JMP $bc44
B39E  38        SEC
B39F  20 F0 FF  JSR $fff0
B3A2  A9 00     LDA #$00
B3A4  F0 EB     BEQ $b391
B3A6  A6 3A     LDX $3a
B3A8  E8        INX
B3A9  D0 A0     BNE $b34b
B3AB  A2 15     LDX #$15
B3AD  2C A2 1B  BIT $1ba2
B3B0  4C 37 A4  JMP $a437
B3B3  20 E1 B3  JSR $b3e1
B3B6  20 A6 B3  JSR $b3a6
B3B9  20 FA AE  JSR $aefa
B3BC  A9 80     LDA #$80
B3BE  85 10     STA $10
B3C0  20 8B B0  JSR $b08b
B3C3  20 8D AD  JSR $ad8d
B3C6  20 F7 AE  JSR $aef7
B3C9  A9 B2     LDA #$b2
B3CB  20 FF AE  JSR $aeff
B3CE  48        PHA
B3CF  A5 48     LDA $48
B3D1  48        PHA
B3D2  A5 47     LDA $47
B3D4  48        PHA
B3D5  A5 7B     LDA $7b
B3D7  48        PHA
B3D8  A5 7A     LDA $7a
B3DA  48        PHA
B3DB  20 F8 A8  JSR $a8f8
B3DE  4C 4F B4  JMP $b44f
B3E1  A9 A5     LDA #$a5
B3E3  20 FF AE  JSR $aeff
B3E6  09 80     ORA #$80
B3E8  85 10     STA $10
B3EA  20 92 B0  JSR $b092
B3ED  85 4E     STA $4e
B3EF  84 4F     STY $4f
B3F1  4C 8D AD  JMP $ad8d
B3F4  20 E1 B3  JSR $b3e1
B3F7  A5 4F     LDA $4f
B3F9  48        PHA
B3FA  A5 4E     LDA $4e
B3FC  48        PHA
B3FD  20 F1 AE  JSR $aef1
B400  20 8D AD  JSR $ad8d
B403  68        PLA
B404  85 4E     STA $4e
B406  68        PLA
B407  85 4F     STA $4f
B409  A0 02     LDY #$02
B40B  B1 4E     LDA ($4e),Y
B40D  85 47     STA $47
B40F  AA        TAX
B410  C8        INY
B411  B1 4E     LDA ($4e),Y
B413  F0 99     BEQ $b3ae
B415  85 48     STA $48
B417  C8        INY
B418  B1 47     LDA ($47),Y
B41A  48        PHA
B41B  88        DEY
B41C  10 FA     BPL $b418
B41E  A4 48     LDY $48
B420  20 D4 BB  JSR $bbd4
B423  A5 7B     LDA $7b
B425  48        PHA
B426  A5 7A     LDA $7a
B428  48        PHA
B429  B1 4E     LDA ($4e),Y
B42B  85 7A     STA $7a
B42D  C8        INY
B42E  B1 4E     LDA ($4e),Y
B430  85 7B     STA $7b
B432  A5 48     LDA $48
B434  48        PHA
B435  A5 47     LDA $47
B437  48        PHA
B438  20 8A AD  JSR $ad8a
B43B  68        PLA
B43C  85 4E     STA $4e
B43E  68        PLA
B43F  85 4F     STA $4f
B441  20 79 00  JSR $0079
B444  F0 03     BEQ $b449
B446  4C 08 AF  JMP $af08
B449  68        PLA
B44A  85 7A     STA $7a
B44C  68        PLA
B44D  85 7B     STA $7b
B44F  A0 00     LDY #$00
B451  68        PLA
B452  91 4E     STA ($4e),Y
B454  68        PLA
B455  C8        INY
B456  91 4E     STA ($4e),Y
B458  68        PLA
B459  C8        INY
B45A  91 4E     STA ($4e),Y
B45C  68        PLA
B45D  C8        INY
B45E  91 4E     STA ($4e),Y
B460  68        PLA
B461  C8        INY
B462  91 4E     STA ($4e),Y
B464  60        RTS
B465  20 8D AD  JSR $ad8d
B468  A0 00     LDY #$00
B46A  20 DF BD  JSR $bddf
B46D  68        PLA
B46E  68        PLA
B46F  A9 FF     LDA #$ff
B471  A0 00     LDY #$00
B473  F0 12     BEQ $b487
B475  A6 64     LDX $64
B477  A4 65     LDY $65
B479  86 50     STX $50
B47B  84 51     STY $51
B47D  20 F4 B4  JSR $b4f4
B480  86 62     STX $62
B482  84 63     STY $63
B484  85 61     STA $61
B486  60        RTS
B487  A2 22     LDX #$22
B489  86 07     STX $07
B48B  86 08     STX $08
B48D  85 6F     STA $6f
B48F  84 70     STY $70
B491  85 62     STA $62
B493  84 63     STY $63
B495  A0 FF     LDY #$ff
B497  C8        INY
B498  B1 6F     LDA ($6f),Y
B49A  F0 0C     BEQ $b4a8
B49C  C5 07     CMP $07
B49E  F0 04     BEQ $b4a4
B4A0  C5 08     CMP $08
B4A2  D0 F3     BNE $b497
B4A4  C9 22     CMP #$22
B4A6  F0 01     BEQ $b4a9
B4A8  18        CLC
B4A9  84 61     STY $61
B4AB  98        TYA
B4AC  65 6F     ADC $6f
B4AE  85 71     STA $71
B4B0  A6 70     LDX $70
B4B2  90 01     BCC $b4b5
B4B4  E8        INX
B4B5  86 72     STX $72
B4B7  A5 70     LDA $70
B4B9  F0 04     BEQ $b4bf
B4BB  C9 02     CMP #$02
B4BD  D0 0B     BNE $b4ca
B4BF  98        TYA
B4C0  20 75 B4  JSR $b475
B4C3  A6 6F     LDX $6f
B4C5  A4 70     LDY $70
B4C7  20 88 B6  JSR $b688
B4CA  A6 16     LDX $16
B4CC  E0 22     CPX #$22
B4CE  D0 05     BNE $b4d5
B4D0  A2 19     LDX #$19
B4D2  4C 37 A4  JMP $a437
B4D5  A5 61     LDA $61
B4D7  95 00     STA $00,X
B4D9  A5 62     LDA $62
B4DB  95 01     STA $01,X
B4DD  A5 63     LDA $63
B4DF  95 02     STA $02,X
B4E1  A0 00     LDY #$00
B4E3  86 64     STX $64
B4E5  84 65     STY $65
B4E7  84 70     STY $70
B4E9  88        DEY
B4EA  84 0D     STY $0d
B4EC  86 17     STX $17
B4EE  E8        INX
B4EF  E8        INX
B4F0  E8        INX
B4F1  86 16     STX $16
B4F3  60        RTS
B4F4  46 0F     LSR $0f
B4F6  48        PHA
B4F7  49 FF     EOR #$ff
B4F9  38        SEC
B4FA  65 33     ADC $33
B4FC  A4 34     LDY $34
B4FE  B0 01     BCS $b501
B500  88        DEY
B501  C4 32     CPY $32
B503  90 11     BCC $b516
B505  D0 04     BNE $b50b
B507  C5 31     CMP $31
B509  90 0B     BCC $b516
B50B  85 33     STA $33
B50D  84 34     STY $34
B50F  85 35     STA $35
B511  84 36     STY $36
B513  AA        TAX
B514  68        PLA
B515  60        RTS
B516  A2 10     LDX #$10
B518  A5 0F     LDA $0f
B51A  30 B6     BMI $b4d2
B51C  20 26 B5  JSR $b526
B51F  A9 80     LDA #$80
B521  85 0F     STA $0f
B523  68        PLA
B524  D0 D0     BNE $b4f6
B526  A6 37     LDX $37
B528  A5 38     LDA $38
B52A  86 33     STX $33
B52C  85 34     STA $34
B52E  A0 00     LDY #$00
B530  84 4F     STY $4f
B532  84 4E     STY $4e
B534  A5 31     LDA $31
B536  A6 32     LDX $32
B538  85 5F     STA $5f
B53A  86 60     STX $60
B53C  A9 19     LDA #$19
B53E  A2 00     LDX #$00
B540  85 22     STA $22
B542  86 23     STX $23
B544  C5 16     CMP $16
B546  F0 05     BEQ $b54d
B548  20 C7 B5  JSR $b5c7
B54B  F0 F7     BEQ $b544
B54D  A9 07     LDA #$07
B54F  85 53     STA $53
B551  A5 2D     LDA $2d
B553  A6 2E     LDX $2e
B555  85 22     STA $22
B557  86 23     STX $23
B559  E4 30     CPX $30
B55B  D0 04     BNE $b561
B55D  C5 2F     CMP $2f
B55F  F0 05     BEQ $b566
B561  20 BD B5  JSR $b5bd
B564  F0 F3     BEQ $b559
B566  85 58     STA $58
B568  86 59     STX $59
B56A  A9 03     LDA #$03
B56C  85 53     STA $53
B56E  A5 58     LDA $58
B570  A6 59     LDX $59
B572  E4 32     CPX $32
B574  D0 07     BNE $b57d
B576  C5 31     CMP $31
B578  D0 03     BNE $b57d
B57A  4C 06 B6  JMP $b606
B57D  85 22     STA $22
B57F  86 23     STX $23
B581  A0 00     LDY #$00
B583  B1 22     LDA ($22),Y
B585  AA        TAX
B586  C8        INY
B587  B1 22     LDA ($22),Y
B589  08        PHP
B58A  C8        INY
B58B  B1 22     LDA ($22),Y
B58D  65 58     ADC $58
B58F  85 58     STA $58
B591  C8        INY
B592  B1 22     LDA ($22),Y
B594  65 59     ADC $59
B596  85 59     STA $59
B598  28        PLP
B599  10 D3     BPL $b56e
B59B  8A        TXA
B59C  30 D0     BMI $b56e
B59E  C8        INY
B59F  B1 22     LDA ($22),Y
B5A1  A0 00     LDY #$00
B5A3  0A        ASL A
B5A4  69 05     ADC #$05
B5A6  65 22     ADC $22
B5A8  85 22     STA $22
B5AA  90 02     BCC $b5ae
B5AC  E6 23     INC $23
B5AE  A6 23     LDX $23
B5B0  E4 59     CPX $59
B5B2  D0 04     BNE $b5b8
B5B4  C5 58     CMP $58
B5B6  F0 BA     BEQ $b572
B5B8  20 C7 B5  JSR $b5c7
B5BB  F0 F3     BEQ $b5b0
B5BD  B1 22     LDA ($22),Y
B5BF  30 35     BMI $b5f6
B5C1  C8        INY
B5C2  B1 22     LDA ($22),Y
B5C4  10 30     BPL $b5f6
B5C6  C8        INY
B5C7  B1 22     LDA ($22),Y
B5C9  F0 2B     BEQ $b5f6
B5CB  C8        INY
B5CC  B1 22     LDA ($22),Y
B5CE  AA        TAX
B5CF  C8        INY
B5D0  B1 22     LDA ($22),Y
B5D2  C5 34     CMP $34
B5D4  90 06     BCC $b5dc
B5D6  D0 1E     BNE $b5f6
B5D8  E4 33     CPX $33
B5DA  B0 1A     BCS $b5f6
B5DC  C5 60     CMP $60
B5DE  90 16     BCC $b5f6
B5E0  D0 04     BNE $b5e6
B5E2  E4 5F     CPX $5f
B5E4  90 10     BCC $b5f6
B5E6  86 5F     STX $5f
B5E8  85 60     STA $60
B5EA  A5 22     LDA $22
B5EC  A6 23     LDX $23
B5EE  85 4E     STA $4e
B5F0  86 4F     STX $4f
B5F2  A5 53     LDA $53
B5F4  85 55     STA $55
B5F6  A5 53     LDA $53
B5F8  18        CLC
B5F9  65 22     ADC $22
B5FB  85 22     STA $22
B5FD  90 02     BCC $b601
B5FF  E6 23     INC $23
B601  A6 23     LDX $23
B603  A0 00     LDY #$00
B605  60        RTS
B606  A5 4F     LDA $4f
B608  05 4E     ORA $4e
B60A  F0 F5     BEQ $b601
B60C  A5 55     LDA $55
B60E  29 04     AND #$04
B610  4A        LSR A
B611  A8        TAY
B612  85 55     STA $55
B614  B1 4E     LDA ($4e),Y
B616  65 5F     ADC $5f
B618  85 5A     STA $5a
B61A  A5 60     LDA $60
B61C  69 00     ADC #$00
B61E  85 5B     STA $5b
B620  A5 33     LDA $33
B622  A6 34     LDX $34
B624  85 58     STA $58
B626  86 59     STX $59
B628  20 BF A3  JSR $a3bf
B62B  A4 55     LDY $55
B62D  C8        INY
B62E  A5 58     LDA $58
B630  91 4E     STA ($4e),Y
B632  AA        TAX
B633  E6 59     INC $59
B635  A5 59     LDA $59
B637  C8        INY
B638  91 4E     STA ($4e),Y
B63A  4C 2A B5  JMP $b52a
B63D  A5 65     LDA $65
B63F  48        PHA
B640  A5 64     LDA $64
B642  48        PHA
B643  20 83 AE  JSR $ae83
B646  20 8F AD  JSR $ad8f
B649  68        PLA
B64A  85 6F     STA $6f
B64C  68        PLA
B64D  85 70     STA $70
B64F  A0 00     LDY #$00
B651  B1 6F     LDA ($6f),Y
B653  18        CLC
B654  71 64     ADC ($64),Y
B656  90 05     BCC $b65d
B658  A2 17     LDX #$17
B65A  4C 37 A4  JMP $a437
B65D  20 75 B4  JSR $b475
B660  20 7A B6  JSR $b67a
B663  A5 50     LDA $50
B665  A4 51     LDY $51
B667  20 AA B6  JSR $b6aa
B66A  20 8C B6  JSR $b68c
B66D  A5 6F     LDA $6f
B66F  A4 70     LDY $70
B671  20 AA B6  JSR $b6aa
B674  20 CA B4  JSR $b4ca
B677  4C B8 AD  JMP $adb8
B67A  A0 00     LDY #$00
B67C  B1 6F     LDA ($6f),Y
B67E  48        PHA
B67F  C8        INY
B680  B1 6F     LDA ($6f),Y
B682  AA        TAX
B683  C8        INY
B684  B1 6F     LDA ($6f),Y
B686  A8        TAY
B687  68        PLA
B688  86 22     STX $22
B68A  84 23     STY $23
B68C  A8        TAY
B68D  F0 0A     BEQ $b699
B68F  48        PHA
B690  88        DEY
B691  B1 22     LDA ($22),Y
B693  91 35     STA ($35),Y
B695  98        TYA
B696  D0 F8     BNE $b690
B698  68        PLA
B699  18        CLC
B69A  65 35     ADC $35
B69C  85 35     STA $35
B69E  90 02     BCC $b6a2
B6A0  E6 36     INC $36
B6A2  60        RTS
B6A3  20 8F AD  JSR $ad8f
B6A6  A5 64     LDA $64
B6A8  A4 65     LDY $65
B6AA  85 22     STA $22
B6AC  84 23     STY $23
B6AE  20 DB B6  JSR $b6db
B6B1  08        PHP
B6B2  A0 00     LDY #$00
B6B4  B1 22     LDA ($22),Y
B6B6  48        PHA
B6B7  C8        INY
B6B8  B1 22     LDA ($22),Y
B6BA  AA        TAX
B6BB  C8        INY
B6BC  B1 22     LDA ($22),Y
B6BE  A8        TAY
B6BF  68        PLA
B6C0  28        PLP
B6C1  D0 13     BNE $b6d6
B6C3  C4 34     CPY $34
B6C5  D0 0F     BNE $b6d6
B6C7  E4 33     CPX $33
B6C9  D0 0B     BNE $b6d6
B6CB  48        PHA
B6CC  18        CLC
B6CD  65 33     ADC $33
B6CF  85 33     STA $33
B6D1  90 02     BCC $b6d5
B6D3  E6 34     INC $34
B6D5  68        PLA
B6D6  86 22     STX $22
B6D8  84 23     STY $23
B6DA  60        RTS
B6DB  C4 18     CPY $18
B6DD  D0 0C     BNE $b6eb
B6DF  C5 17     CMP $17
B6E1  D0 08     BNE $b6eb
B6E3  85 16     STA $16
B6E5  E9 03     SBC #$03
B6E7  85 17     STA $17
B6E9  A0 00     LDY #$00
B6EB  60        RTS
B6EC  20 A1 B7  JSR $b7a1
B6EF  8A        TXA
B6F0  48        PHA
B6F1  A9 01     LDA #$01
B6F3  20 7D B4  JSR $b47d
B6F6  68        PLA
B6F7  A0 00     LDY #$00
B6F9  91 62     STA ($62),Y
B6FB  68        PLA
B6FC  68        PLA
B6FD  4C CA B4  JMP $b4ca
B700  20 61 B7  JSR $b761
B703  D1 50     CMP ($50),Y
B705  98        TYA
B706  90 04     BCC $b70c
B708  B1 50     LDA ($50),Y
B70A  AA        TAX
B70B  98        TYA
B70C  48        PHA
B70D  8A        TXA
B70E  48        PHA
B70F  20 7D B4  JSR $b47d
B712  A5 50     LDA $50
B714  A4 51     LDY $51
B716  20 AA B6  JSR $b6aa
B719  68        PLA
B71A  A8        TAY
B71B  68        PLA
B71C  18        CLC
B71D  65 22     ADC $22
B71F  85 22     STA $22
B721  90 02     BCC $b725
B723  E6 23     INC $23
B725  98        TYA
B726  20 8C B6  JSR $b68c
B729  4C CA B4  JMP $b4ca
B72C  20 61 B7  JSR $b761
B72F  18        CLC
B730  F1 50     SBC ($50),Y
B732  49 FF     EOR #$ff
B734  4C 06 B7  JMP $b706
B737  A9 FF     LDA #$ff
B739  85 65     STA $65
B73B  20 79 00  JSR $0079
B73E  C9 29     CMP #$29
B740  F0 06     BEQ $b748
B742  20 FD AE  JSR $aefd
B745  20 9E B7  JSR $b79e
B748  20 61 B7  JSR $b761
B74B  F0 4B     BEQ $b798
B74D  CA        DEX
B74E  8A        TXA
B74F  48        PHA
B750  18        CLC
B751  A2 00     LDX #$00
B753  F1 50     SBC ($50),Y
B755  B0 B6     BCS $b70d
B757  49 FF     EOR #$ff
B759  C5 65     CMP $65
B75B  90 B1     BCC $b70e
B75D  A5 65     LDA $65
B75F  B0 AD     BCS $b70e
B761  20 F7 AE  JSR $aef7
B764  68        PLA
B765  A8        TAY
B766  68        PLA
B767  85 55     STA $55
B769  68        PLA
B76A  68        PLA
B76B  68        PLA
B76C  AA        TAX
B76D  68        PLA
B76E  85 50     STA $50
B770  68        PLA
B771  85 51     STA $51
B773  A5 55     LDA $55
B775  48        PHA
B776  98        TYA
B777  48        PHA
B778  A0 00     LDY #$00
B77A  8A        TXA
B77B  60        RTS
B77C  20 82 B7  JSR $b782
B77F  4C A2 B3  JMP $b3a2
B782  20 A3 B6  JSR $b6a3
B785  A2 00     LDX #$00
B787  86 0D     STX $0d
B789  A8        TAY
B78A  60        RTS
B78B  20 82 B7  JSR $b782
B78E  F0 08     BEQ $b798
B790  A0 00     LDY #$00
B792  B1 22     LDA ($22),Y
B794  A8        TAY
B795  4C A2 B3  JMP $b3a2
B798  4C 48 B2  JMP $b248
B79B  20 73 00  JSR $0073
B79E  20 8A AD  JSR $ad8a
B7A1  20 B8 B1  JSR $b1b8
B7A4  A6 64     LDX $64
B7A6  D0 F0     BNE $b798
B7A8  A6 65     LDX $65
B7AA  4C 79 00  JMP $0079
B7AD  20 82 B7  JSR $b782
B7B0  D0 03     BNE $b7b5
B7B2  4C F7 B8  JMP $b8f7
B7B5  A6 7A     LDX $7a
B7B7  A4 7B     LDY $7b
B7B9  86 71     STX $71
B7BB  84 72     STY $72
B7BD  A6 22     LDX $22
B7BF  86 7A     STX $7a
B7C1  18        CLC
B7C2  65 22     ADC $22
B7C4  85 24     STA $24
B7C6  A6 23     LDX $23
B7C8  86 7B     STX $7b
B7CA  90 01     BCC $b7cd
B7CC  E8        INX
B7CD  86 25     STX $25
B7CF  A0 00     LDY #$00
B7D1  B1 24     LDA ($24),Y
B7D3  48        PHA
B7D4  98        TYA
B7D5  91 24     STA ($24),Y
B7D7  20 79 00  JSR $0079
B7DA  20 F3 BC  JSR $bcf3
B7DD  68        PLA
B7DE  A0 00     LDY #$00
B7E0  91 24     STA ($24),Y
B7E2  A6 71     LDX $71
B7E4  A4 72     LDY $72
B7E6  86 7A     STX $7a
B7E8  84 7B     STY $7b
B7EA  60        RTS
B7EB  20 8A AD  JSR $ad8a
B7EE  20 F7 B7  JSR $b7f7
B7F1  20 FD AE  JSR $aefd
B7F4  4C 9E B7  JMP $b79e
B7F7  A5 66     LDA $66
B7F9  30 9D     BMI $b798
B7FB  A5 61     LDA $61
B7FD  C9 91     CMP #$91
B7FF  B0 97     BCS $b798
B801  20 9B BC  JSR $bc9b
B804  A5 64     LDA $64
B806  A4 65     LDY $65
B808  84 14     STY $14
B80A  85 15     STA $15
B80C  60        RTS
B80D  A5 15     LDA $15
B80F  48        PHA
B810  A5 14     LDA $14
B812  48        PHA
B813  20 F7 B7  JSR $b7f7
B816  A0 00     LDY #$00
B818  B1 14     LDA ($14),Y
B81A  A8        TAY
B81B  68        PLA
B81C  85 14     STA $14
B81E  68        PLA
B81F  85 15     STA $15
B821  4C A2 B3  JMP $b3a2
B824  20 EB B7  JSR $b7eb
B827  8A        TXA
B828  A0 00     LDY #$00
B82A  91 14     STA ($14),Y
B82C  60        RTS
B82D  20 EB B7  JSR $b7eb
B830  86 49     STX $49
B832  A2 00     LDX #$00
B834  20 79 00  JSR $0079
B837  F0 03     BEQ $b83c
B839  20 F1 B7  JSR $b7f1
B83C  86 4A     STX $4a
B83E  A0 00     LDY #$00
B840  B1 14     LDA ($14),Y
B842  45 4A     EOR $4a
B844  25 49     AND $49
B846  F0 F8     BEQ $b840
B848  60        RTS
B849  A9 11     LDA #$11
B84B  A0 BF     LDY #$bf
B84D  4C 67 B8  JMP $b867
B850  20 8C BA  JSR $ba8c
B853  A5 66     LDA $66
B855  49 FF     EOR #$ff
B857  85 66     STA $66
B859  45 6E     EOR $6e
B85B  85 6F     STA $6f
B85D  A5 61     LDA $61
B85F  4C 6A B8  JMP $b86a
B862  20 99 B9  JSR $b999
B865  90 3C     BCC $b8a3
B867  20 8C BA  JSR $ba8c
B86A  D0 03     BNE $b86f
B86C  4C FC BB  JMP $bbfc
B86F  A6 70     LDX $70
B871  86 56     STX $56
B873  A2 69     LDX #$69
B875  A5 69     LDA $69
B877  A8        TAY
B878  F0 CE     BEQ $b848
B87A  38        SEC
B87B  E5 61     SBC $61
B87D  F0 24     BEQ $b8a3
B87F  90 12     BCC $b893
B881  84 61     STY $61
B883  A4 6E     LDY $6e
B885  84 66     STY $66
B887  49 FF     EOR #$ff
B889  69 00     ADC #$00
B88B  A0 00     LDY #$00
B88D  84 56     STY $56
B88F  A2 61     LDX #$61
B891  D0 04     BNE $b897
B893  A0 00     LDY #$00
B895  84 70     STY $70
B897  C9 F9     CMP #$f9
B899  30 C7     BMI $b862
B89B  A8        TAY
B89C  A5 70     LDA $70
B89E  56 01     LSR $01,X
B8A0  20 B0 B9  JSR $b9b0
B8A3  24 6F     BIT $6f
B8A5  10 57     BPL $b8fe
B8A7  A0 61     LDY #$61
B8A9  E0 69     CPX #$69
B8AB  F0 02     BEQ $b8af
B8AD  A0 69     LDY #$69
B8AF  38        SEC
B8B0  49 FF     EOR #$ff
B8B2  65 56     ADC $56
B8B4  85 70     STA $70
B8B6  B9 04 00  LDA $0004,Y
B8B9  F5 04     SBC $04,X
B8BB  85 65     STA $65
B8BD  B9 03 00  LDA $0003,Y
B8C0  F5 03     SBC $03,X
B8C2  85 64     STA $64
B8C4  B9 02 00  LDA $0002,Y
B8C7  F5 02     SBC $02,X
B8C9  85 63     STA $63
B8CB  B9 01 00  LDA $0001,Y
B8CE  F5 01     SBC $01,X
B8D0  85 62     STA $62
B8D2  B0 03     BCS $b8d7
B8D4  20 47 B9  JSR $b947
B8D7  A0 00     LDY #$00
B8D9  98        TYA
B8DA  18        CLC
B8DB  A6 62     LDX $62
B8DD  D0 4A     BNE $b929
B8DF  A6 63     LDX $63
B8E1  86 62     STX $62
B8E3  A6 64     LDX $64
B8E5  86 63     STX $63
B8E7  A6 65     LDX $65
B8E9  86 64     STX $64
B8EB  A6 70     LDX $70
B8ED  86 65     STX $65
B8EF  84 70     STY $70
B8F1  69 08     ADC #$08
B8F3  C9 20     CMP #$20
B8F5  D0 E4     BNE $b8db
B8F7  A9 00     LDA #$00
B8F9  85 61     STA $61
B8FB  85 66     STA $66
B8FD  60        RTS
B8FE  65 56     ADC $56
B900  85 70     STA $70
B902  A5 65     LDA $65
B904  65 6D     ADC $6d
B906  85 65     STA $65
B908  A5 64     LDA $64
B90A  65 6C     ADC $6c
B90C  85 64     STA $64
B90E  A5 63     LDA $63
B910  65 6B     ADC $6b
B912  85 63     STA $63
B914  A5 62     LDA $62
B916  65 6A     ADC $6a
B918  85 62     STA $62
B91A  4C 36 B9  JMP $b936
B91D  69 01     ADC #$01
B91F  06 70     ASL $70
B921  26 65     ROL $65
B923  26 64     ROL $64
B925  26 63     ROL $63
B927  26 62     ROL $62
B929  10 F2     BPL $b91d
B92B  38        SEC
B92C  E5 61     SBC $61
B92E  B0 C7     BCS $b8f7
B930  49 FF     EOR #$ff
B932  69 01     ADC #$01
B934  85 61     STA $61
B936  90 0E     BCC $b946
B938  E6 61     INC $61
B93A  F0 42     BEQ $b97e
B93C  66 62     ROR $62
B93E  66 63     ROR $63
B940  66 64     ROR $64
B942  66 65     ROR $65
B944  66 70     ROR $70
B946  60        RTS
B947  A5 66     LDA $66
B949  49 FF     EOR #$ff
B94B  85 66     STA $66
B94D  A5 62     LDA $62
B94F  49 FF     EOR #$ff
B951  85 62     STA $62
B953  A5 63     LDA $63
B955  49 FF     EOR #$ff
B957  85 63     STA $63
B959  A5 64     LDA $64
B95B  49 FF     EOR #$ff
B95D  85 64     STA $64
B95F  A5 65     LDA $65
B961  49 FF     EOR #$ff
B963  85 65     STA $65
B965  A5 70     LDA $70
B967  49 FF     EOR #$ff
B969  85 70     STA $70
B96B  E6 70     INC $70
B96D  D0 0E     BNE $b97d
B96F  E6 65     INC $65
B971  D0 0A     BNE $b97d
B973  E6 64     INC $64
B975  D0 06     BNE $b97d
B977  E6 63     INC $63
B979  D0 02     BNE $b97d
B97B  E6 62     INC $62
B97D  60        RTS
B97E  A2 0F     LDX #$0f
B980  4C 37 A4  JMP $a437
B983  A2 25     LDX #$25
B985  B4 04     LDY $04,X
B987  84 70     STY $70
B989  B4 03     LDY $03,X
B98B  94 04     STY $04,X
B98D  B4 02     LDY $02,X
B98F  94 03     STY $03,X
B991  B4 01     LDY $01,X
B993  94 02     STY $02,X
B995  A4 68     LDY $68
B997  94 01     STY $01,X
B999  69 08     ADC #$08
B99B  30 E8     BMI $b985
B99D  F0 E6     BEQ $b985
B99F  E9 08     SBC #$08
B9A1  A8        TAY
B9A2  A5 70     LDA $70
B9A4  B0 14     BCS $b9ba
B9A6  16 01     ASL $01,X
B9A8  90 02     BCC $b9ac
B9AA  F6 01     INC $01,X
B9AC  76 01     ROR $01,X
B9AE  76 01     ROR $01,X
B9B0  76 02     ROR $02,X
B9B2  76 03     ROR $03,X
B9B4  76 04     ROR $04,X
B9B6  6A        ROR A
B9B7  C8        INY
B9B8  D0 EC     BNE $b9a6
B9BA  18        CLC
B9BB  60        RTS
B9BC  81 00     STA ($00,X)
B9BE  00        BRK
B9BF  00        BRK
B9C0  00        BRK
B9C1  03        ???
B9C2  7F        ???
B9C3  5E 56 CB  LSR $cb56,X
B9C6  79 80 13  ADC $1380,Y
B9C9  9B        ???
B9CA  0B        ???
B9CB  64        ???
B9CC  80        ???
B9CD  76 38     ROR $38,X
B9CF  93        ???
B9D0  16 82     ASL $82,X
B9D2  38        SEC
B9D3  AA        TAX
B9D4  3B        ???
B9D5  20 80 35  JSR $3580
B9D8  04        ???
B9D9  F3        ???
B9DA  34        ???
B9DB  81 35     STA ($35,X)
B9DD  04        ???
B9DE  F3        ???
B9DF  34        ???
B9E0  80        ???
B9E1  80        ???
B9E2  00        BRK
B9E3  00        BRK
B9E4  00        BRK
B9E5  80        ???
B9E6  31 72     AND ($72),Y
B9E8  17        ???
B9E9  F8        SED
B9EA  20 2B BC  JSR $bc2b
B9ED  F0 02     BEQ $b9f1
B9EF  10 03     BPL $b9f4
B9F1  4C 48 B2  JMP $b248
B9F4  A5 61     LDA $61
B9F6  E9 7F     SBC #$7f
B9F8  48        PHA
B9F9  A9 80     LDA #$80
B9FB  85 61     STA $61
B9FD  A9 D6     LDA #$d6
B9FF  A0 B9     LDY #$b9
BA01  20 67 B8  JSR $b867
BA04  A9 DB     LDA #$db
BA06  A0 B9     LDY #$b9
BA08  20 0F BB  JSR $bb0f
BA0B  A9 BC     LDA #$bc
BA0D  A0 B9     LDY #$b9
BA0F  20 50 B8  JSR $b850
BA12  A9 C1     LDA #$c1
BA14  A0 B9     LDY #$b9
BA16  20 43 E0  JSR $e043
BA19  A9 E0     LDA #$e0
BA1B  A0 B9     LDY #$b9
BA1D  20 67 B8  JSR $b867
BA20  68        PLA
BA21  20 7E BD  JSR $bd7e
BA24  A9 E5     LDA #$e5
BA26  A0 B9     LDY #$b9
BA28  20 8C BA  JSR $ba8c
BA2B  D0 03     BNE $ba30
BA2D  4C 8B BA  JMP $ba8b
BA30  20 B7 BA  JSR $bab7
BA33  A9 00     LDA #$00
BA35  85 26     STA $26
BA37  85 27     STA $27
BA39  85 28     STA $28
BA3B  85 29     STA $29
BA3D  A5 70     LDA $70
BA3F  20 59 BA  JSR $ba59
BA42  A5 65     LDA $65
BA44  20 59 BA  JSR $ba59
BA47  A5 64     LDA $64
BA49  20 59 BA  JSR $ba59
BA4C  A5 63     LDA $63
BA4E  20 59 BA  JSR $ba59
BA51  A5 62     LDA $62
BA53  20 5E BA  JSR $ba5e
BA56  4C 8F BB  JMP $bb8f
BA59  D0 03     BNE $ba5e
BA5B  4C 83 B9  JMP $b983
BA5E  4A        LSR A
BA5F  09 80     ORA #$80
BA61  A8        TAY
BA62  90 19     BCC $ba7d
BA64  18        CLC
BA65  A5 29     LDA $29
BA67  65 6D     ADC $6d
BA69  85 29     STA $29
BA6B  A5 28     LDA $28
BA6D  65 6C     ADC $6c
BA6F  85 28     STA $28
BA71  A5 27     LDA $27
BA73  65 6B     ADC $6b
BA75  85 27     STA $27
BA77  A5 26     LDA $26
BA79  65 6A     ADC $6a
BA7B  85 26     STA $26
BA7D  66 26     ROR $26
BA7F  66 27     ROR $27
BA81  66 28     ROR $28
BA83  66 29     ROR $29
BA85  66 70     ROR $70
BA87  98        TYA
BA88  4A        LSR A
BA89  D0 D6     BNE $ba61
BA8B  60        RTS
BA8C  85 22     STA $22
BA8E  84 23     STY $23
BA90  A0 04     LDY #$04
BA92  B1 22     LDA ($22),Y
BA94  85 6D     STA $6d
BA96  88        DEY
BA97  B1 22     LDA ($22),Y
BA99  85 6C     STA $6c
BA9B  88        DEY
BA9C  B1 22     LDA ($22),Y
BA9E  85 6B     STA $6b
BAA0  88        DEY
BAA1  B1 22     LDA ($22),Y
BAA3  85 6E     STA $6e
BAA5  45 66     EOR $66
BAA7  85 6F     STA $6f
BAA9  A5 6E     LDA $6e
BAAB  09 80     ORA #$80
BAAD  85 6A     STA $6a
BAAF  88        DEY
BAB0  B1 22     LDA ($22),Y
BAB2  85 69     STA $69
BAB4  A5 61     LDA $61
BAB6  60        RTS
BAB7  A5 69     LDA $69
BAB9  F0 1F     BEQ $bada
BABB  18        CLC
BABC  65 61     ADC $61
BABE  90 04     BCC $bac4
BAC0  30 1D     BMI $badf
BAC2  18        CLC
BAC3  2C 10 14  BIT $1410
BAC6  69 80     ADC #$80
BAC8  85 61     STA $61
BACA  D0 03     BNE $bacf
BACC  4C FB B8  JMP $b8fb
BACF  A5 6F     LDA $6f
BAD1  85 66     STA $66
BAD3  60        RTS
BAD4  A5 66     LDA $66
BAD6  49 FF     EOR #$ff
BAD8  30 05     BMI $badf
BADA  68        PLA
BADB  68        PLA
BADC  4C F7 B8  JMP $b8f7
BADF  4C 7E B9  JMP $b97e
BAE2  20 0C BC  JSR $bc0c
BAE5  AA        TAX
BAE6  F0 10     BEQ $baf8
BAE8  18        CLC
BAE9  69 02     ADC #$02
BAEB  B0 F2     BCS $badf
BAED  A2 00     LDX #$00
BAEF  86 6F     STX $6f
BAF1  20 77 B8  JSR $b877
BAF4  E6 61     INC $61
BAF6  F0 E7     BEQ $badf
BAF8  60        RTS
BAF9  84 20     STY $20
BAFB  00        BRK
BAFC  00        BRK
BAFD  00        BRK
BAFE  20 0C BC  JSR $bc0c
BB01  A9 F9     LDA #$f9
BB03  A0 BA     LDY #$ba
BB05  A2 00     LDX #$00
BB07  86 6F     STX $6f
BB09  20 A2 BB  JSR $bba2
BB0C  4C 12 BB  JMP $bb12
BB0F  20 8C BA  JSR $ba8c
BB12  F0 76     BEQ $bb8a
BB14  20 1B BC  JSR $bc1b
BB17  A9 00     LDA #$00
BB19  38        SEC
BB1A  E5 61     SBC $61
BB1C  85 61     STA $61
BB1E  20 B7 BA  JSR $bab7
BB21  E6 61     INC $61
BB23  F0 BA     BEQ $badf
BB25  A2 FC     LDX #$fc
BB27  A9 01     LDA #$01
BB29  A4 6A     LDY $6a
BB2B  C4 62     CPY $62
BB2D  D0 10     BNE $bb3f
BB2F  A4 6B     LDY $6b
BB31  C4 63     CPY $63
BB33  D0 0A     BNE $bb3f
BB35  A4 6C     LDY $6c
BB37  C4 64     CPY $64
BB39  D0 04     BNE $bb3f
BB3B  A4 6D     LDY $6d
BB3D  C4 65     CPY $65
BB3F  08        PHP
BB40  2A        ROL A
BB41  90 09     BCC $bb4c
BB43  E8        INX
BB44  95 29     STA $29,X
BB46  F0 32     BEQ $bb7a
BB48  10 34     BPL $bb7e
BB4A  A9 01     LDA #$01
BB4C  28        PLP
BB4D  B0 0E     BCS $bb5d
BB4F  06 6D     ASL $6d
BB51  26 6C     ROL $6c
BB53  26 6B     ROL $6b
BB55  26 6A     ROL $6a
BB57  B0 E6     BCS $bb3f
BB59  30 CE     BMI $bb29
BB5B  10 E2     BPL $bb3f
BB5D  A8        TAY
BB5E  A5 6D     LDA $6d
BB60  E5 65     SBC $65
BB62  85 6D     STA $6d
BB64  A5 6C     LDA $6c
BB66  E5 64     SBC $64
BB68  85 6C     STA $6c
BB6A  A5 6B     LDA $6b
BB6C  E5 63     SBC $63
BB6E  85 6B     STA $6b
BB70  A5 6A     LDA $6a
BB72  E5 62     SBC $62
BB74  85 6A     STA $6a
BB76  98        TYA
BB77  4C 4F BB  JMP $bb4f
BB7A  A9 40     LDA #$40
BB7C  D0 CE     BNE $bb4c
BB7E  0A        ASL A
BB7F  0A        ASL A
BB80  0A        ASL A
BB81  0A        ASL A
BB82  0A        ASL A
BB83  0A        ASL A
BB84  85 70     STA $70
BB86  28        PLP
BB87  4C 8F BB  JMP $bb8f
BB8A  A2 14     LDX #$14
BB8C  4C 37 A4  JMP $a437
BB8F  A5 26     LDA $26
BB91  85 62     STA $62
BB93  A5 27     LDA $27
BB95  85 63     STA $63
BB97  A5 28     LDA $28
BB99  85 64     STA $64
BB9B  A5 29     LDA $29
BB9D  85 65     STA $65
BB9F  4C D7 B8  JMP $b8d7
BBA2  85 22     STA $22
BBA4  84 23     STY $23
BBA6  A0 04     LDY #$04
BBA8  B1 22     LDA ($22),Y
BBAA  85 65     STA $65
BBAC  88        DEY
BBAD  B1 22     LDA ($22),Y
BBAF  85 64     STA $64
BBB1  88        DEY
BBB2  B1 22     LDA ($22),Y
BBB4  85 63     STA $63
BBB6  88        DEY
BBB7  B1 22     LDA ($22),Y
BBB9  85 66     STA $66
BBBB  09 80     ORA #$80
BBBD  85 62     STA $62
BBBF  88        DEY
BBC0  B1 22     LDA ($22),Y
BBC2  85 61     STA $61
BBC4  84 70     STY $70
BBC6  60        RTS
BBC7  A2 5C     LDX #$5c
BBC9  2C A2 57  BIT $57a2
BBCC  A0 00     LDY #$00
BBCE  F0 04     BEQ $bbd4
BBD0  A6 49     LDX $49
BBD2  A4 4A     LDY $4a
BBD4  20 1B BC  JSR $bc1b
BBD7  86 22     STX $22
BBD9  84 23     STY $23
BBDB  A0 04     LDY #$04
BBDD  A5 65     LDA $65
BBDF  91 22     STA ($22),Y
BBE1  88        DEY
BBE2  A5 64     LDA $64
BBE4  91 22     STA ($22),Y
BBE6  88        DEY
BBE7  A5 63     LDA $63
BBE9  91 22     STA ($22),Y
BBEB  88        DEY
BBEC  A5 66     LDA $66
BBEE  09 7F     ORA #$7f
BBF0  25 62     AND $62
BBF2  91 22     STA ($22),Y
BBF4  88        DEY
BBF5  A5 61     LDA $61
BBF7  91 22     STA ($22),Y
BBF9  84 70     STY $70
BBFB  60        RTS
BBFC  A5 6E     LDA $6e
BBFE  85 66     STA $66
BC00  A2 05     LDX #$05
BC02  B5 68     LDA $68,X
BC04  95 60     STA $60,X
BC06  CA        DEX
BC07  D0 F9     BNE $bc02
BC09  86 70     STX $70
BC0B  60        RTS
BC0C  20 1B BC  JSR $bc1b
BC0F  A2 06     LDX #$06
BC11  B5 60     LDA $60,X
BC13  95 68     STA $68,X
BC15  CA        DEX
BC16  D0 F9     BNE $bc11
BC18  86 70     STX $70
BC1A  60        RTS
BC1B  A5 61     LDA $61
BC1D  F0 FB     BEQ $bc1a
BC1F  06 70     ASL $70
BC21  90 F7     BCC $bc1a
BC23  20 6F B9  JSR $b96f
BC26  D0 F2     BNE $bc1a
BC28  4C 38 B9  JMP $b938
BC2B  A5 61     LDA $61
BC2D  F0 09     BEQ $bc38
BC2F  A5 66     LDA $66
BC31  2A        ROL A
BC32  A9 FF     LDA #$ff
BC34  B0 02     BCS $bc38
BC36  A9 01     LDA #$01
BC38  60        RTS
BC39  20 2B BC  JSR $bc2b
BC3C  85 62     STA $62
BC3E  A9 00     LDA #$00
BC40  85 63     STA $63
BC42  A2 88     LDX #$88
BC44  A5 62     LDA $62
BC46  49 FF     EOR #$ff
BC48  2A        ROL A
BC49  A9 00     LDA #$00
BC4B  85 65     STA $65
BC4D  85 64     STA $64
BC4F  86 61     STX $61
BC51  85 70     STA $70
BC53  85 66     STA $66
BC55  4C D2 B8  JMP $b8d2
BC58  46 66     LSR $66
BC5A  60        RTS
BC5B  85 24     STA $24
BC5D  84 25     STY $25
BC5F  A0 00     LDY #$00
BC61  B1 24     LDA ($24),Y
BC63  C8        INY
BC64  AA        TAX
BC65  F0 C4     BEQ $bc2b
BC67  B1 24     LDA ($24),Y
BC69  45 66     EOR $66
BC6B  30 C2     BMI $bc2f
BC6D  E4 61     CPX $61
BC6F  D0 21     BNE $bc92
BC71  B1 24     LDA ($24),Y
BC73  09 80     ORA #$80
BC75  C5 62     CMP $62
BC77  D0 19     BNE $bc92
BC79  C8        INY
BC7A  B1 24     LDA ($24),Y
BC7C  C5 63     CMP $63
BC7E  D0 12     BNE $bc92
BC80  C8        INY
BC81  B1 24     LDA ($24),Y
BC83  C5 64     CMP $64
BC85  D0 0B     BNE $bc92
BC87  C8        INY
BC88  A9 7F     LDA #$7f
BC8A  C5 70     CMP $70
BC8C  B1 24     LDA ($24),Y
BC8E  E5 65     SBC $65
BC90  F0 28     BEQ $bcba
BC92  A5 66     LDA $66
BC94  90 02     BCC $bc98
BC96  49 FF     EOR #$ff
BC98  4C 31 BC  JMP $bc31
BC9B  A5 61     LDA $61
BC9D  F0 4A     BEQ $bce9
BC9F  38        SEC
BCA0  E9 A0     SBC #$a0
BCA2  24 66     BIT $66
BCA4  10 09     BPL $bcaf
BCA6  AA        TAX
BCA7  A9 FF     LDA #$ff
BCA9  85 68     STA $68
BCAB  20 4D B9  JSR $b94d
BCAE  8A        TXA
BCAF  A2 61     LDX #$61
BCB1  C9 F9     CMP #$f9
BCB3  10 06     BPL $bcbb
BCB5  20 99 B9  JSR $b999
BCB8  84 68     STY $68
BCBA  60        RTS
BCBB  A8        TAY
BCBC  A5 66     LDA $66
BCBE  29 80     AND #$80
BCC0  46 62     LSR $62
BCC2  05 62     ORA $62
BCC4  85 62     STA $62
BCC6  20 B0 B9  JSR $b9b0
BCC9  84 68     STY $68
BCCB  60        RTS
BCCC  A5 61     LDA $61
BCCE  C9 A0     CMP #$a0
BCD0  B0 20     BCS $bcf2
BCD2  20 9B BC  JSR $bc9b
BCD5  84 70     STY $70
BCD7  A5 66     LDA $66
BCD9  84 66     STY $66
BCDB  49 80     EOR #$80
BCDD  2A        ROL A
BCDE  A9 A0     LDA #$a0
BCE0  85 61     STA $61
BCE2  A5 65     LDA $65
BCE4  85 07     STA $07
BCE6  4C D2 B8  JMP $b8d2
BCE9  85 62     STA $62
BCEB  85 63     STA $63
BCED  85 64     STA $64
BCEF  85 65     STA $65
BCF1  A8        TAY
BCF2  60        RTS
BCF3  A0 00     LDY #$00
BCF5  A2 0A     LDX #$0a
BCF7  94 5D     STY $5d,X
BCF9  CA        DEX
BCFA  10 FB     BPL $bcf7
BCFC  90 0F     BCC $bd0d
BCFE  C9 2D     CMP #$2d
BD00  D0 04     BNE $bd06
BD02  86 67     STX $67
BD04  F0 04     BEQ $bd0a
BD06  C9 2B     CMP #$2b
BD08  D0 05     BNE $bd0f
BD0A  20 73 00  JSR $0073
BD0D  90 5B     BCC $bd6a
BD0F  C9 2E     CMP #$2e
BD11  F0 2E     BEQ $bd41
BD13  C9 45     CMP #$45
BD15  D0 30     BNE $bd47
BD17  20 73 00  JSR $0073
BD1A  90 17     BCC $bd33
BD1C  C9 AB     CMP #$ab
BD1E  F0 0E     BEQ $bd2e
BD20  C9 2D     CMP #$2d
BD22  F0 0A     BEQ $bd2e
BD24  C9 AA     CMP #$aa
BD26  F0 08     BEQ $bd30
BD28  C9 2B     CMP #$2b
BD2A  F0 04     BEQ $bd30
BD2C  D0 07     BNE $bd35
BD2E  66 60     ROR $60
BD30  20 73 00  JSR $0073
BD33  90 5C     BCC $bd91
BD35  24 60     BIT $60
BD37  10 0E     BPL $bd47
BD39  A9 00     LDA #$00
BD3B  38        SEC
BD3C  E5 5E     SBC $5e
BD3E  4C 49 BD  JMP $bd49
BD41  66 5F     ROR $5f
BD43  24 5F     BIT $5f
BD45  50 C3     BVC $bd0a
BD47  A5 5E     LDA $5e
BD49  38        SEC
BD4A  E5 5D     SBC $5d
BD4C  85 5E     STA $5e
BD4E  F0 12     BEQ $bd62
BD50  10 09     BPL $bd5b
BD52  20 FE BA  JSR $bafe
BD55  E6 5E     INC $5e
BD57  D0 F9     BNE $bd52
BD59  F0 07     BEQ $bd62
BD5B  20 E2 BA  JSR $bae2
BD5E  C6 5E     DEC $5e
BD60  D0 F9     BNE $bd5b
BD62  A5 67     LDA $67
BD64  30 01     BMI $bd67
BD66  60        RTS
BD67  4C B4 BF  JMP $bfb4
BD6A  48        PHA
BD6B  24 5F     BIT $5f
BD6D  10 02     BPL $bd71
BD6F  E6 5D     INC $5d
BD71  20 E2 BA  JSR $bae2
BD74  68        PLA
BD75  38        SEC
BD76  E9 30     SBC #$30
BD78  20 7E BD  JSR $bd7e
BD7B  4C 0A BD  JMP $bd0a
BD7E  48        PHA
BD7F  20 0C BC  JSR $bc0c
BD82  68        PLA
BD83  20 3C BC  JSR $bc3c
BD86  A5 6E     LDA $6e
BD88  45 66     EOR $66
BD8A  85 6F     STA $6f
BD8C  A6 61     LDX $61
BD8E  4C 6A B8  JMP $b86a
BD91  A5 5E     LDA $5e
BD93  C9 0A     CMP #$0a
BD95  90 09     BCC $bda0
BD97  A9 64     LDA #$64
BD99  24 60     BIT $60
BD9B  30 11     BMI $bdae
BD9D  4C 7E B9  JMP $b97e
BDA0  0A        ASL A
BDA1  0A        ASL A
BDA2  18        CLC
BDA3  65 5E     ADC $5e
BDA5  0A        ASL A
BDA6  18        CLC
BDA7  A0 00     LDY #$00
BDA9  71 7A     ADC ($7a),Y
BDAB  38        SEC
BDAC  E9 30     SBC #$30
BDAE  85 5E     STA $5e
BDB0  4C 30 BD  JMP $bd30
BDB3  9B        ???
BDB4  3E BC 1F  ROL $1fbc,X
BDB7  FD 9E 6E  SBC $6e9e,X
BDBA  6B        ???
BDBB  27        ???
BDBC  FD 9E 6E  SBC $6e9e,X
BDBF  6B        ???
BDC0  28        PLP
BDC1  00        BRK
BDC2  A9 71     LDA #$71
BDC4  A0 A3     LDY #$a3
BDC6  20 DA BD  JSR $bdda
BDC9  A5 3A     LDA $3a
BDCB  A6 39     LDX $39
BDCD  85 62     STA $62
BDCF  86 63     STX $63
BDD1  A2 90     LDX #$90
BDD3  38        SEC
BDD4  20 49 BC  JSR $bc49
BDD7  20 DF BD  JSR $bddf
BDDA  4C 1E AB  JMP $ab1e
BDDD  A0 01     LDY #$01
BDDF  A9 20     LDA #$20
BDE1  24 66     BIT $66
BDE3  10 02     BPL $bde7
BDE5  A9 2D     LDA #$2d
BDE7  99 FF 00  STA $00ff,Y
BDEA  85 66     STA $66
BDEC  84 71     STY $71
BDEE  C8        INY
BDEF  A9 30     LDA #$30
BDF1  A6 61     LDX $61
BDF3  D0 03     BNE $bdf8
BDF5  4C 04 BF  JMP $bf04
BDF8  A9 00     LDA #$00
BDFA  E0 80     CPX #$80
BDFC  F0 02     BEQ $be00
BDFE  B0 09     BCS $be09
BE00  A9 BD     LDA #$bd
BE02  A0 BD     LDY #$bd
BE04  20 28 BA  JSR $ba28
BE07  A9 F7     LDA #$f7
BE09  85 5D     STA $5d
BE0B  A9 B8     LDA #$b8
BE0D  A0 BD     LDY #$bd
BE0F  20 5B BC  JSR $bc5b
BE12  F0 1E     BEQ $be32
BE14  10 12     BPL $be28
BE16  A9 B3     LDA #$b3
BE18  A0 BD     LDY #$bd
BE1A  20 5B BC  JSR $bc5b
BE1D  F0 02     BEQ $be21
BE1F  10 0E     BPL $be2f
BE21  20 E2 BA  JSR $bae2
BE24  C6 5D     DEC $5d
BE26  D0 EE     BNE $be16
BE28  20 FE BA  JSR $bafe
BE2B  E6 5D     INC $5d
BE2D  D0 DC     BNE $be0b
BE2F  20 49 B8  JSR $b849
BE32  20 9B BC  JSR $bc9b
BE35  A2 01     LDX #$01
BE37  A5 5D     LDA $5d
BE39  18        CLC
BE3A  69 0A     ADC #$0a
BE3C  30 09     BMI $be47
BE3E  C9 0B     CMP #$0b
BE40  B0 06     BCS $be48
BE42  69 FF     ADC #$ff
BE44  AA        TAX
BE45  A9 02     LDA #$02
BE47  38        SEC
BE48  E9 02     SBC #$02
BE4A  85 5E     STA $5e
BE4C  86 5D     STX $5d
BE4E  8A        TXA
BE4F  F0 02     BEQ $be53
BE51  10 13     BPL $be66
BE53  A4 71     LDY $71
BE55  A9 2E     LDA #$2e
BE57  C8        INY
BE58  99 FF 00  STA $00ff,Y
BE5B  8A        TXA
BE5C  F0 06     BEQ $be64
BE5E  A9 30     LDA #$30
BE60  C8        INY
BE61  99 FF 00  STA $00ff,Y
BE64  84 71     STY $71
BE66  A0 00     LDY #$00
BE68  A2 80     LDX #$80
BE6A  A5 65     LDA $65
BE6C  18        CLC
BE6D  79 19 BF  ADC $bf19,Y
BE70  85 65     STA $65
BE72  A5 64     LDA $64
BE74  79 18 BF  ADC $bf18,Y
BE77  85 64     STA $64
BE79  A5 63     LDA $63
BE7B  79 17 BF  ADC $bf17,Y
BE7E  85 63     STA $63
BE80  A5 62     LDA $62
BE82  79 16 BF  ADC $bf16,Y
BE85  85 62     STA $62
BE87  E8        INX
BE88  B0 04     BCS $be8e
BE8A  10 DE     BPL $be6a
BE8C  30 02     BMI $be90
BE8E  30 DA     BMI $be6a
BE90  8A        TXA
BE91  90 04     BCC $be97
BE93  49 FF     EOR #$ff
BE95  69 0A     ADC #$0a
BE97  69 2F     ADC #$2f
BE99  C8        INY
BE9A  C8        INY
BE9B  C8        INY
BE9C  C8        INY
BE9D  84 47     STY $47
BE9F  A4 71     LDY $71
BEA1  C8        INY
BEA2  AA        TAX
BEA3  29 7F     AND #$7f
BEA5  99 FF 00  STA $00ff,Y
BEA8  C6 5D     DEC $5d
BEAA  D0 06     BNE $beb2
BEAC  A9 2E     LDA #$2e
BEAE  C8        INY
BEAF  99 FF 00  STA $00ff,Y
BEB2  84 71     STY $71
BEB4  A4 47     LDY $47
BEB6  8A        TXA
BEB7  49 FF     EOR #$ff
BEB9  29 80     AND #$80
BEBB  AA        TAX
BEBC  C0 24     CPY #$24
BEBE  F0 04     BEQ $bec4
BEC0  C0 3C     CPY #$3c
BEC2  D0 A6     BNE $be6a
BEC4  A4 71     LDY $71
BEC6  B9 FF 00  LDA $00ff,Y
BEC9  88        DEY
BECA  C9 30     CMP #$30
BECC  F0 F8     BEQ $bec6
BECE  C9 2E     CMP #$2e
BED0  F0 01     BEQ $bed3
BED2  C8        INY
BED3  A9 2B     LDA #$2b
BED5  A6 5E     LDX $5e
BED7  F0 2E     BEQ $bf07
BED9  10 08     BPL $bee3
BEDB  A9 00     LDA #$00
BEDD  38        SEC
BEDE  E5 5E     SBC $5e
BEE0  AA        TAX
BEE1  A9 2D     LDA #$2d
BEE3  99 01 01  STA $0101,Y
BEE6  A9 45     LDA #$45
BEE8  99 00 01  STA $0100,Y
BEEB  8A        TXA
BEEC  A2 2F     LDX #$2f
BEEE  38        SEC
BEEF  E8        INX
BEF0  E9 0A     SBC #$0a
BEF2  B0 FB     BCS $beef
BEF4  69 3A     ADC #$3a
BEF6  99 03 01  STA $0103,Y
BEF9  8A        TXA
BEFA  99 02 01  STA $0102,Y
BEFD  A9 00     LDA #$00
BEFF  99 04 01  STA $0104,Y
BF02  F0 08     BEQ $bf0c
BF04  99 FF 00  STA $00ff,Y
BF07  A9 00     LDA #$00
BF09  99 00 01  STA $0100,Y
BF0C  A9 00     LDA #$00
BF0E  A0 01     LDY #$01
BF10  60        RTS
BF11  80        ???
BF12  00        BRK
BF13  00        BRK
BF14  00        BRK
BF15  00        BRK
BF16  FA        ???
BF17  0A        ASL A
BF18  1F        ???
BF19  00        BRK
BF1A  00        BRK
BF1B  98        TYA
BF1C  96 80     STX $80,Y
BF1E  FF        ???
BF1F  F0 BD     BEQ $bede
BF21  C0 00     CPY #$00
BF23  01 86     ORA ($86,X)
BF25  A0 FF     LDY #$ff
BF27  FF        ???
BF28  D8        CLD
BF29  F0 00     BEQ $bf2b
BF2B  00        BRK
BF2C  03        ???
BF2D  E8        INX
BF2E  FF        ???
BF2F  FF        ???
BF30  FF        ???
BF31  9C        ???
BF32  00        BRK
BF33  00        BRK
BF34  00        BRK
BF35  0A        ASL A
BF36  FF        ???
BF37  FF        ???
BF38  FF        ???
BF39  FF        ???
BF3A  FF        ???
BF3B  DF        ???
BF3C  0A        ASL A
BF3D  80        ???
BF3E  00        BRK
BF3F  03        ???
BF40  4B        ???
BF41  C0 FF     CPY #$ff
BF43  FF        ???
BF44  73        ???
BF45  60        RTS
BF46  00        BRK
BF47  00        BRK
BF48  0E 10 FF  ASL $ff10
BF4B  FF        ???
BF4C  FD A8 00  SBC $00a8,X
BF4F  00        BRK
BF50  00        BRK
BF51  3C        ???
BF52  EC AA AA  CPX $aaaa
BF55  AA        TAX
BF56  AA        TAX
BF57  AA        TAX
BF58  AA        TAX
BF59  AA        TAX
BF5A  AA        TAX
BF5B  AA        TAX
BF5C  AA        TAX
BF5D  AA        TAX
BF5E  AA        TAX
BF5F  AA        TAX
BF60  AA        TAX
BF61  AA        TAX
BF62  AA        TAX
BF63  AA        TAX
BF64  AA        TAX
BF65  AA        TAX
BF66  AA        TAX
BF67  AA        TAX
BF68  AA        TAX
BF69  AA        TAX
BF6A  AA        TAX
BF6B  AA        TAX
BF6C  AA        TAX
BF6D  AA        TAX
BF6E  AA        TAX
BF6F  AA        TAX
BF70  AA        TAX
BF71  20 0C BC  JSR $bc0c
BF74  A9 11     LDA #$11
BF76  A0 BF     LDY #$bf
BF78  20 A2 BB  JSR $bba2
BF7B  F0 70     BEQ $bfed
BF7D  A5 69     LDA $69
BF7F  D0 03     BNE $bf84
BF81  4C F9 B8  JMP $b8f9
BF84  A2 4E     LDX #$4e
BF86  A0 00     LDY #$00
BF88  20 D4 BB  JSR $bbd4
BF8B  A5 6E     LDA $6e
BF8D  10 0F     BPL $bf9e
BF8F  20 CC BC  JSR $bccc
BF92  A9 4E     LDA #$4e
BF94  A0 00     LDY #$00
BF96  20 5B BC  JSR $bc5b
BF99  D0 03     BNE $bf9e
BF9B  98        TYA
BF9C  A4 07     LDY $07
BF9E  20 FE BB  JSR $bbfe
BFA1  98        TYA
BFA2  48        PHA
BFA3  20 EA B9  JSR $b9ea
BFA6  A9 4E     LDA #$4e
BFA8  A0 00     LDY #$00
BFAA  20 28 BA  JSR $ba28
BFAD  20 ED BF  JSR $bfed
BFB0  68        PLA
BFB1  4A        LSR A
BFB2  90 0A     BCC $bfbe
BFB4  A5 61     LDA $61
BFB6  F0 06     BEQ $bfbe
BFB8  A5 66     LDA $66
BFBA  49 FF     EOR #$ff
BFBC  85 66     STA $66
BFBE  60        RTS
BFBF  81 38     STA ($38,X)
BFC1  AA        TAX
BFC2  3B        ???
BFC3  29 07     AND #$07
BFC5  71 34     ADC ($34),Y
BFC7  58        CLI
BFC8  3E 56 74  ROL $7456,X
BFCB  16 7E     ASL $7e,X
BFCD  B3        ???
BFCE  1B        ???
BFCF  77        ???
BFD0  2F        ???
BFD1  EE E3 85  INC $85e3
BFD4  7A        ???
BFD5  1D 84 1C  ORA $1c84,X
BFD8  2A        ROL A
BFD9  7C        ???
BFDA  63        ???
BFDB  59 58 0A  EOR $0a58,Y
BFDE  7E 75 FD  ROR $fd75,X
BFE1  E7        ???
BFE2  C6 80     DEC $80
BFE4  31 72     AND ($72),Y
BFE6  18        CLC
BFE7  10 81     BPL $bf6a
BFE9  00        BRK
BFEA  00        BRK
BFEB  00        BRK
BFEC  00        BRK
BFED  A9 BF     LDA #$bf
BFEF  A0 BF     LDY #$bf
BFF1  20 28 BA  JSR $ba28
BFF4  A5 70     LDA $70
BFF6  69 50     ADC #$50
BFF8  90 03     BCC $bffd
BFFA  20 23 BC  JSR $bc23
BFFD  4C 00 E0  JMP $e000
