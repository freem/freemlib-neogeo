; Character definitions (for use with MESS_OUT) (UTF-8 encoding for proper view)
;==============================================================================;
; todo: add the kanji (Command 8)

; [Symbols/Other]
SYMB_LEFT  = $10 ; ◀ Left arrow
SYMB_RIGHT = $11 ; ▶ Right arrow
SYMB_UP    = $12 ; ▲ Up arrow
SYMB_DOWN  = $13 ; ▼ Down arrow
;-------;
SYMB_01 = $5F ; 00 1/2 (see NAM-1975 soft dips)
SYMB_02 = $60 ; 00 2/2 (see NAM-1975 soft dips)
;-------;
SYMB_COPYRIGHT = $7B ; © Copyright symbol
;-------;
SYMB_KH = $BA ; 「 opening quote mark
SYMB_KT = $BB ; 」 closing quote mark
;-------;
SYMB_TEN  = $FA ; 、 Japanese comma
SYMB_MARU = $FB ; 。 Japanese period

; [Hiragana]
HIRA_A = $80 ; あ
HIRA_I = $81 ; い
HIRA_U = $82 ; う
HIRA_E = $83 ; え
HIRA_O = $84 ; お
;-------;
HIRA_KA = $85 ; か
HIRA_KI = $86 ; き
HIRA_KU = $87 ; く
HIRA_KE = $88 ; け
HIRA_KO = $89 ; こ
;-------;
HIRA_SA  = $8A ; さ
HIRA_SHI = $8B ; し
HIRA_SU  = $8C ; す
HIRA_SE  = $8D ; せ
HIRA_SO  = $8E ; そ
;-------;
HIRA_TA  = $8F ; た
HIRA_CHI = $90 ; ち
HIRA_TSU = $91 ; つ
HIRA_TE  = $92 ; て
HIRA_TO  = $93 ; と
;-------;
HIRA_NA  = $94 ; な
HIRA_NI  = $95 ; に
HIRA_NU  = $96 ; ぬ
HIRA_NE  = $97 ; ね
HIRA_NO  = $98 ; の
;-------;
HIRA_HA  = $99 ; は
HIRA_HI  = $9A ; ひ
HIRA_FU  = $9B ; ふ
HIRA_HE  = $9C ; へ
HIRA_HO  = $9D ; ほ
;-------;
HIRA_MA  = $9E ; ま
HIRA_MI  = $9F ; み
HIRA_MU  = $A0 ; む
HIRA_ME  = $A1 ; め
HIRA_MO  = $A2 ; も
;-------;
HIRA_YA  = $A3 ; や
HIRA_YU  = $A4 ; ゆ
HIRA_YO  = $A5 ; よ
;-------;
HIRA_RA  = $A6 ; ら
HIRA_RI  = $A7 ; り
HIRA_RU  = $A8 ; る
HIRA_RE  = $A9 ; れ
HIRA_RO  = $AA ; ろ
;-------;
HIRA_WA  = $AB ; わ
HIRA_WO  = $AC ; を
HIRA_N   = $AD ; ん
;-------;
HIRA_a  = $AE ; ぁ
HIRA_i  = $AF ; ぃ
HIRA_u  = $B0 ; ぅ
HIRA_e  = $B1 ; ぇ
HIRA_o  = $B2 ; ぉ
;-------;
HIRA_ya  = $B3 ; ゃ
HIRA_yu  = $B4 ; ゅ
HIRA_yo  = $B5 ; ょ
HIRA_tsu = $B6 ; っ
;-------;
HIRA_DAKU = $B7 ; ゛
HIRA_HAN  = $B8 ; ゜
HIRA_CHOU = $B9 ; ー
;-------;
HIRA_GA  = $00 ; が
HIRA_GI  = $01 ; ぎ
HIRA_GU  = $02 ; ぐ
HIRA_GE  = $03 ; げ
HIRA_GO  = $04 ; ご
;-------;
HIRA_ZA  = $05 ; ざ
HIRA_JI  = $06 ; じ
HIRA_ZU  = $07 ; ず
HIRA_ZE  = $08 ; ぜ
HIRA_ZO  = $09 ; ぞ
;-------;
HIRA_DA  = $0A ; だ
HIRA_DI  = $0B ; ぢ
HIRA_DU  = $0C ; づ
HIRA_DE  = $0D ; で
HIRA_DO  = $0E ; ど
;-------;
HIRA_BA  = $0F ; ば
HIRA_BI  = $10 ; び
HIRA_BU  = $11 ; ぶ
HIRA_BE  = $12 ; べ
HIRA_BO  = $13 ; ぼ
;-------;
HIRA_PA  = $14 ; ぱ
HIRA_PI  = $15 ; ぴ
HIRA_PU  = $16 ; ぷ
HIRA_PE  = $17 ; ぺ
HIRA_PO  = $18 ; ぽ

; [Katakana]
KANA_A  = $C0 ; ア
KANA_I  = $C1 ; イ
KANA_U  = $C2 ; ウ
KANA_E  = $C3 ; エ
KANA_O  = $C4 ; オ
;-------;
KANA_KA  = $C5 ; カ
KANA_KI  = $C6 ; キ
KANA_KU  = $C7 ; ク
KANA_KE  = $C8 ; ケ
KANA_KO  = $C9 ; コ
;-------;
KANA_SA  = $CA ; サ
KANA_SHI = $CB ; シ
KANA_SU  = $CC ; ス
KANA_SE  = $CD ; セ
KANA_SO  = $CE ; ソ
;-------;
KANA_TA  = $CF ; タ
KANA_CHI = $D0 ; チ
KANA_TSU = $D1 ; ツ
KANA_TE  = $D2 ; テ
KANA_TO  = $D3 ; ト
;-------;
KANA_NA  = $D4 ; ナ
KANA_NI  = $D5 ; ニ
KANA_NU  = $D6 ; ヌ
KANA_NE  = $D7 ; ネ
KANA_NO  = $D8 ; ノ
;-------;
KANA_HA  = $D9 ; ハ
KANA_HI  = $DA ; ヒ
KANA_FU  = $DB ; フ
KANA_HE  = $DC ; ヘ
KANA_HO  = $DD ; ホ
;-------;
KANA_MA  = $DE ; マ
KANA_MI  = $DF ; ミ
KANA_MU  = $E0 ; ム
KANA_ME  = $E1 ; メ
KANA_MO  = $E2 ; モ
;-------;
KANA_YA  = $E3 ; ヤ
KANA_YU  = $E4 ; ユ
KANA_YO  = $E5 ; ヨ
;-------;
KANA_RA  = $E6 ; ラ
KANA_RI  = $E7 ; リ
KANA_RU  = $E8 ; ル
KANA_RE  = $E9 ; レ
KANA_RO  = $EA ; ロ
;-------;
KANA_WA  = $EB ; ワ
KANA_WO  = $EC ; ヲ
KANA_N  = $ED ; ン
;-------;
KANA_a  = $EE ; ァ
KANA_i  = $EF ; ィ
KANA_u  = $F0 ; ゥ
KANA_e  = $F1 ; ェ
KANA_o  = $F2 ; ォ
;-------;
KANA_ya  = $F3 ; ャ
KANA_yu  = $F4 ; ュ
KANA_yo  = $F5 ; ョ
KANA_tsu = $F6 ; ッ
;-------;
KANA_DAKU = $F7 ; ゛
KANA_HAN  = $F8 ; ゜
KANA_CHOU = $F9 ; ー
;-------;
KANA_GA  = $60 ; ガ
KANA_GI  = $61 ; ギ
KANA_GU  = $62 ; グ
KANA_GE  = $63 ; ゲ
KANA_GO  = $64 ; ゴ
;-------;
KANA_ZA  = $65 ; ザ
KANA_JI  = $66 ; ジ
KANA_ZU  = $67 ; ズ
KANA_ZE  = $68 ; ゼ
KANA_ZO  = $69 ; ゾ
;-------;
KANA_DA  = $6A ; ダ
KANA_DI  = $6B ; ヂ
KANA_DU  = $6C ; ヅ
KANA_DE  = $6D ; デ
KANA_DO  = $6E ; ド
;-------;
KANA_BA  = $6F ; バ
KANA_BI  = $70 ; ビ
KANA_BU  = $71 ; ブ
KANA_BE  = $72 ; ベ
KANA_BO  = $73 ; ボ
;-------;
KANA_PA  = $74 ; パ
KANA_PI  = $75 ; ピ
KANA_PU  = $76 ; プ
KANA_PE  = $77 ; ペ
KANA_PO  = $78 ; ポ

; [Kanji]
; 難易度時間分秒有
; 無設定持機数
; 遊び
; 方説
; 明

; 難 (Nan/"Difficulty")
;KANJI_NAN_1 = $00 ; 難 1/2
;KANJI_NAN_2 = $01 ; 難 2/2
;--------;
; 易 (Eki/"Easy")
;KANJI_EKI_1 = $02 ; 易 1/2
;KANJI_EKI_2 = $03 ; 易 2/2
;--------;
; 度 (Do/"Degree")
;KANJI_DO_1 = $04 ; 度 1/2
;KANJI_DO_2 = $05 ; 度 2/2
;--------;
; 時 (Toki/"Time")
;KANJI_TOKI_1 = $06 ; 時 1/2
;KANJI_TOKI_2 = $07 ; 時 2/2
;--------;
; 間 (kan?)
;KANJI_KAN_1 = $08 ; 間 1/2
;KANJI_KAN_2 = $09 ; 間 2/2
;--------;
; 分 (bun/"Minute")
;KANJI_BUN_1 = $0A ; 分 1/2
;KANJI_BUN_2 = $0B ; 分 2/2
;--------;
; 秒 (byō/"Second")
;KANJI_BYO_1 = $0C ; 秒 1/2
;KANJI_BYO_2 = $0D ; 秒 2/2
;--------;
; 有 (yū/"Yes")
;KANJI_YU_1 = $0E ; 有 1/2
;KANJI_YU_2 = $0F ; 有 2/2
;--------;
; 無 (mu/"Nothing","No")
;KANJI_MU_1 = $14 ; 無 1/2
;KANJI_MU_2 = $15 ; 無 2/2
;--------;
; 設 (?/"Setting")
;KANJI_x_1 = $16 ; 設 1/2
;KANJI_x_2 = $17 ; 設 2/2
;--------;
; 定 (Jō/"Constant")
;KANJI_x_1 = $18 ; 定 1/2
;KANJI_x_2 = $19 ; 定 2/2
;--------;
; 持? (Ji)
;KANJI_x_1 = $1A
;KANJI_x_2 = $1B
;--------;
; 機 (Ki/"Machine"?)
;KANJI_x_1 = $1C
;KANJI_x_2 = $1D
;--------;
; 数 (Kazu/"Number")
;KANJI_KAZU_1 = $1E
;KANJI_KAZU_2 = $1F
;--------;
; 遊? (Yū)
;KANJI_x_1 = $7C
;KANJI_x_2 = $7D
;--------;
; び, but not really??
;KANJI_x_1 = $7E
;KANJI_x_2 = $7F
;--------;
; 方 (Hō/"Person")
;KANJI_x_1 =
;KANJI_x_2 =
;--------;
; 説 (Setsu?)
;KANJI_x_1 =
;KANJI_x_2 =
;--------;
; 明 (Akira?)
;KANJI_x_1 =
;KANJI_x_2 =
