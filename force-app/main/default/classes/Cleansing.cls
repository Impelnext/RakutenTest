public class Cleansing {
    /**
		* 数字変換マップの定義
	*/
    public static Map<String, String> NOBLANK_MAP = new Map<String, String>();
    public static Map<String, String> NUMBER_MAP = new Map<String, String>();
    public static Map<String, String> KANA_MAP = new Map<String, String>();
        
        public Cleansing() {
            // 半角数字 → 変換なし
            NOBLANK_MAP.put(' ', '');
            NOBLANK_MAP.put('　', '');

            // 半角数字 → 変換なし
            NUMBER_MAP.put('0', '0');
            NUMBER_MAP.put('1', '1');
            NUMBER_MAP.put('2', '2');
            NUMBER_MAP.put('3', '3');
            NUMBER_MAP.put('4', '4');
            NUMBER_MAP.put('5', '5');
            NUMBER_MAP.put('6', '6');
            NUMBER_MAP.put('7', '7');
            NUMBER_MAP.put('8', '8');
            NUMBER_MAP.put('9', '9');
            
            // 全角数字 → 半角数字に変換
            NUMBER_MAP.put('０', '0');
            NUMBER_MAP.put('１', '1');
            NUMBER_MAP.put('２', '2');
            NUMBER_MAP.put('３', '3');
            NUMBER_MAP.put('４', '4');
            NUMBER_MAP.put('５', '5');
            NUMBER_MAP.put('６', '6');
            NUMBER_MAP.put('７', '7');
            NUMBER_MAP.put('８', '8');
            NUMBER_MAP.put('９', '9');
            
            NUMBER_MAP.put('/', ''); // Remove '/'
            NUMBER_MAP.put('-', ''); // Remove '-'
            NUMBER_MAP.put('(', ''); // Remove '('
            NUMBER_MAP.put(')', ''); // Remove ')'
            
            /**
				* カナ変換マップの定義
			*/
            KANA_MAP.put('ア', 'ア');
            KANA_MAP.put('イ', 'イ');
            KANA_MAP.put('ウ', 'ウ');
            KANA_MAP.put('エ', 'エ');
            KANA_MAP.put('オ', 'オ');
            KANA_MAP.put('カ', 'カ');
            KANA_MAP.put('キ', 'キ');
            KANA_MAP.put('ク', 'ク');
            KANA_MAP.put('ケ', 'ケ');
            KANA_MAP.put('コ', 'コ');
            KANA_MAP.put('サ', 'サ');
            KANA_MAP.put('シ', 'シ');
            KANA_MAP.put('ス', 'ス');
            KANA_MAP.put('セ', 'セ');
            KANA_MAP.put('ソ', 'ソ');
            KANA_MAP.put('タ', 'タ');
            KANA_MAP.put('チ', 'チ');
            KANA_MAP.put('ツ', 'ツ');
            KANA_MAP.put('テ', 'テ');
            KANA_MAP.put('ト', 'ト');
            KANA_MAP.put('ナ', 'ナ');
            KANA_MAP.put('ニ', 'ニ');
            KANA_MAP.put('ヌ', 'ヌ');
            KANA_MAP.put('ネ', 'ネ');
            KANA_MAP.put('ノ', 'ノ');
            KANA_MAP.put('ハ', 'ハ');
            KANA_MAP.put('ヒ', 'ヒ');
            KANA_MAP.put('フ', 'フ');
            KANA_MAP.put('ヘ', 'ヘ');
            KANA_MAP.put('ホ', 'ホ');
            KANA_MAP.put('マ', 'マ');
            KANA_MAP.put('ミ', 'ミ');
            KANA_MAP.put('ム', 'ム');
            KANA_MAP.put('メ', 'メ');
            KANA_MAP.put('モ', 'モ');
            KANA_MAP.put('ヤ', 'ヤ');
            KANA_MAP.put('ユ', 'ユ');
            KANA_MAP.put('ヨ', 'ヨ');
            KANA_MAP.put('ラ', 'ラ');
            KANA_MAP.put('リ', 'リ');
            KANA_MAP.put('ル', 'ル');
            KANA_MAP.put('レ', 'レ');
            KANA_MAP.put('ロ', 'ロ');
            KANA_MAP.put('ワ', 'ワ');
            KANA_MAP.put('ヲ', 'ヲ');
            KANA_MAP.put('ン', 'ン');
            
            // 半角カタカナ（正音）→ 全角カタカナに変換
            KANA_MAP.put('ｱ', 'ア');
            KANA_MAP.put('ｲ', 'イ');
            KANA_MAP.put('ｳ', 'ウ');
            KANA_MAP.put('ｴ', 'エ');
            KANA_MAP.put('ｵ', 'オ');
            KANA_MAP.put('ｶ', 'カ');
            KANA_MAP.put('ｷ', 'キ');
            KANA_MAP.put('ｸ', 'ク');
            KANA_MAP.put('ｹ', 'ケ');
            KANA_MAP.put('ｺ', 'コ');
            KANA_MAP.put('ｻ', 'サ');
            KANA_MAP.put('ｼ', 'シ');
            KANA_MAP.put('ｽ', 'ス');
            KANA_MAP.put('ｾ', 'セ');
            KANA_MAP.put('ｿ', 'ソ');
            KANA_MAP.put('ﾀ', 'タ');
            KANA_MAP.put('ﾁ', 'チ');
            KANA_MAP.put('ﾂ', 'ツ');
            KANA_MAP.put('ﾃ', 'テ');
            KANA_MAP.put('ﾄ', 'ト');
            KANA_MAP.put('ﾅ', 'ナ');
            KANA_MAP.put('ﾆ', 'ニ');
            KANA_MAP.put('ﾇ', 'ヌ');
            KANA_MAP.put('ﾈ', 'ネ');
            KANA_MAP.put('ﾉ', 'ノ');
            KANA_MAP.put('ﾊ', 'ハ');
            KANA_MAP.put('ﾋ', 'ヒ');
            KANA_MAP.put('ﾌ', 'フ');
            KANA_MAP.put('ﾍ', 'ヘ');
            KANA_MAP.put('ﾎ', 'ホ');
            KANA_MAP.put('ﾏ', 'マ');
            KANA_MAP.put('ﾐ', 'ミ');
            KANA_MAP.put('ﾑ', 'ム');
            KANA_MAP.put('ﾒ', 'メ');
            KANA_MAP.put('ﾓ', 'モ');
            KANA_MAP.put('ﾔ', 'ヤ');
            KANA_MAP.put('ﾕ', 'ユ');
            KANA_MAP.put('ﾖ', 'ヨ');
            KANA_MAP.put('ﾗ', 'ラ');
            KANA_MAP.put('ﾘ', 'リ');
            KANA_MAP.put('ﾙ', 'ル');
            KANA_MAP.put('ﾚ', 'レ');
            KANA_MAP.put('ﾛ', 'ロ');
            KANA_MAP.put('ﾜ', 'ワ');
            KANA_MAP.put('ｦ', 'オ');
            KANA_MAP.put('ﾝ', 'ン');
            
            // 全角ひらがな（正音）→ 全角カタカナに変換
            KANA_MAP.put('あ', 'ア');
            KANA_MAP.put('い', 'イ');
            KANA_MAP.put('う', 'ウ');
            KANA_MAP.put('え', 'エ');
            KANA_MAP.put('お', 'オ');
            KANA_MAP.put('か', 'カ');
            KANA_MAP.put('き', 'キ');
            KANA_MAP.put('く', 'ク');
            KANA_MAP.put('け', 'ケ');
            KANA_MAP.put('こ', 'コ');
            KANA_MAP.put('さ', 'サ');
            KANA_MAP.put('し', 'シ');
            KANA_MAP.put('す', 'ス');
            KANA_MAP.put('せ', 'セ');
            KANA_MAP.put('そ', 'ソ');
            KANA_MAP.put('た', 'タ');
            KANA_MAP.put('ち', 'チ');
            KANA_MAP.put('つ', 'ツ');
            KANA_MAP.put('て', 'テ');
            KANA_MAP.put('と', 'ト');
            KANA_MAP.put('な', 'ナ');
            KANA_MAP.put('に', 'ニ');
            KANA_MAP.put('ぬ', 'ヌ');
            KANA_MAP.put('ね', 'ネ');
            KANA_MAP.put('の', 'ノ');
            KANA_MAP.put('は', 'ハ');
            KANA_MAP.put('ひ', 'ヒ');
            KANA_MAP.put('ふ', 'フ');
            KANA_MAP.put('へ', 'ヘ');
            KANA_MAP.put('ほ', 'ホ');
            KANA_MAP.put('ま', 'マ');
            KANA_MAP.put('み', 'ミ');
            KANA_MAP.put('む', 'ム');
            KANA_MAP.put('め', 'メ');
            KANA_MAP.put('も', 'モ');
            KANA_MAP.put('や', 'ヤ');
            KANA_MAP.put('ゆ', 'ユ');
            KANA_MAP.put('よ', 'ヨ');
            KANA_MAP.put('ら', 'ラ');
            KANA_MAP.put('り', 'リ');
            KANA_MAP.put('る', 'ル');
            KANA_MAP.put('れ', 'レ');
            KANA_MAP.put('ろ', 'ロ');
            KANA_MAP.put('わ', 'ワ');
            KANA_MAP.put('を', 'ヲ');
            KANA_MAP.put('ん', 'ン');
            
            // 半角カタカナ小文字（拗音・発音）→ 大文字の全角カタカナに変換
            KANA_MAP.put('ｧ', 'ア');
            KANA_MAP.put('ｨ', 'イ');
            KANA_MAP.put('ｩ', 'ウ');
            KANA_MAP.put('ｪ', 'エ');
            KANA_MAP.put('ｫ', 'オ');
            KANA_MAP.put('ｬ', 'ヤ');
            KANA_MAP.put('ｭ', 'ユ');
            KANA_MAP.put('ｮ', 'ヨ');
            KANA_MAP.put('ｯ', 'ツ');
            
            // 全角カタカナ小文字（拗音・発音）→ 大文字の全角カタカナに変換
            KANA_MAP.put('ァ', 'ア');
            KANA_MAP.put('ィ', 'イ');
            KANA_MAP.put('ゥ', 'ウ');
            KANA_MAP.put('ェ', 'エ');
            KANA_MAP.put('ォ', 'オ');
            KANA_MAP.put('ャ', 'ヤ');
            KANA_MAP.put('ュ', 'ユ');
            KANA_MAP.put('ョ', 'ヨ');
            KANA_MAP.put('ッ', 'ツ');
            
            // 全角ひらがな小文字（拗音・発音）→ 大文字の全角カタカナに変換
            KANA_MAP.put('ぁ', 'ア');
            KANA_MAP.put('ぃ', 'イ');
            KANA_MAP.put('ぅ', 'ウ');
            KANA_MAP.put('ぇ', 'エ');
            KANA_MAP.put('ぉ', 'オ');
            KANA_MAP.put('ゃ', 'ヤ');
            KANA_MAP.put('ゅ', 'ユ');
            KANA_MAP.put('ょ', 'ヨ');
            KANA_MAP.put('っ', 'ツ');
            
            // 全角カタカナ（濁音・半濁音）→ 変換なし
            KANA_MAP.put('ヴ', 'ヴ');
            KANA_MAP.put('ガ', 'ガ');
            KANA_MAP.put('ギ', 'ギ');
            KANA_MAP.put('グ', 'グ');
            KANA_MAP.put('ゲ', 'ゲ');
            KANA_MAP.put('ゴ', 'ゴ');
            KANA_MAP.put('ダ', 'ダ');
            KANA_MAP.put('ヂ', 'ヂ');
            KANA_MAP.put('ヅ', 'ヅ');
            KANA_MAP.put('デ', 'デ');
            KANA_MAP.put('ド', 'ド');
            KANA_MAP.put('バ', 'バ');
            KANA_MAP.put('ビ', 'ビ');
            KANA_MAP.put('ブ', 'ブ');
            KANA_MAP.put('ベ', 'ベ');
            KANA_MAP.put('ボ', 'ボ');
            KANA_MAP.put('パ', 'パ');
            KANA_MAP.put('ピ', 'ピ');
            KANA_MAP.put('プ', 'プ');
            KANA_MAP.put('ペ', 'ペ');
            KANA_MAP.put('ポ', 'ポ');
            
            // 全角ひらがな小文字（拗音・発音）→ 大文字の全角カタカナに変換
            KANA_MAP.put('ゔ', 'ヴ');
            KANA_MAP.put('が', 'ガ');
            KANA_MAP.put('ぎ', 'ギ');
            KANA_MAP.put('ぐ', 'グ');
            KANA_MAP.put('げ', 'ゲ');
            KANA_MAP.put('ご', 'ゴ');
            KANA_MAP.put('だ', 'ダ');
            KANA_MAP.put('ぢ', 'ヂ');
            KANA_MAP.put('づ', 'ヅ');
            KANA_MAP.put('で', 'デ');
            KANA_MAP.put('ど', 'ド');
            KANA_MAP.put('ば', 'バ');
            KANA_MAP.put('び', 'ビ');
            KANA_MAP.put('ぶ', 'ブ');
            KANA_MAP.put('べ', 'ベ');
            KANA_MAP.put('ぼ', 'ボ');
            KANA_MAP.put('ぱ', 'パ');
            KANA_MAP.put('ぴ', 'ピ');
            KANA_MAP.put('ぷ', 'プ');
            KANA_MAP.put('ぺ', 'ペ');
            KANA_MAP.put('ぽ', 'ポ');
            
            // 全角カタカナ（同音異体字）→ 現代発音の全角カタカナに変換
            KANA_MAP.put('ヰ', 'イ');
            KANA_MAP.put('ヱ', 'エ');
            
            // 全角ひらがな（同音異体字）→ 現代発音の全角カタカナに変換
            KANA_MAP.put('ゐ', 'イ');
            KANA_MAP.put('ゑ', 'エ');
            // 全角カタカナ（正音）→ 変換なし
            
            KANA_MAP.put(' ', '');
            
        }
    
    public static String convert(String src, Map<String, String> mapvalues) {
        // 変換後の文字列を格納するためのBuffer
        String dst = '';
        List<String> strList = src.split('');
        // 変換前の文字列を１文字ごとにloopする
        for(String charStr : strList) {
            
            // 変換MAPを使って、１文字ずつ変換する
            String converted = mapvalues.get(charStr);
            
            // 変換MAPに定義されている文字が存在した場合、Bufferに格納する
            if (String.isNotBlank(converted)) {
                dst = dst + converted;
            }
        }
        
        return dst;
    }
    /*
public static void main(String[] args) throws Exception {
String testString = 'あいうえおｶﾞｷﾞｸﾞｹﾞｺﾞザジズゼゾだぢづでどなにぬねのぱぴぷぺぽｧｨｩｪｫｬｭｮｯぁぃぅぇぉゃゅょっヰヱゐゑゔヴ';
System.out.println(testString);
System.out.println(convert(testString, KANA_MAP));

String testNumber = '2023/10/27(Fri)－０１-２３４５-６７８９';
System.out.println(testNumber);
System.out.println(convert(testNumber, NUMBER_MAP));
}*/
}