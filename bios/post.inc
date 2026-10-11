; ---------------- makra ----------------
; test ZP/stosu bez użycia stosu i ZP-zmiennych: tylko A, X
.macro ZPPASS K
        .local w0, w1, v0, v1, bad, good
        ldx #2
w0:     txa
        eor #K
        sta $00,x
        inx
        bne w0
        ldx #0
w1:     txa
        eor #(K ^ $5A)
        sta $0100,x
        inx
        bne w1
        ldx #2
v0:     txa
        eor #K
        cmp $00,x
        bne bad
        inx
        bne v0
        ldx #0
v1:     txa
        eor #(K ^ $5A)
        cmp $0100,x
        bne bad
        inx
        bne v1
        jmp good
bad:    jmp ZpFail
good:
.endmacro

; test zakresu stron: A = pierwsza strona, X = strona końcowa (wył., mod 256)
; wyjście: A = 0 OK / 1 błąd (post_page = strona). Kod niezależny od położenia.
.macro TESTRANGE_BODY
        .local pass, phase, page, byte, wr, nxt, k1, k2, kd, fail, done
        sta tr_pm
        stx tr_xm
        lda #0
        sta tr_k
pass:   lda #0
        sta tr_ph
phase:  lda tr_pm
        sta ptr+1
        lda #0
        sta ptr
page:   lda tr_k
        beq k1                  ; przebieg 0: K = 0 (A = 0)
        cmp #1
        bne k2
        lda #$FF                ; przebieg 1: K = $FF
        bne kd
k2:     lda ptr+1               ; przebieg 2: K = numer strony
        bne kd
        lda #$00
kd:     sta tmp
k1:     sta tmp                 ; (przebieg 0: A = 0)
        ldy #0
byte:   tya
        eor tmp
        ldx tr_ph
        bne wr
        sta (ptr),y             ; faza zapisu
        clc
        bcc nxt
wr:     cmp (ptr),y             ; faza odczytu
        bne fail
nxt:    iny
        bne byte
        inc ptr+1
        lda ptr+1
        cmp tr_xm
        bne page
        inc tr_ph
        lda tr_ph
        cmp #2
        bcc phase
        inc tr_k
        lda tr_k
        cmp #3
        bcc pass
        lda #0
        beq done
fail:   lda ptr+1
        sta post_page
        lda #1
done:
.endmacro

.macro PRT lbl
        lda #<lbl
        ldy #>lbl
        jsr PrtAY
.endmacro

.macro ROW lbl
        lda #<lbl
        ldy #>lbl
        jsr RowAY
.endmacro

