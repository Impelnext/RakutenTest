@isTest
public class MiniInsuranceTriggerTest
{
    @isTest
    static void MiniInsuranceTriggerTest()
    {
        MiniInsuranceTriggerTest triggerTest = new MiniInsuranceTriggerTest();
        
        Account account = triggerTest.createAccount();
        insert  account;
        account = triggerTest.getAccountById(account.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        MiniInsurance__c mini = triggerTest.createMiniInsurance(account.Id);
        insert mini;
        Test.stopTest();
        
        Account acc = triggerTest.getAccountById(account.Id);
        System.assertEquals(mini.LastName__c, acc.LastName);
        System.assertEquals(mini.FirstName__c, acc.FirstName);
        System.assertEquals(mini.last_name_kana__c, acc.furiganaLast__pc);
        System.assertEquals(mini.first_name_kana__c, acc.furiganaForst__pc);
        System.assertEquals(mini.mobile_num__c, acc.PersonMobilePhone);
        System.assertEquals(mini.Birthdate__c, acc.PersonBirthdate);
        System.assertEquals(mini.Gender__c, acc.Gender__pc);
        System.assertEquals(mini.postal_code__c, acc.PersonMailingPostalCode);
        System.assertEquals(Null, acc.PersonMailingState);
        System.assertEquals(Null, acc.PersonMailingCity);
        System.assertEquals(mini.address1__c + mini.address2__c, acc.PersonMailingStreet);
        System.assertEquals(mini.Email__c, acc.PersonEmail);
    }
    
    @isTest
    static void MiniInsuranceTriggerTest_non_AccountId()
    {
        MiniInsuranceTriggerTest triggerTest = new MiniInsuranceTriggerTest();
        
        Account account = triggerTest.createAccount();
        insert  account;
        account = triggerTest.getAccountById(account.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        MiniInsurance__c mini = triggerTest.createMiniInsurance(null);
        insert mini;
        Test.stopTest();
        
        Id accId = [SELECT Id, AccountId__c FROM miniInsurance__c WHERE Id =: mini.Id LIMIT 1].AccountId__c;
        Account acc = triggerTest.getAccountById(accId);
        System.assertEquals(mini.LastName__c, acc.LastName);
        System.assertEquals(mini.FirstName__c, acc.FirstName);
        System.assertEquals(mini.last_name_kana__c, acc.furiganaLast__pc);
        System.assertEquals(mini.first_name_kana__c, acc.furiganaForst__pc);
        System.assertEquals(mini.mobile_num__c, acc.PersonMobilePhone);
        System.assertEquals(mini.Birthdate__c, acc.PersonBirthdate);
        System.assertEquals(mini.Gender__c, acc.Gender__pc);
        System.assertEquals(mini.postal_code__c, acc.PersonMailingPostalCode);
        System.assertEquals(Null, acc.PersonMailingState);
        System.assertEquals(Null, acc.PersonMailingCity);
        System.assertEquals(mini.address1__c + mini.address2__c, acc.PersonMailingStreet);
        System.assertEquals(mini.Email__c, acc.PersonEmail);
        System.assertEquals(acc.OperationType__c, '割当可');
        System.assertEquals(acc.OpportunityStatus__c, '未対応');
    }
    
    @isTest
    static void MiniInsuranceTriggerTest_non_Account_easy_Id_unmatch() {
        MiniInsuranceTriggerTest triggerTest = new MiniInsuranceTriggerTest();
        
        Account acc = triggerTest.createAccount();
        insert  triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        MiniInsurance__c m = triggerTest.createMiniInsurance(null);
        m.easy_id__c = null;
        insert m;
        Test.stopTest();
    }
    
    @isTest
    static void MiniInsuranceTriggerTest_non_Account_easy_Id_match() {
        MiniInsuranceTriggerTest triggerTest = new MiniInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        acc.easyId__pc = '1111111';
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        MiniInsurance__c m = triggerTest.createMiniInsurance(null);
        m.easy_id__c = acc.easyId__pc;
        insert m;
        Test.stopTest();
        
        MiniInsurance__c mini = triggerTest.getMiniInsuranceById(m.Id);
        Account resultAcc = triggerTest.getAccountById(mini.accountId__c);
        
        System.assertEquals(mini.LastName__c, resultAcc.LastName);
        System.assertEquals(mini.FirstName__c, resultAcc.FirstName);
        System.assertEquals(mini.last_name_kana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(mini.first_name_kana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(mini.Birthdate__c, resultAcc.PersonBirthdate);
        System.assertEquals(mini.Gender__c, resultAcc.Gender__pc);
        System.assertEquals(mini.phone_num__c , resultAcc.PersonHomePhone);
        System.assertEquals(mini.mobilePhone__c, resultAcc.PersonMobilePhone);
        System.assertEquals(mini.postal_code__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(Null, resultAcc.PersonMailingState);
        System.assertEquals(Null, resultAcc.PersonMailingCity);
        System.assertEquals(mini.address1__c + mini.address2__c, resultAcc.PersonMailingStreet);
        System.assertEquals(mini.Email__c, resultAcc.PersonEmail);
        System.assertNotEquals(mini.accountId__c, acc.Id);
    }
    
    @isTest
    static void MiniInsuranceTriggerTest_name_phone() {
        MiniInsuranceTriggerTest triggerTest = new MiniInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        MiniInsurance__c m = triggerTest.createMiniInsurance(null);
        m.LastName__c = account.LastName;
        m.FirstName__c = account.FirstName;
        m.last_name_kana__c = account.furiganaLast__pc;
        m.first_name_kana__c = account.furiganaForst__pc;
        m.phone_num__c  = account.PersonHomePhone;
        m.phone_num__c = account.PersonHomePhone;
        insert m;
        Test.stopTest();
        
        MiniInsurance__c mini = triggerTest.getMiniInsuranceById(m.Id);
        Account resultAcc = triggerTest.getAccountById(acc.Id);
        
        System.assertEquals(mini.LastName__c, resultAcc.LastName);
        System.assertEquals(mini.FirstName__c, resultAcc.FirstName);
        System.assertEquals(mini.last_name_kana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(mini.first_name_kana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(mini.Birthdate__c, resultAcc.PersonBirthdate);
        System.assertEquals(mini.Gender__c, resultAcc.Gender__pc);
        System.assertEquals(resultAcc.PersonHomePhone, acc.PersonHomePhone);
        System.assertEquals(resultAcc.PersonMobilePhone, mini.mobile_num__c);
        System.assertEquals(mini.postal_code__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(Null, resultAcc.PersonMailingState);
        System.assertEquals(Null, resultAcc.PersonMailingCity);
        System.assertEquals(mini.address1__c + mini.address2__c, resultAcc.PersonMailingStreet);
        System.assertEquals(mini.Email__c, resultAcc.PersonEmail);
        System.assertEquals(mini.accountId__c, resultAcc.Id);
    }
    
    @isTest
    static void MiniInsuranceTriggerTest_name_mobilephone() {
        MiniInsuranceTriggerTest triggerTest = new MiniInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        MiniInsurance__c m = triggerTest.createMiniInsurance(null);
        m.LastName__c = account.LastName;
        m.FirstName__c = account.FirstName;
        m.last_name_kana__c = account.furiganaLast__pc;
        m.first_name_kana__c = account.furiganaForst__pc;
        m.mobile_num__c = account.PersonMobilePhone;
        m.mobile_num__c = account.PersonMobilePhone;
        insert m;
        Test.stopTest();
        
        MiniInsurance__c mini = triggerTest.getMiniInsuranceById(m.Id);
        Account resultAcc = triggerTest.getAccountById(acc.Id);
        
        System.assertEquals(mini.LastName__c, resultAcc.LastName);
        System.assertEquals(mini.FirstName__c, resultAcc.FirstName);
        System.assertEquals(mini.last_name_kana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(mini.first_name_kana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(mini.Birthdate__c, resultAcc.PersonBirthdate);
        System.assertEquals(mini.Gender__c, resultAcc.Gender__pc);
        System.assertEquals(mini.phone_num__c , resultAcc.PersonHomePhone);
        System.assertEquals(resultAcc.PersonMobilePhone, acc.PersonMobilePhone);
        System.assertEquals(mini.postal_code__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(Null, resultAcc.PersonMailingState);
        System.assertEquals(Null, resultAcc.PersonMailingCity);
        System.assertEquals(mini.address1__c + mini.address2__c, resultAcc.PersonMailingStreet);
        System.assertEquals(mini.Email__c, resultAcc.PersonEmail);
        System.assertEquals(mini.accountId__c, resultAcc.Id);
        
        List<Opportunity> oppUpt = [Select id From Opportunity ];
        Opportunity oppt = triggerTest.getOpportunityById(mini.OpportunityId__c);
        System.assertEquals(2, oppUpt.Size());
        System.assertNotEquals(oppUpt[0].id , mini.OpportunityId__c);
        System.assertEquals(oppt.Question1__c , mini.Question1__c);
        System.assertEquals(oppt.Question2__c , mini.Question2__c);
        System.assertEquals(oppt.Question3__c , mini.Question3__c);
        System.assertEquals(oppt.Question4__c , mini.Question4__c);
        System.assertEquals(oppt.Question5__c , mini.Question5__c);
        System.assertEquals(oppt.Question6__c , mini.Question6__c);
        System.assertEquals(oppt.Question7__c , mini.Question7__c);
        System.assertEquals(oppt.Question8__c , mini.Question8__c);
        System.assertEquals(oppt.Question9__c , mini.Question9__c);
        System.assertEquals(oppt.Question10__c , mini.Question10__c);
        System.assertEquals(oppt.Answer1__c , mini.Answer1__c);
        System.assertEquals(oppt.Answer2__c , mini.Answer2__c);
        System.assertEquals(oppt.Answer2_1__c , mini.Answer2_1__c);
        System.assertEquals(oppt.Answer2_2__c , mini.Answer2_2__c);
        System.assertEquals(oppt.Answer3__c , mini.Answer3__c);
        System.assertEquals(oppt.Answer4__c , mini.Answer4__c);
        System.assertEquals(oppt.Answer5__c , mini.Answer5__c);
        System.assertEquals(oppt.Answer6__c , mini.Answer6__c);
        System.assertEquals(oppt.Answer7__c , mini.Answer7__c);
        System.assertEquals(oppt.Answer8__c , mini.Answer8__c);
        System.assertEquals(oppt.Answer9__c , mini.Answer9__c);
        System.assertEquals(oppt.Answer10__c , mini.Answer10__c);
        System.assertEquals(oppt.InflowRoute__c ,'ミニ保険');
        System.assertNotEquals(oppt.MiniUpdateDate__c ,null);
        
    }
    @isTest
    static void MiniInsuranceTriggerTest_name_mobilephone_HanyoOpp() {
        MiniInsuranceTriggerTest triggerTest = new MiniInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        Opportunity opp =  triggerTest.createOpportunityHanyo(account.Id);
        opp.MiniUpdateDate__c = null;
        insert opp;
        
        Test.startTest();
        MiniInsurance__c m = triggerTest.createMiniInsurance(null);
        m.LastName__c = account.LastName;
        m.FirstName__c = account.FirstName;
        m.last_name_kana__c = account.furiganaLast__pc;
        m.first_name_kana__c = account.furiganaForst__pc;
        m.mobile_num__c = account.PersonMobilePhone;
        m.mobile_num__c = account.PersonMobilePhone;
        insert m;
        Test.stopTest();
        
        MiniInsurance__c mini = triggerTest.getMiniInsuranceById(m.Id);
        Account resultAcc = triggerTest.getAccountById(acc.Id);
        
        System.assertEquals(mini.LastName__c, resultAcc.LastName);
        System.assertEquals(mini.FirstName__c, resultAcc.FirstName);
        System.assertEquals(mini.last_name_kana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(mini.first_name_kana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(mini.Birthdate__c, resultAcc.PersonBirthdate);
        System.assertEquals(mini.Gender__c, resultAcc.Gender__pc);
        System.assertEquals(mini.phone_num__c , resultAcc.PersonHomePhone);
        System.assertEquals(resultAcc.PersonMobilePhone, acc.PersonMobilePhone);
        System.assertEquals(mini.postal_code__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(Null, resultAcc.PersonMailingState);
        System.assertEquals(Null, resultAcc.PersonMailingCity);
        System.assertEquals(mini.address1__c + mini.address2__c, resultAcc.PersonMailingStreet);
        System.assertEquals(mini.Email__c, resultAcc.PersonEmail);
        System.assertEquals(mini.accountId__c, resultAcc.Id);
        
        List<Opportunity> oppUpt = [Select id From Opportunity ];
        Opportunity oppt = triggerTest.getOpportunityById(mini.OpportunityId__c);
        System.assertEquals(1, oppUpt.Size());
        System.assertEquals(oppt.Question1__c , mini.Question1__c);
        System.assertEquals(oppt.Question2__c , mini.Question2__c);
        System.assertEquals(oppt.Question3__c , mini.Question3__c);
        System.assertEquals(oppt.Question4__c , mini.Question4__c);
        System.assertEquals(oppt.Question5__c , mini.Question5__c);
        System.assertEquals(oppt.Question6__c , mini.Question6__c);
        System.assertEquals(oppt.Question7__c , mini.Question7__c);
        System.assertEquals(oppt.Question8__c , mini.Question8__c);
        System.assertEquals(oppt.Question9__c , mini.Question9__c);
        System.assertEquals(oppt.Question10__c , mini.Question10__c);
        System.assertEquals(oppt.Answer1__c , mini.Answer1__c);
        System.assertEquals(oppt.Answer2__c , mini.Answer2__c);
        System.assertEquals(oppt.Answer2_1__c , mini.Answer2_1__c);
        System.assertEquals(oppt.Answer2_2__c , mini.Answer2_2__c);
        System.assertEquals(oppt.Answer3__c , mini.Answer3__c);
        System.assertEquals(oppt.Answer4__c , mini.Answer4__c);
        System.assertEquals(oppt.Answer5__c , mini.Answer5__c);
        System.assertEquals(oppt.Answer6__c , mini.Answer6__c);
        System.assertEquals(oppt.Answer7__c , mini.Answer7__c);
        System.assertEquals(oppt.Answer8__c , mini.Answer8__c);
        System.assertEquals(oppt.Answer9__c , mini.Answer9__c);
        System.assertEquals(oppt.Answer10__c , mini.Answer10__c);
        System.assertNotEquals(oppt.InflowRoute__c ,'ミニ保険');
        System.assertNotEquals(oppt.MiniUpdateDate__c ,null);
        
    }
    
    @isTest
    static void MiniInsuranceTriggerTest_name_gender_Birthdate() {
        MiniInsuranceTriggerTest triggerTest = new MiniInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        MiniInsurance__c m = triggerTest.createMiniInsurance(null);
        m.LastName__c = account.LastName;
        m.FirstName__c = account.FirstName;
        m.last_name_kana__c = account.furiganaLast__pc;
        m.first_name_kana__c = account.furiganaForst__pc;
        m.Gender__c = account.Gender__pc;
        m.Birthdate__c = account.PersonBirthdate;
        insert m;
        Test.stopTest();
        
        MiniInsurance__c mini = triggerTest.getMiniInsuranceById(m.Id);
        Account resultAcc = triggerTest.getAccountById(acc.Id);
        
        System.assertEquals(mini.LastName__c, resultAcc.LastName);
        System.assertEquals(mini.FirstName__c, resultAcc.FirstName);
        System.assertEquals(mini.last_name_kana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(mini.first_name_kana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(acc.PersonBirthdate, resultAcc.PersonBirthdate);
        System.assertEquals(acc.Gender__pc, resultAcc.Gender__pc);
        System.assertEquals(mini.phone_num__c , resultAcc.PersonHomePhone);
        System.assertEquals(mini.mobilePhone__c, resultAcc.PersonMobilePhone);
        System.assertEquals(mini.postal_code__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(Null, resultAcc.PersonMailingState);
        System.assertEquals(Null, resultAcc.PersonMailingCity);
        System.assertEquals(mini.address1__c + mini.address2__c, resultAcc.PersonMailingStreet);
        System.assertEquals(mini.Email__c, resultAcc.PersonEmail);
        System.assertEquals(mini.accountId__c, resultAcc.Id);
        
    }
    
    @isTest
    static void onBeforeUpdateProccessTest() {
        MiniInsuranceTriggerTest triggerTest = new MiniInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        MiniInsurance__c m = triggerTest.createMiniInsurance(account.Id);
        insert m;
        update m;
        Test.stopTest();
        
        MiniInsurance__c mini = triggerTest.getMiniInsuranceById(m.Id);
        Account resultAcc = triggerTest.getAccountById(acc.Id);
        
        System.assertEquals(mini.LastName__c, resultAcc.LastName);
        System.assertEquals(mini.FirstName__c, resultAcc.FirstName);
        System.assertEquals(mini.last_name_kana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(mini.first_name_kana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(mini.birthdate__c, resultAcc.PersonBirthdate);
        System.assertEquals(mini.gender__c, resultAcc.Gender__pc);
        System.assertEquals(mini.phone_num__c , resultAcc.PersonHomePhone);
        System.assertEquals(mini.mobilePhone__c, resultAcc.PersonMobilePhone);
        System.assertEquals(mini.postal_code__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(Null, resultAcc.PersonMailingState);
        System.assertEquals(Null, resultAcc.PersonMailingCity);
        System.assertEquals(mini.address1__c + mini.address2__c, resultAcc.PersonMailingStreet);
        System.assertEquals(mini.Email__c, resultAcc.PersonEmail);
        System.assertEquals(mini.accountId__c, resultAcc.Id);
    }
    
    @isTest
    static void MiniInsuranceTriggerExOppNoMiniUpdateTest()
    {
        MiniInsuranceTriggerTest triggerTest = new MiniInsuranceTriggerTest();
        
        Account account = triggerTest.createAccount();
        insert  account;
        account = triggerTest.getAccountById(account.Id);
        
        Opportunity opp = triggerTest.createOpportunityHanyo(account.Id);
        opp.MiniUpdateDate__c = null;
        insert opp;
        
        Test.startTest();
        MiniInsurance__c mini = triggerTest.createMiniInsurance(account.Id);
        mini.LastName__c = '個人';
        mini.FirstName__c = '取引先';
        mini.last_name_kana__c = 'コジン';
        mini.first_name_kana__c = 'トリヒキサキ';
        mini.Phone__c = '11-1111-1111';
        insert mini;
        Test.stopTest();
        
        Account acc = triggerTest.getAccountById(account.Id);
        System.assertEquals(mini.LastName__c, acc.LastName__pc);
        System.assertEquals(mini.FirstName__c, acc.firstname__pc);
        System.assertEquals(mini.LastName__c, acc.LastName);
        System.assertEquals(mini.FirstName__c, acc.firstname);      
        System.assertEquals(mini.last_name_kana__c, acc.furiganaLast__pc);
        System.assertEquals(mini.first_name_kana__c, acc.furiganaForst__pc);
        System.assertEquals(mini.mobile_num__c, acc.PersonMobilePhone);
        System.assertEquals(mini.Birthdate__c, acc.PersonBirthdate);
        System.assertEquals(mini.Gender__c, acc.Gender__pc);
        System.assertEquals(mini.postal_code__c, acc.PersonMailingPostalCode);
        System.assertEquals(Null, acc.PersonMailingState);
        System.assertEquals(Null, acc.PersonMailingCity);
        System.assertEquals(mini.address1__c + mini.address2__c, acc.PersonMailingStreet);
        System.assertEquals(mini.Email__c, acc.PersonEmail);
        
        List<Opportunity> oppUpt = [Select id From Opportunity ];
        Opportunity oppt = triggerTest.getOpportunityById(oppUpt[0].id);
        System.assertEquals(oppt.Question1__c , mini.Question1__c);
        System.assertEquals(oppt.Question2__c , mini.Question2__c);
        System.assertEquals(oppt.Question3__c , mini.Question3__c);
        System.assertEquals(oppt.Question4__c , mini.Question4__c);
        System.assertEquals(oppt.Question5__c , mini.Question5__c);
        System.assertEquals(oppt.Question6__c , mini.Question6__c);
        System.assertEquals(oppt.Question7__c , mini.Question7__c);
        System.assertEquals(oppt.Question8__c , mini.Question8__c);
        System.assertEquals(oppt.Question9__c , mini.Question9__c);
        System.assertEquals(oppt.Question10__c , mini.Question10__c);
        System.assertEquals(oppt.Answer1__c , mini.Answer1__c);
        System.assertEquals(oppt.Answer2__c , mini.Answer2__c);
        System.assertEquals(oppt.Answer2_1__c , mini.Answer2_1__c);
        System.assertEquals(oppt.Answer2_2__c , mini.Answer2_2__c);
        System.assertEquals(oppt.Answer3__c , mini.Answer3__c);
        System.assertEquals(oppt.Answer4__c , mini.Answer4__c);
        System.assertEquals(oppt.Answer5__c , mini.Answer5__c);
        System.assertEquals(oppt.Answer6__c , mini.Answer6__c);
        System.assertEquals(oppt.Answer7__c , mini.Answer7__c);
        System.assertEquals(oppt.Answer8__c , mini.Answer8__c);
        System.assertEquals(oppt.Answer9__c , mini.Answer9__c);
        System.assertEquals(oppt.Answer10__c , mini.Answer10__c);
        System.assertNotEquals(oppt.InflowRoute__c ,'ミニ保険');
        System.assertNotEquals(oppt.MiniUpdateDate__c ,null);
        
    }
    @isTest
    static void MiniInsuranceTriggerExOppMiniUpdateTest()
    {
        MiniInsuranceTriggerTest triggerTest = new MiniInsuranceTriggerTest();

        Account account = triggerTest.createAccount();
        insert  account;
        account = triggerTest.getAccountById(account.Id);

        Opportunity opp = triggerTest.createOpportunityHanyo(account.Id);
        insert opp;

        Test.startTest();
        MiniInsurance__c mini = triggerTest.createMiniInsurance(account.Id);
        mini.LastName__c = null;
        mini.FirstName__c = null;
        insert mini;
        Test.stopTest();
        Account acc = triggerTest.getAccountById(account.Id);
        System.assertEquals('未登録', acc.LastName__pc);
        System.assertEquals(null, acc.firstname__pc);
        System.assertEquals(mini.last_name_kana__c, acc.furiganaLast__pc);
        System.assertEquals(mini.first_name_kana__c, acc.furiganaForst__pc);
        System.assertEquals(mini.mobile_num__c, acc.PersonMobilePhone);
        System.assertEquals(mini.Birthdate__c, acc.PersonBirthdate);
        System.assertEquals(mini.Gender__c, acc.Gender__pc);
        System.assertEquals(mini.postal_code__c, acc.PersonMailingPostalCode);
        System.assertEquals(Null, acc.PersonMailingState);
        System.assertEquals(Null, acc.PersonMailingCity);
        System.assertEquals(mini.address1__c + mini.address2__c, acc.PersonMailingStreet);
        System.assertEquals(mini.Email__c, acc.PersonEmail);
        
    }
    
    @isTest
    static void MiniInsuranceTriggerAccountName_Phone_MatchTest(){
        MiniInsuranceTriggerTest triggerTest = new MiniInsuranceTriggerTest();
        
        Account account = triggerTest.createAccount();
        insert  account;
        
        for (Integer i = 0; i < 500; i++) {
            System.debug('Sleep thread !');
        }
        
        Account act = [Select LastName From Account limit 1];
        Account account2 = triggerTest.createAccount();
        account2.LastName = act.LastName;
        // System.DmlException: Insert failed. 
        // First exception on row 0; 
        // first error: DUPLICATES_DETECTED, いずれか 1 つのレコードを使用しますか?: []
        //insert  account2;
        
        Opportunity opp = triggerTest.createOpportunityHanyo(null);
        insert opp;
        
        Test.startTest();
        MiniInsurance__c mini = triggerTest.createMiniInsurance(null);
        mini.LastName__c = '個人';
        mini.FirstName__c = '取引先';
        mini.last_name_kana__c = 'コジン';
        mini.first_name_kana__c = 'トリヒキサキ';
        mini.Phone__c = '11-1111-1111';
        insert mini;
        Test.stopTest();
        
        Id accId = [SELECT Id, AccountId__c FROM miniInsurance__c WHERE Id =: mini.Id LIMIT 1].AccountId__c;
        Account acc = triggerTest.getAccountById(accId);
        System.assertEquals(mini.LastName__c, acc.LastName__pc);
        System.assertEquals(mini.FirstName__c, acc.firstname__pc);
        System.assertEquals(mini.last_name_kana__c, acc.furiganaLast__pc);
        System.assertEquals(mini.first_name_kana__c, acc.furiganaForst__pc);
        System.assertEquals(mini.mobile_num__c, acc.PersonMobilePhone);
        System.assertEquals(mini.Birthdate__c, acc.PersonBirthdate);
        System.assertEquals(mini.Gender__c, acc.Gender__pc);
        System.assertEquals(mini.postal_code__c, acc.PersonMailingPostalCode);
        System.assertEquals(Null, acc.PersonMailingState);
        System.assertEquals(Null, acc.PersonMailingCity);
        System.assertEquals(mini.address1__c + mini.address2__c, acc.PersonMailingStreet);
        System.assertEquals(mini.Email__c, acc.PersonEmail);
        
        List<Opportunity> oppUpt = [Select id From Opportunity ];
        Opportunity oppt = triggerTest.getOpportunityById(oppUpt[1].id);
        System.assertEquals(oppt.Question1__c , mini.Question1__c);
        System.assertEquals(oppt.Question2__c , mini.Question2__c);
        System.assertEquals(oppt.Question3__c , mini.Question3__c);
        System.assertEquals(oppt.Question4__c , mini.Question4__c);
        System.assertEquals(oppt.Question5__c , mini.Question5__c);
        System.assertEquals(oppt.Question6__c , mini.Question6__c);
        System.assertEquals(oppt.Question7__c , mini.Question7__c);
        System.assertEquals(oppt.Question8__c , mini.Question8__c);
        System.assertEquals(oppt.Question9__c , mini.Question9__c);
        System.assertEquals(oppt.Question10__c , mini.Question10__c);
        System.assertEquals(oppt.Answer1__c , mini.Answer1__c);
        System.assertEquals(oppt.Answer2__c , mini.Answer2__c);
        System.assertEquals(oppt.Answer2_1__c , mini.Answer2_1__c);
        System.assertEquals(oppt.Answer2_2__c , mini.Answer2_2__c);
        System.assertEquals(oppt.Answer3__c , mini.Answer3__c);
        System.assertEquals(oppt.Answer4__c , mini.Answer4__c);
        System.assertEquals(oppt.Answer5__c , mini.Answer5__c);
        System.assertEquals(oppt.Answer6__c , mini.Answer6__c);
        System.assertEquals(oppt.Answer7__c , mini.Answer7__c);
        System.assertEquals(oppt.Answer8__c , mini.Answer8__c);
        System.assertEquals(oppt.Answer9__c , mini.Answer9__c);
        System.assertEquals(oppt.Answer10__c , mini.Answer10__c);
        System.assertNotEquals(oppt.MiniUpdateDate__c ,null);
        System.assertEquals(oppt.InflowRoute__c ,'ミニ保険');
    }
    
    @isTest
    static void MiniInsuranceTriggerAccountName_Birthday_Gender_MatchTest(){
        MiniInsuranceTriggerTest triggerTest = new MiniInsuranceTriggerTest();
        
        Account account = triggerTest.createAccount();
        insert  account;
        
        Opportunity opp = triggerTest.createOpportunityHanyo(account.id);
        opp.MiniUpdateDate__c = null;
        insert opp;
        
        for (Integer i = 0; i < 500; i++) {
            System.debug('Sleep thread !');
        }
        
        Account act = [Select LastName From Account limit 1];
        
        Account account2 = triggerTest.createAccount();
        account2.LastName = act.LastName;
        account2.PersonMailingPostalCode = '111-1234';
        // System.DmlException: Insert failed. 
        // First exception on row 0; 
        // first error: DUPLICATES_DETECTED, いずれか 1 つのレコードを使用しますか?: []
        //insert  account2;
        
        Opportunity opp2 = triggerTest.createOpportunityHanyo(account2.id);
        opp2.MiniUpdateDate__c = null;
        insert opp2;
        
        for (Integer i = 0; i < 500; i++) {
            System.debug('Sleep thread !');
        }
        //  同じ取引先に、同じメーカーのオープンな商談が存在します。: [] Because of this error Commented
        Opportunity opp3 = triggerTest.createOpportunityHanyo(account2.id);
        //insert opp3;
        
        
        Test.startTest();
        MiniInsurance__c mini = triggerTest.createMiniInsurance(null);
        mini.LastName__c = '個人';
        mini.FirstName__c = '取引先';
        mini.last_name_kana__c = 'コジン';
        mini.first_name_kana__c = 'トリヒキサキ';
        mini.Birthdate__c = date.newInstance(1998, 1, 10);
        mini.Gender__c = '女性';
        insert mini;
        
        Test.stopTest();
        
        Id accId = [SELECT Id, AccountId__c FROM miniInsurance__c WHERE Id =: mini.Id LIMIT 1].AccountId__c;
        Account acc = triggerTest.getAccountById(accId);
        List<Account> accList = [Select id from Account];
        System.assertEquals(1, accList.Size());
        System.assertEquals(mini.LastName__c, acc.LastName__pc);
        System.assertEquals(mini.FirstName__c, acc.firstname__pc);
        System.assertEquals(mini.last_name_kana__c, acc.furiganaLast__pc);
        System.assertEquals(mini.first_name_kana__c, acc.furiganaForst__pc);
        System.assertEquals(mini.mobile_num__c, acc.PersonMobilePhone);
        System.assertEquals(mini.Birthdate__c, acc.PersonBirthdate);
        System.assertEquals(mini.Gender__c, acc.Gender__pc);
        System.assertEquals(mini.PostalCode__c, acc.PersonMailingPostalCode);
        System.assertEquals(Null, acc.PersonMailingState);
        System.assertEquals(Null, acc.PersonMailingCity);
        System.assertEquals(mini.address1__c + mini.address2__c, acc.PersonMailingStreet);
        System.assertEquals(mini.Email__c, acc.PersonEmail);
        
        
        List<Opportunity> oppUpt = [Select id From Opportunity ];
        Opportunity oppt1 = triggerTest.getOpportunityById(oppUpt[1].id);
        Opportunity oppt2 = triggerTest.getOpportunityById(oppUpt[0].id);
        Id oppId = [SELECT Id, OpportunityId__c FROM miniInsurance__c WHERE Id =: mini.Id LIMIT 1].OpportunityId__c;
        Opportunity oppt = triggerTest.getOpportunityById(oppId);
        System.assertEquals(oppt1.StageName , oppt2.StageName);
        System.assertEquals( '未対応', oppt2.StageName);
        System.assertEquals(2,oppUpt.Size());
        System.assertEquals(oppt.Question1__c , mini.Question1__c);
        System.assertEquals(oppt.Question2__c , mini.Question2__c);
        System.assertEquals(oppt.Question3__c , mini.Question3__c);
        System.assertEquals(oppt.Question4__c , mini.Question4__c);
        System.assertEquals(oppt.Question5__c , mini.Question5__c);
        System.assertEquals(oppt.Question6__c , mini.Question6__c);
        System.assertEquals(oppt.Question7__c , mini.Question7__c);
        System.assertEquals(oppt.Question8__c , mini.Question8__c);
        System.assertEquals(oppt.Question9__c , mini.Question9__c);
        System.assertEquals(oppt.Question10__c , mini.Question10__c);
        System.assertEquals(oppt.Answer1__c , mini.Answer1__c);
        System.assertEquals(oppt.Answer2__c , mini.Answer2__c);
        System.assertEquals(oppt.Answer2_1__c , mini.Answer2_1__c);
        System.assertEquals(oppt.Answer2_2__c , mini.Answer2_2__c);
        System.assertEquals(oppt.Answer3__c , mini.Answer3__c);
        System.assertEquals(oppt.Answer4__c , mini.Answer4__c);
        System.assertEquals(oppt.Answer5__c , mini.Answer5__c);
        System.assertEquals(oppt.Answer6__c , mini.Answer6__c);
        System.assertEquals(oppt.Answer7__c , mini.Answer7__c);
        System.assertEquals(oppt.Answer8__c , mini.Answer8__c);
        System.assertEquals(oppt.Answer9__c , mini.Answer9__c);
        System.assertEquals(oppt.Answer10__c , mini.Answer10__c);
        System.assertNotEquals(oppt.InflowRoute__c ,'ミニ保険');
        System.assertNotEquals(oppt.MiniUpdateDate__c ,null);
    }

    @isTest
    public static void target_value_changed(){
        MiniInsuranceTriggerTest triggerTest = new MiniInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        MiniInsurance__c m = triggerTest.createMiniInsurance(account.Id);
        insert m;
        // birthdate
        Account before = triggerTest.getAccountById(account.Id);
        m.Birthdate__c = date.newInstance(1991, 11, 21);
        triggerTest.waitSeconds(1);
        update m;
        Account after = triggerTest.getAccountById(account.Id);
        System.assert(before.lastModifiedDate < after.lastModifiedDate);

        // Gender__c
        m.Gender__c = '女性';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update m;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);

        // easy_id__c
        m.easy_id__c = '444444';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update m;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);

        // Email__c
        m.Email__c = 'rakuten999999@rexample.com';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update m;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);

        // phone_num__c
        m.phone_num__c = '9988882222';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update m;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);

        // mobile_num__c
        m.mobile_num__c = '9988882222';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update m;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);

        // LastName__c
        m.LastName__c = 'テスト０００１';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update m;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);

        // FirstName__c
        m.FirstName__c = 'テスト０００１';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update m;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);

        // last_name_kana__c
        m.last_name_kana__c = 'テストレイレイレイイチ';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update m;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);

        // first_name_kana__c
        m.first_name_kana__c = 'テストレイレイレイイチ';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update m;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);

        // postal_code__c
        m.postal_code__c = '9870123';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update m;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);

        // address1__c
        m.address1__c = '東京都品川区';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update m;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);

        // address2__c
        m.address2__c = '高輪１－１－１';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update m;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);

        // other
        m.Company__c = 'AAAAA';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update m;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate == after.LastModifiedDate);

        Test.stopTest();
        
    }

    private void waitSeconds(Integer seconds) {
        Long startTime = DateTime.now().getTime();
        Long finishTime = DateTime.now().getTime();
        while ((finishTime - startTime) < seconds * 1000) {
            finishTime = DateTime.now().getTime();
        }
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
            PersonHomePhone = '11-1111-1111',
            PersonMobilePhone = '22-2222-2222',
            PersonBirthdate = date.newInstance(1998, 1, 10),
            Gender__pc = '女性',
            SYSAccountName__c = '楽天太郎ﾗｸﾃﾝﾀﾛｳ',
            PersonMailingPostalCode = '111-0000',
            PersonMailingState = '東京都',
            PersonMailingCity = '世田谷区',
            PersonMailingStreet = '玉川１－１４－１',
            PersonEmail = 'example01@example.com',
            RecordTypeId=recordTypes[0].Id
        );
    }
    
    private MiniInsurance__c createMiniInsurance(Id accountId){
        return new MiniInsurance__c(
            easy_id__c = '1111111',
            LastName__c = '楽天',
            FirstName__c = '太郎',
            last_name_kana__c = 'ﾗｸﾃﾝ',
            first_name_kana__c = 'ﾀﾛｳ',
            Phone__c = '99-9999-9999',
            MobilePhone__c = '88-8888-8888',
            phone_num__c = '99-9999-9999',
            mobile_num__c = '88-8888-8888',
            Birthdate__c = date.newInstance(1990, 11, 21),
            Gender__c = '男性',
            PostalCode__c = '222-2222',
            postal_code__c = '222-2222',
            State__c = '東京都',
            City__c = '千代田区',
            address1__c = '麹町 6-6',
            address2__c = '東急四谷ビル',
            Email__c = 'example02@example.com',
            AccountId__c = accountId,
            Answer10__c = 'Answer10Test Value', 
            Answer1__c = 'Answer1Test Value', 
            Answer2_1__c = 'Answer2_1Test Value', 
            Answer2_2__c = 'Answer2_2Test Value', 
            Answer2__c = 'Answer2Test Value', 
            Answer3__c = 'Answer3Test Value', 
            Answer4__c = 'Answer4Test Value', 
            Answer5__c = 'Answer5Test Value', 
            Answer6__c = 'Answer6Test Value', 
            Answer7__c = 'Answer7Test Value', 
            Answer8__c = 'Answer8Test Value', 
            Answer9__c = 'Answer9Test Value', 
            Question10__c = 'Question10test value', 
            Question1__c = 'Question1test value', 
            Question2__c = 'Question2test value', 
            Question3__c = 'Question3test value', 
            Question4__c = 'Question4test value', 
            Question5__c = 'Question5test value', 
            Question6__c = 'Question6test value', 
            Question7__c = 'Question7test value', 
            Question8__c = 'Question8test value', 
            Question9__c = 'Question9test value'
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
    
    private Opportunity createOpportunityHanyo(Id accountId) {
        List<RecordType> recordTypes = [SELECT Id, Name 
                                        FROM   RecordType 
                                        WHERE  SobjectType = 'Opportunity' 
                                        And    Name = '汎用' 
                                        ORDER BY Name ASC LIMIT 50];
        return new Opportunity(
            Name = '1111111',
            AccountId = accountId,
            StageName = '未対応',
            FirstCallDateTime__c = System.today(),
            FirstProbability__c = 'test',
            CloseDate = System.today(),
            RecordTypeId=recordTypes[0].Id,
            MiniUpdateDate__c = System.now()
        );
    }
    
    private Account getAccountById( Id accountId ) {
        return [SELECT Id, Name, LastName, FirstName, furiganaLast__pc, furiganaForst__pc, 
                       PersonHomePhone, PersonMobilePhone, PersonBirthdate, Gender__pc, 
                       SYSAccountName__c, PersonMailingPostalCode, PersonMailingState, 
                       PersonMailingCity, PersonMailingStreet, PersonEmail,LastName__pc,firstname__pc,
                       OperationType__c,OpportunityStatus__c, LastModifiedDate, SystemModStamp 
                FROM   Account
                WHERE  Id =: accountId LIMIT 1];
    }
    
    private MiniInsurance__c getMiniInsuranceById( Id miniId ) {
        return [SELECT Id, Name, easy_id__c,OpportunityId__c,LastName__c, FirstName__c, last_name_kana__c, 
                       first_name_kana__c, Phone__c, mobile_num__c, Birthdate__c, Gender__c, phone_num__c,MobilePhone__c,postal_code__c,
                       PostalCode__c, State__c, City__c, address1__c, address2__c, AccountId__c, Question1__c,Question2__c,Question3__c,Question4__c,Question5__c,Question6__c,Question7__c,
                        Question8__c,Question9__c,Question10__c,Answer1__c,Answer2__c,Answer2_1__c,Answer2_2__c,Answer3__c,Answer4__c,
                        Answer5__c,Answer6__c,Answer7__c,Answer8__c,Answer9__c,
                        Answer10__c,Email__c
                        FROM   MiniInsurance__c 
                        WHERE  Id =: miniId LIMIT 1];
    }
    
    private Opportunity getOpportunityById( Id oppId ) {
        return [SELECT Question1__c,Question2__c,Question3__c,Question4__c,Question5__c,Question6__c,Question7__c,
                Question8__c,Question9__c,Question10__c,Answer1__c,Answer2__c,Answer2_1__c,Answer2_2__c,Answer3__c,Answer4__c,
                Answer5__c,Answer6__c,Answer7__c,Answer8__c,Answer9__c,
                Answer10__c,InflowRoute__c,MiniUpdateDate__c,StageName FROM Opportunity WHERE  Id =: oppId LIMIT 1];
    }
}