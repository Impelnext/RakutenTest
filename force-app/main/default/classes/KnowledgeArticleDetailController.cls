/**
 * @Class Name      : KnowledgeArticleDetailController 
 * @Description     : ナレッジ記事詳細コントローラ
 * @Created Date    : 2022.07.28
 * @Created By      : Uhuru) N.Hashi
 */
public class KnowledgeArticleDetailController {
    /**
     * ナレッジより記事タイトルとテキストを取得
     * @param String urlName URL名
     * @return Knowledge__kav ナレッジオブジェクトレコード
     */
    @AuraEnabled
    public static Knowledge__kav getArticleDetail( String urlName ) {
        List<Knowledge__kav> articleList = [
            SELECT Title, Question__c, Answer__c
            FROM Knowledge__kav
            WHERE PublishStatus = 'online'
            AND IsVisibleInPkb = true
            AND urlName = :urlName
        ];

        if ( articleList.isEmpty() ) return null;
        return articleList[0];
    }
}