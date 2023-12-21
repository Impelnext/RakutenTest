@isTest
public class GeneralWebApplicationTriggerTest
{
    @isTest
    static void GeneralWebApplicationTriggerTest_AccountId()
    {
        GeneralWebApplicationTriggerTest triggerTest = new GeneralWebApplicationTriggerTest();

        insert  triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();

        GeneralWebApplication__c generalWebAppln = triggerTest.createGeneralWebApplication(account.Id);        
        insert generalWebAppln;

        Test.stopTest();
        
        GeneralWebApplication__c result;
        for(GeneralWebApplication__c gen : [SELECT Id, Ref_Account__c ,Opportunity__c,Opportunity__r.StageName 
                                            FROM   GeneralWebApplication__c
                                            WHERE  Id = :generalWebAppln.Id]) {
            result = gen;
        }
        System.assertNotEquals(null, result.Ref_Account__c);
        System.assertEquals(account.Id, result.Ref_Account__c);
        System.assertEquals('対応終了', result.Opportunity__r.StageName);
    }
    
    @isTest
    static void GeneralWebApplicationTriggerTest_non_AccountId()
    {
        GeneralWebApplicationTriggerTest triggerTest = new GeneralWebApplicationTriggerTest();
        insert  triggerTest.createAccount();
        

        Test.startTest();

        insert triggerTest.createGeneralWebApplication(null);

        Test.stopTest();
        
    }

    @isTest
    static void GeneralWebApplicationTriggerTest_easyId() {
        GeneralWebApplicationTriggerTest triggerTest = new GeneralWebApplicationTriggerTest();
        Account acc = triggerTest.createAccount();
        acc.easyId__pc = '1111111';
        insert  acc;
        

        Test.startTest();
        GeneralWebApplication__c generalWeb = triggerTest.createGeneralWebApplication(null);
        insert generalWeb;
        Test.stopTest();

        GeneralWebApplication__c result;
        for(GeneralWebApplication__c gen : [SELECT Id, Ref_Account__c ,Opportunity__c
                                            FROM   GeneralWebApplication__c
                                            WHERE  Id = :generalWeb.Id]) {
            result = gen;
        }
        System.assertNotEquals(null, result.Ref_Account__c);
        System.assertNotEquals(acc.Id, result.Ref_Account__c);
    }

    @isTest
    static void GeneralWebApplicationTriggerTest_name_phone() {
        GeneralWebApplicationTriggerTest triggerTest = new GeneralWebApplicationTriggerTest();
        Account acc = triggerTest.createAccount();
        acc.PersonHomePhone = '00011112222';
        insert  acc;
        
        Account acc2 = triggerTest.createAccount();
        acc2.PersonHomePhone = '00011112223';
        insert  acc2;

        Test.startTest();
        GeneralWebApplication__c generalWeb = triggerTest.createGeneralWebApplication(null);
        generalWeb.name_keiyaku__c = '個人取引先';
        generalWeb.name_keiyaku_k__c = 'コジントリヒキサキ';
        generalWeb.tel_keiyaku_area__c = '000';
        generalWeb.tel_keiyaku_city__c = '1111';
        generalWeb.tel_keiyaku_number__c = '2222';
        generalWeb.tel_keiyaku2_area__c = '000';
        generalWeb.tel_keiyaku2_city__c = '2222';
        generalWeb.tel_keiyaku2_number__c = '3333';
        insert generalWeb;

        Test.stopTest();
        GeneralWebApplication__c result;
        for(GeneralWebApplication__c gen : [SELECT Id, Ref_Account__c,Opportunity__c
                                            FROM   GeneralWebApplication__c
                                            WHERE  Id = :generalWeb.Id] ) {
            result = gen;
        }
        System.assertEquals(acc.Id, result.Ref_Account__c);
        Opportunity oppt = triggerTest.getOpportunityById(result.Opportunity__c);
        Account acct = triggerTest.getAccountById(result.Ref_Account__c);
        System.assertEquals(oppt.InflowRoute__c ,'申込途中保存');
        System.assertEquals(oppt.StageName,'未割当');
        System.assertEquals(oppt.telReason__c ,'その他');
        System.assertEquals(oppt.CloseDate ,Date.newInstance(System.today().year(), System.today().month() + 2,0));
        String opportunityNameInsertStr = datetime.now().format('yyyyMMdd') + '_' + '損保' + '_';
        System.assertEquals(oppt.Name ,opportunityNameInsertStr+acct.furiganaLast__pc+acct.furiganaForst__pc);
    }

    @isTest
    static void GeneralWebApplicationTriggerTest_name_mobilephone() {
        GeneralWebApplicationTriggerTest triggerTest = new GeneralWebApplicationTriggerTest();
        Account acc = triggerTest.createAccount();
        acc.PersonMobilePhone = '09011112222';
        insert  acc;
        
        Account acc2 = triggerTest.createAccount();
        acc2.PersonMobilePhone = '09011112223';
        insert  acc2;

        Test.startTest();
        GeneralWebApplication__c generalWeb = triggerTest.createGeneralWebApplication(null);
        generalWeb.name_keiyaku__c = '個人取引先';
        generalWeb.name_keiyaku_k__c = 'コジントリヒキサキ';
        generalWeb.tel_keiyaku_area__c = '090';
        generalWeb.tel_keiyaku_city__c = '1111';
        generalWeb.tel_keiyaku_number__c = '44444';
        generalWeb.tel_keiyaku2_area__c = '090';
        generalWeb.tel_keiyaku2_city__c = '1111';
        generalWeb.tel_keiyaku2_number__c = '2222';
        insert generalWeb;

        Test.stopTest();
        GeneralWebApplication__c result;
        for(GeneralWebApplication__c gen : [SELECT Id, Ref_Account__c,Opportunity__c
                                            FROM   GeneralWebApplication__c
                                            WHERE  Id = :generalWeb.Id] ) {
            result = gen;
        }
        System.assertEquals(acc.Id, result.Ref_Account__c);
        Account acct = triggerTest.getAccountById(result.Ref_Account__c);
        Opportunity oppt = triggerTest.getOpportunityById(result.Opportunity__c);
        System.assertEquals(oppt.InflowRoute__c ,'申込途中保存');
        System.assertEquals(oppt.StageName,'未割当');
        System.assertEquals(oppt.telReason__c ,'その他');
        System.assertEquals(oppt.CloseDate ,Date.newInstance(System.today().year(), System.today().month() + 2,0));
        String opportunityNameInsertStr = datetime.now().format('yyyyMMdd') + '_' + '損保' + '_';
        System.assertEquals(oppt.Name ,opportunityNameInsertStr+acct.furiganaLast__pc+acct.furiganaForst__pc);
    }
    @isTest
    static void GeneralWebApplicationTriggerTest_ExOpp_Closed() {
        GeneralWebApplicationTriggerTest triggerTest = new GeneralWebApplicationTriggerTest();

        Account acc = triggerTest.createAccount();
        insert  acc;
        Account account = [SELECT Id FROM Account LIMIT 1];
        Opportunity opp = triggerTest.createOpportunityClosed(account.Id);
        insert opp;
        
        Test.startTest();
        GeneralWebApplication__c generalWeb = triggerTest.createGeneralWebApplication(null);
        generalWeb.name_keiyaku__c = '個人取引先';
        generalWeb.name_keiyaku_k__c = 'コジントリヒキサキ';
        generalWeb.tel_keiyaku_area__c = '090';
        generalWeb.tel_keiyaku_city__c = '1111';
        generalWeb.tel_keiyaku_number__c = '44444';
        generalWeb.tel_keiyaku2_area__c = '090';
        generalWeb.tel_keiyaku2_city__c = '1111';
        generalWeb.tel_keiyaku2_number__c = '2222';
        insert generalWeb;
        Test.stopTest();

        GeneralWebApplication__c result;
        for(GeneralWebApplication__c gen : [SELECT Id, Ref_Account__c,Opportunity__c,name_keiyaku__c,name_keiyaku_k__c,mail_keiyaku__c,
                                            yubin_keiyaku__c,easy_id__c,open_id__c,tel_keiyaku2_area__c,tel_keiyaku_city__c,tel_keiyaku_number__c,
                                            tel_keiyaku_area__c,tel_keiyaku2_city__c,tel_keiyaku2_number__c
                                            FROM   GeneralWebApplication__c
                                            WHERE  Id = :generalWeb.Id] ) {
            result = gen;
        }
        List<Opportunity> Oppr = [Select id from Opportunity];
        System.assertNotEquals(acc.Id, result.Ref_Account__c);
        System.assertEquals(Oppr[1].Id, result.Opportunity__c);
        Account acct = triggerTest.getAccountById(result.Ref_Account__c);
        System.assertEquals(acct.OperationType__c,'割当可');
        System.assertEquals(acct.division__pc,'見込み顧客');
        System.assertEquals(acct.OpportunityStatus__c ,'未対応');
        
        System.assertEquals(acct.LastName ,result.name_keiyaku__c);
        System.assertEquals(acct.furiganaLast__pc ,result.name_keiyaku_k__c);
        System.assertEquals(acct.easyId__pc ,result.easy_id__c);
        System.assertEquals(acct.openId__pc ,result.open_id__c);
        System.assertEquals(acct.PersonEmail ,result.mail_keiyaku__c);
        System.assertEquals(acct.PersonMailingPostalCode ,result.yubin_keiyaku__c);
        
        System.assertEquals(acct.Phone ,result.tel_keiyaku_area__c+result.tel_keiyaku_city__c+result.tel_keiyaku_number__c);
        System.assertEquals(acct.PersonHomePhone ,result.tel_keiyaku_area__c+result.tel_keiyaku_city__c+result.tel_keiyaku_number__c);
        System.assertEquals(acct.PersonMobilePhone ,result.tel_keiyaku2_area__c+result.tel_keiyaku2_city__c+result.tel_keiyaku2_number__c);
        
        Opportunity oppt = triggerTest.getOpportunityById(result.Opportunity__c);
        System.assertEquals(oppt.InflowRoute__c ,'申込途中保存');
        System.assertEquals(oppt.StageName,'未割当');
        System.assertEquals(oppt.telReason__c ,'その他');
        System.assertEquals(oppt.CloseDate ,Date.newInstance(System.today().year(), System.today().month() + 2,0));
        String opportunityNameInsertStr = datetime.now().format('yyyyMMdd') + '_' + '損保' + '_';
        System.assertEquals(oppt.Name ,opportunityNameInsertStr+acct.furiganaLast__pc);
        
    }
    @isTest
    static void GeneralWebApplicationTriggerTest_ExOpp_Open() {
        GeneralWebApplicationTriggerTest triggerTest = new GeneralWebApplicationTriggerTest();

        Account acc = triggerTest.createAccount();
        insert  acc;
        Account account = [SELECT Id FROM Account LIMIT 1];
        Opportunity opp = triggerTest.createOpportunityNotClosed(account.Id);
        insert opp;
        opp.StageName = '未対応';
        update opp;
        
        Test.startTest();
        GeneralWebApplication__c generalWeb = triggerTest.createGeneralWebApplication(null);
        generalWeb.name_keiyaku__c = '個人取引先';
        generalWeb.name_keiyaku_k__c = 'コジントリヒキサキ';
        generalWeb.tel_keiyaku_area__c = '090';
        generalWeb.tel_keiyaku_city__c = '1111';
        generalWeb.tel_keiyaku_number__c = '44444';
        generalWeb.tel_keiyaku2_area__c = '090';
        generalWeb.tel_keiyaku2_city__c = '1111';
        generalWeb.tel_keiyaku2_number__c = '2222';
        insert generalWeb;
        Test.stopTest();

        GeneralWebApplication__c result;
        for(GeneralWebApplication__c gen : [SELECT Id, Ref_Account__c,Opportunity__c
                                            FROM   GeneralWebApplication__c
                                            WHERE  Id = :generalWeb.Id] ) {
            result = gen;
        }
        List<Opportunity> Oppr = [Select id from Opportunity];
        System.assertNotEquals(acc.Id, result.Ref_Account__c);
        Account acct = triggerTest.getAccountById(result.Ref_Account__c);
        System.assertEquals(acct.OperationType__c,'割当可');
        System.assertEquals(acct.division__pc,'見込み顧客');
        System.assertEquals(acct.OpportunityStatus__c ,'未対応');
        
        Opportunity oppt = triggerTest.getOpportunityById(result.Opportunity__c);
        System.assertEquals(Oppr[1].Id, result.Opportunity__c);    
        System.assertEquals(oppt.InflowRoute__c ,'申込途中保存');
        System.assertEquals(oppt.StageName,'未割当');
        System.assertEquals(oppt.telReason__c ,'その他');
        System.assertEquals(oppt.CloseDate ,Date.newInstance(System.today().year(), System.today().month() + 2,0));
        String opportunityNameInsertStr = datetime.now().format('yyyyMMdd') + '_' + '損保' + '_';
        System.assertEquals(oppt.Name ,opportunityNameInsertStr+acct.furiganaLast__pc);
    }
    @isTest
    static void GeneralWebApplicationTriggerTest_No_Account_Null_Value() {
        GeneralWebApplicationTriggerTest triggerTest = new GeneralWebApplicationTriggerTest();

        
        Test.startTest();
        GeneralWebApplication__c generalWeb = triggerTest.createGeneralWebApplication(null);
        generalWeb.name_keiyaku__c = null;
        generalWeb.name_keiyaku_k__c = null;
        generalWeb.tel_keiyaku_area__c = null;
        generalWeb.tel_keiyaku_city__c = null;
        generalWeb.tel_keiyaku_number__c = null;
        generalWeb.tel_keiyaku2_area__c = null;
        generalWeb.tel_keiyaku2_city__c = null;
        generalWeb.tel_keiyaku2_number__c = null;
        insert generalWeb;
        Test.stopTest();

        GeneralWebApplication__c result;
        for(GeneralWebApplication__c gen : [SELECT Id, Ref_Account__c,Opportunity__c,name_keiyaku__c,name_keiyaku_k__c,easy_id__c,open_id__c,
                                            mail_keiyaku__c,yubin_keiyaku__c,tel_keiyaku_area__c,tel_keiyaku_city__c,tel_keiyaku_number__c,
                                            tel_keiyaku2_area__c,tel_keiyaku2_city__c,tel_keiyaku2_number__c
                                            FROM   GeneralWebApplication__c
                                            WHERE  Id = :generalWeb.Id] ) {
            result = gen;
        }
        List<Opportunity> Oppr = [Select id from Opportunity];
        System.assertNotEquals(null, result.Ref_Account__c);
        System.assertEquals(Oppr[0].Id, result.Opportunity__c);
        Account acct = triggerTest.getAccountById(result.Ref_Account__c);
        System.assertEquals(acct.division__pc,'見込み顧客');
        System.assertEquals(acct.furiganaLast__pc ,result.name_keiyaku_k__c);
        System.assertEquals(acct.easyId__pc ,result.easy_id__c);
        System.assertEquals(acct.openId__pc ,result.open_id__c);
        System.assertEquals(acct.PersonEmail ,result.mail_keiyaku__c);
        System.assertEquals(acct.PersonMailingPostalCode ,result.yubin_keiyaku__c);
        
        System.assertEquals(acct.Phone ,null);
        System.assertEquals(acct.PersonHomePhone ,null);
        System.assertEquals(acct.PersonMobilePhone ,null);
        
        System.assertEquals(acct.LastName,'未登録');       
        Opportunity oppt = triggerTest.getOpportunityById(result.Opportunity__c);
        System.assertEquals(oppt.InflowRoute__c ,'申込途中保存');
        System.assertNotEquals(oppt.StageName,'未割当');
        System.assertEquals(oppt.telReason__c ,'その他');
        System.assertEquals(oppt.CloseDate ,Date.newInstance(System.today().year(), System.today().month() + 2,0));
        String opportunityNameInsertStr = datetime.now().format('yyyyMMdd') + '_' + '損保' + '_';
        System.assertEquals(oppt.Name ,opportunityNameInsertStr);
    }
    private GeneralWebApplication__c createGeneralWebApplication(Id accountId){
        return new GeneralWebApplication__c(
            easy_id__c = '1111111',
            ForeignKey_GeneralWebApplication__c = '2222222',
            name_keiyaku__c = '楽天',
            name_keiyaku_k__c = 'テスト',
            yubin_keiyaku__c = '住所',
            jusho_keiyaku__c = '住所',
            tel_keiyaku_area__c = 'area',
            tel_keiyaku_city__c = 'city',
            tel_keiyaku_number__c = '99-8888-8888',
            tel_keiyaku2_area__c  = 'area',
            tel_keiyaku2_city__c  = 'city',
            tel_keiyaku2_number__c = '77-8888-6655',
            Ref_Account__c = accountId
        );
    }
    
    private account createAccount() {
        List<RecordType> recordTypes = [SELECT Id, Name 
                                        FROM   RecordType 
                                        WHERE  SobjectType = 'Account' 
                                        And    Name = '個人取引先' 
                                        ORDER BY Name ASC LIMIT 50];
        return new Account(
            LastName='個人',
            FirstName='取引先',
            furiganaLast__pc = 'コジン',
            furiganaForst__pc = 'トリヒキサキ',
            Gender__pc = '男性',
            RecordTypeId=recordTypes[0].Id
        );
    }
    
    private Opportunity createOpportunityClosed(Id accountId) {
        List<RecordType> recordTypes = [SELECT Id, Name 
                                        FROM   RecordType 
                                        WHERE  SobjectType = 'Opportunity' 
                                        And    Name = '損保' 
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
    private Opportunity createOpportunityNotClosed(Id accountId) {
        List<RecordType> recordTypes = [SELECT Id, Name 
                                        FROM   RecordType 
                                        WHERE  SobjectType = 'Opportunity' 
                                        And    Name = '損保' 
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
        return [SELECT id,name,telReason__c,InflowRoute__c,CloseDate,StageName FROM Opportunity WHERE  Id =: oppId LIMIT 1];
    }
}