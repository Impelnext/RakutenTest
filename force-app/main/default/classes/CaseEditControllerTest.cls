@isTest
public class CaseEditControllerTest
{
    @isTest
    static void CaseEditControllerTest_ctrlClassPickListOptions()
    {
        //WebServiceを疑似コールアウト
        Test.setMock(HttpCalloutMock.class, new ZipUtilTest_HttpCalloutMock());

        PageReference pageRef = Page.CaseCustomEdit;
        Test.setCurrentPage(pageRef);

        CaseEditControllerTest controllerTest = new CaseEditControllerTest();
        insert controllerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert controllerTest.createCase();
        Case caseObj = [SELECT Id FROM Case LIMIT 1];
        insert controllerTest.createChildCase(account.Id, caseObj.Id);
        Case childCaseObj = [SELECT Id, ParentId, AccountId,RequestReference__c,RecordTypeId FROM Case WHERE ParentId != null];

        
        Test.startTest();

        // オブジェクトを渡してインスタンス化する
        ApexPages.StandardController stdController = new ApexPages.StandardController (childCaseObj);
        CaseEditController controller = new CaseEditController(stdController);

        controller.parentAccObj = account;

        // 対応区分選択リスト生成
        List<SelectOption> classOptions = controller.ctrlClassPickListOptions;
        // 対応種別選択リスト生成
        controller.caseObj.class__c = '共通異動';
        List<SelectOption> typeOptions = controller.depTypePickListOptions;
        // 発生源選択リスト生成
        List<SelectOption> originOptions = controller.ctrlOriginPickListOptions;
        // 状況選択リスト生成
        List<SelectOption> statusOptions = controller.ctrlStatusPickListOptions;

        // 住所変更フラグ取得
        controller.caseObj.type__c = '住所変更';
        Boolean inputAddressFlg = controller.getInputAddressFlg();
        // 郵便番号検索
        controller.caseObj.PostNumber__c = '2223333';
        PageReference searchPostalCodePageRef = controller.searchPostalCode();

        // 保存ボタン処理
        controller.caseObj.type__c = '電話番号変更';
        PageReference savePageRef = controller.doSave();

        Test.stopTest();
    }

    private account createAccount(){
        List<RecordType> recordTypes = [SELECT Id, Name 
                                        FROM   RecordType 
                                        WHERE  SobjectType = 'Account' 
                                        And    Name = '個人取引先' 
                                        ORDER BY Name ASC LIMIT 50];
        return new Account(
            LastName='個人',
            FirstName='取引先',
            furiganaLast__pc='ｺｼﾞﾝ',
            furiganaForst__pc='ﾄﾘﾋｷｻｷ',
            PersonMailingPostalCode='2223333',
            PersonMailingState='住所１',
            PersonMailingCity='住所２',
            PersonMailingStreet='住所３',
            RecordTypeId=recordTypes[0].Id
        );
    }
    private Case createCase(){
        return new Case(
            Origin='電話',
            Status='オープン',
            class__c='対応履歴',
            type__c='対応履歴'
        );
    }

    private Case createChildCase(Id accountId, Id caseId){
        return new Case(
            Origin='電話',
            Status='オープン',
            class__c='対応履歴',
            type__c='対応履歴',
            AccountId = accountId,
            ParentId= caseId
        );
    }
}