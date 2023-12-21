/**
 * @Class Name      : DataCategoryHelperTest 
 * @Description     : データカテゴリ取得ヘルパークラスのテストクラス
 * @Created Date    : 2022.11.24
 * @Created By      : Uhuru) Y.Yamada
 * @Modified Date   : 2022.11.24
 * @Modified By     : Uhuru) Y.Yamada
 */
@isTest
public with sharing class DataCategoryHelperTest {
    /**
     * getDataCategoryメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_getDataCategoryTest() {
        // テストデータ
        // なし

        // テスト実行
        Test.startTest();
            // 取得できる正常系
            String actual1 = DataCategoryHelper.getDataCategory('CategoryGroupLife');
            String actual2 = DataCategoryHelper.getDataCategory('CategoryGroupInsurance');
            String actual3 = DataCategoryHelper.getDataCategory('CategoryGroupPet');
            // 取得できない異常系
            String actual4 = DataCategoryHelper.getDataCategory('rakutenIC');
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(true, String.isNotBlank(actual1));
        System.assertEquals(true, String.isNotBlank(actual2));
        System.assertEquals(true, String.isNotBlank(actual3));
        System.assertEquals(true, String.isBlank(actual4));
    }

    /**
     * getDataCategory1stLevelメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_getDataCategory1stLevelTest() {
        // テストデータ
        // なし

        // テスト実行
        Test.startTest();
            // 取得できる正常系
            List<String> actual1 = DataCategoryHelper.getDataCategory1stLevel('楽天生命');
            List<String> actual2 = DataCategoryHelper.getDataCategory1stLevel('楽天損保');
            List<String> actual3 = DataCategoryHelper.getDataCategory1stLevel('楽天ペット保険');
            // 取得できない異常系
            List<String> actual4 = DataCategoryHelper.getDataCategory1stLevel('損保');
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(false, actual1.isEmpty());
        System.assertEquals(false, actual2.isEmpty());
        System.assertEquals(false, actual3.isEmpty());
        System.assertEquals(null, actual4);
    }

    /**
     * getDataCategory2ndLevelメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_getDataCategory2ndLevelTest() {
        // テストデータ
        // なし

        // テスト実行
        Test.startTest();
            // 取得できる正常系
            List<String> actual1 = DataCategoryHelper.getDataCategory2ndLevel('楽天生命', '各種お手続き');
            List<String> actual2 = DataCategoryHelper.getDataCategory2ndLevel('楽天損保', '商品・補償内容');
            List<String> actual3 = DataCategoryHelper.getDataCategory2ndLevel('楽天ペット保険', '各種手続き');
            // 取得できない異常系
            List<String> actual4 = DataCategoryHelper.getDataCategory2ndLevel('損保', '自賠責');
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(false, actual1.isEmpty());
        System.assertEquals(false, actual2.isEmpty());
        System.assertEquals(false, actual3.isEmpty());
        System.assertEquals(null, actual4);
    }

    /**
     * getSubCategoryInfoメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_getSubCategoryInfoTest() {
        // テストデータ
        // なし

        // テスト実行
        Test.startTest();
            // 取得できる正常系
            String actual1 = DataCategoryHelper.getSubCategoryInfo('楽天生命', '各種お手続き');
            String actual2 = DataCategoryHelper.getSubCategoryInfo('楽天損保', '商品・補償内容');
            String actual3 = DataCategoryHelper.getSubCategoryInfo('楽天ペット保険', '各種手続き');
            // 取得できない異常系
            String actual4 = DataCategoryHelper.getSubCategoryInfo('損保', '自賠責');
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(true, String.isNotBlank(actual1));
        System.assertEquals(true, String.isNotBlank(actual2));
        System.assertEquals(true, String.isNotBlank(actual3));
        System.assertEquals(true, String.isBlank(actual4));
    }

    /**
     * getKnowledgeDataCategorySelectionメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_getKnowledgeDataCategorySelectionTest() {
        // テストデータ
        DataCategoryHelper helper = new DataCategoryHelper('CategoryGroupLife');

        // テスト実行
        Test.startTest();
            List<Knowledge__DataCategorySelection> actual = helper.getKnowledgeDataCategorySelection();
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(true, actual.isEmpty());
    }

    /**
     * getDataCategoriesメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void publicMethod_getDataCategoriesTest() {
        // テストデータ
        // 取得できる正常系
        DataCategoryHelper helper1 = new DataCategoryHelper('CategoryGroupLife');
        DataCategoryHelper helper2 = new DataCategoryHelper('CategoryGroupInsurance');
        DataCategoryHelper helper3 = new DataCategoryHelper('CategoryGroupPet');
        // 取得できない異常系
        DataCategoryHelper helper4 = new DataCategoryHelper('rakutenIC');

        // テスト実行
        Test.startTest();
            List<Schema.DataCategory> actual1 = helper1.getDataCategories();
            List<Schema.DataCategory> actual2 = helper2.getDataCategories();
            List<Schema.DataCategory> actual3 = helper3.getDataCategories();
            List<Schema.DataCategory> actual4 = helper4.getDataCategories();
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(false, actual1.isEmpty());
        System.assertEquals(false, actual2.isEmpty());
        System.assertEquals(false, actual3.isEmpty());
        System.assertEquals(true, actual4.isEmpty());
    }

    /**
     * getFaqPrivateDataCategorySettingMdtメソッドのテスト
     * コードカバレッジ率目的のテスト実行
     */
    @isTest
    static void privateMethod_getFaqPrivateDataCategorySettingMdtTest() {
        // テストデータ
        // 取得できる正常系
        DataCategoryHelper helper1 = new DataCategoryHelper('CategoryGroupLife');
        DataCategoryHelper helper2 = new DataCategoryHelper('CategoryGroupInsurance');
        DataCategoryHelper helper3 = new DataCategoryHelper('CategoryGroupPet');
        // 取得できない異常系
        DataCategoryHelper helper4 = new DataCategoryHelper('rakutenIC');

        // テスト実行
        Test.startTest();
            // 取得できる正常系
            List<FaqPrivateDataCategorySetting__mdt> actual1 = helper1.getFaqPrivateDataCategorySettingMdt('楽天生命');
            List<FaqPrivateDataCategorySetting__mdt> actual2 = helper2.getFaqPrivateDataCategorySettingMdt('楽天損保');
            List<FaqPrivateDataCategorySetting__mdt> actual3 = helper3.getFaqPrivateDataCategorySettingMdt('楽天ペット保険');
            // 取得できない異常系
            List<FaqPrivateDataCategorySetting__mdt> actual4 = helper4.getFaqPrivateDataCategorySettingMdt('損保');
        Test.stopTest();

        // テスト結果検証
        System.assertEquals(false, actual1.isEmpty());
        System.assertEquals(false, actual2.isEmpty());
        System.assertEquals(false, actual3.isEmpty());
        System.assertEquals(true, actual4.isEmpty());
    }
}