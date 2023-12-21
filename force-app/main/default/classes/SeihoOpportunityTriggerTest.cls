@isTest
public class SeihoOpportunityTriggerTest
{
    @isTest
    static void SeihoOpportunityTriggerTest()
    {
        SeihoOpportunityTriggerTest triggerTest = new SeihoOpportunityTriggerTest();

        insert  triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(account.Id);

        Test.startTest();

        SeihoOpportunity__c so = triggerTest.createSeihoOpportunity(account.Id);
        insert so;
        
        Test.stopTest();
        Account acc = triggerTest.getAccountById(account.Id);
         SeihoOpportunity__c result;
        for( SeihoOpportunity__c sOpp : [SELECT Id, Ref_Account__c,ApplicantName__c,ApplicantPhoneNumber__c,ApplicantCellPhoneNumber__c,MobilePhone__c,Birthdate__c,ContractPostalAddress__c,address2__c,Email__c,Gender__c,State__c, ApplicantNameKana__c,ContractPostalCode__c
                                         FROM   SeihoOpportunity__c
                                         WHERE  Id = :so.Id] ) {
            result= sOpp;
        }
        System.assertEquals(acc.Id, result.Ref_Account__c);
        System.assertEquals(result.Ref_Account__c, acc.Id);
       
        System.assertEquals(result.MobilePhone__c, acc.PersonMobilePhone);
        System.assertEquals(result.Birthdate__c, acc.PersonBirthdate);
        System.assertEquals(result.Gender__c, acc.Gender__pc);
        System.assertEquals(result.ContractPostalCode__c, acc.PersonMailingPostalCode);
        System.assertEquals(acc.PersonMailingState,null );
        System.assertEquals(acc.PersonMailingCity,null );
        System.assertEquals(result.ContractPostalAddress__c, acc.PersonMailingStreet);
        System.assertEquals(null, acc.PersonEmail);
        System.assertNotEquals(result.ApplicantPhoneNumber__c, acc.Phone);
        System.assertEquals(result.ApplicantPhoneNumber__c, acc.PersonHomePhone);
        System.assertEquals(result.ApplicantCellPhoneNumber__c, acc.PersonMobilePhone);
        
        System.assertNotEquals(acc.division__pc,'見込み顧客');
        System.assertNotEquals(acc.OperationType__c,'割当可');
        System.assertNotEquals(acc.OpportunityStatus__c,'未対応');
                 
    }
    
    @isTest
    static void SeihoOpportunityTriggerTest_non_AccountId()
    {
        SeihoOpportunityTriggerTest triggerTest = new SeihoOpportunityTriggerTest();

        insert  triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
         insert  triggerTest.createOpportunity(account.Id);

        Test.startTest();

        insert triggerTest.createSeihoOpportunity(null);

        Test.stopTest();
    }
    
    @isTest
    static void SeihoOpportunityTriggerTest_non_Account_easy_Id() {
        SeihoOpportunityTriggerTest triggerTest = new SeihoOpportunityTriggerTest();

        Account acc = triggerTest.createAccount();
        acc.easyId__pc = '1111111';
        insert  acc;
        Account account = [SELECT Id FROM Account LIMIT 1];
        Opportunity opp =  triggerTest.createOpportunity(null);
        opp.ANP__c = 12;
        insert opp;

        Test.startTest();
        SeihoOpportunity__c so = triggerTest.createSeihoOpportunity(null);
        so.ApplyID__c = '';
        so.ApplicantName__c = null;
        so.ApplicationInsuFee__c = '100';
        insert so;
        Test.stopTest();

        SeihoOpportunity__c result;
        for( SeihoOpportunity__c sOpp : [SELECT Id, Ref_Account__c,Opportunity__c,AgentName__c,ApplicationInsuFee__c,Birthdate__c,FirstName__c,LastNameKana__c,
                                        FirstNameKana__c,Gender__c,EasyId__c,Email__c,PostalCode__c,State__c,ApplySts__c,address1__c,ApplicantPhoneNumber__c,ApplicantCellPhoneNumber__c
                                         FROM   SeihoOpportunity__c
                                         WHERE  Id = :so.Id] ) {
            result= sOpp;
        }
        System.assertNotEquals(null, result.Ref_Account__c);
        System.assertNotEquals(acc.Id, result.Ref_Account__c);
        Account acct = triggerTest.getAccountById(result.Ref_Account__c);
        System.assertEquals(result.Birthdate__c, acct.PersonBirthdate);
        System.assertEquals(null, acct.FirstName);
        System.assertEquals(acct.LastName,'未登録');
        System.assertNotEquals(result.LastNameKana__c, acct.furiganaLast__pc);
        System.assertNotEquals(result.FirstNameKana__c, acct.furiganaForst__pc);
        System.assertEquals(result.Gender__c, acct.Gender__pc);
        System.assertEquals(result.EasyId__c, acct.easyId__pc);
        System.assertEquals(result.Email__c, acct.PersonEmail);
        System.assertNotEquals(result.PostalCode__c, acct.PersonMailingPostalCode);
        System.assertNotEquals(result.State__c, acct.PersonMailingState);
        System.assertNotEquals(result.address1__c, acct.PersonMailingCity);
        System.assertEquals(result.ApplicantPhoneNumber__c, acct.Phone);
        System.assertEquals(result.ApplicantPhoneNumber__c, acct.PersonHomePhone);
        System.assertEquals(result.ApplicantCellPhoneNumber__c, acct.PersonMobilePhone);
        
        Opportunity oppt = triggerTest.getOpportunityById(result.Opportunity__c);
        System.assertEquals(oppt.InflowRoute__c ,'申込途中保存');
        System.assertEquals(oppt.StageName,'対応終了');
        System.assertEquals(oppt.telReason__c ,'その他');
        System.assertEquals(oppt.CloseDate ,System.Today());
        String opportunityNameInsertStr = datetime.now().format('yyyyMMdd') + '_' + '生保' + '_';
        System.assertEquals(oppt.Name ,opportunityNameInsertStr+acct.furiganaLast__pc);
        
        System.assertEquals(oppt.CloseType__c ,'申込');
        System.assertEquals(oppt.RecentProbability__c ,'申込済み');
        System.assertEquals(oppt.AgentName__c ,result.AgentName__c);
        System.assertEquals(oppt.ApplySts__c ,result.ApplySts__c);
       
    }

    @isTest
    static void SeihoOpportunityTriggerTest_name_mobilephone_web() {
        SeihoOpportunityTriggerTest triggerTest = new SeihoOpportunityTriggerTest();

        Account acc = triggerTest.createAccount();
        insert  acc;
        Account account = [SELECT Id, SYSAccountName__c FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(null);

        Test.startTest();
        SeihoOpportunity__c so = triggerTest.createSeihoOpportunity(null);
        so.LastName__c = '個人';
        so.FirstName__c = '取引先';
        so.LastNameKana__c = 'コジン';
        so.FirstNameKana__c = 'トリヒキサキ';
        so.ApplicantName__c = null;
        so.ApplicantNameKana__c = null;
        so.Phone__c = '11-2222-3333';
        so.Birthdate__c = date.newInstance(1999, 11, 21);
        so.Gender__c = '女性';
        insert so;
        Test.stopTest();

        SeihoOpportunity__c result;
        for( SeihoOpportunity__c sOpp : [SELECT Id, Ref_Account__c,ApplicantName__c , ApplicantNameKana__c
                                         FROM   SeihoOpportunity__c
                                         WHERE  Id = :so.Id] ) {
            result= sOpp;
        }
        System.assertEquals(acc.Id, result.Ref_Account__c);
    }

    @isTest
    static void SeihoOpportunityTriggerTest_name_phone_web() {
        SeihoOpportunityTriggerTest triggerTest = new SeihoOpportunityTriggerTest();

        Account acc = triggerTest.createAccount();
        insert  acc;
        Account account = [SELECT Id, SYSAccountName__c FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(null);

        Test.startTest();
        SeihoOpportunity__c so = triggerTest.createSeihoOpportunity(null);
        so.LastName__c = '個人';
        so.FirstName__c = '取引先';
        so.LastNameKana__c = 'コジン';
        so.FirstNameKana__c = 'トリヒキサキ';
        so.ApplicantName__c = null;
        so.ApplicantNameKana__c = null;
        so.MobilePhone__c = '11-2222-3333';
        so.Birthdate__c = date.newInstance(1999, 11, 21);
        so.Gender__c = '女性';
        insert so;
        Test.stopTest();

        SeihoOpportunity__c result;
        for( SeihoOpportunity__c sOpp : [SELECT Id, Ref_Account__c,ApplicantName__c , ApplicantNameKana__c
                                         FROM   SeihoOpportunity__c
                                         WHERE  Id = :so.Id] ) {
            result= sOpp;
        }
        System.assertEquals(acc.Id, result.Ref_Account__c);
    }

    @isTest
    static void SeihoOpportunityTriggerTest_name_phone_paper() {
        SeihoOpportunityTriggerTest triggerTest = new SeihoOpportunityTriggerTest();

        Account acc = triggerTest.createAccount();
        insert  acc;
        Account account = [SELECT Id, SYSAccountName__c FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(null);

        Test.startTest();
        SeihoOpportunity__c so = triggerTest.createSeihoOpportunity(null);
        so.ApplyID__c = null;
        so.LastName__c = null;
        so.FirstName__c = null;
        so.LastNameKana__c = null;
        so.FirstNameKana__c = null;
        so.ApplicantName__c = '個人取引先';
        so.ApplicantNameKana__c = 'コジントリヒキサキ';
        so.ApplicantPhoneNumber__c = '11-2222-3333';
        so.Birthdate__c = date.newInstance(1999, 11, 21);
        so.Gender__c = '女性';
        insert so;
        Test.stopTest();

        SeihoOpportunity__c result;
        for( SeihoOpportunity__c sOpp : [SELECT Id, Ref_Account__c,ApplicantName__c , ApplicantNameKana__c
                                         FROM   SeihoOpportunity__c
                                         WHERE  Id = :so.Id] ) {
            result= sOpp;
        }
        System.assertEquals(acc.Id, result.Ref_Account__c);
    }

    @isTest
    static void SeihoOpportunityTriggerTest_name_mobilephone_paper() {
        SeihoOpportunityTriggerTest triggerTest = new SeihoOpportunityTriggerTest();

        Account acc = triggerTest.createAccount();
        insert  acc;
        Account account = [SELECT Id, SYSAccountName__c FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(null);

        Test.startTest();
        SeihoOpportunity__c so = triggerTest.createSeihoOpportunity(null);
        so.ApplyID__c = null;
        so.LastName__c = null;
        so.FirstName__c = null;
        so.LastNameKana__c = null;
        so.FirstNameKana__c = null;
        so.ApplicantName__c = '個人取引先';
        so.ApplicantNameKana__c = 'コジントリヒキサキ';
        so.ApplicantCellPhoneNumber__c = '11-2222-3333';
        so.Birthdate__c = date.newInstance(1999, 11, 21);
        so.Gender__c = '女性';
        insert so;
        Test.stopTest();

        SeihoOpportunity__c result;
        for( SeihoOpportunity__c sOpp : [SELECT Id, Ref_Account__c,ApplicantName__c , ApplicantNameKana__c
                                         FROM   SeihoOpportunity__c
                                         WHERE  Id = :so.Id] ) {
            result= sOpp;
        }
        System.assertEquals(acc.Id, result.Ref_Account__c);
    }

    @isTest
    static void SeihoOpportunityTriggerTest_name_gender_birthdate_web() {
        SeihoOpportunityTriggerTest triggerTest = new SeihoOpportunityTriggerTest();

        Account acc = triggerTest.createAccount();
        insert  acc;
        Account account = [SELECT Id, SYSAccountName__c FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(null);

        Test.startTest();
        SeihoOpportunity__c so = triggerTest.createSeihoOpportunity(null);
        so.LastName__c = '個人';
        so.FirstName__c = '取引先';
        so.LastNameKana__c = 'コジン';
        so.FirstNameKana__c = 'トリヒキサキ';
        so.ApplicantName__c = '個人取引先';
        so.ApplicantNameKana__c = 'コジントリヒキサキ';
        so.Phone__c = '44-55555-6666';
        so.MobilePhone__c = '11-2222-3333';
        insert so;
        Test.stopTest();

        SeihoOpportunity__c result;
        for( SeihoOpportunity__c sOpp : [SELECT Id, Ref_Account__c,ApplicantName__c , ApplicantNameKana__c
                                         FROM   SeihoOpportunity__c
                                         WHERE  Id = :so.Id] ) {
            result= sOpp;
        }
        System.assertEquals(acc.Id, result.Ref_Account__c);
    }

    @isTest
    static void SeihoOpportunityTriggerTest_name_gender_birthdate_paper() {
        SeihoOpportunityTriggerTest triggerTest = new SeihoOpportunityTriggerTest();

        Account acc = triggerTest.createAccount();
        insert  acc;
        Account account = [SELECT Id, SYSAccountName__c FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(null);

        Test.startTest();
        SeihoOpportunity__c so = triggerTest.createSeihoOpportunity(null);
        so.ApplyID__c = null;
        so.LastName__c = null;
        so.FirstName__c = null;
        so.LastNameKana__c = null;
        so.FirstNameKana__c = null;
        so.ApplicantName__c = '個人取引先';
        so.ApplicantNameKana__c = 'コジントリヒキサキ';
        so.ApplicantPhoneNumber__c = '44-55555-6666';
        so.ApplicantCellPhoneNumber__c = '11-2222-3333';
        insert so;
        Test.stopTest();

        SeihoOpportunity__c result;
        for( SeihoOpportunity__c sOpp : [SELECT Id, Ref_Account__c,ApplicantName__c , ApplicantNameKana__c
                                         FROM   SeihoOpportunity__c
                                         WHERE  Id = :so.Id] ) {
            result= sOpp;
        }
        System.assertEquals(acc.Id, result.Ref_Account__c);
    }

    @isTest
    static void SeihoOpportunityTriggerTest_non_Account_easy_apply_Id()
    {
        SeihoOpportunityTriggerTest triggerTest = new SeihoOpportunityTriggerTest();

        insert  triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
         insert  triggerTest.createOpportunity(account.Id);

        Test.startTest();

        SeihoOpportunity__c so = triggerTest.createSeihoOpportunity(null);
        so.EasyId__c = null;
        so.ApplyID__c = null;
        insert so;

        Test.stopTest();
    }
    
    @isTest
    static void SeihoOpportunityBeforeUpdateTriggerTest()
    {
        SeihoOpportunityTriggerTest triggerTest = new SeihoOpportunityTriggerTest();

        insert  triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(account.Id);

        Test.startTest();

        SeihoOpportunity__c so = triggerTest.createSeihoOpportunity(account.Id);
        insert so;
        
        SeihoOpportunity__c updateSo= [SELECT Id,Phone__c 
                                         FROM   SeihoOpportunity__c
                                         WHERE  Id = :so.Id];
        updateSo.Phone__c = '99-777-7777';
        update updateSo;

        Test.stopTest();
    }
    @isTest
    static void SeihoOpportunityTriggerEx_Opp_Test()
    {
        SeihoOpportunityTriggerTest triggerTest = new SeihoOpportunityTriggerTest();

        insert  triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(account.Id);

        Test.startTest();

        SeihoOpportunity__c so = triggerTest.createSeihoOpportunity(account.Id);
        insert so;
        
        SeihoOpportunity__c updateSo= [SELECT Id,Phone__c 
                                         FROM   SeihoOpportunity__c
                                         WHERE  Id = :so.Id];
        updateSo.Phone__c = '99-777-7777';
        update updateSo;

        Test.stopTest();
         SeihoOpportunity__c result;
        for( SeihoOpportunity__c sOpp : [SELECT Id, Ref_Account__c,Opportunity__c,AgentName__c,ApplicationInsuFee__c,Birthdate__c,FirstName__c,LastNameKana__c,
                                        FirstNameKana__c,Gender__c,LastName__c,EasyId__c,Email__c,PostalCode__c,State__c,ApplySts__c,address1__c,ApplicantPhoneNumber__c,ApplicantCellPhoneNumber__c
                                         FROM   SeihoOpportunity__c
                                         WHERE  Id = :so.Id] ) {
            result= sOpp;
        }
        System.assertNotEquals(null, result.Ref_Account__c);
        System.assertEquals(account.Id, result.Ref_Account__c);
        Account acct = triggerTest.getAccountById(result.Ref_Account__c);
        System.assertEquals(result.Birthdate__c, acct.PersonBirthdate);
        System.assertNotEquals(result.FirstName__c, acct.FirstName);
        System.assertNotEquals(result.LastName__c,acct.LastName);
        System.assertNotEquals(result.LastNameKana__c, acct.furiganaLast__pc);
        System.assertNotEquals(result.FirstNameKana__c, acct.furiganaForst__pc);
        System.assertEquals(result.Gender__c, acct.Gender__pc);
        System.assertNotEquals(result.EasyId__c, acct.easyId__pc);
        System.assertEquals(result.Email__c, acct.PersonEmail);
        System.assertNotEquals(result.PostalCode__c, acct.PersonMailingPostalCode);
        System.assertNotEquals(result.State__c, acct.PersonMailingState);
        System.assertNotEquals(result.address1__c, acct.PersonMailingCity);
        //System.assertNotEquals(result.ApplicantPhoneNumber__c, acct.Phone);
        System.assertEquals(result.ApplicantPhoneNumber__c, acct.PersonHomePhone);
        System.assertEquals(result.ApplicantCellPhoneNumber__c, acct.PersonMobilePhone);
        
        Opportunity oppt = triggerTest.getOpportunityById(result.Opportunity__c);
        System.assertNotEquals(oppt.InflowRoute__c ,'申込途中保存');
        System.assertEquals(oppt.StageName,'対応終了');
        System.assertNotEquals(oppt.telReason__c ,'その他');
        System.assertEquals(oppt.CloseDate ,System.Today());
        String opportunityNameInsertStr = datetime.now().format('yyyyMMdd') + '_' + '生保' + '_';
        System.assertNotEquals(oppt.Name ,opportunityNameInsertStr+acct.furiganaLast__pc+acct.furiganaForst__pc);
        
        System.assertEquals(oppt.CloseType__c ,'申込');
        System.assertEquals(oppt.RecentProbability__c ,'申込済み');
        System.assertEquals(oppt.AgentName__c ,result.AgentName__c);
        System.assertEquals(oppt.ApplySts__c ,result.ApplySts__c);
    }
    @isTest
    static void SeihoOpportunityTriggerEx_Multi_Opp_Test()
    {
        SeihoOpportunityTriggerTest triggerTest = new SeihoOpportunityTriggerTest();

        insert  triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        Opportunity opp1 =  triggerTest.createOpportunity(account.Id);
        opp1.StageName = '未割当';
        insert opp1;
        
        Opportunity opp2 =  triggerTest.createOpportunityHanyo(account.Id);
        opp2.StageName = '未割当';
        insert opp2;
            
        Test.startTest();

        SeihoOpportunity__c so = triggerTest.createSeihoOpportunity(account.Id);
        insert so;
        
        SeihoOpportunity__c updateSo= [SELECT Id,Phone__c 
                                         FROM   SeihoOpportunity__c
                                         WHERE  Id = :so.Id];
        updateSo.Phone__c = '99-777-7777';
        update updateSo;

        Test.stopTest();
         SeihoOpportunity__c result;
        for( SeihoOpportunity__c sOpp : [SELECT Id, Ref_Account__c,Opportunity__c,AgentName__c,ApplicationInsuFee__c,Birthdate__c,FirstName__c,LastNameKana__c,
                                        FirstNameKana__c,Gender__c,LastName__c,EasyId__c,Email__c,PostalCode__c,State__c,ApplySts__c,address1__c,ApplicantPhoneNumber__c,ApplicantCellPhoneNumber__c
                                         FROM   SeihoOpportunity__c
                                         WHERE  Id = :so.Id] ) {
            result= sOpp;
        }
        System.assertNotEquals(null, result.Ref_Account__c);
        System.assertEquals(account.Id, result.Ref_Account__c);
        Account acct = triggerTest.getAccountById(result.Ref_Account__c);
        System.assertEquals(result.Birthdate__c, acct.PersonBirthdate);
        System.assertNotEquals(result.FirstName__c, acct.FirstName);
        System.assertNotEquals(result.LastName__c,acct.LastName);
        System.assertNotEquals(result.LastNameKana__c, acct.furiganaLast__pc);
        System.assertNotEquals(result.FirstNameKana__c, acct.furiganaForst__pc);
        System.assertEquals(result.Gender__c, acct.Gender__pc);
        System.assertNotEquals(result.EasyId__c, acct.easyId__pc);
        System.assertEquals(result.Email__c, acct.PersonEmail);
        System.assertNotEquals(result.PostalCode__c, acct.PersonMailingPostalCode);
        System.assertNotEquals(result.State__c, acct.PersonMailingState);
        System.assertNotEquals(result.address1__c, acct.PersonMailingCity);
        //System.assertNotEquals(result.ApplicantPhoneNumber__c, acct.Phone);
        System.assertEquals(result.ApplicantPhoneNumber__c, acct.PersonHomePhone);
        System.assertEquals(result.ApplicantCellPhoneNumber__c, acct.PersonMobilePhone);
        
        Opportunity oppt = triggerTest.getOpportunityById(result.Opportunity__c);
        System.assertNotEquals(oppt.InflowRoute__c ,'申込途中保存');
        System.assertEquals(oppt.StageName,'対応終了');
        System.assertNotEquals(oppt.telReason__c ,'その他');
        System.assertEquals(oppt.CloseDate ,System.Today());
        String opportunityNameInsertStr = datetime.now().format('yyyyMMdd') + '_' + '生保' + '_';
        System.assertNotEquals(oppt.Name ,opportunityNameInsertStr+acct.furiganaLast__pc+acct.furiganaForst__pc);
        
        System.assertEquals(oppt.CloseType__c ,'申込');
        System.assertEquals(oppt.RecentProbability__c ,'申込済み');
        System.assertEquals(oppt.AgentName__c ,result.AgentName__c);
        System.assertEquals(oppt.ApplySts__c ,result.ApplySts__c);
    }
    @isTest
    static void SeihoOpportunityTriggerEx_Multi_Opp_Draft_Test()
    {
        SeihoOpportunityTriggerTest triggerTest = new SeihoOpportunityTriggerTest();

        insert  triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        Opportunity opp1 =  triggerTest.createOpportunity(account.Id);
        opp1.StageName = '未割当';
        insert opp1;
        
        Opportunity opp2 =  triggerTest.createOpportunityHanyo(account.Id);
        opp2.StageName = '未割当';
        insert opp2;
            
        Test.startTest();

        SeihoOpportunity__c so = triggerTest.createSeihoOpportunity(account.Id);
        so.ApplySts__c = null;
        so.MiniSyncSubsc__c = '-';
        insert so;
        
        SeihoOpportunity__c updateSo= [SELECT Id,Phone__c 
                                         FROM   SeihoOpportunity__c
                                         WHERE  Id = :so.Id];
        updateSo.Phone__c = '99-777-7777';
        update updateSo;

        Test.stopTest();
        SeihoOpportunity__c result;
        for( SeihoOpportunity__c sOpp : [SELECT Id, Ref_Account__c,Opportunity__c,AgentName__c,ApplicationInsuFee__c,Birthdate__c,FirstName__c,LastName__c,LastNameKana__c,
                                        FirstNameKana__c,Gender__c,EasyId__c,Email__c,PostalCode__c,State__c,ApplySts__c,address1__c,ApplicantPhoneNumber__c,ApplicantCellPhoneNumber__c
                                         FROM   SeihoOpportunity__c
                                         WHERE  Id = :so.Id] ) {
            result= sOpp;
        }
        
        System.assertEquals(account.Id, result.Ref_Account__c);
        Account acct = triggerTest.getAccountById(result.Ref_Account__c);
        System.assertEquals(result.Birthdate__c, acct.PersonBirthdate);
        System.assertNotEquals(result.FirstName__c, acct.FirstName);
        System.assertNotEquals(result.LastName__c,acct.LastName);
        System.assertNotEquals(result.LastNameKana__c, acct.furiganaLast__pc);
        System.assertNotEquals(result.FirstNameKana__c, acct.furiganaForst__pc);
        System.assertEquals(result.Gender__c, acct.Gender__pc);
        System.assertNotEquals(result.EasyId__c, acct.easyId__pc);
        System.assertEquals(result.Email__c, acct.PersonEmail);
        System.assertNotEquals(result.PostalCode__c, acct.PersonMailingPostalCode);
        System.assertNotEquals(result.State__c, acct.PersonMailingState);
        System.assertNotEquals(result.address1__c, acct.PersonMailingCity);
        //System.assertNotEquals(result.ApplicantPhoneNumber__c, acct.Phone);
        System.assertEquals(result.ApplicantPhoneNumber__c, acct.PersonHomePhone);
        System.assertEquals(result.ApplicantCellPhoneNumber__c, acct.PersonMobilePhone);
        
        Opportunity oppt = triggerTest.getOpportunityById(result.Opportunity__c);
        System.assertNotEquals(oppt.InflowRoute__c ,'申込途中保存');
        System.assertNotEquals(oppt.StageName,'対応終了');
        //System.assertEquals(oppt.telReason__c ,'その他');
        System.assertEquals(oppt.CloseDate ,System.Today());
        String opportunityNameInsertStr = datetime.now().format('yyyyMMdd') + '_' + '生保' + '_';
        System.assertNotEquals(oppt.Name ,opportunityNameInsertStr+acct.furiganaLast__pc+acct.furiganaForst__pc);
        
        //System.assertEquals(oppt.CloseType__c ,'申込');
        //System.assertEquals(oppt.RecentProbability__c ,'申込なし');
        System.assertEquals(oppt.AgentName__c ,result.AgentName__c);
        System.assertEquals(oppt.ApplySts__c ,result.ApplySts__c);
    }
    @isTest
    static void SeihoOpportunityTriggerEx_Opp_Hanyo_Test()
    {
        SeihoOpportunityTriggerTest triggerTest = new SeihoOpportunityTriggerTest();

        insert  triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createOpportunityHanyo(account.Id);

        Test.startTest();

        SeihoOpportunity__c so = triggerTest.createSeihoOpportunity(account.Id);
        insert so;
        
        SeihoOpportunity__c updateSo= [SELECT Id,Phone__c 
                                         FROM   SeihoOpportunity__c
                                         WHERE  Id = :so.Id];
        updateSo.Phone__c = '99-777-7777';
        update updateSo;

        Test.stopTest();
        
         SeihoOpportunity__c result;
        for( SeihoOpportunity__c sOpp : [SELECT Id, Ref_Account__c,Opportunity__c,AgentName__c,ApplicationInsuFee__c,Birthdate__c,FirstName__c,LastNameKana__c,
                                        FirstNameKana__c,LastName__c,Gender__c,EasyId__c,Email__c,PostalCode__c,State__c,ApplySts__c,address1__c,ApplicantPhoneNumber__c,ApplicantCellPhoneNumber__c
                                         FROM   SeihoOpportunity__c
                                         WHERE  Id = :so.Id] ) {
            result= sOpp;
        }
        System.assertNotEquals(null, result.Ref_Account__c);
        System.assertEquals(account.Id, result.Ref_Account__c);
        Account acct = triggerTest.getAccountById(result.Ref_Account__c);
        System.assertEquals(result.Birthdate__c, acct.PersonBirthdate);
        System.assertNotEquals(result.FirstName__c, acct.FirstName);
        System.assertNotEquals(result.LastName__c,acct.LastName);
        System.assertNotEquals(result.LastNameKana__c, acct.furiganaLast__pc);
        System.assertNotEquals(result.FirstNameKana__c, acct.furiganaForst__pc);
        System.assertEquals(result.Gender__c, acct.Gender__pc);
        System.assertNotEquals(result.EasyId__c, acct.easyId__pc);
        System.assertEquals(result.Email__c, acct.PersonEmail);
        System.assertNotEquals(result.PostalCode__c, acct.PersonMailingPostalCode);
        System.assertNotEquals(result.State__c, acct.PersonMailingState);
        System.assertNotEquals(result.address1__c, acct.PersonMailingCity);
        //System.assertNotEquals(result.ApplicantPhoneNumber__c, acct.Phone);
        System.assertEquals(result.ApplicantPhoneNumber__c, acct.PersonHomePhone);
        System.assertEquals(result.ApplicantCellPhoneNumber__c, acct.PersonMobilePhone);
        
        Opportunity oppt = triggerTest.getOpportunityById(result.Opportunity__c);
        System.assertNotEquals(oppt.InflowRoute__c ,'申込途中保存');
        System.assertEquals(oppt.StageName,'対応終了');
        System.assertNotEquals(oppt.telReason__c ,'その他');
        System.assertEquals(oppt.CloseDate ,System.Today());
        String opportunityNameInsertStr = datetime.now().format('yyyyMMdd') + '_' + '生保' + '_';
        System.assertNotEquals(oppt.Name ,opportunityNameInsertStr+acct.furiganaLast__pc+acct.furiganaForst__pc);
        
        System.assertEquals(oppt.CloseType__c ,'申込');
        System.assertEquals(oppt.RecentProbability__c ,'申込済み');
        System.assertEquals(oppt.AgentName__c ,result.AgentName__c);
        System.assertEquals(oppt.ApplySts__c ,result.ApplySts__c);
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
            SYSAccountName__c = 'アプリケーション名アプリ',
            RecordTypeId=recordTypes[0].Id
        );
    }

    private SeihoOpportunity__c createSeihoOpportunity(Id accountId){
        return new SeihoOpportunity__c(
            EasyId__c = '1111111',
            ApplyID__c = '2222222',
            AppliNo__c = '3333333',
            LastName__c = '楽天',
            FirstName__c = '太郎',
            LastNameKana__c = 'ﾗｸﾃﾝ',
            FirstNameKana__c = 'ﾀﾛｳ',
            ApplicantName__c = 'アプリケーション名',
            ApplicantNameKana__c = 'アプリ',
            Phone__c = '99-9999-9999',
            MobilePhone__c = '88-8888-8888',
            ApplicantPhoneNumber__c = '99-9999-9999',
            ApplicantCellPhoneNumber__c = '88-8888-8888',            
            Birthdate__c = date.newInstance(1990, 11, 21),
            Gender__c = '男性',
            ContracterBD__c = date.newInstance(1990, 11, 21),
            ApplicantGender__c = '男性',
            PostalCode__c = '222-2222',
            State__c = '住所',
            address1__c = '住所１',
            address2__c = '住所２',
            address3__c = '住所３',
            ApplySts__c = '申込完了',
            MiniSyncSubsc__c = '有',
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
            RecordTypeId=recordTypes[0].Id
        );
    }
    private Account getAccountById( Id accountId ) {
        return [SELECT Id, Name, LastName, FirstName, furiganaForst__pc, furiganaLast__pc, Phone,easyId__pc,openId__pc,
                       PersonHomePhone, PersonMobilePhone, PersonBirthdate, Gender__pc,  
                       SYSAccountName__c, PersonMailingPostalCode, PersonMailingState, 
                       PersonMailingCity, PersonMailingStreet, PersonEmail,LastName__pc,firstname__pc,division__pc,
                       OperationType__c,OpportunityStatus__c
                FROM   Account
                WHERE  Id =: accountId LIMIT 1];
    }
    private Opportunity getOpportunityById( Id oppId ) {
        return [SELECT id,name,telReason__c,InflowRoute__c,CloseDate,CloseType__c,StageName,RecentProbability__c,AgentName__c,ApplySts__c FROM Opportunity WHERE  Id =: oppId LIMIT 1];
    }
}