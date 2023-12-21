@isTest
public class LifeContractTriggerTest
{
    @isTest
    static void LifeContractTriggerTest_insert()
    {
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        insert  triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        SeihoAgencyMaster__c sam = new SeihoAgencyMaster__c();
        sam.agncyno__c = '789789';
        insert sam;
        
        AgencyMaster__c am = new AgencyMaster__c();
        am.SeihoAgencyCode__c = '789789';
        insert am;
        
        Test.startTest();
        LifeContract__c lc = triggerTest.createLifeContract(account.Id);
        insert lc;
        
        Account acc = triggerTest.getAccountById (lc.AccountId__c);       
        System.assertEquals(True,acc.LifeUse__pc );
        System.assertEquals(True,acc.SeihoOppApplyflg__c );
        
        LifeContract__c resLc = triggerTest.getLifeContractId(lc.id); 
        System.assertEquals(sam.id,resLc.AGENCY__c);
        System.assertEquals(sam.id,resLc.REFERRAL_AGENCY__c);
        System.assertEquals(am.id,resLc.AgencyId__c);
        System.assertEquals(null, resLc.COMPANY_NAME__c);
        System.assertEquals(null, resLc.SEIHO_RECRUITER_NAME__c);
        System.assertEquals(null, resLc.AGENT_NAME__c);
        
        Test.stopTest();
    }
    
    @isTest
    static void LifeContractTriggerTest_update()
    {
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        
        insert  triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createLifeContract(account.Id);
        
        Test.startTest();
        LifeContract__c lc = [SELECT Id, Name, POL_NUM__c, PRODUCT_NAME__c
                              ,KANJI_CONTROR_NAME__c, INSR_PERIOD__c
                              ,CONTRACT_DATE__c, REFERRAL_AGENCY__c, KANJI_INSURED_NAME__c, REFERRAL_AGENCY_NUM__c
                              ,Phone__c, AGENCY_NUM__c, BENE_AMOUNT__c, MONTHLY_PRM__c, Status__c
                              ,KANA_CONTROR_NAME__c, BENEFIT_RECIPIENT__c, AccountId__c
                              FROM LifeContract__c LIMIT 1];
        lc.REFERRAL_AGENCY_NUM__c = 'test';
        lc.AGENCY_NUM__c='987987';
        
        update lc;
        
        Account acc = triggerTest.getAccountById (lc.AccountId__c); 
        System.assertEquals(True,acc.LifeUse__pc );
        System.assertEquals(True,acc.SeihoOppApplyflg__c );
        Test.stopTest();
    }
    
    /** 
        契約者変更対応により契約者名変更フラグON処理をCRMバッチ側に移行
        値変更によるフラグON処理が実行されないことを確認する
     **/
    //Insert Pattern 'A' Verification Matching bothParentChild Insert 
    @isTest
    static void onAfterInsertChildParent_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        
        Test.startTest();
        Lifecontract__c lifeCon=triggerTest.createLifeContractChildParent('生保001','010','01','SEQ01',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','020','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保003','R30','01','SEQ01','020');
        lifeconList.add(lifeCon);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert LifeconList;
        Test.stopTest();
        
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life.MediaidAlfaFlg__c);
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(Null,life1.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
    }
    
    // Insert Pattern 'B' Verification Matching ParentFirst Insert
    @isTest
    static void onAfterInsertParentFirst_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeconParentList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Account ac =  triggerTest.createAccount();
        insert ac;
        ac.seihoAccoutType__c='生保募集人';
        update ac;
        
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','010','01','SEQ06',null);
        lifeCon0.accountId__c=ac.Id;
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保007','020','01','SEQ06',null);
        lifeconParentList.add(lifeCon0);
        lifeconParentList.add(lifeCon1);
        insert lifeconParentList;
        
        Test.startTest();
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保008','R30','01','SEQ06','020');
        Lifecontract__c lifeCon3=triggerTest.createLifeContractChildParent('生保004','R30','05','SEQ06','020');
        LifeconList.add(lifeCon2);
        LifeconList.add(lifeCon3);
        insert LifeconList;
        Test.stopTest();
        
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeCon1.id];
        system.assertEquals('有',life.MediaidAlfaFlg__c);
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeCon0.id];
        system.assertEquals(Null,life1.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:LifeconList[0].id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
        Lifecontract__c life3=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:LifeconList[1].id];
        system.assertEquals(Null,life3.MediaidAlfaFlg__c);
    }
    
    //Insert Pattern 'C' Verification MatchingParentLater Insert 
    @isTest
    static void onAfterInsertParentLater_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeconParentList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保008','R30','01','SEQ06','020');
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保004','R30','05','SEQ06','020');
        
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        insert lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保001','010','01','SEQ06',null);
        Lifecontract__c lifeCon3=triggerTest.createLifeContractChildParent('生保007','020','01','SEQ06',null);
        lifeconParentList.add(lifeCon2);
        lifeconParentList.add(lifeCon3);
        insert lifeconParentList;
        Test.stopTest();
        
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeCon1.id];
        system.assertEquals(Null,life.MediaidAlfaFlg__c);
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeCon0.id];
        system.assertEquals(Null,life1.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconParentList[0].id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
        Lifecontract__c life3=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconParentList[1].id];
        system.assertEquals('有',life3.MediaidAlfaFlg__c);
    }
    
    // Insert Pattern 'D' Verification Matching ParentChild Insert , child 契約ステータス<>”有効”
    @isTest
    static void onAfterInsertChildParent_Process_MediaidAlfaFlgSet() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        
        Test.startTest();
        Lifecontract__c lifeCon=triggerTest.createLifeContractChildParent('生保001','010','01','SEQ01',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','020','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','05','SEQ01','020');
        lifeconList.add(lifeCon);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert LifeconList;
        Test.stopTest();
        
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(Null,life.MediaidAlfaFlg__c);
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life1.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals(Null,life.MediaidAlfaFlg__c);
    }
    
    // Insert Pattern 'E' Verification Matching ParentFirst Insert , child 契約ステータス<>”有効”
    @isTest
    static void onAfterInsertParentFirst_Process_MediaidAlfaFlgSet() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeconParentList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Account ac =  triggerTest.createAccount();
        insert ac;
        ac.seihoAccoutType__c='生保募集人';
        update ac;
        
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','010','01','SEQ06',null);
        lifeCon0.accountId__c=ac.Id;
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保007','020','01','SEQ06',null);
        lifeconParentList.add(lifeCon0);
        lifeconParentList.add(lifeCon1);
        insert lifeconParentList;
        
        Test.startTest();
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保008','R30','04','SEQ06','020');
        Lifecontract__c lifeCon3=triggerTest.createLifeContractChildParent('生保004','R30','05','SEQ06','020');
        LifeconList.add(lifeCon2);
        LifeconList.add(lifeCon3);
        insert LifeconList;
        Test.stopTest();
        
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeCon0.id];
        system.assertEquals(Null,life.MediaidAlfaFlg__c);
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeCon1.id];
        system.assertEquals('有',life1.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeCon2.id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
        Lifecontract__c life3=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeCon3.id];
        system.assertEquals(Null,life3.MediaidAlfaFlg__c);
    }
    
    //Insert Pattern 'F' Verification Matching ParentLater Insert, child 契約ステータス<>”有効”
    @isTest
    static void onAfterInsertParentLater_Process_MediaidAlfaFlgSet() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeconParentList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保008','R30','04','SEQ06','020');
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保004','R30','05','SEQ06','020');
        
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        insert lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保001','010','01','SEQ06',null);
        Lifecontract__c lifeCon3=triggerTest.createLifeContractChildParent('生保007','020','01','SEQ06',null);
        lifeconParentList.add(lifeCon2);
        lifeconParentList.add(lifeCon3);
        insert lifeconParentList;
        Test.stopTest();
        
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconParentList[0].id];
        system.assertEquals(Null,life.MediaidAlfaFlg__c);
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeConList[0].id];
        system.assertEquals(Null,life1.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
        Lifecontract__c life3=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconParentList[1].id];
        system.assertEquals('有',life3.MediaidAlfaFlg__c);
    }
    
    // Insert Pattern 'G' ManyParent with Matching child  本人会員識別SEQ番号 Field
    @isTest
    static void ManyParentRecordsInsert_Process_MediaidAlfaFlg_Set() {
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeconupdateList = new List<lifecontract__c>();
        
        Test.startTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','020','01','SEQ01',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','020','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保007','020','01','SEQ01',null);
        Lifecontract__c lifeCon3=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','020');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        lifeconList.add(lifeCon3);
        insert  lifeconList;
        Test.stopTest();
        
        Lifecontract__c life0=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals('有',life0.MediaidAlfaFlg__c);
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life1.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals('有',life2.MediaidAlfaFlg__c);
        Lifecontract__c life3=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[3].id];
        system.assertEquals(Null,life3.MediaidAlfaFlg__c);
    }
    
    //Insert pattern 'H' Parent and Child are "メディエイドα" type
    @isTest
    static void onParentChildMediaAlphaTypeInsert_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        
        Test.startTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','R30','01','SEQ02','010');
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','R30','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','R30');
        
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        Test.stopTest();
        
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life1.MediaidAlfaFlg__c);
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(Null,life.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals('有',life2.MediaidAlfaFlg__c);
    }
    
    // UPDATE pattern A verification Child  Status Changed from 契約ステータス<>”有効” to 契約ステータス=”有効”
    @isTest
    static void onAfterChildStatusUpdate_Process_MediaidAlfaFlgSet() {
        
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','020','01','SEQ02',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','110','05','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','05','SEQ01','110');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[2];
        lifeCon.STATUS__c='01';
        update lifeCon;
        Test.stopTest();
        
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life.MediaidAlfaFlg__c);
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(Null,life1.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
    }
    
    // UPDATE pattern A verification Parent Status Changed from 契約ステータス<>”有効” to 契約ステータス=”有効”
    @isTest
    static void onAfterparentStatusUpdate_Process_MediaidAlfaFlg_Set() {
        
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','020','01','SEQ02',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','110','05','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','110');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[1];
        lifeCon.STATUS__c='01';
        update lifeCon;
        Test.stopTest();
        
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life.MediaidAlfaFlg__c);
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(Null,life1.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
    }
    
    // UPDATE pattern A verification Parent and child Status Changed from 契約ステータス<>”有効” to 契約ステータス=”有効”
    @isTest
    static void onAfterChildParentStatusUpdate_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeUpdateconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','020','01','SEQ02',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','120','05','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','05','SEQ01','120');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[2];
        Lifecontract__c lifeCon4=lifeconList[1];
        lifeCon.STATUS__c='01';
        lifeCon4.STATUS__c='01';
        lifeUpdateconList.add(lifeCon);
        lifeUpdateconList.add(lifeCon4);
        update lifeUpdateconList;
        Test.stopTest();
        
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life1.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
        Lifecontract__c life3=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals(Null,life3.MediaidAlfaFlg__c);
    }
    
    // UPDATE pattern A verification Child Status Changed from 契約ステータス=”有効”to 契約ステータス<>”有効”
    @isTest
    static void onAfterChildStatusUpdatetoDifferent_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','020','01','SEQ02',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','120','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','120');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[2];
        lifeCon.STATUS__c='05';
        update lifeCon;
        Test.stopTest();
        
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life1.MediaidAlfaFlg__c);
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(Null,life.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
    }
    
    // UPDATE pattern A verification Status Changed from 契約ステータス =”有効” to  契約ステータス <>”有効”
    @isTest
    static void onAfterParentStatusUpdateDifferent_Process_MediaidAlfaFlg_Set() {
        
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','020','01','SEQ02',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','010','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','010');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[1];
        lifeCon.STATUS__c='05';
        update lifeCon;
        Test.stopTest();
        
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life1.MediaidAlfaFlg__c);
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(Null,life.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
    }
    
    // UPDATE pattern A verification Parent and child  Status Changed from 契約ステータス=”有効”to 契約ステータス<>”有効”
    @isTest
    static void onAfterChildParentStatusUpdatetoDifferent_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeUpdateconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','020','01','SEQ02',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','030','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','030');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon4=lifeconList[1];
        Lifecontract__c lifeCon=lifeconList[2];
        lifeCon4.STATUS__c='05';
        lifeCon.STATUS__c='05';
        lifeUpdateconList.add(lifeCon4);
        lifeUpdateconList.add(lifeCon);
        update lifeUpdateconList;
        Test.stopTest();
        
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life.MediaidAlfaFlg__c);
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(Null,life1.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
    }
    
    // UPDATE pattern B verification parent 保険種類(INSURANCE_TYPE_DISPLAY__c) Changed 
    @isTest
    static void onParentTypeChange_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','R30','01','SEQ01','010');
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','020','01','SEQ01','100');
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','120');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[1];
        lifeCon.INSURANCE_TYPE__c='120';
        update LifeCon;
        Test.stopTest();
        
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life1.MediaidAlfaFlg__c);
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(Null,life.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
    }
    
    // UPDATE pattern B verification parent 保険種類(INSURANCE_TYPE_DISPLAY__c) Changed 
    @isTest
    static void onParentTypeChangeDifferent_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','020','01','SEQ02',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','120','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','120');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[1];
        lifeCon.INSURANCE_TYPE__c='040';
        update LifeCon;
        Test.stopTest();
        
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals(Null,life.MediaidAlfaFlg__c);
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(Null,life1.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
    }
    
    // UPDATE pattern B verification child 保険種類(INSURANCE_TYPE_DISPLAY__c) Changed from <>"メディエイドα"to  "メディエイドα"
    @isTest
    static void onChildTypeChange_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','020','01','SEQ02',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','020','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','020','01','SEQ01','020');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[2];
        lifeCon.INSURANCE_TYPE__c='R30';
        update LifeCon;
        Test.stopTest();
        
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life.MediaidAlfaFlg__c);
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(Null,life1.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
    }
    
    // UPDATE pattern B verification child 保険種類(INSURANCE_TYPE_DISPLAY__c) Changed from ="メディエイドα"<> "メディエイドα"
    @isTest
    static void onChildTypeChangeDifferent_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','020','01','SEQ02',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','020','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','020');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[2];
        lifeCon.INSURANCE_TYPE__c='040';
        update LifeCon;
        Test.stopTest();
        
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals(Null,life.MediaidAlfaFlg__c);
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(Null,life1.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
    }
    
    // UPDATE pattern B verification parent and child 保険種類(INSURANCE_TYPE_DISPLAY__c) Changed from <>"メディエイドα"to  "メディエイドα"
    @isTest
    static void onAfterChildParentTypeUpdate_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeUpdateconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','020','01','SEQ02',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','120','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','030','01','SEQ01','100');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[2];
        Lifecontract__c lifeCon4=lifeconList[1];
        lifeCon.INSURANCE_TYPE__c='R30';
        lifeCon4.INSURANCE_TYPE__c='100';
        lifeUpdateconList.add(lifeCon);
        lifeUpdateconList.add(lifeCon4);
        update lifeUpdateconList;
        Test.stopTest();
        
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life.MediaidAlfaFlg__c);
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(Null,life1.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
    }
    
    // UPDATE pattern B verification parent and child 保険種類(INSURANCE_TYPE_DISPLAY__c) Changed from ="メディエイドα"<>  "メディエイドα"
    @isTest
    static void onAfterChildParentTypeUpdateDifferrent_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeUpdateconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','020','01','SEQ02',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','R30','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','R30');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[2];
        Lifecontract__c lifeCon4=lifeconList[1];
        lifeCon.INSURANCE_TYPE__c='030';
        lifeCon4.INSURANCE_TYPE__c='030';
        lifeUpdateconList.add(lifeCon);
        lifeUpdateconList.add(lifeCon4);
        update lifeUpdateconList;
        Test.stopTest();
        
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals(Null,life.MediaidAlfaFlg__c);
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(Null,life1.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
    }
    
    // UPDATE pattern C verification 本人会員識別SEQ番号 Changed to matching
    @isTest
    static void onAfterChildIdNumberUpdate_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','020','01','SEQ02',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','020','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','020');
        
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[2];
        LifeCon.IDENTIFICATION_NUM__c='SEQ02';
        update Lifecon;
        Test.stopTest();
        
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals('有',life.MediaidAlfaFlg__c);
        system.assertEquals(null,life1.MediaidAlfaFlg__c);
        system.assertEquals(null,life2.MediaidAlfaFlg__c);
    }
    
    //Update Pattern 'C'  verification  Matching 本人会員識別SEQ番号 
    @isTest
    static void onAfterChildSameIdNumberUpdate_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','020','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ02','020');
        
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[1];
        LifeCon.IDENTIFICATION_NUM__c='SEQ01';
        update Lifecon;
        Test.stopTest();
        
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life1.MediaidAlfaFlg__c);
        system.assertEquals(null,life2.MediaidAlfaFlg__c);
    }
    
    // UPDATE pattern C verification 本人会員識別SEQ番号 Changed to Not matching
    @isTest
    static void onAfterChildIdNumberUpdateDifferent_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','020','01','SEQ02',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','020','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','020');
        
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[2];
        LifeCon.IDENTIFICATION_NUM__c='SEQ06';
        update Lifecon;
        Test.stopTest();
        
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id]; 
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id]; 
        system.assertEquals(null,life1.MediaidAlfaFlg__c);
        system.assertEquals(null,life.MediaidAlfaFlg__c);
        system.assertEquals(null,life2.MediaidAlfaFlg__c);
    }
    
    // UPDATE pattern C Parent verification 本人会員識別SEQ番号 Changed to matching
    @isTest
    static void onAfterParentIdNumberUpdate_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','010','01','SEQ02','020');
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','R30','01','SEQ01','010');
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','R30');
        
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[1];
        LifeCon.IDENTIFICATION_NUM__c='SEQ02';
        update Lifecon;
        Test.stopTest();
        
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals('有',life1.MediaidAlfaFlg__c);
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals(null,life.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals('有',life2.MediaidAlfaFlg__c);
    }
    
    // UPDATE pattern C parent verification 本人会員識別SEQ番号 Changed to  Not matching
    @isTest
    static void onAfterParentIdNumberUpdateDiffferent_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','R30','01','SEQ02','120');
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','120','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','120');
        
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[1];
        LifeCon.IDENTIFICATION_NUM__c='SEQ05';
        update Lifecon;
        Test.stopTest();
        
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals(null,life1.MediaidAlfaFlg__c);
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(null,life.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals(null,life2.MediaidAlfaFlg__c);
    }
    
    // UPDATE pattern C  parent and Child verification 本人会員識別SEQ番号 Changed to matching
    @isTest
    static void onAfterChildParentIdNumberUpdate_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeUpdateconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','R30','01','SEQ02','110');
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','110','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','110');
        
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[2];
        Lifecontract__c lifeCon4=lifeconList[1];
        LifeCon.IDENTIFICATION_NUM__c='SEQ02';
        LifeCon4.IDENTIFICATION_NUM__c='SEQ02';
        lifeUpdateconList.add(LifeCon);
        lifeUpdateconList.add(LifeCon4);
        update lifeUpdateconList;
        Test.stopTest();
        
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(Null,life.MediaidAlfaFlg__c);
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life1.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
    }
    
    // UPDATE pattern C  parent and Child verification 本人会員識別SEQ番号 Changed to  Not matching
    @isTest
    static void onAfterChildParentIdNumberUpdateDifferent_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeUpdateconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','R30','01','SEQ02','020');
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','020','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','020');
        
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[2];
        Lifecontract__c lifeCon4=lifeconList[1];
        LifeCon.IDENTIFICATION_NUM__c='SEQ08';
        LifeCon4.IDENTIFICATION_NUM__c='SEQ07';
        lifeUpdateconList.add(LifeCon);
        lifeUpdateconList.add(LifeCon4);
        update lifeUpdateconList;
        Test.stopTest();
        
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals(null,life.MediaidAlfaFlg__c);
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals(null,life1.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(null,life2.MediaidAlfaFlg__c);
    }
    
    //UPDATE pattern 'D' Parent and Child are "メディエイドα" type
    @isTest
    static void onParentMediaAlphaTypeUpdate_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','R30','01','SEQ02','010');
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','120','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','R30');
        
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[1];
        LifeCon.INSURANCE_TYPE__c='R30';
        update Lifecon;
        Test.stopTest();
        
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life1.MediaidAlfaFlg__c);
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(Null,life.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals('有',life2.MediaidAlfaFlg__c);
    }
    
    //UPDATE pattern 'D' Parent and Child are "メディエイドα" type
    @isTest
    static void onChildMediaAlphaTypeUpdate_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','R30','01','SEQ02','010');
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','R30','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','110','01','SEQ01','R30');
        
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[2];
        LifeCon.INSURANCE_TYPE__c='R30';
        update Lifecon;
        Test.stopTest();
        
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life1.MediaidAlfaFlg__c);
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(Null,life.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals('有',life2.MediaidAlfaFlg__c);
    }
    
    //UPDATE pattern 'D' Parent and Child are "メディエイドα" type
    @isTest
    static void onParentChildMediaAlphaTypeUpdate_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeconupdateList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','R30','01','SEQ02','010');
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','120','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','100','01','SEQ01','R30');
        
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        
        Lifecontract__c lifeCon=lifeconList[1];
        Lifecontract__c lifeCon4=lifeconList[2];
        
        LifeCon.INSURANCE_TYPE__c='R30';
        LifeCon4.INSURANCE_TYPE__c='R30';
        lifeconupdateList.add(LifeCon);
        lifeconupdateList.add(LifeCon4);
        update lifeconupdateList;
        
        
        Test.stopTest();
        
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life1.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
        Lifecontract__c life3=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals('有',life3.MediaidAlfaFlg__c);
    }
    
    //UPDATE 'E'Many Parents for the same 本人会員識別SEQ番号
    @isTest
    static void ManyParentRecords_Process_MediaidAlfaFlg_Set() {
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeconupdateList = new List<lifecontract__c>();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','020','01','SEQ02',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','020','01','SEQ02',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保007','020','01','SEQ01',null);
        Lifecontract__c lifeCon3=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','020');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        lifeconList.add(lifeCon3);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[0];
        Lifecontract__c lifeCon4=lifeconList[1];
        lifeCon.IDENTIFICATION_NUM__c='SEQ01';
        lifeCon4.IDENTIFICATION_NUM__c='SEQ01';
        lifeconupdateList.add(lifeCon);
        lifeconupdateList.add(lifeCon4);
        update lifeconupdateList;
        Test.stopTest();
        Lifecontract__c life0=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals('有',life0.MediaidAlfaFlg__c);
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life1.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals('有',life2.MediaidAlfaFlg__c);
    }
    
    //UPDATE 'F'Pattern 本人会員識別SEQ番号 Changed otherLifeContracts Verification
    @isTest
    static void OtherParentRecordAvailable_Process_MediaidAlfaFlg_Set() {
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','R30','01','SEQ01','020');
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','R30','01','SEQ01','020');
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保007','020','01','SEQ01',null);
        Lifecontract__c lifeCon3=triggerTest.createLifeContractChildParent('生保008','020','01','SEQ02','120');
        Lifecontract__c lifeCon4=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','020');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        lifeconList.add(lifeCon3);
        lifeconList.add(lifeCon4);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[4];
        lifeCon.IDENTIFICATION_NUM__c='SEQ02';
        update LifeCon;
        Test.stopTest();
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals('有',life.MediaidAlfaFlg__c);
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[3].id];
        system.assertEquals('有',life1.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
        Lifecontract__c life3=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals(Null,life3.MediaidAlfaFlg__c);
        Lifecontract__c life4=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[4].id];
        system.assertEquals(Null,life4.MediaidAlfaFlg__c);
    }
    
    //UPDATE Pattern'G' 主契約保険種類 Changed to  matching
    @isTest
    static void onPARENT_POLcode_Change_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','020','01','SEQ02',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','010','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','110');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        Test.startTest();
        
        Lifecontract__c lifeCon=lifeconList[2];
        lifeCon.PARENT_POL_PROD_CODE__c='010';
        update LifeCon;
        Test.stopTest();
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life1.MediaidAlfaFlg__c);
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(Null,life.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
    }
    
    //UPDATE Pattern'G' 主契約保険種類 Changed to not matching
    @isTest
    static void onPARENT_POLcodeNotMatching_Change_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','020','01','SEQ02',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','010','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','110');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        Test.startTest();
        
        Lifecontract__c lifeCon=lifeconList[2];
        lifeCon.PARENT_POL_PROD_CODE__c='020';
        update LifeCon;
        Test.stopTest();
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals(null,life1.MediaidAlfaFlg__c);
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals(null,life.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals(null,life2.MediaidAlfaFlg__c);
    }
    
    //Linkage from GrandParent --> Parent --> Child
    @isTest
    static void GrandParentToParentToChild_Process_MediaidAlfaFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeconChildList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractChildParent('生保001','020','01','SEQ01','120');
        Lifecontract__c lifeCon1=triggerTest.createLifeContractChildParent('生保002','R30','01','SEQ01','020');
        Lifecontract__c lifeCon2=triggerTest.createLifeContractChildParent('生保004','R30','01','SEQ01','100');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        system.debug(lifecon2.MediaidAlfaFlg__c);
        Test.startTest();
        
        Lifecontract__c lifeCon=lifeconList[1];
        lifeCon.INSURANCE_TYPE__c='020';
        Lifecontract__c lifeCon4=lifeconList[2];
        lifeCon4.PARENT_POL_PROD_CODE__c='020';
        lifeconChildList.add(lifeCon);
        lifeconChildList.add(lifeCon4);
        update lifeconChildList;
        Test.stopTest();
        Lifecontract__c life1=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life1.MediaidAlfaFlg__c);
        Lifecontract__c life=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals('有',life.MediaidAlfaFlg__c);
        Lifecontract__c life2=[select id,MediaidAlfaFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals(Null,life2.MediaidAlfaFlg__c);
    }
    
    //Insert Pattern 'A' Verification Matching bothParentChild Insert 
    @isTest
    static void onAfterInsertChildParent_Process_JuniorFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        
        Test.startTest();
        Lifecontract__c life0=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ01',null);
        Lifecontract__c life1=triggerTest.createLifeContractJuniorFlg('生保007','020','01','SEQ06',null);
        Lifecontract__c life2=triggerTest.createLifeContractJuniorFlg('生保008','020','01','SEQ03','SEQ06');
        lifeconList.add(life0);
        lifeconList.add(life1);
        lifeconList.add(life2);
        insert LifeconList;
        Test.stopTest();
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:new list <Id> {life2.id}];
        Lifecontract__c life=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life.JuniorFlg__c);
        system.assertEquals(life1.Id,lifechild[0].JuniorContractFlg__c);
    }
    
    //Insert Pattern 'B' Verification Matching ParentFirst Insert
    @isTest
    static void onAfterInsertParentFirst_Process_JuniorFlg_Set() {
        List<Lifecontract__c> lifeconList1 = new List<lifecontract__c>();
        List<Lifecontract__c> lifeconParentList1 = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Account ac =  triggerTest.createAccount();
        insert ac;
        ac.seihoAccoutType__c='生保募集人';
        update ac;
        
        Test.startTest();
        Lifecontract__c life0=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ01',null);
        life0.accountId__c=ac.Id;
        Lifecontract__c life1=triggerTest.createLifeContractJuniorFlg('生保007','020','01','SEQ06',null);
        lifeconParentList1.add(life0);
        lifeconParentList1.add(life1);
        insert lifeconParentList1;
        
        Lifecontract__c life2=triggerTest.createLifeContractJuniorFlg('生保008','020','01','SEQ03','SEQ06');
        Lifecontract__c life3=triggerTest.createLifeContractJuniorFlg('生保004','020','01','SEQ04','SEQ06');
        lifeconList1.add(life2);
        lifeconList1.add(life3);
        //lifeconList1.add(life4);
        insert lifeconList1;
        Test.stopTest();
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:new list <Id> {life2.id,life3.id}];
        Lifecontract__c lifeparent=[select id,JuniorContractFlg__c,JuniorFlg__c from lifecontract__c where id=:life1.id];
        system.assertEquals('有',lifeparent.JuniorFlg__c);
        system.assertEquals(life1.Id,lifechild[0].JuniorContractFlg__c);
        system.assertEquals(life1.Id,lifechild[1].JuniorContractFlg__c);
    }
    
    //Insert Pattern 'B' Verification MatchingParentLater Insert
    @isTest
    static void onAfterInsertParentLater_Process_JuniorFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeconParentList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        
        Lifecontract__c life0=triggerTest.createLifeContractJuniorFlg('生保008','020','01','SEQ03','SEQ06');
        Lifecontract__c life1=triggerTest.createLifeContractJuniorFlg('生保004','020','01','SEQ04','SEQ06');
        lifeconList.add(life0);
        lifeconList.add(life1);
        //lifeconList.add(life2);
        insert lifeconList;
        Test.startTest();
        Lifecontract__c life3=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ01',null);
        Lifecontract__c life4=triggerTest.createLifeContractJuniorFlg('生保007','020','01','SEQ06',null);
        lifeconParentList.add(life3);
        lifeconParentList.add(life4);
        insert lifeconParentList;
        Test.stopTest();
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:new list <Id> {life0.id,life1.id}];
        Lifecontract__c life=[select id,JuniorContractFlg__c,JuniorFlg__c from lifecontract__c where id=:lifeconParentList[1].id];
        system.assertEquals('有',life.JuniorFlg__c);
        system.assertEquals(life4.Id,lifechild[0].JuniorContractFlg__c);
        system.assertEquals(life4.Id,lifechild[1].JuniorContractFlg__c);
    }
    // UPDATE pattern 'C' verfication  Jr特約主契約識別番号 Changed to matching
    @isTest
    static void onAfterChildIdNumberUpdate_Process_JuniorFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractJuniorFlg('生保001','020','01','SEQ04','SEQ02');
        Lifecontract__c lifeCon1=triggerTest.createLifeContractJuniorFlg('生保002','020','01','SEQ02',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractJuniorFlg('生保003','020','01','SEQ03','SEQ02');
        
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[2];
        LifeCon.JR_RIDER_SEQ_NUM__c='SEQ01';
        update Lifecon;
        Test.stopTest();
        
        Lifecontract__c life=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:lifeconList[0].id];
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:new list <Id> {lifeCon2.id}];
        Lifecontract__c life1=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:lifeconList[1].id];
        List<Lifecontract__c> lifechild1=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:new list <Id> {lifeCon2.id}];
        system.assertEquals(life1.Id,life.JuniorContractFlg__c);
        system.assertEquals(Null,lifechild[0].JuniorContractFlg__c);
        system.assertEquals('有',life1.JuniorFlg__c);
    }
    // UPDATE Pattern'C' Jr特約主契約識別番号 Changed to not matching
    @isTest
    static void onAfterChildIdNumberUpdateDifferent_Process_JuniorFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ01',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractJuniorFlg('生保002','020','01','SEQ02',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractJuniorFlg('生保003','020','01','SEQ03','SEQ02');
        
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[2];
        LifeCon.JR_RIDER_SEQ_NUM__c='SEQ05';
        update Lifecon;
        Test.stopTest();
        
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:lifeconList[0].id];
        Lifecontract__c life1=[select id,JuniorContractFlg__c,JuniorFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals(null,life1.JuniorFlg__c);
        system.assertEquals(Null,lifechild[0].JuniorContractFlg__c);
    }
    
    // UPDATE pattern C Parent verification 本人会員識別SEQ番号 Changed to matching
    @isTest
    static void onAfterParentIdNumberUpdate_Process_JuniorFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractJuniorFlg('生保001','020','01','SEQ06','SEQ02');
        Lifecontract__c lifeCon1=triggerTest.createLifeContractJuniorFlg('生保002','020','01','SEQ01','SEQ03');
        Lifecontract__c lifeCon2=triggerTest.createLifeContractJuniorFlg('生保003','020','01','SEQ03','SEQ01');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[1];
        LifeCon.IDENTIFICATION_NUM__c='SEQ02';
        update Lifecon;
        Test.stopTest();
        
        Lifecontract__c lifeparent1=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:lifeconList[1].id];
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:new list <Id> {lifeCon0.id}];
        Lifecontract__c lifeother=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:lifeconList[2].id];
        system.assertEquals('有',lifeparent1.JuniorFlg__c);
        system.assertEquals(lifeCon1.Id,lifechild[0].JuniorContractFlg__c);
    }
    
    // UPDATE pattern C parent verification 本人会員識別SEQ番号 Changed to  Not matching
    @isTest
    static void onAfterParentIdNumberUpdateDiffferent_Process_JuniorFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ01','SEQ06');
        Lifecontract__c lifeCon1=triggerTest.createLifeContractJuniorFlg('生保002','020','01','SEQ03','SEQ01');
        Lifecontract__c lifeCon2=triggerTest.createLifeContractJuniorFlg('生保003','020','01','SEQ04',null);
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[1];
        LifeCon.IDENTIFICATION_NUM__c='SEQ05';
        update Lifecon;
        Test.stopTest();
        
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:lifeconList[0].id];
        Lifecontract__c life1=[select id,JuniorContractFlg__c,JuniorFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals(null,life1.JuniorFlg__c);
        system.assertEquals(Null,lifechild[0].JuniorContractFlg__c);
    }
    // UPDATE  Child verification InsuranceType Changed to   matching
    @isTest
    static void onAfterChildTypeUpdate_Process_JuniorFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        
        Lifecontract__c lifeCon0=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ01',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractJuniorFlg('生保002','020','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractJuniorFlg('生保003','020','01','SEQ03','SEQ01');
        
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        
        Lifecontract__c lifeCon=lifeconList[2];
        
        
        LifeCon.INSURANCE_TYPE__c='010';
        
        update Lifecon;
        
        
        Test.stopTest();
        
        Lifecontract__c lifeparent=[select id,JuniorFlg__c from lifecontract__c where id=:lifeconList[1].id];
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:new list <Id> {lifeCon2.id}];
        system.assertEquals(Lifecon0.Id,lifechild[0].JuniorContractFlg__c);
        system.assertEquals(Null,lifeparent.JuniorFlg__c);
       
    }
    // UPDATE  Child verification InsuranceType Changed to  Not matching
    @isTest
    static void onAfterChildTypeUpdateDifferent_Process_JuniorFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        
        Lifecontract__c lifeCon0=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ01',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractJuniorFlg('生保002','020','01','SEQ01',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractJuniorFlg('生保003','020','01','SEQ03','SEQ01');
        
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        
        Lifecontract__c lifeCon=lifeconList[2];
        
        
        LifeCon.INSURANCE_TYPE__c='040';
        
        update Lifecon;
        
        
        Test.stopTest();
        
        Lifecontract__c lifeparent=[select id,JuniorFlg__c from lifecontract__c where id=:lifeconList[1].id];
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:new list <Id> {lifeCon2.id}];
        system.assertEquals(Null,lifechild[0].JuniorContractFlg__c);
        system.assertEquals(Null,lifeparent.JuniorFlg__c);
       
    }
    // UPDATE  Parent verification InsuranceType Changed to  matching
     @isTest
    static void onAfterParentTypeUpdate_Process_JuniorFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ04',Null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractJuniorFlg('生保002','010','01','SEQ03','SEQ04');
        Lifecontract__c lifeCon2=triggerTest.createLifeContractJuniorFlg('生保003','020','01','SEQ02','SEQ04');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        
        Lifecontract__c lifeCon=lifeconList[0];
        
        
        LifeCon.INSURANCE_TYPE__c='020';
        
        update Lifecon;
        
        
        Test.stopTest();
        
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:lifeconList[0].id];
        Lifecontract__c life1=[select id,JuniorContractFlg__c,JuniorFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals(null,life1.JuniorContractFlg__c);
        system.assertEquals('有',lifechild[0].JuniorFlg__c);
    }
    // UPDATE  Parent verification InsuranceType Changed to  Not matching
     @isTest
    static void onAfterParentTypeUpdateDifferent_Process_JuniorFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ04',Null);
        lifecon0.REGISTRATION_NUM__c='100';
        Lifecontract__c lifeCon1=triggerTest.createLifeContractJuniorFlg('生保002','010','01','SEQ03','SEQ04');
        Lifecontract__c lifeCon2=triggerTest.createLifeContractJuniorFlg('生保003','020','01','SEQ04',Null);
        lifecon2.REGISTRATION_NUM__c='600';
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        
        Lifecontract__c lifeCon=lifeconList[0];
        
        
        LifeCon.INSURANCE_TYPE__c='040';
        
        update Lifecon;
        
        
        Test.stopTest();
        
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:lifeconList[0].id];
        Lifecontract__c life1=[select id,JuniorContractFlg__c,JuniorFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals(null,life1.JuniorContractFlg__c);
        system.assertEquals(Null,lifechild[0].JuniorFlg__c);
    }
    //UPDATE  ParentChild verification InsuranceType Changed 
    @isTest
    static void onAfterChildParentTypeUpdate_Process_JuniorFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeconUpdateList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ04',Null);
        lifeCon0.REGISTRATION_NUM__c='200';
        Lifecontract__c lifeCon1=triggerTest.createLifeContractJuniorFlg('生保002','010','01','SEQ03','SEQ04');
        Lifecontract__c lifeCon2=triggerTest.createLifeContractJuniorFlg('生保003','020','01','SEQ04',Null);
        lifeCon2.REGISTRATION_NUM__c='400';
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        
        Lifecontract__c lifeCon=lifeconList[0];
        Lifecontract__c lifeCon4=lifeconList[1];
        
        LifeCon.INSURANCE_TYPE__c='020';
        LifeCon4.INSURANCE_TYPE__c='020';
        lifeconUpdateList.add(LifeCon);
        lifeconUpdateList.add(LifeCon4);
        update lifeconUpdateList;
        
        
        
        Test.stopTest(); 
        
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:lifeconList[0].id];
        Lifecontract__c life2=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:lifeconList[2].id];
        Lifecontract__c life1=[select id,JuniorContractFlg__c,JuniorFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals(lifechild[0].Id,life1.JuniorContractFlg__c);
        system.assertEquals('有',lifechild[0].JuniorFlg__c);
        system.assertEquals('有',life2.JuniorFlg__c);
    }
    // UPDATE pattern 'D' verification Child  Status Changed from 契約ステータス<>”有効” to 契約ステータス=”有効”
    @isTest
    static void onAfterChildStatusUpdate_Process_JuniorFlg_Set() {
        
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ01',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractJuniorFlg('生保002','020','01','SEQ02',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractJuniorFlg('生保003','020','05','SEQ03','SEQ02');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        Test.startTest();
        
        Lifecontract__c lifeCon=lifeconList[2];
        lifeCon.STATUS__c='01';
        update lifeCon;
        Test.stopTest();
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:lifeconList[2].id];
        Lifecontract__c life1=[select id,JuniorContractFlg__c,JuniorFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life1.JuniorFlg__c);
        system.assertEquals(lifeCon1.Id,lifechild[0].JuniorContractFlg__c);
    }
    
    // UPDATE pattern 'D' verification Parent Status Changed from 契約ステータス<>”有効” to 契約ステータス=”有効”
    @isTest
    static void onAfterparentStatusUpdate_Process_JuniorFlg_Set() {
        
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ01',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractJuniorFlg('生保002','020','05','SEQ02',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractJuniorFlg('生保003','020','01','SEQ03','SEQ02');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        Test.startTest();
        
        Lifecontract__c lifeCon=lifeconList[1];
        lifeCon.STATUS__c='01';
        update lifeCon;
        Test.stopTest();
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:lifeconList[2].id];
        Lifecontract__c life1=[select id,JuniorContractFlg__c,JuniorFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life1.JuniorFlg__c);
        system.assertEquals(life1.Id,lifechild[0].JuniorContractFlg__c);
    }
    
    // UPDATE pattern 'D' verification Parent and child Status Changed from 契約ステータス<>”有効” to 契約ステータス=”有効”
    @isTest
    static void onAfterChildParentStatusUpdate_Process_JuniorFlg_Set() {
        List<Lifecontract__c> lifeUpdateconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ01',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractJuniorFlg('生保002','020','05','SEQ02',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractJuniorFlg('生保003','020','05','SEQ03','SEQ01');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        Test.startTest();
        
        Lifecontract__c lifeCon=lifeconList[2];
        Lifecontract__c lifeCon4=lifeconList[1];
        lifeCon.STATUS__c='01';
        lifeCon4.STATUS__c='01';
        lifeCon.JR_RIDER_SEQ_NUM__c='SEQ02';
        lifeUpdateconList.add(lifeCon);
        lifeUpdateconList.add(lifeCon4);
        update lifeUpdateconList;
        Test.stopTest();
        Lifecontract__c lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:lifeconList[2].id];
        Lifecontract__c lifeparent=[select id,JuniorContractFlg__c,JuniorFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',lifeparent.JuniorFlg__c);
        system.assertEquals(lifeparent.Id,lifechild.JuniorContractFlg__c);
    }
    
    // UPDATE pattern 'D' verification Child Status Changed from 契約ステータス=”有効”to 契約ステータス<>”有効”
    @isTest
    static void onAfterChildStatusUpdatetoDifferent_Process_JuniorFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ01',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractJuniorFlg('生保002','020','01','SEQ02',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractJuniorFlg('生保003','020','01','SEQ03','SEQ02');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[2];
        lifeCon.STATUS__c='05';
        update lifeCon;
        Test.stopTest();
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:lifeconList[2].id];
        Lifecontract__c lifeparent=[select id,JuniorContractFlg__c,JuniorFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',lifeparent.JuniorFlg__c);
        system.assertEquals(lifeparent.Id,lifechild[0].JuniorContractFlg__c);
    }
    
    // UPDATE pattern 'D' verification Status Changed from 契約ステータス =”有効” to  契約ステータス <>”有効”
    @isTest
    static void onAfterParentStatusUpdateDifferent_Process_JuniorFlg_Set() {
        
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ01',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractJuniorFlg('生保002','020','01','SEQ05',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractJuniorFlg('生保003','020','01','SEQ03','SEQ05');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        Test.startTest();
        
        Lifecontract__c lifeCon=lifeconList[1];
        lifeCon.STATUS__c='05';
        update lifeCon;
        Test.stopTest();
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:new list <Id> {lifeCon2.id}];
        Lifecontract__c life=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',life.JuniorFlg__c);
        system.assertEquals(Null,lifechild[0].JuniorContractFlg__c);
    }
    
    // UPDATE pattern 'D' verification Parent and child  Status Changed from 契約ステータス=”有効”to 契約ステータス<>”有効”
    @isTest
    static void onAfterChildParentStatusUpdatetoDifferent_Process_JuniorFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeUpdateconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ01',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractJuniorFlg('生保002','020','01','SEQ06',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractJuniorFlg('生保003','020','01','SEQ08','SEQ06');
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        Test.startTest();
        Lifecontract__c lifeCon4=lifeconList[1];
        Lifecontract__c lifeCon=lifeconList[2];
        lifeCon4.STATUS__c='05';
        lifeCon.STATUS__c='05';
        lifeUpdateconList.add(lifeCon4);
        lifeUpdateconList.add(lifeCon);
        update lifeUpdateconList;
        Test.stopTest();
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:lifeconList[0].id];
        Lifecontract__c lifeparent=[select id,JuniorContractFlg__c,JuniorFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals('有',lifeparent.JuniorFlg__c);
        system.assertEquals(Null,lifechild[0].JuniorContractFlg__c);
    }
    
    // UPDATE pattern 'E' verfication  Jr特約主契約識別番号 Changed to matching
    @isTest
    static void onAfterChildIdNumberUpdate_Process_JuniorFlgSet() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ01',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractJuniorFlg('生保002','020','01','SEQ02',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractJuniorFlg('生保003','020','01','SEQ03','SEQ02');
        
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[2];
        LifeCon.JR_RIDER_SEQ_NUM__c='SEQ01';
        update Lifecon;
        Test.stopTest();
        
        Lifecontract__c life=[select id,JuniorFlg__c from lifecontract__c where id=:lifeconList[0].id];
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:new list <Id> {lifeCon2.id}];
        Lifecontract__c life1=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:lifeconList[1].id];
        List<Lifecontract__c> lifechild1=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:new list <Id> {lifeCon2.id}];
        system.assertEquals(NULL,life.JuniorFlg__c);
        system.assertEquals(NULL,lifechild[0].JuniorContractFlg__c);
        system.assertEquals(NULL,life1.JuniorFlg__c);
    }
    
    // UPDATE Pattern'E' Jr特約主契約識別番号 Changed to not matching
    @isTest
    static void onAfterChildIdNumberUpdated_Process_JuniorFlg_Set() {
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Lifecontract__c lifeCon0=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ01',null);
        Lifecontract__c lifeCon1=triggerTest.createLifeContractJuniorFlg('生保002','020','01','SEQ02',null);
        Lifecontract__c lifeCon2=triggerTest.createLifeContractJuniorFlg('生保003','020','01','SEQ03','SEQ02');
        
        lifeconList.add(lifeCon0);
        lifeconList.add(lifeCon1);
        lifeconList.add(lifeCon2);
        insert  lifeconList;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[2];
        LifeCon.JR_RIDER_SEQ_NUM__c='SEQ05';
        update Lifecon;
        Test.stopTest();
        
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:lifeconList[0].id];
        Lifecontract__c life1=[select id,JuniorContractFlg__c,JuniorFlg__c from lifecontract__c where id=:lifeconList[1].id];
        system.assertEquals(null,life1.JuniorFlg__c);
        system.assertEquals(Null,lifechild[0].JuniorContractFlg__c);
    }
    
    // Multiple ParentChild Link   while Inserting
    @isTest
    static void ManyParentRecords_Process_JuniorFlg_Set_Insert() {
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeconupdateList = new List<lifecontract__c>();
        Lifecontract__c lifeconList0=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ01',null);
        lifeconList0.REGISTRATION_NUM__c='100';
        Lifecontract__c lifeconList1=triggerTest.createLifeContractJuniorFlg('生保007','020','01','SEQ01',null);
        lifeconList1.REGISTRATION_NUM__c='400';
        Lifecontract__c lifeconList2=triggerTest.createLifeContractJuniorFlg('生保008','020','01','SEQ01',null);
        lifeconList2.REGISTRATION_NUM__c='300';
        Lifecontract__c lifeconList3=triggerTest.createLifeContractJuniorFlg('生保004','020','01','SEQ04','SEQ01');
        lifeconList3.REGISTRATION_NUM__c='100';
        Test.startTest();
        insert  lifeconList0;
        insert  lifeconList1;
        insert  lifeconList2;
        insert  lifeconList3;
        Test.stopTest();
        
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:new list <Id> {lifeconList3.id}];
        Lifecontract__c lifeparent=[select id,JuniorFlg__c from lifecontract__c where id=:lifeconList2.id];
        system.assertEquals('有',lifeparent.JuniorFlg__c);
        system.assertEquals(lifeparent.Id,lifechild[0].JuniorContractFlg__c);
        
    }
    
    // Multiple ParentChild Link   while updating Status
    static void ManyParentRecords_Process_JuniorFlg_Set_UpdSts() {
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeconupdateList = new List<lifecontract__c>();
        Lifecontract__c lifeconList0=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ01',null);
        lifeconList0.REGISTRATION_NUM__c='100';
        Lifecontract__c lifeconList1=triggerTest.createLifeContractJuniorFlg('生保007','020','01','SEQ01',null);
        lifeconList1.REGISTRATION_NUM__c='200';
        Lifecontract__c lifeconList2=triggerTest.createLifeContractJuniorFlg('生保008','020','01','SEQ01',null);
        lifeconList2.REGISTRATION_NUM__c='400';
        Lifecontract__c lifeconList3=triggerTest.createLifeContractJuniorFlg('生保004','020','01','SEQ04','SEQ01');
        lifeconList3.REGISTRATION_NUM__c='300';
        insert  lifeconList0;
        insert  lifeconList1;
        insert  lifeconList2;
        insert  lifeconList3;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList0;
        lifeCon.Status__c='05';
        lifeconupdateList.add(lifeCon);
        //lifeconupdateList.add(lifeCon4);
        update lifeconupdateList;
        Test.stopTest();
        
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:new list <Id> {lifeconList3.id}];
        Lifecontract__c lifeparent=[select id,JuniorFlg__c from lifecontract__c where id=:lifeconList1.id];
        system.assertEquals('有',lifeparent.JuniorFlg__c);
        system.assertEquals(lifeparent.Id,lifechild[0].JuniorContractFlg__c);
    }
    
    // Multiple ParentChild Link   while updating Identification no
    static void ManyParentRecords_Process_JuniorFlg_Set_UpdIdentfNo() {
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeconupdateList = new List<lifecontract__c>();
        Lifecontract__c lifeconList0=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ03',null);
        lifeconList0.REGISTRATION_NUM__c='100';
        Lifecontract__c lifeconList1=triggerTest.createLifeContractJuniorFlg('生保007','020','01','SEQ06',null);
        lifeconList1.REGISTRATION_NUM__c='400';
        Lifecontract__c lifeconList2=triggerTest.createLifeContractJuniorFlg('生保008','020','01','SEQ01',null);
        lifeconList2.REGISTRATION_NUM__c='300';
        Lifecontract__c lifeconList3=triggerTest.createLifeContractJuniorFlg('生保004','020','01','SEQ04','SEQ01');
        lifeconList3.REGISTRATION_NUM__c='200';
        insert  lifeconList2;
        insert  lifeconList0;
        insert  lifeconList1;
        insert  lifeconList3;
        
        Test.startTest();
        Lifecontract__c lifeCon=lifeconList[0];
        Lifecontract__c lifeCon4=lifeconList[1];
        lifeCon.IDENTIFICATION_NUM__c='SEQ01';
        lifeCon4.IDENTIFICATION_NUM__c='SEQ01';
        lifeconupdateList.add(lifeCon);
        lifeconupdateList.add(lifeCon4);
        update lifeconupdateList;
        Test.stopTest();
        
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:new list <Id> {lifeconList3.id}];
        Lifecontract__c lifeparent=[select id,JuniorFlg__c from lifecontract__c where id=:lifeconList0.id];
        system.assertEquals('有',lifeparent.JuniorFlg__c);
        system.assertEquals(lifeparent.Id,lifechild[0].JuniorContractFlg__c);
    }
    
    //UPDATE 'F' Many childs for the same 本人会員識別SEQ番号
    @isTest
    static void ManyChildRecords_Process_JuniorFlg_Set() {
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        List<Lifecontract__c> lifeconList = new List<lifecontract__c>();
        List<Lifecontract__c> lifeconupdateList = new List<lifecontract__c>();
        Test.startTest();
        Lifecontract__c lifeconList0=triggerTest.createLifeContractJuniorFlg('生保001','010','01','SEQ01',null);
        Lifecontract__c lifeconList1=triggerTest.createLifeContractJuniorFlg('生保007','010','01','SEQ06','SEQ01');
        Lifecontract__c lifeconList2=triggerTest.createLifeContractJuniorFlg('生保008','010','01','SEQ03','SEQ01');
        Lifecontract__c lifeconList3=triggerTest.createLifeContractJuniorFlg('生保004','010','05','SEQ04','SEQ01');
        lifeconList.add(lifeconList0);
        lifeconList.add(lifeconList1);
        lifeconList.add(lifeconList2);
        lifeconList.add(lifeconList3);
        insert  lifeconList;
        
        Test.stopTest();
        List<Lifecontract__c> lifechild=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:new list <Id> {lifeconList1.id,lifeconList2.id,lifeconList1.id}];
        Lifecontract__c life=[select id,JuniorFlg__c,JuniorContractFlg__c from lifecontract__c where id=:lifeconList[0].id];
        system.assertEquals('有',life.JuniorFlg__c);
        system.assertEquals(life.Id,lifechild[0].JuniorContractFlg__c);
        system.assertEquals(life.Id,lifechild[1].JuniorContractFlg__c);
    }
    
    
    private LifeContract__c createLifeContractJuniorFlg(string Pollno,string Insurance,string status,string Id,String SEQ_NUM){
        
        LifeContract__c lifeCon=new LifeContract__c();
        lifeCon.Name = 'Test Life Contract_001';
        lifeCon.POL_NUM__c = Pollno;
        lifeCon.INSURANCE_TYPE__c=Insurance;
        lifeCon.status__c=status;
        lifeCon.IDENTIFICATION_NUM__c=Id;
        lifeCon.JR_RIDER_SEQ_NUM__c=SEQ_NUM;
        return lifeCon;
        
    }
    
    
    @isTest
    static void onAfterProcess_name_kana_changed() {
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        LifeContractTriggerHandler handler = new LifeContractTriggerHandler();
        
        Account ac =  triggerTest.createAccount();
        insert ac;
        
        LifeContract__c lc = new LifeContract__c();
        lc.KANA_CONTROR_NAME__c = 'ラクテン　セイホイチロウ';
        lc.CONTROR_GENDER__c = '男';
        lc.CONTROR_BIRTH_DATE__c = '1900/01/01';
        lc.AccountId__c = ac.Id;
        insert lc;
        
        Test.startTest();
        lc.KANA_CONTROR_NAME__c = 'ラクテン　セイホジロウ';
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
    static void onAfterProcess_gender_changed() {
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();                    
        LifeContractTriggerHandler handler = new LifeContractTriggerHandler();
        
        Account ac =  triggerTest.createAccount();
        insert ac;
        
        LifeContract__c lc = new LifeContract__c();
        lc.KANA_CONTROR_NAME__c = 'ラクテン　セイホイチロウ';
        lc.CONTROR_GENDER__c = '男';
        lc.CONTROR_BIRTH_DATE__c = '1900/01/01';
        lc.AccountId__c = ac.Id;
        insert lc;
        
        Test.startTest();
        lc.CONTROR_GENDER__c = '女';
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
    static void onAfterProcess_birthdate_changed() {
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();                    
        LifeContractTriggerHandler handler = new LifeContractTriggerHandler();
        
        Account ac =  triggerTest.createAccount();
        insert ac;
        
        LifeContract__c lc = new LifeContract__c();
        lc.KANA_CONTROR_NAME__c = 'ラクテン　セイホイチロウ';
        lc.CONTROR_GENDER__c = '男';
        lc.CONTROR_BIRTH_DATE__c = '1900/01/01';
        lc.AccountId__c = ac.Id;
        insert lc;
        
        Test.startTest();
        lc.CONTROR_BIRTH_DATE__c = '1999/01/01';
        update lc;
        Test.stopTest();
        
        Account result = triggerTest.getAccountById(lc.AccountId__c);
        system.assertEquals(false, result.nameChangedFlag__c);
        system.assertEquals(false, result.genderChangedFlag__c);
        system.assertEquals(false, result.birthdateChangedFlag__c);
    }
    
    @isTest
    //カード会社マス、募集人マスタ、エージェントマスタとの紐付け処理(新規作成)
    static void createMasterReference(){
        
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Test.startTest();
        List<SeihoCcCompanyMaster__c> seihoCcList = triggerTest.createCompanyMaster();
        List<SeihoRecruiterMaster__c> seihoRecruitList = triggerTest.createRecruiterMaster();
        List<SeihoAgentMaster__c> seihoAgentList = triggerTest.createAgentMaster();
        System.debug('card compantny ' + seihoCcList);
        System.debug('recruit compantny ' + seihoRecruitList);
        System.debug('agent compantny ' + seihoAgentList);
        LifeContract__c life = triggerTest.createLifeContract(
                                                seihoCcList.get(0).CARD_COMPANY_CODE__c, 
                                                seihoRecruitList.get(0).RECRUITER_NUMBER__c, 
                                                seihoAgentList.get(0).MEMBER_ID_SEQ__c);
        insert life;
        Test.stopTest();
        
        System.debug('life Id ' + life.Id);
        
        LifeContract__c newLife = [SELECT ID, COMPANY_NAME__c, SEIHO_RECRUITER_NAME__c, AGENT_NAME__c FROM LifeContract__c where Id =: life.Id LIMIT 1];
        System.debug('newLife comp ' + newLife.COMPANY_NAME__c);
        System.debug('newLife comp ' + newLife.SEIHO_RECRUITER_NAME__c);
        System.debug('newLife comp ' + newLife.AGENT_NAME__c);
        System.assertEquals(seihoCcList.get(0).Id, newLife.COMPANY_NAME__c);
        System.assertEquals(seihoRecruitList.get(0).Id, newLife.SEIHO_RECRUITER_NAME__c);
        System.assertEquals(seihoAgentList.get(0).Id, newLife.AGENT_NAME__c);
    }
    
    @isTest
    //カード会社マス、募集人マスタ、エージェントマスタとの紐付け処理(更新)
    static void updateMasterReference(){
        
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Test.startTest();
        List<SeihoCcCompanyMaster__c> seihoCcList = triggerTest.createCompanyMaster();
        List<SeihoRecruiterMaster__c> seihoRecruitList = triggerTest.createRecruiterMaster();
        List<SeihoAgentMaster__c> seihoAgentList = triggerTest.createAgentMaster();
        LifeContract__c life = triggerTest.createLifeContract(
                                                        seihoCcList.get(0).CARD_COMPANY_CODE__c, 
                                                        seihoRecruitList.get(0).RECRUITER_NUMBER__c, 
                                                        seihoAgentList.get(0).MEMBER_ID_SEQ__c);
        insert life;
        life.COMPANY_CODE__c = seihoCcList.get(1).CARD_COMPANY_CODE__c;
        life.RECRUITER_NUM__c = seihoRecruitList.get(1).RECRUITER_NUMBER__c;
        life.HANDLING_AGENT__c = seihoAgentList.get(1).MEMBER_ID_SEQ__c;
        update life;
        Test.stopTest();
        
        LifeContract__c updateLife = [SELECT ID, COMPANY_NAME__c, SEIHO_RECRUITER_NAME__c, AGENT_NAME__c FROM LifeContract__c where Id =: life.Id LIMIT 1];
        System.assertEquals(seihoCcList.get(1).Id, updateLife.COMPANY_NAME__c);
        System.assertEquals(seihoRecruitList.get(1).Id, updateLife.SEIHO_RECRUITER_NAME__c);
        System.assertEquals(seihoAgentList.get(1).Id, updateLife.AGENT_NAME__c);
    }
    
    @isTest
    //カード会社マス、募集人マスタ、エージェントマスタとの紐付け処理(最初に値がセットされた場合)
    static void updateMasterReferenceFirstTime(){
        
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Test.startTest();
        List<SeihoCcCompanyMaster__c> seihoCcList = triggerTest.createCompanyMaster();
        List<SeihoRecruiterMaster__c> seihoRecruitList = triggerTest.createRecruiterMaster();
        List<SeihoAgentMaster__c> seihoAgentList = triggerTest.createAgentMaster();
        LifeContract__c life = triggerTest.createLifeContract('', '', '');
        insert life;
        life.COMPANY_CODE__c = seihoCcList.get(1).CARD_COMPANY_CODE__c;
        life.RECRUITER_NUM__c = seihoRecruitList.get(1).RECRUITER_NUMBER__c;
        life.HANDLING_AGENT__c = seihoAgentList.get(1).MEMBER_ID_SEQ__c;
        update life;
        Test.stopTest();
        
        LifeContract__c updateLife = [SELECT ID, COMPANY_NAME__c, SEIHO_RECRUITER_NAME__c, AGENT_NAME__c FROM LifeContract__c where Id =: life.Id LIMIT 1];
        System.assertEquals(seihoCcList.get(1).Id, updateLife.COMPANY_NAME__c);
        System.assertEquals(seihoRecruitList.get(1).Id, updateLife.SEIHO_RECRUITER_NAME__c);
        System.assertEquals(seihoAgentList.get(1).Id, updateLife.AGENT_NAME__c);
    }
    
    @isTest
    //カード会社マス、募集人マスタ、エージェントマスタとの紐付け処理(マスタに存在しない)
    static void noMasterReference(){
        
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Test.startTest();
        List<SeihoCcCompanyMaster__c> seihoCcList = triggerTest.createCompanyMaster();
        List<SeihoRecruiterMaster__c> seihoRecruitList = triggerTest.createRecruiterMaster();
        List<SeihoAgentMaster__c> seihoAgentList = triggerTest.createAgentMaster();
        LifeContract__c life = triggerTest.createLifeContract('abc', 'abc', 'abc');
        insert life;
        Test.stopTest();
        
        LifeContract__c updateLife = [SELECT ID, COMPANY_NAME__c, SEIHO_RECRUITER_NAME__c, AGENT_NAME__c FROM LifeContract__c where Id =: life.Id LIMIT 1];
        System.assertEquals(null, updateLife.COMPANY_NAME__c);
        System.assertEquals(null, updateLife.SEIHO_RECRUITER_NAME__c);
        System.assertEquals(null, updateLife.AGENT_NAME__c);
    }
    
    @isTest
    //カード会社マス、募集人マスタ、エージェントマスタとの非紐付け処理
    static void delinkMasterReference(){
        
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Test.startTest();
        List<SeihoCcCompanyMaster__c> seihoCcList = triggerTest.createCompanyMaster();
        List<SeihoRecruiterMaster__c> seihoRecruitList = triggerTest.createRecruiterMaster();
        List<SeihoAgentMaster__c> seihoAgentList = triggerTest.createAgentMaster();
        LifeContract__c life = triggerTest.createLifeContract(
                                                        seihoCcList.get(0).CARD_COMPANY_CODE__c, 
                                                        seihoRecruitList.get(0).RECRUITER_NUMBER__c, 
                                                        seihoAgentList.get(0).MEMBER_ID_SEQ__c);
        insert life;
        life.COMPANY_CODE__c = '';
        life.RECRUITER_NUM__c = '';
        life.HANDLING_AGENT__c = '';
        update life;
        Test.stopTest();
        
        LifeContract__c updateLife = [SELECT ID, COMPANY_NAME__c, SEIHO_RECRUITER_NAME__c, AGENT_NAME__c FROM LifeContract__c where Id =: life.Id LIMIT 1];
        System.assertEquals(null, updateLife.COMPANY_NAME__c);
        System.assertEquals(null, updateLife.SEIHO_RECRUITER_NAME__c);
        System.assertEquals(null, updateLife.AGENT_NAME__c);
    }
    
    @isTest
    // 生保契約を新規に登録する時、IDに保険種類の名称をセットする
    static void setInsuranceTypeInsert() {
        
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Account account =  triggerTest.createAccount();
        insert account;
        
        Test.startTest();
        LifeContract__c lc = new LifeContract__c();
        lc.KANA_CONTROR_NAME__c = 'ラクテン　セイホイチロウ';
        lc.AccountId__c = account.Id;
        lc.INSURANCE_TYPE__c = '080';
        insert lc;
        Test.stopTest();
        
        LifeContract__c result = [SELECT Id, Name FROM LifeContract__c];
        System.assertEquals('医療保険', result.Name);
    }
    
    @isTest
    // 生保契約の保険種類コードは変更せず更新をかけるとき、IDは変わらない
    static void setInsranceTypeNotChangeUpdate() {
        
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Account account = triggerTest.createAccount();
        insert account;
        
        LifeContract__c lc = new LifeContract__c();
        lc.KANA_CONTROR_NAME__c = 'ラクテン　セイホイチロウ';
        lc.AccountId__c = account.Id;
        lc.INSURANCE_TYPE__c = '080';
        lc.Name = '医療保険';
        insert lc;
        
        Test.startTest();
        lc.KANA_CONTROR_NAME__c = 'ラクテン　セイホニロウ';
        update lc;
        Test.stopTest();
        
        LifeContract__c result = [SELECT Id, Name, KANA_CONTROR_NAME__c FROM LifeContract__c];
        System.assertEquals('ラクテン　セイホニロウ', result.KANA_CONTROR_NAME__c);
        System.assertEquals('医療保険', result.Name);
    }
    
    @isTest
    // 生保契約の保険種類コードを変更して更新をかけるとき、IDに保険種類の名称をセットする
    static void setInsranceTypeChangeUpdate() {
        
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        Account account = triggerTest.createAccount();
        insert account;
        
        LifeContract__c lc = new LifeContract__c();
        lc.KANA_CONTROR_NAME__c = 'ラクテン　セイホイチロウ';
        lc.AccountId__c = account.Id;
        lc.INSURANCE_TYPE__c = '080';
        lc.Name = '医療保険';
        insert lc;
        
        Test.startTest();
        lc.INSURANCE_TYPE__c = '060';
        update lc;
        Test.stopTest();
        
        LifeContract__c result = [SELECT Id, Name FROM LifeContract__c];
        System.assertEquals('定期保険', result.Name);
    }
    @isTest
    static void LifeContractTriggerTest_IsAfter()
    {
        LifeContractTriggerTest triggerTest = new LifeContractTriggerTest();
        insert  triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        insert triggerTest.createAccount();
        List<Account> accList = [SELECT Id FROM Account];
        
        SeihoAgencyMaster__c sam = new SeihoAgencyMaster__c();
        sam.agncyno__c = '789789';
        insert sam;
        
        Test.startTest();
        LifeContract__c life = triggerTest.createLifeContract(account.Id);
        insert life;
        Test.stopTest();
        
        LifeContract__c updateLife = [SELECT ID FROM LifeContract__c where Id =: life.Id LIMIT 1];
        updateLife.AccountId__c =accList[1].id;
        update updateLife;
        
        System.assertNotEquals(account.id , updateLife.AccountId__c);
        System.assertEquals(null , updateLife.Opportunity__c);
        
    }
    
    
    private account createAccount(){
        List<RecordType> recordTypes = [SELECT Id, Name 
                                        FROM   RecordType 
                                        WHERE  SobjectType = 'Account' 
                                        And    Name = '個人取引先' 
                                        ORDER BY Name ASC LIMIT 50];
        return new Account(LastName='個人',FirstName='取引先',RecordTypeId=recordTypes[0].Id);
    }
    
    private LifeContract__c createLifeContract(Id accountId){
        return new LifeContract__c(
            Name = 'test name',
            AGENCY_NUM__c='789789',
            POL_NUM__c = '1234567',
            PRODUCT_NAME__c = 'test product name',
            KANJI_CONTROR_NAME__c = '楽天　一郎',
            INSR_PERIOD__c = 'term',
            REFERRAL_AGENCY_NUM__c = '789789',
            CONTRACT_DATE__c = '20190523',
            KANJI_INSURED_NAME__c = '楽天　一郎',
            Phone__c = '111-2222-3333',
            BENE_AMOUNT__c = '3000000',
            MONTHLY_PRM__c = '2000',
            Status__c = '01',
            KANA_CONTROR_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ',
            BENEFIT_RECIPIENT__c = '楽天　二郎',
            AccountId__c = accountId,
            APPLICATION_NUM__c = '12345'
        );
    }
    
    private LifeContract__c createLifeContract(String companyCode, String recruitNo, String handlingAg){
        
        return new LifeContract__c(
            Name = 'Test Life Contract_001',
            POL_NUM__c = '123450',
            COMPANY_CODE__c = companyCode,
            RECRUITER_NUM__c = recruitNo,
            HANDLING_AGENT__c = handlingAg
        );
    }
    
    private LifeContract__c createLifeContractChildParent(string Pollno,string Insurance,string status,string Id,String PARENT_POL){
        
        LifeContract__c lifeCon=new LifeContract__c();
        lifeCon.Name = 'Test Life Contract_001';
        lifeCon.POL_NUM__c = Pollno;
        lifeCon.INSURANCE_TYPE__c=Insurance;
        lifeCon.status__c=status;
        lifeCon.IDENTIFICATION_NUM__c=Id;
        lifeCon.PARENT_POL_PROD_CODE__c=PARENT_POL;
        return lifeCon;
        
    }
    
    private List<SeihoCcCompanyMaster__c> createCompanyMaster(){
        List<SeihoCcCompanyMaster__c> seihoCcList = new List<SeihoCcCompanyMaster__c>();
        for(Integer i=1;i<=2;i++){
            seihoCcList.add(new SeihoCcCompanyMaster__c(
                Name = 'Test Company Master_00' + i ,
                CARD_COMPANY_CODE__c = 'Code_00' + i,
                CARD_COMPANY_NAME__c = 'CompanyName_00' + i    
            ));
        }
        insert seihoCcList;
        return seihoCcList;
    }
    
    private List<SeihoRecruiterMaster__c> createRecruiterMaster(){
        List<SeihoRecruiterMaster__c> seihoRecruitList = new List<SeihoRecruiterMaster__c>();
        for(Integer i=1;i<=2;i++){
            seihoRecruitList.add(new SeihoRecruiterMaster__c(
                Name = 'Test Recruiter Master_00' + i,
                RECRUITER_NUMBER__c = 'Recruit_00' + i,
                KANJI_NAME__c = 'RecruiterName_00' + i
            ));
        } 
        insert seihoRecruitList;
        return seihoRecruitList;
    }
    
    private List<SeihoAgentMaster__c> createAgentMaster(){
        List<SeihoAgentMaster__c> seihoAgentList = new List<SeihoAgentMaster__c>();
        for(Integer i=1;i<=2;i++){
            seihoAgentList.add(new SeihoAgentMaster__c(
                Name = 'Test Agent Master_00' + i,
                MEMBER_ID_SEQ__c = 'AgentNo_00' + i,
                KANJI_AGENT_NAME__c = 'AgentName_00' + i
            ));
        }
        insert seihoAgentList;
        return seihoAgentList;
    }
    
    private Account getAccountById(Id id){
        return [SELECT Id, Name, nameChangedFlag__c, genderChangedFlag__c, birthdateChangedFlag__c ,
                LifeUse__pc,SeihoOppApplyflg__c
                FROM   Account 
                WHERE  Id =: id];
    }
    
    private LifeContract__c getLifeContractId(Id id){
        return [Select id,AGENCY__c,REFERRAL_AGENCY__c,COMPANY_NAME__c,SEIHO_RECRUITER_NAME__c,
                AGENT_NAME__c,AgencyId__c,Opportunity__c
                from LifeContract__c where id =: id];
    }
    
}