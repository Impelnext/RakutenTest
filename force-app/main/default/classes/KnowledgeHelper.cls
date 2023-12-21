/**
 * @Class Name      : KnowledgeHelper 
 * @Description     : ナレッジヘルパークラス
 * @Created Date    : 2022.08.24
 * @Created By      : Uhuru) Y.Yamada
 * @Modified Date   : 2022.09.15
 * @Modified By     : Uhuru) Y.Yamada
 */
public without sharing class KnowledgeHelper {
    /**
     * QA一覧に表示するナレッジを取得する
     * @param String procName 取得処理名 (注目のご質問/よく読まれているご質問/サブカテゴリ/検索結果)
     * @param String categoryGroupName カテゴリグループ名（一意の名前）
     * @param Integer limitSize 最大取得件数 (0指定は無制限)
     * @param String option（null/サブカテゴリ名(一意の名前)/検索ワード）
     * @return List<Knowledge__kav> QA一覧に表示するナレッジ
     */
    @AuraEnabled
    public static List<Knowledge__kav> getKnowledge(String procName, String categoryGroupName, Integer limitSize, String option) {
        List<Knowledge__kav> kavs = new List<Knowledge__kav>();

        // 第一引数のパラメータを元にナレッジを取得
        // elseは第一引数のパラメータ不備による想定外ルート
        switch on procName {
            when '注目のご質問'           {kavs = getKnowledgeForWatched(categoryGroupName, limitSize);}
            when 'よく読まれているご質問' {kavs = getKnowledgeForViewed(categoryGroupName, limitSize);}
            when 'サブカテゴリ'           {kavs = getKnowledgeForSubCategory(categoryGroupName, option);}
            when '検索結果'               {kavs = searchKnowledgeByCategory(option.split(FaqConstants.CHAR_HALF_SPACE), limitSize, categoryGroupName);}
            when else                     {kavs = null;}
        }

        return kavs;
    }

    /**
     * 指定した会社と第二階層カテゴリ名配下のナレッジを取得する
     * @param String companyName 会社名(カテゴリグループ名)
     * @param String categoryLabelLv1 データカテゴリ第一階層のカテゴリ名(Label)
     * @param String categoryLabelLv2 データカテゴリ第二階層のカテゴリ名(Label)
     * @return List<Knowledge__kav> 指定したカテゴリ第二階層のナレッジ
     */
    public static List<Knowledge__kav> getKnowledgeBy2ndLvCatLabel(String companyName, String categoryLabelLv1, String categoryLabelLv2) {
        // 会社名の引数チェック
        if (!FaqConstants.CATEGORY_GROUP_LABELS.containsKey(companyName)) {
            return null;
        }

        // カテゴリグループ名(一意の値)
        String categoryGroupName = FaqConstants.CATEGORY_GROUP_LABELS.get(companyName);

        // カテゴリ名(Label)のAPI名(Name)を取得
        DataCategoryHelper helper = new DataCategoryHelper(categoryGroupName);
        String categoryNameLv1 = FaqConstants.CHAR_EMPTY;
        String categoryNameLv2 = FaqConstants.CHAR_EMPTY;
        for (Schema.DataCategory topCategory : helper.getDataCategories()) {
            if (topCategory.getLabel() == categoryLabelLv1) {
                categoryNameLv1 = topCategory.getName();
                for (Schema.DataCategory subCategory : topCategory.getChildCategories()) {
                    if (subCategory.getLabel() == categoryLabelLv2) {
                        // 第二階層のAPI名を特定
                        categoryNameLv2 = subCategory.getName();
                        break;
                    }
                }
            }

            // 第二階層のAPI名を特定できた時点で以降のループ処理をエスケープ
            if (String.isNotBlank(categoryNameLv2)) {
                break;
            }
        }

        // カテゴリ名を特定できない場合は処理終了
        if (String.isBlank(categoryNameLv1) || String.isBlank(categoryNameLv2)) {
            return null;
        }

        // サブカテゴリを指定したナレッジの取得結果を返却
        return getKnowledgeForSubCategory(categoryGroupName, categoryNameLv2);
    }

    /**
     * 会社を指定してキーワード検索でナレッジを取得する
     * 質問の文字数が引数の leftSize より多い場合は、leftSizeまで切取る
     * @param List<String> keywords 検索キーワード
     * @param Integer limitSize 最大取得件数
     * @param String companyName 会社名
     * @param Integer leftSize 質問の最大表示文字数
     * @return List<Knowledge__kav> キーワード検索でヒットしたナレッジ
     */
    public static List<Knowledge__kav> searchKnowledgeByCompany(List<String> keywords, Integer limitSize, String companyName, Integer leftSize) {
        // 検索用埋込ワードをkeywordに追加
        String secretSearchKeyword = getFaqSecretSearchKeywordByCompanyName(companyName);
        List<String> addedSearchKeywords = new List<String>();
        if (String.isNotBlank(secretSearchKeyword)) {
            addedSearchKeywords.add(secretSearchKeyword);
        }
        addedSearchKeywords.addAll(keywords);
        
        // パラメータを設定して共通メソッドをコール
        return searchKnowledge(addedSearchKeywords, limitSize, null, companyName, leftSize);
    }

    /**
     * データカテゴリグループ名を指定してキーワード検索でナレッジを取得する
     * @param List<String> keywords 検索キーワード
     * @param Integer limitSize 最大取得件数
     * @param String categoryGroupName カテゴリグループ名（一意の名前）
     * @return List<Knowledge__kav> キーワード検索でヒットしたナレッジ
     */
    public static List<Knowledge__kav> searchKnowledgeByCategory(List<String> keywords, Integer limitSize, String categoryGroupName) {
        // 検索用埋込ワードをkeywordに追加
        String secretSearchKeyword = getFaqSecretSearchKeywordByCategoryGroupName(categoryGroupName);
        List<String> addedSearchKeywords = new List<String>();
        if (String.isNotBlank(secretSearchKeyword)) {
            addedSearchKeywords.add(secretSearchKeyword);
        }
        addedSearchKeywords.addAll(keywords);

        // パラメータを設定して共通メソッドをコール
        return searchKnowledge(addedSearchKeywords, limitSize, categoryGroupName, null, FaqConstants.FULL_LENGTH);
    }

    /**
     * ナレッジIDをキーにナレッジを取得する
     * @param Id knowledgeId ナレッジId
     * @return Knowledge__kav ナレッジオブジェクトレコード
     */
    public static Knowledge__kav getKnowledgeById(Id knowledgeId) {
        List<Knowledge__kav> kavs = [
            SELECT
                Id,
                ArticleNumber,
                Question__c,
                Answer__c,
                DataCategoryGroup__c
            FROM
                Knowledge__kav
            WHERE
                    PublishStatus = :FaqConstants.PUBLISH_STATUS_ONLINE
                AND Language = :FaqConstants.LANGUAGE_JA
                AND IsVisibleInPkb = true
                AND Id = :knowledgeId
        ];

        return kavs.isEmpty() ? null : kavs.get(0);
    }

    /**
     * キーワード検索でナレッジを取得する
     * @param List<String> keywords 検索キーワード
     * @param Integer limitSize 最大取得件数
     * @param String categoryGroupName カテゴリグループ名（一意の名前）
     * @param String companyName 会社名
     * @param Integer leftSize 質問の最大表示文字数
     * @return List<Knowledge__kav> キーワード検索でヒットしたナレッジ
     */
    @testVisible
    private static List<Knowledge__kav> searchKnowledge(List<String> keywords, Integer limitSize, String categoryGroupName, String companyName, Integer leftSize) {
        List<Knowledge__kav> searchList = new List<Knowledge__kav>();

        try {
            // 引数に応じて動的にSOSLを作成
            String joinedKeyword = String.join(keywords, ' AND ');
            String sosl = FaqConstants.CHAR_EMPTY;
            sosl += 'FIND';
            sosl += '    {' + escapeReservedChars(joinedKeyword) + '}';
            sosl += ' IN ALL FIELDS RETURNING ' + FaqConstants.KNOWLEDGE_KAV + ' (';
            sosl += '    Id,';
            sosl += '    UrlName,';
            sosl += '    Question__c,';
            sosl += '    Answer__c';
            sosl += ' WHERE';
            sosl += '        PublishStatus = ' + FaqConstants.CHAR_SINGLE_QUARTO + FaqConstants.PUBLISH_STATUS_ONLINE + FaqConstants.CHAR_SINGLE_QUARTO;
            sosl += '    AND Language = ' + FaqConstants.CHAR_SINGLE_QUARTO + FaqConstants.LANGUAGE_JA + FaqConstants.CHAR_SINGLE_QUARTO;
            sosl += '    AND IsVisibleInPkb = true';
            if (String.isNotBlank(companyName)) {
                sosl += ' AND DataCategoryGroup__c = ' + FaqConstants.CHAR_SINGLE_QUARTO + companyName + FaqConstants.CHAR_SINGLE_QUARTO;
            }
            // sosl += ' ORDER BY';
            // sosl += '    ArticleTotalViewCount DESC';
            if (limitSize != 0) {
                sosl += ' LIMIT ' + String.valueOf(limitSize);
            }        
            sosl += ')';
            if (String.isNotBlank(categoryGroupName)) {
                sosl += ' WITH DATA CATEGORY ' + categoryGroupName + '__c BELOW ALL__c';
            }
            
            // 作成したSOSLを実行
            Search.SearchResults workResultList = Search.find(sosl);

            // 取得した結果から、Knowledge__kavのデータのみを抽出
            List<Search.SearchResult> workResult = workResultList.get(FaqConstants.KNOWLEDGE_KAV);
            for (Search.SearchResult result: workResult) {
                searchList.add((Knowledge__kav)result.getSObject());
            }

            // ナレッジの質問項目を指定の文字数分まで削る（0指定時は削らない）
            if (leftSize > FaqConstants.FULL_LENGTH) {
                for (Knowledge__kav kav : searchList) {
                    kav.Question__c = String.valueOf(kav.Question__c).left(leftSize); 
                }
            }
        } catch (Exception e) {
            // 空のListを返却する（検索結果0件として処理する）
        }
        
        return searchList;
    }

    /**
     * 注目のご質問用のナレッジを取得する
     * @param String categoryGroupName カテゴリグループ名(一意の名前)
     * @param Integer limitSize 取得件数
     * @return List<Knowledge__kav> 注目のご質問用のナレッジ
     */
    @testVisible
    private static List<Knowledge__kav> getKnowledgeForWatched(String categoryGroupName, Integer limitSize) {
        return [
            SELECT
                Id,
                Question__c,
                Answer__c
            FROM
                Knowledge__kav
            WHERE
                    PublishStatus = :FaqConstants.PUBLISH_STATUS_ONLINE
                AND Language = :FaqConstants.LANGUAGE_JA
                AND IsVisibleInPkb = true
                AND DataCategoryGroup__c = :FaqConstants.CATEGORY_GROUP_NAMES.get(categoryGroupName)
                AND IsWatched__c = true
            ORDER BY
                LastPublishedDate DESC
            LIMIT
                :limitSize
        ];
    }

    /**
     * よく読まれているご質問用のナレッジを取得する
     * @param String categoryGroupName カテゴリグループ名(一意の名前)
     * @param Integer limitSize 取得件数
     * @return List<Knowledge__kav> よく読まれているご質問用のナレッジ
     */
    @testVisible
    private static List<Knowledge__kav> getKnowledgeForViewed(String categoryGroupName, Integer limitSize) {
        // ナレッジお客様投票から総投票数順のナレッジ記事番号を取得
        List<KnowledgeVote__c> votes = KnowledgeVoteHelper.getKnowledgeVoteByCategoryGroupName(categoryGroupName);
        if (votes.isEmpty()) {
            return new List<Knowledge__kav>();
        }

        List<Knowledge__kav> sortedKavs = new List<Knowledge__kav>();
        Map<String, Knowledge__kav> kavMap = new Map<String, Knowledge__kav>();
        Integer getKnowledgeSize = 0;
        Integer voteIndex = 0;

        // アーカイブ済みを除く公開済みナレッジの取得が取得件数分完了するまで処理を繰り返す
        // このwhileループの最大ループ回数は引数「limitSize」となり、
        // 表示する件数の要件が「5」件となり、ループ内のクエリ発行でもガバナ制限に抵触しない
        while (true) {
            // 取得した記事番号をListに格納
            List<String> articleNumbers = new List<String>();
            for (Integer i = 0; i < (limitSize - getKnowledgeSize); i++) {
                articleNumbers.add(votes[voteIndex].ArticleNumber__c);
                voteIndex++;

                // 要取得件数が取得件数未満の場合でも、ナレッジお客様投票の取得数の上限に到達
                if (voteIndex == votes.size()) {
                    break;
                }
            }
            
            // 記事番号を指定してナレッジを取得
            List<Knowledge__kav> kavs = getKnowledgeByArticleNumbers(articleNumbers);
            getKnowledgeSize += kavs.size();

            // 取得したナレッジを記事番号をキーにしたMapに変換
            for (Knowledge__kav kav : kavs) {
                kavMap.put(kav.ArticleNumber, kav);
            }    

            // <ループ終了条件判定>
            // ①ナレッジお客様投票の取得レコード分のループが完走している
            // ②ナレッジの総取得が、取得制限数に達している
            // のいずれかを満たした場合
            if (voteIndex == votes.size() || getKnowledgeSize >= limitSize) {
                break;
            }
        }
        
        // 取得したナレッジをナレッジお客様投票の総投票数順にソート
        for (KnowledgeVote__c vote : votes) {
            if (kavMap.containsKey(vote.ArticleNumber__c)) {
                sortedKavs.add(kavMap.get(vote.ArticleNumber__c));
            }
        }

        return sortedKavs;
    }

    /**
     * 指定したサブカテゴリ配下のナレッジを取得する
     * @param String categoryGroupName カテゴリグループ名(一意の名前)
     * @param String subCategoryName サブカテゴリ名(一意の名前)
     * @return List<Knowledge__kav> 指定したサブカテゴリ配下のナレッジ
     */
    @testVisible
    private static List<Knowledge__kav> getKnowledgeForSubCategory(String categoryGroupName, String subCategoryName) {
        // クエリでカテゴリグループ名、データカテゴリ名を指定する場合は、__cを付ける必要があり、
        // WITH DATA CATEGORY はリテラルで記述する必要があるため、Stringでクエリを作成
        String soql = FaqConstants.CHAR_EMPTY;
        soql += 'SELECT';
        soql += '    Id,';
        soql += '    UrlName,';
        soql += '    Question__c,';
        soql += '    Answer__c';
        soql += ' FROM';
        soql += ' ' + FaqConstants.KNOWLEDGE_KAV;
        soql += ' WHERE';
        soql += '        PublishStatus = ' + FaqConstants.CHAR_SINGLE_QUARTO + FaqConstants.PUBLISH_STATUS_ONLINE + FaqConstants.CHAR_SINGLE_QUARTO;
        soql += '    AND Language = ' + FaqConstants.CHAR_SINGLE_QUARTO + FaqConstants.LANGUAGE_JA + FaqConstants.CHAR_SINGLE_QUARTO;
        soql += '    AND IsVisibleInPkb = true';
        soql += ' WITH DATA CATEGORY ' + categoryGroupName + '__c AT ' + subCategoryName + '__c';

        return Database.query(soql);
    }

    /**
     * 記事番号を指定してナレッジを取得する
     * @param List<String> articleNumbers 記事番号リスト
     * @return List<Knowledge__kav> 指定した記事番号に一致するナレッジ
     */
    @testVisible
    private static List<Knowledge__kav> getKnowledgeByArticleNumbers(List<String> articleNumbers) {
        return [
            SELECT
                Id,
                Question__c,
                Answer__c,
            	ArticleNumber
            FROM
                Knowledge__kav
            WHERE
                    PublishStatus = :FaqConstants.PUBLISH_STATUS_ONLINE
                AND Language = :FaqConstants.LANGUAGE_JA
                AND IsVisibleInPkb = true
                AND ArticleNumber IN :articleNumbers
        ];
    }

    /**
     * 検索ワード内の予約文字をエスケープ処理を行う
     * @param String target 検索ワード文字列
     * @return String エスケープ処理した検索ワード文字列
     */
    @testVisible
    private static String escapeReservedChars(String target) {
        if (String.isBlank(target)) {
            // return後の処理でのNullPointerException回避の為、空文字として返却
            return FaqConstants.CHAR_EMPTY;            
        }

        // 予約文字が検索ワードに含まれている場合は、"\"を付けてエスケープする
        // "*"、"?"は、ワイルドカードでの検索とみなし、エスケープしない（FaqConstants.RESERVED_CHARS内に含まれていない）
        for (String reservedChar : FaqConstants.RESERVED_CHARS) {
            target = target.replace(reservedChar, FaqConstants.CHAR_BACK_SLASH + reservedChar);
        }

        return target;
    }

    /**
     * カスタムメタデータ「保険会社別設定」から会社名をキーにFAQの埋込用検索ワードを取得する
     * @param String companyName 会社名
     * @return String FAQの埋込用検索ワード
     */
    @testVisible
    private static String getFaqSecretSearchKeywordByCompanyName(String companyName) {
        // カスタムメタデータ「保険会社別設定」を取得
        List<InsuranceCompanySet__mdt> insuranceCompanySets = [
            SELECT
                FaqSecretSearchKeyword__c
            FROM
                InsuranceCompanySet__mdt
            WHERE
                FaqCompanyName__c = :companyName
        ];

        // 取得結果から返却値を設定
        String secretSearchKeyword = FaqConstants.CHAR_EMPTY;
        if (!insuranceCompanySets.isEmpty()) {
            secretSearchKeyword = insuranceCompanySets.get(0).FaqSecretSearchKeyword__c;
        }

        return secretSearchKeyword;
    }

    /**
     * カスタムメタデータ「保険会社別設定」からカテゴリグループ名をキーにFAQの埋込用検索ワードを取得する
     * @param String categoryGroupName カテゴリグループ名(一意の名前)
     * @return String FAQの埋込用検索ワード
     */
    @testVisible
    private static String getFaqSecretSearchKeywordByCategoryGroupName(String categoryGroupName) {
        // カスタムメタデータ「保険会社別設定」を取得
        List<InsuranceCompanySet__mdt> insuranceCompanySets = [
            SELECT
                FaqSecretSearchKeyword__c
            FROM
                InsuranceCompanySet__mdt
            WHERE
                FaqDataCategoryGroupName__c = :categoryGroupName
        ];

        // 取得結果から返却値を設定
        String secretSearchKeyword = FaqConstants.CHAR_EMPTY;
        if (!insuranceCompanySets.isEmpty()) {
            secretSearchKeyword = insuranceCompanySets.get(0).FaqSecretSearchKeyword__c;
        }

        return secretSearchKeyword;
    }
}