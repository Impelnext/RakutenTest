@isTest
public class ExternaldatasourceTriggerTest
{
    @isTest
    static void ExternaldatasourceTriggerTest()
    {
        ExternaldatasourceTriggerTest triggerTest = new ExternaldatasourceTriggerTest();
        
        Account account = triggerTest.createAccount();
        insert  account;
        account = triggerTest.getAccountById(account.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        Externaldatasource__c ex = triggerTest.createextDataSrcInsurance(account.Id);
        insert ex;
        Test.stopTest();
        
        Externaldatasource__c extDataSrc = triggerTest.getextDataSrcInsuranceById(ex.Id);
        Account acc = triggerTest.getAccountById(account.Id);
        
        System.assertEquals(extDataSrc.AccountId__c, acc.id);
        
    }
    
    @isTest
    static void extDataSrcInsuranceTriggerTest_non_AccountId()
    {
        ExternaldatasourceTriggerTest triggerTest = new ExternaldatasourceTriggerTest();
        
        Account account = triggerTest.createAccount();
        insert  account;
        
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        Externaldatasource__c extDataSrc = triggerTest.createextDataSrcInsurance(null);
        insert extDataSrc;
        Test.stopTest();
        
        Id accId = [SELECT Id, AccountId__c FROM Externaldatasource__c WHERE Id =: extDataSrc.Id LIMIT 1].AccountId__c;
        Externaldatasource__c extData = triggerTest.getextDataSrcInsuranceById(extDataSrc.Id);
        System.assertNotEquals(extData.AccountId__c, account.id);
        
    }
    
    @isTest
    static void extDataSrcInsuranceTriggerTest_non_Account_easy_Id_unmatch() {
        ExternaldatasourceTriggerTest triggerTest = new ExternaldatasourceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        
        Externaldatasource__c ex = triggerTest.createextDataSrcInsurance(null);
        ex.easyId__c = null;
        insert ex;
        
        Test.stopTest();
    }
    
    @isTest
    static void extDataSrcInsuranceTriggerTest_non_Account_easy_Id_match() {
        ExternaldatasourceTriggerTest triggerTest = new ExternaldatasourceTriggerTest();
        Account acc = triggerTest.createAccount();
        acc.easyId__pc = '1111111';
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        Externaldatasource__c ex = triggerTest.createextDataSrcInsurance(null);
        ex.easyId__c = acc.easyId__pc;
        insert ex;
        Test.stopTest();
        
        Externaldatasource__c extDataSrc = triggerTest.getextDataSrcInsuranceById(ex.Id);
        Account resultAcc = triggerTest.getAccountById(extDataSrc.accountId__c);
        
        System.assertNotEquals(extDataSrc.accountId__c, acc.Id);
    }
    
    @isTest
    static void extDataSrcInsuranceTriggerTest_name_phone() {
        ExternaldatasourceTriggerTest triggerTest = new ExternaldatasourceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        Externaldatasource__c ex = triggerTest.createextDataSrcInsurance(null);
        ex.LastName__c = account.LastName;
        ex.FirstName__c = account.FirstName;
        ex.LastNameFurigana__c = account.furiganaLast__pc;
        ex.FirstNameFurigana__c = account.furiganaForst__pc;
        ex.HomePhone__c= account.PersonHomePhone;
        ex.MobilePhone__c = account.PersonMobilePhone;
        insert ex;
        Test.stopTest();
        
        Externaldatasource__c extDataSrc = triggerTest.getextDataSrcInsuranceById(ex.Id);
        Account resultAcc = triggerTest.getAccountById(acc.Id);
        
        System.assertEquals(extDataSrc.accountId__c, resultAcc.Id);
    }
    
    @isTest
    static void extDataSrcInsuranceTriggerTest_name_mobilephone() {
        ExternaldatasourceTriggerTest triggerTest = new ExternaldatasourceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;

        Account account = triggerTest.getAccountById(acc.Id);
        insert  triggerTest.createOpportunity(account.Id);

        Test.startTest();
        Externaldatasource__c ex = triggerTest.createextDataSrcInsurance(null);
        ex.LastName__c = account.LastName;
        ex.FirstName__c = account.FirstName;
        ex.LastNameFurigana__c = account.furiganaLast__pc;
        ex.FirstNameFurigana__c = account.furiganaForst__pc;
        ex.MobilePhone__c = account.PersonMobilePhone;
        ex.HomePhone__c = account.PersonHomePhone;
        insert ex;
        Test.stopTest();

        Externaldatasource__c extDataSrc = triggerTest.getextDataSrcInsuranceById(ex.Id);
        Account resultAcc = triggerTest.getAccountById(acc.Id);

        System.assertEquals(extDataSrc.LastName__c, resultAcc.LastName);
        System.assertEquals(extDataSrc.FirstName__c, resultAcc.FirstName);
        System.assertEquals(extDataSrc.LastNameFurigana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(extDataSrc.FirstNameFurigana__c, resultAcc.furiganaForst__pc);
       
        System.assertEquals(extDataSrc.accountId__c, resultAcc.Id);
       
        List<Opportunity> oppUpt = [Select id From Opportunity ];   
        Opportunity oppt = triggerTest.getOpportunityById(extDataSrc.OpportunityId__c);       
        System.assertEquals(2, oppUpt.Size());
        System.assertNotEquals(oppUpt[0].id , extDataSrc.OpportunityId__c);
        System.assertEquals(oppt.Item1__c , extDataSrc.Item1__c);
        System.assertEquals(oppt.Item2__c , extDataSrc.Item2__c);
        System.assertEquals(oppt.Item3__c , extDataSrc.Item3__c);
        System.assertEquals(oppt.Item4__c , extDataSrc.Item4__c);
        System.assertEquals(oppt.Item5__c , extDataSrc.Item5__c);
        System.assertEquals(oppt.Item6__c , extDataSrc.Item6__c);
        System.assertEquals(oppt.Item7__c , extDataSrc.Item7__c);
        System.assertEquals(oppt.Item8__c , extDataSrc.Item8__c);
        System.assertEquals(oppt.Item9__c , extDataSrc.Item9__c);
        System.assertEquals(oppt.Item10__c , extDataSrc.Item10__c);
        System.assertEquals(oppt.ItemLong1__c , extDataSrc.ItemLong1__c);
        System.assertEquals(oppt.ItemLong2__c , extDataSrc.ItemLong2__c);
        System.assertEquals(oppt.ItemLong3__c , extDataSrc.ItemLong3__c);
        System.assertEquals(oppt.ItemLong4__c , extDataSrc.ItemLong4__c);
        System.assertEquals(oppt.ItemLong5__c , extDataSrc.ItemLong5__c);
        System.assertEquals(oppt.ItemLong6__c , extDataSrc.ItemLong6__c);
        System.assertEquals(oppt.ItemLong7__c , extDataSrc.ItemLong7__c);
        System.assertEquals(oppt.ItemLong8__c , extDataSrc.ItemLong8__c);
        System.assertEquals(oppt.ItemLong9__c , extDataSrc.ItemLong9__c);
        System.assertEquals(oppt.ItemLong10__c , extDataSrc.ItemLong10__c);
        System.assertNotEquals(oppt.InflowRoute__c ,'ミニ保険');
        System.assertNotEquals(oppt.ExLeadUpdateDate__c,null);    
    }
    @isTest
    static void extDataSrcInsuranceTriggerTest_name_mobilephone_HanyoOpp() {
        ExternaldatasourceTriggerTest triggerTest = new ExternaldatasourceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        Account account = triggerTest.getAccountById(acc.Id);
        Opportunity opp =  triggerTest.createOpportunityHanyo(account.Id);
        opp.ExLeadUpdateDate__c = null;
        insert opp;
        
        Test.startTest();
        Externaldatasource__c extDataSrc = triggerTest.createextDataSrcInsurance(null);
        extDataSrc.LastName__c = account.LastName;
        extDataSrc.FirstName__c = account.FirstName;
        extDataSrc.LastNameFurigana__c = account.furiganaLast__pc;
        extDataSrc.FirstNameFurigana__c = account.furiganaForst__pc;
        extDataSrc.MobilePhone__c = account.PersonMobilePhone;
        extDataSrc.HomePhone__c = account.PersonHomePhone;
        insert extDataSrc;
        Test.stopTest();

        Id accId = [SELECT id,AccountId__c FROM Externaldatasource__c WHERE Id =: extDataSrc.Id LIMIT 1].AccountId__c;
        Account resultAcc = triggerTest.getAccountById(accId);
        Externaldatasource__c extData = triggerTest.getextDataSrcInsuranceById(extDataSrc.Id);
        System.assertEquals(extData.accountId__c, resultAcc.Id);
        
        List<Opportunity> oppUpt = [Select id From Opportunity ];   
        Opportunity oppt = triggerTest.getOpportunityById(extData.OpportunityId__c);       
        System.assertEquals(1, oppUpt.Size());
         System.assertEquals(oppt.Item1__c , extData.Item1__c);
        System.assertEquals(oppt.Item2__c , extData.Item2__c);
        System.assertEquals(oppt.Item3__c , extData.Item3__c);
        System.assertEquals(oppt.Item4__c , extData.Item4__c);
        System.assertEquals(oppt.Item5__c , extData.Item5__c);
        System.assertEquals(oppt.Item6__c , extData.Item6__c);
        System.assertEquals(oppt.Item7__c , extData.Item7__c);
        System.assertEquals(oppt.Item8__c , extData.Item8__c);
        System.assertEquals(oppt.Item9__c , extData.Item9__c);
        System.assertEquals(oppt.Item10__c , extData.Item10__c);
        System.assertEquals(oppt.ItemLong1__c , extData.ItemLong1__c);
        System.assertEquals(oppt.ItemLong2__c , extData.ItemLong2__c);
        System.assertEquals(oppt.ItemLong3__c , extData.ItemLong3__c);
        System.assertEquals(oppt.ItemLong4__c , extData.ItemLong4__c);
        System.assertEquals(oppt.ItemLong5__c , extData.ItemLong5__c);
        System.assertEquals(oppt.ItemLong6__c , extData.ItemLong6__c);
        System.assertEquals(oppt.ItemLong7__c , extData.ItemLong7__c);
        System.assertEquals(oppt.ItemLong8__c , extData.ItemLong8__c);
        System.assertEquals(oppt.ItemLong9__c , extData.ItemLong9__c);
        System.assertEquals(oppt.ItemLong10__c , extData.ItemLong10__c);
        System.assertNotEquals(oppt.InflowRoute__c ,'ミニ保険');
        System.assertNotEquals(oppt.ExLeadUpdateDate__c,null);    
        
    }
    @isTest
    static void extDataSrcInsuranceTriggerTest_name_gender_Birthdate() {
        ExternaldatasourceTriggerTest triggerTest = new ExternaldatasourceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;

        Account account = triggerTest.getAccountById(acc.Id);
        insert  triggerTest.createOpportunity(account.Id);

        Test.startTest();
        Externaldatasource__c ex = triggerTest.createextDataSrcInsurance(null);
        ex.LastName__c = account.LastName;
        ex.FirstName__c = account.FirstName;
        ex.LastNameFurigana__c = account.furiganaLast__pc;
        ex.FirstNameFurigana__c = account.furiganaForst__pc;
        ex.Gender__c = account.Gender__pc;
        ex.Birthday__c = account.PersonBirthdate;
        insert ex;
        Test.stopTest();

        Externaldatasource__c extDataSrc = triggerTest.getextDataSrcInsuranceById(ex.Id);
        Account resultAcc = triggerTest.getAccountById(acc.Id);

        System.assertEquals(extDataSrc.LastName__c, resultAcc.LastName);
        System.assertEquals(extDataSrc.FirstName__c, resultAcc.FirstName);
        System.assertEquals(extDataSrc.LastNameFurigana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(extDataSrc.FirstNameFurigana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(acc.PersonBirthdate, resultAcc.PersonBirthdate);
        System.assertEquals(acc.Gender__pc, resultAcc.Gender__pc);
        System.assertEquals(extDataSrc.accountId__c, resultAcc.Id);
        
    }

    @isTest
    static void onBeforeUpdateProccessTest() {
        ExternaldatasourceTriggerTest triggerTest = new ExternaldatasourceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;

        Account account = triggerTest.getAccountById(acc.Id);
        insert  triggerTest.createOpportunity(account.Id);

        Test.startTest();
        Externaldatasource__c ex = triggerTest.createextDataSrcInsurance(account.Id);
        insert ex;
        update ex;
        Test.stopTest();

        Externaldatasource__c extDataSrc = triggerTest.getextDataSrcInsuranceById(ex.Id);
        Account resultAcc = triggerTest.getAccountById(acc.Id);

        System.assertEquals(extDataSrc.accountId__c, resultAcc.Id);
         
    }
    @isTest
    static void extDataSrcInsuranceTriggerExOppNoExUpdateTest()
    {
        ExternaldatasourceTriggerTest triggerTest = new ExternaldatasourceTriggerTest();

        Account account = triggerTest.createAccount();
        insert  account;
        account = triggerTest.getAccountById(account.Id);

        Opportunity opp = triggerTest.createOpportunityHanyo(account.Id);
        opp.ExLeadUpdateDate__c = null;
        insert opp;


        Test.startTest();
        Externaldatasource__c ex= triggerTest.createextDataSrcInsurance(account.Id);
        ex.LastName__c = '個人';
        ex.FirstName__c = '取引先';
        ex.LastNameFurigana__c = 'コジン';
        ex.FirstNameFurigana__c = 'トリヒキサキ';
        ex.HomePhone__c = '11-1111-1111';
        insert ex;
        Test.stopTest();
        
        Externaldatasource__c extDataSrc = triggerTest.getextDataSrcInsuranceById(ex.Id);
        Account acc = triggerTest.getAccountById(account.Id);
        
        System.assertEquals(extDataSrc.AccountId__c, acc.Id);
      
        
        List<Opportunity> oppUpt = [Select id From Opportunity ];
        Opportunity oppt = triggerTest.getOpportunityById(oppUpt[0].id);
        System.assertEquals(oppt.Item1__c , extDataSrc.Item1__c);
        System.assertEquals(oppt.Item2__c , extDataSrc.Item2__c);
        System.assertEquals(oppt.Item3__c , extDataSrc.Item3__c);
        System.assertEquals(oppt.Item4__c , extDataSrc.Item4__c);
        System.assertEquals(oppt.Item5__c , extDataSrc.Item5__c);
        System.assertEquals(oppt.Item6__c , extDataSrc.Item6__c);
        System.assertEquals(oppt.Item7__c , extDataSrc.Item7__c);
        System.assertEquals(oppt.Item8__c , extDataSrc.Item8__c);
        System.assertEquals(oppt.Item9__c , extDataSrc.Item9__c);
        System.assertEquals(oppt.Item10__c , extDataSrc.Item10__c);
        System.assertEquals(oppt.ItemLong1__c , extDataSrc.ItemLong1__c);
        System.assertEquals(oppt.ItemLong2__c , extDataSrc.ItemLong2__c);
        System.assertEquals(oppt.ItemLong3__c , extDataSrc.ItemLong3__c);
        System.assertEquals(oppt.ItemLong4__c , extDataSrc.ItemLong4__c);
        System.assertEquals(oppt.ItemLong5__c , extDataSrc.ItemLong5__c);
        System.assertEquals(oppt.ItemLong6__c , extDataSrc.ItemLong6__c);
        System.assertEquals(oppt.ItemLong7__c , extDataSrc.ItemLong7__c);
        System.assertEquals(oppt.ItemLong8__c , extDataSrc.ItemLong8__c);
        System.assertEquals(oppt.ItemLong9__c , extDataSrc.ItemLong9__c);
        System.assertEquals(oppt.ItemLong10__c , extDataSrc.ItemLong10__c);
        System.assertNotEquals(oppt.InflowRoute__c ,'ミニ保険');
        System.assertNotEquals(oppt.ExLeadUpdateDate__c,null);      
   
    }
     
    @isTest
    static void extDataSrcInsuranceTriggerExOppExUpdateTest()
    {
        ExternaldatasourceTriggerTest triggerTest = new ExternaldatasourceTriggerTest();

        Account account = triggerTest.createAccount();
        insert  account;
        account = triggerTest.getAccountById(account.Id);

        Opportunity opp = triggerTest.createOpportunityHanyo(account.Id);
        insert opp;

        Test.startTest();
        Externaldatasource__c ex= triggerTest.createextDataSrcInsurance(account.Id);
        ex.LastName__c = null;
        ex.FirstName__c = null;
        insert ex;
        Test.stopTest();
        
        Externaldatasource__c extDataSrc = triggerTest.getextDataSrcInsuranceById(ex.Id);
        Account acc = triggerTest.getAccountById(account.Id);
        System.assertEquals(extDataSrc.AccountId__c, acc.Id);
        
        List<Opportunity> oppUpt = [Select id From Opportunity ];
        Opportunity oppt = triggerTest.getOpportunityById(oppUpt[0].id);
      
    }    
    @isTest
    static void extDataSrcInsuranceTriggerAccountName_Phone_MatchTest(){
        ExternaldatasourceTriggerTest triggerTest = new ExternaldatasourceTriggerTest();
        
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
        Externaldatasource__c ex= triggerTest.createextDataSrcInsurance(account.Id);
        ex.LastName__c = '個人';
        ex.FirstName__c = '取引先';
        ex.LastNameFurigana__c = 'コジン';
        ex.FirstNameFurigana__c = 'トリヒキサキ';
        ex.HomePhone__c = '11-1111-1111';
        insert ex;
        Test.stopTest();
        
        Externaldatasource__c extDataSrc = triggerTest.getextDataSrcInsuranceById(ex.Id);
        Id accId = [SELECT Id, AccountId__c FROM Externaldatasource__c WHERE Id =: ex.Id LIMIT 1].AccountId__c;
        Account acc = triggerTest.getAccountById(accId);
        System.assertEquals(extDataSrc.AccountId__c, acc.id);
        
        List<Opportunity> oppUpt = [Select id From Opportunity ];
        Opportunity oppt = triggerTest.getOpportunityById(oppUpt[1].id);
        System.assertEquals(oppt.Item1__c , extDataSrc.Item1__c);
        System.assertEquals(oppt.Item2__c , extDataSrc.Item2__c);
        System.assertEquals(oppt.Item3__c , extDataSrc.Item3__c);
        System.assertEquals(oppt.Item4__c , extDataSrc.Item4__c);
        System.assertEquals(oppt.Item5__c , extDataSrc.Item5__c);
        System.assertEquals(oppt.Item6__c , extDataSrc.Item6__c);
        System.assertEquals(oppt.Item7__c , extDataSrc.Item7__c);
        System.assertEquals(oppt.Item8__c , extDataSrc.Item8__c);
        System.assertEquals(oppt.Item9__c , extDataSrc.Item9__c);
        System.assertEquals(oppt.Item10__c , extDataSrc.Item10__c);
        System.assertEquals(oppt.ItemLong1__c , extDataSrc.ItemLong1__c);
        System.assertEquals(oppt.ItemLong2__c , extDataSrc.ItemLong2__c);
        System.assertEquals(oppt.ItemLong3__c , extDataSrc.ItemLong3__c);
        System.assertEquals(oppt.ItemLong4__c , extDataSrc.ItemLong4__c);
        System.assertEquals(oppt.ItemLong5__c , extDataSrc.ItemLong5__c);
        System.assertEquals(oppt.ItemLong6__c , extDataSrc.ItemLong6__c);
        System.assertEquals(oppt.ItemLong7__c , extDataSrc.ItemLong7__c);
        System.assertEquals(oppt.ItemLong8__c , extDataSrc.ItemLong8__c);
        System.assertEquals(oppt.ItemLong9__c , extDataSrc.ItemLong9__c);
        System.assertEquals(oppt.ItemLong10__c , extDataSrc.ItemLong10__c);
        System.assertNotEquals(oppt.InflowRoute__c ,'ミニ保険');
        System.assertNotEquals(oppt.ExLeadUpdateDate__c,null);
    }
    
    @isTest
    static void extDataSrcTriggerAccountName_Birthday_Gender_MatchTest(){
        ExternaldatasourceTriggerTest triggerTest = new ExternaldatasourceTriggerTest();
        
        Account account = triggerTest.createAccount();
        insert  account;
        
        Opportunity opp = triggerTest.createOpportunityHanyo(account.id);
        opp.ExLeadUpdateDate__c = null;
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
        opp2.ExLeadUpdateDate__c = null;
        insert opp2;
       
        
        for (Integer i = 0; i < 500; i++) {
            System.debug('Sleep thread !');
        }
        //  同じ取引先に、同じメーカーのオープンな商談が存在します。: [] Because of this error Commented
        Opportunity opp3 = triggerTest.createOpportunityHanyo(account2.id);
        //insert opp3;
        
        
        Test.startTest();
        Externaldatasource__c ex = triggerTest.createextDataSrcInsurance(null);
        ex.LastName__c = account.LastName;
        ex.FirstName__c = account.FirstName;
        ex.LastNameFurigana__c = account.furiganaLast__pc;
        ex.FirstNameFurigana__c = account.furiganaForst__pc;
        ex.Gender__c = account.Gender__pc;
        ex.Birthday__c = account.PersonBirthdate;
        insert ex;
        
        Test.stopTest();
        
        Externaldatasource__c extDataSrc = triggerTest.getextDataSrcInsuranceById(ex.Id);
        Id accId = [SELECT Id, AccountId__c FROM Externaldatasource__c WHERE Id =: ex.Id LIMIT 1].AccountId__c;
        Account acc = triggerTest.getAccountById(accId);
        List<Account> accList = [Select id from Account];
        System.assertEquals(1, accList.Size());
        System.assertEquals(extDataSrc.AccountId__c, acc.id);
        
        List<Opportunity> oppUpt = [Select id From Opportunity ];
        Opportunity oppt1 = triggerTest.getOpportunityById(oppUpt[1].id);
        Opportunity oppt2 = triggerTest.getOpportunityById(oppUpt[0].id);
        Id oppId = [SELECT Id, OpportunityId__c FROM Externaldatasource__c WHERE Id =: ex.Id LIMIT 1].OpportunityId__c;
        Opportunity oppt = triggerTest.getOpportunityById(oppId);
        System.assertEquals(oppt1.StageName , oppt2.StageName);
        System.assertEquals( '未対応', oppt2.StageName);
        System.assertEquals(2,oppUpt.Size());
        System.assertEquals(oppt.Item1__c , extDataSrc.Item1__c);
        System.assertEquals(oppt.Item2__c , extDataSrc.Item2__c);
        System.assertEquals(oppt.Item3__c , extDataSrc.Item3__c);
        System.assertEquals(oppt.Item4__c , extDataSrc.Item4__c);
        System.assertEquals(oppt.Item5__c , extDataSrc.Item5__c);
        System.assertEquals(oppt.Item6__c , extDataSrc.Item6__c);
        System.assertEquals(oppt.Item7__c , extDataSrc.Item7__c);
        System.assertEquals(oppt.Item8__c , extDataSrc.Item8__c);
        System.assertEquals(oppt.Item9__c , extDataSrc.Item9__c);
        System.assertEquals(oppt.Item10__c , extDataSrc.Item10__c);
        System.assertEquals(oppt.ItemLong1__c , extDataSrc.ItemLong1__c);
        System.assertEquals(oppt.ItemLong2__c , extDataSrc.ItemLong2__c);
        System.assertEquals(oppt.ItemLong3__c , extDataSrc.ItemLong3__c);
        System.assertEquals(oppt.ItemLong4__c , extDataSrc.ItemLong4__c);
        System.assertEquals(oppt.ItemLong5__c , extDataSrc.ItemLong5__c);
        System.assertEquals(oppt.ItemLong6__c , extDataSrc.ItemLong6__c);
        System.assertEquals(oppt.ItemLong7__c , extDataSrc.ItemLong7__c);
        System.assertEquals(oppt.ItemLong8__c , extDataSrc.ItemLong8__c);
        System.assertEquals(oppt.ItemLong9__c , extDataSrc.ItemLong9__c);
        System.assertEquals(oppt.ItemLong10__c , extDataSrc.ItemLong10__c);
        System.assertNotEquals(oppt.InflowRoute__c ,'ミニ保険');
        System.assertNotEquals(oppt.ExLeadUpdateDate__c,null);    
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
    
    private Externaldatasource__c createextDataSrcInsurance(Id accountId){
        return new Externaldatasource__c (
            easyId__c = '1111111',
            LastName__c = '楽天',
            FirstName__c = '太郎',
            LastNameFurigana__c = 'ﾗｸﾃﾝ',
            FirstNameFurigana__c = 'ﾀﾛｳ',
            InternalPhone__c = '99-9999-9999',
            HomePhone__c = '99-9999-9999',
            MobilePhone__c = '88-8888-8888',
            Birthday__c = date.newInstance(1990, 11, 21),
            Gender__c = '男性',
            PostCode__c = '222-2222',
            Prefecture__c = '東京都',
            City__c = '千代田区',
            TownName__c = '麹町 6-6',
            Email__c = 'example02@example.com',
            AccountId__c = accountId,
            Item1__c = 'Item1Test Value', 
            Item2__c = 'Item2Test Value',
            Item3__c = 'Item3Test Value',
            Item4__c = 'Item4Test Value',
            Item5__c= 'Item5Test Value',
            Item6__c= 'Item6Test Value',
            Item7__c= 'Item7Test Value',
            Item8__c= 'Item8Test Value',
            Item9__c= 'Item9Test Value',
            Item10__c= 'Item10Test Value',
            ItemLong1__c= 'ItemLong1Test Value',
            ItemLong2__c= 'ItemLong2Test Value',
            ItemLong3__c= 'ItemLong3Test Value',
            ItemLong4__c= 'ItemLong4Test Value',
            ItemLong5__c= 'ItemLong5Test Value',
            ItemLong6__c= 'ItemLong6Test Value',
            ItemLong7__c= 'ItemLong7Test Value',
            ItemLong8__c= 'ItemLong8Test Value',
            ItemLong9__c = 'ItemLong9Test Value',
            ItemLong10__c= 'ItemLong10Test Value'
            
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
            ExLeadUpdateDate__c  = System.now()
        );
    }
    private Account getAccountById( Id accountId ) {
        return [SELECT Id, Name, LastName, FirstName, furiganaForst__pc, furiganaLast__pc, 
                       PersonHomePhone, PersonMobilePhone, PersonBirthdate, Gender__pc, 
                       SYSAccountName__c, PersonMailingPostalCode, PersonMailingState, 
                       PersonMailingCity, PersonMailingStreet, PersonEmail,LastName__pc,firstname__pc,OperationType__c,OpportunityStatus__c
                FROM   Account
                WHERE  Id =: accountId LIMIT 1];
    }

    private Externaldatasource__c getextDataSrcInsuranceById( Id extDataSrcId ) {
        return [SELECT Id, Name, easyId__c,OpportunityId__c, LastName__c, FirstName__c, LastNameFurigana__c , 
                       FirstNameFurigana__c , InternalPhone__c, HomePhone__c,MobilePhone__c, Birthday__c, Gender__c, 
                       PostCode__c, Prefecture__c, City__c, TownName__c,  AccountId__c, Email__c,Item1__c,Item2__c,Item3__c,Item4__c,Item5__c,Item6__c,Item7__c,Item8__c,Item9__c,
                       Item10__c,ItemLong1__c,ItemLong2__c,ItemLong3__c,ItemLong4__c,ItemLong5__c,ItemLong6__c,ItemLong7__c,ItemLong8__c,ItemLong9__c,ItemLong10__c
                FROM   Externaldatasource__c 
                WHERE  Id =: extDataSrcId LIMIT 1];
    }
    
    private Opportunity getOpportunityById( Id oppId ) {
        return [SELECT Item1__c,Item2__c,Item3__c,Item4__c,Item5__c,Item6__c,Item7__c,Item8__c,Item9__c,
                       Item10__c,ItemLong1__c,ItemLong2__c,ItemLong3__c,ItemLong4__c,ItemLong5__c,
                       ItemLong6__c,ItemLong7__c,ItemLong8__c,ItemLong9__c,ItemLong10__c,
                       InflowRoute__c,ExLeadUpdateDate__c,StageName FROM Opportunity WHERE  Id =: oppId LIMIT 1];
    }
}