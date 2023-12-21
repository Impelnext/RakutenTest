@isTest
public class SeihoLeadTriggerTest
{
    @isTest
    static void SeihoLeadTriggerTest()
    {
        SeihoLeadTriggerTest triggerTest = new SeihoLeadTriggerTest();

        insert  triggerTest.createAccount();
        Account account = [SELECT Id,furiganaLast__pc,furiganaForst__pc FROM Account LIMIT 1];

        Test.startTest();

        SeihoLead__c sl = triggerTest.createSeihoLead(account.Id);
        insert sl;      
        
        Id oppId = [SELECT Id, Opportunity__c FROM SeihoLead__c WHERE Id =: sl.Id LIMIT 1].Opportunity__c;
        Opportunity opp = triggerTest.getOpportunityById(oppId);
        System.assertEquals('未割当', opp.StageName);
        System.assertEquals('その他', opp.telReason__c);
        Date today = System.today();
        Date expCloseDate = Date.newInstance(today.year(), today.month() + 2,0);
        System.assertEquals(expCloseDate, opp.CloseDate);
        System.assertEquals('資料請求', opp.InflowRoute__c);
        System.assertEquals(account.id, opp.AccountId);
        DateTime insertDate = datetime.now();
        String oppNameInsertStr = insertDate.format('yyyyMMdd') + '_' + '生保' + '_';
        System.assertEquals(oppNameInsertStr + account.furiganaLast__pc + account.furiganaForst__pc ,opp.Name); 
        
        List<SeihoLead__c> slead = [SELECT Id, Ref_Account__c,Opportunity__c FROM SeihoLead__c WHERE  Id = :sl.Id];
        System.assertEquals(account.Id, slead[0].Ref_Account__c);
        System.assertEquals(opp.Id, slead[0].Opportunity__c);                           
         
        Test.stopTest();        
               
    }
    
    @isTest
    static void SeihoLeadTriggerTest_non_AccountId()
    {
        SeihoLeadTriggerTest triggerTest = new SeihoLeadTriggerTest();

        insert  triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
         insert  triggerTest.createOpportunity(account.Id);

        Test.startTest();

        SeihoLead__c sl =  triggerTest.createSeihoLead(null);
        insert sl;
		
        Id accId = [SELECT Id, Ref_Account__c FROM SeihoLead__c WHERE Id =: sl.Id LIMIT 1].Ref_Account__c;
        Account acc = triggerTest.getAccountById(accId);
        System.assertEquals(sl.LastName__c, acc.LastName);
        System.assertEquals(sl.LastName__c, acc.LastName__pc);
        System.assertEquals(sl.FirstName__c, acc.FirstName);
        System.assertEquals(sl.FirstName__c, acc.firstname__pc);
        System.assertEquals(sl.LastNameKana__c, acc.furiganaLast__pc);
        System.assertEquals(sl.FirstNameKana__c, acc.furiganaForst__pc);
        System.assertEquals(sl.EasyId__c, acc.easyId__pc);
        System.assertEquals(sl.Birthdate__c, acc.PersonBirthdate);
        System.assertEquals(sl.Gender__c, acc.Gender__pc);
        System.assertEquals(sl.Email__c, acc.PersonEmail);
        System.assertEquals(sl.PostalCode__c, acc.PersonMailingPostalCode);
        System.assertEquals(sl.State__c, acc.PersonMailingState);
        System.assertEquals(sl.City__c, acc.PersonMailingCity);
        System.assertEquals(sl.Phone__c, acc.Phone);
        System.assertEquals(sl.Phone__c, acc.PersonHomePhone);
        System.assertEquals(sl.MobilePhone__c, acc.PersonMobilePhone);                
        System.assertEquals('見込み顧客', acc.division__pc);
        System.assertEquals('割当可', acc.OperationType__c);
        System.assertEquals('未対応', acc.OpportunityStatus__c);
                
        Test.stopTest();
        
    }
    
    @isTest
    static void SeihoLeadTriggerTest_non_Account_easy_Id_match() {
        SeihoLeadTriggerTest triggerTest = new SeihoLeadTriggerTest();

        Account acc = triggerTest.createAccount();
        acc.easyId__pc = '1111111';
        insert  acc;
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(account.Id);

        Test.startTest();
        SeihoLead__c sl = triggerTest.createSeihoLead(null);
        insert sl;
        Test.stopTest();

        SeihoLead__c result;
        for( SeihoLead__c slead : [SELECT Id, Ref_Account__c
                                   FROM   SeihoLead__c
                                   WHERE  Id = :sl.Id] ) {
            result = slead;
        }

        System.assertNotEquals(null, result.Ref_Account__c);
        System.assertNotEquals(acc.Id, result.Ref_Account__c);

    }

    @isTest
    static void SeihoLeadTriggerTest_non_Account_easy_Id_unmatch() {
        SeihoLeadTriggerTest triggerTest = new SeihoLeadTriggerTest();

        insert  triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
         insert  triggerTest.createOpportunity(account.Id);

        Test.startTest();

        SeihoLead__c sl = triggerTest.createSeihoLead(null);
        sl.EasyId__c = null;
        sl.FirstName__c = '';
        sl.LastName__c = '';
        insert sl;
        
        SeihoLead__c result;
        for( SeihoLead__c slead : [SELECT Id, Ref_Account__c
                                   FROM   SeihoLead__c
                                   WHERE  Id = :sl.Id] ) {
            result = slead;
        }

        System.assertNotEquals(null, result.Ref_Account__c);
        System.assertNotEquals(account.Id, result.Ref_Account__c);
       
        Test.stopTest();

    }
    
    @isTest
    static void SeihoLeadTriggerTest_AccountId_Not_Null()
    {
        SeihoLeadTriggerTest triggerTest = new SeihoLeadTriggerTest();

        insert  triggerTest.createAccount();
        Account account = [SELECT Id,furiganaLast__pc,furiganaForst__pc FROM Account LIMIT 1];

        Test.startTest();

        SeihoLead__c sl = triggerTest.createSeihoLead(account.Id);
        insert sl;      
        
        Id oppId = [SELECT Id, Opportunity__c FROM SeihoLead__c WHERE Id =: sl.Id LIMIT 1].Opportunity__c;
        Opportunity opp = triggerTest.getOpportunityById(oppId);
        System.assertEquals('未割当', opp.StageName);
        System.assertEquals('その他', opp.telReason__c);
        Date today = System.today();
        Date expCloseDate = Date.newInstance(today.year(), today.month() + 2,0);
        System.assertEquals(expCloseDate, opp.CloseDate);
        System.assertEquals('資料請求', opp.InflowRoute__c);
        System.assertEquals(account.id, opp.AccountId);
        DateTime insertDate = datetime.now();
        String oppNameInsertStr = insertDate.format('yyyyMMdd') + '_' + '生保' + '_';
        System.assertEquals(oppNameInsertStr + account.furiganaLast__pc + account.furiganaForst__pc ,opp.Name); 
        
        List<SeihoLead__c> slead = [SELECT Id, Ref_Account__c,Opportunity__c FROM SeihoLead__c WHERE  Id = :sl.Id];
        System.assertEquals(account.Id, slead[0].Ref_Account__c);
        System.assertEquals(opp.Id, slead[0].Opportunity__c);

        Test.stopTest();
        
    }
    
    @isTest
    static void SeihoLeadTriggerTest_name_phone() {
        SeihoLeadTriggerTest triggerTest = new SeihoLeadTriggerTest();

        Account acc = triggerTest.createAccount();
        insert  acc;
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(account.Id);

        Test.startTest();
        SeihoLead__c sl = triggerTest.createSeihoLead(null);
        sl.LastName__c = '個人';
        sl.FirstName__c = '取引先';
        sl.LastNameKana__c = 'コジン';
        sl.FirstNameKana__c = 'トリヒキサキ';
        sl.MobilePhone__c = '11-1111-1111';
        sl.Birthdate__c = date.newInstance(1999, 11, 21);
        sl.Gender__c = '女性';
        sl.CatalogId__c = '12345';
        sl.PostalCode__c = '12345678901234567890';
        sl.PrefectureKana__c = 'PrefectureKana';
        sl.CityKana__c = 'CityKana';
        sl.StreetKana__c = 'StreetKana';
        insert sl;
        Test.stopTest();

        SeihoLead__c result;
        for( SeihoLead__c slead : [SELECT Id, Ref_Account__c
                                   FROM   SeihoLead__c
                                   WHERE  Id = :sl.Id] ) {
            result = slead;
        }

        System.assertEquals(acc.Id, result.Ref_Account__c);
		
        Id accId = [SELECT Id, Ref_Account__c FROM SeihoLead__c WHERE Id =: sl.Id LIMIT 1].Ref_Account__c;
        Account resAcc = triggerTest.getAccountById(accId);        
        System.assertEquals(sl.Phone__c, resAcc.PersonHomePhone); 
    }

    @isTest
    static void SeihoLeadTriggerTest_name_mobilephone() {
        SeihoLeadTriggerTest triggerTest = new SeihoLeadTriggerTest();

        Account acc = triggerTest.createAccount();
        insert  acc;
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(account.Id);

        Test.startTest();
        SeihoLead__c sl = triggerTest.createSeihoLead(null);
        sl.LastName__c = '個人';
        sl.FirstName__c = '取引先';
        sl.LastNameKana__c = 'コジン';
        sl.FirstNameKana__c = 'トリヒキサキ';
        sl.phone__c = '11-1111-1111';
        sl.Birthdate__c = date.newInstance(1999, 11, 21);
        sl.Gender__c = '女性';
        insert sl;
        Test.stopTest();

        SeihoLead__c result;
        for( SeihoLead__c slead : [SELECT Id, Ref_Account__c
                                   FROM   SeihoLead__c
                                   WHERE  Id = :sl.Id] ) {
            result = slead;
        }

        System.assertEquals(acc.Id, result.Ref_Account__c);
        
        Id accId = [SELECT Id, Ref_Account__c FROM SeihoLead__c WHERE Id =: sl.Id LIMIT 1].Ref_Account__c;
        Account resAcc = triggerTest.getAccountById(accId);        
        System.assertEquals(sl.MobilePhone__c, resAcc.PersonMobilePhone);                        

    }

    @isTest
    static void SeihoLeadTriggerTest_name_birthdate_gender() {
        SeihoLeadTriggerTest triggerTest = new SeihoLeadTriggerTest();

        Account acc = triggerTest.createAccount();
        insert  acc;
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(account.Id);

        Test.startTest();
        SeihoLead__c sl = triggerTest.createSeihoLead(null);
        sl.LastName__c = '個人';
        sl.FirstName__c = '取引先';
        sl.LastNameKana__c = 'コジン';
        sl.FirstNameKana__c = 'トリヒキサキ';
        sl.phone__c = '11-1111-1111';
        sl.Mobilephone__c = '44-4444-4444';
        insert sl;
        Test.stopTest();

        SeihoLead__c result;
        for( SeihoLead__c slead : [SELECT Id, Ref_Account__c
                                   FROM   SeihoLead__c
                                   WHERE  Id = :sl.Id] ) {
            result = slead;
        }

        System.assertEquals(acc.Id, result.Ref_Account__c);
        
        Id accId = [SELECT Id, Ref_Account__c FROM SeihoLead__c WHERE Id =: sl.Id LIMIT 1].Ref_Account__c;
        Account resAcc = triggerTest.getAccountById(accId);        
        System.assertEquals(sl.Birthdate__c, resAcc.PersonBirthdate);
        System.assertEquals(sl.Gender__c, resAcc.Gender__pc);

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

    private SeihoLead__c createSeihoLead(Id accountId){
        return new SeihoLead__c(
            EasyId__c = '1111111',
            LastName__c = '楽天',
            FirstName__c = '太郎',
            LastNameKana__c = 'ﾗｸﾃﾝ',
            FirstNameKana__c = 'ﾀﾛｳ',
            Phone__c = '99-9999-9999',
            MobilePhone__c = '88-8888-8888',
            Birthdate__c = date.newInstance(1990, 11, 21),
            Gender__c = '男性',
            PostalCode__c = '222-2222',
            State__c = '住所',
            City__c = '市区町村市区町村市区町村市区町村市区町村市区町村市区町村市区町村',
            Street__c = '住所１',
            Apart__c = '住所２',
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
    
    private Account getAccountById( Id accountId ) {
        return [SELECT Id, Name, LastName, FirstName, furiganaLast__pc, furiganaForst__pc, 
                       PersonHomePhone, PersonMobilePhone, PersonBirthdate, Gender__pc, easyId__pc,Phone,division__pc,
                       SYSAccountName__c, PersonMailingPostalCode, PersonMailingState, 
                       PersonMailingCity, PersonMailingStreet, PersonEmail,LastName__pc,firstname__pc,OperationType__c,OpportunityStatus__c
                FROM   Account
                WHERE  Id =: accountId LIMIT 1];
    }
    
    private Opportunity getOpportunityById( Id oppId ) {
        return [SELECT id,StageName,telReason__c,CloseDate,AccountId,InflowRoute__c,Name 
                FROM Opportunity WHERE  Id =: oppId LIMIT 1];
    }
        
}