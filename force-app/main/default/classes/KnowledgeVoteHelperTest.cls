/**
 * @Class Name      : KnowledgeVoteHelperTest 
 * @Description     : ナレッジお客様投票ヘルパークラスのテストクラス
 * @Created Date    : 2022.11.24
 * @Created By      : Uhuru) Y.Yamada
 * @Modified Date   : 2022.11.24
 * @Modified By     : Uhuru) Y.Yamada
 */
@isTest
public with sharing class KnowledgeVoteHelperTest {    
    /**
     * upsertGoodCountメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_upsertGoodCountTest() {
        // テストデータ
        // Knowledge__kav
        Knowledge__kav kav = new Knowledge__kav(
            Title = 'KnowledgeVoteHelperTest1',
            UrlName = 'KnowledgeVoteHelperTest1',
            Question__c = '高評価',
            Answer__c = '高評価',
            Language = 'ja',
            DataCategoryGroup__c = '楽天生命',
            IsVisibleInPkb = true,
            IsWatched__c = false
        );
        insert kav;
        List<Knowledge__kav> insertedKavs = [SELECT Id, Title, ArticleNumber, KnowledgeArticleId, Question__c FROM Knowledge__kav WHERE PublishStatus = 'Draft' AND Language = 'ja' AND Id = :kav.Id LIMIT 1];
        for (Knowledge__kav k : insertedKavs) {
            // ドラフト記事を公開
            KbManagement.PublishingService.publishArticle(String.valueOf(k.KnowledgeArticleId), true);
        }
        
        // KnowledgeVote__c
        insert new KnowledgeVote__c(
            Company__c = '楽天生命',
            ArticleNumber__c = insertedKavs.get(0).ArticleNumber,
            Question__c = insertedKavs.get(0).Question__c,
            GoodCount__c = 1,
            BadCount__c = 0
        );

        // テスト実行
        Test.startTest();
            KnowledgeVoteHelper.upsertGoodCount(kav.Id);
            KnowledgeVote__c actual = [SELECT GoodCount__c, BadCount__c FROM KnowledgeVote__c LIMIT 1];
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(2, actual.GoodCount__c);
        System.assertEquals(0, actual.BadCount__c);
    }

    /**
     * upsertBadCountメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_upsertBadCountTest() {
        // テストデータ
        // Knowledge__kav
        Knowledge__kav kav = new Knowledge__kav(
            Title = 'KnowledgeVoteHelperTest1',
            UrlName = 'KnowledgeVoteHelperTest1',
            Question__c = '高評価',
            Answer__c = '高評価',
            Language = 'ja',
            DataCategoryGroup__c = '楽天生命',
            IsVisibleInPkb = true,
            IsWatched__c = false
        );
        insert kav;
        List<Knowledge__kav> insertedKavs = [SELECT Id, Title, ArticleNumber, KnowledgeArticleId, Question__c FROM Knowledge__kav WHERE PublishStatus = 'Draft' AND Language = 'ja' AND Id = :kav.Id LIMIT 1];
        for (Knowledge__kav k : insertedKavs) {
            // ドラフト記事を公開
            KbManagement.PublishingService.publishArticle(String.valueOf(k.KnowledgeArticleId), true);
        }

        // テスト実行
        Test.startTest();
            KnowledgeVoteHelper.upsertBadCount(kav.Id);
            KnowledgeVote__c actual = [SELECT GoodCount__c, BadCount__c FROM KnowledgeVote__c LIMIT 1];
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(0, actual.GoodCount__c);
        System.assertEquals(1, actual.BadCount__c);
    }

    /**
     * getGoodCountメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_getGoodCountTest() {
        // テストデータ
        // Knowledge__kav
        Knowledge__kav kav = new Knowledge__kav(
            Title = 'KnowledgeVoteHelperTest1',
            UrlName = 'KnowledgeVoteHelperTest1',
            Question__c = '高評価',
            Answer__c = '高評価',
            Language = 'ja',
            DataCategoryGroup__c = '楽天生命',
            IsVisibleInPkb = true,
            IsWatched__c = false
        );
        insert kav;
        List<Knowledge__kav> insertedKavs = [SELECT Id, Title, ArticleNumber, KnowledgeArticleId, Question__c FROM Knowledge__kav WHERE PublishStatus = 'Draft' AND Language = 'ja' AND Id = :kav.Id LIMIT 1];
        for (Knowledge__kav k : insertedKavs) {
            // ドラフト記事を公開
            KbManagement.PublishingService.publishArticle(String.valueOf(k.KnowledgeArticleId), true);
        }
        
        // KnowledgeVote__c
        insert new KnowledgeVote__c(
            Company__c = '楽天生命',
            ArticleNumber__c = insertedKavs.get(0).ArticleNumber,
            Question__c = insertedKavs.get(0).Question__c,
            GoodCount__c = 1,
            BadCount__c = 0
        );

        // テスト実行
        Test.startTest();
            Integer actual = KnowledgeVoteHelper.getGoodCount(kav.Id);
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(1, actual);
    }

    /**
     * getGoodCountメソッドのテスト (異常系：ナレッジが取得できない)
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_getGoodCountTest_KnowledgeIsNull() {
        // テストデータ
        // なし

        // テスト実行
        Test.startTest();
            Integer actual = KnowledgeVoteHelper.getGoodCount('ka0000000000000000');
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(0, actual);
    }

    /**
     * getGoodCountメソッドのテスト (異常系：ナレッジお客様投票が取得できない)
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_getGoodCountTest_KnowledgeVoteIsNull() {
        // テストデータ
        // Knowledge__kav
        Knowledge__kav kav = new Knowledge__kav(
            Title = 'KnowledgeVoteHelperTest1',
            UrlName = 'KnowledgeVoteHelperTest1',
            Question__c = '高評価',
            Answer__c = '高評価',
            Language = 'ja',
            DataCategoryGroup__c = '楽天生命',
            IsVisibleInPkb = true,
            IsWatched__c = false
        );
        insert kav;
        List<Knowledge__kav> insertedKavs = [SELECT Id, Title, ArticleNumber, KnowledgeArticleId, Question__c FROM Knowledge__kav WHERE PublishStatus = 'Draft' AND Language = 'ja' AND Id = :kav.Id LIMIT 1];
        for (Knowledge__kav k : insertedKavs) {
            // ドラフト記事を公開
            KbManagement.PublishingService.publishArticle(String.valueOf(k.KnowledgeArticleId), true);
        }
        
        // テスト実行
        Test.startTest();
            Integer actual = KnowledgeVoteHelper.getGoodCount(kav.Id);
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(0, actual);
    }

    /**
     * getKnowledgeVoteByCategoryGroupNameメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_getKnowledgeVoteByCategoryGroupNameTest() {
        // テストデータ
        // なし

        // テスト実行
        Test.startTest();
            List<KnowledgeVote__c> actual = KnowledgeVoteHelper.getKnowledgeVoteByCategoryGroupName('CategoryGroupLife');
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(new List<KnowledgeVote__c>(), actual);
    }

    /**
     * upsertKnowledgeVoteメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void privateMethod_upsertKnowledgeVoteTest() {
        // テストデータ
        // Knowledge__kav
        List<Knowledge__kav> kavs = new List<Knowledge__kav> {
            new Knowledge__kav(
                Title = 'KnowledgeVoteHelperTest1',
                UrlName = 'KnowledgeVoteHelperTest1',
                Question__c = '高評価',
                Answer__c = '高評価',
                Language = 'ja',
                DataCategoryGroup__c = '楽天生命',
                IsVisibleInPkb = true,
                IsWatched__c = false
            ),
            new Knowledge__kav(
                Title = 'KnowledgeVoteHelperTest2',
                UrlName = 'KnowledgeVoteHelperTest2',
                Question__c = '低評価',
                Answer__c = '低評価',
                Language = 'ja',
                DataCategoryGroup__c = '楽天生命',
                IsVisibleInPkb = true,
                IsWatched__c = false
            ),
            new Knowledge__kav(
                Title = 'KnowledgeVoteHelperTest3',
                UrlName = 'KnowledgeVoteHelperTest3',
                Question__c = '投票あり',
                Answer__c = '投票あり',
                Language = 'ja',
                DataCategoryGroup__c = '楽天生命',
                IsVisibleInPkb = true,
                IsWatched__c = false
            )
        };
        insert kavs;
        List<Id> kavIds = new List<Id>();
        for (Knowledge__kav kav : kavs) {
            kavIds.add(kav.Id);
        }
        List<Knowledge__kav> insertedKavs = [SELECT Id, Title, ArticleNumber, KnowledgeArticleId, Question__c FROM Knowledge__kav WHERE PublishStatus = 'Draft' AND Language = 'ja' AND Id IN :kavIds];
        for (Knowledge__kav kav : insertedKavs) {
            // ドラフト記事を公開
            KbManagement.PublishingService.publishArticle(String.valueOf(kav.KnowledgeArticleId), true);
        }
        
        // KnowledgeVote__c
        Id knowledgeId1;
        Id knowledgeId2;
        Id knowledgeId3;
        for (Knowledge__kav kav : insertedKavs) {
            if (kav.Title == 'KnowledgeVoteHelperTest1') {
                knowledgeId1 = kav.Id;
            } else if (kav.Title == 'KnowledgeVoteHelperTest2') {
                knowledgeId2 = kav.Id;
            } else if (kav.Title == 'KnowledgeVoteHelperTest3') {
                knowledgeId3 = kav.Id;
                // 投票されたデータとして作成（Updateで更新される用
                insert new KnowledgeVote__c(
                    Company__c = '楽天生命',
                    ArticleNumber__c = kav.ArticleNumber,
                    Question__c = kav.Question__c,
                    GoodCount__c = 1,
                    BadCount__c = 0
                );
            }
        } 

        // テスト実行
        Test.startTest();
            KnowledgeVoteHelper.upsertKnowledgeVote(knowledgeId1, true);
            KnowledgeVoteHelper.upsertKnowledgeVote(knowledgeId2, false);
            KnowledgeVoteHelper.upsertKnowledgeVote(knowledgeId3, true);
            List<KnowledgeVote__c> actuals = [SELECT Question__c, GoodCount__c, BadCount__c FROM KnowledgeVote__c];
        Test.stopTest();
        
        // テスト結果検証
        for (KnowledgeVote__c actual : actuals) {
            if (actual.Question__c == '高評価') {
                System.assertEquals(1, actual.GoodCount__c);
                System.assertEquals(0, actual.BadCount__c);
            } else if (actual.Question__c == '低評価') {
                System.assertEquals(0, actual.GoodCount__c);
                System.assertEquals(1, actual.BadCount__c);
            } else if (actual.Question__c == '投票あり') {
                System.assertEquals(2, actual.GoodCount__c);
                System.assertEquals(0, actual.BadCount__c);
            }
        }
    }

    /**
     * upsertKnowledgeVoteメソッドのテスト (異常系)
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void privateMethod_upsertKnowledgeVoteTest_KnowledgeIdIsNull() {
        // テストデータ
        // 必要なし

        // テスト実行
        Test.startTest();
            Id actual1 = KnowledgeVoteHelper.upsertKnowledgeVote('ka0000000000000000', true);
            Id actual2 = KnowledgeVoteHelper.upsertKnowledgeVote('ka0000000000000000', false);
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(null, actual1);
        System.assertEquals(null, actual2);
    }

    /**
     * getKnowledgeVoteByArticleNumberメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void privateMethod_getKnowledgeVoteByArticleNumberTest() {
        // テストデータ
        KnowledgeVote__c kv = new KnowledgeVote__c(
            Company__c = '楽天生命',
            ArticleNumber__c = '0000000001',
            Question__c = 'KnowledgeVoteHelperTest',
            GoodCount__c = 0,
            BadCount__c = 1
        );
        insert kv;

        // テスト実行
        Test.startTest();
            KnowledgeVote__c actual1 = KnowledgeVoteHelper.getKnowledgeVoteByArticleNumber(kv.ArticleNumber__c);
            KnowledgeVote__c actual2 = KnowledgeVoteHelper.getKnowledgeVoteByArticleNumber('0000000000');
        Test.stopTest();
        
        // テスト結果検証
        System.assertEquals(kv.Id, actual1.Id);
        System.assertEquals(kv.Company__c, actual1.Company__c);
        System.assertEquals(kv.ArticleNumber__c, actual1.ArticleNumber__c);
        System.assertEquals(kv.Question__c, actual1.Question__c);
        System.assertEquals(kv.GoodCount__c, actual1.GoodCount__c);
        System.assertEquals(kv.BadCount__c, actual1.BadCount__c);
        System.assertEquals(null, actual2);
    }
}