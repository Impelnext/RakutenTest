/**
 * @Class Name      : KnowledgeHelperTest 
 * @Description     : ナレッジヘルパークラスのテストクラス
 * @Created Date    : 2022.11.25
 * @Created By      : Uhuru) Y.Yamada
 * @Modified Date   : 2022.11.25
 * @Modified By     : Uhuru) Y.Yamada
 */
@isTest
public with sharing class KnowledgeHelperTest {
    /**
     * getKnowledgeメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_getKnowledgeTest() {
        // テストデータ
        // なしの為、取得件数が0として正常に処理される事を確認

        // テスト実行
        Test.startTest();
            List<Knowledge__kav> actual1 = KnowledgeHelper.getKnowledge('注目のご質問', 'CategoryGroupLife', 5, null);
            List<Knowledge__kav> actual2 = KnowledgeHelper.getKnowledge('よく読まれているご質問', 'CategoryGroupLife', 5, null);
            List<Knowledge__kav> actual3 = KnowledgeHelper.getKnowledge('サブカテゴリ', 'CategoryGroupLife', 0, 'CategoryLife0101');
            List<Knowledge__kav> actual4 = KnowledgeHelper.getKnowledge('検索結果', 'CategoryGroupLife', 0, 'Knowledge Helper Test');
            List<Knowledge__kav> actual5 = KnowledgeHelper.getKnowledge('KnowledgeHelperTest', 'CategoryGroupLife', 0, null);
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(new List<Knowledge__kav>(), actual1);
        System.assertEquals(new List<Knowledge__kav>(), actual2);
        System.assertEquals(new List<Knowledge__kav>(), actual3);
        System.assertEquals(new List<Knowledge__kav>(), actual4);
        System.assertEquals(null, actual5);
    }

    /**
     * getKnowledgeBy2ndLvCatLabelメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_getKnowledgeBy2ndLvCatLabelTest() {
        // テストデータ
        // なしの為、取得件数が0として正常に処理される事を確認

        // テスト実行
        Test.startTest();
            List<Knowledge__kav> actual = KnowledgeHelper.getKnowledgeBy2ndLvCatLabel('楽天生命', '各種お手続き', '改姓・改名');
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(new List<Knowledge__kav>(), actual);
    }

    /**
     * getKnowledgeBy2ndLvCatLabelメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_getKnowledgeBy2ndLvCatLabelTest_InvalidCategoryLabelLv2() {
        // テストデータ
        // なし

        // テスト実行
        Test.startTest();
            List<Knowledge__kav> actual = KnowledgeHelper.getKnowledgeBy2ndLvCatLabel('楽天生命', '各種お手続き', '改姓改名');
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(null, actual);
    }

    /**
     * getKnowledgeBy2ndLvCatLabelメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_getKnowledgeBy2ndLvCatLabelTest_InvalidCategoryLabelLv1() {
        // テストデータ
        // なし

        // テスト実行
        Test.startTest();
            List<Knowledge__kav> actual = KnowledgeHelper.getKnowledgeBy2ndLvCatLabel('楽天生命', '各種手続', '改姓・改名');
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(null, actual);
    }

    /**
     * getKnowledgeBy2ndLvCatLabelメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_getKnowledgeBy2ndLvCatLabelTest_InvalidCampanyName() {
        // テストデータ
        // なし

        // テスト実行
        Test.startTest();
            List<Knowledge__kav> actual = KnowledgeHelper.getKnowledgeBy2ndLvCatLabel('損保', '自賠責', '運用');
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(null, actual);
    }

    /**
     * searchKnowledgeByCompanyメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_searchKnowledgeByCompanyTest() {
        // テストデータ
        // なしの為、取得件数が0として正常に処理される事を確認

        // テスト実行
        Test.startTest();
            List<Knowledge__kav> actual = KnowledgeHelper.searchKnowledgeByCompany(new List<String> {'てすと'}, 0, '楽天生命', 0);
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(new List<Knowledge__kav>(), actual);
    }

    /**
     * searchKnowledgeByCategoryメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_searchKnowledgeByCategoryTest() {
        // テストデータ
        // なしの為、取得件数が0として正常に処理される事を確認

        // テスト実行
        Test.startTest();
            List<Knowledge__kav> actual = KnowledgeHelper.searchKnowledgeByCategory(new List<String> {'てすと'}, 0, 'CategoryGroupLife');
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(new List<Knowledge__kav>(), actual);
    }

    /**
     * getKnowledgeByIdメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_getKnowledgeByIdTest() {
        // テストデータ
        // Knowledge__kav
        Knowledge__kav kav = new Knowledge__kav(
            Title = 'KnowledgeHelperTest1',
            UrlName = 'KnowledgeHelperTest1',
            Question__c = '高評価',
            Answer__c = '高評価',
            Language = 'ja',
            DataCategoryGroup__c = '楽天生命',
            IsVisibleInPkb = true,
            IsWatched__c = false
        );
        insert kav;
        List<Knowledge__kav> insertedKavs = [SELECT Id, Title, ArticleNumber, KnowledgeArticleId, Question__c, Answer__c FROM Knowledge__kav WHERE PublishStatus = 'Draft' AND Language = 'ja' AND Id = :kav.Id LIMIT 1];
        for (Knowledge__kav k : insertedKavs) {
            // ドラフト記事を公開
            KbManagement.PublishingService.publishArticle(String.valueOf(k.KnowledgeArticleId), true);
        }

        // テスト実行
        Test.startTest();
            Knowledge__kav actual = KnowledgeHelper.getKnowledgeById(insertedKavs.get(0).Id);
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(insertedKavs.get(0).Question__c, actual.Question__c);
        System.assertEquals(insertedKavs.get(0).Answer__c, actual.Answer__c);
    }

    /**
     * getKnowledgeByIdメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_getKnowledgeByIdTest_ResultNull() {
        // テストデータ
        // なしの為、取得件数が0として正常に処理される事を確認

        // テスト実行
        Test.startTest();
            Knowledge__kav actual = KnowledgeHelper.getKnowledgeById('ka0000000000000000');
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(null, actual);
    }

    /**
     * searchKnowledgeメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void privateMethod_searchKnowledgeTest() {
        // テストデータ
        // Knowledge__kav
        Knowledge__kav kav = new Knowledge__kav(
            Title = 'KnowledgeHelperTest1',
            UrlName = 'KnowledgeHelperTest1',
            Question__c = '高評価',
            Answer__c = '高評価',
            SecretSearchKeyword__c = 'CategoryGroupLife',
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
            Id[] fixedSearchResults = new Id[1];
            fixedSearchResults[0] = insertedKavs.get(0).Id;
            Test.setFixedSearchResults(fixedSearchResults);

            List<Knowledge__kav> actual = KnowledgeHelper.searchKnowledge(new List<String> {'高評価'}, 5, null, '楽天生命', 1);
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(true, actual.size() == 1);
    }

    /**
     * searchKnowledgeメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void privateMethod_searchKnowledgeTest_Exception() {
        // テストデータ
        /*
         * SOSL ステートメントの文字数制限は、
         * 組織で定義されている SOQL ステートメントの文字数制限に関連付けられます。
         * デフォルトでは、SOQL クエリおよび SOSL クエリは 100,000 文字を超えることはできません。
         * この最大長を超える SOSL ステートメントでは、API が MALFORMED_SEARCH 例外コードを返します。結果の行は返されません。
         * →これを利用してExceptionを通す
         */
        String malformedKeyword = '';
        for (Integer i = 0; i < 100000; i++) {
            malformedKeyword = malformedKeyword + 'a';
        }

        // テスト実行
        Test.startTest();
            List<Knowledge__kav> actual = KnowledgeHelper.searchKnowledge(new List<String> {malformedKeyword}, 5, 'CategoryGroupLife', '楽天生命', 1);
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(new List<Knowledge__kav>(), actual);
    }

    /**
     * searchKnowledgeメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void privateMethod_searchKnowledgeTest_Result0() {
        // テストデータ
        // なしの為、取得件数が0として正常に処理される事を確認

        // テスト実行
        Test.startTest();
            List<Knowledge__kav> actual = KnowledgeHelper.searchKnowledge(new List<String> {'てすと'}, 5, 'CategoryGroupLife', '楽天生命', 1);
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(new List<Knowledge__kav>(), actual);
    }

    /**
     * getKnowledgeForWatchedメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void privateMethod_getKnowledgeForWatchedTest() {
        // テストデータ
        // なしの為、取得件数が0として正常に処理される事を確認

        // テスト実行
        Test.startTest();
            List<Knowledge__kav> actual = KnowledgeHelper.getKnowledgeForWatched('CategoryGroupLife', 5);
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(new List<Knowledge__kav>(), actual);
    }

    /**
     * getKnowledgeForViewedメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void privateMethod_getKnowledgeForViewedTest() {
        // テストデータ
        // Knowledge__kav
        Knowledge__kav kav = new Knowledge__kav(
            Title = 'KnowledgeHelperTest1',
            UrlName = 'KnowledgeHelperTest1',
            Question__c = '高評価' ,
            Answer__c = '高評価' ,
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
            List<Knowledge__kav> actual1 = KnowledgeHelper.getKnowledgeForViewed('CategoryGroupLife', 1);
            List<Knowledge__kav> actual2 = KnowledgeHelper.getKnowledgeForViewed('CategoryGroupPet', 1);
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(true, actual1.size() == 1);
        System.assertEquals(new List<Knowledge__kav>(), actual2);
    }

    /**
     * getKnowledgeForSubCategoryメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void privateMethod_getKnowledgeForSubCategoryTest() {
        // テストデータ
        // なしの為、取得件数が0として正常に処理される事を確認

        // テスト実行
        Test.startTest();
            List<Knowledge__kav> actual = KnowledgeHelper.getKnowledgeForSubCategory('CategoryGroupLife', 'CategoryLife0101');
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(new List<Knowledge__kav>(), actual);
    }

    /**
     * getKnowledgeByArticleNumbersメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void privateMethod_getKnowledgeByArticleNumbersTest() {
        // テストデータ
        // なしの為、取得件数が0として正常に処理される事を確認

        // テスト実行
        Test.startTest();
            List<Knowledge__kav> actual = KnowledgeHelper.getKnowledgeByArticleNumbers(new List<String> {'0000000001'});
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(new List<Knowledge__kav>(), actual);
    }

    /**
     * escapeReservedCharsメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void privateMethod_escapeReservedCharsTest() {
        // テストデータ
        String base = '&|!{}[]()^~:+-*?';

        // テスト実行
        Test.startTest();
            String actual1 = KnowledgeHelper.escapeReservedChars(base);
            String actual2 = KnowledgeHelper.escapeReservedChars('');
            String actual3 = KnowledgeHelper.escapeReservedChars(null);
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(true, base.length() != actual1.length());
        System.assertEquals('', actual2);
        System.assertEquals('', actual3);
    }

    /**
     * getFaqSecretSearchKeywordByCompanyNameメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void privateMethod_getFaqSecretSearchKeywordByCompanyNameTest() {
        // テストデータ
        // なし

        // テスト実行
        Test.startTest();
            String actual1 = KnowledgeHelper.getFaqSecretSearchKeywordByCompanyName('楽天生命');
            String actual2 = KnowledgeHelper.getFaqSecretSearchKeywordByCompanyName('CategoryGroupLife');
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(true, String.isNotBlank(actual1));
        System.assertEquals(true, String.isBlank(actual2));
    }

    /**
     * getFaqSecretSearchKeywordByCategoryGroupNameメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void privateMethod_getFaqSecretSearchKeywordByCategoryGroupNameTest() {
        // テストデータ
        // なし

        // テスト実行
        Test.startTest();
            String actual1 = KnowledgeHelper.getFaqSecretSearchKeywordByCategoryGroupName('CategoryGroupLife');
            String actual2 = KnowledgeHelper.getFaqSecretSearchKeywordByCategoryGroupName('楽天生命');
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(true, String.isNotBlank(actual1));
        System.assertEquals(true, String.isBlank(actual2));
    }
}