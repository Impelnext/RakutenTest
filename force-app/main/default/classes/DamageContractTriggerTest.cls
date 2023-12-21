@isTest
public class DamageContractTriggerTest
{
    @isTest
    static void DamageContractTriggerTest_execut1()
    {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();

        insert  triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        insert  triggerTest.createOpportunity(account.Id,'損保');
        Opportunity opp = [SELECT Id,ANP__c FROM Opportunity LIMIT 1];

        Test.startTest();

        DamageContract__c dc = triggerTest.createDamageContract(account.Id,opp.id);
        insert dc;
        
        Id oppId = [SELECT Id, Opportunity__c FROM DamageContract__c WHERE Id =: dc.Id LIMIT 1].Opportunity__c;
        Opportunity resOpp = triggerTest.getOpportunityById(oppId);
        System.assertEquals(dc.Opportunity__c, oppId);
        System.assertEquals('対応終了', resOpp.StageName);
        System.assertEquals(system.today(), resOpp.CloseDate);
        System.assertEquals(Integer.valueOf(dc.InsuranceFee__c)+opp.ANP__c, resOpp.ANP__c);
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
    public static void onAfterProccess_kana_name_chenged() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    
        
        Account ac =  triggerTest.createAccount();
        insert ac;
        
        DamageContract__c dc = new DamageContract__c();
        dc.TorihikisakiKana__c = 'ラクテン　ソンポイチロウ';
        dc.TorihikisakiGender__c = '男';
        dc.TorihikisakiBD__c = '19000101';
        dc.AccountId__c = ac.Id;
        insert dc;
        dc.TorihikisakiKana__c = 'ラクテン　ソンポジロウ';
        
        Test.startTest();
        update dc;
        Test.stopTest();
        Account result = triggerTest.getAccountById(dc.AccountId__c);
        system.assertEquals(false, result.nameChangedFlag__c);
        system.assertEquals(false, result.genderChangedFlag__c);
        system.assertEquals(false, result.birthdateChangedFlag__c);
    }

    /** 
        契約者変更対応により性別変更フラグON処理をCRMバッチ側に移行
        値変更によるフラグON処理が実行されないことを確認する
     **/
    @isTest
    public static void onAfterProccess_gender_chenged() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    

        Account ac =  triggerTest.createAccount();
        insert ac;
        
        DamageContract__c dc = new DamageContract__c();
        dc.TorihikisakiKana__c = 'ラクテン　ソンポイチロウ';
        dc.TorihikisakiGender__c = '男';
        dc.TorihikisakiBD__c = '19000101';
        dc.AccountId__c = ac.Id;
        insert dc;
        dc.TorihikisakiGender__c = '女';
        
        Test.startTest();
        update dc;
        Test.stopTest();
        Account result = triggerTest.getAccountById(dc.AccountId__c);
        system.assertEquals(false, result.nameChangedFlag__c);
        system.assertEquals(false, result.genderChangedFlag__c);
        system.assertEquals(false, result.birthdateChangedFlag__c);
    }

    /** 
        契約者変更対応により生年月日変更フラグON処理をCRMバッチ側に移行
        値変更によるフラグON処理が実行されないことを確認する
     **/
    @isTest
    public static void onAfterProccess_birth_date_chenged() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    

        Account ac =  triggerTest.createAccount();
        insert ac;
        
        DamageContract__c dc = new DamageContract__c();
        dc.TorihikisakiKana__c = 'ラクテン　ソンポイチロウ';
        dc.TorihikisakiGender__c = '男';
        dc.TorihikisakiBD__c = '19000101';
        dc.AccountId__c = ac.Id;
        insert dc;
        dc.TorihikisakiBD__c = '19990101';
        
        Test.startTest();
        update dc;
        Test.stopTest();
        Account result = triggerTest.getAccountById(dc.AccountId__c);
        system.assertEquals(false, result.nameChangedFlag__c);
        system.assertEquals(false, result.genderChangedFlag__c);
        system.assertEquals(false, result.birthdateChangedFlag__c);
    }
    
    @isTest
    static void DamageContractTriggerTest_Exist_Opp()
    {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();

        Account acc = triggerTest.createAccount();  
        acc.PersonHomePhone = '333-4444-5555';
        insert acc;
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        insert  triggerTest.createAccount();
        List<Account> accList = [SELECT Id FROM Account];
        
        
        insert  triggerTest.createOpportunity(account.Id,'損保');
        insert  triggerTest.createOpportunity(account.Id,'汎用');
        List<Opportunity> opp = [SELECT Id,ANP__c FROM Opportunity ];

        Test.startTest();

        DamageContract__c dc = triggerTest.createDamageContract(account.Id,opp[0].id);
        insert dc;
        dc.CarNo__c = '111-2222';
        dc.AccountId__c = accList[1].id;
        update dc;
        
        DamageContract__c dcList = [select id,AccountId__c from DamageContract__c where id =: dc.id];
        System.assertNotEquals(account.id, dcList.AccountId__c);
              
        Opportunity resOpp = triggerTest.getOpportunityById(opp[0].Id);
        System.assertEquals(dc.Opportunity__c, resOpp.id);
        System.assertEquals('対応終了', resOpp.StageName);
        System.assertEquals(system.today(), resOpp.CloseDate);
        System.assertEquals(Integer.valueOf(dc.InsuranceFee__c)+opp[0].ANP__c, resOpp.ANP__c);
        System.assertEquals(resOpp.ANP__c, resOpp.EstimatedANP__c);
        System.assertEquals('申込', resOpp.CloseType__c);
        
        Opportunity resOtherClosedOpp = triggerTest.getOpportunityById(opp[1].Id);
        System.assertNotEquals(dc.Opportunity__c, resOtherClosedOpp.id);
        System.assertEquals('対応終了', resOtherClosedOpp.StageName);
        System.assertEquals(system.today(), resOtherClosedOpp.CloseDate);      
        System.assertEquals('対応打ち切り', resOtherClosedOpp.CloseType__c);
        System.assertEquals('他商談にて対応', resOtherClosedOpp.CloseReason__c);
        System.assertEquals('申込なし', resOtherClosedOpp.RecentProbability__c);
        
        Test.stopTest();
        
    }

    @isTest
    static void DamageContract_NoAccountId_Error(){

        List<DamageContract__c> damageContractList = new List<DamageContract__c>();
        DamageContract__c damage1 = new DamageContract__c(
            Name = 'DamageContract_ErrorTest_001',
            ContractUniqueKey__c = 'ERR-000000001'
        );
        DamageContract__c damage2 = new DamageContract__c(
            Name = 'DamageContract_ErrorTest_002',
            ContractUniqueKey__c = '000000002',
            OpenId__c = 'XX0001'
        );
        damageContractList.add(damage1);
        damageContractList.add(damage2);

        insert(damageContractList);
        
        List<ErrorLog__c> errorLog = [SELECT Id, ProgramName__c, ErrorMessage__c FROM ErrorLog__c WHERE ProgramName__c = 'DamageContractTrigger.NoAccountIdContractProcess'];
        System.assertEquals('保険種類に値が入っていません。\n 保険証券番号：000000001\n OpenID :なし', errorLog.get(0).ErrorMessage__c);
        System.assertEquals('対象の契約が存在しません。\n 契約識別番号：000000002\n OpenID :あり', errorLog.get(1).ErrorMessage__c);

        System.assertEquals(0, [SELECT count() FROM DamageContract__c WHERE ID IN: damageContractList]);
    }

    private Account createAccount(){
        List<RecordType> recordTypes = [SELECT Id, Name 
                                        FROM   RecordType 
                                        WHERE  SobjectType = 'Account' 
                                        And    Name = '個人取引先' 
                                        ORDER BY Name ASC LIMIT 50];
        return new Account(
            LastName='個人',
            FirstName='取引先',
            furiganaLast__pc = 'Firigana',
            furiganaForst__pc = 'Forst',
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
            RecentProbability__c = '申込なし',
            CloseDate = system.today(),
            RecordTypeId = recordTypeIdOPP,
            AccountId = accountId
        );
    }
    
    private DamageContract__c createDamageContract(Id accountId,Id oppId){
        return new DamageContract__c(
            InsuraPolicyNo__c = '2222222',
            Name = 'test damage insurance',
            ContractTerm__c = 'test damage contract term',
            ContractStartDate__c = '20190101',
            InsuredPerson__c = '楽天　損保一郎',
            CarNo__c = '111-2222',
            SubjectArea__c = '東京都',
            InsuredPhoneNum__c = '222-3333-4444',
            InsuranceFee__c = '2500',
            ContractStatus__c = '新規',
            TorihikisakiKana__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ',
            PaymentType__c = '年払い',
            PledgeOrNot__c = '有',
            Opportunity__c = oppId,
            AccountId__c = accountId);
    }
    private DamageContract__c updateDamageContract(DamageContract__c damageContract){
        damageContract.TorihikisakiKana__c = '楽天　損保二郎';
        damageContract.TorihikisakiGender__c = '漢';
        damageContract.TorihikisakiBD__c = '19090909';
        return damageContract;
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
    
    /**** Mail Update Functionality- For Migration code coverage we can comment - 【通常稼働用】 Start**********/
    /*********/
    @isTest
    public static void setDamageContractMail_Insert_Changed() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();
        
        Test.startTest();
        Account acc = triggerTest.createAccount();  
        acc.PersonEmail = 'test1@gmail.com';
        insert acc;
        
        DamageContract__c dc = new DamageContract__c();
        dc.Name='Test';
        dc.Mail__c='test2@gmail.com';
        dc.AccountId__c = acc.Id;
        dc.ContractUniqueKey__c = '122333';
        insert dc;
        
        
        
        Test.stopTest();
        Account account = [SELECT Id,PersonEmail FROM Account where ID=:acc.Id LIMIT 1];
        DamageContract__c damageContract = [SELECT id,Mail__c from DamageContract__c where id =: dc.id Limit 1];
        system.assertEquals(account.PersonEmail,damageContract.Mail__c);
        
    }
    @isTest
    public static void setDamageContractMail_Insert_Null() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    
        
        Test.startTest();
        Account acc = triggerTest.createAccount();  
        insert acc;
        
        DamageContract__c dc = new DamageContract__c();
        dc.Name='Test';
        dc.AccountId__c = acc.Id;
        dc.ContractUniqueKey__c = '122333';
        dc.Mail__c='test@gmail.com';
        insert dc;
        
        
        
        Test.stopTest();
        Account account = [SELECT Id,PersonEmail FROM Account where ID=:acc.Id LIMIT 1];        
        system.assertEquals('test@gmail.com',account.PersonEmail);
        
    }
    
    @isTest
    public static void setDamageContractMail_Insert_InvalidEmail() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    
        
        Test.startTest();
        Account acc = triggerTest.createAccount();  
        insert acc;
        
        DamageContract__c dc = new DamageContract__c();
        dc.Name='Test';
        dc.Mail__c='test2';
        dc.AccountId__c = acc.Id;
        dc.ContractUniqueKey__c = '122333';
        insert dc;
        
        Test.stopTest();
        Account account = [SELECT Id,PersonEmail FROM Account where ID=:acc.Id LIMIT 1];
        DamageContract__c damageContract = [SELECT id,Mail__c,Name from DamageContract__c where id =: dc.id Limit 1];
        system.assertEquals(NULL,account.PersonEmail);
        system.assertEquals('test2',damageContract.Mail__c);
        system.assertEquals('Test',damageContract.Name);
        
    }
    
    @isTest
    public static void setDamageContractMail_Insert_InvalidEmail2() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    
        
        Test.startTest();
        Account acc = triggerTest.createAccount(); 
        acc.PersonEmail = 'test@gmail.com';
        insert acc;
        
        DamageContract__c dc = new DamageContract__c();
        dc.Name='Test';
        dc.Mail__c='test2';
        dc.AccountId__c = acc.Id;
        dc.ContractUniqueKey__c = '122333';
        insert dc;
        
        Test.stopTest();
        Account account = [SELECT Id,PersonEmail FROM Account where ID=:acc.Id LIMIT 1];
        DamageContract__c damageContract = [SELECT id,Mail__c,Name from DamageContract__c where id =: dc.id Limit 1];
        system.assertEquals('test@gmail.com',account.PersonEmail);
        system.assertEquals('test2',damageContract.Mail__c);
        
    }
    
    @isTest
    public static void setDamageContractMail_Update_Changed() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    
        
        Test.startTest();
        Account acc = triggerTest.createAccount();  
        acc.PersonEmail = 'test1@gmail.com';
        insert acc;
        
        DamageContract__c dc = new DamageContract__c();
        dc.Name='Test';
        dc.AccountId__c = acc.Id;
        dc.ContractUniqueKey__c = '122333';
        insert dc;
        
        
        dc.Mail__c='test2@gmail.com';
        Update dc;
        
        Test.stopTest();
        Account account = [SELECT Id,PersonEmail FROM Account where ID=:acc.Id LIMIT 1];     
        system.assertEquals(account.PersonEmail,dc.Mail__c);
        
    }
    @isTest
    public static void setDamageContractMail_Update_Null() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    
        
        Test.startTest();
        
        Account acc1 = triggerTest.createAccount();  
        acc1.PersonEmail = 'test1@gmail.com';
        insert acc1;
        
        DamageContract__c dc = new DamageContract__c();
        dc.Name='Test';
        dc.AccountId__c = acc1.Id;
        dc.Mail__c='test2@gmail.com';
        dc.ContractUniqueKey__c = '122333';
        insert dc;
        
        Account acc = triggerTest.createAccount();  
        acc.PersonEmail = 'test1@gmail.com';
        insert acc;
        
        
        dc.Mail__c='';
        dc.AccountId__c = acc.Id;
        Update dc;
        
        Test.stopTest();
        Account account = [SELECT Id,PersonEmail FROM Account where ID=:acc.Id LIMIT 1];
        system.assertEquals('test1@gmail.com',account.PersonEmail);
        
        
    }
    @isTest
    public static void setDamageContractMail_Update_Dc_Changed() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    
        
        Test.startTest();
        Account acc = triggerTest.createAccount();  
        acc.PersonEmail = 'test1@gmail.com';
        insert acc;
        
        DamageContract__c dc = new DamageContract__c();
        dc.Name='Test';
        dc.AccountId__c = acc.Id;
        dc.Mail__c='test1@gmail.com';
        dc.ContractUniqueKey__c = '122333';
        insert dc;
        
        
        dc.Mail__c='test2@gmail.com';
        Update dc;
        
        Test.stopTest();
        Account account = [SELECT Id,PersonEmail FROM Account where ID=:acc.Id LIMIT 1];
        system.assertEquals(account.PersonEmail,dc.Mail__c);
        
    }
     @isTest
     public static void setDamageContractMail_Update_Dc_Invalid() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    
        
        Test.startTest();
        Account acc = triggerTest.createAccount();  
        acc.PersonEmail = 'test1@gmail.com';
        insert acc;
        
        DamageContract__c dc = new DamageContract__c();
        dc.Name='Test';
        dc.AccountId__c = acc.Id;
        dc.Mail__c='test1@gmail.com';
        dc.ContractUniqueKey__c = '122333';
        insert dc;
        
        
        dc.Mail__c='test2';
        Update dc;
        
        Test.stopTest();
        Account account = [SELECT Id,PersonEmail FROM Account where ID=:acc.Id LIMIT 1];
        DamageContract__c damageContract = [SELECT id,Mail__c,Name from DamageContract__c where id =: dc.id Limit 1]; 
        system.assertEquals('test1@gmail.com',account.PersonEmail);
        system.assertEquals('test2',damageContract.Mail__c);
        
    }
    @isTest
    public static void setDamageContractMail_Update_Dc_Invalid1() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    
        
        Test.startTest();
        
        Account acc1 = triggerTest.createAccount();  
        acc1.PersonEmail = 'test1@gmail.com';
        insert acc1;
        
        DamageContract__c dc = new DamageContract__c();
        dc.Name='Test';
        dc.AccountId__c = acc1.Id;
        dc.Mail__c='test1@gmail.com';
        dc.ContractUniqueKey__c = '122333';
        insert dc;
        
        Account acc = triggerTest.createAccount();  
        acc.PersonEmail = 'test2@gmail.com';
        insert acc;
        
        
        dc.Mail__c='test2';
        dc.AccountId__c = acc.Id;
        Update dc;
        
        Test.stopTest();
        Account account = [SELECT Id,PersonEmail FROM Account where ID=:acc.Id LIMIT 1];
        DamageContract__c damageContract = [SELECT id,Mail__c from DamageContract__c where id =: dc.id Limit 1];
        system.assertEquals('test2@gmail.com',account.PersonEmail);
        system.assertEquals('test2',damageContract.Mail__c);
        
        
    }
    @isTest
    public static void setDamageContractMail_Update_DC_Invalid_Null() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    
        
        Test.startTest();
        
        Account acc = triggerTest.createAccount();  
        insert acc;
                
        DamageContract__c dc = new DamageContract__c();
        dc.Name='Test';
        dc.AccountId__c = acc.Id;
        dc.ContractUniqueKey__c = '122333';
        insert dc;
    
        dc.Mail__c='test2';
        Update dc;
        
        Test.stopTest();
        Account account = [SELECT Id,PersonEmail FROM Account where ID=:acc.Id LIMIT 1];
        DamageContract__c damageContract = [SELECT id,Mail__c from DamageContract__c where id =: dc.id Limit 1];
        List<ErrorLog__c> errorlist=[select id from ErrorLog__c];
        system.assertEquals(NULL,account.PersonEmail);
        system.assertEquals('test2',damageContract.Mail__c);
        system.assertEquals(1,errorlist.size());
        
    }
    @isTest
    public static void setDamageContractMail_Multiple_Insert_Invalid() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    
        List<DamageContract__c> damagecontract =new List<DamageContract__c>();
        
        Test.startTest();
        Account acc = triggerTest.createAccount();  
        acc.PersonEmail = 'test@gmail.com';
        insert acc;
        
        DamageContract__c dc = new DamageContract__c();
        dc.Name='Test';
        dc.Mail__c='test1';
        dc.AccountId__c = acc.Id;
        dc.ContractUniqueKey__c = '122333';
        damagecontract.add(dc);
        
        DamageContract__c dc1 = new DamageContract__c();
        dc1.Name='Test';
        dc1.Mail__c='test1';
        dc1.AccountId__c = acc.Id;
        dc1.ContractUniqueKey__c = '122334';
         damagecontract.add(dc1);
        
        DamageContract__c dc2 = new DamageContract__c();
        dc2.Name='Test';
        dc2.Mail__c='test1';
        dc2.AccountId__c = acc.Id;
        dc2.ContractUniqueKey__c = '122335';
         damagecontract.add(dc2);
        
        DamageContract__c dc3 = new DamageContract__c();
        dc3.Name='Test';
        dc3.Mail__c='test1';
        dc3.AccountId__c = acc.Id;
        dc3.ContractUniqueKey__c = '122336';
        damagecontract.add(dc3);
        
        DamageContract__c dc4 = new DamageContract__c();
        dc4.Name='Test';
        dc4.Mail__c='test1';
        dc4.AccountId__c = acc.Id;
        dc4.ContractUniqueKey__c = '122337';
        damagecontract.add(dc4); 
        
        insert damagecontract;
        
        Test.stopTest();
        Account account = [SELECT Id,PersonEmail FROM Account where ID=:acc.Id LIMIT 1];
        List<DamageContract__c> damageContract1 = [SELECT id,Mail__c from DamageContract__c   Order By  ContractUniqueKey__c];
        List<ErrorLog__c> errorlist=[select id from ErrorLog__c];
        system.assertEquals('test@gmail.com',account.PersonEmail);
        system.assertEquals('test1',damageContract1[0].Mail__c);
        system.assertEquals('test1',damageContract1[1].Mail__c);
        system.assertEquals('test1',damageContract1[2].Mail__c);
        system.assertEquals('test1',damageContract1[3].Mail__c);
        system.assertEquals('test1',damageContract1[4].Mail__c);
        system.assertEquals(5,errorlist.size());
        
    }
    @isTest
    public static void setDamageContractMail_Multiple_Insert_Invalid1() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    
        List<DamageContract__c> damagecontract =new List<DamageContract__c>();
        
        Test.startTest();
        Account acc1 = triggerTest.createAccount();  
        acc1.PersonEmail = 'test1@gmail.com';
        insert acc1;
        
        Account acc2 = triggerTest.createAccount();  
        acc2.PersonEmail = 'test2@gmail.com';
        insert acc2;
        
        Account acc3 = triggerTest.createAccount();  
        acc3.PersonEmail = 'test3@gmail.com';
        insert acc3;
        
        Account acc4 = triggerTest.createAccount();  
        acc4.PersonEmail = 'test4@gmail.com';
        insert acc4;
        
        Account acc5 = triggerTest.createAccount();  
        acc5.PersonEmail = 'test5@gmail.com';
        insert acc5;
        
        DamageContract__c dc1 = new DamageContract__c();
        dc1.Name='Test1';
        dc1.Mail__c='test1';
        dc1.AccountId__c = acc1.Id;
        dc1.ContractUniqueKey__c = '122331';
        damagecontract.add(dc1);
    
        DamageContract__c dc2 = new DamageContract__c();
        dc2.Name='Test2';
        dc2.Mail__c='test2';
        dc2.AccountId__c = acc2.Id;
        dc2.ContractUniqueKey__c = '122332';
         damagecontract.add(dc2);
        
        DamageContract__c dc3 = new DamageContract__c();
        dc3.Name='Test3';
        dc3.Mail__c='test3';
        dc3.AccountId__c = acc3.Id;
        dc3.ContractUniqueKey__c = '122333';
        damagecontract.add(dc3);
        
        DamageContract__c dc4 = new DamageContract__c();
        dc4.Name='Test4';
        dc4.Mail__c='test4';
        dc4.AccountId__c = acc4.Id;
        dc4.ContractUniqueKey__c = '122334';
        damagecontract.add(dc4); 
        
        DamageContract__c dc5 = new DamageContract__c();
        dc5.Name='Test5';
        dc5.Mail__c='test5';
        dc5.AccountId__c = acc5.Id;
        dc5.ContractUniqueKey__c = '122335';
        damagecontract.add(dc5); 
        
        insert damagecontract;
        
        Test.stopTest();
        List<Account> account = [SELECT Id,PersonEmail FROM Account ];
        List<DamageContract__c> damageContract1 = [SELECT id,Mail__c from DamageContract__c   Order By  ContractUniqueKey__c];
        List<ErrorLog__c> errorlist=[select id from ErrorLog__c];
        system.assertEquals('test1@gmail.com',account[0].PersonEmail);
        system.assertEquals('test2@gmail.com',account[1].PersonEmail);
        system.assertEquals('test3@gmail.com',account[2].PersonEmail);
        system.assertEquals('test4@gmail.com',account[3].PersonEmail);
        system.assertEquals('test5@gmail.com',account[4].PersonEmail);
        system.assertEquals('test1',damageContract1[0].Mail__c);
        system.assertEquals('test2',damageContract1[1].Mail__c);
        system.assertEquals('test3',damageContract1[2].Mail__c);
        system.assertEquals('test4',damageContract1[3].Mail__c);
        system.assertEquals('test5',damageContract1[4].Mail__c);
        system.assertEquals(5,errorlist.size());
        
    }
    @isTest
    public static void setDamageContractMail_Multiple_Update_Invalid() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    
        List<DamageContract__c> damagecontract =new List<DamageContract__c>();
        
        Test.startTest();
        Account acc1 = triggerTest.createAccount();  
        acc1.PersonEmail = 'test@gmail.com';
        insert acc1;
                
        DamageContract__c dc1 = new DamageContract__c();
        dc1.Name='Test1';
        dc1.Mail__c='test1@gmail.com';
        dc1.AccountId__c = acc1.Id;
        dc1.ContractUniqueKey__c = '122331';
        damagecontract.add(dc1);
        
        DamageContract__c dc2 = new DamageContract__c();
        dc2.Name='Test2';
        dc2.Mail__c='test1@gmail.com';
        dc2.AccountId__c = acc1.Id;
        dc2.ContractUniqueKey__c = '122332';
         damagecontract.add(dc2);
        
        DamageContract__c dc3 = new DamageContract__c();
        dc3.Name='Test3';
        dc3.Mail__c='test1@gmail.com';
        dc3.AccountId__c = acc1.Id;
        dc3.ContractUniqueKey__c = '122333';
        damagecontract.add(dc3);
        
        DamageContract__c dc4 = new DamageContract__c();
        dc4.Name='Test4';
        dc4.Mail__c='test1@gmail.com';
        dc4.AccountId__c = acc1.Id;
        dc4.ContractUniqueKey__c = '122334';
        damagecontract.add(dc4); 
        
        DamageContract__c dc5 = new DamageContract__c();
        dc5.Name='Test5';
        dc5.Mail__c='test1@gmail.com';
        dc5.AccountId__c = acc1.Id;
        dc5.ContractUniqueKey__c = '122335';
        damagecontract.add(dc5); 
        
        insert damagecontract;
        
        dc1.Mail__c='test1';
        dc2.Mail__c='test1';
        dc3.Mail__c='test1';
        dc4.Mail__c='test1';
        dc5.Mail__c='test1';        
        
        Update damageContract;
        
        Test.stopTest();
        Account account = [SELECT Id,PersonEmail FROM Account ];
        List<DamageContract__c> damageContract1 = [SELECT id,Mail__c from DamageContract__c   Order By  ContractUniqueKey__c];
        List<ErrorLog__c> errorlist=[select id from ErrorLog__c];
        system.assertEquals('test1@gmail.com',account.PersonEmail);
        system.assertEquals('test1',damageContract1[0].Mail__c);
        system.assertEquals('test1',damageContract1[1].Mail__c);
        system.assertEquals('test1',damageContract1[2].Mail__c);
        system.assertEquals('test1',damageContract1[3].Mail__c);
        system.assertEquals('test1',damageContract1[4].Mail__c);
        system.assertEquals(5,errorlist.size());
        
    } 
    
    @isTest
    public static void setDamageContractMail_Multiple_Insert_Invalid_Valid() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();
        List<DamageContract__c> damagecontract =new List<DamageContract__c>();
        
        Test.startTest();
        Account acc1 = triggerTest.createAccount();
        insert acc1;
        
        Account acc2 = triggerTest.createAccount();
        insert acc2;
                
        DamageContract__c dc1 = new DamageContract__c();
        dc1.Name='Test1';
        dc1.Mail__c='test1';
        dc1.AccountId__c = acc1.Id;
        dc1.ContractUniqueKey__c = '122331';
        damagecontract.add(dc1);
        
        DamageContract__c dc2 = new DamageContract__c();
        dc2.Name='Test2';
        dc2.Mail__c='test2@gmail.com';
        dc2.AccountId__c = acc2.Id;
        dc2.ContractUniqueKey__c = '122332';
        damagecontract.add(dc2);
        
        insert damagecontract;      
        
        Test.stopTest();
        Account account1 = [SELECT Id,PersonEmail FROM Account where id =: acc1.id];
        Account account2 = [SELECT Id,PersonEmail FROM Account where id =: acc2.id];
        List<DamageContract__c> damageContract1 = [SELECT id,Mail__c from DamageContract__c   Order By  ContractUniqueKey__c];
        List<ErrorLog__c> errorlist=[select id from ErrorLog__c];
        system.assertEquals(NULL,account1.PersonEmail);
        system.assertEquals('test2@gmail.com',account2.PersonEmail);
        system.assertEquals('test1',damageContract1[0].Mail__c);
        system.assertEquals('test2@gmail.com',damageContract1[1].Mail__c);
        system.assertEquals(1,errorlist.size());
        
    }
    
    @isTest
    public static void setDamageContractMail_Multiple_Insert_Invalid_Valid2() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();
        List<DamageContract__c> damagecontract =new List<DamageContract__c>();
        
        Test.startTest();
        Account acc1 = triggerTest.createAccount();
        acc1.PersonEmail = 'test1@gmail.com';
        insert acc1;
        
        Account acc2 = triggerTest.createAccount();
        acc2.PersonEmail = 'test2@gmail.com';
        insert acc2;
                
        DamageContract__c dc1 = new DamageContract__c();
        dc1.Name='Test1';
        dc1.Mail__c='test3';
        dc1.AccountId__c = acc1.Id;
        dc1.ContractUniqueKey__c = '122331';
        damagecontract.add(dc1);
        
        DamageContract__c dc2 = new DamageContract__c();
        dc2.Name='Test2';
        dc2.Mail__c='test4@gmail.com';
        dc2.AccountId__c = acc2.Id;
        dc2.ContractUniqueKey__c = '122332';
        damagecontract.add(dc2);
        
        insert damagecontract;      
        
        Test.stopTest();
        Account account1 = [SELECT Id,PersonEmail FROM Account where id =: acc1.id];
        Account account2 = [SELECT Id,PersonEmail FROM Account where id =: acc2.id];
        List<DamageContract__c> damageContract1 = [SELECT id,Mail__c from DamageContract__c   Order By  ContractUniqueKey__c];
        List<ErrorLog__c> errorlist=[select id from ErrorLog__c];
        system.assertEquals('test1@gmail.com',account1.PersonEmail);
        system.assertEquals('test4@gmail.com',account2.PersonEmail);
        system.assertEquals('test3',damageContract1[0].Mail__c);
        system.assertEquals('test4@gmail.com',damageContract1[1].Mail__c);
        system.assertEquals(1,errorlist.size());
        
    }
    
    @isTest
    public static void setDamageContractMail_Multiple_Update_Invalid_Valid() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();
        List<DamageContract__c> damagecontract =new List<DamageContract__c>();
        
        Test.startTest();
        Account acc1 = triggerTest.createAccount();
        insert acc1;
        
        Account acc2 = triggerTest.createAccount();
        insert acc2;
                
        DamageContract__c dc1 = new DamageContract__c();
        dc1.Name='Test1';
        dc1.Mail__c=NULL;
        dc1.AccountId__c = acc1.Id;
        dc1.ContractUniqueKey__c = '122331';
        damagecontract.add(dc1);
        
        DamageContract__c dc2 = new DamageContract__c();
        dc2.Name='Test2';
        dc2.AccountId__c = acc2.Id;
        dc2.ContractUniqueKey__c = '122332';
        damagecontract.add(dc2);
        
        insert damagecontract;
        
        dc1.Mail__c='test1@gmail.com';
        dc2.Mail__c='test2';
        
        Update damageContract;
        
        Test.stopTest();
        Account account1 = [SELECT Id,PersonEmail FROM Account where id =: acc1.id];
        Account account2 = [SELECT Id,PersonEmail FROM Account where id =: acc2.id];
        List<DamageContract__c> damageContract1 = [SELECT id,Mail__c from DamageContract__c   Order By  ContractUniqueKey__c];
        List<ErrorLog__c> errorlist=[select id from ErrorLog__c];
        system.assertEquals('test1@gmail.com',account1.PersonEmail);
        system.assertEquals(NULL,account2.PersonEmail);
        system.assertEquals('test1@gmail.com',damageContract1[0].Mail__c);
        system.assertEquals('test2',damageContract1[1].Mail__c);
        system.assertEquals(1,errorlist.size());
        
    }
    
    @isTest
    public static void setDamageContractMail_Multiple_Update_Invalid_Valid2() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();
        List<DamageContract__c> damagecontract =new List<DamageContract__c>();
        
        Test.startTest();
        Account acc1 = triggerTest.createAccount();
        insert acc1;
        
        Account acc2 = triggerTest.createAccount();
        insert acc2;
                
        DamageContract__c dc1 = new DamageContract__c();
        dc1.Name='Test1';
        dc1.Mail__c='test1@gmail.com';
        dc1.AccountId__c = acc1.Id;
        dc1.ContractUniqueKey__c = '122331';
        damagecontract.add(dc1);
        
        DamageContract__c dc2 = new DamageContract__c();
        dc2.Name='Test2';
        dc2.Mail__c='test2@gmail.com';
        dc2.AccountId__c = acc2.Id;
        dc2.ContractUniqueKey__c = '122332';
        damagecontract.add(dc2);
        
        insert damagecontract;
        
        dc1.Mail__c='test3@gmail.com';
        dc2.Mail__c='test4';
        
        Update damageContract;
        
        Test.stopTest();
        Account account1 = [SELECT Id,PersonEmail FROM Account where id =: acc1.id];
        Account account2 = [SELECT Id,PersonEmail FROM Account where id =: acc2.id];
        List<DamageContract__c> damageContract1 = [SELECT id,Mail__c from DamageContract__c   Order By  ContractUniqueKey__c];
        List<ErrorLog__c> errorlist=[select id from ErrorLog__c];
        system.assertEquals('test3@gmail.com',account1.PersonEmail);
        system.assertEquals('test2@gmail.com',account2.PersonEmail);
        system.assertEquals('test3@gmail.com',damageContract1[0].Mail__c);
        system.assertEquals('test4',damageContract1[1].Mail__c);
        system.assertEquals(1,errorlist.size());
        
    }
    
    @isTest
    public static void setDamageContractMail_Other_Error() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    
        
        Test.startTest();
        Account acc = triggerTest.createAccount();  
        insert acc;
         
        List<DamageContract__c> dcList = new List<DamageContract__c>();
        DamageContract__c dc = new DamageContract__c();
        dc.Name='Test';
        dc.Mail__c = 'test@gmail.com';
        dc.AccountId__c = acc.Id;
        dc.ContractUniqueKey__c = '122333';
        dcList.add(dc);
        
        DamageContract__c dc1 = new DamageContract__c();
        dc1.Name='Test';
        dc1.Mail__c = 'test@gmail.com';
        dc1.AccountId__c = acc.Id;
        dc1.ContractUniqueKey__c = '122333';
        dcList.add(dc1);
        
        try{
            insert dcList;     
        }catch(exception exp){
            
        }
        
        
        Test.stopTest();
        Account account = [SELECT Id,PersonEmail FROM Account where ID=:acc.Id LIMIT 1];    
        List<DamageContract__c> damageContract1 = [SELECT id,Mail__c from DamageContract__c];
        List<ErrorLog__c> errorlist=[select id from ErrorLog__c];
        system.assertEquals(null,account.PersonEmail);
        system.assertEquals(0,damageContract1.size());
        system.assertEquals(0,errorlist.size());
        
    }
    /**********/
    /**** Mail Update Functionality - For Migration code coverage we can comment - 【通常稼働用】End**********/
    
    /**** Mail Update Functionality - For Migration code coverage we can uncomment - 【移行用】Start**********/
    /*********
    @isTest
    public static void setDamageContractMail_Insert_Acc_mail_Null_Mig() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();
        
        Test.startTest();
        Account acc = triggerTest.createAccount();  
        insert acc;
        
        DamageContract__c dc = new DamageContract__c();
        dc.Name='Test';
        dc.Mail__c = 'test@gmail.com';
        dc.AccountId__c = acc.Id;
        dc.ContractUniqueKey__c = '122333';
        insert dc;
        
        
        
        Test.stopTest();
        Account account = [SELECT Id,PersonEmail FROM Account where ID=:acc.Id LIMIT 1]; 
        DamageContract__c damageContract = [SELECT id,Mail__c from DamageContract__c LIMIT 1];
        system.assertEquals('test@gmail.com',account.PersonEmail);
        system.assertEquals('test@gmail.com',damageContract.Mail__c);
        
    }
    
    @isTest
    public static void setDamageContractMail_Insert_Acc_mail_NotNull_Mig() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    
        
        Test.startTest();
        Account acc = triggerTest.createAccount();
        acc.PersonEmail ='test@gmail.com';
        insert acc;
        
        DamageContract__c dc = new DamageContract__c();
        dc.Name='Test';
        dc.Mail__c = 'test1@gmail.com';
        dc.AccountId__c = acc.Id;
        dc.ContractUniqueKey__c = '122333';
        insert dc;
        
        
        
        Test.stopTest();
        Account account = [SELECT Id,PersonEmail FROM Account where ID=:acc.Id LIMIT 1];  
        DamageContract__c damageContract = [SELECT id,Mail__c from DamageContract__c LIMIT 1];
        system.assertEquals('test@gmail.com',account.PersonEmail);
        system.assertEquals('test1@gmail.com',damageContract.Mail__c);
        
    }
    
    @isTest
    public static void setDamageContractMail_Insert_Invalid_Mail_Mig() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    
        
        Test.startTest();
        Account acc = triggerTest.createAccount();
        insert acc;
        
        DamageContract__c dc = new DamageContract__c();
        dc.Name='Test';
        dc.Mail__c = 'test1';
        dc.AccountId__c = acc.Id;
        dc.ContractUniqueKey__c = '122333';
        insert dc;
        
        Test.stopTest();
        Account account = [SELECT Id,PersonEmail FROM Account where ID=:acc.Id LIMIT 1];   
        DamageContract__c damageContract = [SELECT id,Mail__c from DamageContract__c LIMIT 1];
        system.assertEquals(NULL,account.PersonEmail);
        system.assertEquals('test1',damageContract.Mail__c);
        
    }
    
    @isTest
    public static void setDamageContractMail_Insert_Invalid_Mail_Mig2() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    
        
        Test.startTest();
        Account acc = triggerTest.createAccount();
        acc.PersonEmail ='test@gmail.com';
        insert acc;
        
        DamageContract__c dc = new DamageContract__c();
        dc.Name='Test';
        dc.Mail__c = 'test1';
        dc.AccountId__c = acc.Id;
        dc.ContractUniqueKey__c = '122333';
        insert dc;
        
        Test.stopTest();
        Account account = [SELECT Id,PersonEmail FROM Account where ID=:acc.Id LIMIT 1];  
        DamageContract__c damageContract = [SELECT id,Mail__c from DamageContract__c LIMIT 1];
        system.assertEquals('test@gmail.com',account.PersonEmail);
        system.assertEquals('test1',damageContract.Mail__c);
        
    }
    
    @isTest
    public static void setDamageContractMail_Update_Acc_mail_Null_Mig() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    
        
        Test.startTest();
        Account acc = triggerTest.createAccount();  
        insert acc;
        
        DamageContract__c dc = new DamageContract__c();
        dc.Name='Test';     
        dc.AccountId__c = acc.Id;
        dc.ContractUniqueKey__c = '122333';
        insert dc;
        
        dc.Mail__c = 'test@gmail.com';
        update dc;
        
        Test.stopTest();
        Account account = [SELECT Id,PersonEmail FROM Account where ID=:acc.Id LIMIT 1];        
        system.assertEquals('test@gmail.com',account.PersonEmail);
        
    }
    
    @isTest
    public static void setDamageContractMail_Update_Acc_mail_NotNull_Mig() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    
        
        Test.startTest();
        Account acc = triggerTest.createAccount();
        acc.PersonEmail ='test@gmail.com';
        insert acc;
        
        DamageContract__c dc = new DamageContract__c();
        dc.Name='Test';
        dc.Mail__c = 'test1@gmail.com';
        dc.AccountId__c = acc.Id;
        dc.ContractUniqueKey__c = '122333';
        insert dc;
        
        dc.Mail__c = 'test2@gmail.com';
        update dc;
        
        Test.stopTest();
        Account account = [SELECT Id,PersonEmail FROM Account where ID=:acc.Id LIMIT 1];        
        system.assertEquals('test@gmail.com',account.PersonEmail);
        
    }
    
    @isTest
    public static void setDamageContractMail_Update_Invalid_Mail_Mig() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    
        
        Test.startTest();
        Account acc1 = triggerTest.createAccount();
        insert acc1;
        
        DamageContract__c dc = new DamageContract__c();
        dc.Name='Test';
        dc.Mail__c = 'test1@gmail.com';
        dc.AccountId__c = acc1.Id;
        dc.ContractUniqueKey__c = '122333';
        insert dc;
        
        Account acc = triggerTest.createAccount();
        acc.PersonEmail ='';
        insert acc;
        
        dc.Mail__c = 'test1';
        dc.AccountId__c = acc.Id;
        update dc;
        
        Test.stopTest();
        Account account = [SELECT Id,PersonEmail FROM Account where ID=:acc.Id LIMIT 1];  
        DamageContract__c damageContract = [SELECT id,Mail__c from DamageContract__c LIMIT 1];
        system.assertEquals(NULL,account.PersonEmail);
        system.assertEquals('test1',damageContract.Mail__c);
        
    }
    
    @isTest
    public static void setDamageContractMail_Update_Invalid_Mail_Mig2() {
        DamageContractTriggerTest triggerTest = new DamageContractTriggerTest();                    
        
        Test.startTest();
        Account acc = triggerTest.createAccount();
        acc.PersonEmail ='test@gmail.com';
        insert acc;
        
        DamageContract__c dc = new DamageContract__c();
        dc.Name='Test';
        dc.Mail__c = 'test1@gmail.com';
        dc.AccountId__c = acc.Id;
        dc.ContractUniqueKey__c = '122333';
        insert dc;
        
        dc.Mail__c = 'test1';
        update dc;
        
        Test.stopTest();
        Account account = [SELECT Id,PersonEmail FROM Account where ID=:acc.Id LIMIT 1];  
        DamageContract__c damageContract = [SELECT id,Mail__c from DamageContract__c LIMIT 1];
        system.assertEquals('test@gmail.com',account.PersonEmail);
        system.assertEquals('test1',damageContract.Mail__c);
        
    }
    **********/
    /**** Mail Update Functionality - For Migration code coverage we can uncomment - 【移行用】End**********/
}