/**
 * @Class Name      : FaqConstants 
 * @Description     : FAQ領域用定数クラス
 * @Created Date    : 2022.08.23
 * @Created By      : Uhuru) Y.Yamada
 * @Modified Date   : 2022.09.14
 * @Modified By     : Uhuru) Y.Yamada
 */
public with sharing class FaqConstants {
    //======================================================
    // オブジェクトAPI名
    //======================================================
    /** ナレッジ */
    public static final String KNOWLEDGE_KAV = Schema.SObjectType.Knowledge__kav.getName();
    /** ナレッジバージョンオブジェクト */
    public static final String KNOWLEDGE_ARTICLE_VERSION = Schema.SObjectType.KnowledgeArticleVersion.getName();

    //======================================================
    // String固定値
    //======================================================
    /** 空文字 */
    public static final String CHAR_EMPTY = '';
    /** 半角スペース */
    public static final String CHAR_HALF_SPACE = ' ';
    /** シングルクォーテーション */
    public static final String CHAR_SINGLE_QUARTO = '\'';
    /** バックスラッシュ */
    public static final String CHAR_BACK_SLASH = '\\';

    //======================================================
    // カテゴリグループ
    //======================================================
    /** カテゴリグループ名(一意の名前)：楽天生命 */
    public static final String CATEGORY_GROUP_LIFE = 'CategoryGroupLife';
    /** カテゴリグループ名(一意の名前)：楽天損保 */
    public static final String CATEGORY_GROUP_INSURANCE = 'CategoryGroupInsurance';
    /** カテゴリグループ名(一意の名前)：楽天ペット保険 */
    public static final String CATEGORY_GROUP_PET = 'CategoryGroupPet';
    /** カテゴリグループ名：楽天生命 */
    public static final String CATEGORY_GROUP_LABEL_LIFE = '楽天生命';
    /** カテゴリグループ名：楽天損保 */
    public static final String CATEGORY_GROUP_LABEL_INSURANCE = '楽天損保';
    /** カテゴリグループ名：楽天ペット保険 */
    public static final String CATEGORY_GROUP_LABEL_PET = '楽天ペット保険';
    /** カテゴリグループ名Map (Name to Label) */
    public static final Map<String, String> CATEGORY_GROUP_NAMES = new Map<String, String> {
        CATEGORY_GROUP_LIFE => CATEGORY_GROUP_LABEL_LIFE,
        CATEGORY_GROUP_INSURANCE => CATEGORY_GROUP_LABEL_INSURANCE,
        CATEGORY_GROUP_PET => CATEGORY_GROUP_LABEL_PET
    };
    /** カテゴリグループ名Map (Label to Name) */
    public static final Map<String, String> CATEGORY_GROUP_LABELS = new Map<String, String> {
        CATEGORY_GROUP_LABEL_LIFE => CATEGORY_GROUP_LIFE,
        CATEGORY_GROUP_LABEL_INSURANCE => CATEGORY_GROUP_INSURANCE,
        CATEGORY_GROUP_LABEL_PET => CATEGORY_GROUP_PET
    };
    
    //======================================================
    // ナレッジステータス
    //======================================================
    /** ナレッジ公開状況：公開済み */
    public static final String PUBLISH_STATUS_ONLINE = 'Online';
    /** ナレッジ言語：日本語 */
    public static final String LANGUAGE_JA = 'ja';

    //======================================================
    // 投票数設定値
    //======================================================
    /** 初期押下カウント値 */
    public static final Integer INIT_COUNT_VALUE = 1;
    /** デフォルトカウント値 */
    public static final Integer DEFAULT_COUNT_VALUE = 0;

    //======================================================
    // ナレッジ取得パラメータ
    //======================================================
    /** QA一覧パラメータ名：取得数無制限 */
    public static final Integer NO_LIMIT = 0;
    /** QA一覧パラメータ名：質問表示文字数無制限 */
    public static final Integer FULL_LENGTH = 0;
    /** SOSL検索予約文字 */
    public static final List<String> RESERVED_CHARS = new List<String> {
        '\\',
        '&',
        '|',
        '!',
        '{',
        '}',
        '[',
        ']',
        '(',
        ')',
        '^',
        '~',
        ':',
        '\"',
        '\'',
        '+',
        '-'
    };
}