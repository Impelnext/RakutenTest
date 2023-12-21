@isTest
public class GeneralRequestTriggerTest
{
    @isTest
    static void GeneralRequestTriggerTest_With_AccountId()
    {
        GeneralRequestTriggerTest triggerTest = new GeneralRequestTriggerTest();

        insert  triggerTest.createAccount();
        Account account = [SELECT Id,furiganaLast__pc,furiganaForst__pc FROM Account LIMIT 1];

        Test.startTest();

        GeneralRequest__c generalReq = triggerTest.createGeneralRequest(account.Id);
        insert generalReq;        
		
        Id oppId = [SELECT Id, Opportunity__c FROM GeneralRequest__c WHERE Id =: generalReq.Id LIMIT 1].Opportunity__c;
        Opportunity opp = triggerTest.getOpportunityById(oppId);
        System.assertEquals('未割当', opp.StageName);
        System.assertEquals('その他', opp.telReason__c);
        Date today = System.today();
        Date expCloseDate = Date.newInstance(today.year(), today.month() + 2,0);
        System.assertEquals(expCloseDate, opp.CloseDate);
        System.assertEquals('資料請求', opp.InflowRoute__c);
        System.assertEquals(account.id, opp.AccountId);
        DateTime insertDate = datetime.now();
        String oppNameInsertStr = insertDate.format('yyyyMMdd') + '_' + '損保' + '_';
        System.assertEquals(oppNameInsertStr + account.furiganaLast__pc + account.furiganaForst__pc ,opp.Name);      
        
        List<GeneralRequest__c> generalReqList = [Select Id, Opportunity__r.StageName,Opportunity__c,Ref_Account__c from GeneralRequest__c where Id =: generalReq.Id];
        System.assertEquals('未割当', generalReqList[0].Opportunity__r.StageName);
        System.assertEquals(opp.id, generalReqList[0].Opportunity__c);
        System.assertEquals(account.id, generalReqList[0].Ref_Account__c);
        Test.stopTest();
    }
    
    @isTest
    static void GeneralRequestTriggerTest_non_AccountId()
    {
        GeneralRequestTriggerTest triggerTest = new GeneralRequestTriggerTest();

        insert  triggerTest.createAccount();

        Test.startTest();

        GeneralRequest__c generalReq = triggerTest.createGeneralRequest(null);
        generalReq.phone__c = '11-1111-1111';
        insert generalReq;
		
       	Id accId = [SELECT Id, Ref_Account__c FROM GeneralRequest__c WHERE Id =: generalReq.Id LIMIT 1].Ref_Account__c;
        Account acc = triggerTest.getAccountById(accId);
        System.assertEquals(generalReq.name__c, acc.LastName);
        System.assertEquals(generalReq.name__c, acc.LastName__pc);
        System.assertEquals(generalReq.furigana__c, acc.furiganaLast__pc);
        System.assertEquals(generalReq.easy_id__c, acc.easyId__pc);
        System.assertEquals(generalReq.email_address__c, acc.PersonEmail);
        System.assertEquals(generalReq.address__c, acc.PersonMailingStreet);
        System.assertEquals(generalReq.Phone__c, acc.Phone);
        System.assertEquals(generalReq.Phone__c, acc.PersonHomePhone);
        System.assertEquals('見込み顧客', acc.division__pc);
        System.assertEquals('割当可', acc.OperationType__c);
        System.assertEquals('未対応', acc.OpportunityStatus__c);
               
        Test.stopTest();
    }

	@isTest
    static void GeneralRequestTriggerTest_AccountId_Not_Null()
    {
        GeneralRequestTriggerTest triggerTest = new GeneralRequestTriggerTest();

        insert  triggerTest.createAccount();
        Account account = [SELECT Id,furiganaLast__pc,furiganaForst__pc FROM Account LIMIT 1];

        Test.startTest();

        GeneralRequest__c generalReq = triggerTest.createGeneralRequest(account.Id);
        insert generalReq;

        Id oppId = [SELECT Id, Opportunity__c FROM GeneralRequest__c WHERE Id =: generalReq.Id LIMIT 1].Opportunity__c;
        Opportunity opp = triggerTest.getOpportunityById(oppId);
        System.assertEquals('未割当', opp.StageName);
        System.assertEquals('その他', opp.telReason__c);
        Date today = System.today();
        Date expCloseDate = Date.newInstance(today.year(), today.month() + 2,0);
        System.assertEquals(expCloseDate, opp.CloseDate);
        System.assertEquals('資料請求', opp.InflowRoute__c);
        System.assertEquals(account.id, opp.AccountId);
        DateTime insertDate = datetime.now();
        String oppNameInsertStr = insertDate.format('yyyyMMdd') + '_' + '損保' + '_';
        System.assertEquals(oppNameInsertStr + account.furiganaLast__pc + account.furiganaForst__pc ,opp.Name);      
        
        List<GeneralRequest__c> generalReqList = [Select Id, Opportunity__r.StageName,Opportunity__c,Ref_Account__c from GeneralRequest__c where Id =: generalReq.Id];
        System.assertEquals('未割当', generalReqList[0].Opportunity__r.StageName);
        System.assertEquals(opp.id, generalReqList[0].Opportunity__c);
        System.assertEquals(account.id, generalReqList[0].Ref_Account__c);

        Test.stopTest();
    }
     
	
    @isTest
    static void GeneralRequestTriggerTest_name_phone() {
        GeneralRequestTriggerTest triggerTest = new GeneralRequestTriggerTest();
        Account acc = triggerTest.createAccount();
        acc.PersonHomePhone = '00011112222';
        acc.Phone = '00011112222';
        insert  acc;

        Account acc2 = triggerTest.createAccount();
        acc2.PersonHomePhone = '00011112233';
        insert  acc2;

        Test.startTest();
        GeneralRequest__c generalReq = triggerTest.createGeneralRequest(null);
        generalReq.phone__c = '00011112222';
        generalReq.name__c = '個人取引先';
        generalReq.furigana__c = 'ｺｼﾞﾝﾄﾘﾋｷｻｷ';
        insert generalReq;
        Test.stopTest();
        GeneralRequest__c result;
        for(GeneralRequest__c gen : [SELECT Id, Ref_Account__c
                                     FROM GeneralRequest__c
                                     WHERE Id = :generalReq.Id]) {
            result = gen;
        }
        System.assertEquals(acc.Id, result.Ref_Account__c);
        
        Account resAcc = triggerTest.getAccountById(acc.Id);            
        System.assertEquals(generalReq.Phone__c, resAcc.Phone);
        System.assertEquals(generalReq.Phone__c, resAcc.PersonHomePhone);
    }    

    @isTest
    static void GeneralRequestTriggerTest_name_mobilephone() {
        GeneralRequestTriggerTest triggerTest = new GeneralRequestTriggerTest();
        Account acc = triggerTest.createAccount();
        acc.PersonMobilePhone = '09011112222';
        acc.Phone = '09011112222';
        insert  acc;

        Account acc2 = triggerTest.createAccount();
        acc2.PersonMobilePhone = '09011112233';
        insert  acc2;

        Test.startTest();
        GeneralRequest__c generalReq = triggerTest.createGeneralRequest(null);
        generalReq.phone__c = '09011112222';
        generalReq.name__c = '個人取引先';
        generalReq.furigana__c = 'ｺｼﾞﾝﾄﾘﾋｷｻｷ';
        insert generalReq;
        Test.stopTest();
        GeneralRequest__c result;
        for(GeneralRequest__c gen : [SELECT Id, Ref_Account__c
                                     FROM GeneralRequest__c
                                     WHERE Id = :generalReq.Id]) {
            result = gen;
        }
        System.assertEquals(acc.Id, result.Ref_Account__c);
        
        Account resAcc = triggerTest.getAccountById(acc.Id);            
        System.assertEquals(generalReq.Phone__c, resAcc.Phone);
        System.assertEquals(generalReq.Phone__c, resAcc.PersonMobilePhone);
    }
    
    @isTest
    static void GeneralRequestTriggerTest_easyId() {
        GeneralRequestTriggerTest triggerTest = new GeneralRequestTriggerTest();
        Account acc = triggerTest.createAccount();
        acc.easyId__pc = '1111111';
        insert  acc;		
        
        Test.startTest();
        GeneralRequest__c generalReq = triggerTest.createGeneralRequest(null);
        generalReq.name__c = '';
        generalReq.phone__c = '00011112222';
        insert generalReq;
        Test.stopTest();
        GeneralRequest__c result;
        for(GeneralRequest__c gen : [SELECT Id, Ref_Account__c
                                     FROM GeneralRequest__c
                                     WHERE Id = :generalReq.Id]) {
            result = gen;
        }
        System.assertNotEquals(acc.Id, result.Ref_Account__c);
        
        Id accId = [SELECT Id, Ref_Account__c FROM GeneralRequest__c WHERE Id =: generalReq.Id LIMIT 1].Ref_Account__c;
        Account resAcc = triggerTest.getAccountById(accId);
        System.assertEquals('未登録', resAcc.LastName);
        System.assertEquals('未登録', resAcc.LastName__pc);
        System.assertEquals(generalReq.furigana__c, resAcc.furiganaLast__pc);
        System.assertEquals(generalReq.easy_id__c, resAcc.easyId__pc);
        System.assertEquals(generalReq.email_address__c, resAcc.PersonEmail);
        System.assertEquals(generalReq.address__c, resAcc.PersonMailingStreet);
        System.assertEquals(generalReq.Phone__c, resAcc.Phone);
        System.assertEquals(generalReq.Phone__c, resAcc.PersonHomePhone);
        System.assertEquals('見込み顧客', resAcc.division__pc);
        System.assertEquals('割当可', resAcc.OperationType__c);
        System.assertEquals('未対応', resAcc.OpportunityStatus__c);
    }

    @isTest
    static void GeneralRequestTriggerTest_Existing_Oppottunity() {
        
        GeneralRequestTriggerTest triggerTest = new GeneralRequestTriggerTest();
        Account acc = triggerTest.createAccount();
        acc.PersonHomePhone = '00011112222';
        insert  acc;      
		
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        insert  triggerTest.createOpportunity(account.Id);
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        
        Test.startTest();
        GeneralRequest__c generalReq = new GeneralRequest__c();
        generalReq.phone__c = '00011112222';
        generalReq.name__c = '個人取引先';
        generalReq.furigana__c = 'ｺｼﾞﾝﾄﾘﾋｷｻｷ';
        generalReq.easy_id__c = '1111111';
        generalReq.name__c = '楽天';
        generalReq.Ref_Account__c = account.id;
        generalReq.ForeignKey_Renban__c = 'test';
        insert generalReq;
        Test.stopTest();
        GeneralRequest__c result;
        for(GeneralRequest__c gen : [SELECT Id, Ref_Account__c,Opportunity__c
                                     FROM GeneralRequest__c
                                     WHERE Id = :generalReq.Id]) {
            result = gen;
        }
        System.assertEquals(opp.Id, result.Opportunity__c);
        System.assertEquals(account.Id, result.Ref_Account__c);
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
            RecordTypeId=recordTypes[0].Id,
            furiganaLast__pc = 'ｺｼﾞﾝ',
            furiganaForst__pc = 'ﾄﾘﾋｷｻｷ',
            PersonHomePhone = '11-1111-1111'
        );
    }
    
    private Opportunity createOpportunity(Id accountId){
        
        Id recordTypeIdOPP = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('損保').getRecordTypeId();
        
        return new Opportunity(
            Name = 'Test',
            ANP__c = 1234,
            StageName = '未割当',
            CloseDate = system.today(),
            RecordTypeId = recordTypeIdOPP,
            AccountId = accountId            
        );
    }
    
    private GeneralRequest__c createGeneralRequest(Id accountId){
        return new GeneralRequest__c(
            easy_id__c = '1111111',
            name__c = '楽天',
            furigana__c = 'ﾗｸﾃﾝ',
            Ref_Account__c = accountId,
            ForeignKey_Renban__c = 'test'
        );
    }
    
    private Account getAccountById( Id accountId ) {
        return [SELECT Id, Name, LastName, FirstName, furiganaLast__pc, furiganaForst__pc, 
                       PersonHomePhone, PersonMobilePhone, PersonBirthdate, Gender__pc, easyId__pc,Phone,division__pc,
                       SYSAccountName__c, PersonMailingPostalCode, PersonMailingState, 
                       PersonMailingCity, PersonMailingStreet, PersonEmail,LastName__pc,firstname__pc,OperationType__c,OpportunityStatus__c
                FROM   Account
                WHERE  Id =: accountId LIMIT 1];
    }
    
    private Opportunity getOpportunityById( Id oppId ) {
        return [SELECT id,StageName,telReason__c,CloseDate,AccountId,InflowRoute__c,Name FROM Opportunity WHERE  Id =: oppId LIMIT 1];
    }
}