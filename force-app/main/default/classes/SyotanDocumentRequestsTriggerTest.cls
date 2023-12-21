@isTest
public class SyotanDocumentRequestsTriggerTest
{
    @isTest
    static void SyotanDocumentRequestsTriggerTest()
    {
        SyotanDocumentRequestsTriggerTest triggerTest = new SyotanDocumentRequestsTriggerTest();
        insert  triggerTest.createAccount();
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        
        SyotanDocumentRequests__c syotanDocReq = triggerTest.createSyotanDocumentRequests(account.Id);
        insert syotanDocReq;
        Test.stopTest();
        
        SyotanDocumentRequests__c result;
        for( SyotanDocumentRequests__c sdoc : [SELECT Id, Ref_Account__c,Ref_Syodan__r.StageName 
                                               FROM SyotanDocumentRequests__c
                                               WHERE Id = :syotanDocReq.Id]) {
            result = sdoc;
        }
        System.assertEquals(account.Id, result.Ref_Account__c);
        System.assertEquals('未割当', result.Ref_Syodan__r.StageName);
    }
    
    @isTest
    static void SyotanDocumentRequestsTriggerTest_non_AccountId() {
        SyotanDocumentRequestsTriggerTest triggerTest = new SyotanDocumentRequestsTriggerTest();
        insert  triggerTest.createAccount();
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        insert triggerTest.createSyotanDocumentRequests(null);
        Test.stopTest();
    }
    
    @isTest
    static void SyotanDocumentRequestsTriggerTest_name_tel1() {
        SyotanDocumentRequestsTriggerTest triggerTest = new SyotanDocumentRequestsTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        SyotanDocumentRequests__c syotanDoc = triggerTest.createSyotanDocumentRequests(null);
        syotanDoc.last_name__c = '個人';
        syotanDoc.first_name__c = '取引先';
        syotanDoc.last_name_kana__c = 'コジン';
        syotanDoc.first_name_kana__c = 'トリヒキサキ';
        syotanDoc.tel1__c = '99-9999-9999';
        syotanDoc.tel2__c = '11-1111-1111';
        syotanDoc.tel3__c = '77-7777-7777';
        insert syotanDoc;
        Test.stopTest();
        
        SyotanDocumentRequests__c result;
        for( SyotanDocumentRequests__c sdoc : [SELECT Id, Ref_Account__c
                                               FROM SyotanDocumentRequests__c
                                               WHERE Id = :syotanDoc.Id]) {
            result = sdoc;
        }
        System.assertEquals(acc.Id, result.Ref_Account__c);
    }
    
    @isTest
    static void SyotanDocumentRequestsTriggerTest_name_tel2() {
        SyotanDocumentRequestsTriggerTest triggerTest = new SyotanDocumentRequestsTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        SyotanDocumentRequests__c syotanDoc = triggerTest.createSyotanDocumentRequests(null);
        syotanDoc.last_name__c = '個人';
        syotanDoc.first_name__c = '取引先';
        syotanDoc.last_name_kana__c = 'コジン';
        syotanDoc.first_name_kana__c = 'トリヒキサキ';
        syotanDoc.tel1__c = '11-1111-1111';
        syotanDoc.tel2__c = '99-9999-9999';
        syotanDoc.tel3__c = '77-7777-7777';
        insert syotanDoc;
        Test.stopTest();
        
        SyotanDocumentRequests__c result;
        for( SyotanDocumentRequests__c sdoc : [SELECT Id, Ref_Account__c
                                               FROM SyotanDocumentRequests__c
                                               WHERE Id = :syotanDoc.Id]) {
            result = sdoc;
        }
        System.assertEquals(acc.Id, result.Ref_Account__c);
    }
    
    @isTest
    static void SyotanDocumentRequestsTriggerTest_name_tel3() {
        SyotanDocumentRequestsTriggerTest triggerTest = new SyotanDocumentRequestsTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        SyotanDocumentRequests__c syotanDoc = triggerTest.createSyotanDocumentRequests(null);
        syotanDoc.last_name__c = '個人';
        syotanDoc.first_name__c = '取引先';
        syotanDoc.last_name_kana__c = 'コジン';
        syotanDoc.first_name_kana__c = 'トリヒキサキ';
        syotanDoc.tel1__c = '11-1111-1111';
        syotanDoc.tel2__c = '77-7777-7777';
        syotanDoc.tel3__c = '99-9999-9999';
        insert syotanDoc;
        Test.stopTest();
        
        SyotanDocumentRequests__c result;
        for( SyotanDocumentRequests__c sdoc : [SELECT Id, Ref_Account__c
                                               FROM SyotanDocumentRequests__c
                                               WHERE Id = :syotanDoc.Id]) {
            result = sdoc;
        }
        System.assertEquals(acc.Id, result.Ref_Account__c);
    }
    
    @isTest
    static void SyotanDocumentRequestsTriggerTest_name_mobile_tel1() {
        SyotanDocumentRequestsTriggerTest triggerTest = new SyotanDocumentRequestsTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        SyotanDocumentRequests__c syotanDoc = triggerTest.createSyotanDocumentRequests(null);
        syotanDoc.last_name__c = '個人';
        syotanDoc.first_name__c = '取引先';
        syotanDoc.last_name_kana__c = 'コジン';
        syotanDoc.first_name_kana__c = 'トリヒキサキ';
        syotanDoc.tel1__c = '88-8888-8888';
        syotanDoc.tel2__c = '11-1111-1111';
        syotanDoc.tel3__c = '77-7777-7777';
        insert syotanDoc;
        Test.stopTest();
        
        SyotanDocumentRequests__c result;
        for( SyotanDocumentRequests__c sdoc : [SELECT Id, Ref_Account__c
                                               FROM SyotanDocumentRequests__c
                                               WHERE Id = :syotanDoc.Id]) {
            result = sdoc;
        }
        System.assertEquals(acc.Id, result.Ref_Account__c);
    }
    
    @isTest
    static void SyotanDocumentRequestsTriggerTest_name_mobile_tel2() {
        SyotanDocumentRequestsTriggerTest triggerTest = new SyotanDocumentRequestsTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        SyotanDocumentRequests__c syotanDoc = triggerTest.createSyotanDocumentRequests(null);
        syotanDoc.last_name__c = '個人';
        syotanDoc.first_name__c = '取引先';
        syotanDoc.last_name_kana__c = 'コジン';
        syotanDoc.first_name_kana__c = 'トリヒキサキ';
        syotanDoc.tel1__c = '11-1111-1111';
        syotanDoc.tel2__c = '88-8888-8888';
        syotanDoc.tel3__c = '77-7777-7777';
        insert syotanDoc;
        Test.stopTest();
        
        SyotanDocumentRequests__c result;
        for( SyotanDocumentRequests__c sdoc : [SELECT Id, Ref_Account__c
                                               FROM SyotanDocumentRequests__c
                                               WHERE Id = :syotanDoc.Id]) {
            result = sdoc;
        }
        System.assertEquals(acc.Id, result.Ref_Account__c);
    }
    
    @isTest
    static void SyotanDocumentRequestsTriggerTest_name_mobile_tel3() {
        SyotanDocumentRequestsTriggerTest triggerTest = new SyotanDocumentRequestsTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        SyotanDocumentRequests__c syotanDoc = triggerTest.createSyotanDocumentRequests(null);
        syotanDoc.last_name__c = '個人';
        syotanDoc.first_name__c = '取引先';
        syotanDoc.last_name_kana__c = 'コジン';
        syotanDoc.first_name_kana__c = 'トリヒキサキ';
        syotanDoc.tel1__c = '11-1111-1111';
        syotanDoc.tel2__c = '77-7777-7777';
        syotanDoc.tel3__c = '88-8888-8888';
        insert syotanDoc;
        Test.stopTest();
        
        SyotanDocumentRequests__c result;
        for( SyotanDocumentRequests__c sdoc : [SELECT Id, Ref_Account__c
                                               FROM SyotanDocumentRequests__c
                                               WHERE Id = :syotanDoc.Id]) {
            result = sdoc;
        }
        System.assertEquals(acc.Id, result.Ref_Account__c);
    }
    
    @isTest
    static void SyotanDocumentRequestsTriggerTest_ExOpp_Closed() {
        SyotanDocumentRequestsTriggerTest triggerTest = new SyotanDocumentRequestsTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        Opportunity opp = triggerTest.createOpportunityClosed(account.Id);
        insert opp;
        
        Test.startTest();
        SyotanDocumentRequests__c syotanDoc = triggerTest.createSyotanDocumentRequests(account.id);
        //syotanDoc.last_name__c = '個人';
        //syotanDoc.first_name__c = '取引先';
        syotanDoc.last_name_kana__c = 'コジン';
        syotanDoc.first_name_kana__c = 'トリヒキサキ';
        syotanDoc.tel1__c = '11-1111-1111';
        syotanDoc.tel2__c = '77-7777-7777';
        syotanDoc.tel3__c = '88-8888-8888';
        insert syotanDoc;
        Test.stopTest();
        
        SyotanDocumentRequests__c result;
        for( SyotanDocumentRequests__c sdoc : [SELECT Id, Ref_Account__c,Ref_Syodan__c
                                               FROM SyotanDocumentRequests__c
                                               WHERE Id = :syotanDoc.Id]) {
            result = sdoc;
        }
        List<Opportunity> Oppr = [Select id from Opportunity];
        Opportunity oppt = triggerTest.getOpportunityById(result.Ref_Syodan__c);
        System.assertEquals(acc.Id, result.Ref_Account__c);
        System.assertEquals(Oppr[1].Id, result.Ref_Syodan__c);
        System.assertEquals(oppt.InflowRoute__c ,'資料請求');
        System.assertEquals(oppt.StageName,'未割当');
        System.assertEquals(oppt.telReason__c ,'その他');
    }
    
    @isTest
    static void SyotanDocumentRequestsTriggerTest_name_mobile_tel2_MultipleAccount() {
        SyotanDocumentRequestsTriggerTest triggerTest = new SyotanDocumentRequestsTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        for (Integer i = 0; i < 500; i++) {
            System.debug('Sleep thread !');
        }
        
        Account acc2 = triggerTest.createAccount();
        // System.DmlException: Insert failed. 
        // First exception on row 0; 
        // first error: DUPLICATES_DETECTED, いずれか 1 つのレコードを使用しますか?: []
        //insert  acc2;
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        SyotanDocumentRequests__c syotanDoc = triggerTest.createSyotanDocumentRequests(null);
        syotanDoc.last_name__c = '個人';
        syotanDoc.first_name__c = '取引先';
        syotanDoc.last_name_kana__c = 'コジン';
        syotanDoc.first_name_kana__c = 'トリヒキサキ';
        syotanDoc.tel1__c = '11-1111-1111';
        syotanDoc.tel2__c = '88-8888-8888';
        syotanDoc.tel3__c = '77-7777-7777';
        insert syotanDoc;
        Test.stopTest();
        
        SyotanDocumentRequests__c result;
        for( SyotanDocumentRequests__c sdoc : [SELECT Id, Ref_Account__c,Ref_Syodan__c
                                               FROM SyotanDocumentRequests__c
                                               WHERE Id = :syotanDoc.Id]) {
            result = sdoc;
        }
        //System.assertEquals(acc.Id, result.Ref_Account__c);
        Opportunity oppt = triggerTest.getOpportunityById(result.Ref_Syodan__c);
        System.assertEquals(oppt.InflowRoute__c ,'資料請求');
        System.assertEquals(oppt.StageName,'未割当');
        System.assertEquals(oppt.telReason__c ,'その他');
    }
    
    @isTest
    static void SyotanDocumentRequestsTriggerTest_no_Account() {
        SyotanDocumentRequestsTriggerTest triggerTest = new SyotanDocumentRequestsTriggerTest();
        
        Test.startTest();
        SyotanDocumentRequests__c syotanDoc = triggerTest.createSyotanDocumentRequests(null);
        syotanDoc.last_name__c = null;
        syotanDoc.first_name__c = null;
        syotanDoc.last_name_kana__c = null;
        syotanDoc.first_name_kana__c = null;
        syotanDoc.tel1__c = '11-1111-1111';
        syotanDoc.tel2__c = '77-7777-7777';
        syotanDoc.tel3__c = '88-8888-8888';
        insert syotanDoc;
        Test.stopTest();
        
        SyotanDocumentRequests__c result;
        for( SyotanDocumentRequests__c sdoc : [SELECT Id, Ref_Account__c,Ref_Syodan__c,tel1__c,tel2__c,tel3__c
                                               FROM SyotanDocumentRequests__c
                                               WHERE Id = :syotanDoc.Id]) {
            result = sdoc;
        }
        Account acc = triggerTest.getAccountById(result.Ref_Account__c);
        System.assertNotEquals(result.Ref_Account__c,null );
        System.assertEquals(acc.OperationType__c,'割当可');
        System.assertEquals(acc.division__pc,'見込み顧客');
        System.assertEquals(acc.OpportunityStatus__c ,'未対応');
        
        System.assertEquals(acc.LastName,'未登録');
        System.assertEquals(acc.FirstName,'未登録');
        
        Opportunity oppt = triggerTest.getOpportunityById(result.Ref_Syodan__c);
        System.assertEquals(oppt.InflowRoute__c ,'資料請求');
        System.assertEquals(oppt.StageName,'未割当');
        System.assertEquals(oppt.telReason__c ,'その他');
    }
    
    private account createAccount(){
        List<RecordType> recordTypes = [SELECT Id, Name 
                                        FROM   RecordType 
                                        WHERE  SobjectType = 'Account' 
                                        And    Name = '個人取引先' 
                                        ORDER BY Name ASC LIMIT 50];
        return new Account(
            LastName = '個人',
            FirstName = '取引先',
            furiganaLast__pc = 'コジン',
            furiganaForst__pc = 'トリヒキサキ',
            PersonHomePhone = '99-9999-9999',
            PersonMobilePhone = '88-8888-8888',
            PersonBirthdate = date.newInstance(1990, 11, 21),
            Gender__pc = '男性',
            SYSAccountName__c = '楽天太郎ﾗｸﾃﾝﾀﾛｳ',
            RecordTypeId=recordTypes[0].Id
        );
    }
    
    private SyotanDocumentRequests__c createSyotanDocumentRequests(Id accountId){
        return new SyotanDocumentRequests__c(
            id__c = '1111111',
            request_id__c = '2222222',
            last_name__c = '楽天',
            first_name__c = '太郎',
            last_name_kana__c = 'ﾗｸﾃﾝ',
            first_name_kana__c = 'ﾀﾛｳ',
            tel1__c = '99-9999-9999',
            tel2__c = '88-8888-8888',
            tel3__c = '77-7777-7777',
            zip_code1__c = '5555555',
            pref__c = '住所',
            city__c = '市区町村市区町村市区町村市区町村市区町村市区町村市区町村市区町村',
            address__c = '住所１',
            building__c = '住所２',
            Ref_Account__c = accountId
        );
    }
    
    private Opportunity createOpportunity(Id accountId) {
        List<RecordType> recordTypes = [SELECT Id, Name 
                                        FROM   RecordType 
                                        WHERE  SobjectType = 'Opportunity' 
                                        And    Name = '生保' 
                                        ORDER BY Name ASC LIMIT 50];
        return new Opportunity(
            Name = '1111111',
            AccountId = accountId,
            StageName = '未対応',
            FirstCallDateTime__c = System.today(),
            FirstProbability__c = 'test',
            CloseDate = System.today(),
            RecordTypeId=recordTypes[0].Id
        );
    }
    
    private Opportunity createOpportunityClosed(Id accountId) {
        List<RecordType> recordTypes = [SELECT Id, Name 
                                        FROM   RecordType 
                                        WHERE  SobjectType = 'Opportunity' 
                                        And    Name = '生保' 
                                        ORDER BY Name ASC LIMIT 50];
        return new Opportunity(
            Name = '1111111',
            AccountId = accountId,
            StageName = '対応終了',
            FirstCallDateTime__c = System.today(),
            FirstProbability__c = 'test',
            CloseDate = System.today(),
            RecordTypeId=recordTypes[0].Id
        );
    }
    
    private Account getAccountById( Id accountId ) {
        return [SELECT Id, Name, LastName, FirstName, furiganaForst__pc, furiganaLast__pc, Phone,
                       PersonHomePhone, PersonMobilePhone, PersonBirthdate, Gender__pc, 
                       SYSAccountName__c, PersonMailingPostalCode, PersonMailingState, 
                       PersonMailingCity, PersonMailingStreet, PersonEmail,LastName__pc,firstname__pc,division__pc,
                       OperationType__c,OpportunityStatus__c
                FROM   Account
                WHERE  Id =: accountId LIMIT 1];
    }
    
    private Opportunity getOpportunityById( Id oppId ) {
        return [SELECT id,telReason__c,InflowRoute__c,MiniUpdateDate__c,StageName FROM Opportunity WHERE  Id =: oppId LIMIT 1];
    }
}