/**
 * @Class Name      : DataCategoryHelper 
 * @Description     : データカテゴリ取得ヘルパークラス
 * @Created Date    : 2022.08.17
 * @Created By      : Uhuru) Y.Yamada
 * @Modified Date   : 2022.09.14
 * @Modified By     : Uhuru) Y.Yamada
 */
public without sharing class DataCategoryHelper {
    //======================================================
    // 変数定義
    //======================================================
    /** データカテゴリ格納リスト */
    private List<Schema.DataCategory> dataCategories;
    /** データカテゴリグループ名 */
    private String dataCategoryGroupName;
    /** 外部非公開データカテゴリMap */
    private Map<String, String> excludeDateCategories;

    /**
     * 指定した会社のデータカテゴリをJSON形式で取得する
     * @param String categoryGroupName カテゴリグループ名(一意の名前)
     * @return String データカテゴリ情報(JSON形式)
     */
    @AuraEnabled
    public static String getDataCategory(String categoryGroupName) {
        DataCategoryHelper helper = new DataCategoryHelper(categoryGroupName);
        if (helper.dataCategories.isEmpty()) {
            // データカテゴリ情報なし（コール元の引数エラー）
            return null;
        }

        // 返却用データカテゴリ情報
        List<DataCategoryHelper.CategoryInfo> categories = new List<DataCategoryHelper.CategoryInfo>();

        // コンストラクタで取得したカテゴリグループからカテゴリ情報を展開
        // TOPカテゴリ
        for (Schema.DataCategory topCategory : helper.dataCategories) {
            // サブカテゴリ情報格納用インスタンス生成
            List<DataCategoryHelper.SubCategoryInfo> subCategories = new List<DataCategoryHelper.SubCategoryInfo>();

            // TOPカテゴリに紐づくサブカテゴリ情報を展開
            for (Schema.DataCategory subCategory : topCategory.getChildCategories()) {
                // サブカテゴリ情報を格納 (外部非公開のデータカテゴリは除外)
                if (!helper.excludeDateCategories.containsKey(subCategory.getName())) {
                    subCategories.add(new DataCategoryHelper.SubCategoryInfo(subCategory.getLabel(), subCategory.getName()));
                }
            }

            // カテゴリ情報を格納（TOPカテゴリ配下のサブカテゴリが無い場合は除外）
            if (!subCategories.isEmpty()) {
                categories.add(new DataCategoryHelper.CategoryInfo(topCategory.getLabel(), topCategory.getName(), subCategories));
            }
        }
        return JSON.serializePretty(categories);
    }

    /**
     * 指定した会社のデータカテゴリ第一階層を取得する
     * @param String companyName 会社名(カテゴリグループ名)
     * @return List<String> データカテゴリ第一階層のカテゴリ名(Label)
     */
    public static List<String> getDataCategory1stLevel(String companyName) {
        // 指定会社の全データカテゴリ情報を取得
        DataCategoryHelper helper = new DataCategoryHelper(FaqConstants.CATEGORY_GROUP_LABELS.get(companyName));
        if (helper.dataCategories.isEmpty()) {
            // データカテゴリ情報なし（コール元の引数エラー）
            return null;
        }

        // 取得したデータカテゴリ情報から第一階層のカテゴリ名リストを作成
        List<String> categories = new List<String>();
        for (Schema.DataCategory topCategory : helper.dataCategories) {
            // サブカテゴリの件数をカウント
            Integer subCategoryCount = 0;
            for (Schema.DataCategory subCategory : topCategory.getChildCategories()) {
                if (!helper.excludeDateCategories.containsKey(subCategory.getName())) {
                    subCategoryCount++;
                }
            }

            // サブカテゴリが全て外部非公開のカテゴリは追加しない
            if (subCategoryCount > 0) {
                categories.add(topCategory.getLabel());
            }
        }

        return categories;
    }

    /**
     * 指定した会社と第一階層カテゴリ名のデータカテゴリ第二階層を取得する
     * @param String companyName 会社名(カテゴリグループ名)
     * @param String categoryLabel データカテゴリ第一階層のカテゴリ名(Label)
     * @return List<String> データカテゴリ第二階層のカテゴリ名(Label)
     */
    public static List<String> getDataCategory2ndLevel(String companyName, String categoryLabel) {
        // 指定会社の全データカテゴリ情報を取得
        DataCategoryHelper helper = new DataCategoryHelper(FaqConstants.CATEGORY_GROUP_LABELS.get(companyName));
        if (helper.dataCategories.isEmpty()) {
            // データカテゴリ情報なし（コール元の引数エラー）
            return null;
        }

        // 第一階層のカテゴリ情報を展開
        List<String> categories = new List<String>();
        for (Schema.DataCategory topCategory : helper.dataCategories) {
            // 指定した第一階層のカテゴリ名に一致した第二階層情報のみ展開
            if (topCategory.getLabel() == categoryLabel) {
                // 取得したデータカテゴリ情報から第二階層のカテゴリ名リストを作成
                for (Schema.DataCategory subCategory : topCategory.getChildCategories()) {
                    // 外部非公開のサブカテゴリは追加しない
                    if (!helper.excludeDateCategories.containsKey(subCategory.getName())) {
                        categories.add(subCategory.getLabel());
                    }
                }
            }
        }

        return categories;
    }

    /**
     * 指定した会社と第一階層カテゴリ名のデータカテゴリ第二階層の情報を取得する
     * @param String companyName 会社名(カテゴリグループ名)
     * @param String categoryLabel データカテゴリ第一階層のカテゴリ名(Label)
     * @return String 第二階層データカテゴリ情報(JSON形式)
     */
    @AuraEnabled
    public static String getSubCategoryInfo(String companyName, String categoryLabel) {
        // 指定会社の全データカテゴリ情報を取得
        DataCategoryHelper helper = new DataCategoryHelper(FaqConstants.CATEGORY_GROUP_LABELS.get(companyName));
        if (helper.dataCategories.isEmpty()) {
            // データカテゴリ情報なし（コール元の引数エラー）
            return null;
        }

        // 第一階層のカテゴリ情報を展開
        List<SubCategoryInfo> subCategories = new List<SubCategoryInfo>();
        for (Schema.DataCategory topCategory : helper.dataCategories) {
            // 指定した第一階層のカテゴリ名に一致した第二階層情報のみ展開
            if (topCategory.getLabel() == categoryLabel) {
                // 取得したデータカテゴリ情報から第二階層のカテゴリ名リストを作成
                for (Schema.DataCategory subCategory : topCategory.getChildCategories()) {
                    // 外部非公開のサブカテゴリは追加しない
                    if (!helper.excludeDateCategories.containsKey(subCategory.getName())) {
                        subCategories.add(new SubCategoryInfo(subCategory.getLabel(), subCategory.getName()));
                    }
                }
            }
        }

        return JSON.serializePretty(subCategories);
    }

    /**
     * コンストラクタ 全カテゴリグループをMapに格納
     * @param String categoryGroupName カテゴリグループ名(一意の名前)
     */
    public DataCategoryHelper(String categoryGroupName) {
        // 変数初期化
        dataCategories = new List<Schema.DataCategory>();
        excludeDateCategories = new Map<String, String>();

        // 引数チェック
        dataCategoryGroupName = categoryGroupName;
        if (FaqConstants.CATEGORY_GROUP_NAMES.containsKey(dataCategoryGroupName)) {
            // 引数で指定された会社のカテゴリグループ情報
            DataCategoryGroupSobjectTypePair pair = new DataCategoryGroupSobjectTypePair();
            pair.setSobject(FaqConstants.KNOWLEDGE_ARTICLE_VERSION);
            pair.setDataCategoryGroupName(dataCategoryGroupName);

            // カテゴリグループ取得
            List<Schema.DescribeDataCategoryGroupStructureResult> results = Schema.describeDataCategoryGroupStructures(new List<DataCategoryGroupSobjectTypePair> {pair}, false);

            // 取得したカテゴリグループの第二階層データカテゴリをListに格納
            // results : カテゴリグループ 環境設定不備以外、取得できる前提で取得件数は1件以外ありえない
            // getTopCategories : カテゴリグループの第一階層データカテゴリ (カテゴリグループ作成時デフォルトの「すべて」の1件のみ 「すべて」と同階層のカテゴリは無い)
            dataCategories = results.get(0).getTopCategories().get(0).getChildCategories();

            // 外部非公開データカテゴリ情報を取得
            List<FaqPrivateDataCategorySetting__mdt> privateCategories = getFaqPrivateDataCategorySettingMdt(FaqConstants.CATEGORY_GROUP_NAMES.get(dataCategoryGroupName));
            if (!privateCategories.isEmpty()) {
                for (FaqPrivateDataCategorySetting__mdt mdt : privateCategories) {
                    excludeDateCategories.put(mdt.DeveloperName, mdt.DeveloperName);
                }
            }
        }
    }

    /**
     * Knowledge__DataCategorySelectionを公開中の全件(1会社分)取得する
     * ※DataCategoryGroupName、DataCategoryNameをWHERE句の条件に使えない
     * @param なし
     * @return List<Knowledge__DataCategorySelection> 取得したKnowledge__DataCategorySelectionレコード
     */
    public List<Knowledge__DataCategorySelection> getKnowledgeDataCategorySelection() {
        return [
            SELECT
                ParentId,
                DataCategoryName
            FROM
                Knowledge__DataCategorySelection
            WHERE
                    Parent.PublishStatus = :FaqConstants.PUBLISH_STATUS_ONLINE
                AND Parent.Language = :FaqConstants.LANGUAGE_JA
                AND Parent.IsVisibleInPkb = true
                AND Parent.DataCategoryGroup__c = :FaqConstants.CATEGORY_GROUP_NAMES.get(dataCategoryGroupName)
        ];
    }

    /**
     * クラス変数「データカテゴリ格納リスト」のGetter
     * @param なし
     * @return List<Schema.DataCategory> クラス変数「データカテゴリ格納リスト」
     */
    public List<Schema.DataCategory> getDataCategories() {
        return dataCategories;
    }

    /**
     * カスタムメタデータ「FAQ外部非公開データカテゴリ設定」を取得する
     * @param String companyName 会社名
     * @return List<FaqPrivateDataCategorySetting__mdt> 取得したカスタムメタデータ「FAQ外部非公開データカテゴリ設定」
     */
    @testVisible
    private List<FaqPrivateDataCategorySetting__mdt> getFaqPrivateDataCategorySettingMdt(String companyName) {
        return [
            SELECT
                DeveloperName
            FROM
                FaqPrivateDataCategorySetting__mdt
            WHERE
                CategoryGroupName__c = :companyName
        ];
    }

    //======================================================
    // インナークラス定義
    //======================================================
    /**
     * カテゴリ情報用インナークラス
     */
    public class CategoryInfo {
        /** データカテゴリ名 */
        private String categoryName;
        /** データカテゴリ名（一意の名前） */
        private String categoryApiName;
        /** サブカテゴリ情報 */
        private List<SubCategoryInfo> subCategories;

        /**
         * コンストラクタ
         * @param String categoryName データカテゴリ名
         * @param String categoryApiName データカテゴリ名（一意の名前）
         * @param List<SubCategoryInfo> subCategories サブカテゴリ情報
         */
        public CategoryInfo(String categoryName, String categoryApiName, List<SubCategoryInfo> subCategories) {
            this.categoryName = categoryName;
            this.categoryApiName = categoryApiName;
            this.subCategories = subCategories;
        }
    }

    /**
     * サブカテゴリ情報用インナークラス
     */
    public class SubCategoryInfo {
        /** データカテゴリ名 */
        private String categoryName;
        /** データカテゴリ名（一意の名前） */
        private String categoryApiName;
 
        /**
         * コンストラクタ
         * @param String categoryName データカテゴリ名
         * @param String categoryApiName データカテゴリ名（一意の名前）
         */
        public SubCategoryInfo(String categoryName, String categoryApiName) {
            this.categoryName = categoryName;
            this.categoryApiName = categoryApiName;
        }
    }
}