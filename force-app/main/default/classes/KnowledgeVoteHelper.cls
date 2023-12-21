/**
 * @Class Name      : KnowledgeVoteHelper 
 * @Description     : ナレッジお客様投票ヘルパークラス
 * @Created Date    : 2022.07.25
 * @Created By      : Uhuru) Y.Yamada
 * @Modified Date   : 2022.09.15
 * @Modified By     : Uhuru) Y.Yamada
 */
public without sharing class KnowledgeVoteHelper {
    /**
     * ナレッジお客様投票の高評価を登録・更新(upsert)する
     * @param Id knowledgeId ナレッジId
     * @return なし
     */
    @AuraEnabled
    public static void upsertGoodCount(Id knowledgeId) {
        // ナレッジお客様投票を登録・更新メソッドをコール
        Id knowledgeVoteId = upsertKnowledgeVote(knowledgeId, true);
    }

    /**
     * ナレッジお客様投票の低評価を登録・更新(upsert)する
     * @param Id knowledgeId ナレッジId
     * @return Id 登録・更新したナレッジお客様投票レコードId
     */
    @AuraEnabled
    public static Id upsertBadCount(Id knowledgeId) {
        // ナレッジお客様投票を登録・更新メソッドをコールし、ナレッジお客様投票IDを返却
        return upsertKnowledgeVote(knowledgeId, false);
    }

    /**
     * ナレッジ(ナレッジお客様投票)の高評価数を取得する
     * @param Id knowledgeId ナレッジId
     * @return Integer 高評価数
     */
    @AuraEnabled
    public static Integer getGoodCount(Id knowledgeId) {
        // 引数のナレッジIDからナレッジを取得
        Knowledge__kav kav = KnowledgeHelper.getKnowledgeById(knowledgeId);
        if (kav == null) {
            return FaqConstants.DEFAULT_COUNT_VALUE;
        }

        // 取得したナレッジの記事番号からナレッジお客様投票を取得
        KnowledgeVote__c vote = getKnowledgeVoteByArticleNumber(kav.ArticleNumber);
        return vote == null ? FaqConstants.DEFAULT_COUNT_VALUE : Integer.valueOf(vote.GoodCount__c);
    }

    /**
     * 指定した会社名に一致するナレッジお客様投票を取得する
     * @param String categoryGroupName カテゴリグループ名(一意の名前)
     * @return List<KnowledgeVote__c> ナレッジお客様投票
     */
    public static List<KnowledgeVote__c> getKnowledgeVoteByCategoryGroupName(String categoryGroupName) {
        return [
            SELECT
                Id,
                GoodCount__c,
                BadCount__c,
                TotalCount__c, 
                ArticleNumber__c
            FROM
                KnowledgeVote__c
            WHERE
                Company__c = :FaqConstants.CATEGORY_GROUP_NAMES.get(categoryGroupName)
            ORDER BY
                TotalCount__c DESC,
                GoodCount__c DESC,
                LastModifiedDate DESC
        ];
    }

    /**
     * ナレッジお客様投票を登録・更新(upsert)する
     * @param Id knowledgeId ナレッジId
     * @param Boolean isGood true:はいボタン押下／false:いいえボタン押下
     * @return Id 登録・更新したナレッジお客様投票レコードId
     */
    @testVisible
    private static Id upsertKnowledgeVote(Id knowledgeId, Boolean isGood) {
        // 引数のナレッジIDからナレッジを取得
        Knowledge__kav kav = KnowledgeHelper.getKnowledgeById(knowledgeId);
        if (kav == null) {
            return null;
        }

        // 取得したナレッジのレコードから記事番号・会社・質問の値を取得
        String articleNumber = kav.ArticleNumber;
        String company = kav.DataCategoryGroup__c;
        String question = kav.Question__c;

        // ナレッジの記事番号からナレッジお客様投票を取得
        KnowledgeVote__c upsertVoteRecord = getKnowledgeVoteByArticleNumber(articleNumber);

        // 新規登録or更新するナレッジお客様投票の値を設定
        if (upsertVoteRecord == null) {
            // 新規登録データ
            upsertVoteRecord = new KnowledgeVote__c(
                ArticleNumber__c = articleNumber,
                Company__c = company,
                Question__c = question,
                GoodCount__c = isGood ? FaqConstants.INIT_COUNT_VALUE : FaqConstants.DEFAULT_COUNT_VALUE,
                BadCount__c = isGood ? FaqConstants.DEFAULT_COUNT_VALUE : FaqConstants.INIT_COUNT_VALUE
            );
        } else {
            // 更新データ
            upsertVoteRecord.Company__c = company;
            upsertVoteRecord.Question__c = question;
            upsertVoteRecord.GoodCount__c += isGood ? FaqConstants.INIT_COUNT_VALUE : FaqConstants.DEFAULT_COUNT_VALUE;
            upsertVoteRecord.BadCount__c += isGood ? FaqConstants.DEFAULT_COUNT_VALUE : FaqConstants.INIT_COUNT_VALUE;
        }

        // UPSERT実行
        upsert upsertVoteRecord ArticleNumber__c;

        return upsertVoteRecord.Id;
    }

    /**
     * 記事番号をキーにナレッジお客様投票を取得する
     * @param String articleNumber ナレッジの記事番号
     * @return KnowledgeVote__c ナレッジお客様投票オブジェクトレコード
     */
    @testVisible
    private static KnowledgeVote__c getKnowledgeVoteByArticleNumber(String articleNumber) {
        List<KnowledgeVote__c> votes = [
            SELECT
                Id,
                ArticleNumber__c,
                Question__c,
                Company__c,
                GoodCount__c,
                BadCount__c
            FROM
                KnowledgeVote__c
            WHERE
                ArticleNumber__c = :articleNumber
        ];

        return votes.isEmpty() ? null : votes.get(0);
    }
}