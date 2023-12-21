@isTest
public class LittleContractTriggerTest
{
    @isTest
    static void LittleContractTriggerTest()
    {
        LittleContractTriggerTest triggerTest = new LittleContractTriggerTest();

        insert  triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        insert  triggerTest.createOpportunity(account.Id,'少短');
        Opportunity opp = [SELECT Id,ANP__c FROM Opportunity LIMIT 1]; 
        
        Test.startTest();

        LittleContract__c lc = triggerTest.createLittleContract(account.Id,opp.id);
        insert lc;
        
        Id oppId = [SELECT Id, Opportunity__c FROM LittleContract__c WHERE Id =: lc.Id LIMIT 1].Opportunity__c;
        Opportunity resOpp = triggerTest.getOpportunityById(oppId);
        System.assertEquals(lc.Opportunity__c, oppId);
        System.assertEquals('対応終了', resOpp.StageName);
        System.assertEquals(system.today(), resOpp.CloseDate);
        //20200421 RIPCRM-218 修正　開始
        //System.assertEquals(Integer.valueOf(lc.InsurancePremium__c)+opp.ANP__c, resOpp.ANP__c);
        System.assertEquals(lc.KEIYAKUJI_PRM_TOTAL__c+opp.ANP__c, resOpp.ANP__c);
        //20200421 RIPCRM-218 修正　終了
        System.assertEquals(resOpp.ANP__c, resOpp.EstimatedANP__c);
        System.assertEquals('申込', resOpp.CloseType__c);
        System.assertEquals('申込済み', resOpp.RecentProbability__c);

        Test.stopTest();
    }
    
    /** 
        契約者変更対応により契約者名変更フラグON処理をCRMバッチ側に移行
        値変更によるフラグON処理が実行されないことを確認する
     **/
    @isTest
    static void onAfterUpdateProcess_name_kana_changed() {
        LittleContractTriggerTest triggerTest = new LittleContractTriggerTest();                    
        LittleContractTriggerHandler handler = new LittleContractTriggerHandler();

        Account ac =  triggerTest.createAccount();
        insert ac;

        LittleContract__c lc = new LittleContract__c();
        lc.SubscriberNameKana__c = 'ラクテン　ショウタンイチロウ';
        lc.SubscriberSex__c = '男';
        lc.SubscriberBirthdate__c = '1900/01/01';
        lc.AccountId__c = ac.Id;
        insert lc;
        lc.SubscriberNameKana__c = 'ラクテン　ショウタンジロウ';

        Test.startTest();
        update lc;

        Test.stopTest();
        Account result = triggerTest.getAccountById(lc.AccountId__c);
        system.assertEquals(false, result.nameChangedFlag__c);
        system.assertEquals(false, result.genderChangedFlag__c);
        system.assertEquals(false, result.birthdateChangedFlag__c);

    }

    /** 
        契約者変更対応により性別変更フラグON処理をCRMバッチ側に移行
        値変更によるフラグON処理が実行されないことを確認する
     **/
    @isTest
    static void onAfterUpdateProcess_gender_changed() {
        LittleContractTriggerTest triggerTest = new LittleContractTriggerTest();                    
        LittleContractTriggerHandler handler = new LittleContractTriggerHandler();

        Account ac =  triggerTest.createAccount();
        insert ac;

        LittleContract__c lc = new LittleContract__c();
        lc.SubscriberNameKana__c = 'ラクテン　ショウタンイチロウ';
        lc.SubscriberSex__c = '男';
        lc.SubscriberBirthdate__c = '1900/01/01';
        lc.AccountId__c = ac.Id;
        insert lc;
        lc.SubscriberSex__c = '女';

        Test.startTest();
        update lc;

        Test.stopTest();
        Account result = triggerTest.getAccountById(lc.AccountId__c);
        system.assertEquals(false, result.nameChangedFlag__c);
        system.assertEquals(false, result.genderChangedFlag__c);
        system.assertEquals(false, result.birthdateChangedFlag__c);

    }

    /** 
        契約者変更対応により生年月日変更フラグON処理をCRMバッチ側に移行
        値変更によるフラグON処理が実行されないことを確認する
     **/
    @isTest
    static void onAfterUpdateProcess_birthdate_changed() {
        LittleContractTriggerTest triggerTest = new LittleContractTriggerTest();                    
        LittleContractTriggerHandler handler = new LittleContractTriggerHandler();

        Account ac =  triggerTest.createAccount();
        insert ac;

        LittleContract__c lc = new LittleContract__c();
        lc.SubscriberNameKana__c = 'ラクテン　ショウタンイチロウ';
        lc.SubscriberSex__c = '男';
        lc.SubscriberBirthdate__c = '1900/01/01';
        lc.AccountId__c = ac.Id;
        insert lc;
        lc.SubscriberBirthdate__c = '1999/01/01';

        Test.startTest();
        update lc;

        Test.stopTest();
        Account result = triggerTest.getAccountById(lc.AccountId__c);
        system.assertEquals(false, result.nameChangedFlag__c);
        system.assertEquals(false, result.genderChangedFlag__c);
        system.assertEquals(false, result.birthdateChangedFlag__c);

    }

    @isTest
    static void LittleContractTriggerTest_Existing_Oppo()
    {
        LittleContractTriggerTest triggerTest = new LittleContractTriggerTest();

        Account acc = triggerTest.createAccount();  
        acc.PersonHomePhone = '333-4444-5555';
        insert acc;
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        insert  triggerTest.createAccount();
        List<Account> accList = [SELECT Id FROM Account];
        
        insert  triggerTest.createOpportunity(account.Id,'少短');
        insert  triggerTest.createOpportunity(account.Id,'汎用');
        List<Opportunity> opp = [SELECT Id,ANP__c FROM Opportunity ]; 
        
        Test.startTest();
        insert triggerTest.createLittleContract(account.Id,opp[0].id);
        LittleContract__c lc = triggerTest.createLittleContract(account.Id,opp[0].id);
        insert lc;
        lc.AccountId__c = accList[1].id;
        update lc;
        
        Test.stopTest();
        LittleContract__c lcList = [select id,AccountId__c from LittleContract__c where id =: lc.id];
        System.assertNotEquals(account.id, lcList.AccountId__c);
              
        Opportunity resOpp = triggerTest.getOpportunityById(opp[0].Id);
        System.assertEquals(lc.Opportunity__c, resOpp.id);
        System.assertEquals('対応終了', resOpp.StageName);
        System.assertEquals(system.today(), resOpp.CloseDate);
        System.assertEquals(resOpp.ANP__c, resOpp.EstimatedANP__c);
        System.assertEquals('申込', resOpp.CloseType__c);
        System.assertEquals('申込済み', resOpp.RecentProbability__c);
        
        Opportunity resOtherClosedOpp = triggerTest.getOpportunityById(opp[1].Id);
        System.assertNotEquals(lc.Opportunity__c, resOtherClosedOpp.id);
        System.assertEquals('対応終了', resOtherClosedOpp.StageName);
        System.assertEquals(system.today(), resOtherClosedOpp.CloseDate);      
        System.assertEquals('対応打ち切り', resOtherClosedOpp.CloseType__c);
        System.assertEquals('他商談にて対応', resOtherClosedOpp.CloseReason__c);
        System.assertEquals('申込なし', resOtherClosedOpp.RecentProbability__c);
        
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
            furiganaLast__pc = 'furigana',
            furiganaForst__pc = 'furiganaForst',
            OperationType__c = '割当可',
            RecordTypeId=recordTypes[0].Id,
            PersonHomePhone = '333-4444-5555'
        );
    }
    
    private Opportunity createOpportunity(Id accountId,String recordType){
        
        Id recordTypeIdOPP = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
        
        return new Opportunity(
            Name = 'Test',
            ANP__c = 1234,
            StageName = '対応中',
            CloseDate = system.today(),
            RecordTypeId = recordTypeIdOPP,
            AccountId = accountId            
        );
    }
    
    private LittleContract__c createLittleContract(Id accountId,Id oppId){
        return new LittleContract__c(
            InsuranceType__c = 'test little insurance',
            /*** 本番00090 FIX START ***/
            //SubscriberStatus__c='オープン',
            SubscriberStatus__c ='10',
            /*** 本番00090 END START ***/
            SubscriberManageNo__c = '3333333',
            Name = 'test little insurance name',
            SubscriberNameKanji__c = '楽天　少短一郎',
            InsurancePeriod__c = 'little period',
            InsuranceCommencement__c = '2019/01/01',
            InsuredKanji__c = '楽天　少短一郎',
            InsuranceTarget_1__c = 'pet name',
            SubscriberTel__c = '333-4444-5555',
            //20200421 RIPCRM-218 修正　開始
            //InsurancePremium__c = '3000',
            KEIYAKUJI_PRM_TOTAL__c = 3000,
            //20200421 RIPCRM-218 修正　終了
            SubscriberAddressKanji__c = '東京都世田谷区玉川',
            CustomerNumber__c = '1',
            petAge__c = '5',
            SubscriberManageNoMaster__c = 'SubScr',
            Opportunity__c = oppId,
            AccountId__c = accountId
        );
    }

    private Account getAccountById(Id id){
        return [SELECT Id, Name, nameChangedFlag__c, genderChangedFlag__c, birthdateChangedFlag__c 
                FROM   Account 
                WHERE  Id =: id];
    }
    
    private Opportunity getOpportunityById( Id oppId ) {
        return [SELECT id,StageName,telReason__c,CloseDate,AccountId,InflowRoute__c,Name,ANP__c,EstimatedANP__c,
                CloseType__c,RecentProbability__c,CloseReason__c
                FROM Opportunity WHERE  Id =: oppId LIMIT 1];
    }
}