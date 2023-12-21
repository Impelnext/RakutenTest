/**
 * @Class Name      : KnowledgeVoteBadReasonHelperTest 
 * @Description     : ナレッジお客様投票低評価理由ヘルパークラスのテストクラス
 * @Created Date    : 2022.11.24
 * @Created By      : Uhuru) Y.Yamada
 * @Modified Date   : 2022.11.24
 * @Modified By     : Uhuru) Y.Yamada
 */
@isTest
public with sharing class KnowledgeVoteBadReasonHelperTest {
    /**
     * insertBadReasonメソッドのテスト (正常系)
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_insertBadReasonTest() {
        // テストデータ
        KnowledgeVote__c kv = new KnowledgeVote__c(
            Company__c = '楽天生命',
            ArticleNumber__c = '0000000001',
            Question__c = 'KnowledgeVoteBadReasonHelperTest',
            GoodCount__c = 0,
            BadCount__c = 1
        );
        insert kv;

        // テスト実行
        Test.startTest();
            KnowledgeVoteBadReasonHelper.insertBadReason(kv.Id, kv.Question__c);
            KnowledgeVoteBadReason__c actual = [SELECT Id, Name, KnowledgeVote__c, BadReason__c, VoteDate__c FROM KnowledgeVoteBadReason__c LIMIT 1];
        Test.stopTest();
        
        // テスト結果検証
        System.assertEquals(kv.Id, actual.KnowledgeVote__c);
        System.assertEquals(kv.Question__c, actual.BadReason__c);
        System.assertEquals(Date.today(), actual.VoteDate__c);
    }

    /**
     * insertBadReasonメソッドのテスト (異常系)
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_insertBadReasonTest_NG() {
        // テストデータ
        KnowledgeVote__c kv = new KnowledgeVote__c(
            Company__c = '楽天生命',
            ArticleNumber__c = '0000000001',
            Question__c = 'KnowledgeVoteBadReasonHelperTest',
            GoodCount__c = 0,
            BadCount__c = 1
        );
        insert kv;

        // テスト実行
        Test.startTest();
            KnowledgeVoteBadReasonHelper.insertBadReason(null, kv.Question__c);
            List<KnowledgeVoteBadReason__c> actuals = [SELECT Id, Name, KnowledgeVote__c, BadReason__c, VoteDate__c FROM KnowledgeVoteBadReason__c LIMIT 1];
        Test.stopTest();
        
        // テスト結果検証
        System.assertEquals(true, actuals.isEmpty());
    }
}