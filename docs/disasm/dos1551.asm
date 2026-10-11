; 1551 DOS ROM 318008-01 ($C000-$FFFF) - linear disassembly (py65; data tables appear as bogus code)
; TCBM host side: TPI 6525 at $4000 (PA data, PB, PC handshake). Command handlers: jump table at $C046 (index = PA & $0F),
; main loop $EABD, $81 -> $C071 (LISTEN/TALK/UNLISTEN/UNTALK), $82 -> $C0D6 (secondary), $83 -> $C0F6 (data), $84 -> $C14E (receive)

C000  BE 44 41     LDX $4144,Y
C003  56 49        LSR $49,X
C005  44           ???
C006  20 47 20     JSR $2047
C009  53           ???
C00A  49 52        EOR #$52
C00C  41 43        EOR ($43,X)
C00E  55 53        EOR $53,X
C010  41 20        EOR ($20,X)
C012  43           ???
C013  42           ???
C014  4D 20 43     EOR $4320
C017  4F           ???
C018  50 59        BVC $c073
C01A  52           ???
C01B  49 47        EOR #$47
C01D  48           PHA
C01E  54           ???
C01F  20 38 34     JSR $3438
C022  AD 00 40     LDA $4000
C025  CD 00 40     CMP $4000
C028  F0 03        BEQ $c02d
C02A  4C BD EA     JMP $eabd
C02D  29 0F        AND #$0f
C02F  0A           ASL A
C030  A8           TAY
C031  B9 46 C0     LDA $c046,Y
C034  85 6E        STA $6e
C036  B9 47 C0     LDA $c047,Y
C039  85 6F        STA $6f
C03B  AD 02 40     LDA $4002
C03E  29 F7        AND #$f7
C040  8D 02 40     STA $4002
C043  6C 6E 00     JMP ($006e)
C046  66 C0        ROR $c0
C048  71 C0        ADC ($c0),Y
C04A  D6 C0        DEC $c0,X
C04C  F6 C0        INC $c0,X
C04E  4E C1 66     LSR $66c1
C051  C0 66        CPY #$66
C053  C0 66        CPY #$66
C055  C0 66        CPY #$66
C057  C0 66        CPY #$66
C059  C0 66        CPY #$66
C05B  C0 66        CPY #$66
C05D  C0 66        CPY #$66
C05F  C0 66        CPY #$66
C061  C0 66        CPY #$66
C063  C0 66        CPY #$66
C065  C0 AD        CPY #$ad
C067  02           ???
C068  40           RTI
C069  09 08        ORA #$08
C06B  8D 02 40     STA $4002
C06E  4C BD EA     JMP $eabd
C071  AD 02 40     LDA $4002
C074  30 FB        BMI $c071
C076  AD 00 40     LDA $4000
C079  48           PHA
C07A  A5 58        LDA $58
C07C  10 0D        BPL $c08b
C07E  A9 00        LDA #$00
C080  85 95        STA $95
C082  A5 59        LDA $59
C084  20 F6 C0     JSR $c0f6
C087  A9 00        LDA #$00
C089  85 58        STA $58
C08B  68           PLA
C08C  BA           TSX
C08D  86 5A        STX $5a
C08F  A2 00        LDX #$00
C091  85 8F        STA $8f
C093  A8           TAY
C094  29 60        AND #$60
C096  C9 40        CMP #$40
C098  F0 0E        BEQ $c0a8
C09A  C9 20        CMP #$20
C09C  F0 22        BEQ $c0c0
C09E  A0 00        LDY #$00
C0A0  A2 03        LDX #$03
C0A2  86 6E        STX $6e
C0A4  78           SEI
C0A5  4C 84 E9     JMP $e984
C0A8  86 5B        STX $5b
C0AA  98           TYA
C0AB  C9 5F        CMP #$5f
C0AD  F0 0D        BEQ $c0bc
C0AF  85 5B        STA $5b
C0B1  86 5C        STX $5c
C0B3  A9 20        LDA #$20
C0B5  85 7C        STA $7c
C0B7  85 7D        STA $7d
C0B9  4C 33 C1     JMP $c133
C0BC  A9 00        LDA #$00
C0BE  F0 75        BEQ $c135
C0C0  98           TYA
C0C1  C9 3F        CMP #$3f
C0C3  D0 0A        BNE $c0cf
C0C5  A9 FF        LDA #$ff
C0C7  85 95        STA $95
C0C9  A2 00        LDX #$00
C0CB  86 5C        STX $5c
C0CD  F0 ED        BEQ $c0bc
C0CF  85 5C        STA $5c
C0D1  86 5B        STX $5b
C0D3  4C B3 C0     JMP $c0b3
C0D6  AD 02 40     LDA $4002
C0D9  30 FB        BMI $c0d6
C0DB  BA           TSX
C0DC  86 5A        STX $5a
C0DE  AD 00 40     LDA $4000
C0E1  85 7D        STA $7d
C0E3  A8           TAY
C0E4  29 0F        AND #$0f
C0E6  85 7C        STA $7c
C0E8  98           TYA
C0E9  29 F0        AND #$f0
C0EB  C9 E0        CMP #$e0
C0ED  D0 03        BNE $c0f2
C0EF  20 F7 DB     JSR $dbf7
C0F2  A9 00        LDA #$00
C0F4  F0 3F        BEQ $c135
C0F6  AD 02 40     LDA $4002
C0F9  30 FB        BMI $c0f6
C0FB  BA           TSX
C0FC  86 5A        STX $5a
C0FE  AD 00 40     LDA $4000
C101  48           PHA
C102  A5 58        LDA $58
C104  10 24        BPL $c12a
C106  A5 59        LDA $59
C108  85 7E        STA $7e
C10A  20 17 D2     JSR $d217
C10D  B0 05        BCS $c114
C10F  B5 F3        LDA $f3,X
C111  6A           ROR A
C112  B0 13        BCS $c127
C114  A5 7D        LDA $7d
C116  29 F0        AND #$f0
C118  C9 F0        CMP #$f0
C11A  F0 0B        BEQ $c127
C11C  A5 7C        LDA $7c
C11E  C9 01        CMP #$01
C120  F0 0E        BEQ $c130
C122  68           PLA
C123  A9 02        LDA #$02
C125  D0 0E        BNE $c135
C127  20 D3 D0     JSR $d0d3
C12A  A5 58        LDA $58
C12C  09 80        ORA #$80
C12E  85 58        STA $58
C130  68           PLA
C131  85 59        STA $59
C133  A9 00        LDA #$00
C135  29 03        AND #$03
C137  09 08        ORA #$08
C139  85 97        STA $97
C13B  AD 02 40     LDA $4002
C13E  05 97        ORA $97
C140  8D 02 40     STA $4002
C143  AD 02 40     LDA $4002
C146  10 FB        BPL $c143
C148  29 FC        AND #$fc
C14A  8D 02 40     STA $4002
C14D  60           RTS
C14E  AD 02 40     LDA $4002
C151  30 FB        BMI $c14e
C153  A9 FF        LDA #$ff
C155  8D 03 40     STA $4003
C158  BA           TSX
C159  86 5A        STX $5a
C15B  A5 7C        LDA $7c
C15D  C9 13        CMP #$13
C15F  90 02        BCC $c163
C161  29 0F        AND #$0f
C163  C9 0F        CMP #$0f
C165  D0 02        BNE $c169
C167  A9 10        LDA #$10
C169  AA           TAX
C16A  38           SEC
C16B  BD 2B 02     LDA $022b,X
C16E  30 06        BMI $c176
C170  29 0F        AND #$0f
C172  85 7B        STA $7b
C174  AA           TAX
C175  18           CLC
C176  B0 06        BCS $c17e
C178  A6 7B        LDX $7b
C17A  B5 F3        LDA $f3,X
C17C  30 0B        BMI $c189
C17E  A9 0D        LDA #$0d
C180  8D 00 40     STA $4000
C183  A9 0A        LDA #$0a
C185  85 97        STA $97
C187  D0 1E        BNE $c1a7
C189  BD 3E 02     LDA $023e,X
C18C  8D 00 40     STA $4000
C18F  B5 F3        LDA $f3,X
C191  29 08        AND #$08
C193  49 08        EOR #$08
C195  0A           ASL A
C196  0A           ASL A
C197  0A           ASL A
C198  48           PHA
C199  20 F9 D4     JSR $d4f9
C19C  68           PLA
C19D  C9 40        CMP #$40
C19F  D0 02        BNE $c1a3
C1A1  A9 03        LDA #$03
C1A3  09 08        ORA #$08
C1A5  85 97        STA $97
C1A7  AD 02 40     LDA $4002
C1AA  29 FC        AND #$fc
C1AC  05 97        ORA $97
C1AE  8D 02 40     STA $4002
C1B1  AD 02 40     LDA $4002
C1B4  10 FB        BPL $c1b1
C1B6  A2 00        LDX #$00
C1B8  8E 03 40     STX $4003
C1BB  29 F7        AND #$f7
C1BD  8D 02 40     STA $4002
C1C0  AD 02 40     LDA $4002
C1C3  30 FB        BMI $c1c0
C1C5  09 08        ORA #$08
C1C7  29 FC        AND #$fc
C1C9  8D 02 40     STA $4002
C1CC  60           RTS
C1CD  A2 0D        LDX #$0d
C1CF  8E 00 40     STX $4000
C1D2  A9 0A        LDA #$0a
C1D4  85 97        STA $97
C1D6  D0 CF        BNE $c1a7
C1D8  A9 01        LDA #$01
C1DA  4C 35 C1     JMP $c135
C1DD  AE 74 02     LDX $0274
C1E0  CA           DEX
C1E1  F0 18        BEQ $c1fb
C1E3  AD 01 02     LDA $0201
C1E6  A8           TAY
C1E7  C9 52        CMP #$52
C1E9  F0 35        BEQ $c220
C1EB  C9 53        CMP #$53
C1ED  F0 31        BEQ $c220
C1EF  C9 39        CMP #$39
C1F1  F0 15        BEQ $c208
C1F3  C9 38        CMP #$38
C1F5  D0 0C        BNE $c203
C1F7  A2 08        LDX #$08
C1F9  D0 0F        BNE $c20a
C1FB  A5 66        LDA $66
C1FD  C9 08        CMP #$08
C1FF  F0 07        BEQ $c208
C201  D0 F4        BNE $c1f7
C203  A9 31        LDA #$31
C205  4C B2 C2     JMP $c2b2
C208  A2 09        LDX #$09
C20A  86 66        STX $66
C20C  8A           TXA
C20D  0A           ASL A
C20E  0A           ASL A
C20F  29 04        AND #$04
C211  49 04        EOR #$04
C213  85 97        STA $97
C215  AD 02 40     LDA $4002
C218  29 FB        AND #$fb
C21A  05 97        ORA $97
C21C  8D 02 40     STA $4002
C21F  60           RTS
C220  CA           DEX
C221  F0 E0        BEQ $c203
C223  A2 01        LDX #$01
C225  AD 02 02     LDA $0202
C228  C0 52        CPY #$52
C22A  F0 01        BEQ $c22d
C22C  CA           DEX
C22D  95 68        STA $68,X
C22F  60           RTS
C230  A9 00        LDA #$00
C232  8D F9 02     STA $02f9
C235  AD 8E 02     LDA $028e
C238  85 78        STA $78
C23A  20 FB E7     JSR $e7fb
C23D  A5 7D        LDA $7d
C23F  10 09        BPL $c24a
C241  29 0F        AND #$0f
C243  C9 0F        CMP #$0f
C245  F0 03        BEQ $c24a
C247  4C EE D8     JMP $d8ee
C24A  20 9D C3     JSR $c39d
C24D  B1 A4        LDA ($a4),Y
C24F  8D 75 02     STA $0275
C252  A2 0C        LDX #$0c
C254  BD C7 F0     LDA $f0c7,X
C257  CD 75 02     CMP $0275
C25A  F0 08        BEQ $c264
C25C  CA           DEX
C25D  10 F5        BPL $c254
C25F  A9 31        LDA #$31
C261  4C B2 C2     JMP $c2b2
C264  8E 2A 02     STX $022a
C267  E0 0A        CPX #$0a
C269  90 03        BCC $c26e
C26B  20 D8 C2     JSR $c2d8
C26E  AE 2A 02     LDX $022a
C271  BD D4 F0     LDA $f0d4,X
C274  85 6E        STA $6e
C276  BD E1 F0     LDA $f0e1,X
C279  85 6F        STA $6f
C27B  6C 6E 00     JMP ($006e)
C27E  A9 00        LDA #$00
C280  8D F9 02     STA $02f9
C283  AD 6C 02     LDA $026c
C286  D0 2A        BNE $c2b2
C288  A0 00        LDY #$00
C28A  98           TYA
C28B  84 79        STY $79
C28D  84 7A        STY $7a
C28F  84 A4        STY $a4
C291  20 06 E8     JSR $e806
C294  20 F0 F3     JSR $f3f0
C297  A5 78        LDA $78
C299  8D 8E 02     STA $028e
C29C  AA           TAX
C29D  A9 00        LDA #$00
C29F  95 5F        STA $5f,X
C2A1  20 A7 C2     JSR $c2a7
C2A4  4C 2D D6     JMP $d62d
C2A7  A0 28        LDY #$28
C2A9  A9 00        LDA #$00
C2AB  99 00 02     STA $0200,Y
C2AE  88           DEY
C2AF  10 FA        BPL $c2ab
C2B1  60           RTS
C2B2  A0 00        LDY #$00
C2B4  84 79        STY $79
C2B6  84 7A        STY $7a
C2B8  4C 81 E7     JMP $e781
C2BB  A2 00        LDX #$00
C2BD  8E 7A 02     STX $027a
C2C0  A9 3A        LDA #$3a
C2C2  20 52 C3     JSR $c352
C2C5  F0 05        BEQ $c2cc
C2C7  88           DEY
C2C8  88           DEY
C2C9  8C 7A 02     STY $027a
C2CC  4C 52 C4     JMP $c452
C2CF  A0 00        LDY #$00
C2D1  A2 00        LDX #$00
C2D3  A9 3A        LDA #$3a
C2D5  4C 52 C3     JMP $c352
C2D8  20 CF C2     JSR $c2cf
C2DB  D0 05        BNE $c2e2
C2DD  A9 34        LDA #$34
C2DF  4C B2 C2     JMP $c2b2
C2E2  88           DEY
C2E3  88           DEY
C2E4  8C 7A 02     STY $027a
C2E7  8A           TXA
C2E8  D0 F3        BNE $c2dd
C2EA  A9 3D        LDA #$3d
C2EC  20 52 C3     JSR $c352
C2EF  8A           TXA
C2F0  F0 02        BEQ $c2f4
C2F2  A9 40        LDA #$40
C2F4  09 21        ORA #$21
C2F6  8D 8B 02     STA $028b
C2F9  E8           INX
C2FA  8E 77 02     STX $0277
C2FD  8E 78 02     STX $0278
C300  AD 8A 02     LDA $028a
C303  F0 0D        BEQ $c312
C305  A9 80        LDA #$80
C307  0D 8B 02     ORA $028b
C30A  8D 8B 02     STA $028b
C30D  A9 00        LDA #$00
C30F  8D 8A 02     STA $028a
C312  98           TYA
C313  F0 29        BEQ $c33e
C315  9D 7A 02     STA $027a,X
C318  AD 77 02     LDA $0277
C31B  8D 79 02     STA $0279
C31E  A9 8D        LDA #$8d
C320  20 52 C3     JSR $c352
C323  E8           INX
C324  8E 78 02     STX $0278
C327  CA           DEX
C328  AD 8A 02     LDA $028a
C32B  F0 02        BEQ $c32f
C32D  A9 08        LDA #$08
C32F  EC 77 02     CPX $0277
C332  F0 02        BEQ $c336
C334  09 04        ORA #$04
C336  09 03        ORA #$03
C338  4D 8B 02     EOR $028b
C33B  8D 8B 02     STA $028b
C33E  AD 8B 02     LDA $028b
C341  AE 2A 02     LDX $022a
C344  3D E5 F0     AND $f0e5,X
C347  D0 01        BNE $c34a
C349  60           RTS
C34A  8D 6C 02     STA $026c
C34D  A9 30        LDA #$30
C34F  4C B2 C2     JMP $c2b2
C352  8D 75 02     STA $0275
C355  CC 74 02     CPY $0274
C358  B0 2E        BCS $c388
C35A  B1 A4        LDA ($a4),Y
C35C  C8           INY
C35D  CD 75 02     CMP $0275
C360  F0 28        BEQ $c38a
C362  C9 2A        CMP #$2a
C364  F0 04        BEQ $c36a
C366  C9 3F        CMP #$3f
C368  D0 03        BNE $c36d
C36A  EE 8A 02     INC $028a
C36D  C9 2C        CMP #$2c
C36F  D0 E4        BNE $c355
C371  98           TYA
C372  9D 7B 02     STA $027b,X
C375  AD 8A 02     LDA $028a
C378  29 7F        AND #$7f
C37A  F0 07        BEQ $c383
C37C  A9 80        LDA #$80
C37E  95 E8        STA $e8,X
C380  8D 8A 02     STA $028a
C383  E8           INX
C384  E0 04        CPX #$04
C386  90 CD        BCC $c355
C388  A0 00        LDY #$00
C38A  AD 74 02     LDA $0274
C38D  9D 7B 02     STA $027b,X
C390  AD 8A 02     LDA $028a
C393  29 7F        AND #$7f
C395  F0 04        BEQ $c39b
C397  A9 80        LDA #$80
C399  95 E8        STA $e8,X
C39B  98           TYA
C39C  60           RTS
C39D  A4 A4        LDY $a4
C39F  F0 14        BEQ $c3b5
C3A1  88           DEY
C3A2  F0 10        BEQ $c3b4
C3A4  B9 00 02     LDA $0200,Y
C3A7  C9 0D        CMP #$0d
C3A9  F0 0A        BEQ $c3b5
C3AB  88           DEY
C3AC  B9 00 02     LDA $0200,Y
C3AF  C9 0D        CMP #$0d
C3B1  F0 02        BEQ $c3b5
C3B3  C8           INY
C3B4  C8           INY
C3B5  8C 74 02     STY $0274
C3B8  C0 2A        CPY #$2a
C3BA  A0 FF        LDY #$ff
C3BC  90 08        BCC $c3c6
C3BE  8C 2A 02     STY $022a
C3C1  A9 32        LDA #$32
C3C3  4C B2 C2     JMP $c2b2
C3C6  A0 00        LDY #$00
C3C8  98           TYA
C3C9  85 A4        STA $a4
C3CB  8D 58 02     STA $0258
C3CE  8D 4A 02     STA $024a
C3D1  8D 96 02     STA $0296
C3D4  85 99        STA $99
C3D6  8D 79 02     STA $0279
C3D9  8D 77 02     STA $0277
C3DC  8D 78 02     STA $0278
C3DF  8D 8A 02     STA $028a
C3E2  8D 6C 02     STA $026c
C3E5  A2 05        LDX #$05
C3E7  9D 79 02     STA $0279,X
C3EA  95 D8        STA $d8,X
C3EC  95 DD        STA $dd,X
C3EE  95 E2        STA $e2,X
C3F0  95 E7        STA $e7,X
C3F2  9D 7F 02     STA $027f,X
C3F5  9D 84 02     STA $0284,X
C3F8  CA           DEX
C3F9  D0 EC        BNE $c3e7
C3FB  60           RTS
C3FC  AD 78 02     LDA $0278
C3FF  8D 77 02     STA $0277
C402  A9 01        LDA #$01
C404  8D 78 02     STA $0278
C407  8D 79 02     STA $0279
C40A  AC 8E 02     LDY $028e
C40D  A2 00        LDX #$00
C40F  86 99        STX $99
C411  BD 7A 02     LDA $027a,X
C414  20 26 C4     JSR $c426
C417  A6 99        LDX $99
C419  9D 7A 02     STA $027a,X
C41C  98           TYA
C41D  95 E3        STA $e3,X
C41F  E8           INX
C420  EC 78 02     CPX $0278
C423  90 EA        BCC $c40f
C425  60           RTS
C426  AA           TAX
C427  A0 00        LDY #$00
C429  A9 3A        LDA #$3a
C42B  DD 01 02     CMP $0201,X
C42E  F0 0C        BEQ $c43c
C430  DD 00 02     CMP $0200,X
C433  D0 01        BNE $c436
C435  E8           INX
C436  98           TYA
C437  29 01        AND #$01
C439  A8           TAY
C43A  8A           TXA
C43B  60           RTS
C43C  BD 00 02     LDA $0200,X
C43F  E8           INX
C440  E8           INX
C441  C9 30        CMP #$30
C443  F0 F2        BEQ $c437
C445  C9 31        CMP #$31
C447  F0 69        BEQ $c4b2
C449  D0 EB        BNE $c436
C44B  98           TYA
C44C  09 80        ORA #$80
C44E  29 81        AND #$81
C450  D0 E7        BNE $c439
C452  A9 00        LDA #$00
C454  8D 8B 02     STA $028b
C457  AC 7A 02     LDY $027a
C45A  B1 A4        LDA ($a4),Y
C45C  20 A5 C4     JSR $c4a5
C45F  10 11        BPL $c472
C461  C8           INY
C462  CC 74 02     CPY $0274
C465  B0 06        BCS $c46d
C467  AC 74 02     LDY $0274
C46A  88           DEY
C46B  D0 ED        BNE $c45a
C46D  CE 8B 02     DEC $028b
C470  A9 00        LDA #$00
C472  29 01        AND #$01
C474  85 78        STA $78
C476  60           RTS
C477  A5 78        LDA $78
C479  49 01        EOR #$01
C47B  29 01        AND #$01
C47D  85 78        STA $78
C47F  60           RTS
C480  A0 00        LDY #$00
C482  AD 77 02     LDA $0277
C485  CD 78 02     CMP $0278
C488  F0 16        BEQ $c4a0
C48A  CE 78 02     DEC $0278
C48D  AC 78 02     LDY $0278
C490  B9 7A 02     LDA $027a,Y
C493  A8           TAY
C494  B1 A4        LDA ($a4),Y
C496  A0 04        LDY #$04
C498  D9 FC F0     CMP $f0fc,Y
C49B  F0 03        BEQ $c4a0
C49D  88           DEY
C49E  D0 F8        BNE $c498
C4A0  98           TYA
C4A1  8D 96 02     STA $0296
C4A4  60           RTS
C4A5  C9 30        CMP #$30
C4A7  F0 06        BEQ $c4af
C4A9  C9 31        CMP #$31
C4AB  F0 05        BEQ $c4b2
C4AD  09 80        ORA #$80
C4AF  29 81        AND #$81
C4B1  60           RTS
C4B2  A9 31        LDA #$31
C4B4  4C B2 C2     JMP $c2b2
C4B7  A9 00        LDA #$00
C4B9  85 6E        STA $6e
C4BB  8D 8D 02     STA $028d
C4BE  48           PHA
C4BF  AE 78 02     LDX $0278
C4C2  68           PLA
C4C3  05 6E        ORA $6e
C4C5  48           PHA
C4C6  A9 01        LDA #$01
C4C8  85 6E        STA $6e
C4CA  CA           DEX
C4CB  30 0F        BMI $c4dc
C4CD  B5 E3        LDA $e3,X
C4CF  10 04        BPL $c4d5
C4D1  06 6E        ASL $6e
C4D3  06 6E        ASL $6e
C4D5  4A           LSR A
C4D6  90 EA        BCC $c4c2
C4D8  06 6E        ASL $6e
C4DA  D0 E6        BNE $c4c2
C4DC  68           PLA
C4DD  AA           TAX
C4DE  BD 2A C5     LDA $c52a,X
C4E1  48           PHA
C4E2  29 03        AND #$03
C4E4  8D 8C 02     STA $028c
C4E7  68           PLA
C4E8  0A           ASL A
C4E9  10 3C        BPL $c527
C4EB  A5 E3        LDA $e3
C4ED  29 01        AND #$01
C4EF  85 78        STA $78
C4F1  AD 8C 02     LDA $028c
C4F4  F0 2B        BEQ $c521
C4F6  20 22 C7     JSR $c722
C4F9  F0 12        BEQ $c50d
C4FB  20 77 C4     JSR $c477
C4FE  A9 00        LDA #$00
C500  8D 8C 02     STA $028c
C503  20 22 C7     JSR $c722
C506  F0 1E        BEQ $c526
C508  A9 74        LDA #$74
C50A  20 B2 C2     JSR $c2b2
C50D  20 77 C4     JSR $c477
C510  20 22 C7     JSR $c722
C513  08           PHP
C514  20 77 C4     JSR $c477
C517  28           PLP
C518  F0 0C        BEQ $c526
C51A  A9 00        LDA #$00
C51C  8D 8C 02     STA $028c
C51F  F0 05        BEQ $c526
C521  20 22 C7     JSR $c722
C524  D0 E2        BNE $c508
C526  60           RTS
C527  2A           ROL A
C528  4C ED C4     JMP $c4ed
C52B  00           BRK
C52C  80           ???
C52D  41 01        EOR ($01,X)
C52F  01 01        ORA ($01,X)
C531  01 81        ORA ($81,X)
C533  81 81        STA ($81,X)
C535  81 42        STA ($42,X)
C537  42           ???
C538  42           ???
C539  42           ???
C53A  20 B7 C4     JSR $c4b7
C53D  A9 00        LDA #$00
C53F  8D 92 02     STA $0292
C542  20 91 C6     JSR $c691
C545  D0 16        BNE $c55d
C547  CE 8C 02     DEC $028c
C54A  10 01        BPL $c54d
C54C  60           RTS
C54D  A9 01        LDA #$01
C54F  8D 8D 02     STA $028d
C552  20 77 C4     JSR $c477
C555  4C 3D C5     JMP $c53d
C558  20 FC C6     JSR $c6fc
C55B  F0 10        BEQ $c56d
C55D  20 BD C5     JSR $c5bd
C560  AD 8F 02     LDA $028f
C563  F0 01        BEQ $c566
C565  60           RTS
C566  AD 53 02     LDA $0253
C569  30 ED        BMI $c558
C56B  10 F0        BPL $c55d
C56D  AD 8F 02     LDA $028f
C570  F0 D5        BEQ $c547
C572  60           RTS
C573  20 E9 C6     JSR $c6e9
C576  F0 17        BEQ $c58f
C578  D0 25        BNE $c59f
C57A  A9 01        LDA #$01
C57C  8D 8D 02     STA $028d
C57F  20 77 C4     JSR $c477
C582  A9 00        LDA #$00
C584  8D 92 02     STA $0292
C587  20 91 C6     JSR $c691
C58A  D0 13        BNE $c59f
C58C  8D 8F 02     STA $028f
C58F  AD 8F 02     LDA $028f
C592  D0 28        BNE $c5bc
C594  CE 8C 02     DEC $028c
C597  10 E1        BPL $c57a
C599  60           RTS
C59A  20 FC C6     JSR $c6fc
C59D  F0 F0        BEQ $c58f
C59F  20 BD C5     JSR $c5bd
C5A2  AE 53 02     LDX $0253
C5A5  10 07        BPL $c5ae
C5A7  AD 8F 02     LDA $028f
C5AA  F0 EE        BEQ $c59a
C5AC  D0 0E        BNE $c5bc
C5AE  AD 96 02     LDA $0296
C5B1  F0 09        BEQ $c5bc
C5B3  B5 E8        LDA $e8,X
C5B5  29 07        AND #$07
C5B7  CD 96 02     CMP $0296
C5BA  D0 DE        BNE $c59a
C5BC  60           RTS
C5BD  A2 FF        LDX #$ff
C5BF  8E 53 02     STX $0253
C5C2  E8           INX
C5C3  8E 8A 02     STX $028a
C5C6  20 6E C6     JSR $c66e
C5C9  F0 06        BEQ $c5d1
C5CB  60           RTS
C5CC  20 79 C6     JSR $c679
C5CF  D0 FA        BNE $c5cb
C5D1  A5 78        LDA $78
C5D3  55 E3        EOR $e3,X
C5D5  4A           LSR A
C5D6  90 0B        BCC $c5e3
C5D8  29 40        AND #$40
C5DA  F0 F0        BEQ $c5cc
C5DC  A9 02        LDA #$02
C5DE  CD 8C 02     CMP $028c
C5E1  F0 E9        BEQ $c5cc
C5E3  BD 7A 02     LDA $027a,X
C5E6  AA           TAX
C5E7  20 87 C7     JSR $c787
C5EA  A0 03        LDY #$03
C5EC  4C 02 C6     JMP $c602
C5EF  BD 00 02     LDA $0200,X
C5F2  D1 8D        CMP ($8d),Y
C5F4  F0 0A        BEQ $c600
C5F6  C9 3F        CMP #$3f
C5F8  D0 D2        BNE $c5cc
C5FA  B1 8D        LDA ($8d),Y
C5FC  C9 A0        CMP #$a0
C5FE  F0 CC        BEQ $c5cc
C600  E8           INX
C601  C8           INY
C602  EC 76 02     CPX $0276
C605  B0 09        BCS $c610
C607  BD 00 02     LDA $0200,X
C60A  C9 2A        CMP #$2a
C60C  F0 0C        BEQ $c61a
C60E  D0 DF        BNE $c5ef
C610  C0 13        CPY #$13
C612  B0 06        BCS $c61a
C614  B1 8D        LDA ($8d),Y
C616  C9 A0        CMP #$a0
C618  D0 B2        BNE $c5cc
C61A  AE 79 02     LDX $0279
C61D  8E 53 02     STX $0253
C620  B5 E8        LDA $e8,X
C622  29 80        AND #$80
C624  8D 8A 02     STA $028a
C627  AD 94 02     LDA $0294
C62A  95 DE        STA $de,X
C62C  A5 7A        LDA $7a
C62E  95 D9        STA $d9,X
C630  A0 00        LDY #$00
C632  B1 8D        LDA ($8d),Y
C634  C8           INY
C635  48           PHA
C636  29 40        AND #$40
C638  85 6E        STA $6e
C63A  68           PLA
C63B  29 DF        AND #$df
C63D  30 02        BMI $c641
C63F  09 20        ORA #$20
C641  29 27        AND #$27
C643  05 6E        ORA $6e
C645  85 6E        STA $6e
C647  A9 80        LDA #$80
C649  35 E8        AND $e8,X
C64B  05 6E        ORA $6e
C64D  95 E8        STA $e8,X
C64F  B5 E3        LDA $e3,X
C651  29 80        AND #$80
C653  05 78        ORA $78
C655  95 E3        STA $e3,X
C657  B1 8D        LDA ($8d),Y
C659  9D 80 02     STA $0280,X
C65C  C8           INY
C65D  B1 8D        LDA ($8d),Y
C65F  9D 85 02     STA $0285,X
C662  AD 58 02     LDA $0258
C665  D0 07        BNE $c66e
C667  A0 15        LDY #$15
C669  B1 8D        LDA ($8d),Y
C66B  8D 58 02     STA $0258
C66E  A9 FF        LDA #$ff
C670  8D 8F 02     STA $028f
C673  AD 78 02     LDA $0278
C676  8D 79 02     STA $0279
C679  CE 79 02     DEC $0279
C67C  10 01        BPL $c67f
C67E  60           RTS
C67F  AE 79 02     LDX $0279
C682  B5 E8        LDA $e8,X
C684  30 05        BMI $c68b
C686  BD 80 02     LDA $0280,X
C689  D0 EE        BNE $c679
C68B  A9 00        LDA #$00
C68D  8D 8F 02     STA $028f
C690  60           RTS
C691  A0 00        LDY #$00
C693  8C 91 02     STY $0291
C696  88           DEY
C697  8C 53 02     STY $0253
C69A  AD C3 F0     LDA $f0c3
C69D  85 79        STA $79
C69F  A9 01        LDA #$01
C6A1  85 7A        STA $7a
C6A3  8D 93 02     STA $0293
C6A6  20 C8 D5     JSR $d5c8
C6A9  AD 93 02     LDA $0293
C6AC  D0 01        BNE $c6af
C6AE  60           RTS
C6AF  A9 07        LDA #$07
C6B1  8D 95 02     STA $0295
C6B4  A9 00        LDA #$00
C6B6  20 49 D6     JSR $d649
C6B9  8D 93 02     STA $0293
C6BC  20 3B D6     JSR $d63b
C6BF  CE 95 02     DEC $0295
C6C2  A0 00        LDY #$00
C6C4  B1 8D        LDA ($8d),Y
C6C6  D0 18        BNE $c6e0
C6C8  AD 91 02     LDA $0291
C6CB  D0 2F        BNE $c6fc
C6CD  20 76 DF     JSR $df76
C6D0  A5 7A        LDA $7a
C6D2  8D 91 02     STA $0291
C6D5  A5 8D        LDA $8d
C6D7  AE 92 02     LDX $0292
C6DA  8D 92 02     STA $0292
C6DD  F0 1D        BEQ $c6fc
C6DF  60           RTS
C6E0  A2 01        LDX #$01
C6E2  EC 92 02     CPX $0292
C6E5  D0 2D        BNE $c714
C6E7  F0 13        BEQ $c6fc
C6E9  AD C3 F0     LDA $f0c3
C6EC  85 79        STA $79
C6EE  AD 90 02     LDA $0290
C6F1  85 7A        STA $7a
C6F3  20 C8 D5     JSR $d5c8
C6F6  AD 94 02     LDA $0294
C6F9  20 1B D6     JSR $d61b
C6FC  A9 FF        LDA #$ff
C6FE  8D 53 02     STA $0253
C701  AD 95 02     LDA $0295
C704  30 08        BMI $c70e
C706  A9 20        LDA #$20
C708  20 1C D3     JSR $d31c
C70B  4C BC C6     JMP $c6bc
C70E  20 A0 D5     JSR $d5a0
C711  4C A9 C6     JMP $c6a9
C714  A5 8D        LDA $8d
C716  8D 94 02     STA $0294
C719  20 76 DF     JSR $df76
C71C  A5 7A        LDA $7a
C71E  8D 90 02     STA $0290
C721  60           RTS
C722  A6 78        LDX $78
C724  56 22        LSR $22,X
C726  90 22        BCC $c74a
C728  A9 FF        LDA #$ff
C72A  8D 98 02     STA $0298
C72D  20 2A D1     JSR $d12a
C730  A0 FF        LDY #$ff
C732  C9 02        CMP #$02
C734  F0 0A        BEQ $c740
C736  C9 03        CMP #$03
C738  F0 06        BEQ $c740
C73A  C9 0F        CMP #$0f
C73C  F0 02        BEQ $c740
C73E  A0 00        LDY #$00
C740  A6 78        LDX $78
C742  98           TYA
C743  95 5F        STA $5f,X
C745  D0 03        BNE $c74a
C747  20 5E D1     JSR $d15e
C74A  A6 78        LDX $78
C74C  B5 5F        LDA $5f,X
C74E  60           RTS
C74F  48           PHA
C750  20 87 C7     JSR $c787
C753  20 69 C7     JSR $c769
C756  68           PLA
C757  38           SEC
C758  ED 4B 02     SBC $024b
C75B  AA           TAX
C75C  F0 0A        BEQ $c768
C75E  90 08        BCC $c768
C760  A9 A0        LDA #$a0
C762  91 8D        STA ($8d),Y
C764  C8           INY
C765  CA           DEX
C766  D0 FA        BNE $c762
C768  60           RTS
C769  98           TYA
C76A  0A           ASL A
C76B  A8           TAY
C76C  B9 9A 00     LDA $009a,Y
C76F  85 8D        STA $8d
C771  B9 9B 00     LDA $009b,Y
C774  85 8E        STA $8e
C776  A0 00        LDY #$00
C778  BD 00 02     LDA $0200,X
C77B  91 8D        STA ($8d),Y
C77D  C8           INY
C77E  F0 06        BEQ $c786
C780  E8           INX
C781  EC 76 02     CPX $0276
C784  90 F2        BCC $c778
C786  60           RTS
C787  A9 00        LDA #$00
C789  8D 4B 02     STA $024b
C78C  8A           TXA
C78D  48           PHA
C78E  BD 00 02     LDA $0200,X
C791  C9 2C        CMP #$2c
C793  F0 14        BEQ $c7a9
C795  C9 3D        CMP #$3d
C797  F0 10        BEQ $c7a9
C799  EE 4B 02     INC $024b
C79C  E8           INX
C79D  A9 0F        LDA #$0f
C79F  CD 4B 02     CMP $024b
C7A2  90 05        BCC $c7a9
C7A4  EC 74 02     CPX $0274
C7A7  90 E5        BCC $c78e
C7A9  8E 76 02     STX $0276
C7AC  68           PLA
C7AD  AA           TAX
C7AE  60           RTS
C7AF  A5 7C        LDA $7c
C7B1  48           PHA
C7B2  A5 7B        LDA $7b
C7B4  48           PHA
C7B5  20 BF C7     JSR $c7bf
C7B8  68           PLA
C7B9  85 7B        STA $7b
C7BB  68           PLA
C7BC  85 7C        STA $7c
C7BE  60           RTS
C7BF  A9 11        LDA #$11
C7C1  85 7C        STA $7c
C7C3  20 FB D1     JSR $d1fb
C7C6  20 3B D6     JSR $d63b
C7C9  AD 53 02     LDA $0253
C7CC  10 0A        BPL $c7d8
C7CE  AD 8D 02     LDA $028d
C7D1  D0 0A        BNE $c7dd
C7D3  20 E7 C8     JSR $c8e7
C7D6  18           CLC
C7D7  60           RTS
C7D8  AD 8D 02     LDA $028d
C7DB  F0 1F        BEQ $c7fc
C7DD  CE 8D 02     DEC $028d
C7E0  D0 0D        BNE $c7ef
C7E2  CE 8D 02     DEC $028d
C7E5  20 77 C4     JSR $c477
C7E8  20 E7 C8     JSR $c8e7
C7EB  38           SEC
C7EC  4C 77 C4     JMP $c477
C7EF  A9 00        LDA #$00
C7F1  8D 73 02     STA $0273
C7F4  8D 8D 02     STA $028d
C7F7  20 98 C8     JSR $c898
C7FA  38           SEC
C7FB  60           RTS
C7FC  A2 18        LDX #$18
C7FE  A0 1D        LDY #$1d
C800  B1 8D        LDA ($8d),Y
C802  8D 73 02     STA $0273
C805  F0 02        BEQ $c809
C807  A2 16        LDX #$16
C809  88           DEY
C80A  B1 8D        LDA ($8d),Y
C80C  8D 72 02     STA $0272
C80F  E0 16        CPX #$16
C811  F0 0A        BEQ $c81d
C813  C9 0A        CMP #$0a
C815  90 06        BCC $c81d
C817  CA           DEX
C818  C9 64        CMP #$64
C81A  90 01        BCC $c81d
C81C  CA           DEX
C81D  20 8D C8     JSR $c88d
C820  B1 8D        LDA ($8d),Y
C822  48           PHA
C823  0A           ASL A
C824  10 05        BPL $c82b
C826  A9 3C        LDA #$3c
C828  9D B2 02     STA $02b2,X
C82B  68           PLA
C82C  29 0F        AND #$0f
C82E  A8           TAY
C82F  B9 06 F1     LDA $f106,Y
C832  9D B1 02     STA $02b1,X
C835  CA           DEX
C836  B9 01 F1     LDA $f101,Y
C839  9D B1 02     STA $02b1,X
C83C  CA           DEX
C83D  B9 FC F0     LDA $f0fc,Y
C840  9D B1 02     STA $02b1,X
C843  CA           DEX
C844  CA           DEX
C845  B0 05        BCS $c84c
C847  A9 2A        LDA #$2a
C849  9D B2 02     STA $02b2,X
C84C  A9 A0        LDA #$a0
C84E  9D B1 02     STA $02b1,X
C851  CA           DEX
C852  A0 12        LDY #$12
C854  B1 8D        LDA ($8d),Y
C856  9D B1 02     STA $02b1,X
C859  CA           DEX
C85A  88           DEY
C85B  C0 03        CPY #$03
C85D  B0 F5        BCS $c854
C85F  A9 22        LDA #$22
C861  9D B1 02     STA $02b1,X
C864  E8           INX
C865  E0 20        CPX #$20
C867  B0 0B        BCS $c874
C869  BD B1 02     LDA $02b1,X
C86C  C9 22        CMP #$22
C86E  F0 04        BEQ $c874
C870  C9 A0        CMP #$a0
C872  D0 F0        BNE $c864
C874  A9 22        LDA #$22
C876  9D B1 02     STA $02b1,X
C879  E8           INX
C87A  E0 20        CPX #$20
C87C  B0 0A        BCS $c888
C87E  A9 7F        LDA #$7f
C880  3D B1 02     AND $02b1,X
C883  9D B1 02     STA $02b1,X
C886  10 F1        BPL $c879
C888  20 9A C5     JSR $c59a
C88B  38           SEC
C88C  60           RTS
C88D  A0 1B        LDY #$1b
C88F  A9 20        LDA #$20
C891  99 B0 02     STA $02b0,Y
C894  88           DEY
C895  D0 FA        BNE $c891
C897  60           RTS
C898  20 84 EF     JSR $ef84
C89B  20 4A EF     JSR $ef4a
C89E  20 8D C8     JSR $c88d
C8A1  A9 FF        LDA #$ff
C8A3  85 6E        STA $6e
C8A5  A6 78        LDX $78
C8A7  8E 72 02     STX $0272
C8AA  A9 00        LDA #$00
C8AC  8D 73 02     STA $0273
C8AF  A6 98        LDX $98
C8B1  BD 23 F1     LDA $f123,X
C8B4  85 8E        STA $8e
C8B6  AD C6 F0     LDA $f0c6
C8B9  85 8D        STA $8d
C8BB  A0 16        LDY #$16
C8BD  B1 8D        LDA ($8d),Y
C8BF  C9 A0        CMP #$a0
C8C1  D0 0B        BNE $c8ce
C8C3  A9 31        LDA #$31
C8C5  2C B1 8D     BIT $8db1
C8C8  C9 A0        CMP #$a0
C8CA  D0 02        BNE $c8ce
C8CC  A9 20        LDA #$20
C8CE  99 B3 02     STA $02b3,Y
C8D1  88           DEY
C8D2  10 F2        BPL $c8c6
C8D4  A9 12        LDA #$12
C8D6  8D B1 02     STA $02b1
C8D9  A9 22        LDA #$22
C8DB  8D B2 02     STA $02b2
C8DE  8D C3 02     STA $02c3
C8E1  A9 20        LDA #$20
C8E3  8D C4 02     STA $02c4
C8E6  60           RTS
C8E7  20 8D C8     JSR $c88d
C8EA  A0 0B        LDY #$0b
C8EC  B9 F8 C8     LDA $c8f8,Y
C8EF  99 B1 02     STA $02b1,Y
C8F2  88           DEY
C8F3  10 F7        BPL $c8ec
C8F5  4C B8 ED     JMP $edb8
C8F8  42           ???
C8F9  4C 4F 43     JMP $434f
C8FC  4B           ???
C8FD  53           ???
C8FE  20 46 52     JSR $5246
C901  45 45        EOR $45
C903  2E 20 80     ROL $8020
C906  C4 20        CPY $20
C908  0A           ASL A
C909  C4 20        CPY $20
C90B  B7           ???
C90C  C4 A9        CPY $a9
C90E  00           BRK
C90F  85 7F        STA $7f
C911  20 82 C5     JSR $c582
C914  30 3D        BMI $c953
C916  20 F2 DE     JSR $def2
C919  90 33        BCC $c94e
C91B  A0 00        LDY #$00
C91D  B1 8D        LDA ($8d),Y
C91F  29 40        AND #$40
C921  D0 2B        BNE $c94e
C923  20 97 C9     JSR $c997
C926  A0 13        LDY #$13
C928  B1 8D        LDA ($8d),Y
C92A  F0 0A        BEQ $c936
C92C  85 79        STA $79
C92E  C8           INY
C92F  B1 8D        LDA ($8d),Y
C931  85 7A        STA $7a
C933  20 5E C9     JSR $c95e
C936  AE 53 02     LDX $0253
C939  A9 20        LDA #$20
C93B  35 E8        AND $e8,X
C93D  D0 0D        BNE $c94c
C93F  BD 80 02     LDA $0280,X
C942  85 79        STA $79
C944  BD 85 02     LDA $0285,X
C947  85 7A        STA $7a
C949  20 5E C9     JSR $c95e
C94C  E6 7F        INC $7f
C94E  20 73 C5     JSR $c573
C951  10 C3        BPL $c916
C953  A5 7F        LDA $7f
C955  85 79        STA $79
C957  A9 01        LDA #$01
C959  A0 00        LDY #$00
C95B  4C 8D C2     JMP $c28d
C95E  20 CA ED     JSR $edca
C961  20 C8 D5     JSR $d5c8
C964  20 84 EF     JSR $ef84
C967  B5 A8        LDA $a8,X
C969  C9 FF        CMP #$ff
C96B  F0 08        BEQ $c975
C96D  AD F9 02     LDA $02f9
C970  09 40        ORA #$40
C972  8D F9 02     STA $02f9
C975  A9 00        LDA #$00
C977  20 1B D6     JSR $d61b
C97A  20 71 D2     JSR $d271
C97D  85 79        STA $79
C97F  20 71 D2     JSR $d271
C982  85 7A        STA $7a
C984  A5 79        LDA $79
C986  D0 06        BNE $c98e
C988  20 5F ED     JSR $ed5f
C98B  4C 7D D3     JMP $d37d
C98E  20 CA ED     JSR $edca
C991  20 A0 D5     JSR $d5a0
C994  4C 75 C9     JMP $c975
C997  A0 00        LDY #$00
C999  98           TYA
C99A  91 8D        STA ($8d),Y
C99C  20 99 DF     JSR $df99
C99F  4C EC D6     JMP $d6ec
C9A2  A9 31        LDA #$31
C9A4  4C B2 C2     JMP $c2b2
C9A7  A9 03        LDA #$03
C9A9  20 08 D8     JSR $d808
C9AC  A2 03        LDX #$03
C9AE  A9 F0        LDA #$f0
C9B0  85 FF        STA $ff
C9B2  8D FE 02     STA $02fe
C9B5  20 C8 C9     JSR $c9c8
C9B8  A9 01        LDA #$01
C9BA  85 0E        STA $0e
C9BC  A9 00        LDA #$00
C9BE  85 0F        STA $0f
C9C0  A9 80        LDA #$80
C9C2  8D FE 02     STA $02fe
C9C5  4C C8 C9     JMP $c9c8
C9C8  A0 03        LDY #$03
C9CA  AD FE 02     LDA $02fe
C9CD  95 02        STA $02,X
C9CF  20 19 D8     JSR $d819
C9D2  C9 02        CMP #$02
C9D4  90 0E        BCC $c9e4
C9D6  A9 FF        LDA #$ff
C9D8  85 40        STA $40
C9DA  85 FF        STA $ff
C9DC  88           DEY
C9DD  D0 EB        BNE $c9ca
C9DF  A2 00        LDX #$00
C9E1  4C 46 E7     JMP $e746
C9E4  60           RTS
C9E5  A9 E0        LDA #$e0
C9E7  8D 4F 02     STA $024f
C9EA  20 3C EF     JSR $ef3c
C9ED  20 84 EF     JSR $ef84
C9F0  A9 FF        LDA #$ff
C9F2  95 A8        STA $a8,X
C9F4  A9 0F        LDA #$0f
C9F6  8D 56 02     STA $0256
C9F9  20 CF C2     JSR $c2cf
C9FC  D0 03        BNE $ca01
C9FE  4C A2 C9     JMP $c9a2
CA01  20 E2 C2     JSR $c2e2
CA04  20 0A C4     JSR $c40a
CA07  AD 8B 02     LDA $028b
CA0A  29 55        AND #$55
CA0C  D0 0F        BNE $ca1d
CA0E  AE 7A 02     LDX $027a
CA11  BD 00 02     LDA $0200,X
CA14  C9 2A        CMP #$2a
CA16  D0 05        BNE $ca1d
CA18  A9 30        LDA #$30
CA1A  4C B2 C2     JMP $c2b2
CA1D  AD 8B 02     LDA $028b
CA20  29 D9        AND #$d9
CA22  D0 F4        BNE $ca18
CA24  4C 47 CA     JMP $ca47
CA27  A9 00        LDA #$00
CA29  8D 58 02     STA $0258
CA2C  8D 8C 02     STA $028c
CA2F  8D 80 02     STA $0280
CA32  8D 81 02     STA $0281
CA35  A5 E4        LDA $e4
CA37  29 01        AND #$01
CA39  85 78        STA $78
CA3B  09 01        ORA #$01
CA3D  8D 91 02     STA $0291
CA40  AD 7B 02     LDA $027b
CA43  8D 7A 02     STA $027a
CA46  60           RTS
CA47  20 3A C5     JSR $c53a
CA4A  AD 78 02     LDA $0278
CA4D  C9 03        CMP #$03
CA4F  90 45        BCC $ca96
CA51  A5 E3        LDA $e3
CA53  C5 E4        CMP $e4
CA55  D0 3F        BNE $ca96
CA57  A5 DE        LDA $de
CA59  C5 DF        CMP $df
CA5B  D0 39        BNE $ca96
CA5D  A5 D9        LDA $d9
CA5F  C5 DA        CMP $da
CA61  D0 33        BNE $ca96
CA63  20 C1 CB     JSR $cbc1
CA66  A9 01        LDA #$01
CA68  8D 79 02     STA $0279
CA6B  20 EF CA     JSR $caef
CA6E  20 35 D2     JSR $d235
CA71  F0 04        BEQ $ca77
CA73  C9 02        CMP #$02
CA75  D0 05        BNE $ca7c
CA77  A9 64        LDA #$64
CA79  20 B2 C2     JSR $c2b2
CA7C  A9 12        LDA #$12
CA7E  85 7C        STA $7c
CA80  AD 3C 02     LDA $023c
CA83  8D 3D 02     STA $023d
CA86  A9 FF        LDA #$ff
CA88  8D 3C 02     STA $023c
CA8B  20 61 DB     JSR $db61
CA8E  A2 02        LDX #$02
CA90  20 AE CA     JSR $caae
CA93  4C 7E C2     JMP $c27e
CA96  20 9C CA     JSR $ca9c
CA99  4C 7E C2     JMP $c27e
CA9C  20 DC CB     JSR $cbdc
CA9F  A5 E3        LDA $e3
CAA1  29 01        AND #$01
CAA3  85 78        STA $78
CAA5  20 D9 D5     JSR $d5d9
CAA8  20 1E D8     JSR $d81e
CAAB  AE 77 02     LDX $0277
CAAE  8E 79 02     STX $0279
CAB1  20 EF CA     JSR $caef
CAB4  A9 11        LDA #$11
CAB6  85 7C        STA $7c
CAB8  20 FB D1     JSR $d1fb
CABB  20 35 D2     JSR $d235
CABE  D0 03        BNE $cac3
CAC0  20 48 CB     JSR $cb48
CAC3  A9 08        LDA #$08
CAC5  85 95        STA $95
CAC7  4C CD CA     JMP $cacd
CACA  20 BA D0     JSR $d0ba
CACD  20 2A CB     JSR $cb2a
CAD0  A9 80        LDA #$80
CAD2  20 E1 DE     JSR $dee1
CAD5  F0 F3        BEQ $caca
CAD7  20 35 D2     JSR $d235
CADA  F0 03        BEQ $cadf
CADC  20 BA D0     JSR $d0ba
CADF  AE 79 02     LDX $0279
CAE2  E8           INX
CAE3  EC 78 02     CPX $0278
CAE6  90 C6        BCC $caae
CAE8  A9 12        LDA #$12
CAEA  85 7C        STA $7c
CAEC  4C 39 DC     JMP $dc39
CAEF  AE 79 02     LDX $0279
CAF2  B5 E3        LDA $e3,X
CAF4  29 01        AND #$01
CAF6  85 78        STA $78
CAF8  AD C3 F0     LDA $f0c3
CAFB  85 79        STA $79
CAFD  B5 D9        LDA $d9,X
CAFF  85 7A        STA $7a
CB01  20 C8 D5     JSR $d5c8
CB04  AE 79 02     LDX $0279
CB07  B5 DE        LDA $de,X
CB09  20 1B D6     JSR $d61b
CB0C  AE 79 02     LDX $0279
CB0F  B5 E8        LDA $e8,X
CB11  29 07        AND #$07
CB13  8D 4A 02     STA $024a
CB16  A9 00        LDA #$00
CB18  8D 58 02     STA $0258
CB1B  20 D7 DA     JSR $dad7
CB1E  A0 01        LDY #$01
CB20  20 35 D2     JSR $d235
CB23  F0 01        BEQ $cb26
CB25  C8           INY
CB26  98           TYA
CB27  4C 1B D6     JMP $d61b
CB2A  A9 11        LDA #$11
CB2C  85 7C        STA $7c
CB2E  20 ED D4     JSR $d4ed
CB31  85 7E        STA $7e
CB33  A6 7B        LDX $7b
CB35  B5 F3        LDA $f3,X
CB37  29 08        AND #$08
CB39  85 95        STA $95
CB3B  D0 0A        BNE $cb47
CB3D  20 35 D2     JSR $d235
CB40  F0 05        BEQ $cb47
CB42  A9 80        LDA #$80
CB44  20 D2 DE     JSR $ded2
CB47  60           RTS
CB48  20 29 D3     JSR $d329
CB4B  20 06 E3     JSR $e306
CB4E  A5 93        LDA $93
CB50  48           PHA
CB51  A5 92        LDA $92
CB53  48           PHA
CB54  A9 12        LDA #$12
CB56  85 7C        STA $7c
CB58  20 17 D2     JSR $d217
CB5B  20 29 D3     JSR $d329
CB5E  20 06 E3     JSR $e306
CB61  20 D7 E3     JSR $e3d7
CB64  A5 93        LDA $93
CB66  85 80        STA $80
CB68  A5 92        LDA $92
CB6A  85 7F        STA $7f
CB6C  A9 00        LDA #$00
CB6E  85 81        STA $81
CB70  85 91        STA $91
CB72  85 94        STA $94
CB74  68           PLA
CB75  85 92        STA $92
CB77  68           PLA
CB78  85 93        STA $93
CB7A  4C 76 E4     JMP $e476
CB7D  20 0A C4     JSR $c40a
CB80  A5 E4        LDA $e4
CB82  29 01        AND #$01
CB84  85 E4        STA $e4
CB86  C5 E3        CMP $e3
CB88  F0 02        BEQ $cb8c
CB8A  09 80        ORA #$80
CB8C  85 E3        STA $e3
CB8E  20 3A C5     JSR $c53a
CB91  20 DC CB     JSR $cbdc
CB94  A5 E4        LDA $e4
CB96  29 01        AND #$01
CB98  85 78        STA $78
CB9A  A5 DA        LDA $da
CB9C  85 7A        STA $7a
CB9E  20 92 DF     JSR $df92
CBA1  20 EC D6     JSR $d6ec
CBA4  A5 DF        LDA $df
CBA6  18           CLC
CBA7  69 03        ADC #$03
CBA9  20 1B D6     JSR $d61b
CBAC  20 CE E0     JSR $e0ce
CBAF  A8           TAY
CBB0  AE 7A 02     LDX $027a
CBB3  A9 10        LDA #$10
CBB5  20 4F C7     JSR $c74f
CBB8  20 99 DF     JSR $df99
CBBB  20 EC D6     JSR $d6ec
CBBE  4C 7E C2     JMP $c27e
CBC1  A5 E9        LDA $e9
CBC3  29 07        AND #$07
CBC5  8D 4A 02     STA $024a
CBC8  AE 78 02     LDX $0278
CBCB  CA           DEX
CBCC  EC 77 02     CPX $0277
CBCF  90 0A        BCC $cbdb
CBD1  BD 80 02     LDA $0280,X
CBD4  D0 F5        BNE $cbcb
CBD6  A9 62        LDA #$62
CBD8  4C B2 C2     JMP $c2b2
CBDB  60           RTS
CBDC  20 C1 CB     JSR $cbc1
CBDF  BD 80 02     LDA $0280,X
CBE2  F0 05        BEQ $cbe9
CBE4  A9 63        LDA #$63
CBE6  4C B2 C2     JMP $c2b2
CBE9  CA           DEX
CBEA  10 F3        BPL $cbdf
CBEC  60           RTS
CBED  AD 01 02     LDA $0201
CBF0  C9 2D        CMP #$2d
CBF2  D0 49        BNE $cc3d
CBF4  AD 03 02     LDA $0203
CBF7  85 6E        STA $6e
CBF9  AD 04 02     LDA $0204
CBFC  85 6F        STA $6f
CBFE  A0 00        LDY #$00
CC00  AD 02 02     LDA $0202
CC03  C9 52        CMP #$52
CC05  F0 0B        BEQ $cc12
CC07  C9 57        CMP #$57
CC09  F0 37        BEQ $cc42
CC0B  C9 45        CMP #$45
CC0D  D0 2E        BNE $cc3d
CC0F  6C 6E 00     JMP ($006e)
CC12  B1 6E        LDA ($6e),Y
CC14  85 7E        STA $7e
CC16  AD 74 02     LDA $0274
CC19  C9 06        CMP #$06
CC1B  90 1A        BCC $cc37
CC1D  AE 05 02     LDX $0205
CC20  CA           DEX
CC21  F0 14        BEQ $cc37
CC23  8A           TXA
CC24  18           CLC
CC25  65 6E        ADC $6e
CC27  E6 6E        INC $6e
CC29  8D 49 02     STA $0249
CC2C  A5 6E        LDA $6e
CC2E  85 A6        STA $a6
CC30  A5 6F        LDA $6f
CC32  85 A7        STA $a7
CC34  4C 96 D5     JMP $d596
CC37  20 FB D1     JSR $d1fb
CC3A  4C 8D D5     JMP $d58d
CC3D  A9 31        LDA #$31
CC3F  4C B2 C2     JMP $c2b2
CC42  B9 06 02     LDA $0206,Y
CC45  91 6E        STA ($6e),Y
CC47  C8           INY
CC48  CC 05 02     CPY $0205
CC4B  90 F5        BCC $cc42
CC4D  60           RTS
CC4E  AC 01 02     LDY $0201
CC51  C0 30        CPY #$30
CC53  D0 09        BNE $cc5e
CC55  A9 EA        LDA #$ea
CC57  85 6A        STA $6a
CC59  A9 FF        LDA #$ff
CC5B  85 6B        STA $6b
CC5D  60           RTS
CC5E  20 64 CC     JSR $cc64
CC61  4C 7E C2     JMP $c27e
CC64  88           DEY
CC65  98           TYA
CC66  29 0F        AND #$0f
CC68  0A           ASL A
CC69  A8           TAY
CC6A  B1 6A        LDA ($6a),Y
CC6C  85 74        STA $74
CC6E  C8           INY
CC6F  B1 6A        LDA ($6a),Y
CC71  85 75        STA $75
CC73  6C 74 00     JMP ($0074)
CC76  AD 8E 02     LDA $028e
CC79  85 78        STA $78
CC7B  A5 7C        LDA $7c
CC7D  48           PHA
CC7E  20 22 C7     JSR $c722
CC81  68           PLA
CC82  85 7C        STA $7c
CC84  AE 74 02     LDX $0274
CC87  CA           DEX
CC88  D0 0D        BNE $cc97
CC8A  A9 01        LDA #$01
CC8C  20 38 D3     JSR $d338
CC8F  4C E3 CC     JMP $cce3
CC92  A9 70        LDA #$70
CC94  4C B2 C2     JMP $c2b2
CC97  A0 01        LDY #$01
CC99  20 6E CD     JSR $cd6e
CC9C  AE 85 02     LDX $0285
CC9F  E0 05        CPX #$05
CCA1  B0 EF        BCS $cc92
CCA3  A9 00        LDA #$00
CCA5  85 6E        STA $6e
CCA7  85 6F        STA $6f
CCA9  38           SEC
CCAA  26 6E        ROL $6e
CCAC  26 6F        ROL $6f
CCAE  CA           DEX
CCAF  10 F9        BPL $ccaa
CCB1  A5 6E        LDA $6e
CCB3  2D 4F 02     AND $024f
CCB6  D0 DA        BNE $cc92
CCB8  A5 6F        LDA $6f
CCBA  2D 50 02     AND $0250
CCBD  D0 D3        BNE $cc92
CCBF  A5 6E        LDA $6e
CCC1  0D 4F 02     ORA $024f
CCC4  8D 4F 02     STA $024f
CCC7  A5 6F        LDA $6f
CCC9  0D 50 02     ORA $0250
CCCC  8D 50 02     STA $0250
CCCF  A9 00        LDA #$00
CCD1  20 38 D3     JSR $d338
CCD4  A6 7B        LDX $7b
CCD6  AD 85 02     LDA $0285
CCD9  95 A8        STA $a8,X
CCDB  AA           TAX
CCDC  A5 78        LDA $78
CCDE  95 02        STA $02,X
CCE0  9D 5B 02     STA $025b,X
CCE3  A6 7C        LDX $7c
CCE5  BD 2B 02     LDA $022b,X
CCE8  09 40        ORA #$40
CCEA  9D 2B 02     STA $022b,X
CCED  A4 7B        LDY $7b
CCEF  A9 FF        LDA #$ff
CCF1  99 44 02     STA $0244,Y
CCF4  A9 89        LDA #$89
CCF6  99 F3 00     STA $00f3,Y
CCF9  B9 A8 00     LDA $00a8,Y
CCFC  99 3E 02     STA $023e,Y
CCFF  0A           ASL A
CD00  AA           TAX
CD01  A9 01        LDA #$01
CD03  95 9A        STA $9a,X
CD05  A9 0E        LDA #$0e
CD07  99 ED 00     STA $00ed,Y
CD0A  4C 7E C2     JMP $c27e
CD0D  A0 00        LDY #$00
CD0F  A2 00        LDX #$00
CD11  A9 2D        LDA #$2d
CD13  20 52 C3     JSR $c352
CD16  D0 0A        BNE $cd22
CD18  A9 31        LDA #$31
CD1A  4C B2 C2     JMP $c2b2
CD1D  A9 30        LDA #$30
CD1F  4C B2 C2     JMP $c2b2
CD22  8A           TXA
CD23  D0 F8        BNE $cd1d
CD25  A2 05        LDX #$05
CD27  B9 00 02     LDA $0200,Y
CD2A  DD 4F CD     CMP $cd4f,X
CD2D  F0 05        BEQ $cd34
CD2F  CA           DEX
CD30  10 F8        BPL $cd2a
CD32  30 E4        BMI $cd18
CD34  8A           TXA
CD35  09 80        ORA #$80
CD37  8D 2A 02     STA $022a
CD3A  20 61 CD     JSR $cd61
CD3D  AD 2A 02     LDA $022a
CD40  0A           ASL A
CD41  AA           TAX
CD42  BD 56 CD     LDA $cd56,X
CD45  85 6F        STA $6f
CD47  BD 55 CD     LDA $cd55,X
CD4A  85 6E        STA $6e
CD4C  6C 6E 00     JMP ($006e)
CD4F  41 46        EOR ($46,X)
CD51  52           ???
CD52  57           ???
CD53  45 50        EOR $50
CD55  F5 CD        SBC $cd,X
CD57  E7           ???
CD58  CD 48 CE     CMP $ce48
CD5B  65 CE        ADC $ce
CD5D  97           ???
CD5E  CE AE CE     DEC $ceae
CD61  A0 00        LDY #$00
CD63  A2 00        LDX #$00
CD65  A9 3A        LDA #$3a
CD67  20 52 C3     JSR $c352
CD6A  D0 02        BNE $cd6e
CD6C  A0 03        LDY #$03
CD6E  B9 00 02     LDA $0200,Y
CD71  C9 20        CMP #$20
CD73  F0 08        BEQ $cd7d
CD75  C9 1D        CMP #$1d
CD77  F0 04        BEQ $cd7d
CD79  C9 2C        CMP #$2c
CD7B  D0 07        BNE $cd84
CD7D  C8           INY
CD7E  CC 74 02     CPY $0274
CD81  90 EB        BCC $cd6e
CD83  60           RTS
CD84  20 93 CD     JSR $cd93
CD87  EE 77 02     INC $0277
CD8A  AC 79 02     LDY $0279
CD8D  E0 04        CPX #$04
CD8F  90 EC        BCC $cd7d
CD91  B0 8A        BCS $cd1d
CD93  A9 00        LDA #$00
CD95  85 6E        STA $6e
CD97  85 6F        STA $6f
CD99  85 71        STA $71
CD9B  A2 FF        LDX #$ff
CD9D  B9 00 02     LDA $0200,Y
CDA0  C9 40        CMP #$40
CDA2  B0 18        BCS $cdbc
CDA4  C9 30        CMP #$30
CDA6  90 14        BCC $cdbc
CDA8  29 0F        AND #$0f
CDAA  48           PHA
CDAB  A5 6F        LDA $6f
CDAD  85 70        STA $70
CDAF  A5 6E        LDA $6e
CDB1  85 6F        STA $6f
CDB3  68           PLA
CDB4  85 6E        STA $6e
CDB6  C8           INY
CDB7  CC 74 02     CPY $0274
CDBA  90 E1        BCC $cd9d
CDBC  8C 79 02     STY $0279
CDBF  18           CLC
CDC0  A9 00        LDA #$00
CDC2  E8           INX
CDC3  E0 03        CPX #$03
CDC5  B0 0F        BCS $cdd6
CDC7  B4 6E        LDY $6e,X
CDC9  88           DEY
CDCA  30 F6        BMI $cdc2
CDCC  7D E4 CD     ADC $cde4,X
CDCF  90 F8        BCC $cdc9
CDD1  18           CLC
CDD2  E6 71        INC $71
CDD4  D0 F3        BNE $cdc9
CDD6  48           PHA
CDD7  AE 77 02     LDX $0277
CDDA  A5 71        LDA $71
CDDC  9D 80 02     STA $0280,X
CDDF  68           PLA
CDE0  9D 85 02     STA $0285,X
CDE3  60           RTS
CDE4  01 0A        ORA ($0a,X)
CDE6  64           ???
CDE7  20 E6 CE     JSR $cee6
CDEA  20 CA ED     JSR $edca
CDED  4C 7E C2     JMP $c27e
CDF0  A9 01        LDA #$01
CDF2  8D F9 02     STA $02f9
CDF5  20 E6 CE     JSR $cee6
CDF8  A5 7A        LDA $7a
CDFA  48           PHA
CDFB  20 65 F0     JSR $f065
CDFE  F0 0B        BEQ $ce0b
CE00  68           PLA
CE01  C5 7A        CMP $7a
CE03  D0 19        BNE $ce1e
CE05  20 FB ED     JSR $edfb
CE08  4C 7E C2     JMP $c27e
CE0B  68           PLA
CE0C  A9 00        LDA #$00
CE0E  85 7A        STA $7a
CE10  E6 79        INC $79
CE12  A5 79        LDA $79
CE14  CD 1A F1     CMP $f11a
CE17  B0 0A        BCS $ce23
CE19  20 65 F0     JSR $f065
CE1C  F0 EE        BEQ $ce0c
CE1E  A9 65        LDA #$65
CE20  20 81 E7     JSR $e781
CE23  A9 65        LDA #$65
CE25  20 B2 C2     JSR $c2b2
CE28  20 E3 CE     JSR $cee3
CE2B  4C B3 D5     JMP $d5b3
CE2E  20 3F D2     JSR $d23f
CE31  A1 9A        LDA ($9a,X)
CE33  60           RTS
CE34  20 28 CE     JSR $ce28
CE37  A9 00        LDA #$00
CE39  20 1B D6     JSR $d61b
CE3C  20 2E CE     JSR $ce2e
CE3F  99 44 02     STA $0244,Y
CE42  A9 89        LDA #$89
CE44  99 F3 00     STA $00f3,Y
CE47  60           RTS
CE48  20 34 CE     JSR $ce34
CE4B  20 3F D5     JSR $d53f
CE4E  4C 7E C2     JMP $c27e
CE51  20 61 CD     JSR $cd61
CE54  20 34 CE     JSR $ce34
CE57  B9 44 02     LDA $0244,Y
CE5A  99 3E 02     STA $023e,Y
CE5D  A9 FF        LDA #$ff
CE5F  99 44 02     STA $0244,Y
CE62  4C 7E C2     JMP $c27e
CE65  20 E3 CE     JSR $cee3
CE68  20 3B D6     JSR $d63b
CE6B  A8           TAY
CE6C  88           DEY
CE6D  C9 02        CMP #$02
CE6F  B0 02        BCS $ce73
CE71  A0 01        LDY #$01
CE73  A9 00        LDA #$00
CE75  20 1B D6     JSR $d61b
CE78  98           TYA
CE79  20 0D D1     JSR $d10d
CE7C  8A           TXA
CE7D  48           PHA
CE7E  20 B7 D5     JSR $d5b7
CE81  68           PLA
CE82  AA           TAX
CE83  A4 7B        LDY $7b
CE85  20 41 D5     JSR $d541
CE88  4C 7E C2     JMP $c27e
CE8B  20 61 CD     JSR $cd61
CE8E  20 E3 CE     JSR $cee3
CE91  20 B7 D5     JSR $d5b7
CE94  4C 7E C2     JMP $c27e
CE97  20 28 CE     JSR $ce28
CE9A  A9 00        LDA #$00
CE9C  85 6E        STA $6e
CE9E  A6 98        LDX $98
CEA0  BD 23 F1     LDA $f123,X
CEA3  85 6F        STA $6f
CEA5  20 AB CE     JSR $ceab
CEA8  4C 7E C2     JMP $c27e
CEAB  6C 6E 00     JMP ($006e)
CEAE  20 C3 CE     JSR $cec3
CEB1  A5 98        LDA $98
CEB3  0A           ASL A
CEB4  AA           TAX
CEB5  AD 86 02     LDA $0286
CEB8  95 9A        STA $9a,X
CEBA  20 3F D2     JSR $d23f
CEBD  20 41 D5     JSR $d541
CEC0  4C 7E C2     JMP $c27e
CEC3  A6 99        LDX $99
CEC5  E6 99        INC $99
CEC7  BD 85 02     LDA $0285,X
CECA  A8           TAY
CECB  88           DEY
CECC  88           DEY
CECD  C0 0C        CPY #$0c
CECF  90 05        BCC $ced6
CED1  A9 70        LDA #$70
CED3  4C B2 C2     JMP $c2b2
CED6  85 7C        STA $7c
CED8  20 FB D1     JSR $d1fb
CEDB  B0 F4        BCS $ced1
CEDD  20 CE E0     JSR $e0ce
CEE0  85 98        STA $98
CEE2  60           RTS
CEE3  20 C3 CE     JSR $cec3
CEE6  A6 99        LDX $99
CEE8  BD 85 02     LDA $0285,X
CEEB  29 01        AND #$01
CEED  85 78        STA $78
CEEF  BD 87 02     LDA $0287,X
CEF2  85 7A        STA $7a
CEF4  BD 86 02     LDA $0286,X
CEF7  85 79        STA $79
CEF9  20 B0 D6     JSR $d6b0
CEFC  60           RTS
CEFD  20 1B CF     JSR $cf1b
CF00  20 5D CF     JSR $cf5d
CF03  A5 89        LDA $89
CF05  85 94        STA $94
CF07  20 60 CF     JSR $cf60
CF0A  E6 94        INC $94
CF0C  E6 94        INC $94
CF0E  A5 84        LDA $84
CF10  85 92        STA $92
CF12  A5 89        LDA $89
CF14  0A           ASL A
CF15  18           CLC
CF16  69 10        ADC #$10
CF18  85 93        STA $93
CF1A  60           RTS
CF1B  20 8F CF     JSR $cf8f
CF1E  85 8B        STA $8b
CF20  A6 7B        LDX $7b
CF22  B5 B6        LDA $b6,X
CF24  85 89        STA $89
CF26  B5 BC        LDA $bc,X
CF28  85 8A        STA $8a
CF2A  D0 04        BNE $cf30
CF2C  A5 89        LDA $89
CF2E  F0 0B        BEQ $cf3b
CF30  A5 89        LDA $89
CF32  38           SEC
CF33  E9 01        SBC #$01
CF35  85 89        STA $89
CF37  B0 02        BCS $cf3b
CF39  C6 8A        DEC $8a
CF3B  B5 C8        LDA $c8,X
CF3D  85 6E        STA $6e
CF3F  46 6E        LSR $6e
CF41  90 03        BCC $cf46
CF43  20 A3 CF     JSR $cfa3
CF46  20 9B CF     JSR $cf9b
CF49  A5 6E        LDA $6e
CF4B  D0 F2        BNE $cf3f
CF4D  A5 91        LDA $91
CF4F  18           CLC
CF50  65 84        ADC $84
CF52  85 84        STA $84
CF54  90 06        BCC $cf5c
CF56  E6 85        INC $85
CF58  D0 02        BNE $cf5c
CF5A  E6 86        INC $86
CF5C  60           RTS
CF5D  A9 FE        LDA #$fe
CF5F  2C A9 78     BIT $78a9
CF62  2C A9 06     BIT $06a9
CF65  85 6E        STA $6e
CF67  A9 00        LDA #$00
CF69  85 89        STA $89
CF6B  85 8A        STA $8a
CF6D  A2 18        LDX #$18
CF6F  06 84        ASL $84
CF71  26 85        ROL $85
CF73  26 86        ROL $86
CF75  26 89        ROL $89
CF77  26 8A        ROL $8a
CF79  A5 89        LDA $89
CF7B  38           SEC
CF7C  E5 6E        SBC $6e
CF7E  A8           TAY
CF7F  A5 8A        LDA $8a
CF81  E9 00        SBC #$00
CF83  90 06        BCC $cf8b
CF85  E6 84        INC $84
CF87  85 8A        STA $8a
CF89  84 89        STY $89
CF8B  CA           DEX
CF8C  D0 E1        BNE $cf6f
CF8E  60           RTS
CF8F  A9 00        LDA #$00
CF91  85 84        STA $84
CF93  85 85        STA $85
CF95  85 86        STA $86
CF97  60           RTS
CF98  20 9B CF     JSR $cf9b
CF9B  18           CLC
CF9C  26 89        ROL $89
CF9E  26 8A        ROL $8a
CFA0  26 8B        ROL $8b
CFA2  60           RTS
CFA3  18           CLC
CFA4  A2 FD        LDX #$fd
CFA6  B5 87        LDA $87,X
CFA8  75 8C        ADC $8c,X
CFAA  95 87        STA $87,X
CFAC  E8           INX
CFAD  D0 F7        BNE $cfa6
CFAF  60           RTS
CFB0  A2 00        LDX #$00
CFB2  8A           TXA
CFB3  95 D4        STA $d4,X
CFB5  E8           INX
CFB6  E0 04        CPX #$04
CFB8  D0 F8        BNE $cfb2
CFBA  A9 06        LDA #$06
CFBC  95 D4        STA $d4,X
CFBE  60           RTS
CFBF  A0 04        LDY #$04
CFC1  A6 7B        LDX $7b
CFC3  B9 D4 00     LDA $00d4,Y
CFC6  96 D4        STX $d4,Y
CFC8  C5 7B        CMP $7b
CFCA  F0 07        BEQ $cfd3
CFCC  88           DEY
CFCD  30 E1        BMI $cfb0
CFCF  AA           TAX
CFD0  4C C3 CF     JMP $cfc3
CFD3  60           RTS
CFD4  20 BF CF     JSR $cfbf
CFD7  A6 7B        LDX $7b
CFD9  B5 A8        LDA $a8,X
CFDB  30 02        BMI $cfdf
CFDD  B5 AF        LDA $af,X
CFDF  C9 FF        CMP #$ff
CFE1  F0 18        BEQ $cffb
CFE3  B5 A8        LDA $a8,X
CFE5  49 80        EOR #$80
CFE7  95 A8        STA $a8,X
CFE9  48           PHA
CFEA  B5 AF        LDA $af,X
CFEC  49 80        EOR #$80
CFEE  95 AF        STA $af,X
CFF0  A8           TAY
CFF1  68           PLA
CFF2  10 01        BPL $cff5
CFF4  98           TYA
CFF5  29 BF        AND #$bf
CFF7  AA           TAX
CFF8  4C EC D6     JMP $d6ec
CFFB  B5 A8        LDA $a8,X
CFFD  10 02        BPL $d001
CFFF  B5 AF        LDA $af,X
D001  29 BF        AND #$bf
D003  A8           TAY
D004  B9 5B 02     LDA $025b,Y
D007  29 01        AND #$01
D009  85 78        STA $78
D00B  20 E4 D3     JSR $d3e4
D00E  10 05        BPL $d015
D010  A9 70        LDA #$70
D012  4C B2 C2     JMP $c2b2
D015  A6 7B        LDX $7b
D017  09 80        ORA #$80
D019  B4 A8        LDY $a8,X
D01B  10 04        BPL $d021
D01D  95 A8        STA $a8,X
D01F  30 02        BMI $d023
D021  95 AF        STA $af,X
D023  A5 79        LDA $79
D025  48           PHA
D026  A5 7A        LDA $7a
D028  48           PHA
D029  A9 01        LDA #$01
D02B  85 70        STA $70
D02D  B5 A8        LDA $a8,X
D02F  10 02        BPL $d033
D031  B5 AF        LDA $af,X
D033  29 BF        AND #$bf
D035  A8           TAY
D036  B9 23 F1     LDA $f123,Y
D039  85 71        STA $71
D03B  A0 00        LDY #$00
D03D  B1 70        LDA ($70),Y
D03F  85 7A        STA $7a
D041  A9 00        LDA #$00
D043  85 70        STA $70
D045  B5 A8        LDA $a8,X
D047  10 02        BPL $d04b
D049  B5 AF        LDA $af,X
D04B  29 BF        AND #$bf
D04D  A8           TAY
D04E  B9 23 F1     LDA $f123,Y
D051  85 71        STA $71
D053  A0 00        LDY #$00
D055  B1 70        LDA ($70),Y
D057  85 79        STA $79
D059  F0 2A        BEQ $d085
D05B  20 35 D2     JSR $d235
D05E  F0 0B        BEQ $d06b
D060  20 E6 DE     JSR $dee6
D063  D0 06        BNE $d06b
D065  20 AB D0     JSR $d0ab
D068  4C 7C D0     JMP $d07c
D06B  A6 7B        LDX $7b
D06D  B5 A8        LDA $a8,X
D06F  49 80        EOR #$80
D071  95 A8        STA $a8,X
D073  B5 AF        LDA $af,X
D075  49 80        EOR #$80
D077  95 AF        STA $af,X
D079  20 92 DF     JSR $df92
D07C  68           PLA
D07D  85 7A        STA $7a
D07F  68           PLA
D080  85 79        STA $79
D082  4C 8E D0     JMP $d08e
D085  68           PLA
D086  85 7A        STA $7a
D088  68           PLA
D089  85 79        STA $79
D08B  20 AB D0     JSR $d0ab
D08E  20 CE E0     JSR $e0ce
D091  AA           TAX
D092  4C EC D6     JMP $d6ec
D095  A9 70        LDA #$70
D097  4C B2 C2     JMP $c2b2
D09A  20 BF CF     JSR $cfbf
D09D  20 F2 E0     JSR $e0f2
D0A0  D0 08        BNE $d0aa
D0A2  20 E4 D3     JSR $d3e4
D0A5  30 EE        BMI $d095
D0A7  20 FD E0     JSR $e0fd
D0AA  60           RTS
D0AB  A6 7B        LDX $7b
D0AD  B5 A8        LDA $a8,X
D0AF  49 80        EOR #$80
D0B1  95 A8        STA $a8,X
D0B3  B5 AF        LDA $af,X
D0B5  49 80        EOR #$80
D0B7  95 AF        STA $af,X
D0B9  60           RTS
D0BA  A2 12        LDX #$12
D0BC  86 7C        STX $7c
D0BE  20 17 D2     JSR $d217
D0C1  20 35 D2     JSR $d235
D0C4  90 05        BCC $d0cb
D0C6  A9 20        LDA #$20
D0C8  20 D8 DE     JSR $ded8
D0CB  A5 7C        LDA $7c
D0CD  C9 0F        CMP #$0f
D0CF  F0 23        BEQ $d0f4
D0D1  D0 08        BNE $d0db
D0D3  A5 7D        LDA $7d
D0D5  29 8F        AND #$8f
D0D7  C9 0F        CMP #$0f
D0D9  B0 19        BCS $d0f4
D0DB  20 35 D2     JSR $d235
D0DE  B0 05        BCS $d0e5
D0E0  A5 7E        LDA $7e
D0E2  4C F3 D2     JMP $d2f3
D0E5  D0 03        BNE $d0ea
D0E7  4C E6 E1     JMP $e1e6
D0EA  A5 7E        LDA $7e
D0EC  20 0D D1     JSR $d10d
D0EF  A4 7B        LDY $7b
D0F1  4C 41 D5     JMP $d541
D0F4  A9 04        LDA #$04
D0F6  85 7B        STA $7b
D0F8  20 3B D6     JSR $d63b
D0FB  C9 2A        CMP #$2a
D0FD  F0 05        BEQ $d104
D0FF  A5 7E        LDA $7e
D101  20 0D D1     JSR $d10d
D104  A5 95        LDA $95
D106  F0 01        BEQ $d109
D108  60           RTS
D109  EE 55 02     INC $0255
D10C  60           RTS
D10D  48           PHA
D10E  20 CE E0     JSR $e0ce
D111  10 06        BPL $d119
D113  68           PLA
D114  A9 61        LDA #$61
D116  4C B2 C2     JMP $c2b2
D119  0A           ASL A
D11A  AA           TAX
D11B  68           PLA
D11C  81 9A        STA ($9a,X)
D11E  F6 9A        INC $9a,X
D120  60           RTS
D121  20 BB C2     JSR $c2bb
D124  20 5E D1     JSR $d15e
D127  4C 7E C2     JMP $c27e
D12A  20 7A EF     JSR $ef7a
D12D  A8           TAY
D12E  B6 A8        LDX $a8,Y
D130  E0 FF        CPX #$ff
D132  D0 14        BNE $d148
D134  48           PHA
D135  20 E4 D3     JSR $d3e4
D138  AA           TAX
D139  10 05        BPL $d140
D13B  A9 70        LDA #$70
D13D  20 84 E7     JSR $e784
D140  68           PLA
D141  A8           TAY
D142  8A           TXA
D143  09 80        ORA #$80
D145  99 A8 00     STA $00a8,Y
D148  8A           TXA
D149  29 0F        AND #$0f
D14B  85 98        STA $98
D14D  A2 00        LDX #$00
D14F  86 7A        STX $7a
D151  AE C3 F0     LDX $f0c3
D154  86 79        STX $79
D156  20 08 D8     JSR $d808
D159  A9 B0        LDA #$b0
D15B  4C DF D6     JMP $d6df
D15E  20 3C EF     JSR $ef3c
D161  20 65 D4     JSR $d465
D164  20 2A D1     JSR $d12a
D167  A6 78        LDX $78
D169  A9 00        LDA #$00
D16B  9D 51 02     STA $0251,X
D16E  20 D9 D6     JSR $d6d9
D171  A5 98        LDA $98
D173  0A           ASL A
D174  AA           TAX
D175  A9 02        LDA #$02
D177  95 9A        STA $9a,X
D179  A1 9A        LDA ($9a,X)
D17B  A6 78        LDX $78
D17D  95 5D        STA $5d,X
D17F  A9 00        LDA #$00
D181  95 22        STA $22,X
D183  95 5F        STA $5f,X
D185  20 A5 ED     JSR $eda5
D188  A0 04        LDY #$04
D18A  A9 00        LDA #$00
D18C  AA           TAX
D18D  18           CLC
D18E  71 6C        ADC ($6c),Y
D190  90 01        BCC $d193
D192  E8           INX
D193  C8           INY
D194  C8           INY
D195  C8           INY
D196  C8           INY
D197  C0 48        CPY #$48
D199  F0 F8        BEQ $d193
D19B  C0 90        CPY #$90
D19D  D0 EE        BNE $d18d
D19F  48           PHA
D1A0  8A           TXA
D1A1  A6 78        LDX $78
D1A3  9D FC 02     STA $02fc,X
D1A6  68           PLA
D1A7  9D FA 02     STA $02fa,X
D1AA  60           RTS
D1AB  20 05 D8     JSR $d805
D1AE  20 D3 D1     JSR $d1d3
D1B1  20 EC D6     JSR $d6ec
D1B4  20 47 D2     JSR $d247
D1B7  85 79        STA $79
D1B9  20 47 D2     JSR $d247
D1BC  85 7A        STA $7a
D1BE  60           RTS
D1BF  20 AB D1     JSR $d1ab
D1C2  A5 79        LDA $79
D1C4  D0 01        BNE $d1c7
D1C6  60           RTS
D1C7  20 D4 CF     JSR $cfd4
D1CA  20 05 D8     JSR $d805
D1CD  20 D3 D1     JSR $d1d3
D1D0  4C D4 CF     JMP $cfd4
D1D3  A9 80        LDA #$80
D1D5  D0 02        BNE $d1d9
D1D7  A9 90        LDA #$90
D1D9  8D 4D 02     STA $024d
D1DC  20 CE E0     JSR $e0ce
D1DF  AA           TAX
D1E0  20 59 D6     JSR $d659
D1E3  8A           TXA
D1E4  48           PHA
D1E5  0A           ASL A
D1E6  AA           TAX
D1E7  A9 00        LDA #$00
D1E9  95 9A        STA $9a,X
D1EB  20 35 D2     JSR $d235
D1EE  C9 04        CMP #$04
D1F0  B0 06        BCS $d1f8
D1F2  F6 B6        INC $b6,X
D1F4  D0 02        BNE $d1f8
D1F6  F6 BC        INC $bc,X
D1F8  68           PLA
D1F9  AA           TAX
D1FA  60           RTS
D1FB  A5 7C        LDA $7c
D1FD  C9 13        CMP #$13
D1FF  90 02        BCC $d203
D201  29 0F        AND #$0f
D203  C9 0F        CMP #$0f
D205  D0 02        BNE $d209
D207  A9 10        LDA #$10
D209  AA           TAX
D20A  38           SEC
D20B  BD 2B 02     LDA $022b,X
D20E  30 06        BMI $d216
D210  29 0F        AND #$0f
D212  85 7B        STA $7b
D214  AA           TAX
D215  18           CLC
D216  60           RTS
D217  A5 7C        LDA $7c
D219  C9 13        CMP #$13
D21B  90 02        BCC $d21f
D21D  29 0F        AND #$0f
D21F  AA           TAX
D220  BD 2B 02     LDA $022b,X
D223  A8           TAY
D224  0A           ASL A
D225  90 0A        BCC $d231
D227  30 0A        BMI $d233
D229  98           TYA
D22A  29 0F        AND #$0f
D22C  85 7B        STA $7b
D22E  AA           TAX
D22F  18           CLC
D230  60           RTS
D231  30 F6        BMI $d229
D233  38           SEC
D234  60           RTS
D235  A6 7B        LDX $7b
D237  B5 ED        LDA $ed,X
D239  4A           LSR A
D23A  29 07        AND #$07
D23C  C9 04        CMP #$04
D23E  60           RTS
D23F  20 CE E0     JSR $e0ce
D242  0A           ASL A
D243  AA           TAX
D244  A4 7B        LDY $7b
D246  60           RTS
D247  A6 7B        LDX $7b
D249  B5 A8        LDA $a8,X
D24B  10 02        BPL $d24f
D24D  B5 AF        LDA $af,X
D24F  29 BF        AND #$bf
D251  0A           ASL A
D252  AA           TAX
D253  A4 7B        LDY $7b
D255  B9 44 02     LDA $0244,Y
D258  F0 12        BEQ $d26c
D25A  A1 9A        LDA ($9a,X)
D25C  48           PHA
D25D  B5 9A        LDA $9a,X
D25F  D9 44 02     CMP $0244,Y
D262  D0 04        BNE $d268
D264  A9 FF        LDA #$ff
D266  95 9A        STA $9a,X
D268  68           PLA
D269  F6 9A        INC $9a,X
D26B  60           RTS
D26C  A1 9A        LDA ($9a,X)
D26E  F6 9A        INC $9a,X
D270  60           RTS
D271  20 47 D2     JSR $d247
D274  D0 71        BNE $d2e7
D276  85 7E        STA $7e
D278  B9 44 02     LDA $0244,Y
D27B  F0 08        BEQ $d285
D27D  A9 80        LDA #$80
D27F  99 F3 00     STA $00f3,Y
D282  A5 7E        LDA $7e
D284  60           RTS
D285  20 D4 CF     JSR $cfd4
D288  A9 00        LDA #$00
D28A  85 6E        STA $6e
D28C  A6 7B        LDX $7b
D28E  B5 A8        LDA $a8,X
D290  10 02        BPL $d294
D292  B5 AF        LDA $af,X
D294  29 BF        AND #$bf
D296  0A           ASL A
D297  AA           TAX
D298  B5 9B        LDA $9b,X
D29A  85 8E        STA $8e
D29C  A5 6E        LDA $6e
D29E  95 9A        STA $9a,X
D2A0  85 8D        STA $8d
D2A2  20 47 D2     JSR $d247
D2A5  C9 00        CMP #$00
D2A7  F0 3F        BEQ $d2e8
D2A9  85 79        STA $79
D2AB  20 47 D2     JSR $d247
D2AE  85 7A        STA $7a
D2B0  20 D4 CF     JSR $cfd4
D2B3  A6 7B        LDX $7b
D2B5  B5 A8        LDA $a8,X
D2B7  10 02        BPL $d2bb
D2B9  B5 AF        LDA $af,X
D2BB  29 BF        AND #$bf
D2BD  AA           TAX
D2BE  BD 5B 02     LDA $025b,X
D2C1  29 01        AND #$01
D2C3  85 78        STA $78
D2C5  A6 7B        LDX $7b
D2C7  B5 A8        LDA $a8,X
D2C9  10 02        BPL $d2cd
D2CB  B5 AF        LDA $af,X
D2CD  29 BF        AND #$bf
D2CF  0A           ASL A
D2D0  A8           TAY
D2D1  A5 79        LDA $79
D2D3  99 08 00     STA $0008,Y
D2D6  A5 7A        LDA $7a
D2D8  99 09 00     STA $0009,Y
D2DB  A5 78        LDA $78
D2DD  0A           ASL A
D2DE  AA           TAX
D2DF  20 D3 D1     JSR $d1d3
D2E2  20 D4 CF     JSR $cfd4
D2E5  A5 7E        LDA $7e
D2E7  60           RTS
D2E8  20 47 D2     JSR $d247
D2EB  A4 7B        LDY $7b
D2ED  99 44 02     STA $0244,Y
D2F0  A5 7E        LDA $7e
D2F2  60           RTS
D2F3  20 0D D1     JSR $d10d
D2F6  F0 01        BEQ $d2f9
D2F8  60           RTS
D2F9  20 29 D3     JSR $d329
D2FC  20 89 EF     JSR $ef89
D2FF  A9 00        LDA #$00
D301  20 1B D6     JSR $d61b
D304  A5 79        LDA $79
D306  20 0D D1     JSR $d10d
D309  A5 7A        LDA $7a
D30B  20 0D D1     JSR $d10d
D30E  20 D7 D1     JSR $d1d7
D311  20 D4 CF     JSR $cfd4
D314  20 05 D8     JSR $d805
D317  A9 02        LDA #$02
D319  4C 1B D6     JMP $d61b
D31C  85 6E        STA $6e
D31E  20 3B D6     JSR $d63b
D321  18           CLC
D322  65 6E        ADC $6e
D324  95 9A        STA $9a,X
D326  85 8D        STA $8d
D328  60           RTS
D329  20 CE E0     JSR $e0ce
D32C  AA           TAX
D32D  BD 5B 02     LDA $025b,X
D330  29 01        AND #$01
D332  85 78        STA $78
D334  60           RTS
D335  38           SEC
D336  B0 01        BCS $d339
D338  18           CLC
D339  08           PHP
D33A  85 6E        STA $6e
D33C  20 7D D3     JSR $d37d
D33F  20 D1 D4     JSR $d4d1
D342  85 7B        STA $7b
D344  A6 7C        LDX $7c
D346  28           PLP
D347  90 02        BCC $d34b
D349  09 80        ORA #$80
D34B  9D 2B 02     STA $022b,X
D34E  29 3F        AND #$3f
D350  A8           TAY
D351  A9 FF        LDA #$ff
D353  99 A8 00     STA $00a8,Y
D356  99 AF 00     STA $00af,Y
D359  99 CE 00     STA $00ce,Y
D35C  C6 6E        DEC $6e
D35E  30 1C        BMI $d37c
D360  20 E4 D3     JSR $d3e4
D363  10 08        BPL $d36d
D365  20 B0 D3     JSR $d3b0
D368  A9 70        LDA #$70
D36A  4C B2 C2     JMP $c2b2
D36D  99 A8 00     STA $00a8,Y
D370  C6 6E        DEC $6e
D372  30 08        BMI $d37c
D374  20 E4 D3     JSR $d3e4
D377  30 EC        BMI $d365
D379  99 AF 00     STA $00af,Y
D37C  60           RTS
D37D  A5 7C        LDA $7c
D37F  C9 0F        CMP #$0f
D381  D0 01        BNE $d384
D383  60           RTS
D384  A6 7C        LDX $7c
D386  BD 2B 02     LDA $022b,X
D389  C9 FF        CMP #$ff
D38B  F0 22        BEQ $d3af
D38D  29 3F        AND #$3f
D38F  85 7B        STA $7b
D391  A9 FF        LDA #$ff
D393  9D 2B 02     STA $022b,X
D396  A6 7B        LDX $7b
D398  A9 00        LDA #$00
D39A  95 F3        STA $f3,X
D39C  20 B0 D3     JSR $d3b0
D39F  A6 7B        LDX $7b
D3A1  A9 01        LDA #$01
D3A3  CA           DEX
D3A4  30 03        BMI $d3a9
D3A6  0A           ASL A
D3A7  D0 FA        BNE $d3a3
D3A9  0D 56 02     ORA $0256
D3AC  8D 56 02     STA $0256
D3AF  60           RTS
D3B0  A6 7B        LDX $7b
D3B2  B5 A8        LDA $a8,X
D3B4  C9 FF        CMP #$ff
D3B6  F0 09        BEQ $d3c1
D3B8  48           PHA
D3B9  A9 FF        LDA #$ff
D3BB  95 A8        STA $a8,X
D3BD  68           PLA
D3BE  20 45 D4     JSR $d445
D3C1  A6 7B        LDX $7b
D3C3  B5 AF        LDA $af,X
D3C5  C9 FF        CMP #$ff
D3C7  F0 09        BEQ $d3d2
D3C9  48           PHA
D3CA  A9 FF        LDA #$ff
D3CC  95 AF        STA $af,X
D3CE  68           PLA
D3CF  20 45 D4     JSR $d445
D3D2  A6 7B        LDX $7b
D3D4  B5 CE        LDA $ce,X
D3D6  C9 FF        CMP #$ff
D3D8  F0 09        BEQ $d3e3
D3DA  48           PHA
D3DB  A9 FF        LDA #$ff
D3DD  95 CE        STA $ce,X
D3DF  68           PLA
D3E0  20 45 D4     JSR $d445
D3E3  60           RTS
D3E4  98           TYA
D3E5  48           PHA
D3E6  A0 01        LDY #$01
D3E8  20 0C D4     JSR $d40c
D3EB  10 0C        BPL $d3f9
D3ED  88           DEY
D3EE  20 0C D4     JSR $d40c
D3F1  10 06        BPL $d3f9
D3F3  20 8B D4     JSR $d48b
D3F6  AA           TAX
D3F7  30 0F        BMI $d408
D3F9  A5 78        LDA $78
D3FB  95 02        STA $02,X
D3FD  9D 5B 02     STA $025b,X
D400  8A           TXA
D401  0A           ASL A
D402  A8           TAY
D403  A9 02        LDA #$02
D405  99 9A 00     STA $009a,Y
D408  68           PLA
D409  A8           TAY
D40A  8A           TXA
D40B  60           RTS
D40C  A2 07        LDX #$07
D40E  B9 4F 02     LDA $024f,Y
D411  3D 54 EE     AND $ee54,X
D414  F0 04        BEQ $d41a
D416  CA           DEX
D417  10 F5        BPL $d40e
D419  60           RTS
D41A  B9 4F 02     LDA $024f,Y
D41D  5D 54 EE     EOR $ee54,X
D420  99 4F 02     STA $024f,Y
D423  8A           TXA
D424  88           DEY
D425  30 03        BMI $d42a
D427  18           CLC
D428  69 08        ADC #$08
D42A  AA           TAX
D42B  60           RTS
D42C  A6 7B        LDX $7b
D42E  B5 A8        LDA $a8,X
D430  30 09        BMI $d43b
D432  8A           TXA
D433  18           CLC
D434  69 07        ADC #$07
D436  AA           TAX
D437  B5 A8        LDA $a8,X
D439  10 F0        BPL $d42b
D43B  C9 FF        CMP #$ff
D43D  F0 EC        BEQ $d42b
D43F  48           PHA
D440  A9 FF        LDA #$ff
D442  95 A8        STA $a8,X
D444  68           PLA
D445  29 0F        AND #$0f
D447  A8           TAY
D448  C8           INY
D449  A2 10        LDX #$10
D44B  6E 50 02     ROR $0250
D44E  6E 4F 02     ROR $024f
D451  88           DEY
D452  D0 01        BNE $d455
D454  18           CLC
D455  CA           DEX
D456  10 F3        BPL $d44b
D458  60           RTS
D459  A9 0E        LDA #$0e
D45B  85 7C        STA $7c
D45D  20 7D D3     JSR $d37d
D460  C6 7C        DEC $7c
D462  D0 F9        BNE $d45d
D464  60           RTS
D465  A9 0E        LDA #$0e
D467  85 7C        STA $7c
D469  A6 7C        LDX $7c
D46B  BD 2B 02     LDA $022b,X
D46E  C9 FF        CMP #$ff
D470  F0 14        BEQ $d486
D472  29 3F        AND #$3f
D474  85 7B        STA $7b
D476  20 CE E0     JSR $e0ce
D479  AA           TAX
D47A  BD 5B 02     LDA $025b,X
D47D  29 01        AND #$01
D47F  C5 78        CMP $78
D481  D0 03        BNE $d486
D483  20 7D D3     JSR $d37d
D486  C6 7C        DEC $7c
D488  10 DF        BPL $d469
D48A  60           RTS
D48B  A5 6E        LDA $6e
D48D  48           PHA
D48E  A0 00        LDY #$00
D490  B6 D4        LDX $d4,Y
D492  B5 A8        LDA $a8,X
D494  10 04        BPL $d49a
D496  C9 FF        CMP #$ff
D498  D0 16        BNE $d4b0
D49A  8A           TXA
D49B  18           CLC
D49C  69 07        ADC #$07
D49E  AA           TAX
D49F  B5 A8        LDA $a8,X
D4A1  10 04        BPL $d4a7
D4A3  C9 FF        CMP #$ff
D4A5  D0 09        BNE $d4b0
D4A7  C8           INY
D4A8  C0 05        CPY #$05
D4AA  90 E4        BCC $d490
D4AC  A2 FF        LDX #$ff
D4AE  D0 1C        BNE $d4cc
D4B0  86 6E        STX $6e
D4B2  29 3F        AND #$3f
D4B4  AA           TAX
D4B5  B5 02        LDA $02,X
D4B7  30 FC        BMI $d4b5
D4B9  C9 02        CMP #$02
D4BB  90 08        BCC $d4c5
D4BD  A6 6E        LDX $6e
D4BF  E0 07        CPX #$07
D4C1  90 D7        BCC $d49a
D4C3  B0 E2        BCS $d4a7
D4C5  A4 6E        LDY $6e
D4C7  A9 FF        LDA #$ff
D4C9  99 A8 00     STA $00a8,Y
D4CC  68           PLA
D4CD  85 6E        STA $6e
D4CF  8A           TXA
D4D0  60           RTS
D4D1  A0 00        LDY #$00
D4D3  A9 01        LDA #$01
D4D5  2C 56 02     BIT $0256
D4D8  D0 09        BNE $d4e3
D4DA  C8           INY
D4DB  0A           ASL A
D4DC  D0 F7        BNE $d4d5
D4DE  A9 70        LDA #$70
D4E0  4C B2 C2     JMP $c2b2
D4E3  49 FF        EOR #$ff
D4E5  2D 56 02     AND $0256
D4E8  8D 56 02     STA $0256
D4EB  98           TYA
D4EC  60           RTS
D4ED  20 FB D1     JSR $d1fb
D4F0  20 F9 D4     JSR $d4f9
D4F3  A6 7B        LDX $7b
D4F5  BD 3E 02     LDA $023e,X
D4F8  60           RTS
D4F9  A6 7B        LDX $7b
D4FB  B5 ED        LDA $ed,X
D4FD  4A           LSR A
D4FE  29 07        AND #$07
D500  C9 04        CMP #$04
D502  D0 03        BNE $d507
D504  4C 5B E2     JMP $e25b
D507  A5 7C        LDA $7c
D509  C9 0F        CMP #$0f
D50B  F0 5A        BEQ $d567
D50D  B5 F3        LDA $f3,X
D50F  29 08        AND #$08
D511  D0 13        BNE $d526
D513  20 35 D2     JSR $d235
D516  C9 07        CMP #$07
D518  D0 07        BNE $d521
D51A  A9 89        LDA #$89
D51C  95 F3        STA $f3,X
D51E  4C 31 D5     JMP $d531
D521  A9 00        LDA #$00
D523  95 F3        STA $f3,X
D525  60           RTS
D526  A5 7C        LDA $7c
D528  F0 32        BEQ $d55c
D52A  20 35 D2     JSR $d235
D52D  C9 04        CMP #$04
D52F  90 22        BCC $d553
D531  20 3F D2     JSR $d23f
D534  B5 9A        LDA $9a,X
D536  D9 44 02     CMP $0244,Y
D539  D0 04        BNE $d53f
D53B  A9 00        LDA #$00
D53D  95 9A        STA $9a,X
D53F  F6 9A        INC $9a,X
D541  A1 9A        LDA ($9a,X)
D543  99 3E 02     STA $023e,Y
D546  B5 9A        LDA $9a,X
D548  D9 44 02     CMP $0244,Y
D54B  D0 05        BNE $d552
D54D  A9 81        LDA #$81
D54F  99 F3 00     STA $00f3,Y
D552  60           RTS
D553  20 71 D2     JSR $d271
D556  A6 7B        LDX $7b
D558  9D 3E 02     STA $023e,X
D55B  60           RTS
D55C  AD 54 02     LDA $0254
D55F  F0 F2        BEQ $d553
D561  20 D4 EB     JSR $ebd4
D564  4C 56 D5     JMP $d556
D567  20 3B D6     JSR $d63b
D56A  C9 D4        CMP #$d4
D56C  D0 18        BNE $d586
D56E  A5 8E        LDA $8e
D570  C9 02        CMP #$02
D572  D0 12        BNE $d586
D574  A9 0D        LDA #$0d
D576  85 7E        STA $7e
D578  20 F0 F3     JSR $f3f0
D57B  A9 00        LDA #$00
D57D  20 00 E8     JSR $e800
D580  C6 A6        DEC $a6
D582  A9 80        LDA #$80
D584  D0 12        BNE $d598
D586  20 47 D2     JSR $d247
D589  85 7E        STA $7e
D58B  D0 09        BNE $d596
D58D  A9 D4        LDA #$d4
D58F  20 1B D6     JSR $d61b
D592  A9 02        LDA #$02
D594  95 9B        STA $9b,X
D596  A9 88        LDA #$88
D598  85 F8        STA $f8
D59A  A5 7E        LDA $7e
D59C  8D 43 02     STA $0243
D59F  60           RTS
D5A0  20 CE E0     JSR $e0ce
D5A3  0A           ASL A
D5A4  AA           TAX
D5A5  A9 00        LDA #$00
D5A7  95 9A        STA $9a,X
D5A9  A1 9A        LDA ($9a,X)
D5AB  F0 05        BEQ $d5b2
D5AD  D6 9A        DEC $9a,X
D5AF  4C 71 D2     JMP $d271
D5B2  60           RTS
D5B3  A9 80        LDA #$80
D5B5  D0 02        BNE $d5b9
D5B7  A9 90        LDA #$90
D5B9  05 78        ORA $78
D5BB  8D 4D 02     STA $024d
D5BE  A5 98        LDA $98
D5C0  20 08 D8     JSR $d808
D5C3  A6 98        LDX $98
D5C5  4C E6 D6     JMP $d6e6
D5C8  A9 01        LDA #$01
D5CA  8D 4A 02     STA $024a
D5CD  A9 11        LDA #$11
D5CF  85 7C        STA $7c
D5D1  20 7D DD     JSR $dd7d
D5D4  A9 02        LDA #$02
D5D6  4C 1B D6     JMP $d61b
D5D9  A9 12        LDA #$12
D5DB  85 7C        STA $7c
D5DD  4C 15 DE     JMP $de15
D5E0  20 76 DF     JSR $df76
D5E3  A9 01        LDA #$01
D5E5  85 6E        STA $6e
D5E7  A5 68        LDA $68
D5E9  48           PHA
D5EA  A9 03        LDA #$03
D5EC  85 68        STA $68
D5EE  20 98 EF     JSR $ef98
D5F1  68           PLA
D5F2  85 68        STA $68
D5F4  A9 00        LDA #$00
D5F6  20 1B D6     JSR $d61b
D5F9  A5 79        LDA $79
D5FB  20 0D D1     JSR $d10d
D5FE  A5 7A        LDA $7a
D600  20 0D D1     JSR $d10d
D603  20 D7 D1     JSR $d1d7
D606  20 EC D6     JSR $d6ec
D609  A9 00        LDA #$00
D60B  20 1B D6     JSR $d61b
D60E  20 0D D1     JSR $d10d
D611  D0 FB        BNE $d60e
D613  20 0D D1     JSR $d10d
D616  A9 FF        LDA #$ff
D618  4C 0D D1     JMP $d10d
D61B  85 6E        STA $6e
D61D  20 CE E0     JSR $e0ce
D620  0A           ASL A
D621  AA           TAX
D622  B5 9B        LDA $9b,X
D624  85 8E        STA $8e
D626  A5 6E        LDA $6e
D628  95 9A        STA $9a,X
D62A  85 8D        STA $8d
D62C  60           RTS
D62D  A9 11        LDA #$11
D62F  85 7C        STA $7c
D631  20 7D D3     JSR $d37d
D634  A9 12        LDA #$12
D636  85 7C        STA $7c
D638  4C 7D D3     JMP $d37d
D63B  20 CE E0     JSR $e0ce
D63E  0A           ASL A
D63F  AA           TAX
D640  B5 9B        LDA $9b,X
D642  85 8E        STA $8e
D644  B5 9A        LDA $9a,X
D646  85 8D        STA $8d
D648  60           RTS
D649  85 70        STA $70
D64B  20 CE E0     JSR $e0ce
D64E  AA           TAX
D64F  BD 23 F1     LDA $f123,X
D652  85 71        STA $71
D654  A0 00        LDY #$00
D656  B1 70        LDA ($70),Y
D658  60           RTS
D659  BD 5B 02     LDA $025b,X
D65C  29 01        AND #$01
D65E  0D 4D 02     ORA $024d
D661  48           PHA
D662  86 98        STX $98
D664  8A           TXA
D665  0A           ASL A
D666  AA           TAX
D667  B5 09        LDA $09,X
D669  8D 4D 02     STA $024d
D66C  B5 08        LDA $08,X
D66E  F0 2B        BEQ $d69b
D670  CD 1A F1     CMP $f11a
D673  B0 26        BCS $d69b
D675  AA           TAX
D676  68           PLA
D677  48           PHA
D678  29 F0        AND #$f0
D67A  C9 90        CMP #$90
D67C  D0 4D        BNE $d6cb
D67E  68           PLA
D67F  48           PHA
D680  4A           LSR A
D681  B0 04        BCS $d687
D683  A5 5D        LDA $5d
D685  90 02        BCC $d689
D687  A5 5E        LDA $5e
D689  F0 05        BEQ $d690
D68B  CD 18 F1     CMP $f118
D68E  D0 33        BNE $d6c3
D690  8A           TXA
D691  20 B6 F0     JSR $f0b6
D694  CD 4D 02     CMP $024d
D697  F0 02        BEQ $d69b
D699  B0 30        BCS $d6cb
D69B  20 A3 D6     JSR $d6a3
D69E  A9 66        LDA #$66
D6A0  4C 81 E7     JMP $e781
D6A3  A5 98        LDA $98
D6A5  0A           ASL A
D6A6  AA           TAX
D6A7  B5 08        LDA $08,X
D6A9  85 79        STA $79
D6AB  B5 09        LDA $09,X
D6AD  85 7A        STA $7a
D6AF  60           RTS
D6B0  A5 79        LDA $79
D6B2  F0 EA        BEQ $d69e
D6B4  CD 1A F1     CMP $f11a
D6B7  B0 E5        BCS $d69e
D6B9  20 B6 F0     JSR $f0b6
D6BC  C5 7A        CMP $7a
D6BE  F0 DE        BEQ $d69e
D6C0  90 DC        BCC $d69e
D6C2  60           RTS
D6C3  20 A3 D6     JSR $d6a3
D6C6  A9 73        LDA #$73
D6C8  4C 81 E7     JMP $e781
D6CB  A6 98        LDX $98
D6CD  68           PLA
D6CE  8D 4D 02     STA $024d
D6D1  9D 5B 02     STA $025b,X
D6D4  95 02        STA $02,X
D6D6  4C 19 D8     JMP $d819
D6D9  A9 80        LDA #$80
D6DB  D0 02        BNE $d6df
D6DD  A9 90        LDA #$90
D6DF  05 78        ORA $78
D6E1  A6 98        LDX $98
D6E3  8D 4D 02     STA $024d
D6E6  AD 4D 02     LDA $024d
D6E9  20 61 D6     JSR $d661
D6EC  20 F9 D6     JSR $d6f9
D6EF  B0 FB        BCS $d6ec
D6F1  48           PHA
D6F2  A9 00        LDA #$00
D6F4  8D 98 02     STA $0298
D6F7  68           PLA
D6F8  60           RTS
D6F9  B5 02        LDA $02,X
D6FB  C9 02        CMP #$02
D6FD  90 14        BCC $d713
D6FF  C9 08        CMP #$08
D701  F0 08        BEQ $d70b
D703  C9 0B        CMP #$0b
D705  F0 04        BEQ $d70b
D707  C9 0F        CMP #$0f
D709  D0 0A        BNE $d715
D70B  2C 98 02     BIT $0298
D70E  30 03        BMI $d713
D710  4C 8A D7     JMP $d78a
D713  18           CLC
D714  60           RTS
D715  98           TYA
D716  48           PHA
D717  A5 78        LDA $78
D719  48           PHA
D71A  BD 5B 02     LDA $025b,X
D71D  29 01        AND #$01
D71F  85 78        STA $78
D721  20 F7 F3     JSR $f3f7
D724  20 F0 D7     JSR $d7f0
D727  C9 02        CMP #$02
D729  B0 03        BCS $d72e
D72B  4C B7 D7     JMP $d7b7
D72E  BD 5B 02     LDA $025b,X
D731  29 F0        AND #$f0
D733  48           PHA
D734  C9 90        CMP #$90
D736  D0 07        BNE $d73f
D738  A5 78        LDA $78
D73A  09 B8        ORA #$b8
D73C  9D 5B 02     STA $025b,X
D73F  24 69        BIT $69
D741  70 39        BVS $d77c
D743  A9 00        LDA #$00
D745  8D 99 02     STA $0299
D748  8D 9A 02     STA $029a
D74B  AC 99 02     LDY $0299
D74E  AD 9A 02     LDA $029a
D751  38           SEC
D752  F9 1E F1     SBC $f11e,Y
D755  8D 9A 02     STA $029a
D758  B9 1E F1     LDA $f11e,Y
D75B  20 C5 D7     JSR $d7c5
D75E  EE 99 02     INC $0299
D761  20 F0 D7     JSR $d7f0
D764  C9 02        CMP #$02
D766  90 08        BCC $d770
D768  AC 99 02     LDY $0299
D76B  B9 1E F1     LDA $f11e,Y
D76E  D0 DB        BNE $d74b
D770  AD 9A 02     LDA $029a
D773  20 C5 D7     JSR $d7c5
D776  B5 02        LDA $02,X
D778  C9 02        CMP #$02
D77A  90 2A        BCC $d7a6
D77C  24 69        BIT $69
D77E  10 0F        BPL $d78f
D780  68           PLA
D781  C9 90        CMP #$90
D783  D0 05        BNE $d78a
D785  05 78        ORA $78
D787  9D 5B 02     STA $025b,X
D78A  B5 02        LDA $02,X
D78C  20 46 E7     JSR $e746
D78F  68           PLA
D790  2C 98 02     BIT $0298
D793  30 22        BMI $d7b7
D795  48           PHA
D796  A9 C0        LDA #$c0
D798  05 78        ORA $78
D79A  95 02        STA $02,X
D79C  20 19 D8     JSR $d819
D79F  20 F0 D7     JSR $d7f0
D7A2  C9 02        CMP #$02
D7A4  B0 DA        BCS $d780
D7A6  68           PLA
D7A7  C9 90        CMP #$90
D7A9  D0 0C        BNE $d7b7
D7AB  05 78        ORA $78
D7AD  9D 5B 02     STA $025b,X
D7B0  20 F0 D7     JSR $d7f0
D7B3  C9 02        CMP #$02
D7B5  B0 D3        BCS $d78a
D7B7  68           PLA
D7B8  85 78        STA $78
D7BA  68           PLA
D7BB  A8           TAY
D7BC  B5 02        LDA $02,X
D7BE  48           PHA
D7BF  20 F0 F3     JSR $f3f0
D7C2  68           PLA
D7C3  18           CLC
D7C4  60           RTS
D7C5  C9 00        CMP #$00
D7C7  F0 18        BEQ $d7e1
D7C9  30 0C        BMI $d7d7
D7CB  A0 01        LDY #$01
D7CD  20 E2 D7     JSR $d7e2
D7D0  38           SEC
D7D1  E9 01        SBC #$01
D7D3  D0 F6        BNE $d7cb
D7D5  F0 0A        BEQ $d7e1
D7D7  A0 FF        LDY #$ff
D7D9  20 E2 D7     JSR $d7e2
D7DC  18           CLC
D7DD  69 01        ADC #$01
D7DF  D0 F6        BNE $d7d7
D7E1  60           RTS
D7E2  48           PHA
D7E3  98           TYA
D7E4  85 54        STA $54
D7E6  C5 54        CMP $54
D7E8  F0 FC        BEQ $d7e6
D7EA  A9 00        LDA #$00
D7EC  85 54        STA $54
D7EE  68           PLA
D7EF  60           RTS
D7F0  A5 69        LDA $69
D7F2  29 3F        AND #$3f
D7F4  A8           TAY
D7F5  BD 5B 02     LDA $025b,X
D7F8  95 02        STA $02,X
D7FA  20 19 D8     JSR $d819
D7FD  C9 02        CMP #$02
D7FF  90 03        BCC $d804
D801  88           DEY
D802  D0 F1        BNE $d7f5
D804  60           RTS
D805  20 CE E0     JSR $e0ce
D808  0A           ASL A
D809  A8           TAY
D80A  A5 79        LDA $79
D80C  99 08 00     STA $0008,Y
D80F  A5 7A        LDA $7a
D811  99 09 00     STA $0009,Y
D814  A5 78        LDA $78
D816  0A           ASL A
D817  AA           TAX
D818  60           RTS
D819  B5 02        LDA $02,X
D81B  30 FC        BMI $d819
D81D  60           RTS
D81E  A5 7C        LDA $7c
D820  48           PHA
D821  A5 7B        LDA $7b
D823  48           PHA
D824  A5 7A        LDA $7a
D826  48           PHA
D827  A5 79        LDA $79
D829  48           PHA
D82A  A9 11        LDA #$11
D82C  85 7C        STA $7c
D82E  20 76 DF     JSR $df76
D831  AD 4A 02     LDA $024a
D834  48           PHA
D835  A5 E3        LDA $e3
D837  29 01        AND #$01
D839  85 78        STA $78
D83B  A6 98        LDX $98
D83D  5D 5B 02     EOR $025b,X
D840  4A           LSR A
D841  90 0C        BCC $d84f
D843  A2 01        LDX #$01
D845  8E 92 02     STX $0292
D848  20 91 C6     JSR $c691
D84B  F0 1D        BEQ $d86a
D84D  D0 28        BNE $d877
D84F  AD 91 02     LDA $0291
D852  F0 0C        BEQ $d860
D854  C5 7A        CMP $7a
D856  F0 1F        BEQ $d877
D858  85 7A        STA $7a
D85A  20 B3 D5     JSR $d5b3
D85D  4C 77 D8     JMP $d877
D860  A9 01        LDA #$01
D862  8D 92 02     STA $0292
D865  20 FC C6     JSR $c6fc
D868  D0 0D        BNE $d877
D86A  20 E0 D5     JSR $d5e0
D86D  A5 7A        LDA $7a
D86F  8D 91 02     STA $0291
D872  A9 02        LDA #$02
D874  8D 92 02     STA $0292
D877  AD 92 02     LDA $0292
D87A  20 1B D6     JSR $d61b
D87D  68           PLA
D87E  8D 4A 02     STA $024a
D881  C9 04        CMP #$04
D883  D0 02        BNE $d887
D885  09 80        ORA #$80
D887  20 0D D1     JSR $d10d
D88A  68           PLA
D88B  8D 80 02     STA $0280
D88E  20 0D D1     JSR $d10d
D891  68           PLA
D892  8D 85 02     STA $0285
D895  20 0D D1     JSR $d10d
D898  20 CE E0     JSR $e0ce
D89B  A8           TAY
D89C  AD 7A 02     LDA $027a
D89F  AA           TAX
D8A0  A9 10        LDA #$10
D8A2  20 4F C7     JSR $c74f
D8A5  A0 10        LDY #$10
D8A7  A9 00        LDA #$00
D8A9  91 8D        STA ($8d),Y
D8AB  C8           INY
D8AC  C0 1B        CPY #$1b
D8AE  90 F9        BCC $d8a9
D8B0  AD 4A 02     LDA $024a
D8B3  C9 04        CMP #$04
D8B5  D0 13        BNE $d8ca
D8B7  A0 10        LDY #$10
D8B9  AD 59 02     LDA $0259
D8BC  91 8D        STA ($8d),Y
D8BE  C8           INY
D8BF  AD 5A 02     LDA $025a
D8C2  91 8D        STA ($8d),Y
D8C4  C8           INY
D8C5  AD 58 02     LDA $0258
D8C8  91 8D        STA ($8d),Y
D8CA  20 B7 D5     JSR $d5b7
D8CD  68           PLA
D8CE  85 7B        STA $7b
D8D0  AA           TAX
D8D1  68           PLA
D8D2  85 7C        STA $7c
D8D4  AD 91 02     LDA $0291
D8D7  85 D9        STA $d9
D8D9  9D 60 02     STA $0260,X
D8DC  AD 92 02     LDA $0292
D8DF  85 DE        STA $de
D8E1  9D 66 02     STA $0266,X
D8E4  AD 4A 02     LDA $024a
D8E7  85 E8        STA $e8
D8E9  A5 78        LDA $78
D8EB  85 E3        STA $e3
D8ED  60           RTS
D8EE  A5 7C        LDA $7c
D8F0  8D 4C 02     STA $024c
D8F3  20 9D C3     JSR $c39d
D8F6  8E 2A 02     STX $022a
D8F9  AE 00 02     LDX $0200
D8FC  AD 4C 02     LDA $024c
D8FF  D0 29        BNE $d92a
D901  E0 2A        CPX #$2a
D903  D0 25        BNE $d92a
D905  A5 77        LDA $77
D907  F0 4A        BEQ $d953
D909  85 79        STA $79
D90B  AD 6E 02     LDA $026e
D90E  85 78        STA $78
D910  85 E3        STA $e3
D912  A9 02        LDA #$02
D914  85 E8        STA $e8
D916  AD 6F 02     LDA $026f
D919  85 7A        STA $7a
D91B  20 7D DD     JSR $dd7d
D91E  A9 04        LDA #$04
D920  05 78        ORA $78
D922  A6 7B        LDX $7b
D924  99 ED 00     STA $00ed,Y
D927  4C 7E C2     JMP $c27e
D92A  E0 24        CPX #$24
D92C  D0 1E        BNE $d94c
D92E  AD 4C 02     LDA $024c
D931  D0 03        BNE $d936
D933  4C 8C DB     JMP $db8c
D936  20 BB C2     JSR $c2bb
D939  AD C3 F0     LDA $f0c3
D93C  85 79        STA $79
D93E  A9 00        LDA #$00
D940  85 7A        STA $7a
D942  20 7D DD     JSR $dd7d
D945  A5 78        LDA $78
D947  09 02        ORA #$02
D949  4C 22 D9     JMP $d922
D94C  E0 23        CPX #$23
D94E  D0 12        BNE $d962
D950  4C 76 CC     JMP $cc76
D953  A9 02        LDA #$02
D955  8D 96 02     STA $0296
D958  A9 00        LDA #$00
D95A  85 78        STA $78
D95C  8D 8E 02     STA $028e
D95F  20 5E D1     JSR $d15e
D962  20 CF C2     JSR $c2cf
D965  D0 04        BNE $d96b
D967  A2 00        LDX #$00
D969  F0 0C        BEQ $d977
D96B  8A           TXA
D96C  F0 05        BEQ $d973
D96E  A9 30        LDA #$30
D970  4C B2 C2     JMP $c2b2
D973  88           DEY
D974  F0 01        BEQ $d977
D976  88           DEY
D977  8C 7A 02     STY $027a
D97A  A9 8D        LDA #$8d
D97C  20 52 C3     JSR $c352
D97F  E8           INX
D980  8E 78 02     STX $0278
D983  20 FC C3     JSR $c3fc
D986  20 B7 C4     JSR $c4b7
D989  20 82 C5     JSR $c582
D98C  A2 00        LDX #$00
D98E  8E 58 02     STX $0258
D991  8E 97 02     STX $0297
D994  8E 4A 02     STX $024a
D997  E8           INX
D998  EC 77 02     CPX $0277
D99B  B0 10        BCS $d9ad
D99D  20 40 DB     JSR $db40
D9A0  E8           INX
D9A1  EC 77 02     CPX $0277
D9A4  B0 07        BCS $d9ad
D9A6  C0 04        CPY #$04
D9A8  F0 3E        BEQ $d9e8
D9AA  20 40 DB     JSR $db40
D9AD  AE 4C 02     LDX $024c
D9B0  86 7C        STX $7c
D9B2  E0 02        CPX #$02
D9B4  B0 12        BCS $d9c8
D9B6  8E 97 02     STX $0297
D9B9  A9 40        LDA #$40
D9BB  8D F9 02     STA $02f9
D9BE  AD 4A 02     LDA $024a
D9C1  D0 1B        BNE $d9de
D9C3  A9 02        LDA #$02
D9C5  8D 4A 02     STA $024a
D9C8  AD 4A 02     LDA $024a
D9CB  D0 11        BNE $d9de
D9CD  A5 E8        LDA $e8
D9CF  29 07        AND #$07
D9D1  8D 4A 02     STA $024a
D9D4  AD 80 02     LDA $0280
D9D7  D0 05        BNE $d9de
D9D9  A9 01        LDA #$01
D9DB  8D 4A 02     STA $024a
D9DE  AD 97 02     LDA $0297
D9E1  C9 01        CMP #$01
D9E3  F0 18        BEQ $d9fd
D9E5  4C 77 DA     JMP $da77
D9E8  BC 7A 02     LDY $027a,X
D9EB  B9 00 02     LDA $0200,Y
D9EE  8D 58 02     STA $0258
D9F1  AD 80 02     LDA $0280
D9F4  D0 B7        BNE $d9ad
D9F6  A9 01        LDA #$01
D9F8  8D 97 02     STA $0297
D9FB  D0 B0        BNE $d9ad
D9FD  A5 E8        LDA $e8
D9FF  29 80        AND #$80
DA01  AA           TAX
DA02  D0 14        BNE $da18
DA04  A9 20        LDA #$20
DA06  24 E8        BIT $e8
DA08  F0 06        BEQ $da10
DA0A  20 97 C9     JSR $c997
DA0D  4C 1A DB     JMP $db1a
DA10  AD 80 02     LDA $0280
DA13  D0 03        BNE $da18
DA15  4C 1A DB     JMP $db1a
DA18  AD 00 02     LDA $0200
DA1B  C9 40        CMP #$40
DA1D  F0 0D        BEQ $da2c
DA1F  8A           TXA
DA20  D0 05        BNE $da27
DA22  A9 63        LDA #$63
DA24  4C B2 C2     JMP $c2b2
DA27  A9 33        LDA #$33
DA29  4C B2 C2     JMP $c2b2
DA2C  A5 E8        LDA $e8
DA2E  29 07        AND #$07
DA30  CD 4A 02     CMP $024a
DA33  D0 67        BNE $da9c
DA35  C9 04        CMP #$04
DA37  F0 63        BEQ $da9c
DA39  20 15 DE     JSR $de15
DA3C  A5 7B        LDA $7b
DA3E  8D 70 02     STA $0270
DA41  A9 11        LDA #$11
DA43  85 7C        STA $7c
DA45  20 FB D1     JSR $d1fb
DA48  AD 94 02     LDA $0294
DA4B  20 1B D6     JSR $d61b
DA4E  A0 00        LDY #$00
DA50  B1 8D        LDA ($8d),Y
DA52  09 20        ORA #$20
DA54  91 8D        STA ($8d),Y
DA56  A0 1A        LDY #$1a
DA58  A5 79        LDA $79
DA5A  91 8D        STA ($8d),Y
DA5C  C8           INY
DA5D  A5 7A        LDA $7a
DA5F  91 8D        STA ($8d),Y
DA61  AE 70 02     LDX $0270
DA64  A5 D9        LDA $d9
DA66  9D 60 02     STA $0260,X
DA69  A5 DE        LDA $de
DA6B  9D 66 02     STA $0266,X
DA6E  20 76 DF     JSR $df76
DA71  20 B7 D5     JSR $d5b7
DA74  4C 26 DB     JMP $db26
DA77  AD 80 02     LDA $0280
DA7A  D0 05        BNE $da81
DA7C  A9 62        LDA #$62
DA7E  4C B2 C2     JMP $c2b2
DA81  AD 97 02     LDA $0297
DA84  C9 03        CMP #$03
DA86  F0 0B        BEQ $da93
DA88  A9 20        LDA #$20
DA8A  24 E8        BIT $e8
DA8C  F0 05        BEQ $da93
DA8E  A9 60        LDA #$60
DA90  4C B2 C2     JMP $c2b2
DA93  A5 E8        LDA $e8
DA95  29 07        AND #$07
DA97  CD 4A 02     CMP $024a
DA9A  F0 05        BEQ $daa1
DA9C  A9 64        LDA #$64
DA9E  4C B2 C2     JMP $c2b2
DAA1  A0 00        LDY #$00
DAA3  8C 79 02     STY $0279
DAA6  AE 97 02     LDX $0297
DAA9  E0 02        CPX #$02
DAAB  D0 1A        BNE $dac7
DAAD  C9 04        CMP #$04
DAAF  F0 EB        BEQ $da9c
DAB1  B1 8D        LDA ($8d),Y
DAB3  29 4F        AND #$4f
DAB5  91 8D        STA ($8d),Y
DAB7  A5 7C        LDA $7c
DAB9  48           PHA
DABA  A9 11        LDA #$11
DABC  85 7C        STA $7c
DABE  20 76 DF     JSR $df76
DAC1  20 B7 D5     JSR $d5b7
DAC4  68           PLA
DAC5  85 7C        STA $7c
DAC7  20 D7 DA     JSR $dad7
DACA  AD 97 02     LDA $0297
DACD  C9 02        CMP #$02
DACF  D0 55        BNE $db26
DAD1  20 61 DB     JSR $db61
DAD4  4C 7E C2     JMP $c27e
DAD7  A0 13        LDY #$13
DAD9  B1 8D        LDA ($8d),Y
DADB  8D 59 02     STA $0259
DADE  C8           INY
DADF  B1 8D        LDA ($8d),Y
DAE1  8D 5A 02     STA $025a
DAE4  C8           INY
DAE5  B1 8D        LDA ($8d),Y
DAE7  AE 58 02     LDX $0258
DAEA  8D 58 02     STA $0258
DAED  8A           TXA
DAEE  F0 0A        BEQ $dafa
DAF0  CD 58 02     CMP $0258
DAF3  F0 05        BEQ $dafa
DAF5  A9 50        LDA #$50
DAF7  20 B2 C2     JSR $c2b2
DAFA  AE 79 02     LDX $0279
DAFD  BD 80 02     LDA $0280,X
DB00  85 79        STA $79
DB02  BD 85 02     LDA $0285,X
DB05  85 7A        STA $7a
DB07  20 7D DD     JSR $dd7d
DB0A  A4 7B        LDY $7b
DB0C  AE 79 02     LDX $0279
DB0F  B5 D9        LDA $d9,X
DB11  99 60 02     STA $0260,Y
DB14  B5 DE        LDA $de,X
DB16  99 66 02     STA $0266,Y
DB19  60           RTS
DB1A  A5 E3        LDA $e3
DB1C  29 01        AND #$01
DB1E  85 78        STA $78
DB20  20 15 DE     JSR $de15
DB23  20 1E D8     JSR $d81e
DB26  A5 7C        LDA $7c
DB28  C9 02        CMP #$02
DB2A  B0 11        BCS $db3d
DB2C  20 79 DF     JSR $df79
DB2F  A5 79        LDA $79
DB31  85 77        STA $77
DB33  A5 78        LDA $78
DB35  8D 6E 02     STA $026e
DB38  A5 7A        LDA $7a
DB3A  8D 6F 02     STA $026f
DB3D  4C 83 C2     JMP $c283
DB40  BC 7A 02     LDY $027a,X
DB43  B9 00 02     LDA $0200,Y
DB46  A0 04        LDY #$04
DB48  88           DEY
DB49  30 08        BMI $db53
DB4B  D9 F3 F0     CMP $f0f3,Y
DB4E  D0 F8        BNE $db48
DB50  8C 97 02     STY $0297
DB53  A0 05        LDY #$05
DB55  88           DEY
DB56  30 08        BMI $db60
DB58  D9 F7 F0     CMP $f0f7,Y
DB5B  D0 F8        BNE $db55
DB5D  8C 4A 02     STY $024a
DB60  60           RTS
DB61  20 2E CB     JSR $cb2e
DB64  A9 80        LDA #$80
DB66  20 E1 DE     JSR $dee1
DB69  F0 F6        BEQ $db61
DB6B  20 D0 DF     JSR $dfd0
DB6E  A6 7A        LDX $7a
DB70  E8           INX
DB71  8A           TXA
DB72  D0 05        BNE $db79
DB74  20 F9 D2     JSR $d2f9
DB77  A9 02        LDA #$02
DB79  20 1B D6     JSR $d61b
DB7C  A6 7B        LDX $7b
DB7E  A9 01        LDA #$01
DB80  95 F3        STA $f3,X
DB82  A9 80        LDA #$80
DB84  05 7B        ORA $7b
DB86  A6 7C        LDX $7c
DB88  9D 2B 02     STA $022b,X
DB8B  60           RTS
DB8C  A9 0D        LDA #$0d
DB8E  8D 2A 02     STA $022a
DB91  A9 00        LDA #$00
DB93  AE 74 02     LDX $0274
DB96  CA           DEX
DB97  F0 0B        BEQ $dba4
DB99  CA           DEX
DB9A  D0 21        BNE $dbbd
DB9C  AD 01 02     LDA $0201
DB9F  20 A5 C4     JSR $c4a5
DBA2  30 19        BMI $dbbd
DBA4  85 E3        STA $e3
DBA6  EE 77 02     INC $0277
DBA9  EE 78 02     INC $0278
DBAC  EE 7A 02     INC $027a
DBAF  A9 80        LDA #$80
DBB1  85 E8        STA $e8
DBB3  A9 2A        LDA #$2a
DBB5  8D 00 02     STA $0200
DBB8  8D 01 02     STA $0201
DBBB  D0 18        BNE $dbd5
DBBD  20 CF C2     JSR $c2cf
DBC0  D0 05        BNE $dbc7
DBC2  20 C6 C3     JSR $c3c6
DBC5  A0 03        LDY #$03
DBC7  88           DEY
DBC8  88           DEY
DBC9  8C 7A 02     STY $027a
DBCC  20 EA C2     JSR $c2ea
DBCF  20 80 C4     JSR $c480
DBD2  20 0A C4     JSR $c40a
DBD5  20 B7 C4     JSR $c4b7
DBD8  20 98 C8     JSR $c898
DBDB  20 82 C5     JSR $c582
DBDE  20 0B EB     JSR $eb0b
DBE1  20 47 D2     JSR $d247
DBE4  A6 7B        LDX $7b
DBE6  9D 3E 02     STA $023e,X
DBE9  A5 78        LDA $78
DBEB  8D 8E 02     STA $028e
DBEE  09 04        ORA #$04
DBF0  95 ED        STA $ed,X
DBF2  A9 00        LDA #$00
DBF4  85 A4        STA $a4
DBF6  60           RTS
DBF7  A9 00        LDA #$00
DBF9  8D F9 02     STA $02f9
DBFC  A5 7C        LDA $7c
DBFE  D0 0B        BNE $dc0b
DC00  A9 00        LDA #$00
DC02  8D 54 02     STA $0254
DC05  20 7D D3     JSR $d37d
DC08  4C 2D D6     JMP $d62d
DC0B  C9 0F        CMP #$0f
DC0D  F0 14        BEQ $dc23
DC0F  20 39 DC     JSR $dc39
DC12  A5 7C        LDA $7c
DC14  C9 02        CMP #$02
DC16  90 F0        BCC $dc08
DC18  AD 6C 02     LDA $026c
DC1B  D0 03        BNE $dc20
DC1D  4C 7E C2     JMP $c27e
DC20  4C 97 C2     JMP $c297
DC23  A9 0E        LDA #$0e
DC25  85 7C        STA $7c
DC27  20 39 DC     JSR $dc39
DC2A  C6 7C        DEC $7c
DC2C  10 F9        BPL $dc27
DC2E  AD 6C 02     LDA $026c
DC31  D0 03        BNE $dc36
DC33  4C 7E C2     JMP $c27e
DC36  4C 97 C2     JMP $c297
DC39  A6 7C        LDX $7c
DC3B  BD 2B 02     LDA $022b,X
DC3E  C9 FF        CMP #$ff
DC40  D0 01        BNE $dc43
DC42  60           RTS
DC43  29 0F        AND #$0f
DC45  85 7B        STA $7b
DC47  20 35 D2     JSR $d235
DC4A  C9 07        CMP #$07
DC4C  F0 0F        BEQ $dc5d
DC4E  C9 04        CMP #$04
DC50  F0 11        BEQ $dc63
DC52  20 17 D2     JSR $d217
DC55  B0 09        BCS $dc60
DC57  20 99 DC     JSR $dc99
DC5A  20 DC DC     JSR $dcdc
DC5D  20 5F ED     JSR $ed5f
DC60  4C 7D D3     JMP $d37d
DC63  20 2C DF     JSR $df2c
DC66  20 D4 CF     JSR $cfd4
DC69  20 06 E3     JSR $e306
DC6C  A6 92        LDX $92
DC6E  86 72        STX $72
DC70  E6 72        INC $72
DC72  A9 00        LDA #$00
DC74  85 6F        STA $6f
DC76  85 70        STA $70
DC78  A5 93        LDA $93
DC7A  38           SEC
DC7B  E9 0E        SBC #$0e
DC7D  85 71        STA $71
DC7F  20 8C E0     JSR $e08c
DC82  A6 7B        LDX $7b
DC84  A5 6F        LDA $6f
DC86  95 B6        STA $b6,X
DC88  A5 70        LDA $70
DC8A  95 BC        STA $bc,X
DC8C  A9 40        LDA #$40
DC8E  20 E1 DE     JSR $dee1
DC91  F0 03        BEQ $dc96
DC93  20 DC DC     JSR $dcdc
DC96  4C 7D D3     JMP $d37d
DC99  A6 7B        LDX $7b
DC9B  B5 B6        LDA $b6,X
DC9D  15 BC        ORA $bc,X
DC9F  D0 0C        BNE $dcad
DCA1  20 3B D6     JSR $d63b
DCA4  C9 02        CMP #$02
DCA6  D0 05        BNE $dcad
DCA8  A9 0D        LDA #$0d
DCAA  20 0D D1     JSR $d10d
DCAD  20 3B D6     JSR $d63b
DCB0  C9 02        CMP #$02
DCB2  D0 0F        BNE $dcc3
DCB4  20 D4 CF     JSR $cfd4
DCB7  A6 7B        LDX $7b
DCB9  B5 B6        LDA $b6,X
DCBB  D0 02        BNE $dcbf
DCBD  D6 BC        DEC $bc,X
DCBF  D6 B6        DEC $b6,X
DCC1  A9 00        LDA #$00
DCC3  38           SEC
DCC4  E9 01        SBC #$01
DCC6  48           PHA
DCC7  A9 00        LDA #$00
DCC9  20 1B D6     JSR $d61b
DCCC  20 0D D1     JSR $d10d
DCCF  68           PLA
DCD0  20 0D D1     JSR $d10d
DCD3  20 D7 D1     JSR $d1d7
DCD6  20 EC D6     JSR $d6ec
DCD9  4C D4 CF     JMP $cfd4
DCDC  A6 7B        LDX $7b
DCDE  8E 70 02     STX $0270
DCE1  A5 7C        LDA $7c
DCE3  48           PHA
DCE4  BD 60 02     LDA $0260,X
DCE7  85 7A        STA $7a
DCE9  BD 66 02     LDA $0266,X
DCEC  8D 94 02     STA $0294
DCEF  B5 ED        LDA $ed,X
DCF1  29 01        AND #$01
DCF3  85 78        STA $78
DCF5  AD C3 F0     LDA $f0c3
DCF8  85 79        STA $79
DCFA  20 CE E0     JSR $e0ce
DCFD  48           PHA
DCFE  85 98        STA $98
DD00  20 B3 D5     JSR $d5b3
DD03  A0 00        LDY #$00
DD05  BD 23 F1     LDA $f123,X
DD08  85 80        STA $80
DD0A  AD 94 02     LDA $0294
DD0D  85 7F        STA $7f
DD0F  B1 7F        LDA ($7f),Y
DD11  29 20        AND #$20
DD13  F0 43        BEQ $dd58
DD15  20 35 D2     JSR $d235
DD18  C9 04        CMP #$04
DD1A  F0 44        BEQ $dd60
DD1C  B1 7F        LDA ($7f),Y
DD1E  29 8F        AND #$8f
DD20  91 7F        STA ($7f),Y
DD22  C8           INY
DD23  B1 7F        LDA ($7f),Y
DD25  85 79        STA $79
DD27  84 70        STY $70
DD29  A0 1B        LDY #$1b
DD2B  B1 7F        LDA ($7f),Y
DD2D  48           PHA
DD2E  88           DEY
DD2F  B1 7F        LDA ($7f),Y
DD31  D0 0A        BNE $dd3d
DD33  85 79        STA $79
DD35  68           PLA
DD36  85 7A        STA $7a
DD38  A9 67        LDA #$67
DD3A  20 81 E7     JSR $e781
DD3D  48           PHA
DD3E  A9 00        LDA #$00
DD40  91 7F        STA ($7f),Y
DD42  C8           INY
DD43  91 7F        STA ($7f),Y
DD45  68           PLA
DD46  A4 70        LDY $70
DD48  91 7F        STA ($7f),Y
DD4A  C8           INY
DD4B  B1 7F        LDA ($7f),Y
DD4D  85 7A        STA $7a
DD4F  68           PLA
DD50  91 7F        STA ($7f),Y
DD52  20 5E C9     JSR $c95e
DD55  4C 60 DD     JMP $dd60
DD58  B1 7F        LDA ($7f),Y
DD5A  29 0F        AND #$0f
DD5C  09 80        ORA #$80
DD5E  91 7F        STA ($7f),Y
DD60  AE 70 02     LDX $0270
DD63  A0 1C        LDY #$1c
DD65  B5 B6        LDA $b6,X
DD67  91 7F        STA ($7f),Y
DD69  C8           INY
DD6A  B5 BC        LDA $bc,X
DD6C  91 7F        STA ($7f),Y
DD6E  68           PLA
DD6F  AA           TAX
DD70  A9 90        LDA #$90
DD72  05 78        ORA $78
DD74  20 E3 D6     JSR $d6e3
DD77  68           PLA
DD78  85 7C        STA $7c
DD7A  4C 17 D2     JMP $d217
DD7D  A9 01        LDA #$01
DD7F  20 38 D3     JSR $d338
DD82  20 ED DD     JSR $dded
DD85  AD 4A 02     LDA $024a
DD88  48           PHA
DD89  0A           ASL A
DD8A  05 78        ORA $78
DD8C  95 ED        STA $ed,X
DD8E  20 AB D1     JSR $d1ab
DD91  A6 7B        LDX $7b
DD93  A5 79        LDA $79
DD95  D0 05        BNE $dd9c
DD97  A5 7A        LDA $7a
DD99  9D 44 02     STA $0244,X
DD9C  68           PLA
DD9D  C9 04        CMP #$04
DD9F  D0 3F        BNE $dde0
DDA1  A4 7C        LDY $7c
DDA3  B9 2B 02     LDA $022b,Y
DDA6  09 40        ORA #$40
DDA8  99 2B 02     STA $022b,Y
DDAB  AD 58 02     LDA $0258
DDAE  95 C8        STA $c8,X
DDB0  20 E4 D3     JSR $d3e4
DDB3  10 03        BPL $ddb8
DDB5  4C 65 D3     JMP $d365
DDB8  A6 7B        LDX $7b
DDBA  95 CE        STA $ce,X
DDBC  AC 59 02     LDY $0259
DDBF  84 79        STY $79
DDC1  AC 5A 02     LDY $025a
DDC4  84 7A        STY $7a
DDC6  20 08 D8     JSR $d808
DDC9  20 AE DF     JSR $dfae
DDCC  20 EC D6     JSR $d6ec
DDCF  A6 7B        LDX $7b
DDD1  A9 02        LDA #$02
DDD3  95 C2        STA $c2,X
DDD5  A9 00        LDA #$00
DDD7  20 1B D6     JSR $d61b
DDDA  20 8E E2     JSR $e28e
DDDD  4C 79 DF     JMP $df79
DDE0  20 71 D2     JSR $d271
DDE3  A6 7B        LDX $7b
DDE5  9D 3E 02     STA $023e,X
DDE8  A9 88        LDA #$88
DDEA  95 F3        STA $f3,X
DDEC  60           RTS
DDED  A6 7B        LDX $7b
DDEF  B5 A8        LDA $a8,X
DDF1  0A           ASL A
DDF2  30 06        BMI $ddfa
DDF4  A8           TAY
DDF5  A9 02        LDA #$02
DDF7  99 9A 00     STA $009a,Y
DDFA  B5 AF        LDA $af,X
DDFC  09 80        ORA #$80
DDFE  95 AF        STA $af,X
DE00  0A           ASL A
DE01  30 06        BMI $de09
DE03  A8           TAY
DE04  A9 02        LDA #$02
DE06  99 9A 00     STA $009a,Y
DE09  A9 00        LDA #$00
DE0B  95 B6        STA $b6,X
DE0D  95 BC        STA $bc,X
DE0F  A9 00        LDA #$00
DE11  9D 44 02     STA $0244,X
DE14  60           RTS
DE15  20 14 F0     JSR $f014
DE18  A9 01        LDA #$01
DE1A  20 35 D3     JSR $d335
DE1D  20 05 D8     JSR $d805
DE20  20 ED DD     JSR $dded
DE23  A6 7B        LDX $7b
DE25  AD 4A 02     LDA $024a
DE28  48           PHA
DE29  0A           ASL A
DE2A  05 78        ORA $78
DE2C  95 ED        STA $ed,X
DE2E  68           PLA
DE2F  C9 04        CMP #$04
DE31  F0 05        BEQ $de38
DE33  A9 01        LDA #$01
DE35  95 F3        STA $f3,X
DE37  60           RTS
DE38  A4 7C        LDY $7c
DE3A  B9 2B 02     LDA $022b,Y
DE3D  29 3F        AND #$3f
DE3F  09 40        ORA #$40
DE41  99 2B 02     STA $022b,Y
DE44  AD 58 02     LDA $0258
DE47  95 C8        STA $c8,X
DE49  20 E4 D3     JSR $d3e4
DE4C  10 03        BPL $de51
DE4E  4C 65 D3     JMP $d365
DE51  A6 7B        LDX $7b
DE53  95 CE        STA $ce,X
DE55  20 FC DF     JSR $dffc
DE58  20 89 EF     JSR $ef89
DE5B  A5 79        LDA $79
DE5D  8D 59 02     STA $0259
DE60  A5 7A        LDA $7a
DE62  8D 5A 02     STA $025a
DE65  A6 7B        LDX $7b
DE67  B5 CE        LDA $ce,X
DE69  20 08 D8     JSR $d808
DE6C  A9 00        LDA #$00
DE6E  20 24 E0     JSR $e024
DE71  A9 00        LDA #$00
DE73  20 C8 DE     JSR $dec8
DE76  A9 11        LDA #$11
DE78  20 C8 DE     JSR $dec8
DE7B  A9 00        LDA #$00
DE7D  20 C8 DE     JSR $dec8
DE80  AD 58 02     LDA $0258
DE83  20 C8 DE     JSR $dec8
DE86  A5 79        LDA $79
DE88  20 C8 DE     JSR $dec8
DE8B  A5 7A        LDA $7a
DE8D  20 C8 DE     JSR $dec8
DE90  A9 10        LDA #$10
DE92  20 24 E0     JSR $e024
DE95  20 79 DF     JSR $df79
DE98  A5 79        LDA $79
DE9A  20 C8 DE     JSR $dec8
DE9D  A5 7A        LDA $7a
DE9F  20 C8 DE     JSR $dec8
DEA2  20 A7 DF     JSR $dfa7
DEA5  20 EC D6     JSR $d6ec
DEA8  A9 02        LDA #$02
DEAA  20 1B D6     JSR $d61b
DEAD  A6 7B        LDX $7b
DEAF  38           SEC
DEB0  A9 00        LDA #$00
DEB2  F5 C8        SBC $c8,X
DEB4  95 C2        STA $c2,X
DEB6  20 1D E4     JSR $e41d
DEB9  20 54 DF     JSR $df54
DEBC  20 99 DF     JSR $df99
DEBF  20 EC D6     JSR $d6ec
DEC2  20 5F ED     JSR $ed5f
DEC5  4C CF DD     JMP $ddcf
DEC8  48           PHA
DEC9  A6 7B        LDX $7b
DECB  B5 CE        LDA $ce,X
DECD  4C 19 D1     JMP $d119
DED0  90 06        BCC $ded8
DED2  A6 7B        LDX $7b
DED4  15 ED        ORA $ed,X
DED6  D0 06        BNE $dede
DED8  A6 7B        LDX $7b
DEDA  49 FF        EOR #$ff
DEDC  35 ED        AND $ed,X
DEDE  95 ED        STA $ed,X
DEE0  60           RTS
DEE1  A6 7B        LDX $7b
DEE3  35 ED        AND $ed,X
DEE5  60           RTS
DEE6  20 CE E0     JSR $e0ce
DEE9  AA           TAX
DEEA  BD 5B 02     LDA $025b,X
DEED  29 F0        AND #$f0
DEEF  C9 90        CMP #$90
DEF1  60           RTS
DEF2  A2 00        LDX #$00
DEF4  86 70        STX $70
DEF6  BD 2B 02     LDA $022b,X
DEF9  C9 FF        CMP #$ff
DEFB  D0 08        BNE $df05
DEFD  A6 70        LDX $70
DEFF  E8           INX
DF00  E0 10        CPX #$10
DF02  90 F0        BCC $def4
DF04  60           RTS
DF05  86 70        STX $70
DF07  29 3F        AND #$3f
DF09  A8           TAY
DF0A  B9 ED 00     LDA $00ed,Y
DF0D  29 01        AND #$01
DF0F  85 6F        STA $6f
DF11  AE 53 02     LDX $0253
DF14  B5 E3        LDA $e3,X
DF16  29 01        AND #$01
DF18  C5 6F        CMP $6f
DF1A  D0 E1        BNE $defd
DF1C  B9 60 02     LDA $0260,Y
DF1F  D5 D9        CMP $d9,X
DF21  D0 DA        BNE $defd
DF23  B9 66 02     LDA $0266,Y
DF26  D5 DE        CMP $de,X
DF28  D0 D3        BNE $defd
DF2A  18           CLC
DF2B  60           RTS
DF2C  20 D9 E0     JSR $e0d9
DF2F  50 06        BVC $df37
DF31  20 99 DF     JSR $df99
DF34  20 EC D6     JSR $d6ec
DF37  60           RTS
DF38  20 66 DF     JSR $df66
DF3B  A5 79        LDA $79
DF3D  91 8D        STA ($8d),Y
DF3F  C8           INY
DF40  A5 7A        LDA $7a
DF42  91 8D        STA ($8d),Y
DF44  4C 40 E2     JMP $e240
DF47  20 66 DF     JSR $df66
DF4A  B1 8D        LDA ($8d),Y
DF4C  85 79        STA $79
DF4E  C8           INY
DF4F  B1 8D        LDA ($8d),Y
DF51  85 7A        STA $7a
DF53  60           RTS
DF54  20 66 DF     JSR $df66
DF57  A9 00        LDA #$00
DF59  91 8D        STA ($8d),Y
DF5B  C8           INY
DF5C  A6 7B        LDX $7b
DF5E  B5 C2        LDA $c2,X
DF60  AA           TAX
DF61  CA           DEX
DF62  8A           TXA
DF63  91 8D        STA ($8d),Y
DF65  60           RTS
DF66  20 CE E0     JSR $e0ce
DF69  0A           ASL A
DF6A  AA           TAX
DF6B  B5 9B        LDA $9b,X
DF6D  85 8E        STA $8e
DF6F  A9 00        LDA #$00
DF71  85 8D        STA $8d
DF73  A0 00        LDY #$00
DF75  60           RTS
DF76  20 FB D1     JSR $d1fb
DF79  20 CE E0     JSR $e0ce
DF7C  85 98        STA $98
DF7E  0A           ASL A
DF7F  A8           TAY
DF80  B9 08 00     LDA $0008,Y
DF83  85 79        STA $79
DF85  B9 09 00     LDA $0009,Y
DF88  85 7A        STA $7a
DF8A  60           RTS
DF8B  A9 90        LDA #$90
DF8D  8D 4D 02     STA $024d
DF90  D0 28        BNE $dfba
DF92  A9 80        LDA #$80
DF94  8D 4D 02     STA $024d
DF97  D0 21        BNE $dfba
DF99  A9 90        LDA #$90
DF9B  8D 4D 02     STA $024d
DF9E  D0 26        BNE $dfc6
DFA0  A9 80        LDA #$80
DFA2  8D 4D 02     STA $024d
DFA5  D0 1F        BNE $dfc6
DFA7  A9 90        LDA #$90
DFA9  8D 4D 02     STA $024d
DFAC  D0 02        BNE $dfb0
DFAE  A9 80        LDA #$80
DFB0  8D 4D 02     STA $024d
DFB3  A6 7B        LDX $7b
DFB5  B5 CE        LDA $ce,X
DFB7  AA           TAX
DFB8  10 13        BPL $dfcd
DFBA  20 05 D8     JSR $d805
DFBD  20 CE E0     JSR $e0ce
DFC0  AA           TAX
DFC1  A5 78        LDA $78
DFC3  9D 5B 02     STA $025b,X
DFC6  20 50 E2     JSR $e250
DFC9  20 CE E0     JSR $e0ce
DFCC  AA           TAX
DFCD  4C 59 D6     JMP $d659
DFD0  A9 00        LDA #$00
DFD2  20 1B D6     JSR $d61b
DFD5  20 47 D2     JSR $d247
DFD8  85 79        STA $79
DFDA  20 47 D2     JSR $d247
DFDD  85 7A        STA $7a
DFDF  60           RTS
DFE0  48           PHA
DFE1  A9 00        LDA #$00
DFE3  85 6E        STA $6e
DFE5  85 70        STA $70
DFE7  B9 23 F1     LDA $f123,Y
DFEA  85 6F        STA $6f
DFEC  BD 23 F1     LDA $f123,X
DFEF  85 71        STA $71
DFF1  68           PLA
DFF2  A8           TAY
DFF3  88           DEY
DFF4  B1 6E        LDA ($6e),Y
DFF6  91 70        STA ($70),Y
DFF8  88           DEY
DFF9  10 F9        BPL $dff4
DFFB  60           RTS
DFFC  A8           TAY
DFFD  B9 23 F1     LDA $f123,Y
E000  85 6F        STA $6f
E002  A9 00        LDA #$00
E004  85 6E        STA $6e
E006  A8           TAY
E007  91 6E        STA ($6e),Y
E009  C8           INY
E00A  D0 FB        BNE $e007
E00C  60           RTS
E00D  A9 00        LDA #$00
E00F  20 17 E0     JSR $e017
E012  A0 02        LDY #$02
E014  B1 8D        LDA ($8d),Y
E016  60           RTS
E017  85 8D        STA $8d
E019  A6 7B        LDX $7b
E01B  B5 CE        LDA $ce,X
E01D  AA           TAX
E01E  BD 23 F1     LDA $f123,X
E021  85 8E        STA $8e
E023  60           RTS
E024  48           PHA
E025  20 17 E0     JSR $e017
E028  48           PHA
E029  8A           TXA
E02A  0A           ASL A
E02B  AA           TAX
E02C  68           PLA
E02D  95 9B        STA $9b,X
E02F  68           PLA
E030  95 9A        STA $9a,X
E032  60           RTS
E033  20 A1 E0     JSR $e0a1
E036  30 0E        BMI $e046
E038  50 13        BVC $e04d
E03A  A6 7B        LDX $7b
E03C  B5 CE        LDA $ce,X
E03E  20 56 E0     JSR $e056
E041  20 A1 E0     JSR $e0a1
E044  10 07        BPL $e04d
E046  20 06 E3     JSR $e306
E049  2C 0F F1     BIT $f10f
E04C  60           RTS
E04D  A5 93        LDA $93
E04F  20 24 E0     JSR $e024
E052  2C 0E F1     BIT $f10e
E055  60           RTS
E056  85 98        STA $98
E058  A9 80        LDA #$80
E05A  D0 04        BNE $e060
E05C  85 98        STA $98
E05E  A9 90        LDA #$90
E060  48           PHA
E061  B5 ED        LDA $ed,X
E063  29 01        AND #$01
E065  85 78        STA $78
E067  68           PLA
E068  05 78        ORA $78
E06A  8D 4D 02     STA $024d
E06D  B1 8D        LDA ($8d),Y
E06F  85 79        STA $79
E071  C8           INY
E072  B1 8D        LDA ($8d),Y
E074  85 7A        STA $7a
E076  A5 98        LDA $98
E078  20 08 D8     JSR $d808
E07B  A6 98        LDX $98
E07D  4C E6 D6     JMP $d6e6
E080  A6 7B        LDX $7b
E082  B5 CE        LDA $ce,X
E084  4C 3E D6     JMP $d63e
E087  A9 78        LDA #$78
E089  20 97 E0     JSR $e097
E08C  CA           DEX
E08D  10 F8        BPL $e087
E08F  A5 71        LDA $71
E091  4A           LSR A
E092  20 97 E0     JSR $e097
E095  A5 72        LDA $72
E097  18           CLC
E098  65 6F        ADC $6f
E09A  85 6F        STA $6f
E09C  90 02        BCC $e0a0
E09E  E6 70        INC $70
E0A0  60           RTS
E0A1  20 0D E0     JSR $e00d
E0A4  C5 92        CMP $92
E0A6  D0 0E        BNE $e0b6
E0A8  A4 93        LDY $93
E0AA  B1 8D        LDA ($8d),Y
E0AC  F0 04        BEQ $e0b2
E0AE  2C 0E F1     BIT $f10e
E0B1  60           RTS
E0B2  2C 10 F1     BIT $f110
E0B5  60           RTS
E0B6  A5 92        LDA $92
E0B8  C9 06        CMP #$06
E0BA  B0 0A        BCS $e0c6
E0BC  0A           ASL A
E0BD  A8           TAY
E0BE  A9 04        LDA #$04
E0C0  85 8D        STA $8d
E0C2  B1 8D        LDA ($8d),Y
E0C4  D0 04        BNE $e0ca
E0C6  2C 11 F1     BIT $f111
E0C9  60           RTS
E0CA  2C 0F F1     BIT $f10f
E0CD  60           RTS
E0CE  A6 7B        LDX $7b
E0D0  B5 A8        LDA $a8,X
E0D2  10 02        BPL $e0d6
E0D4  B5 AF        LDA $af,X
E0D6  29 BF        AND #$bf
E0D8  60           RTS
E0D9  A6 7B        LDX $7b
E0DB  8E 57 02     STX $0257
E0DE  B5 A8        LDA $a8,X
E0E0  10 09        BPL $e0eb
E0E2  8A           TXA
E0E3  18           CLC
E0E4  69 07        ADC #$07
E0E6  8D 57 02     STA $0257
E0E9  B5 AF        LDA $af,X
E0EB  85 6F        STA $6f
E0ED  29 1F        AND #$1f
E0EF  24 6F        BIT $6f
E0F1  60           RTS
E0F2  A6 7B        LDX $7b
E0F4  B5 A8        LDA $a8,X
E0F6  30 02        BMI $e0fa
E0F8  B5 AF        LDA $af,X
E0FA  C9 FF        CMP #$ff
E0FC  60           RTS
E0FD  A6 7B        LDX $7b
E0FF  09 80        ORA #$80
E101  B4 A8        LDY $a8,X
E103  10 03        BPL $e108
E105  95 A8        STA $a8,X
E107  60           RTS
E108  95 AF        STA $af,X
E10A  60           RTS
E10B  A9 20        LDA #$20
E10D  20 D8 DE     JSR $ded8
E110  A9 80        LDA #$80
E112  20 E1 DE     JSR $dee1
E115  D0 41        BNE $e158
E117  A6 7B        LDX $7b
E119  F6 B6        INC $b6,X
E11B  D0 02        BNE $e11f
E11D  F6 BC        INC $bc,X
E11F  A6 7B        LDX $7b
E121  B5 C2        LDA $c2,X
E123  F0 2E        BEQ $e153
E125  20 3B D6     JSR $d63b
E128  A6 7B        LDX $7b
E12A  D5 C2        CMP $c2,X
E12C  90 03        BCC $e131
E12E  20 77 E1     JSR $e177
E131  A6 7B        LDX $7b
E133  B5 C2        LDA $c2,X
E135  20 1B D6     JSR $d61b
E138  A1 9A        LDA ($9a,X)
E13A  85 7E        STA $7e
E13C  A9 20        LDA #$20
E13E  20 D8 DE     JSR $ded8
E141  20 3F E4     JSR $e43f
E144  48           PHA
E145  90 28        BCC $e16f
E147  A9 00        LDA #$00
E149  20 49 D6     JSR $d649
E14C  D0 21        BNE $e16f
E14E  68           PLA
E14F  C9 02        CMP #$02
E151  F0 12        BEQ $e165
E153  A9 80        LDA #$80
E155  20 D2 DE     JSR $ded2
E158  20 3F D2     JSR $d23f
E15B  B5 9A        LDA $9a,X
E15D  99 44 02     STA $0244,Y
E160  A9 0D        LDA #$0d
E162  85 7E        STA $7e
E164  60           RTS
E165  20 70 E1     JSR $e170
E168  A6 7B        LDX $7b
E16A  A9 00        LDA #$00
E16C  95 C2        STA $c2,X
E16E  60           RTS
E16F  68           PLA
E170  A6 7B        LDX $7b
E172  95 C2        STA $c2,X
E174  4C A9 E2     JMP $e2a9
E177  20 29 D3     JSR $d329
E17A  20 D0 DF     JSR $dfd0
E17D  20 D9 E0     JSR $e0d9
E180  50 16        BVC $e198
E182  20 99 DF     JSR $df99
E185  20 D4 CF     JSR $cfd4
E188  A9 02        LDA #$02
E18A  20 1B D6     JSR $d61b
E18D  20 E6 DE     JSR $dee6
E190  D0 24        BNE $e1b6
E192  20 92 DF     JSR $df92
E195  4C EC D6     JMP $d6ec
E198  20 D4 CF     JSR $cfd4
E19B  20 E6 DE     JSR $dee6
E19E  D0 06        BNE $e1a6
E1A0  20 92 DF     JSR $df92
E1A3  20 EC D6     JSR $d6ec
E1A6  20 D0 DF     JSR $dfd0
E1A9  A5 79        LDA $79
E1AB  F0 09        BEQ $e1b6
E1AD  20 D4 CF     JSR $cfd4
E1B0  20 92 DF     JSR $df92
E1B3  20 D4 CF     JSR $cfd4
E1B6  60           RTS
E1B7  20 40 E2     JSR $e240
E1BA  20 CE E0     JSR $e0ce
E1BD  0A           ASL A
E1BE  AA           TAX
E1BF  A5 7E        LDA $7e
E1C1  81 9A        STA ($9a,X)
E1C3  B4 9A        LDY $9a,X
E1C5  C8           INY
E1C6  D0 09        BNE $e1d1
E1C8  A4 7B        LDY $7b
E1CA  B9 C2 00     LDA $00c2,Y
E1CD  F0 0A        BEQ $e1d9
E1CF  A0 02        LDY #$02
E1D1  98           TYA
E1D2  A4 7B        LDY $7b
E1D4  D9 C2 00     CMP $00c2,Y
E1D7  D0 05        BNE $e1de
E1D9  A9 20        LDA #$20
E1DB  4C D2 DE     JMP $ded2
E1DE  F6 9A        INC $9a,X
E1E0  D0 03        BNE $e1e5
E1E2  20 77 E1     JSR $e177
E1E5  60           RTS
E1E6  A9 A0        LDA #$a0
E1E8  20 E1 DE     JSR $dee1
E1EB  D0 27        BNE $e214
E1ED  A5 7E        LDA $7e
E1EF  20 B7 E1     JSR $e1b7
E1F2  A5 95        LDA $95
E1F4  F0 0D        BEQ $e203
E1F6  60           RTS
E1F7  A9 20        LDA #$20
E1F9  20 E1 DE     JSR $dee1
E1FC  F0 05        BEQ $e203
E1FE  A9 51        LDA #$51
E200  8D 6C 02     STA $026c
E203  20 2E E2     JSR $e22e
E206  20 8E E2     JSR $e28e
E209  AD 6C 02     LDA $026c
E20C  F0 03        BEQ $e211
E20E  4C B2 C2     JMP $c2b2
E211  4C FB E7     JMP $e7fb
E214  29 80        AND #$80
E216  D0 05        BNE $e21d
E218  A5 95        LDA $95
E21A  F0 DB        BEQ $e1f7
E21C  60           RTS
E21D  A5 7E        LDA $7e
E21F  48           PHA
E220  20 57 E4     JSR $e457
E223  68           PLA
E224  85 7E        STA $7e
E226  A9 80        LDA #$80
E228  20 D8 DE     JSR $ded8
E22B  4C ED E1     JMP $e1ed
E22E  A9 20        LDA #$20
E230  20 E1 DE     JSR $dee1
E233  D0 0A        BNE $e23f
E235  A9 00        LDA #$00
E237  85 7E        STA $7e
E239  20 B7 E1     JSR $e1b7
E23C  4C 2E E2     JMP $e22e
E23F  60           RTS
E240  A9 40        LDA #$40
E242  20 D2 DE     JSR $ded2
E245  20 D9 E0     JSR $e0d9
E248  09 40        ORA #$40
E24A  AE 57 02     LDX $0257
E24D  95 A8        STA $a8,X
E24F  60           RTS
E250  20 D9 E0     JSR $e0d9
E253  29 BF        AND #$bf
E255  AE 57 02     LDX $0257
E258  95 A8        STA $a8,X
E25A  60           RTS
E25B  A9 80        LDA #$80
E25D  20 E1 DE     JSR $dee1
E260  D0 37        BNE $e299
E262  20 3F D2     JSR $d23f
E265  B5 9A        LDA $9a,X
E267  D9 44 02     CMP $0244,Y
E26A  F0 22        BEQ $e28e
E26C  F6 9A        INC $9a,X
E26E  D0 06        BNE $e276
E270  20 77 E1     JSR $e177
E273  20 3F D2     JSR $d23f
E276  A1 9A        LDA ($9a,X)
E278  99 3E 02     STA $023e,Y
E27B  A9 89        LDA #$89
E27D  99 F3 00     STA $00f3,Y
E280  B5 9A        LDA $9a,X
E282  D9 44 02     CMP $0244,Y
E285  F0 01        BEQ $e288
E287  60           RTS
E288  A9 81        LDA #$81
E28A  99 F3 00     STA $00f3,Y
E28D  60           RTS
E28E  20 0B E1     JSR $e10b
E291  20 3F D2     JSR $d23f
E294  A5 7E        LDA $7e
E296  4C 78 E2     JMP $e278
E299  A6 7B        LDX $7b
E29B  A9 0D        LDA #$0d
E29D  9D 3E 02     STA $023e,X
E2A0  A9 81        LDA #$81
E2A2  95 F3        STA $f3,X
E2A4  A9 50        LDA #$50
E2A6  20 B2 C2     JSR $c2b2
E2A9  A6 7B        LDX $7b
E2AB  B5 C2        LDA $c2,X
E2AD  85 80        STA $80
E2AF  C6 80        DEC $80
E2B1  C9 02        CMP #$02
E2B3  D0 04        BNE $e2b9
E2B5  A9 FF        LDA #$ff
E2B7  85 80        STA $80
E2B9  B5 C8        LDA $c8,X
E2BB  85 81        STA $81
E2BD  20 3B D6     JSR $d63b
E2C0  A6 7B        LDX $7b
E2C2  C5 80        CMP $80
E2C4  90 19        BCC $e2df
E2C6  F0 17        BEQ $e2df
E2C8  20 D4 CF     JSR $cfd4
E2CB  20 ED E2     JSR $e2ed
E2CE  90 08        BCC $e2d8
E2D0  A6 7B        LDX $7b
E2D2  9D 44 02     STA $0244,X
E2D5  4C D4 CF     JMP $cfd4
E2D8  20 D4 CF     JSR $cfd4
E2DB  A9 FF        LDA #$ff
E2DD  85 80        STA $80
E2DF  20 ED E2     JSR $e2ed
E2E2  B0 03        BCS $e2e7
E2E4  20 3B D6     JSR $d63b
E2E7  A6 7B        LDX $7b
E2E9  9D 44 02     STA $0244,X
E2EC  60           RTS
E2ED  20 66 DF     JSR $df66
E2F0  A4 80        LDY $80
E2F2  B1 8D        LDA ($8d),Y
E2F4  D0 0D        BNE $e303
E2F6  88           DEY
E2F7  C0 02        CPY #$02
E2F9  90 04        BCC $e2ff
E2FB  C6 81        DEC $81
E2FD  D0 F3        BNE $e2f2
E2FF  C6 81        DEC $81
E301  18           CLC
E302  60           RTS
E303  98           TYA
E304  38           SEC
E305  60           RTS
E306  20 0D E0     JSR $e00d
E309  85 92        STA $92
E30B  A9 04        LDA #$04
E30D  85 8D        STA $8d
E30F  A0 0A        LDY #$0a
E311  D0 04        BNE $e317
E313  88           DEY
E314  88           DEY
E315  30 26        BMI $e33d
E317  B1 8D        LDA ($8d),Y
E319  F0 F8        BEQ $e313
E31B  98           TYA
E31C  4A           LSR A
E31D  C5 92        CMP $92
E31F  F0 09        BEQ $e32a
E321  85 92        STA $92
E323  A6 7B        LDX $7b
E325  B5 CE        LDA $ce,X
E327  20 56 E0     JSR $e056
E32A  A0 00        LDY #$00
E32C  84 8D        STY $8d
E32E  B1 8D        LDA ($8d),Y
E330  D0 0B        BNE $e33d
E332  C8           INY
E333  B1 8D        LDA ($8d),Y
E335  A8           TAY
E336  88           DEY
E337  84 93        STY $93
E339  98           TYA
E33A  4C 24 E0     JMP $e024
E33D  A9 67        LDA #$67
E33F  20 81 E7     JSR $e781
E342  20 9D C3     JSR $c39d
E345  AD 01 02     LDA $0201
E348  85 7C        STA $7c
E34A  20 FB D1     JSR $d1fb
E34D  90 05        BCC $e354
E34F  A9 70        LDA #$70
E351  20 B2 C2     JSR $c2b2
E354  A9 A0        LDA #$a0
E356  20 D8 DE     JSR $ded8
E359  20 35 D2     JSR $d235
E35C  F0 05        BEQ $e363
E35E  A9 64        LDA #$64
E360  20 B2 C2     JSR $c2b2
E363  B5 ED        LDA $ed,X
E365  29 01        AND #$01
E367  85 78        STA $78
E369  AD 02 02     LDA $0202
E36C  95 B6        STA $b6,X
E36E  AD 03 02     LDA $0203
E371  95 BC        STA $bc,X
E373  A6 7B        LDX $7b
E375  A9 89        LDA #$89
E377  95 F3        STA $f3,X
E379  AD 04 02     LDA $0204
E37C  F0 10        BEQ $e38e
E37E  38           SEC
E37F  E9 01        SBC #$01
E381  F0 0B        BEQ $e38e
E383  D5 C8        CMP $c8,X
E385  90 07        BCC $e38e
E387  A9 51        LDA #$51
E389  8D 6C 02     STA $026c
E38C  A9 00        LDA #$00
E38E  85 91        STA $91
E390  20 FD CE     JSR $cefd
E393  20 33 E0     JSR $e033
E396  50 08        BVC $e3a0
E398  A9 80        LDA #$80
E39A  20 D2 DE     JSR $ded2
E39D  4C 99 E2     JMP $e299
E3A0  20 B0 E3     JSR $e3b0
E3A3  A9 80        LDA #$80
E3A5  20 E1 DE     JSR $dee1
E3A8  F0 03        BEQ $e3ad
E3AA  4C 99 E2     JMP $e299
E3AD  4C 7E C2     JMP $c27e
E3B0  20 D7 E3     JSR $e3d7
E3B3  A5 94        LDA $94
E3B5  20 1B D6     JSR $d61b
E3B8  A6 7B        LDX $7b
E3BA  B5 C8        LDA $c8,X
E3BC  38           SEC
E3BD  E5 91        SBC $91
E3BF  B0 03        BCS $e3c4
E3C1  4C 3D E3     JMP $e33d
E3C4  18           CLC
E3C5  65 94        ADC $94
E3C7  90 03        BCC $e3cc
E3C9  69 01        ADC #$01
E3CB  38           SEC
E3CC  20 44 E1     JSR $e144
E3CF  4C 73 E2     JMP $e273
E3D2  A9 51        LDA #$51
E3D4  20 B2 C2     JSR $c2b2
E3D7  A5 8D        LDA $8d
E3D9  85 82        STA $82
E3DB  A5 8E        LDA $8e
E3DD  85 83        STA $83
E3DF  20 0B E4     JSR $e40b
E3E2  D0 01        BNE $e3e5
E3E4  60           RTS
E3E5  20 2C DF     JSR $df2c
E3E8  20 47 DF     JSR $df47
E3EB  A5 79        LDA $79
E3ED  F0 0E        BEQ $e3fd
E3EF  20 0E E4     JSR $e40e
E3F2  D0 06        BNE $e3fa
E3F4  20 D4 CF     JSR $cfd4
E3F7  4C 2C D4     JMP $d42c
E3FA  20 2C D4     JSR $d42c
E3FD  A0 00        LDY #$00
E3FF  B1 82        LDA ($82),Y
E401  85 79        STA $79
E403  C8           INY
E404  B1 82        LDA ($82),Y
E406  85 7A        STA $7a
E408  4C BF D1     JMP $d1bf
E40B  20 79 DF     JSR $df79
E40E  A0 00        LDY #$00
E410  B1 82        LDA ($82),Y
E412  C5 79        CMP $79
E414  F0 01        BEQ $e417
E416  60           RTS
E417  C8           INY
E418  B1 82        LDA ($82),Y
E41A  C5 7A        CMP $7a
E41C  60           RTS
E41D  20 66 DF     JSR $df66
E420  A0 02        LDY #$02
E422  A9 00        LDA #$00
E424  91 8D        STA ($8d),Y
E426  C8           INY
E427  D0 FB        BNE $e424
E429  20 3F E4     JSR $e43f
E42C  95 C2        STA $c2,X
E42E  A8           TAY
E42F  A9 FF        LDA #$ff
E431  91 8D        STA ($8d),Y
E433  20 3F E4     JSR $e43f
E436  90 F4        BCC $e42c
E438  D0 04        BNE $e43e
E43A  A9 00        LDA #$00
E43C  95 C2        STA $c2,X
E43E  60           RTS
E43F  A6 7B        LDX $7b
E441  B5 C2        LDA $c2,X
E443  38           SEC
E444  F0 0D        BEQ $e453
E446  18           CLC
E447  75 C8        ADC $c8,X
E449  90 0B        BCC $e456
E44B  D0 06        BNE $e453
E44D  A9 02        LDA #$02
E44F  2C 0D F1     BIT $f10d
E452  60           RTS
E453  69 01        ADC #$01
E455  38           SEC
E456  60           RTS
E457  20 29 D3     JSR $d329
E45A  20 06 E3     JSR $e306
E45D  20 D7 E3     JSR $e3d7
E460  20 9A D0     JSR $d09a
E463  A5 93        LDA $93
E465  85 80        STA $80
E467  A5 92        LDA $92
E469  85 7F        STA $7f
E46B  A9 00        LDA #$00
E46D  85 81        STA $81
E46F  A9 00        LDA #$00
E471  85 91        STA $91
E473  20 FD CE     JSR $cefd
E476  20 B8 ED     JSR $edb8
E479  A4 7B        LDY $7b
E47B  B6 C8        LDX $c8,Y
E47D  CA           DEX
E47E  8A           TXA
E47F  18           CLC
E480  65 94        ADC $94
E482  90 0C        BCC $e490
E484  E6 93        INC $93
E486  E6 93        INC $93
E488  D0 06        BNE $e490
E48A  E6 92        INC $92
E48C  A9 10        LDA #$10
E48E  85 93        STA $93
E490  A5 80        LDA $80
E492  18           CLC
E493  69 02        ADC #$02
E495  20 24 E0     JSR $e024
E498  A5 92        LDA $92
E49A  C9 06        CMP #$06
E49C  90 05        BCC $e4a3
E49E  A9 52        LDA #$52
E4A0  20 B2 C2     JSR $c2b2
E4A3  A5 93        LDA $93
E4A5  38           SEC
E4A6  E5 80        SBC $80
E4A8  B0 03        BCS $e4ad
E4AA  E9 0F        SBC #$0f
E4AC  18           CLC
E4AD  85 71        STA $71
E4AF  A5 92        LDA $92
E4B1  E5 7F        SBC $7f
E4B3  85 72        STA $72
E4B5  A2 00        LDX #$00
E4B7  86 6F        STX $6f
E4B9  86 70        STX $70
E4BB  AA           TAX
E4BC  20 8C E0     JSR $e08c
E4BF  A5 70        LDA $70
E4C1  D0 07        BNE $e4ca
E4C3  A6 6F        LDX $6f
E4C5  CA           DEX
E4C6  D0 02        BNE $e4ca
E4C8  E6 81        INC $81
E4CA  CD 73 02     CMP $0273
E4CD  90 09        BCC $e4d8
E4CF  D0 CD        BNE $e49e
E4D1  AD 72 02     LDA $0272
E4D4  C5 6F        CMP $6f
E4D6  90 C6        BCC $e49e
E4D8  A9 01        LDA #$01
E4DA  20 49 D6     JSR $d649
E4DD  18           CLC
E4DE  69 01        ADC #$01
E4E0  A6 7B        LDX $7b
E4E2  95 C2        STA $c2,X
E4E4  20 89 EF     JSR $ef89
E4E7  20 38 DF     JSR $df38
E4EA  A5 81        LDA $81
E4EC  D0 15        BNE $e503
E4EE  20 99 DF     JSR $df99
E4F1  20 D4 CF     JSR $cfd4
E4F4  20 05 D8     JSR $d805
E4F7  20 89 EF     JSR $ef89
E4FA  20 38 DF     JSR $df38
E4FD  20 1D E4     JSR $e41d
E500  4C 0F E5     JMP $e50f
E503  20 D4 CF     JSR $cfd4
E506  20 05 D8     JSR $d805
E509  20 1D E4     JSR $e41d
E50C  20 54 DF     JSR $df54
E50F  20 99 DF     JSR $df99
E512  20 47 DF     JSR $df47
E515  A5 79        LDA $79
E517  48           PHA
E518  A5 7A        LDA $7a
E51A  48           PHA
E51B  20 79 DF     JSR $df79
E51E  A5 7A        LDA $7a
E520  48           PHA
E521  A5 79        LDA $79
E523  48           PHA
E524  20 80 E0     JSR $e080
E527  AA           TAX
E528  D0 0A        BNE $e534
E52A  20 89 E5     JSR $e589
E52D  A9 10        LDA #$10
E52F  20 24 E0     JSR $e024
E532  E6 7F        INC $7f
E534  68           PLA
E535  20 C8 DE     JSR $dec8
E538  68           PLA
E539  20 C8 DE     JSR $dec8
E53C  68           PLA
E53D  85 7A        STA $7a
E53F  68           PLA
E540  85 79        STA $79
E542  F0 0F        BEQ $e553
E544  A5 7F        LDA $7f
E546  C5 92        CMP $92
E548  D0 A7        BNE $e4f1
E54A  20 80 E0     JSR $e080
E54D  C5 93        CMP $93
E54F  90 A0        BCC $e4f1
E551  F0 B0        BEQ $e503
E553  20 80 E0     JSR $e080
E556  48           PHA
E557  A9 00        LDA #$00
E559  20 17 E0     JSR $e017
E55C  A9 00        LDA #$00
E55E  A8           TAY
E55F  91 8D        STA ($8d),Y
E561  C8           INY
E562  68           PLA
E563  38           SEC
E564  E9 01        SBC #$01
E566  91 8D        STA ($8d),Y
E568  20 A7 DF     JSR $dfa7
E56B  20 EC D6     JSR $d6ec
E56E  20 5F ED     JSR $ed5f
E571  20 FD CE     JSR $cefd
E574  20 D4 CF     JSR $cfd4
E577  20 33 E0     JSR $e033
E57A  70 03        BVS $e57f
E57C  4C B0 E3     JMP $e3b0
E57F  A9 80        LDA #$80
E581  20 D2 DE     JSR $ded2
E584  A9 50        LDA #$50
E586  20 B2 C2     JSR $c2b2
E589  20 89 EF     JSR $ef89
E58C  20 D4 CF     JSR $cfd4
E58F  20 2C DF     JSR $df2c
E592  20 CE E0     JSR $e0ce
E595  48           PHA
E596  20 FC DF     JSR $dffc
E599  A6 7B        LDX $7b
E59B  B5 CE        LDA $ce,X
E59D  A8           TAY
E59E  68           PLA
E59F  AA           TAX
E5A0  A9 10        LDA #$10
E5A2  20 E0 DF     JSR $dfe0
E5A5  A9 00        LDA #$00
E5A7  20 17 E0     JSR $e017
E5AA  A0 02        LDY #$02
E5AC  B1 8D        LDA ($8d),Y
E5AE  48           PHA
E5AF  A9 00        LDA #$00
E5B1  20 1B D6     JSR $d61b
E5B4  68           PLA
E5B5  18           CLC
E5B6  69 01        ADC #$01
E5B8  91 8D        STA ($8d),Y
E5BA  0A           ASL A
E5BB  69 04        ADC #$04
E5BD  85 82        STA $82
E5BF  A8           TAY
E5C0  38           SEC
E5C1  E9 02        SBC #$02
E5C3  85 83        STA $83
E5C5  A5 79        LDA $79
E5C7  85 80        STA $80
E5C9  91 8D        STA ($8d),Y
E5CB  C8           INY
E5CC  A5 7A        LDA $7a
E5CE  85 81        STA $81
E5D0  91 8D        STA ($8d),Y
E5D2  A0 00        LDY #$00
E5D4  98           TYA
E5D5  91 8D        STA ($8d),Y
E5D7  C8           INY
E5D8  A9 11        LDA #$11
E5DA  91 8D        STA ($8d),Y
E5DC  A9 10        LDA #$10
E5DE  20 1B D6     JSR $d61b
E5E1  20 8B DF     JSR $df8b
E5E4  20 EC D6     JSR $d6ec
E5E7  A6 7B        LDX $7b
E5E9  B5 CE        LDA $ce,X
E5EB  48           PHA
E5EC  20 D9 E0     JSR $e0d9
E5EF  A6 7B        LDX $7b
E5F1  95 CE        STA $ce,X
E5F3  68           PLA
E5F4  AE 57 02     LDX $0257
E5F7  95 A8        STA $a8,X
E5F9  A9 00        LDA #$00
E5FB  20 1B D6     JSR $d61b
E5FE  A0 00        LDY #$00
E600  A5 79        LDA $79
E602  91 8D        STA ($8d),Y
E604  C8           INY
E605  A5 7A        LDA $7a
E607  91 8D        STA ($8d),Y
E609  4C 19 E6     JMP $e619
E60C  20 CE E0     JSR $e0ce
E60F  A6 7B        LDX $7b
E611  20 56 E0     JSR $e056
E614  A9 00        LDA #$00
E616  20 1B D6     JSR $d61b
E619  C6 83        DEC $83
E61B  C6 83        DEC $83
E61D  A4 82        LDY $82
E61F  A5 80        LDA $80
E621  91 8D        STA ($8d),Y
E623  C8           INY
E624  A5 81        LDA $81
E626  91 8D        STA ($8d),Y
E628  20 99 DF     JSR $df99
E62B  20 EC D6     JSR $d6ec
E62E  A4 83        LDY $83
E630  C0 03        CPY #$03
E632  B0 D8        BCS $e60c
E634  4C D4 CF     JMP $cfd4
E637  00           BRK
E638  A0 4F        LDY #$4f
E63A  CB           ???
E63B  20 21 22     JSR $2221
E63E  23           ???
E63F  24 27        BIT $27
E641  D2           ???
E642  45 41        EOR $41
E644  44           ???
E645  89           ???
E646  52           ???
E647  83           ???
E648  20 54 4F     JSR $4f54
E64B  4F           ???
E64C  20 4C 41     JSR $414c
E64F  52           ???
E650  47           ???
E651  C5 50        CMP $50
E653  8B           ???
E654  06 20        ASL $20
E656  50 52        BVC $e6aa
E658  45 53        EOR $53
E65A  45 4E        EOR $4e
E65C  D4           ???
E65D  51 CF        EOR ($cf),Y
E65F  56 45        LSR $45,X
E661  52           ???
E662  46 4C        LSR $4c
E664  4F           ???
E665  57           ???
E666  20 49 4E     JSR $4e49
E669  8B           ???
E66A  25 28        AND $28
E66C  8A           TXA
E66D  89           ???
E66E  26 8A        ROL $8a
E670  20 50 52     JSR $5250
E673  4F           ???
E674  54           ???
E675  45 43        EOR $43
E677  54           ???
E678  20 4F CE     JSR $ce4f
E67B  29 88        AND #$88
E67D  20 49 44     JSR $4449
E680  85 30        STA $30
E682  31 32        AND ($32),Y
E684  33           ???
E685  34           ???
E686  D3           ???
E687  59 4E 54     EOR $544e,Y
E68A  41 58        EOR ($58,X)
E68C  89           ???
E68D  60           RTS
E68E  8A           TXA
E68F  03           ???
E690  84 63        STY $63
E692  83           ???
E693  20 45 58     JSR $5845
E696  49 53        EOR #$53
E698  54           ???
E699  D3           ???
E69A  64           ???
E69B  83           ???
E69C  20 54 59     JSR $5954
E69F  50 45        BVC $e6e6
E6A1  85 65        STA $65
E6A3  CE 4F 20     DEC $204f
E6A6  42           ???
E6A7  4C 4F 43     JMP $434f
E6AA  CB           ???
E6AB  66 67        ROR $67
E6AD  C9 4C        CMP #$4c
E6AF  4C 45 47     JMP $4745
E6B2  41 4C        EOR ($4c,X)
E6B4  20 54 52     JSR $5254
E6B7  41 43        EOR ($43,X)
E6B9  4B           ???
E6BA  20 4F 52     JSR $524f
E6BD  20 53 45     JSR $4553
E6C0  43           ???
E6C1  54           ???
E6C2  4F           ???
E6C3  D2           ???
E6C4  61 83        ADC ($83,X)
E6C6  06 84        ASL $84
E6C8  39 62 83     AND $8362,Y
E6CB  06 87        ASL $87
E6CD  01 83        ORA ($83,X)
E6CF  53           ???
E6D0  20 53 43     JSR $4353
E6D3  52           ???
E6D4  41 54        EOR ($54,X)
E6D6  43           ???
E6D7  48           PHA
E6D8  45 C4        EOR $c4
E6DA  70 CE        BVS $e6aa
E6DC  4F           ???
E6DD  20 43 48     JSR $4843
E6E0  41 4E        EOR ($4e,X)
E6E2  4E 45 CC     LSR $cc45
E6E5  71 C4        ADC ($c4),Y
E6E7  49 52        EOR #$52
E6E9  89           ???
E6EA  72           ???
E6EB  88           DEY
E6EC  20 46 55     JSR $5546
E6EF  4C CC 73     JMP $73cc
E6F2  C3           ???
E6F3  42           ???
E6F4  4D 20 44     EOR $4420
E6F7  4F           ???
E6F8  53           ???
E6F9  20 56 32     JSR $3256
E6FC  2E 36 20     ROL $2036
E6FF  54           ???
E700  44           ???
E701  49 53        EOR #$53
E703  CB           ???
E704  74           ???
E705  C4 52        CPY $52
E707  49 56        EOR #$56
E709  45 06        EOR $06
E70B  20 52 45     JSR $4552
E70E  41 44        EOR ($44,X)
E710  D9 09 C5     CMP $c509,Y
E713  52           ???
E714  52           ???
E715  4F           ???
E716  D2           ???
E717  0A           ASL A
E718  D7           ???
E719  52           ???
E71A  49 54        EOR #$54
E71C  C5 03        CMP $03
E71E  C6 49        DEC $49
E720  4C C5 04     JMP $04c5
E723  CF           ???
E724  50 45        BVC $e76b
E726  CE 05 CD     DEC $cd05
E729  49 53        EOR #$53
E72B  4D 41 54     EOR $5441
E72E  43           ???
E72F  C8           INY
E730  06 CE        ASL $ce
E732  4F           ???
E733  D4           ???
E734  07           ???
E735  C6 4F        DEC $4f
E737  55 4E        EOR $4e,X
E739  C4 08        CPY $08
E73B  C4 49        CPY $49
E73D  53           ???
E73E  CB           ???
E73F  0B           ???
E740  D2           ???
E741  45 43        EOR $43
E743  4F           ???
E744  52           ???
E745  C4 48        CPY $48
E747  86 98        STX $98
E749  8A           TXA
E74A  0A           ASL A
E74B  AA           TAX
E74C  B5 08        LDA $08,X
E74E  85 79        STA $79
E750  B5 09        LDA $09,X
E752  85 7A        STA $7a
E754  68           PLA
E755  29 0F        AND #$0f
E757  F0 08        BEQ $e761
E759  C9 0F        CMP #$0f
E75B  D0 06        BNE $e763
E75D  A9 74        LDA #$74
E75F  D0 08        BNE $e769
E761  A9 06        LDA #$06
E763  09 20        ORA #$20
E765  AA           TAX
E766  CA           DEX
E767  CA           DEX
E768  8A           TXA
E769  48           PHA
E76A  AD 2A 02     LDA $022a
E76D  C9 00        CMP #$00
E76F  D0 0F        BNE $e780
E771  A9 FF        LDA #$ff
E773  8D 2A 02     STA $022a
E776  68           PLA
E777  20 06 E8     JSR $e806
E77A  20 5E D1     JSR $d15e
E77D  4C 84 E7     JMP $e784
E780  68           PLA
E781  20 06 E8     JSR $e806
E784  20 A7 C2     JSR $c2a7
E787  A9 00        LDA #$00
E789  8D F9 02     STA $02f9
E78C  20 F7 F3     JSR $f3f7
E78F  20 2D D6     JSR $d62d
E792  A9 00        LDA #$00
E794  85 A4        STA $a4
E796  A2 FF        LDX #$ff
E798  9A           TXS
E799  A5 7D        LDA $7d
E79B  29 0F        AND #$0f
E79D  85 7C        STA $7c
E79F  C9 0F        CMP #$0f
E7A1  F0 31        BEQ $e7d4
E7A3  A5 5C        LDA $5c
E7A5  D0 1D        BNE $e7c4
E7A7  A5 5B        LDA $5b
E7A9  D0 10        BNE $e7bb
E7AB  A6 7C        LDX $7c
E7AD  BD 2B 02     LDA $022b,X
E7B0  C9 FF        CMP #$ff
E7B2  F0 20        BEQ $e7d4
E7B4  29 0F        AND #$0f
E7B6  85 7B        STA $7b
E7B8  4C CA E7     JMP $e7ca
E7BB  20 FB D1     JSR $d1fb
E7BE  20 CD C1     JSR $c1cd
E7C1  4C CA E7     JMP $e7ca
E7C4  20 17 D2     JSR $d217
E7C7  20 D8 C1     JSR $c1d8
E7CA  20 35 D2     JSR $d235
E7CD  C9 04        CMP #$04
E7CF  B0 03        BCS $e7d4
E7D1  20 7D D3     JSR $d37d
E7D4  A2 FF        LDX #$ff
E7D6  9A           TXS
E7D7  4C BD EA     JMP $eabd
E7DA  AA           TAX
E7DB  A9 00        LDA #$00
E7DD  F8           SED
E7DE  E0 00        CPX #$00
E7E0  F0 07        BEQ $e7e9
E7E2  18           CLC
E7E3  69 01        ADC #$01
E7E5  CA           DEX
E7E6  4C DE E7     JMP $e7de
E7E9  D8           CLD
E7EA  AA           TAX
E7EB  4A           LSR A
E7EC  4A           LSR A
E7ED  4A           LSR A
E7EE  4A           LSR A
E7EF  20 F3 E7     JSR $e7f3
E7F2  8A           TXA
E7F3  29 0F        AND #$0f
E7F5  09 30        ORA #$30
E7F7  91 A6        STA ($a6),Y
E7F9  C8           INY
E7FA  60           RTS
E7FB  20 F0 F3     JSR $f3f0
E7FE  A9 00        LDA #$00
E800  A0 00        LDY #$00
E802  84 79        STY $79
E804  84 7A        STY $7a
E806  A0 00        LDY #$00
E808  A2 D5        LDX #$d5
E80A  86 A6        STX $a6
E80C  A2 02        LDX #$02
E80E  86 A7        STX $a7
E810  20 EA E7     JSR $e7ea
E813  A9 2C        LDA #$2c
E815  91 A6        STA ($a6),Y
E817  C8           INY
E818  AD D5 02     LDA $02d5
E81B  8D 43 02     STA $0243
E81E  8A           TXA
E81F  20 45 E8     JSR $e845
E822  A9 2C        LDA #$2c
E824  91 A6        STA ($a6),Y
E826  C8           INY
E827  A5 79        LDA $79
E829  20 DA E7     JSR $e7da
E82C  A9 2C        LDA #$2c
E82E  91 A6        STA ($a6),Y
E830  C8           INY
E831  A5 7A        LDA $7a
E833  20 DA E7     JSR $e7da
E836  88           DEY
E837  98           TYA
E838  18           CLC
E839  69 D5        ADC #$d5
E83B  8D 49 02     STA $0249
E83E  E6 A6        INC $a6
E840  A9 88        LDA #$88
E842  85 F8        STA $f8
E844  60           RTS
E845  AA           TAX
E846  A5 7F        LDA $7f
E848  48           PHA
E849  A5 80        LDA $80
E84B  48           PHA
E84C  A9 37        LDA #$37
E84E  85 7F        STA $7f
E850  A9 E6        LDA #$e6
E852  85 80        STA $80
E854  8A           TXA
E855  A2 00        LDX #$00
E857  C1 7F        CMP ($7f,X)
E859  F0 21        BEQ $e87c
E85B  48           PHA
E85C  20 B4 E8     JSR $e8b4
E85F  90 05        BCC $e866
E861  20 B4 E8     JSR $e8b4
E864  90 FB        BCC $e861
E866  A5 80        LDA $80
E868  C9 E7        CMP #$e7
E86A  90 08        BCC $e874
E86C  D0 0A        BNE $e878
E86E  A9 46        LDA #$46
E870  C5 7F        CMP $7f
E872  90 04        BCC $e878
E874  68           PLA
E875  4C 57 E8     JMP $e857
E878  68           PLA
E879  4C 8C E8     JMP $e88c
E87C  20 A6 E8     JSR $e8a6
E87F  90 FB        BCC $e87c
E881  20 93 E8     JSR $e893
E884  20 A6 E8     JSR $e8a6
E887  90 F8        BCC $e881
E889  20 93 E8     JSR $e893
E88C  68           PLA
E88D  85 80        STA $80
E88F  68           PLA
E890  85 7F        STA $7f
E892  60           RTS
E893  C9 20        CMP #$20
E895  B0 0B        BCS $e8a2
E897  AA           TAX
E898  A9 20        LDA #$20
E89A  91 A6        STA ($a6),Y
E89C  C8           INY
E89D  8A           TXA
E89E  20 45 E8     JSR $e845
E8A1  60           RTS
E8A2  91 A6        STA ($a6),Y
E8A4  C8           INY
E8A5  60           RTS
E8A6  E6 7F        INC $7f
E8A8  D0 02        BNE $e8ac
E8AA  E6 80        INC $80
E8AC  A1 7F        LDA ($7f,X)
E8AE  0A           ASL A
E8AF  A1 7F        LDA ($7f,X)
E8B1  29 7F        AND #$7f
E8B3  60           RTS
E8B4  20 AC E8     JSR $e8ac
E8B7  E6 7F        INC $7f
E8B9  D0 02        BNE $e8bd
E8BB  E6 80        INC $80
E8BD  60           RTS
E8BE  60           RTS
E8BF  4C BE E8     JMP $e8be
E8C2  58           CLI
E8C3  EE 78 02     INC $0278
E8C6  EE 74 02     INC $0274
E8C9  A9 2A        LDA #$2a
E8CB  8D 00 02     STA $0200
E8CE  4C D9 E8     JMP $e8d9
E8D1  A9 01        LDA #$01
E8D3  8D 7A 02     STA $027a
E8D6  20 FC C3     JSR $c3fc
E8D9  AD 78 02     LDA $0278
E8DC  48           PHA
E8DD  A9 01        LDA #$01
E8DF  8D 78 02     STA $0278
E8E2  A9 FF        LDA #$ff
E8E4  85 7F        STA $7f
E8E6  20 3A C5     JSR $c53a
E8E9  AD 80 02     LDA $0280
E8EC  D0 05        BNE $e8f3
E8EE  A9 39        LDA #$39
E8F0  20 B2 C2     JSR $c2b2
E8F3  68           PLA
E8F4  8D 78 02     STA $0278
E8F7  AD 80 02     LDA $0280
E8FA  85 79        STA $79
E8FC  AD 85 02     LDA $0285
E8FF  85 7A        STA $7a
E901  A9 03        LDA #$03
E903  20 CA D5     JSR $d5ca
E906  A9 00        LDA #$00
E908  85 80        STA $80
E90A  20 67 E9     JSR $e967
E90D  85 81        STA $81
E90F  20 79 E9     JSR $e979
E912  20 67 E9     JSR $e967
E915  85 82        STA $82
E917  20 79 E9     JSR $e979
E91A  A5 7F        LDA $7f
E91C  F0 0A        BEQ $e928
E91E  A5 81        LDA $81
E920  48           PHA
E921  A5 82        LDA $82
E923  48           PHA
E924  A9 00        LDA #$00
E926  85 7F        STA $7f
E928  20 67 E9     JSR $e967
E92B  85 83        STA $83
E92D  20 79 E9     JSR $e979
E930  20 67 E9     JSR $e967
E933  A0 00        LDY #$00
E935  91 81        STA ($81),Y
E937  20 79 E9     JSR $e979
E93A  A5 81        LDA $81
E93C  18           CLC
E93D  69 01        ADC #$01
E93F  85 81        STA $81
E941  90 02        BCC $e945
E943  E6 82        INC $82
E945  C6 83        DEC $83
E947  D0 E7        BNE $e930
E949  20 2A CB     JSR $cb2a
E94C  A5 7E        LDA $7e
E94E  C5 80        CMP $80
E950  F0 08        BEQ $e95a
E952  20 79 DF     JSR $df79
E955  A9 50        LDA #$50
E957  20 81 E7     JSR $e781
E95A  A5 95        LDA $95
E95C  D0 A8        BNE $e906
E95E  68           PLA
E95F  85 82        STA $82
E961  68           PLA
E962  85 81        STA $81
E964  6C 81 00     JMP ($0081)
E967  20 2A CB     JSR $cb2a
E96A  A5 95        LDA $95
E96C  D0 08        BNE $e976
E96E  20 79 DF     JSR $df79
E971  A9 51        LDA #$51
E973  20 81 E7     JSR $e781
E976  A5 7E        LDA $7e
E978  60           RTS
E979  18           CLC
E97A  65 80        ADC $80
E97C  69 00        ADC #$00
E97E  85 80        STA $80
E980  60           RTS
E981  A2 00        LDX #$00
E983  2C A6 6E     BIT $6ea6
E986  9A           TXS
E987  BA           TSX
E988  A9 6F        LDA #$6f
E98A  85 00        STA $00
E98C  29 60        AND #$60
E98E  85 01        STA $01
E990  98           TYA
E991  18           CLC
E992  69 01        ADC #$01
E994  D0 FC        BNE $e992
E996  88           DEY
E997  D0 F8        BNE $e991
E999  A9 68        LDA #$68
E99B  85 01        STA $01
E99D  98           TYA
E99E  18           CLC
E99F  69 01        ADC #$01
E9A1  D0 FC        BNE $e99f
E9A3  88           DEY
E9A4  D0 F8        BNE $e99e
E9A6  CA           DEX
E9A7  10 DF        BPL $e988
E9A9  E0 F4        CPX #$f4
E9AB  D0 F0        BNE $e99d
E9AD  F0 D8        BEQ $e987
E9AF  4C 84 E9     JMP $e984
E9B2  4C 81 E9     JMP $e981
E9B5  78           SEI
E9B6  D8           CLD
E9B7  A0 00        LDY #$00
E9B9  A2 02        LDX #$02
E9BB  8A           TXA
E9BC  95 00        STA $00,X
E9BE  E8           INX
E9BF  D0 FA        BNE $e9bb
E9C1  A2 02        LDX #$02
E9C3  8A           TXA
E9C4  D5 00        CMP $00,X
E9C6  D0 EA        BNE $e9b2
E9C8  F6 00        INC $00,X
E9CA  C8           INY
E9CB  D0 FB        BNE $e9c8
E9CD  D5 00        CMP $00,X
E9CF  D0 E1        BNE $e9b2
E9D1  94 00        STY $00,X
E9D3  B5 00        LDA $00,X
E9D5  D0 DB        BNE $e9b2
E9D7  E8           INX
E9D8  D0 E9        BNE $e9c3
E9DA  E6 6E        INC $6e
E9DC  86 75        STX $75
E9DE  A9 00        LDA #$00
E9E0  85 74        STA $74
E9E2  A8           TAY
E9E3  A2 40        LDX #$40
E9E5  18           CLC
E9E6  C6 75        DEC $75
E9E8  71 74        ADC ($74),Y
E9EA  C8           INY
E9EB  D0 FB        BNE $e9e8
E9ED  CA           DEX
E9EE  D0 F6        BNE $e9e6
E9F0  85 61        STA $61
E9F2  69 FF        ADC #$ff
E9F4  D0 B9        BNE $e9af
E9F6  A9 01        LDA #$01
E9F8  85 75        STA $75
E9FA  E6 6E        INC $6e
E9FC  A2 07        LDX #$07
E9FE  98           TYA
E9FF  18           CLC
EA00  65 75        ADC $75
EA02  91 74        STA ($74),Y
EA04  C8           INY
EA05  D0 F7        BNE $e9fe
EA07  E6 75        INC $75
EA09  CA           DEX
EA0A  D0 F2        BNE $e9fe
EA0C  A2 07        LDX #$07
EA0E  C6 75        DEC $75
EA10  88           DEY
EA11  98           TYA
EA12  18           CLC
EA13  65 75        ADC $75
EA15  D1 74        CMP ($74),Y
EA17  D0 12        BNE $ea2b
EA19  49 FF        EOR #$ff
EA1B  91 74        STA ($74),Y
EA1D  51 74        EOR ($74),Y
EA1F  91 74        STA ($74),Y
EA21  D0 08        BNE $ea2b
EA23  98           TYA
EA24  D0 EA        BNE $ea10
EA26  CA           DEX
EA27  D0 E5        BNE $ea0e
EA29  F0 03        BEQ $ea2e
EA2B  4C AF E9     JMP $e9af
EA2E  A2 FF        LDX #$ff
EA30  86 95        STX $95
EA32  9A           TXS
EA33  20 C6 C3     JSR $c3c6
EA36  20 3D F1     JSR $f13d
EA39  A9 11        LDA #$11
EA3B  85 68        STA $68
EA3D  A9 05        LDA #$05
EA3F  85 69        STA $69
EA41  A2 00        LDX #$00
EA43  A0 00        LDY #$00
EA45  A9 00        LDA #$00
EA47  95 9A        STA $9a,X
EA49  E8           INX
EA4A  B9 23 F1     LDA $f123,Y
EA4D  95 9A        STA $9a,X
EA4F  E8           INX
EA50  C8           INY
EA51  C0 05        CPY #$05
EA53  D0 F0        BNE $ea45
EA55  A9 00        LDA #$00
EA57  95 9A        STA $9a,X
EA59  E8           INX
EA5A  A9 02        LDA #$02
EA5C  95 9A        STA $9a,X
EA5E  E8           INX
EA5F  A9 D5        LDA #$d5
EA61  95 9A        STA $9a,X
EA63  E8           INX
EA64  A9 02        LDA #$02
EA66  95 9A        STA $9a,X
EA68  A9 FF        LDA #$ff
EA6A  A2 12        LDX #$12
EA6C  9D 2B 02     STA $022b,X
EA6F  CA           DEX
EA70  10 FA        BPL $ea6c
EA72  A2 05        LDX #$05
EA74  95 A8        STA $a8,X
EA76  95 AF        STA $af,X
EA78  95 CE        STA $ce,X
EA7A  CA           DEX
EA7B  10 F7        BPL $ea74
EA7D  A9 05        LDA #$05
EA7F  85 AC        STA $ac
EA81  A9 06        LDA #$06
EA83  85 AD        STA $ad
EA85  A9 FF        LDA #$ff
EA87  85 AE        STA $ae
EA89  85 B5        STA $b5
EA8B  A9 05        LDA #$05
EA8D  8D 3B 02     STA $023b
EA90  A9 84        LDA #$84
EA92  8D 3A 02     STA $023a
EA95  A9 0F        LDA #$0f
EA97  8D 56 02     STA $0256
EA9A  A9 01        LDA #$01
EA9C  85 F7        STA $f7
EA9E  A9 88        LDA #$88
EAA0  85 F8        STA $f8
EAA2  A9 E0        LDA #$e0
EAA4  8D 4F 02     STA $024f
EAA7  A9 FF        LDA #$ff
EAA9  8D 50 02     STA $0250
EAAC  A9 01        LDA #$01
EAAE  85 22        STA $22
EAB0  85 23        STA $23
EAB2  20 55 CC     JSR $cc55
EAB5  20 B0 CF     JSR $cfb0
EAB8  A9 73        LDA #$73
EABA  20 00 E8     JSR $e800
EABD  E6 61        INC $61
EABF  D0 03        BNE $eac4
EAC1  20 DC EA     JSR $eadc
EAC4  AD 00 40     LDA $4000
EAC7  10 03        BPL $eacc
EAC9  20 22 C0     JSR $c022
EACC  AD 55 02     LDA $0255
EACF  F0 EC        BEQ $eabd
EAD1  A9 00        LDA #$00
EAD3  8D 55 02     STA $0255
EAD6  20 30 C2     JSR $c230
EAD9  4C BD EA     JMP $eabd
EADC  A9 0E        LDA #$0e
EADE  85 63        STA $63
EAE0  A9 00        LDA #$00
EAE2  85 62        STA $62
EAE4  A6 63        LDX $63
EAE6  BD 2B 02     LDA $022b,X
EAE9  C9 FF        CMP #$ff
EAEB  F0 02        BEQ $eaef
EAED  E6 62        INC $62
EAEF  C6 63        DEC $63
EAF1  10 F1        BPL $eae4
EAF3  A5 62        LDA $62
EAF5  F0 07        BEQ $eafe
EAF7  A5 22        LDA $22
EAF9  F0 03        BEQ $eafe
EAFB  20 65 D4     JSR $d465
EAFE  AE 6C 02     LDX $026c
EB01  F0 03        BEQ $eb06
EB03  4C F7 F3     JMP $f3f7
EB06  A5 62        LDA $62
EB08  85 96        STA $96
EB0A  60           RTS
EB0B  A9 00        LDA #$00
EB0D  85 7C        STA $7c
EB0F  A9 01        LDA #$01
EB11  20 38 D3     JSR $d338
EB14  A9 00        LDA #$00
EB16  20 1B D6     JSR $d61b
EB19  A6 7B        LDX $7b
EB1B  A9 00        LDA #$00
EB1D  9D 44 02     STA $0244,X
EB20  20 CE E0     JSR $e0ce
EB23  AA           TAX
EB24  A5 78        LDA $78
EB26  9D 5B 02     STA $025b,X
EB29  A9 01        LDA #$01
EB2B  20 0D D1     JSR $d10d
EB2E  A9 04        LDA #$04
EB30  20 0D D1     JSR $d10d
EB33  A9 01        LDA #$01
EB35  20 0D D1     JSR $d10d
EB38  20 0D D1     JSR $d10d
EB3B  AD 72 02     LDA $0272
EB3E  20 0D D1     JSR $d10d
EB41  A9 00        LDA #$00
EB43  20 0D D1     JSR $d10d
EB46  20 C6 EB     JSR $ebc6
EB49  20 CE E0     JSR $e0ce
EB4C  0A           ASL A
EB4D  AA           TAX
EB4E  D6 9A        DEC $9a,X
EB50  D6 9A        DEC $9a,X
EB52  A9 00        LDA #$00
EB54  20 0D D1     JSR $d10d
EB57  A9 01        LDA #$01
EB59  20 0D D1     JSR $d10d
EB5C  20 0D D1     JSR $d10d
EB5F  20 AF C7     JSR $c7af
EB62  90 2C        BCC $eb90
EB64  AD 72 02     LDA $0272
EB67  20 0D D1     JSR $d10d
EB6A  AD 73 02     LDA $0273
EB6D  20 0D D1     JSR $d10d
EB70  20 C6 EB     JSR $ebc6
EB73  A9 00        LDA #$00
EB75  20 0D D1     JSR $d10d
EB78  D0 DD        BNE $eb57
EB7A  20 CE E0     JSR $e0ce
EB7D  0A           ASL A
EB7E  AA           TAX
EB7F  A9 00        LDA #$00
EB81  95 9A        STA $9a,X
EB83  A9 88        LDA #$88
EB85  A4 7B        LDY $7b
EB87  8D 54 02     STA $0254
EB8A  99 F3 00     STA $00f3,Y
EB8D  A5 7E        LDA $7e
EB8F  60           RTS
EB90  AD 72 02     LDA $0272
EB93  20 0D D1     JSR $d10d
EB96  AD 73 02     LDA $0273
EB99  20 0D D1     JSR $d10d
EB9C  20 C6 EB     JSR $ebc6
EB9F  20 CE E0     JSR $e0ce
EBA2  0A           ASL A
EBA3  AA           TAX
EBA4  D6 9A        DEC $9a,X
EBA6  D6 9A        DEC $9a,X
EBA8  A9 00        LDA #$00
EBAA  20 0D D1     JSR $d10d
EBAD  20 0D D1     JSR $d10d
EBB0  20 0D D1     JSR $d10d
EBB3  20 CE E0     JSR $e0ce
EBB6  0A           ASL A
EBB7  A8           TAY
EBB8  B9 9A 00     LDA $009a,Y
EBBB  A6 7B        LDX $7b
EBBD  9D 44 02     STA $0244,X
EBC0  DE 44 02     DEC $0244,X
EBC3  4C 7A EB     JMP $eb7a
EBC6  A0 00        LDY #$00
EBC8  B9 B1 02     LDA $02b1,Y
EBCB  20 0D D1     JSR $d10d
EBCE  C8           INY
EBCF  C0 1B        CPY #$1b
EBD1  D0 F5        BNE $ebc8
EBD3  60           RTS
EBD4  20 47 D2     JSR $d247
EBD7  F0 01        BEQ $ebda
EBD9  60           RTS
EBDA  85 7E        STA $7e
EBDC  A4 7B        LDY $7b
EBDE  B9 44 02     LDA $0244,Y
EBE1  F0 08        BEQ $ebeb
EBE3  A9 80        LDA #$80
EBE5  99 F3 00     STA $00f3,Y
EBE8  A5 7E        LDA $7e
EBEA  60           RTS
EBEB  48           PHA
EBEC  20 57 EB     JSR $eb57
EBEF  68           PLA
EBF0  60           RTS
EBF1  20 BB C2     JSR $c2bb
EBF4  20 5E D1     JSR $d15e
EBF7  A9 40        LDA #$40
EBF9  8D F9 02     STA $02f9
EBFC  20 22 ED     JSR $ed22
EBFF  A9 00        LDA #$00
EC01  8D 92 02     STA $0292
EC04  20 91 C6     JSR $c691
EC07  D0 3D        BNE $ec46
EC09  A9 00        LDA #$00
EC0B  85 7A        STA $7a
EC0D  AD C3 F0     LDA $f0c3
EC10  85 79        STA $79
EC12  20 52 EC     JSR $ec52
EC15  A9 00        LDA #$00
EC17  8D F9 02     STA $02f9
EC1A  20 6A ED     JSR $ed6a
EC1D  4C 7E C2     JMP $c27e
EC20  C8           INY
EC21  B1 8D        LDA ($8d),Y
EC23  48           PHA
EC24  C8           INY
EC25  B1 8D        LDA ($8d),Y
EC27  48           PHA
EC28  A0 13        LDY #$13
EC2A  B1 8D        LDA ($8d),Y
EC2C  F0 0A        BEQ $ec38
EC2E  85 79        STA $79
EC30  C8           INY
EC31  B1 8D        LDA ($8d),Y
EC33  85 7A        STA $7a
EC35  20 52 EC     JSR $ec52
EC38  68           PLA
EC39  85 7A        STA $7a
EC3B  68           PLA
EC3C  85 79        STA $79
EC3E  20 52 EC     JSR $ec52
EC41  20 E9 C6     JSR $c6e9
EC44  F0 C3        BEQ $ec09
EC46  A0 00        LDY #$00
EC48  B1 8D        LDA ($8d),Y
EC4A  30 D4        BMI $ec20
EC4C  20 97 C9     JSR $c997
EC4F  4C 41 EC     JMP $ec41
EC52  20 B0 D6     JSR $d6b0
EC55  20 FB ED     JSR $edfb
EC58  20 C8 D5     JSR $d5c8
EC5B  A9 00        LDA #$00
EC5D  20 1B D6     JSR $d61b
EC60  20 47 D2     JSR $d247
EC63  85 79        STA $79
EC65  20 47 D2     JSR $d247
EC68  85 7A        STA $7a
EC6A  A5 79        LDA $79
EC6C  D0 03        BNE $ec71
EC6E  4C 7D D3     JMP $d37d
EC71  20 FB ED     JSR $edfb
EC74  20 A0 D5     JSR $d5a0
EC77  4C 5B EC     JMP $ec5b
EC7A  20 FC C3     JSR $c3fc
EC7D  A5 E3        LDA $e3
EC7F  10 05        BPL $ec86
EC81  A9 33        LDA #$33
EC83  4C B2 C2     JMP $c2b2
EC86  29 01        AND #$01
EC88  85 78        STA $78
EC8A  AA           TAX
EC8B  A0 00        LDY #$00
EC8D  94 5F        STY $5f,X
EC8F  0A           ASL A
EC90  AA           TAX
EC91  AC 7B 02     LDY $027b
EC94  CC 74 02     CPY $0274
EC97  F0 1A        BEQ $ecb3
EC99  B9 00 02     LDA $0200,Y
EC9C  95 14        STA $14,X
EC9E  B9 01 02     LDA $0201,Y
ECA1  95 15        STA $15,X
ECA3  20 59 D4     JSR $d459
ECA6  A9 01        LDA #$01
ECA8  85 79        STA $79
ECAA  20 A7 C9     JSR $c9a7
ECAD  20 70 EE     JSR $ee70
ECB0  4C C2 EC     JMP $ecc2
ECB3  20 5E D1     JSR $d15e
ECB6  A6 78        LDX $78
ECB8  B5 5D        LDA $5d,X
ECBA  CD 18 F1     CMP $f118
ECBD  F0 03        BEQ $ecc2
ECBF  4C C3 D6     JMP $d6c3
ECC2  20 22 ED     JSR $ed22
ECC5  A5 98        LDA $98
ECC7  A8           TAY
ECC8  0A           ASL A
ECC9  AA           TAX
ECCA  AD C6 F0     LDA $f0c6
ECCD  95 9A        STA $9a,X
ECCF  AE 7A 02     LDX $027a
ECD2  A9 1B        LDA #$1b
ECD4  20 4F C7     JSR $c74f
ECD7  A0 12        LDY #$12
ECD9  A6 78        LDX $78
ECDB  AD 18 F1     LDA $f118
ECDE  95 5D        STA $5d,X
ECE0  8A           TXA
ECE1  0A           ASL A
ECE2  AA           TAX
ECE3  B5 14        LDA $14,X
ECE5  91 8D        STA ($8d),Y
ECE7  C8           INY
ECE8  B5 15        LDA $15,X
ECEA  91 8D        STA ($8d),Y
ECEC  C8           INY
ECED  C8           INY
ECEE  A9 32        LDA #$32
ECF0  91 8D        STA ($8d),Y
ECF2  C8           INY
ECF3  AD 18 F1     LDA $f118
ECF6  91 8D        STA ($8d),Y
ECF8  A0 02        LDY #$02
ECFA  91 6C        STA ($6c),Y
ECFC  AD C3 F0     LDA $f0c3
ECFF  85 79        STA $79
ED01  20 FE ED     JSR $edfe
ED04  A9 01        LDA #$01
ED06  85 7A        STA $7a
ED08  20 FE ED     JSR $edfe
ED0B  20 6A ED     JSR $ed6a
ED0E  20 70 EE     JSR $ee70
ED11  A0 01        LDY #$01
ED13  A9 FF        LDA #$ff
ED15  91 6C        STA ($6c),Y
ED17  20 B7 D5     JSR $d5b7
ED1A  C6 7A        DEC $7a
ED1C  20 B3 D5     JSR $d5b3
ED1F  4C 7E C2     JMP $c27e
ED22  20 3C EF     JSR $ef3c
ED25  A0 00        LDY #$00
ED27  A9 12        LDA #$12
ED29  91 6C        STA ($6c),Y
ED2B  C8           INY
ED2C  98           TYA
ED2D  91 6C        STA ($6c),Y
ED2F  C8           INY
ED30  C8           INY
ED31  C8           INY
ED32  A9 00        LDA #$00
ED34  85 6E        STA $6e
ED36  85 6F        STA $6f
ED38  85 70        STA $70
ED3A  98           TYA
ED3B  4A           LSR A
ED3C  4A           LSR A
ED3D  20 B6 F0     JSR $f0b6
ED40  91 6C        STA ($6c),Y
ED42  C8           INY
ED43  AA           TAX
ED44  38           SEC
ED45  26 6E        ROL $6e
ED47  26 6F        ROL $6f
ED49  26 70        ROL $70
ED4B  CA           DEX
ED4C  D0 F6        BNE $ed44
ED4E  B5 6E        LDA $6e,X
ED50  91 6C        STA ($6c),Y
ED52  C8           INY
ED53  E8           INX
ED54  E0 03        CPX #$03
ED56  90 F6        BCC $ed4e
ED58  C0 90        CPY #$90
ED5A  90 D6        BCC $ed32
ED5C  4C 85 D1     JMP $d185
ED5F  20 CE E0     JSR $e0ce
ED62  AA           TAX
ED63  BD 5B 02     LDA $025b,X
ED66  29 01        AND #$01
ED68  85 78        STA $78
ED6A  A4 78        LDY $78
ED6C  B9 51 02     LDA $0251,Y
ED6F  D0 01        BNE $ed72
ED71  60           RTS
ED72  A9 00        LDA #$00
ED74  99 51 02     STA $0251,Y
ED77  20 A5 ED     JSR $eda5
ED7A  A5 78        LDA $78
ED7C  0A           ASL A
ED7D  48           PHA
ED7E  20 10 EF     JSR $ef10
ED81  68           PLA
ED82  18           CLC
ED83  69 01        ADC #$01
ED85  20 10 EF     JSR $ef10
ED88  A5 79        LDA $79
ED8A  48           PHA
ED8B  A9 01        LDA #$01
ED8D  85 79        STA $79
ED8F  0A           ASL A
ED90  0A           ASL A
ED91  85 6C        STA $6c
ED93  20 8B F0     JSR $f08b
ED96  E6 79        INC $79
ED98  A5 79        LDA $79
ED9A  CD 1A F1     CMP $f11a
ED9D  90 F0        BCC $ed8f
ED9F  68           PLA
EDA0  85 79        STA $79
EDA2  4C DD D6     JMP $d6dd
EDA5  20 7A EF     JSR $ef7a
EDA8  AA           TAX
EDA9  20 4A EF     JSR $ef4a
EDAC  A6 98        LDX $98
EDAE  BD 23 F1     LDA $f123,X
EDB1  85 6D        STA $6d
EDB3  A9 00        LDA #$00
EDB5  85 6C        STA $6c
EDB7  60           RTS
EDB8  A6 78        LDX $78
EDBA  BD FA 02     LDA $02fa,X
EDBD  8D 72 02     STA $0272
EDC0  BD FC 02     LDA $02fc,X
EDC3  8D 73 02     STA $0273
EDC6  60           RTS
EDC7  20 5C EE     JSR $ee5c
EDCA  20 3A EE     JSR $ee3a
EDCD  38           SEC
EDCE  D0 22        BNE $edf2
EDD0  B1 6C        LDA ($6c),Y
EDD2  1D 54 EE     ORA $ee54,X
EDD5  91 6C        STA ($6c),Y
EDD7  20 F3 ED     JSR $edf3
EDDA  A4 6E        LDY $6e
EDDC  18           CLC
EDDD  B1 6C        LDA ($6c),Y
EDDF  69 01        ADC #$01
EDE1  91 6C        STA ($6c),Y
EDE3  A5 79        LDA $79
EDE5  CD C3 F0     CMP $f0c3
EDE8  F0 3B        BEQ $ee25
EDEA  FE FA 02     INC $02fa,X
EDED  D0 03        BNE $edf2
EDEF  FE FC 02     INC $02fc,X
EDF2  60           RTS
EDF3  A6 78        LDX $78
EDF5  A9 01        LDA #$01
EDF7  9D 51 02     STA $0251,X
EDFA  60           RTS
EDFB  20 5C EE     JSR $ee5c
EDFE  20 3A EE     JSR $ee3a
EE01  F0 36        BEQ $ee39
EE03  B1 6C        LDA ($6c),Y
EE05  5D 54 EE     EOR $ee54,X
EE08  91 6C        STA ($6c),Y
EE0A  20 F3 ED     JSR $edf3
EE0D  A4 6E        LDY $6e
EE0F  B1 6C        LDA ($6c),Y
EE11  38           SEC
EE12  E9 01        SBC #$01
EE14  91 6C        STA ($6c),Y
EE16  A5 79        LDA $79
EE18  CD C3 F0     CMP $f0c3
EE1B  F0 0B        BEQ $ee28
EE1D  BD FA 02     LDA $02fa,X
EE20  D0 03        BNE $ee25
EE22  DE FC 02     DEC $02fc,X
EE25  DE FA 02     DEC $02fa,X
EE28  BD FC 02     LDA $02fc,X
EE2B  D0 0C        BNE $ee39
EE2D  BD FA 02     LDA $02fa,X
EE30  C9 03        CMP #$03
EE32  B0 05        BCS $ee39
EE34  A9 72        LDA #$72
EE36  20 06 E8     JSR $e806
EE39  60           RTS
EE3A  20 7C EE     JSR $ee7c
EE3D  98           TYA
EE3E  85 6E        STA $6e
EE40  A5 7A        LDA $7a
EE42  4A           LSR A
EE43  4A           LSR A
EE44  4A           LSR A
EE45  38           SEC
EE46  65 6E        ADC $6e
EE48  A8           TAY
EE49  A5 7A        LDA $7a
EE4B  29 07        AND #$07
EE4D  AA           TAX
EE4E  B1 6C        LDA ($6c),Y
EE50  3D 54 EE     AND $ee54,X
EE53  60           RTS
EE54  01 02        ORA ($02,X)
EE56  04           ???
EE57  08           PHP
EE58  10 20        BPL $ee7a
EE5A  40           RTI
EE5B  80           ???
EE5C  A9 FF        LDA #$ff
EE5E  2C F9 02     BIT $02f9
EE61  F0 0C        BEQ $ee6f
EE63  10 0A        BPL $ee6f
EE65  70 08        BVS $ee6f
EE67  A9 00        LDA #$00
EE69  8D F9 02     STA $02f9
EE6C  4C DD D6     JMP $d6dd
EE6F  60           RTS
EE70  20 A5 ED     JSR $eda5
EE73  A0 00        LDY #$00
EE75  98           TYA
EE76  91 6C        STA ($6c),Y
EE78  C8           INY
EE79  D0 FB        BNE $ee76
EE7B  60           RTS
EE7C  A5 6E        LDA $6e
EE7E  48           PHA
EE7F  A5 6F        LDA $6f
EE81  48           PHA
EE82  A6 78        LDX $78
EE84  B5 5F        LDA $5f,X
EE86  F0 05        BEQ $ee8d
EE88  A9 74        LDA #$74
EE8A  20 84 E7     JSR $e784
EE8D  20 7A EF     JSR $ef7a
EE90  85 6E        STA $6e
EE92  8A           TXA
EE93  0A           ASL A
EE94  85 6F        STA $6f
EE96  AA           TAX
EE97  A5 79        LDA $79
EE99  DD 9D 02     CMP $029d,X
EE9C  F0 0B        BEQ $eea9
EE9E  E8           INX
EE9F  86 6F        STX $6f
EEA1  DD 9D 02     CMP $029d,X
EEA4  F0 03        BEQ $eea9
EEA6  20 C6 EE     JSR $eec6
EEA9  A5 6F        LDA $6f
EEAB  A6 78        LDX $78
EEAD  9D 9B 02     STA $029b,X
EEB0  0A           ASL A
EEB1  0A           ASL A
EEB2  18           CLC
EEB3  69 A1        ADC #$a1
EEB5  85 6C        STA $6c
EEB7  A9 02        LDA #$02
EEB9  69 00        ADC #$00
EEBB  85 6D        STA $6d
EEBD  A0 00        LDY #$00
EEBF  68           PLA
EEC0  85 6F        STA $6f
EEC2  68           PLA
EEC3  85 6E        STA $6e
EEC5  60           RTS
EEC6  A6 6E        LDX $6e
EEC8  20 4A EF     JSR $ef4a
EECB  A5 78        LDA $78
EECD  AA           TAX
EECE  0A           ASL A
EECF  1D 9B 02     ORA $029b,X
EED2  49 01        EOR #$01
EED4  29 03        AND #$03
EED6  85 6F        STA $6f
EED8  20 10 EF     JSR $ef10
EEDB  A5 98        LDA $98
EEDD  0A           ASL A
EEDE  AA           TAX
EEDF  A5 79        LDA $79
EEE1  0A           ASL A
EEE2  0A           ASL A
EEE3  95 9A        STA $9a,X
EEE5  A5 6F        LDA $6f
EEE7  0A           ASL A
EEE8  0A           ASL A
EEE9  A8           TAY
EEEA  A1 9A        LDA ($9a,X)
EEEC  99 A1 02     STA $02a1,Y
EEEF  A9 00        LDA #$00
EEF1  81 9A        STA ($9a,X)
EEF3  F6 9A        INC $9a,X
EEF5  C8           INY
EEF6  98           TYA
EEF7  29 03        AND #$03
EEF9  D0 EF        BNE $eeea
EEFB  A6 6F        LDX $6f
EEFD  A5 79        LDA $79
EEFF  9D 9D 02     STA $029d,X
EF02  AD F9 02     LDA $02f9
EF05  D0 03        BNE $ef0a
EF07  4C DD D6     JMP $d6dd
EF0A  09 80        ORA #$80
EF0C  8D F9 02     STA $02f9
EF0F  60           RTS
EF10  A8           TAY
EF11  B9 9D 02     LDA $029d,Y
EF14  F0 25        BEQ $ef3b
EF16  48           PHA
EF17  A9 00        LDA #$00
EF19  99 9D 02     STA $029d,Y
EF1C  A5 98        LDA $98
EF1E  0A           ASL A
EF1F  AA           TAX
EF20  68           PLA
EF21  0A           ASL A
EF22  0A           ASL A
EF23  95 9A        STA $9a,X
EF25  98           TYA
EF26  0A           ASL A
EF27  0A           ASL A
EF28  A8           TAY
EF29  B9 A1 02     LDA $02a1,Y
EF2C  81 9A        STA ($9a,X)
EF2E  A9 00        LDA #$00
EF30  99 A1 02     STA $02a1,Y
EF33  F6 9A        INC $9a,X
EF35  C8           INY
EF36  98           TYA
EF37  29 03        AND #$03
EF39  D0 EE        BNE $ef29
EF3B  60           RTS
EF3C  A5 78        LDA $78
EF3E  0A           ASL A
EF3F  AA           TAX
EF40  A9 00        LDA #$00
EF42  9D 9D 02     STA $029d,X
EF45  E8           INX
EF46  9D 9D 02     STA $029d,X
EF49  60           RTS
EF4A  B5 A8        LDA $a8,X
EF4C  C9 FF        CMP #$ff
EF4E  D0 25        BNE $ef75
EF50  8A           TXA
EF51  48           PHA
EF52  20 E4 D3     JSR $d3e4
EF55  AA           TAX
EF56  10 05        BPL $ef5d
EF58  A9 70        LDA #$70
EF5A  20 B2 C2     JSR $c2b2
EF5D  86 98        STX $98
EF5F  68           PLA
EF60  A8           TAY
EF61  8A           TXA
EF62  09 80        ORA #$80
EF64  99 A8 00     STA $00a8,Y
EF67  0A           ASL A
EF68  AA           TAX
EF69  AD C3 F0     LDA $f0c3
EF6C  95 08        STA $08,X
EF6E  A9 00        LDA #$00
EF70  95 09        STA $09,X
EF72  4C D9 D6     JMP $d6d9
EF75  29 0F        AND #$0f
EF77  85 98        STA $98
EF79  60           RTS
EF7A  A9 06        LDA #$06
EF7C  A6 78        LDX $78
EF7E  D0 03        BNE $ef83
EF80  18           CLC
EF81  69 07        ADC #$07
EF83  60           RTS
EF84  20 7A EF     JSR $ef7a
EF87  AA           TAX
EF88  60           RTS
EF89  20 79 DF     JSR $df79
EF8C  A9 03        LDA #$03
EF8E  85 6E        STA $6e
EF90  A9 01        LDA #$01
EF92  0D F9 02     ORA $02f9
EF95  8D F9 02     STA $02f9
EF98  A5 6E        LDA $6e
EF9A  48           PHA
EF9B  20 7C EE     JSR $ee7c
EF9E  68           PLA
EF9F  85 6E        STA $6e
EFA1  B1 6C        LDA ($6c),Y
EFA3  D0 39        BNE $efde
EFA5  A5 79        LDA $79
EFA7  CD C3 F0     CMP $f0c3
EFAA  F0 19        BEQ $efc5
EFAC  90 1C        BCC $efca
EFAE  E6 79        INC $79
EFB0  A5 79        LDA $79
EFB2  CD 1A F1     CMP $f11a
EFB5  D0 E1        BNE $ef98
EFB7  AE C3 F0     LDX $f0c3
EFBA  CA           DEX
EFBB  86 79        STX $79
EFBD  A9 00        LDA #$00
EFBF  85 7A        STA $7a
EFC1  C6 6E        DEC $6e
EFC3  D0 D3        BNE $ef98
EFC5  A9 72        LDA #$72
EFC7  20 B2 C2     JSR $c2b2
EFCA  C6 79        DEC $79
EFCC  D0 CA        BNE $ef98
EFCE  AE C3 F0     LDX $f0c3
EFD1  E8           INX
EFD2  86 79        STX $79
EFD4  A9 00        LDA #$00
EFD6  85 7A        STA $7a
EFD8  C6 6E        DEC $6e
EFDA  D0 BC        BNE $ef98
EFDC  F0 E7        BEQ $efc5
EFDE  A5 7A        LDA $7a
EFE0  18           CLC
EFE1  65 68        ADC $68
EFE3  85 7A        STA $7a
EFE5  A5 79        LDA $79
EFE7  20 B6 F0     JSR $f0b6
EFEA  8D 4E 02     STA $024e
EFED  8D 4D 02     STA $024d
EFF0  C5 7A        CMP $7a
EFF2  B0 0C        BCS $f000
EFF4  38           SEC
EFF5  A5 7A        LDA $7a
EFF7  ED 4E 02     SBC $024e
EFFA  85 7A        STA $7a
EFFC  F0 02        BEQ $f000
EFFE  C6 7A        DEC $7a
F000  20 65 F0     JSR $f065
F003  F0 03        BEQ $f008
F005  4C FB ED     JMP $edfb
F008  A9 00        LDA #$00
F00A  85 7A        STA $7a
F00C  20 65 F0     JSR $f065
F00F  D0 F4        BNE $f005
F011  4C 60 F0     JMP $f060
F014  A9 01        LDA #$01
F016  0D F9 02     ORA $02f9
F019  8D F9 02     STA $02f9
F01C  A5 7F        LDA $7f
F01E  48           PHA
F01F  A9 01        LDA #$01
F021  85 7F        STA $7f
F023  AD C3 F0     LDA $f0c3
F026  38           SEC
F027  E5 7F        SBC $7f
F029  85 79        STA $79
F02B  90 09        BCC $f036
F02D  F0 07        BEQ $f036
F02F  20 7C EE     JSR $ee7c
F032  B1 6C        LDA ($6c),Y
F034  D0 1B        BNE $f051
F036  AD C3 F0     LDA $f0c3
F039  18           CLC
F03A  65 7F        ADC $7f
F03C  85 79        STA $79
F03E  E6 7F        INC $7f
F040  CD 1A F1     CMP $f11a
F043  90 05        BCC $f04a
F045  A9 67        LDA #$67
F047  20 81 E7     JSR $e781
F04A  20 7C EE     JSR $ee7c
F04D  B1 6C        LDA ($6c),Y
F04F  F0 D2        BEQ $f023
F051  68           PLA
F052  85 7F        STA $7f
F054  A9 00        LDA #$00
F056  85 7A        STA $7a
F058  20 65 F0     JSR $f065
F05B  F0 03        BEQ $f060
F05D  4C FB ED     JMP $edfb
F060  A9 71        LDA #$71
F062  20 81 E7     JSR $e781
F065  20 7C EE     JSR $ee7c
F068  98           TYA
F069  48           PHA
F06A  20 8B F0     JSR $f08b
F06D  A5 79        LDA $79
F06F  20 B6 F0     JSR $f0b6
F072  8D 4E 02     STA $024e
F075  68           PLA
F076  85 6E        STA $6e
F078  A5 7A        LDA $7a
F07A  CD 4E 02     CMP $024e
F07D  B0 09        BCS $f088
F07F  20 40 EE     JSR $ee40
F082  D0 06        BNE $f08a
F084  E6 7A        INC $7a
F086  D0 F0        BNE $f078
F088  A9 00        LDA #$00
F08A  60           RTS
F08B  A5 6E        LDA $6e
F08D  48           PHA
F08E  A9 00        LDA #$00
F090  85 6E        STA $6e
F092  AC C4 F0     LDY $f0c4
F095  88           DEY
F096  A2 07        LDX #$07
F098  B1 6C        LDA ($6c),Y
F09A  3D 54 EE     AND $ee54,X
F09D  F0 02        BEQ $f0a1
F09F  E6 6E        INC $6e
F0A1  CA           DEX
F0A2  10 F4        BPL $f098
F0A4  88           DEY
F0A5  D0 EF        BNE $f096
F0A7  B1 6C        LDA ($6c),Y
F0A9  C5 6E        CMP $6e
F0AB  D0 04        BNE $f0b1
F0AD  68           PLA
F0AE  85 6E        STA $6e
F0B0  60           RTS
F0B1  A9 71        LDA #$71
F0B3  20 81 E7     JSR $e781
F0B6  AE 19 F1     LDX $f119
F0B9  DD 19 F1     CMP $f119,X
F0BC  CA           DEX
F0BD  B0 FA        BCS $f0b9
F0BF  BD 14 F1     LDA $f114,X
F0C2  60           RTS
F0C3  12           ???
F0C4  04           ???
F0C5  04           ???
F0C6  90 25        BCC $f0ed
F0C8  56 49        LSR $49,X
F0CA  44           ???
F0CB  4D 42 55     EOR $5542
F0CE  50 26        BVC $f0f6
F0D0  43           ???
F0D1  52           ???
F0D2  53           ???
F0D3  4E DD F1     LSR $f1dd
F0D6  21 A2        AND ($a2,X)
F0D8  ED 0D 4E     SBC $4e0d
F0DB  42           ???
F0DC  D1 E5        CMP ($e5),Y
F0DE  7D 04 7A     ADC $7a04,X
F0E1  C1 EB        CMP ($eb,X)
F0E3  D1 C9        CMP ($c9),Y
F0E5  CB           ???
F0E6  CD CC E3     CMP $e3cc
F0E9  E8           INX
F0EA  C9 CB        CMP #$cb
F0EC  C9 EC        CMP #$ec
F0EE  51 DD        EOR ($dd),Y
F0F0  1C           ???
F0F1  9E           ???
F0F2  1C           ???
F0F3  52           ???
F0F4  57           ???
F0F5  41 4D        EOR ($4d,X)
F0F7  44           ???
F0F8  53           ???
F0F9  50 55        BVC $f150
F0FB  4C 44 53     JMP $5344
F0FE  50 55        BVC $f155
F100  52           ???
F101  45 45        EOR $45
F103  52           ???
F104  53           ???
F105  45 4C        EOR $4c
F107  51 47        EOR ($47),Y
F109  52           ???
F10A  4C 01 02     JMP $0201
F10D  00           BRK
F10E  3F           ???
F10F  7F           ???
F110  BF           ???
F111  FF           ???
F112  05 06        ORA $06
F114  11 12        ORA ($12),Y
F116  13           ???
F117  15 41        ORA $41,X
F119  04           ???
F11A  24 1F        BIT $1f
F11C  19 12 01     ORA $0112,Y
F11F  FF           ???
F120  FF           ???
F121  01 00        ORA ($00,X)
F123  03           ???
F124  04           ???
F125  05 06        ORA $06
F127  07           ???
F128  07           ???
F129  21 22        AND ($22,X)
F12B  23           ???
F12C  24 25        BIT $25
F12E  26 27        ROL $27
F130  28           PLP
F131  29 02        AND #$02
F133  02           ???
F134  04           ???
F135  06 08        ASL $08
F137  08           PHP
F138  0B           ???
F139  13           ???
F13A  16 58        ASL $58,X
F13C  60           RTS
F13D  A9 6F        LDA #$6f
F13F  85 00        STA $00
F141  29 68        AND #$68
F143  85 01        STA $01
F145  A2 14        LDX #$14
F147  8E 02 40     STX $4002
F14A  A2 1F        LDX #$1f
F14C  8E 05 40     STX $4005
F14F  AD 02 40     LDA $4002
F152  29 20        AND #$20
F154  D0 03        BNE $f159
F156  A9 08        LDA #$08
F158  2C A9 09     BIT $09a9
F15B  85 66        STA $66
F15D  20 0D C2     JSR $c20d
F160  A9 FF        LDA #$ff
F162  85 31        STA $31
F164  85 40        STA $40
F166  A9 01        LDA #$01
F168  85 22        STA $22
F16A  85 23        STA $23
F16C  A9 00        LDA #$00
F16E  85 4D        STA $4d
F170  A0 12        LDY #$12
F172  A9 01        LDA #$01
F174  99 02 00     STA $0002,Y
F177  88           DEY
F178  10 FA        BPL $f174
F17A  A9 00        LDA #$00
F17C  8D 03 40     STA $4003
F17F  AD 02 40     LDA $4002
F182  09 08        ORA #$08
F184  29 FC        AND #$fc
F186  8D 02 40     STA $4002
F189  29 F7        AND #$f7
F18B  8D 02 40     STA $4002
F18E  09 08        ORA #$08
F190  8D 02 40     STA $4002
F193  58           CLI
F194  60           RTS
F195  48           PHA
F196  8A           TXA
F197  48           PHA
F198  98           TYA
F199  48           PHA
F19A  BA           TSX
F19B  86 3A        STX $3a
F19D  A0 05        LDY #$05
F19F  B9 02 00     LDA $0002,Y
F1A2  30 27        BMI $f1cb
F1A4  88           DEY
F1A5  10 F8        BPL $f19f
F1A7  A5 76        LDA $76
F1A9  D0 0F        BNE $f1ba
F1AB  A5 01        LDA $01
F1AD  09 08        ORA #$08
F1AF  A4 96        LDY $96
F1B1  F0 02        BEQ $f1b5
F1B3  29 F7        AND #$f7
F1B5  85 01        STA $01
F1B7  4C C8 F1     JMP $f1c8
F1BA  C6 55        DEC $55
F1BC  10 0A        BPL $f1c8
F1BE  A9 1E        LDA #$1e
F1C0  85 55        STA $55
F1C2  A5 01        LDA $01
F1C4  49 08        EOR #$08
F1C6  85 01        STA $01
F1C8  4C 41 FA     JMP $fa41
F1CB  29 01        AND #$01
F1CD  AA           TAX
F1CE  C5 31        CMP $31
F1D0  F0 1B        BEQ $f1ed
F1D2  85 31        STA $31
F1D4  29 01        AND #$01
F1D6  85 32        STA $32
F1D8  6A           ROR A
F1D9  6A           ROR A
F1DA  6A           ROR A
F1DB  85 38        STA $38
F1DD  AD 02 40     LDA $4002
F1E0  29 3F        AND #$3f
F1E2  05 38        ORA $38
F1E4  8D 02 40     STA $4002
F1E7  20 27 FA     JSR $fa27
F1EA  4C 41 FA     JMP $fa41
F1ED  A5 2B        LDA $2b
F1EF  30 03        BMI $f1f4
F1F1  0A           ASL A
F1F2  10 03        BPL $f1f7
F1F4  4C 41 FA     JMP $fa41
F1F7  A9 20        LDA #$20
F1F9  85 2B        STA $2b
F1FB  A5 01        LDA $01
F1FD  29 F7        AND #$f7
F1FF  85 01        STA $01
F201  A0 05        LDY #$05
F203  84 33        STY $33
F205  20 84 F2     JSR $f284
F208  30 1A        BMI $f224
F20A  C6 33        DEC $33
F20C  10 F7        BPL $f205
F20E  A4 34        LDY $34
F210  20 86 F2     JSR $f286
F213  A5 35        LDA $35
F215  85 3B        STA $3b
F217  06 3B        ASL $3b
F219  A9 60        LDA #$60
F21B  85 2B        STA $2b
F21D  B1 20        LDA ($20),Y
F21F  85 29        STA $29
F221  4C 41 FA     JMP $fa41
F224  29 01        AND #$01
F226  C5 31        CMP $31
F228  D0 E0        BNE $f20a
F22A  A5 29        LDA $29
F22C  F0 10        BEQ $f23e
F22E  38           SEC
F22F  B1 20        LDA ($20),Y
F231  E5 29        SBC $29
F233  F0 09        BEQ $f23e
F235  85 35        STA $35
F237  A5 33        LDA $33
F239  85 34        STA $34
F23B  4C 0A F2     JMP $f20a
F23E  A2 04        LDX #$04
F240  B1 20        LDA ($20),Y
F242  85 56        STA $56
F244  DD 19 F1     CMP $f119,X
F247  CA           DEX
F248  B0 FA        BCS $f244
F24A  BD 14 F1     LDA $f114,X
F24D  85 57        STA $57
F24F  8A           TXA
F250  0A           ASL A
F251  0A           ASL A
F252  0A           ASL A
F253  0A           ASL A
F254  0A           ASL A
F255  85 38        STA $38
F257  A5 01        LDA $01
F259  29 9F        AND #$9f
F25B  05 38        ORA $38
F25D  85 01        STA $01
F25F  A5 1D        LDA $1d
F261  C9 40        CMP #$40
F263  F0 0A        BEQ $f26f
F265  C9 70        CMP #$70
F267  F0 03        BEQ $f26c
F269  4C A6 F2     JMP $f2a6
F26C  4C 7A FB     JMP $fb7a
F26F  A5 01        LDA $01
F271  29 FC        AND #$fc
F273  85 01        STA $01
F275  A9 60        LDA #$60
F277  85 2B        STA $2b
F279  A9 A4        LDA #$a4
F27B  85 3B        STA $3b
F27D  A9 01        LDA #$01
F27F  85 29        STA $29
F281  4C 12 FA     JMP $fa12
F284  A4 33        LDY $33
F286  B9 02 00     LDA $0002,Y
F289  48           PHA
F28A  10 14        BPL $f2a0
F28C  29 78        AND #$78
F28E  85 1D        STA $1d
F290  98           TYA
F291  0A           ASL A
F292  69 08        ADC #$08
F294  85 20        STA $20
F296  A9 00        LDA #$00
F298  85 21        STA $21
F29A  98           TYA
F29B  18           CLC
F29C  69 03        ADC #$03
F29E  85 28        STA $28
F2A0  A0 00        LDY #$00
F2A2  84 27        STY $27
F2A4  68           PLA
F2A5  60           RTS
F2A6  A9 5A        LDA #$5a
F2A8  85 3C        STA $3c
F2AA  20 60 F5     JSR $f560
F2AD  24 01        BIT $01
F2AF  10 FC        BPL $f2ad
F2B1  2C 00 40     BIT $4000
F2B4  AD 01 40     LDA $4001
F2B7  C9 52        CMP #$52
F2B9  D0 42        BNE $f2fd
F2BB  A0 00        LDY #$00
F2BD  99 11 01     STA $0111,Y
F2C0  C8           INY
F2C1  24 01        BIT $01
F2C3  10 FC        BPL $f2c1
F2C5  2C 00 40     BIT $4000
F2C8  AD 01 40     LDA $4001
F2CB  99 11 01     STA $0111,Y
F2CE  C8           INY
F2CF  C0 08        CPY #$08
F2D1  D0 EE        BNE $f2c1
F2D3  20 88 F3     JSR $f388
F2D6  A0 04        LDY #$04
F2D8  A9 00        LDA #$00
F2DA  59 18 00     EOR $0018,Y
F2DD  88           DEY
F2DE  10 FA        BPL $f2da
F2E0  C9 00        CMP #$00
F2E2  D0 30        BNE $f314
F2E4  A5 1A        LDA $1a
F2E6  85 29        STA $29
F2E8  A5 1D        LDA $1d
F2EA  C9 30        CMP #$30
F2EC  F0 18        BEQ $f306
F2EE  A5 14        LDA $14
F2F0  C5 18        CMP $18
F2F2  D0 1D        BNE $f311
F2F4  A5 15        LDA $15
F2F6  C5 19        CMP $19
F2F8  D0 17        BNE $f311
F2FA  4C 19 F3     JMP $f319
F2FD  C6 3C        DEC $3c
F2FF  D0 A9        BNE $f2aa
F301  A9 02        LDA #$02
F303  20 12 FA     JSR $fa12
F306  A5 18        LDA $18
F308  85 14        STA $14
F30A  A5 19        LDA $19
F30C  85 15        STA $15
F30E  A9 01        LDA #$01
F310  2C A9 0B     BIT $0ba9
F313  2C A9 09     BIT $09a9
F316  4C 12 FA     JMP $fa12
F319  A9 7F        LDA #$7f
F31B  85 3D        STA $3d
F31D  A5 1B        LDA $1b
F31F  18           CLC
F320  69 02        ADC #$02
F322  C5 57        CMP $57
F324  90 02        BCC $f328
F326  E5 57        SBC $57
F328  85 3E        STA $3e
F32A  A2 05        LDX #$05
F32C  86 33        STX $33
F32E  A2 FF        LDX #$ff
F330  20 84 F2     JSR $f284
F333  10 3F        BPL $f374
F335  85 38        STA $38
F337  29 01        AND #$01
F339  C5 31        CMP $31
F33B  D0 37        BNE $f374
F33D  A0 00        LDY #$00
F33F  B1 20        LDA ($20),Y
F341  C5 56        CMP $56
F343  D0 2F        BNE $f374
F345  A0 01        LDY #$01
F347  38           SEC
F348  B1 20        LDA ($20),Y
F34A  E5 3E        SBC $3e
F34C  10 03        BPL $f351
F34E  18           CLC
F34F  65 57        ADC $57
F351  C5 3D        CMP $3d
F353  B0 1F        BCS $f374
F355  48           PHA
F356  A5 1D        LDA $1d
F358  F0 15        BEQ $f36f
F35A  68           PLA
F35B  C9 09        CMP #$09
F35D  90 15        BCC $f374
F35F  C9 0C        CMP #$0c
F361  B0 11        BCS $f374
F363  85 3D        STA $3d
F365  A5 33        LDA $33
F367  AA           TAX
F368  18           CLC
F369  69 03        ADC #$03
F36B  85 28        STA $28
F36D  D0 05        BNE $f374
F36F  68           PLA
F370  C9 06        CMP #$06
F372  90 EF        BCC $f363
F374  C6 33        DEC $33
F376  10 B8        BPL $f330
F378  8A           TXA
F379  10 03        BPL $f37e
F37B  4C 41 FA     JMP $fa41
F37E  86 33        STX $33
F380  20 84 F2     JSR $f284
F383  A5 1D        LDA $1d
F385  4C FC F3     JMP $f3fc
F388  A5 27        LDA $27
F38A  48           PHA
F38B  A5 28        LDA $28
F38D  48           PHA
F38E  A9 11        LDA #$11
F390  85 27        STA $27
F392  A9 01        LDA #$01
F394  85 28        STA $28
F396  A9 00        LDA #$00
F398  85 2D        STA $2d
F39A  20 28 F9     JSR $f928
F39D  A5 44        LDA $44
F39F  85 1A        STA $1a
F3A1  A5 43        LDA $43
F3A3  85 1B        STA $1b
F3A5  A5 42        LDA $42
F3A7  85 1C        STA $1c
F3A9  20 28 F9     JSR $f928
F3AC  A5 41        LDA $41
F3AE  85 19        STA $19
F3B0  A5 42        LDA $42
F3B2  85 18        STA $18
F3B4  68           PLA
F3B5  85 28        STA $28
F3B7  68           PLA
F3B8  85 27        STA $27
F3BA  60           RTS
F3BB  A5 28        LDA $28
F3BD  85 1F        STA $1f
F3BF  A9 01        LDA #$01
F3C1  85 28        STA $28
F3C3  A9 11        LDA #$11
F3C5  85 2D        STA $2d
F3C7  A9 08        LDA #$08
F3C9  85 41        STA $41
F3CB  A5 1C        LDA $1c
F3CD  85 42        STA $42
F3CF  A5 1B        LDA $1b
F3D1  85 43        STA $43
F3D3  A5 1A        LDA $1a
F3D5  85 44        STA $44
F3D7  20 0C F8     JSR $f80c
F3DA  A5 19        LDA $19
F3DC  85 41        STA $41
F3DE  A5 18        LDA $18
F3E0  85 42        STA $42
F3E2  A9 00        LDA #$00
F3E4  85 43        STA $43
F3E6  85 44        STA $44
F3E8  20 0C F8     JSR $f80c
F3EB  A5 1F        LDA $1f
F3ED  85 28        STA $28
F3EF  60           RTS
F3F0  A9 00        LDA #$00
F3F2  8D 6C 02     STA $026c
F3F5  F0 02        BEQ $f3f9
F3F7  A9 E0        LDA #$e0
F3F9  85 76        STA $76
F3FB  60           RTS
F3FC  C9 00        CMP #$00
F3FE  F0 03        BEQ $f403
F400  4C 7D F5     JMP $f57d
F403  20 13 F5     JSR $f513
F406  24 01        BIT $01
F408  10 FC        BPL $f406
F40A  AD 01 40     LDA $4001
F40D  85 FA        STA $fa
F40F  29 F8        AND #$f8
F411  AA           TAX
F412  BD 0C F7     LDA $f70c,X
F415  85 F9        STA $f9
F417  A5 FA        LDA $fa
F419  29 07        AND #$07
F41B  85 FA        STA $fa
F41D  24 01        BIT $01
F41F  10 FC        BPL $f41d
F421  AD 01 40     LDA $4001
F424  85 FB        STA $fb
F426  29 C0        AND #$c0
F428  05 FA        ORA $fa
F42A  AA           TAX
F42B  BD 0C F7     LDA $f70c,X
F42E  05 F9        ORA $f9
F430  48           PHA
F431  D0 31        BNE $f464
F433  F0 2F        BEQ $f464
F435  24 01        BIT $01
F437  10 FC        BPL $f435
F439  AD 01 40     LDA $4001
F43C  85 FA        STA $fa
F43E  29 F8        AND #$f8
F440  AA           TAX
F441  BD 0C F7     LDA $f70c,X
F444  85 F9        STA $f9
F446  A5 FA        LDA $fa
F448  29 07        AND #$07
F44A  85 FA        STA $fa
F44C  24 01        BIT $01
F44E  10 FC        BPL $f44c
F450  AD 01 40     LDA $4001
F453  85 FB        STA $fb
F455  29 C0        AND #$c0
F457  05 FA        ORA $fa
F459  AA           TAX
F45A  BD 0C F7     LDA $f70c,X
F45D  05 F9        ORA $f9
F45F  91 27        STA ($27),Y
F461  C8           INY
F462  F0 75        BEQ $f4d9
F464  A5 FB        LDA $fb
F466  29 3E        AND #$3e
F468  AA           TAX
F469  BD 0C F7     LDA $f70c,X
F46C  85 F9        STA $f9
F46E  A5 FB        LDA $fb
F470  29 01        AND #$01
F472  85 FB        STA $fb
F474  24 01        BIT $01
F476  10 FC        BPL $f474
F478  AD 01 40     LDA $4001
F47B  85 FC        STA $fc
F47D  29 F0        AND #$f0
F47F  05 FB        ORA $fb
F481  AA           TAX
F482  BD 0E F7     LDA $f70e,X
F485  05 F9        ORA $f9
F487  91 27        STA ($27),Y
F489  C8           INY
F48A  A5 FC        LDA $fc
F48C  29 0F        AND #$0f
F48E  85 FC        STA $fc
F490  24 01        BIT $01
F492  10 FC        BPL $f490
F494  AD 01 40     LDA $4001
F497  85 FD        STA $fd
F499  29 80        AND #$80
F49B  05 FC        ORA $fc
F49D  AA           TAX
F49E  BD 1C F7     LDA $f71c,X
F4A1  85 F9        STA $f9
F4A3  A5 FD        LDA $fd
F4A5  29 7C        AND #$7c
F4A7  AA           TAX
F4A8  BD 0D F7     LDA $f70d,X
F4AB  05 F9        ORA $f9
F4AD  91 27        STA ($27),Y
F4AF  C8           INY
F4B0  A5 FD        LDA $fd
F4B2  29 03        AND #$03
F4B4  85 FD        STA $fd
F4B6  24 01        BIT $01
F4B8  10 FC        BPL $f4b6
F4BA  AD 01 40     LDA $4001
F4BD  85 FA        STA $fa
F4BF  29 E0        AND #$e0
F4C1  05 FD        ORA $fd
F4C3  AA           TAX
F4C4  BD 29 F7     LDA $f729,X
F4C7  85 F9        STA $f9
F4C9  A5 FA        LDA $fa
F4CB  29 1F        AND #$1f
F4CD  AA           TAX
F4CE  BD FF F6     LDA $f6ff,X
F4D1  05 F9        ORA $f9
F4D3  91 27        STA ($27),Y
F4D5  C8           INY
F4D6  4C 35 F4     JMP $f435
F4D9  A5 FB        LDA $fb
F4DB  29 3E        AND #$3e
F4DD  AA           TAX
F4DE  BD 0C F7     LDA $f70c,X
F4E1  85 F9        STA $f9
F4E3  A5 FB        LDA $fb
F4E5  29 01        AND #$01
F4E7  85 FB        STA $fb
F4E9  24 01        BIT $01
F4EB  10 FC        BPL $f4e9
F4ED  AD 01 40     LDA $4001
F4F0  29 F0        AND #$f0
F4F2  05 FB        ORA $fb
F4F4  AA           TAX
F4F5  BD 0E F7     LDA $f70e,X
F4F8  05 F9        ORA $f9
F4FA  85 FA        STA $fa
F4FC  68           PLA
F4FD  C9 07        CMP #$07
F4FF  D0 0A        BNE $f50b
F501  20 0A F6     JSR $f60a
F504  C5 FA        CMP $fa
F506  F0 06        BEQ $f50e
F508  A9 05        LDA #$05
F50A  2C A9 04     BIT $04a9
F50D  2C A9 01     BIT $01a9
F510  4C 12 FA     JMP $fa12
F513  20 19 F5     JSR $f519
F516  4C 60 F5     JMP $f560
F519  A5 14        LDA $14
F51B  85 18        STA $18
F51D  A5 15        LDA $15
F51F  85 19        STA $19
F521  A0 00        LDY #$00
F523  B1 20        LDA ($20),Y
F525  85 1A        STA $1a
F527  C8           INY
F528  B1 20        LDA ($20),Y
F52A  85 1B        STA $1b
F52C  A9 00        LDA #$00
F52E  45 18        EOR $18
F530  45 19        EOR $19
F532  45 1A        EOR $1a
F534  45 1B        EOR $1b
F536  85 1C        STA $1c
F538  20 BB F3     JSR $f3bb
F53B  A9 5A        LDA #$5a
F53D  85 3C        STA $3c
F53F  20 60 F5     JSR $f560
F542  B9 11 01     LDA $0111,Y
F545  24 01        BIT $01
F547  10 FC        BPL $f545
F549  CD 01 40     CMP $4001
F54C  D0 06        BNE $f554
F54E  C8           INY
F54F  C0 08        CPY #$08
F551  D0 EF        BNE $f542
F553  60           RTS
F554  C6 3C        DEC $3c
F556  D0 E7        BNE $f53f
F558  A9 02        LDA #$02
F55A  2C A9 03     BIT $03a9
F55D  4C 12 FA     JMP $fa12
F560  A0 12        LDY #$12
F562  A2 FF        LDX #$ff
F564  AD 02 40     LDA $4002
F567  29 40        AND #$40
F569  F0 09        BEQ $f574
F56B  CA           DEX
F56C  D0 F6        BNE $f564
F56E  88           DEY
F56F  D0 F1        BNE $f562
F571  4C 5B F5     JMP $f55b
F574  AD 01 40     LDA $4001
F577  2C 00 40     BIT $4000
F57A  A0 00        LDY #$00
F57C  60           RTS
F57D  C9 10        CMP #$10
F57F  F0 03        BEQ $f584
F581  4C BA F6     JMP $f6ba
F584  20 0A F6     JSR $f60a
F587  A5 01        LDA $01
F589  29 10        AND #$10
F58B  D0 05        BNE $f592
F58D  A9 08        LDA #$08
F58F  4C 12 FA     JMP $fa12
F592  20 CF F8     JSR $f8cf
F595  20 19 F5     JSR $f519
F598  A0 09        LDY #$09
F59A  24 01        BIT $01
F59C  10 FC        BPL $f59a
F59E  2C 00 40     BIT $4000
F5A1  88           DEY
F5A2  D0 F6        BNE $f59a
F5A4  A9 FF        LDA #$ff
F5A6  8D 04 40     STA $4004
F5A9  AD 02 40     LDA $4002
F5AC  29 EF        AND #$ef
F5AE  8D 02 40     STA $4002
F5B1  A9 FF        LDA #$ff
F5B3  A0 05        LDY #$05
F5B5  8D 01 40     STA $4001
F5B8  2C 00 40     BIT $4000
F5BB  24 01        BIT $01
F5BD  10 FC        BPL $f5bb
F5BF  2C 00 40     BIT $4000
F5C2  88           DEY
F5C3  D0 F6        BNE $f5bb
F5C5  A0 BB        LDY #$bb
F5C7  B9 60 00     LDA $0060,Y
F5CA  24 01        BIT $01
F5CC  10 FC        BPL $f5ca
F5CE  2C 00 40     BIT $4000
F5D1  8D 01 40     STA $4001
F5D4  C8           INY
F5D5  D0 F0        BNE $f5c7
F5D7  B1 27        LDA ($27),Y
F5D9  24 01        BIT $01
F5DB  10 FC        BPL $f5d9
F5DD  2C 00 40     BIT $4000
F5E0  8D 01 40     STA $4001
F5E3  C8           INY
F5E4  D0 F1        BNE $f5d7
F5E6  24 01        BIT $01
F5E8  10 FC        BPL $f5e6
F5EA  2C 00 40     BIT $4000
F5ED  AD 02 40     LDA $4002
F5F0  09 10        ORA #$10
F5F2  8D 02 40     STA $4002
F5F5  A9 00        LDA #$00
F5F7  8D 04 40     STA $4004
F5FA  20 18 F6     JSR $f618
F5FD  A4 33        LDY $33
F5FF  B9 02 00     LDA $0002,Y
F602  49 30        EOR #$30
F604  99 02 00     STA $0002,Y
F607  4C A6 F2     JMP $f2a6
F60A  A0 00        LDY #$00
F60C  84 30        STY $30
F60E  B1 27        LDA ($27),Y
F610  45 30        EOR $30
F612  85 30        STA $30
F614  C8           INY
F615  D0 F7        BNE $f60e
F617  60           RTS
F618  A9 60        LDA #$60
F61A  85 27        STA $27
F61C  A5 28        LDA $28
F61E  85 36        STA $36
F620  A9 00        LDA #$00
F622  85 28        STA $28
F624  85 37        STA $37
F626  A9 BB        LDA #$bb
F628  85 2D        STA $2d
F62A  85 2E        STA $2e
F62C  20 28 F9     JSR $f928
F62F  A5 41        LDA $41
F631  85 2F        STA $2f
F633  A4 2E        LDY $2e
F635  A5 42        LDA $42
F637  99 60 00     STA $0060,Y
F63A  C8           INY
F63B  A5 43        LDA $43
F63D  99 60 00     STA $0060,Y
F640  C8           INY
F641  A5 44        LDA $44
F643  99 60 00     STA $0060,Y
F646  C8           INY
F647  84 2E        STY $2e
F649  20 28 F9     JSR $f928
F64C  A4 2E        LDY $2e
F64E  A5 41        LDA $41
F650  99 60 00     STA $0060,Y
F653  C8           INY
F654  A5 42        LDA $42
F656  99 60 00     STA $0060,Y
F659  C8           INY
F65A  F0 10        BEQ $f66c
F65C  A5 43        LDA $43
F65E  99 60 00     STA $0060,Y
F661  C8           INY
F662  A5 44        LDA $44
F664  99 60 00     STA $0060,Y
F667  C8           INY
F668  84 2E        STY $2e
F66A  D0 DD        BNE $f649
F66C  A5 43        LDA $43
F66E  91 27        STA ($27),Y
F670  C8           INY
F671  A5 44        LDA $44
F673  91 27        STA ($27),Y
F675  C8           INY
F676  84 2E        STY $2e
F678  20 28 F9     JSR $f928
F67B  A4 2E        LDY $2e
F67D  A5 41        LDA $41
F67F  91 27        STA ($27),Y
F681  C8           INY
F682  A5 42        LDA $42
F684  91 27        STA ($27),Y
F686  C8           INY
F687  A5 43        LDA $43
F689  91 27        STA ($27),Y
F68B  C8           INY
F68C  A5 44        LDA $44
F68E  91 27        STA ($27),Y
F690  C8           INY
F691  84 2E        STY $2e
F693  C0 BB        CPY #$bb
F695  90 E1        BCC $f678
F697  A9 45        LDA #$45
F699  85 1E        STA $1e
F69B  A5 28        LDA $28
F69D  85 1F        STA $1f
F69F  A0 BA        LDY #$ba
F6A1  B1 27        LDA ($27),Y
F6A3  91 1E        STA ($1e),Y
F6A5  88           DEY
F6A6  D0 F9        BNE $f6a1
F6A8  B1 27        LDA ($27),Y
F6AA  91 1E        STA ($1e),Y
F6AC  A2 BB        LDX #$bb
F6AE  B9 1B 01     LDA $011b,Y
F6B1  91 27        STA ($27),Y
F6B3  C8           INY
F6B4  E8           INX
F6B5  D0 F7        BNE $f6ae
F6B7  86 3F        STX $3f
F6B9  60           RTS
F6BA  C9 20        CMP #$20
F6BC  F0 03        BEQ $f6c1
F6BE  4C F9 F6     JMP $f6f9
F6C1  20 0A F6     JSR $f60a
F6C4  20 CF F8     JSR $f8cf
F6C7  20 13 F5     JSR $f513
F6CA  A0 BB        LDY #$bb
F6CC  B9 60 00     LDA $0060,Y
F6CF  24 01        BIT $01
F6D1  10 FC        BPL $f6cf
F6D3  2C 00 40     BIT $4000
F6D6  4D 01 40     EOR $4001
F6D9  D0 19        BNE $f6f4
F6DB  C8           INY
F6DC  D0 EE        BNE $f6cc
F6DE  B1 27        LDA ($27),Y
F6E0  24 01        BIT $01
F6E2  10 FC        BPL $f6e0
F6E4  2C 00 40     BIT $4000
F6E7  4D 01 40     EOR $4001
F6EA  D0 08        BNE $f6f4
F6EC  C8           INY
F6ED  C0 FD        CPY #$fd
F6EF  D0 ED        BNE $f6de
F6F1  4C 0E F3     JMP $f30e
F6F4  A9 07        LDA #$07
F6F6  4C 12 FA     JMP $fa12
F6F9  20 19 F5     JSR $f519
F6FC  4C 0E F3     JMP $f30e
F6FF  FF           ???
F700  FF           ???
F701  FF           ???
F702  FF           ???
F703  FF           ???
F704  FF           ???
F705  FF           ???
F706  FF           ???
F707  FF           ???
F708  08           PHP
F709  00           BRK
F70A  01 FF        ORA ($ff,X)
F70C  0C           ???
F70D  04           ???
F70E  05 FF        ORA $ff
F710  FF           ???
F711  02           ???
F712  03           ???
F713  FF           ???
F714  0F           ???
F715  06 07        ASL $07
F717  FF           ???
F718  09 0A        ORA #$0a
F71A  0B           ???
F71B  FF           ???
F71C  0D 0E 80     ORA $800e
F71F  FF           ???
F720  00           BRK
F721  00           BRK
F722  10 40        BPL $f764
F724  FF           ???
F725  20 C0 60     JSR $60c0
F728  40           RTI
F729  A0 50        LDY #$50
F72B  E0 FF        CPX #$ff
F72D  FF           ???
F72E  FF           ???
F72F  02           ???
F730  20 08 30     JSR $3008
F733  FF           ???
F734  FF           ???
F735  00           BRK
F736  F0 FF        BEQ $f737
F738  60           RTS
F739  01 70        ORA ($70,X)
F73B  FF           ???
F73C  FF           ???
F73D  FF           ???
F73E  90 03        BCC $f743
F740  A0 0C        LDY #$0c
F742  B0 FF        BCS $f743
F744  FF           ???
F745  04           ???
F746  D0 FF        BNE $f747
F748  E0 05        CPX #$05
F74A  80           ???
F74B  FF           ???
F74C  90 FF        BCC $f74d
F74E  08           PHP
F74F  0C           ???
F750  FF           ???
F751  0F           ???
F752  09 0D        ORA #$0d
F754  80           ???
F755  02           ???
F756  FF           ???
F757  FF           ???
F758  FF           ???
F759  03           ???
F75A  FF           ???
F75B  FF           ???
F75C  00           BRK
F75D  FF           ???
F75E  FF           ???
F75F  0F           ???
F760  FF           ???
F761  0F           ???
F762  FF           ???
F763  FF           ???
F764  10 06        BPL $f76c
F766  FF           ???
F767  FF           ???
F768  FF           ???
F769  07           ???
F76A  00           BRK
F76B  20 A0 FF     JSR $ffa0
F76E  FF           ???
F76F  06 FF        ASL $ff
F771  09 FF        ORA #$ff
F773  FF           ???
F774  C0 0A        CPY #$0a
F776  FF           ???
F777  FF           ???
F778  FF           ???
F779  0B           ???
F77A  FF           ???
F77B  FF           ???
F77C  40           RTI
F77D  FF           ???
F77E  FF           ???
F77F  07           ???
F780  FF           ???
F781  0D FF FF     ORA $ffff
F784  50 0E        BVC $f794
F786  FF           ???
F787  FF           ???
F788  FF           ???
F789  FF           ???
F78A  10 30        BPL $f7bc
F78C  B0 FF        BCS $f78d
F78E  00           BRK
F78F  04           ???
F790  02           ???
F791  06 0A        ASL $0a
F793  0E 80 FF     ASL $ff80
F796  FF           ???
F797  FF           ???
F798  FF           ???
F799  FF           ???
F79A  FF           ???
F79B  FF           ???
F79C  20 FF 08     JSR $08ff
F79F  09 80        ORA #$80
F7A1  10 C0        BPL $f763
F7A3  50 30        BVC $f7d5
F7A5  30 F0        BMI $f797
F7A7  70 90        BVS $f739
F7A9  B0 D0        BCS $f77b
F7AB  FF           ???
F7AC  FF           ???
F7AD  FF           ???
F7AE  00           BRK
F7AF  0A           ASL A
F7B0  FF           ???
F7B1  FF           ???
F7B2  FF           ???
F7B3  FF           ???
F7B4  F0 FF        BEQ $f7b5
F7B6  FF           ???
F7B7  FF           ???
F7B8  FF           ???
F7B9  FF           ???
F7BA  FF           ???
F7BB  FF           ???
F7BC  60           RTS
F7BD  FF           ???
F7BE  01 0B        ORA ($0b,X)
F7C0  FF           ???
F7C1  FF           ???
F7C2  FF           ???
F7C3  FF           ???
F7C4  70 FF        BVS $f7c5
F7C6  FF           ???
F7C7  FF           ???
F7C8  FF           ???
F7C9  FF           ???
F7CA  C0 F0        CPY #$f0
F7CC  D0 FF        BNE $f7cd
F7CE  01 05        ORA ($05,X)
F7D0  03           ???
F7D1  07           ???
F7D2  0B           ???
F7D3  FF           ???
F7D4  90 FF        BCC $f7d5
F7D6  FF           ???
F7D7  FF           ???
F7D8  FF           ???
F7D9  FF           ???
F7DA  FF           ???
F7DB  FF           ???
F7DC  A0 FF        LDY #$ff
F7DE  0C           ???
F7DF  0D FF FF     ORA $ffff
F7E2  FF           ???
F7E3  FF           ???
F7E4  B0 FF        BCS $f7e5
F7E6  FF           ???
F7E7  FF           ???
F7E8  FF           ???
F7E9  FF           ???
F7EA  40           RTI
F7EB  60           RTS
F7EC  E0 FF        CPX #$ff
F7EE  04           ???
F7EF  0E FF FF     ASL $ffff
F7F2  FF           ???
F7F3  FF           ???
F7F4  D0 FF        BNE $f7f5
F7F6  FF           ???
F7F7  FF           ???
F7F8  FF           ???
F7F9  FF           ???
F7FA  FF           ???
F7FB  FF           ???
F7FC  E0 FF        CPX #$ff
F7FE  05 FF        ORA $ff
F800  FF           ???
F801  FF           ???
F802  FF           ???
F803  FF           ???
F804  FF           ???
F805  FF           ???
F806  FF           ???
F807  FF           ???
F808  FF           ???
F809  FF           ???
F80A  50 70        BVC $f87c
F80C  A9 00        LDA #$00
F80E  85 46        STA $46
F810  85 49        STA $49
F812  A4 2D        LDY $2d
F814  A5 41        LDA $41
F816  29 F0        AND #$f0
F818  4A           LSR A
F819  4A           LSR A
F81A  4A           LSR A
F81B  4A           LSR A
F81C  AA           TAX
F81D  BD BF F8     LDA $f8bf,X
F820  0A           ASL A
F821  0A           ASL A
F822  0A           ASL A
F823  85 45        STA $45
F825  A5 41        LDA $41
F827  29 0F        AND #$0f
F829  AA           TAX
F82A  BD BF F8     LDA $f8bf,X
F82D  6A           ROR A
F82E  66 46        ROR $46
F830  6A           ROR A
F831  66 46        ROR $46
F833  29 07        AND #$07
F835  05 45        ORA $45
F837  91 27        STA ($27),Y
F839  C8           INY
F83A  A5 42        LDA $42
F83C  29 F0        AND #$f0
F83E  4A           LSR A
F83F  4A           LSR A
F840  4A           LSR A
F841  4A           LSR A
F842  AA           TAX
F843  BD BF F8     LDA $f8bf,X
F846  0A           ASL A
F847  05 46        ORA $46
F849  85 46        STA $46
F84B  A5 42        LDA $42
F84D  29 0F        AND #$0f
F84F  AA           TAX
F850  BD BF F8     LDA $f8bf,X
F853  2A           ROL A
F854  2A           ROL A
F855  2A           ROL A
F856  2A           ROL A
F857  85 47        STA $47
F859  2A           ROL A
F85A  29 01        AND #$01
F85C  05 46        ORA $46
F85E  91 27        STA ($27),Y
F860  C8           INY
F861  A5 43        LDA $43
F863  29 F0        AND #$f0
F865  4A           LSR A
F866  4A           LSR A
F867  4A           LSR A
F868  4A           LSR A
F869  AA           TAX
F86A  BD BF F8     LDA $f8bf,X
F86D  18           CLC
F86E  6A           ROR A
F86F  05 47        ORA $47
F871  91 27        STA ($27),Y
F873  C8           INY
F874  6A           ROR A
F875  29 80        AND #$80
F877  85 48        STA $48
F879  A5 43        LDA $43
F87B  29 0F        AND #$0f
F87D  AA           TAX
F87E  BD BF F8     LDA $f8bf,X
F881  0A           ASL A
F882  0A           ASL A
F883  29 7C        AND #$7c
F885  05 48        ORA $48
F887  85 48        STA $48
F889  A5 44        LDA $44
F88B  29 F0        AND #$f0
F88D  4A           LSR A
F88E  4A           LSR A
F88F  4A           LSR A
F890  4A           LSR A
F891  AA           TAX
F892  BD BF F8     LDA $f8bf,X
F895  6A           ROR A
F896  66 49        ROR $49
F898  6A           ROR A
F899  66 49        ROR $49
F89B  6A           ROR A
F89C  66 49        ROR $49
F89E  29 03        AND #$03
F8A0  05 48        ORA $48
F8A2  91 27        STA ($27),Y
F8A4  C8           INY
F8A5  D0 08        BNE $f8af
F8A7  A5 1F        LDA $1f
F8A9  85 28        STA $28
F8AB  A9 00        LDA #$00
F8AD  85 27        STA $27
F8AF  A5 44        LDA $44
F8B1  29 0F        AND #$0f
F8B3  AA           TAX
F8B4  BD BF F8     LDA $f8bf,X
F8B7  05 49        ORA $49
F8B9  91 27        STA ($27),Y
F8BB  C8           INY
F8BC  84 2D        STY $2d
F8BE  60           RTS
F8BF  0A           ASL A
F8C0  0B           ???
F8C1  12           ???
F8C2  13           ???
F8C3  0E 0F 16     ASL $160f
F8C6  17           ???
F8C7  09 19        ORA #$19
F8C9  1A           ???
F8CA  1B           ???
F8CB  0D 1D 1E     ORA $1e1d
F8CE  15 A9        ORA $a9,X
F8D0  00           BRK
F8D1  85 1E        STA $1e
F8D3  85 2E        STA $2e
F8D5  A9 60        LDA #$60
F8D7  85 27        STA $27
F8D9  A9 BB        LDA #$bb
F8DB  85 2D        STA $2d
F8DD  85 3F        STA $3f
F8DF  A5 28        LDA $28
F8E1  85 1F        STA $1f
F8E3  A9 00        LDA #$00
F8E5  85 28        STA $28
F8E7  A9 07        LDA #$07
F8E9  85 41        STA $41
F8EB  A4 2E        LDY $2e
F8ED  B1 1E        LDA ($1e),Y
F8EF  85 42        STA $42
F8F1  C8           INY
F8F2  B1 1E        LDA ($1e),Y
F8F4  85 43        STA $43
F8F6  C8           INY
F8F7  B1 1E        LDA ($1e),Y
F8F9  85 44        STA $44
F8FB  C8           INY
F8FC  84 2E        STY $2e
F8FE  20 0C F8     JSR $f80c
F901  A4 2E        LDY $2e
F903  B1 1E        LDA ($1e),Y
F905  85 41        STA $41
F907  C8           INY
F908  F0 11        BEQ $f91b
F90A  B1 1E        LDA ($1e),Y
F90C  85 42        STA $42
F90E  C8           INY
F90F  B1 1E        LDA ($1e),Y
F911  85 43        STA $43
F913  C8           INY
F914  B1 1E        LDA ($1e),Y
F916  85 44        STA $44
F918  C8           INY
F919  D0 E1        BNE $f8fc
F91B  A5 30        LDA $30
F91D  85 42        STA $42
F91F  A9 00        LDA #$00
F921  85 43        STA $43
F923  85 44        STA $44
F925  4C 0C F8     JMP $f80c
F928  A4 2D        LDY $2d
F92A  B1 27        LDA ($27),Y
F92C  AA           TAX
F92D  29 F8        AND #$f8
F92F  85 45        STA $45
F931  8A           TXA
F932  29 07        AND #$07
F934  85 46        STA $46
F936  C8           INY
F937  D0 06        BNE $f93f
F939  A5 36        LDA $36
F93B  85 28        STA $28
F93D  A4 37        LDY $37
F93F  B1 27        LDA ($27),Y
F941  AA           TAX
F942  29 C0        AND #$c0
F944  05 46        ORA $46
F946  85 46        STA $46
F948  8A           TXA
F949  29 3E        AND #$3e
F94B  85 47        STA $47
F94D  8A           TXA
F94E  29 01        AND #$01
F950  85 48        STA $48
F952  C8           INY
F953  B1 27        LDA ($27),Y
F955  AA           TAX
F956  29 F0        AND #$f0
F958  05 48        ORA $48
F95A  85 48        STA $48
F95C  8A           TXA
F95D  29 0F        AND #$0f
F95F  85 49        STA $49
F961  C8           INY
F962  B1 27        LDA ($27),Y
F964  AA           TAX
F965  29 80        AND #$80
F967  05 49        ORA $49
F969  85 49        STA $49
F96B  8A           TXA
F96C  29 7C        AND #$7c
F96E  85 4A        STA $4a
F970  8A           TXA
F971  29 03        AND #$03
F973  85 4B        STA $4b
F975  C8           INY
F976  D0 08        BNE $f980
F978  A5 36        LDA $36
F97A  85 28        STA $28
F97C  A4 37        LDY $37
F97E  84 27        STY $27
F980  B1 27        LDA ($27),Y
F982  AA           TAX
F983  29 E0        AND #$e0
F985  05 4B        ORA $4b
F987  85 4B        STA $4b
F989  8A           TXA
F98A  29 1F        AND #$1f
F98C  85 4C        STA $4c
F98E  C8           INY
F98F  84 2D        STY $2d
F991  A6 45        LDX $45
F993  BD 0C F7     LDA $f70c,X
F996  A6 46        LDX $46
F998  1D 0C F7     ORA $f70c,X
F99B  85 41        STA $41
F99D  A6 47        LDX $47
F99F  BD 0C F7     LDA $f70c,X
F9A2  A6 48        LDX $48
F9A4  1D 0E F7     ORA $f70e,X
F9A7  85 42        STA $42
F9A9  A6 49        LDX $49
F9AB  BD 1C F7     LDA $f71c,X
F9AE  A6 4A        LDX $4a
F9B0  1D 0D F7     ORA $f70d,X
F9B3  85 43        STA $43
F9B5  A6 4B        LDX $4b
F9B7  BD 29 F7     LDA $f729,X
F9BA  A6 4C        LDX $4c
F9BC  1D FF F6     ORA $f6ff,X
F9BF  85 44        STA $44
F9C1  60           RTS
F9C2  A9 00        LDA #$00
F9C4  85 2D        STA $2d
F9C6  85 1E        STA $1e
F9C8  85 2E        STA $2e
F9CA  A9 01        LDA #$01
F9CC  85 36        STA $36
F9CE  A9 1B        LDA #$1b
F9D0  85 37        STA $37
F9D2  A5 28        LDA $28
F9D4  85 1F        STA $1f
F9D6  20 28 F9     JSR $f928
F9D9  A5 41        LDA $41
F9DB  85 2F        STA $2f
F9DD  A4 2E        LDY $2e
F9DF  A5 42        LDA $42
F9E1  91 1E        STA ($1e),Y
F9E3  C8           INY
F9E4  A5 43        LDA $43
F9E6  91 1E        STA ($1e),Y
F9E8  C8           INY
F9E9  A5 44        LDA $44
F9EB  91 1E        STA ($1e),Y
F9ED  C8           INY
F9EE  84 2E        STY $2e
F9F0  20 28 F9     JSR $f928
F9F3  A4 2E        LDY $2e
F9F5  A5 41        LDA $41
F9F7  91 1E        STA ($1e),Y
F9F9  C8           INY
F9FA  F0 11        BEQ $fa0d
F9FC  A5 42        LDA $42
F9FE  91 1E        STA ($1e),Y
FA00  C8           INY
FA01  A5 43        LDA $43
FA03  91 1E        STA ($1e),Y
FA05  C8           INY
FA06  A5 44        LDA $44
FA08  91 1E        STA ($1e),Y
FA0A  C8           INY
FA0B  D0 E1        BNE $f9ee
FA0D  A5 1F        LDA $1f
FA0F  85 28        STA $28
FA11  60           RTS
FA12  A4 33        LDY $33
FA14  99 02 00     STA $0002,Y
FA17  A5 3F        LDA $3f
FA19  F0 03        BEQ $fa1e
FA1B  20 18 F6     JSR $f618
FA1E  20 36 FA     JSR $fa36
FA21  A6 3A        LDX $3a
FA23  9A           TXS
FA24  4C 9D F1     JMP $f19d
FA27  A9 A0        LDA #$a0
FA29  85 2B        STA $2b
FA2B  A5 01        LDA $01
FA2D  09 04        ORA #$04
FA2F  85 01        STA $01
FA31  A9 A7        LDA #$a7
FA33  85 39        STA $39
FA35  60           RTS
FA36  A5 2B        LDA $2b
FA38  09 10        ORA #$10
FA3A  85 2B        STA $2b
FA3C  A9 FF        LDA #$ff
FA3E  85 39        STA $39
FA40  60           RTS
FA41  A5 01        LDA $01
FA43  29 10        AND #$10
FA45  C5 24        CMP $24
FA47  85 24        STA $24
FA49  D0 06        BNE $fa51
FA4B  A5 FE        LDA $fe
FA4D  D0 12        BNE $fa61
FA4F  F0 20        BEQ $fa71
FA51  A9 FF        LDA #$ff
FA53  85 FE        STA $fe
FA55  A5 01        LDA $01
FA57  09 04        ORA #$04
FA59  85 01        STA $01
FA5B  A9 01        LDA #$01
FA5D  85 22        STA $22
FA5F  D0 10        BNE $fa71
FA61  C6 FE        DEC $fe
FA63  D0 0C        BNE $fa71
FA65  A5 2B        LDA $2b
FA67  C9 00        CMP #$00
FA69  D0 06        BNE $fa71
FA6B  A5 01        LDA $01
FA6D  29 FB        AND #$fb
FA6F  85 01        STA $01
FA71  A5 54        LDA $54
FA73  F0 13        BEQ $fa88
FA75  C9 02        CMP #$02
FA77  D0 06        BNE $fa7f
FA79  A9 00        LDA #$00
FA7B  85 54        STA $54
FA7D  F0 09        BEQ $fa88
FA7F  85 3B        STA $3b
FA81  A9 02        LDA #$02
FA83  85 54        STA $54
FA85  4C C5 FA     JMP $fac5
FA88  A6 31        LDX $31
FA8A  30 07        BMI $fa93
FA8C  A5 2B        LDA $2b
FA8E  A8           TAY
FA8F  C9 20        CMP #$20
FA91  D0 03        BNE $fa96
FA93  4C 00 FB     JMP $fb00
FA96  C6 39        DEC $39
FA98  D0 1B        BNE $fab5
FA9A  98           TYA
FA9B  10 04        BPL $faa1
FA9D  29 7F        AND #$7f
FA9F  85 2B        STA $2b
FAA1  29 10        AND #$10
FAA3  F0 10        BEQ $fab5
FAA5  A5 01        LDA $01
FAA7  29 FB        AND #$fb
FAA9  85 01        STA $01
FAAB  A9 FF        LDA #$ff
FAAD  85 31        STA $31
FAAF  A9 00        LDA #$00
FAB1  85 2B        STA $2b
FAB3  F0 DE        BEQ $fa93
FAB5  98           TYA
FAB6  29 40        AND #$40
FAB8  D0 03        BNE $fabd
FABA  4C 00 FB     JMP $fb00
FABD  A5 4D        LDA $4d
FABF  D0 1B        BNE $fadc
FAC1  A5 3B        LDA $3b
FAC3  F0 0E        BEQ $fad3
FAC5  A5 3B        LDA $3b
FAC7  10 24        BPL $faed
FAC9  E6 3B        INC $3b
FACB  A5 01        LDA $01
FACD  38           SEC
FACE  E9 01        SBC #$01
FAD0  4C F4 FA     JMP $faf4
FAD3  A9 02        LDA #$02
FAD5  85 39        STA $39
FAD7  85 4D        STA $4d
FAD9  4C 00 FB     JMP $fb00
FADC  C6 39        DEC $39
FADE  D0 20        BNE $fb00
FAE0  A5 2B        LDA $2b
FAE2  29 BF        AND #$bf
FAE4  85 2B        STA $2b
FAE6  A9 00        LDA #$00
FAE8  85 4D        STA $4d
FAEA  4C 00 FB     JMP $fb00
FAED  C6 3B        DEC $3b
FAEF  A5 01        LDA $01
FAF1  18           CLC
FAF2  69 01        ADC #$01
FAF4  29 03        AND #$03
FAF6  85 3C        STA $3c
FAF8  A5 01        LDA $01
FAFA  29 FC        AND #$fc
FAFC  05 3C        ORA $3c
FAFE  85 01        STA $01
FB00  68           PLA
FB01  A8           TAY
FB02  68           PLA
FB03  AA           TAX
FB04  68           PLA
FB05  40           RTI
FB06  A9 05        LDA #$05
FB08  8D 00 01     STA $0100
FB0B  A2 1C        LDX #$1c
FB0D  20 87 FD     JSR $fd87
FB10  A2 14        LDX #$14
FB12  A0 00        LDY #$00
FB14  A9 FF        LDA #$ff
FB16  8D 01 40     STA $4001
FB19  24 01        BIT $01
FB1B  10 FC        BPL $fb19
FB1D  2C 00 40     BIT $4000
FB20  88           DEY
FB21  D0 F6        BNE $fb19
FB23  CA           DEX
FB24  D0 F3        BNE $fb19
FB26  20 79 FD     JSR $fd79
FB29  A0 FF        LDY #$ff
FB2B  A2 FF        LDX #$ff
FB2D  AD 02 40     LDA $4002
FB30  29 40        AND #$40
FB32  F0 10        BEQ $fb44
FB34  CA           DEX
FB35  D0 F6        BNE $fb2d
FB37  88           DEY
FB38  D0 F1        BNE $fb2b
FB3A  CE 00 01     DEC $0100
FB3D  D0 CC        BNE $fb0b
FB3F  A9 02        LDA #$02
FB41  4C 6F FD     JMP $fd6f
FB44  A0 00        LDY #$00
FB46  A2 00        LDX #$00
FB48  AD 02 40     LDA $4002
FB4B  29 40        AND #$40
FB4D  F0 F9        BEQ $fb48
FB4F  AD 02 40     LDA $4002
FB52  C8           INY
FB53  D0 01        BNE $fb56
FB55  E8           INX
FB56  29 40        AND #$40
FB58  D0 F5        BNE $fb4f
FB5A  8E 02 01     STX $0102
FB5D  8C 01 01     STY $0101
FB60  A9 00        LDA #$00
FB62  85 FF        STA $ff
FB64  A2 08        LDX #$08
FB66  BD 29 F1     LDA $f129,X
FB69  CD 02 01     CMP $0102
FB6C  F0 05        BEQ $fb73
FB6E  CA           DEX
FB6F  10 F5        BPL $fb66
FB71  30 C7        BMI $fb3a
FB73  BD 32 F1     LDA $f132,X
FB76  8D 03 01     STA $0103
FB79  60           RTS
FB7A  A5 40        LDA $40
FB7C  10 1B        BPL $fb99
FB7E  A9 60        LDA #$60
FB80  85 2B        STA $2b
FB82  A9 01        LDA #$01
FB84  85 29        STA $29
FB86  85 40        STA $40
FB88  A9 A4        LDA #$a4
FB8A  85 3B        STA $3b
FB8C  A5 01        LDA $01
FB8E  29 FC        AND #$fc
FB90  85 01        STA $01
FB92  A9 0A        LDA #$0a
FB94  85 51        STA $51
FB96  4C 41 FA     JMP $fa41
FB99  A0 00        LDY #$00
FB9B  B1 20        LDA ($20),Y
FB9D  C5 40        CMP $40
FB9F  F0 07        BEQ $fba8
FBA1  A5 40        LDA $40
FBA3  91 20        STA ($20),Y
FBA5  4C 41 FA     JMP $fa41
FBA8  A5 01        LDA $01
FBAA  29 10        AND #$10
FBAC  D0 05        BNE $fbb3
FBAE  A9 08        LDA #$08
FBB0  4C 68 FD     JMP $fd68
FBB3  A5 FF        LDA $ff
FBB5  10 03        BPL $fbba
FBB7  20 06 FB     JSR $fb06
FBBA  AD 03 01     LDA $0103
FBBD  85 4E        STA $4e
FBBF  18           CLC
FBC0  A9 03        LDA #$03
FBC2  85 21        STA $21
FBC4  A9 00        LDA #$00
FBC6  85 20        STA $20
FBC8  85 53        STA $53
FBCA  A0 00        LDY #$00
FBCC  A9 08        LDA #$08
FBCE  91 20        STA ($20),Y
FBD0  C8           INY
FBD1  A9 00        LDA #$00
FBD3  91 20        STA ($20),Y
FBD5  C8           INY
FBD6  A5 53        LDA $53
FBD8  91 20        STA ($20),Y
FBDA  C8           INY
FBDB  A5 40        LDA $40
FBDD  91 20        STA ($20),Y
FBDF  C8           INY
FBE0  A5 15        LDA $15
FBE2  91 20        STA ($20),Y
FBE4  C8           INY
FBE5  A5 14        LDA $14
FBE7  91 20        STA ($20),Y
FBE9  C8           INY
FBEA  A9 0F        LDA #$0f
FBEC  91 20        STA ($20),Y
FBEE  C8           INY
FBEF  91 20        STA ($20),Y
FBF1  C8           INY
FBF2  98           TYA
FBF3  48           PHA
FBF4  A2 07        LDX #$07
FBF6  A9 00        LDA #$00
FBF8  85 30        STA $30
FBFA  88           DEY
FBFB  B1 20        LDA ($20),Y
FBFD  45 30        EOR $30
FBFF  85 30        STA $30
FC01  CA           DEX
FC02  D0 F6        BNE $fbfa
FC04  91 20        STA ($20),Y
FC06  68           PLA
FC07  A8           TAY
FC08  E6 53        INC $53
FC0A  A5 53        LDA $53
FC0C  C5 57        CMP $57
FC0E  90 BC        BCC $fbcc
FC10  20 A9 FD     JSR $fda9
FC13  A0 BA        LDY #$ba
FC15  B1 20        LDA ($20),Y
FC17  A2 45        LDX #$45
FC19  86 20        STX $20
FC1B  91 20        STA ($20),Y
FC1D  A2 00        LDX #$00
FC1F  86 20        STX $20
FC21  88           DEY
FC22  C0 FF        CPY #$ff
FC24  D0 EF        BNE $fc15
FC26  A0 44        LDY #$44
FC28  B9 1B 01     LDA $011b,Y
FC2B  91 20        STA ($20),Y
FC2D  88           DEY
FC2E  10 F8        BPL $fc28
FC30  18           CLC
FC31  A9 03        LDA #$03
FC33  69 02        ADC #$02
FC35  85 28        STA $28
FC37  A9 00        LDA #$00
FC39  A8           TAY
FC3A  91 27        STA ($27),Y
FC3C  C8           INY
FC3D  D0 FB        BNE $fc3a
FC3F  20 0A F6     JSR $f60a
FC42  20 CF F8     JSR $f8cf
FC45  A9 00        LDA #$00
FC47  85 4F        STA $4f
FC49  A2 03        LDX #$03
FC4B  20 87 FD     JSR $fd87
FC4E  A9 FF        LDA #$ff
FC50  8D 01 40     STA $4001
FC53  A0 05        LDY #$05
FC55  24 01        BIT $01
FC57  10 FC        BPL $fc55
FC59  2C 00 40     BIT $4000
FC5C  88           DEY
FC5D  D0 F6        BNE $fc55
FC5F  A9 0A        LDA #$0a
FC61  85 50        STA $50
FC63  A4 4F        LDY $4f
FC65  24 01        BIT $01
FC67  10 FC        BPL $fc65
FC69  2C 00 40     BIT $4000
FC6C  B1 20        LDA ($20),Y
FC6E  8D 01 40     STA $4001
FC71  C8           INY
FC72  C6 50        DEC $50
FC74  D0 EF        BNE $fc65
FC76  A0 09        LDY #$09
FC78  24 01        BIT $01
FC7A  10 FC        BPL $fc78
FC7C  2C 00 40     BIT $4000
FC7F  A9 55        LDA #$55
FC81  8D 01 40     STA $4001
FC84  88           DEY
FC85  D0 F1        BNE $fc78
FC87  A9 FF        LDA #$ff
FC89  A0 05        LDY #$05
FC8B  24 01        BIT $01
FC8D  10 FC        BPL $fc8b
FC8F  2C 00 40     BIT $4000
FC92  8D 01 40     STA $4001
FC95  88           DEY
FC96  D0 F3        BNE $fc8b
FC98  A0 BB        LDY #$bb
FC9A  24 01        BIT $01
FC9C  10 FC        BPL $fc9a
FC9E  2C 00 40     BIT $4000
FCA1  B9 60 00     LDA $0060,Y
FCA4  8D 01 40     STA $4001
FCA7  C8           INY
FCA8  D0 F0        BNE $fc9a
FCAA  24 01        BIT $01
FCAC  10 FC        BPL $fcaa
FCAE  2C 00 40     BIT $4000
FCB1  B1 27        LDA ($27),Y
FCB3  8D 01 40     STA $4001
FCB6  C8           INY
FCB7  D0 F1        BNE $fcaa
FCB9  A9 55        LDA #$55
FCBB  A4 4E        LDY $4e
FCBD  24 01        BIT $01
FCBF  10 FC        BPL $fcbd
FCC1  2C 00 40     BIT $4000
FCC4  8D 01 40     STA $4001
FCC7  88           DEY
FCC8  D0 F3        BNE $fcbd
FCCA  A5 4F        LDA $4f
FCCC  18           CLC
FCCD  69 0A        ADC #$0a
FCCF  85 4F        STA $4f
FCD1  C6 53        DEC $53
FCD3  F0 03        BEQ $fcd8
FCD5  4C 4E FC     JMP $fc4e
FCD8  24 01        BIT $01
FCDA  10 FC        BPL $fcd8
FCDC  2C 00 40     BIT $4000
FCDF  24 01        BIT $01
FCE1  10 FC        BPL $fcdf
FCE3  2C 00 40     BIT $4000
FCE6  20 79 FD     JSR $fd79
FCE9  A9 C8        LDA #$c8
FCEB  85 52        STA $52
FCED  A9 00        LDA #$00
FCEF  85 4F        STA $4f
FCF1  A5 57        LDA $57
FCF3  85 53        STA $53
FCF5  A9 0A        LDA #$0a
FCF7  85 50        STA $50
FCF9  20 60 F5     JSR $f560
FCFC  A4 4F        LDY $4f
FCFE  B1 20        LDA ($20),Y
FD00  24 01        BIT $01
FD02  10 FC        BPL $fd00
FD04  2C 00 40     BIT $4000
FD07  CD 01 40     CMP $4001
FD0A  D0 0F        BNE $fd1b
FD0C  C8           INY
FD0D  C6 50        DEC $50
FD0F  D0 ED        BNE $fcfe
FD11  18           CLC
FD12  A5 4F        LDA $4f
FD14  69 0A        ADC #$0a
FD16  85 4F        STA $4f
FD18  4C 24 FD     JMP $fd24
FD1B  C6 52        DEC $52
FD1D  D0 CE        BNE $fced
FD1F  A9 06        LDA #$06
FD21  4C 68 FD     JMP $fd68
FD24  20 60 F5     JSR $f560
FD27  A0 BB        LDY #$bb
FD29  B9 60 00     LDA $0060,Y
FD2C  24 01        BIT $01
FD2E  10 FC        BPL $fd2c
FD30  2C 00 40     BIT $4000
FD33  CD 01 40     CMP $4001
FD36  D0 E3        BNE $fd1b
FD38  C8           INY
FD39  D0 EE        BNE $fd29
FD3B  B1 27        LDA ($27),Y
FD3D  24 01        BIT $01
FD3F  10 FC        BPL $fd3d
FD41  2C 00 40     BIT $4000
FD44  CD 01 40     CMP $4001
FD47  D0 D2        BNE $fd1b
FD49  C8           INY
FD4A  D0 EF        BNE $fd3b
FD4C  C6 53        DEC $53
FD4E  D0 A5        BNE $fcf5
FD50  E6 40        INC $40
FD52  A5 40        LDA $40
FD54  C9 24        CMP #$24
FD56  B0 03        BCS $fd5b
FD58  4C 41 FA     JMP $fa41
FD5B  A9 FF        LDA #$ff
FD5D  85 40        STA $40
FD5F  A9 00        LDA #$00
FD61  85 3F        STA $3f
FD63  A9 01        LDA #$01
FD65  4C 12 FA     JMP $fa12
FD68  C6 51        DEC $51
FD6A  F0 03        BEQ $fd6f
FD6C  4C 41 FA     JMP $fa41
FD6F  A0 FF        LDY #$ff
FD71  84 40        STY $40
FD73  C8           INY
FD74  84 3F        STY $3f
FD76  4C 12 FA     JMP $fa12
FD79  AD 02 40     LDA $4002
FD7C  09 10        ORA #$10
FD7E  8D 02 40     STA $4002
FD81  A9 00        LDA #$00
FD83  8D 04 40     STA $4004
FD86  60           RTS
FD87  AD 02 40     LDA $4002
FD8A  29 EF        AND #$ef
FD8C  8D 02 40     STA $4002
FD8F  A9 FF        LDA #$ff
FD91  8D 04 40     STA $4004
FD94  A9 55        LDA #$55
FD96  8D 01 40     STA $4001
FD99  A0 00        LDY #$00
FD9B  24 01        BIT $01
FD9D  10 FC        BPL $fd9b
FD9F  2C 00 40     BIT $4000
FDA2  88           DEY
FDA3  D0 F6        BNE $fd9b
FDA5  CA           DEX
FDA6  D0 F3        BNE $fd9b
FDA8  60           RTS
FDA9  A9 00        LDA #$00
FDAB  85 28        STA $28
FDAD  85 1E        STA $1e
FDAF  85 2E        STA $2e
FDB1  A9 BB        LDA #$bb
FDB3  85 2D        STA $2d
FDB5  A9 60        LDA #$60
FDB7  85 27        STA $27
FDB9  18           CLC
FDBA  A9 03        LDA #$03
FDBC  85 1F        STA $1f
FDBE  A4 2E        LDY $2e
FDC0  B1 1E        LDA ($1e),Y
FDC2  85 41        STA $41
FDC4  C8           INY
FDC5  B1 1E        LDA ($1e),Y
FDC7  85 42        STA $42
FDC9  C8           INY
FDCA  B1 1E        LDA ($1e),Y
FDCC  85 43        STA $43
FDCE  C8           INY
FDCF  B1 1E        LDA ($1e),Y
FDD1  85 44        STA $44
FDD3  C8           INY
FDD4  F0 08        BEQ $fdde
FDD6  84 2E        STY $2e
FDD8  20 0C F8     JSR $f80c
FDDB  4C BE FD     JMP $fdbe
FDDE  4C 0C F8     JMP $f80c
FDE1  81 FF        STA ($ff,X)
FDE3  FF           ???
FDE4  FF           ???
FDE5  FF           ???
FDE6  FF           ???
FDE7  FF           ???
FDE8  FF           ???
FDE9  FF           ???
FDEA  FF           ???
FDEB  FF           ???
FDEC  FF           ???
FDED  FF           ???
FDEE  FF           ???
FDEF  FF           ???
FDF0  FF           ???
FDF1  FF           ???
FDF2  FF           ???
FDF3  FF           ???
FDF4  FF           ???
FDF5  FF           ???
FDF6  FF           ???
FDF7  FF           ???
FDF8  FF           ???
FDF9  FF           ???
FDFA  FF           ???
FDFB  FF           ???
FDFC  FF           ???
FDFD  FF           ???
FDFE  FF           ???
FDFF  FF           ???
FE00  FF           ???
FE01  FF           ???
FE02  FF           ???
FE03  FF           ???
FE04  FF           ???
FE05  FF           ???
FE06  FF           ???
FE07  FF           ???
FE08  FF           ???
FE09  FF           ???
FE0A  FF           ???
FE0B  FF           ???
FE0C  FF           ???
FE0D  FF           ???
FE0E  FF           ???
FE0F  FF           ???
FE10  FF           ???
FE11  FF           ???
FE12  FF           ???
FE13  FF           ???
FE14  FF           ???
FE15  FF           ???
FE16  FF           ???
FE17  FF           ???
FE18  FF           ???
FE19  FF           ???
FE1A  FF           ???
FE1B  FF           ???
FE1C  FF           ???
FE1D  FF           ???
FE1E  FF           ???
FE1F  FF           ???
FE20  FF           ???
FE21  FF           ???
FE22  FF           ???
FE23  FF           ???
FE24  FF           ???
FE25  FF           ???
FE26  FF           ???
FE27  FF           ???
FE28  FF           ???
FE29  FF           ???
FE2A  FF           ???
FE2B  FF           ???
FE2C  FF           ???
FE2D  FF           ???
FE2E  FF           ???
FE2F  FF           ???
FE30  FF           ???
FE31  FF           ???
FE32  FF           ???
FE33  FF           ???
FE34  FF           ???
FE35  FF           ???
FE36  FF           ???
FE37  FF           ???
FE38  FF           ???
FE39  FF           ???
FE3A  FF           ???
FE3B  FF           ???
FE3C  FF           ???
FE3D  FF           ???
FE3E  FF           ???
FE3F  FF           ???
FE40  FF           ???
FE41  FF           ???
FE42  FF           ???
FE43  FF           ???
FE44  FF           ???
FE45  FF           ???
FE46  FF           ???
FE47  FF           ???
FE48  FF           ???
FE49  FF           ???
FE4A  FF           ???
FE4B  FF           ???
FE4C  FF           ???
FE4D  FF           ???
FE4E  FF           ???
FE4F  FF           ???
FE50  FF           ???
FE51  FF           ???
FE52  FF           ???
FE53  FF           ???
FE54  FF           ???
FE55  FF           ???
FE56  FF           ???
FE57  FF           ???
FE58  FF           ???
FE59  FF           ???
FE5A  FF           ???
FE5B  FF           ???
FE5C  FF           ???
FE5D  FF           ???
FE5E  FF           ???
FE5F  FF           ???
FE60  FF           ???
FE61  FF           ???
FE62  FF           ???
FE63  FF           ???
FE64  FF           ???
FE65  FF           ???
FE66  FF           ???
FE67  FF           ???
FE68  FF           ???
FE69  FF           ???
FE6A  FF           ???
FE6B  FF           ???
FE6C  FF           ???
FE6D  FF           ???
FE6E  FF           ???
FE6F  FF           ???
FE70  FF           ???
FE71  FF           ???
FE72  FF           ???
FE73  FF           ???
FE74  FF           ???
FE75  FF           ???
FE76  FF           ???
FE77  FF           ???
FE78  FF           ???
FE79  FF           ???
FE7A  FF           ???
FE7B  FF           ???
FE7C  FF           ???
FE7D  FF           ???
FE7E  FF           ???
FE7F  FF           ???
FE80  FF           ???
FE81  FF           ???
FE82  FF           ???
FE83  FF           ???
FE84  FF           ???
FE85  FF           ???
FE86  FF           ???
FE87  FF           ???
FE88  FF           ???
FE89  FF           ???
FE8A  FF           ???
FE8B  FF           ???
FE8C  FF           ???
FE8D  FF           ???
FE8E  FF           ???
FE8F  FF           ???
FE90  FF           ???
FE91  FF           ???
FE92  FF           ???
FE93  FF           ???
FE94  FF           ???
FE95  FF           ???
FE96  FF           ???
FE97  FF           ???
FE98  FF           ???
FE99  FF           ???
FE9A  FF           ???
FE9B  FF           ???
FE9C  FF           ???
FE9D  FF           ???
FE9E  FF           ???
FE9F  FF           ???
FEA0  FF           ???
FEA1  FF           ???
FEA2  FF           ???
FEA3  FF           ???
FEA4  FF           ???
FEA5  FF           ???
FEA6  FF           ???
FEA7  FF           ???
FEA8  FF           ???
FEA9  FF           ???
FEAA  FF           ???
FEAB  FF           ???
FEAC  FF           ???
FEAD  FF           ???
FEAE  FF           ???
FEAF  FF           ???
FEB0  FF           ???
FEB1  FF           ???
FEB2  FF           ???
FEB3  FF           ???
FEB4  FF           ???
FEB5  FF           ???
FEB6  FF           ???
FEB7  FF           ???
FEB8  FF           ???
FEB9  FF           ???
FEBA  FF           ???
FEBB  FF           ???
FEBC  FF           ???
FEBD  FF           ???
FEBE  FF           ???
FEBF  FF           ???
FEC0  FF           ???
FEC1  FF           ???
FEC2  FF           ???
FEC3  FF           ???
FEC4  FF           ???
FEC5  FF           ???
FEC6  FF           ???
FEC7  FF           ???
FEC8  FF           ???
FEC9  FF           ???
FECA  FF           ???
FECB  FF           ???
FECC  FF           ???
FECD  FF           ???
FECE  FF           ???
FECF  FF           ???
FED0  FF           ???
FED1  FF           ???
FED2  FF           ???
FED3  FF           ???
FED4  FF           ???
FED5  FF           ???
FED6  FF           ???
FED7  FF           ???
FED8  FF           ???
FED9  FF           ???
FEDA  FF           ???
FEDB  FF           ???
FEDC  FF           ???
FEDD  FF           ???
FEDE  FF           ???
FEDF  FF           ???
FEE0  FF           ???
FEE1  FF           ???
FEE2  FF           ???
FEE3  FF           ???
FEE4  FF           ???
FEE5  FF           ???
FEE6  FF           ???
FEE7  FF           ???
FEE8  FF           ???
FEE9  FF           ???
FEEA  FF           ???
FEEB  FF           ???
FEEC  FF           ???
FEED  FF           ???
FEEE  FF           ???
FEEF  FF           ???
FEF0  FF           ???
FEF1  FF           ???
FEF2  FF           ???
FEF3  FF           ???
FEF4  FF           ???
FEF5  FF           ???
FEF6  FF           ???
FEF7  FF           ???
FEF8  FF           ???
FEF9  FF           ???
FEFA  FF           ???
FEFB  FF           ???
FEFC  FF           ???
FEFD  FF           ???
FEFE  FF           ???
FEFF  FF           ???
FF00  FF           ???
FF01  FF           ???
FF02  FF           ???
FF03  FF           ???
FF04  FF           ???
FF05  FF           ???
FF06  FF           ???
FF07  FF           ???
FF08  FF           ???
FF09  FF           ???
FF0A  FF           ???
FF0B  FF           ???
FF0C  FF           ???
FF0D  FF           ???
FF0E  FF           ???
FF0F  FF           ???
FF10  FF           ???
FF11  FF           ???
FF12  FF           ???
FF13  FF           ???
FF14  FF           ???
FF15  FF           ???
FF16  FF           ???
FF17  FF           ???
FF18  FF           ???
FF19  FF           ???
FF1A  FF           ???
FF1B  FF           ???
FF1C  FF           ???
FF1D  FF           ???
FF1E  FF           ???
FF1F  FF           ???
FF20  FF           ???
FF21  FF           ???
FF22  FF           ???
FF23  FF           ???
FF24  FF           ???
FF25  FF           ???
FF26  FF           ???
FF27  FF           ???
FF28  FF           ???
FF29  FF           ???
FF2A  FF           ???
FF2B  FF           ???
FF2C  FF           ???
FF2D  FF           ???
FF2E  FF           ???
FF2F  FF           ???
FF30  FF           ???
FF31  FF           ???
FF32  FF           ???
FF33  FF           ???
FF34  FF           ???
FF35  FF           ???
FF36  FF           ???
FF37  FF           ???
FF38  FF           ???
FF39  FF           ???
FF3A  FF           ???
FF3B  FF           ???
FF3C  FF           ???
FF3D  FF           ???
FF3E  FF           ???
FF3F  FF           ???
FF40  FF           ???
FF41  FF           ???
FF42  FF           ???
FF43  FF           ???
FF44  FF           ???
FF45  FF           ???
FF46  FF           ???
FF47  FF           ???
FF48  FF           ???
FF49  FF           ???
FF4A  FF           ???
FF4B  FF           ???
FF4C  FF           ???
FF4D  FF           ???
FF4E  FF           ???
FF4F  FF           ???
FF50  FF           ???
FF51  FF           ???
FF52  FF           ???
FF53  FF           ???
FF54  FF           ???
FF55  FF           ???
FF56  FF           ???
FF57  FF           ???
FF58  FF           ???
FF59  FF           ???
FF5A  FF           ???
FF5B  FF           ???
FF5C  FF           ???
FF5D  FF           ???
FF5E  FF           ???
FF5F  FF           ???
FF60  FF           ???
FF61  FF           ???
FF62  FF           ???
FF63  FF           ???
FF64  FF           ???
FF65  FF           ???
FF66  FF           ???
FF67  FF           ???
FF68  FF           ???
FF69  FF           ???
FF6A  FF           ???
FF6B  FF           ???
FF6C  FF           ???
FF6D  FF           ???
FF6E  FF           ???
FF6F  FF           ???
FF70  FF           ???
FF71  FF           ???
FF72  FF           ???
FF73  FF           ???
FF74  FF           ???
FF75  FF           ???
FF76  FF           ???
FF77  FF           ???
FF78  FF           ???
FF79  FF           ???
FF7A  FF           ???
FF7B  FF           ???
FF7C  FF           ???
FF7D  FF           ???
FF7E  FF           ???
FF7F  FF           ???
FF80  FF           ???
FF81  FF           ???
FF82  FF           ???
FF83  FF           ???
FF84  FF           ???
FF85  FF           ???
FF86  FF           ???
FF87  FF           ???
FF88  FF           ???
FF89  FF           ???
FF8A  FF           ???
FF8B  FF           ???
FF8C  FF           ???
FF8D  FF           ???
FF8E  FF           ???
FF8F  FF           ???
FF90  FF           ???
FF91  FF           ???
FF92  FF           ???
FF93  FF           ???
FF94  FF           ???
FF95  FF           ???
FF96  FF           ???
FF97  FF           ???
FF98  FF           ???
FF99  FF           ???
FF9A  FF           ???
FF9B  FF           ???
FF9C  FF           ???
FF9D  FF           ???
FF9E  FF           ???
FF9F  FF           ???
FFA0  FF           ???
FFA1  FF           ???
FFA2  FF           ???
FFA3  FF           ???
FFA4  FF           ???
FFA5  FF           ???
FFA6  FF           ???
FFA7  FF           ???
FFA8  FF           ???
FFA9  FF           ???
FFAA  FF           ???
FFAB  FF           ???
FFAC  FF           ???
FFAD  FF           ???
FFAE  FF           ???
FFAF  FF           ???
FFB0  FF           ???
FFB1  FF           ???
FFB2  FF           ???
FFB3  FF           ???
FFB4  FF           ???
FFB5  FF           ???
FFB6  FF           ???
FFB7  FF           ???
FFB8  FF           ???
FFB9  FF           ???
FFBA  FF           ???
FFBB  FF           ???
FFBC  FF           ???
FFBD  FF           ???
FFBE  FF           ???
FFBF  FF           ???
FFC0  FF           ???
FFC1  FF           ???
FFC2  FF           ???
FFC3  FF           ???
FFC4  FF           ???
FFC5  FF           ???
FFC6  FF           ???
FFC7  FF           ???
FFC8  FF           ???
FFC9  FF           ???
FFCA  FF           ???
FFCB  FF           ???
FFCC  FF           ???
FFCD  FF           ???
FFCE  FF           ???
FFCF  FF           ???
FFD0  FF           ???
FFD1  FF           ???
FFD2  FF           ???
FFD3  FF           ???
FFD4  FF           ???
FFD5  FF           ???
FFD6  FF           ???
FFD7  FF           ???
FFD8  FF           ???
FFD9  FF           ???
FFDA  FF           ???
FFDB  FF           ???
FFDC  FF           ???
FFDD  FF           ???
FFDE  FF           ???
FFDF  FF           ???
FFE0  FF           ???
FFE1  FF           ???
FFE2  FF           ???
FFE3  FF           ???
FFE4  FF           ???
FFE5  FF           ???
FFE6  A7           ???
FFE7  C9 3B        CMP #$3b
FFE9  F1 51        SBC ($51),Y
FFEB  CE 8B CE     DEC $ce8b
FFEE  00           BRK
FFEF  05 03        ORA $03
FFF1  05 06        ORA $06
FFF3  05 09        ORA $09
FFF5  05 0C        ORA $0c
FFF7  05 0F        ORA $0f
FFF9  05 39        ORA $39
FFFB  EA           NOP
FFFC  B5 E9        LDA $e9,X
FFFE  95 F1        STA $f1,X
