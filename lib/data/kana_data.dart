import '../models/kana_item.dart';

const List<String> defaultSelectedRows = ['row-a', 'row-ka', 'row-sa'];

const List<KanaRowGroup> kanaRowGroups = [
  // Monographs (Gojūon)
  KanaRowGroup(
    id: 'row-a',
    label: 'Vowels (A-row)',
    sampleHiragana: 'あ',
    sampleKatakana: 'ア',
    romajiSummary: 'a • i • u • e • o',
    category: KanaCategory.monograph,
  ),
  KanaRowGroup(
    id: 'row-ka',
    label: 'K-row',
    sampleHiragana: 'か',
    sampleKatakana: 'カ',
    romajiSummary: 'ka • ki • ku • ke • ko',
    category: KanaCategory.monograph,
  ),
  KanaRowGroup(
    id: 'row-sa',
    label: 'S-row',
    sampleHiragana: 'さ',
    sampleKatakana: 'サ',
    romajiSummary: 'sa • shi • su • se • so',
    category: KanaCategory.monograph,
  ),
  KanaRowGroup(
    id: 'row-ta',
    label: 'T-row',
    sampleHiragana: 'た',
    sampleKatakana: 'タ',
    romajiSummary: 'ta • chi • tsu • te • to',
    category: KanaCategory.monograph,
  ),
  KanaRowGroup(
    id: 'row-na',
    label: 'N-row',
    sampleHiragana: 'な',
    sampleKatakana: 'ナ',
    romajiSummary: 'na • ni • nu • ne • no',
    category: KanaCategory.monograph,
  ),
  KanaRowGroup(
    id: 'row-ha',
    label: 'H-row',
    sampleHiragana: 'は',
    sampleKatakana: 'ハ',
    romajiSummary: 'ha • hi • fu • he • ho',
    category: KanaCategory.monograph,
  ),
  KanaRowGroup(
    id: 'row-ma',
    label: 'M-row',
    sampleHiragana: 'ま',
    sampleKatakana: 'マ',
    romajiSummary: 'ma • mi • mu • me • mo',
    category: KanaCategory.monograph,
  ),
  KanaRowGroup(
    id: 'row-ya',
    label: 'Y-row',
    sampleHiragana: 'や',
    sampleKatakana: 'ヤ',
    romajiSummary: 'ya • yu • yo',
    category: KanaCategory.monograph,
  ),
  KanaRowGroup(
    id: 'row-ra',
    label: 'R-row',
    sampleHiragana: 'ら',
    sampleKatakana: 'ラ',
    romajiSummary: 'ra • ri • ru • re • ro',
    category: KanaCategory.monograph,
  ),
  KanaRowGroup(
    id: 'row-wa',
    label: 'W-row & N',
    sampleHiragana: 'わ',
    sampleKatakana: 'ワ',
    romajiSummary: 'wa • wo • n',
    category: KanaCategory.monograph,
  ),
  // Diacritics (Dakuon & Handakuon)
  KanaRowGroup(
    id: 'row-ga',
    label: 'G-row (Dakuten)',
    sampleHiragana: 'が',
    sampleKatakana: 'ガ',
    romajiSummary: 'ga • gi • gu • ge • go',
    category: KanaCategory.diacritic,
  ),
  KanaRowGroup(
    id: 'row-za',
    label: 'Z-row (Dakuten)',
    sampleHiragana: 'ざ',
    sampleKatakana: 'ザ',
    romajiSummary: 'za • ji • zu • ze • zo',
    category: KanaCategory.diacritic,
  ),
  KanaRowGroup(
    id: 'row-da',
    label: 'D-row (Dakuten)',
    sampleHiragana: 'だ',
    sampleKatakana: 'ダ',
    romajiSummary: 'da • ji • zu • de • do',
    category: KanaCategory.diacritic,
  ),
  KanaRowGroup(
    id: 'row-ba',
    label: 'B-row (Dakuten)',
    sampleHiragana: 'ば',
    sampleKatakana: 'バ',
    romajiSummary: 'ba • bi • bu • be • bo',
    category: KanaCategory.diacritic,
  ),
  KanaRowGroup(
    id: 'row-pa',
    label: 'P-row (Handakuten)',
    sampleHiragana: 'ぱ',
    sampleKatakana: 'パ',
    romajiSummary: 'pa • pi • pu • pe • po',
    category: KanaCategory.diacritic,
  ),
  // Digraphs (Yōon)
  KanaRowGroup(
    id: 'row-kya',
    label: 'KY & GY Digraphs',
    sampleHiragana: 'きゃ',
    sampleKatakana: 'キャ',
    romajiSummary: 'kya • kyu • kyo • gya • gyu • gyo',
    category: KanaCategory.digraph,
  ),
  KanaRowGroup(
    id: 'row-sha',
    label: 'SH & J Digraphs',
    sampleHiragana: 'しゃ',
    sampleKatakana: 'シャ',
    romajiSummary: 'sha • shu • sho • ja • ju • jo',
    category: KanaCategory.digraph,
  ),
  KanaRowGroup(
    id: 'row-cha',
    label: 'CH & NY Digraphs',
    sampleHiragana: 'ちゃ',
    sampleKatakana: 'チャ',
    romajiSummary: 'cha • chu • cho • nya • nyu • nyo',
    category: KanaCategory.digraph,
  ),
  KanaRowGroup(
    id: 'row-hya',
    label: 'HY, BY & PY Digraphs',
    sampleHiragana: 'ひゃ',
    sampleKatakana: 'ヒャ',
    romajiSummary: 'hya/bya/pya • hyu/byu/pyu • hyo/byo/pyo',
    category: KanaCategory.digraph,
  ),
  KanaRowGroup(
    id: 'row-mya',
    label: 'MY & RY Digraphs',
    sampleHiragana: 'みゃ',
    sampleKatakana: 'ミャ',
    romajiSummary: 'mya • myu • myo • rya • ryu • ryo',
    category: KanaCategory.digraph,
  ),
];

KanaItem _mono(
  String id,
  String hiragana,
  String katakana,
  String romaji,
  String rowId,
  String hint, [
  List<String>? accepted,
]) {
  return KanaItem(
    id: id,
    hiragana: hiragana,
    katakana: katakana,
    romaji: romaji,
    acceptedRomaji: accepted ?? [romaji],
    rowId: rowId,
    category: KanaCategory.monograph,
    hint: hint,
  );
}

KanaItem _diacritic(
  String id,
  String hiragana,
  String katakana,
  String romaji,
  String rowId,
  String hint, [
  List<String>? accepted,
]) {
  return KanaItem(
    id: id,
    hiragana: hiragana,
    katakana: katakana,
    romaji: romaji,
    acceptedRomaji: accepted ?? [romaji],
    rowId: rowId,
    category: KanaCategory.diacritic,
    hint: hint,
  );
}

KanaItem _digraph(
  String id,
  String hiragana,
  String katakana,
  String romaji,
  String rowId,
  String hint, [
  List<String>? accepted,
]) {
  return KanaItem(
    id: id,
    hiragana: hiragana,
    katakana: katakana,
    romaji: romaji,
    acceptedRomaji: accepted ?? [romaji],
    rowId: rowId,
    category: KanaCategory.digraph,
    hint: hint,
  );
}

final List<KanaItem> monographKanaItems = [
  // A-row
  _mono('a', 'あ', 'ア', 'a', 'row-a', "'a' as in father"),
  _mono('i', 'い', 'イ', 'i', 'row-a', "'i' as in machine (ee)"),
  _mono('u', 'う', 'ウ', 'u', 'row-a', "'u' as in flute (oo)"),
  _mono('e', 'え', 'エ', 'e', 'row-a', "'e' as in pet (eh)"),
  _mono('o', 'お', 'オ', 'o', 'row-a', "'o' as in more (oh)"),
  // K-row
  _mono('ka', 'か', 'カ', 'ka', 'row-ka', "'ka' as in karma", ['ka', 'ca']),
  _mono('ki', 'き', 'キ', 'ki', 'row-ka', "Sounds like 'key'"),
  _mono('ku', 'く', 'ク', 'ku', 'row-ka', "'ku' like a cuckoo bird beak", ['ku', 'cu']),
  _mono('ke', 'け', 'ケ', 'ke', 'row-ka', "'ke' as in keg"),
  _mono('ko', 'こ', 'コ', 'ko', 'row-ka', "'ko' as in koi fish", ['ko', 'co']),
  // S-row
  _mono('sa', 'さ', 'サ', 'sa', 'row-sa', "'sa' as in salsa"),
  _mono('shi', 'し', 'シ', 'shi', 'row-sa', "Sounds like 'she'", ['shi', 'si']),
  _mono('su', 'す', 'ス', 'su', 'row-sa', "'su' as in sushi"),
  _mono('se', 'せ', 'セ', 'se', 'row-sa', "'se' as in set"),
  _mono('so', 'そ', 'ソ', 'so', 'row-sa', "'so' as in soda"),
  // T-row
  _mono('ta', 'た', 'タ', 'ta', 'row-ta', "'ta' as in taco"),
  _mono('chi', 'ち', 'チ', 'chi', 'row-ta', "'chi' as in cheer", ['chi', 'ti']),
  _mono('tsu', 'つ', 'ツ', 'tsu', 'row-ta', "'tsu' as in tsunami", ['tsu', 'tu']),
  _mono('te', 'て', 'テ', 'te', 'row-ta', "'te' as in ten"),
  _mono('to', 'と', 'ト', 'to', 'row-ta', "'to' as in tornado"),
  // N-row
  _mono('na', 'な', 'ナ', 'na', 'row-na', "'na' as in nacho"),
  _mono('ni', 'に', 'ニ', 'ni', 'row-na', "'ni' as in knee"),
  _mono('nu', 'ぬ', 'ヌ', 'nu', 'row-na', "'nu' as in noodle"),
  _mono('ne', 'ね', 'ネ', 'ne', 'row-na', "'ne' as in neko (cat)"),
  _mono('no', 'の', 'ノ', 'no', 'row-na', "Looks like a 'No' prohibition sign"),
  // H-row
  _mono('ha', 'は', 'ハ', 'ha', 'row-ha', "'ha' as in haha"),
  _mono('hi', 'ひ', 'ヒ', 'hi', 'row-ha', "Sounds like 'he'"),
  _mono('fu', 'ふ', 'フ', 'fu', 'row-ha', "'fu' as in Mt. Fuji", ['fu', 'hu']),
  _mono('he', 'へ', 'ヘ', 'he', 'row-ha', "'he' as in heaven (points up)"),
  _mono('ho', 'ほ', 'ホ', 'ho', 'row-ha', "'ho' as in hotel"),
  // M-row
  _mono('ma', 'ま', 'マ', 'ma', 'row-ma', "'ma' as in mama"),
  _mono('mi', 'み', 'ミ', 'mi', 'row-ma', "Sounds like musical note 'mi'"),
  _mono('mu', 'む', 'ム', 'mu', 'row-ma', "'mu' as in cow moo"),
  _mono('me', 'め', 'メ', 'me', 'row-ma', "Means 'eye' in Japanese"),
  _mono('mo', 'も', 'モ', 'mo', 'row-ma', "'mo' as in more fishhooks"),
  // Y-row
  _mono('ya', 'や', 'ヤ', 'ya', 'row-ya', "'ya' as in yak"),
  _mono('yu', 'ゆ', 'ユ', 'yu', 'row-ya', "Sounds like 'you'"),
  _mono('yo', 'よ', 'ヨ', 'yo', 'row-ya', "'yo' as in yo-yo"),
  // R-row
  _mono('ra', 'ら', 'ラ', 'ra', 'row-ra', "'ra' as in ramen", ['ra', 'la']),
  _mono('ri', 'り', 'リ', 'ri', 'row-ra', "'ri' as in river reeds", ['ri', 'li']),
  _mono('ru', 'る', 'ル', 'ru', 'row-ra', "'ru' has a loop at the bottom", ['ru', 'lu']),
  _mono('re', 'れ', 'レ', 're', 'row-ra', "'re' kicks outward at the end", ['re', 'le']),
  _mono('ro', 'ろ', 'ロ', 'ro', 'row-ra', "'ro' is like 'ru' without the loop", ['ro', 'lo']),
  // W-row & N
  _mono('wa', 'わ', 'ワ', 'wa', 'row-wa', "'wa' as in water"),
  _mono('wo', 'を', 'ヲ', 'wo', 'row-wa', "Object particle pronounced 'o' / 'wo'", ['wo', 'o']),
  _mono('n', 'ん', 'ン', 'n', 'row-wa', "Standalone nasal 'n'", ['n', 'nn']),
];

final List<KanaItem> diacriticKanaItems = [
  // G-row (Dakuten)
  _diacritic('ga', 'が', 'ガ', 'ga', 'row-ga', "Voiced 'ka' -> 'ga'"),
  _diacritic('gi', 'ぎ', 'ギ', 'gi', 'row-ga', "Voiced 'ki' -> 'gi' (hard g)"),
  _diacritic('gu', 'ぐ', 'グ', 'gu', 'row-ga', "Voiced 'ku' -> 'gu'"),
  _diacritic('ge', 'げ', 'ゲ', 'ge', 'row-ga', "Voiced 'ke' -> 'ge'"),
  _diacritic('go', 'ご', 'ゴ', 'go', 'row-ga', "Voiced 'ko' -> 'go'"),
  // Z-row (Dakuten)
  _diacritic('za', 'ざ', 'ザ', 'za', 'row-za', "Voiced 'sa' -> 'za'"),
  _diacritic('ji', 'じ', 'ジ', 'ji', 'row-za', "Voiced 'shi' -> 'ji'", ['ji', 'zi']),
  _diacritic('zu', 'ず', 'ズ', 'zu', 'row-za', "Voiced 'su' -> 'zu'"),
  _diacritic('ze', 'ぜ', 'ゼ', 'ze', 'row-za', "Voiced 'se' -> 'ze'"),
  _diacritic('zo', 'ぞ', 'ゾ', 'zo', 'row-za', "Voiced 'so' -> 'zo'"),
  // D-row (Dakuten)
  _diacritic('da', 'だ', 'ダ', 'da', 'row-da', "Voiced 'ta' -> 'da'"),
  _diacritic('dji', 'ぢ', 'ヂ', 'ji', 'row-da', "Voiced 'chi' -> 'ji' (di)", ['ji', 'di', 'dji']),
  _diacritic('dzu', 'づ', 'ヅ', 'zu', 'row-da', "Voiced 'tsu' -> 'zu' (du)", ['zu', 'du', 'dzu']),
  _diacritic('de', 'で', 'デ', 'de', 'row-da', "Voiced 'te' -> 'de'"),
  _diacritic('do', 'ど', 'ド', 'do', 'row-da', "Voiced 'to' -> 'do'"),
  // B-row (Dakuten)
  _diacritic('ba', 'ば', 'バ', 'ba', 'row-ba', "Voiced 'ha' -> 'ba'"),
  _diacritic('bi', 'び', 'ビ', 'bi', 'row-ba', "Voiced 'hi' -> 'bi'"),
  _diacritic('bu', 'ぶ', 'ブ', 'bu', 'row-ba', "Voiced 'fu' -> 'bu'"),
  _diacritic('be', 'べ', 'ベ', 'be', 'row-ba', "Voiced 'he' -> 'be'"),
  _diacritic('bo', 'ぼ', 'ボ', 'bo', 'row-ba', "Voiced 'ho' -> 'bo'"),
  // P-row (Handakuten)
  _diacritic('pa', 'ぱ', 'パ', 'pa', 'row-pa', "Handakuten 'ha' -> 'pa'"),
  _diacritic('pi', 'ぴ', 'ピ', 'pi', 'row-pa', "Handakuten 'hi' -> 'pi'"),
  _diacritic('pu', 'ぷ', 'プ', 'pu', 'row-pa', "Handakuten 'fu' -> 'pu'"),
  _diacritic('pe', 'ぺ', 'ペ', 'pe', 'row-pa', "Handakuten 'he' -> 'pe'"),
  _diacritic('po', 'ぽ', 'ポ', 'po', 'row-pa', "Handakuten 'ho' -> 'po'"),
];

final List<KanaItem> digraphKanaItems = [
  // KY & GY
  _digraph('kya', 'きゃ', 'キャ', 'kya', 'row-kya', 'ki + small ya = kya'),
  _digraph('kyu', 'きゅ', 'キュ', 'kyu', 'row-kya', 'ki + small yu = kyu'),
  _digraph('kyo', 'きょ', 'キョ', 'kyo', 'row-kya', 'ki + small yo = kyo (as in Kyoto)'),
  _digraph('gya', 'ぎゃ', 'ギャ', 'gya', 'row-kya', 'gi + small ya = gya'),
  _digraph('gyu', 'ぎゅ', 'ギュ', 'gyu', 'row-kya', 'gi + small yu = gyu (wagyu)'),
  _digraph('gyo', 'ぎょ', 'ギョ', 'gyo', 'row-kya', 'gi + small yo = gyo (gyoza)'),
  // SH & J
  _digraph('sha', 'しゃ', 'シャ', 'sha', 'row-sha', 'shi + small ya = sha', ['sha', 'sya']),
  _digraph('shu', 'しゅ', 'シュ', 'shu', 'row-sha', 'shi + small yu = shu', ['shu', 'syu']),
  _digraph('sho', 'しょ', 'ショ', 'sho', 'row-sha', 'shi + small yo = sho (shoyu)', ['sho', 'syo']),
  _digraph('ja', 'じゃ', 'ジャ', 'ja', 'row-sha', 'ji + small ya = ja', ['ja', 'jya', 'zya']),
  _digraph('ju', 'じゅ', 'ジュ', 'ju', 'row-sha', 'ji + small yu = ju (judo)', ['ju', 'jyu', 'zyu']),
  _digraph('jo', 'じょ', 'ジョ', 'jo', 'row-sha', 'ji + small yo = jo', ['jo', 'jyo', 'zyo']),
  // CH & NY
  _digraph('cha', 'ちゃ', 'チャ', 'cha', 'row-cha', 'chi + small ya = cha (matcha)', ['cha', 'tya', 'cya']),
  _digraph('chu', 'ちゅ', 'チュ', 'chu', 'row-cha', 'chi + small yu = chu', ['chu', 'tyu', 'cyu']),
  _digraph('cho', 'ちょ', 'チョ', 'cho', 'row-cha', 'chi + small yo = cho', ['cho', 'tyo', 'cyo']),
  _digraph('nya', 'にゃ', 'ニャ', 'nya', 'row-cha', 'ni + small ya = nya (cat meow)'),
  _digraph('nyu', 'にゅ', 'ニュ', 'nyu', 'row-cha', 'ni + small yu = nyu'),
  _digraph('nyo', 'にょ', 'ニョ', 'nyo', 'row-cha', 'ni + small yo = nyo'),
  // HY, BY, PY
  _digraph('hya', 'ひゃ', 'ヒャ', 'hya', 'row-hya', 'hi + small ya = hya'),
  _digraph('hyu', 'ひゅ', 'ヒュ', 'hyu', 'row-hya', 'hi + small yu = hyu'),
  _digraph('hyo', 'ひょ', 'ヒョ', 'hyo', 'row-hya', 'hi + small yo = hyo'),
  _digraph('bya', 'びゃ', 'ビャ', 'bya', 'row-hya', 'bi + small ya = bya'),
  _digraph('byu', 'びゅ', 'ビュ', 'byu', 'row-hya', 'bi + small yu = byu'),
  _digraph('byo', 'びょ', 'ビョ', 'byo', 'row-hya', 'bi + small yo = byo'),
  _digraph('pya', 'ぴゃ', 'ピャ', 'pya', 'row-hya', 'pi + small ya = pya'),
  _digraph('pyu', 'ぴゅ', 'ピュ', 'pyu', 'row-hya', 'pi + small yu = pyu'),
  _digraph('pyo', 'ぴょ', 'ピョ', 'pyo', 'row-hya', 'pi + small yo = pyo'),
  // MY & RY
  _digraph('mya', 'みゃ', 'ミャ', 'mya', 'row-mya', 'mi + small ya = mya'),
  _digraph('myu', 'みゅ', 'ミュ', 'myu', 'row-mya', 'mi + small yu = myu'),
  _digraph('myo', 'みょ', 'ミョ', 'myo', 'row-mya', 'mi + small yo = myo'),
  _digraph('rya', 'りゃ', 'リャ', 'rya', 'row-mya', 'ri + small ya = rya'),
  _digraph('ryu', 'りゅ', 'リュ', 'ryu', 'row-mya', 'ri + small yu = ryu (dragon)'),
  _digraph('ryo', 'りょ', 'リョ', 'ryo', 'row-mya', 'ri + small yo = ryo (ryokan)'),
];

final List<KanaItem> kanaItems = [
  ...monographKanaItems,
  ...diacriticKanaItems,
  ...digraphKanaItems,
];

final Map<String, KanaItem> kanaItemById = {
  for (final item in kanaItems) item.id: item,
};

final Map<String, List<KanaItem>> kanaItemsByRow = () {
  final map = <String, List<KanaItem>>{};
  for (final item in kanaItems) {
    map.putIfAbsent(item.rowId, () => []).add(item);
  }
  return map;
}();

final Map<KanaCategory, List<KanaItem>> kanaItemsByCategory = () {
  final map = <KanaCategory, List<KanaItem>>{
    KanaCategory.monograph: [],
    KanaCategory.diacritic: [],
    KanaCategory.digraph: [],
  };
  for (final item in kanaItems) {
    map[item.category]!.add(item);
  }
  return map;
}();
