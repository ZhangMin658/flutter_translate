import 'package:camera/camera.dart';

class DefaultValue {
  static const int NUM_SCAN_FREE = 5;
  static const List<String> IAP_PRODUCE_IDS = <String>[
    'id_premium_pack_week',
    'id_premium_pack_month',
    'id_premium_pack_year'
  ];

  static const List<Duration> PACK_DURATION = <Duration>[
    Duration(days: 7),
    Duration(days: 30),
    Duration(days: 365)
  ];
  static const String OFFER_PRODUCE_IAP = "id_premium_pack_month";

  static const String PERCENTAGE_PRODUCE_IAP = "id_premium_pack_week";

  static const ResolutionPreset CAMERA_RESOLUTION_ANDROID =
      ResolutionPreset.ultraHigh;
  static const ResolutionPreset CAMERA_RESOLUTION_IOS = ResolutionPreset.high;
}

class Lang {
  final String codeForSpeech;
  final String codeForTranslate;
  final String name;
  const Lang(this.codeForTranslate, this.codeForSpeech, this.name);
}

class Language {
  static Lang getLangByCode(String code) {
    List<Lang> langs =
        LIST_LANGUAGE.where((lang) => lang.codeForTranslate == code).toList();
    return langs.length > 0 ? langs[0] : LIST_LANGUAGE[0];
  }

  static const Lang AF = Lang("af", "en", "Afrikaans");
  static const Lang SQ = Lang("sq", "en", "Albanian");
  static const Lang AM = Lang("am", "en", "Amharic");
  static const Lang AR = Lang("ar", "ar-qa", "Arabic");
  static const Lang HY = Lang("hy", "en", "Armenian");
  static const Lang AZ = Lang("az", "en", "Azerbaijani");
  static const Lang EU = Lang("eu", "en", "Basque");
  static const Lang BE = Lang("be", "en", "Belarusian");
  static const Lang BN = Lang("bn", "en", "Bengali");
  static const Lang BS = Lang("bs", "en", "Bosnian");
  static const Lang BG = Lang("bg", "en", "Bulgarian");
  static const Lang CA = Lang("ca", "en", "Catalan");
  static const Lang CEB = Lang("ceb", "en", "Cebuano");
  static const Lang ZH_CN = Lang("zh-CN", "zh-CN", "Chinese(S)");
  static const Lang ZH_TW = Lang("zh-TW", "en", "Chinese(T)");
  static const Lang CO = Lang("co", "en", "Corsican");
  static const Lang HR = Lang("hr", "en", "Croatian");
  static const Lang CS = Lang("cs", "cs-CZ", "Czech");
  static const Lang DA = Lang("da", "da-DK", "Danish");
  static const Lang NL = Lang("nl", "nl-NL", "Dutch");
  static const Lang EN = Lang("en", "en-US", "English");
  static const Lang EO = Lang("eo", "en", "Esperanto");
  static const Lang ET = Lang("et", "en", "Estonian");
  static const Lang FI = Lang("fi", "fi-FI", "Finnish");
  static const Lang FR = Lang("fr", "fr-CA", "French");
  static const Lang FY = Lang("fy", "en", "Frisian");
  static const Lang GL = Lang("gl", "en", "Galician");
  static const Lang KA = Lang("ka", "en", "Georgian");
  static const Lang DE = Lang("de", "de-DE", "German");
  static const Lang EL = Lang("el", "el-GR", "Greek");
  static const Lang GU = Lang("gu", "en", "Gujarati");
  static const Lang HT = Lang("ht", "en", "Haitian Creole");
  static const Lang HA = Lang("ha", "en", "Hausa");
  static const Lang HAW = Lang("haw", "en", "Hawaiian");
  static const Lang HE = Lang("he", "en", "Hebrew");
  static const Lang HI = Lang("hi", "hi-IN", "Hindi");
  static const Lang HMN = Lang("hmn", "en", "Hmong");
  static const Lang HU = Lang("hu", "hu-HU", "Hungarian");
  static const Lang IS = Lang("is", "en", "Icelandic");
  static const Lang IG = Lang("ig", "en", "Igbo");
  static const Lang ID = Lang("id", "id-ID", "Indonesian");
  static const Lang GA = Lang("ga", "en", "Irish");
  static const Lang IT = Lang("it", "it-IT", "Italian");
  static const Lang JA = Lang("ja", "ja-JP", "Japanese");
  static const Lang JW = Lang("jw", "en", "Javanese");
  static const Lang KN = Lang("kn", "en", "Kannada");
  static const Lang KK = Lang("kk", "en", "Kazakh");
  static const Lang KM = Lang("km", "en", "Khmer");
  static const Lang KO = Lang("ko", "ko-KR", "Korean");
  static const Lang KU = Lang("ku", "en", "Kurdish");
  static const Lang KY = Lang("ky", "en", "Kyrgyz");
  static const Lang LO = Lang("lo", "en", "Lao");
  static const Lang LA = Lang("la", "en", "Latin");
  static const Lang LV = Lang("lv", "en", "Latvian");
  static const Lang LT = Lang("lt", "en", "Lithuanian");
  static const Lang LB = Lang("lb", "en", "Luxembourgish");
  static const Lang MK = Lang("mk", "en", "Macedonian");
  static const Lang MG = Lang("mg", "en", "Malagasy");
  static const Lang MD = Lang("md", "en", "Malay");
  static const Lang ML = Lang("ml", "en", "Malayalam");
  static const Lang MT = Lang("mt", "en", "Maltese");
  static const Lang MI = Lang("mi", "en", "Maori");
  static const Lang MR = Lang("mr", "en", "Marathi");
  static const Lang MN = Lang("mn", "en", "Mongolian");
  static const Lang MY = Lang("my", "en", "Myanmar (Burmese)");
  static const Lang NE = Lang("ne", "en", "Nepali");
  static const Lang NO = Lang("no", "nb-NO", "Norwegian");
  static const Lang NY = Lang("ny", "en", "Nyanja (Chichewa)");
  static const Lang PS = Lang("ps", "en", "Pashto");
  static const Lang FA = Lang("fa", "en", "Persian");
  static const Lang PL = Lang("pl", "pl-PL", "Polish");
  static const Lang PT = Lang("pt", "pt-PT", "Portuguese (Portugal, Brazil)");
  static const Lang PA = Lang("pa", "en", "Punjabi");
  static const Lang RO = Lang("ro", "en", "Romanian");
  static const Lang RU = Lang("ru", "ru-RU", "Russian");
  static const Lang SM = Lang("sm", "en", "Samoan");
  static const Lang GD = Lang("gd", "en", "Scots Gaelic");
  static const Lang SR = Lang("sr", "en", "Serbian");
  static const Lang ST = Lang("st", "en", "Sesotho");
  static const Lang SN = Lang("sn", "uk", "Shona");
  static const Lang SD = Lang("sd", "uk", "Sindhi");
  static const Lang SI = Lang("si", "uk", "Sinhala (Sinhalese)");
  static const Lang SK = Lang("sk", "sk-SK", "Slovak");
  static const Lang SL = Lang("sl", "uk", "Slovenian");
  static const Lang SO = Lang("so", "uk", "Somali");
  static const Lang ES = Lang("es", "es-ES", "Spanish");
  static const Lang SU = Lang("su", "uk", "Sundanese");
  static const Lang SW = Lang("sw", "uk", "Swahili");
  static const Lang SV = Lang("sv", "sv-SE", "Swedish");
  static const Lang TL = Lang("tl", "uk", "Tagalog (Filipino)");
  static const Lang TG = Lang("tg", "uk", "Tajik");
  static const Lang TA = Lang("ta", "uk", "Tamil");
  static const Lang TE = Lang("te", "uk", "Telugu");
  static const Lang TH = Lang("th", "uk", "Thai");
  static const Lang TR = Lang("tr", "tr-TR", "Turkish");
  static const Lang UK = Lang("uk", "uk-UA", "Ukrainian");
  static const Lang UR = Lang("ur", "uk", "Urdu");
  static const Lang UZ = Lang("uz", "uk", "Uzbek");
  static const Lang VN = Lang("vi", "vi-VN", "Vietnamese");
  static const Lang CY = Lang("cy", "uk", "Welsh");
  static const Lang XH = Lang("xh", "uk", "Xhosa");
  static const Lang YI = Lang("yi", "uk", "Yiddish");
  static const Lang YO = Lang("yo", "uk", "Yoruba");
  static const Lang ZU = Lang("zu", "uk", "Zulu");

  static List<Lang> LIST_LANGUAGE = [
    AF,
    SQ,
    AM,
    AR,
    HY,
    AZ,
    EU,
    BE,
    BN,
    BS,
    BG,
    CA,
    CEB,
    ZH_CN,
    ZH_TW,
    CO,
    HR,
    CS,
    DA,
    NL,
    EN,
    EO,
    ET,
    FI,
    FR,
    FY,
    GL,
    KA,
    DE,
    EL,
    GU,
    HT,
    HA,
    HAW,
    HE,
    HI,
    HMN,
    HU,
    IS,
    IG,
    ID,
    GA,
    IT,
    JA,
    JW,
    KN,
    KK,
    KM,
    KO,
    KU,
    KY,
    LO,
    LA,
    LV,
    LT,
    LB,
    MK,
    MG,
    MD,
    ML,
    MT,
    MI,
    MR,
    MN,
    MY,
    NE,
    NO,
    NY,
    PS,
    FA,
    PL,
    PT,
    PA,
    RO,
    RU,
    SM,
    GD,
    SR,
    ST,
    SN,
    SD,
    SI,
    SK,
    SL,
    SO,
    ES,
    SU,
    SW,
    SV,
    TL,
    TG,
    TA,
    TE,
    TH,
    TR,
    UK,
    UR,
    UZ,
    VN,
    CY,
    XH,
    YI,
    YO,
    ZU
  ];
}
