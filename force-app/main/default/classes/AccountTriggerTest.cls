@isTest
public class AccountTriggerTest
{
    @isTest
    static void testAccountTriggerTest()
    {
        AccountTriggerTest triggerTest = new AccountTriggerTest();
        
        Test.startTest();
        Account acct = triggerTest.createAccount();
        acct.HanshaList__c = '疑いなし';
        acct.CSID__pc='ACC001';
        insert acct;
        Test.stopTest();
        
        Account acc = triggerTest.getAccountById(acct.Id);
        System.assertEquals(acc.SYSAccountName__c,acc.LastName__pc+acc.firstname__pc+acc.furiganaLast__pc+acc.furiganaForst__pc);
        System.assertNotEquals(acc.HanshaUserUpdateDate__c,null);
        System.assertEquals(acc.OperationType__c,'架電禁止');
        
    }
    @isTest
    static void testAccountFuriganaTest()
    {
        
        
        AccountTriggerTest triggerTest = new AccountTriggerTest();
        
        Test.startTest();
        Account acct = triggerTest.createAccount();
        acct.HanshaList__c = '疑いなし';
        acct.CSID__pc='ACC001';
        insert acct;
        
        String acc = AccountHelper.getAccFurigana(acct.Id);
        
        Test.stopTest();
        
        
        System.assertEquals(acc,acct.furiganaLast__pc+acct.furiganaForst__pc);
        
        
    }
    
    
    
    
    
    @isTest
    static void testAccountTriggerTest_Name_Blank()
    {
        
        AccountTriggerTest triggerTest = new AccountTriggerTest();
        Account acc = triggerTest.createAccount();
        acc.LastName__pc = '';
        acc.firstname__pc = '';
        acc.HanshaSystemUpdateDate__c = System.Now().addHours(-2);  
        acc.OpportunityStatus__c = null;
        acc.PersonMobilePhone  = '88-8888-8888';
        //acc.HANSHA_FLG__pc = '疑いあり';
        acc.HanshaList__c = '未選択';
        insert acc;
        
        Opportunity opp = triggerTest.createOpportunity(acc.id);
        insert opp;
        
        Test.startTest();
        insert triggerTest.createHanshaInfo();
        
        Account accUpt = new Account();
        accUpt.id = acc.id;
        accUpt.OpportunityStatus__c = '全商談終了';
        accUpt.PersonMobilePhone  = '88-8888-8888';
        accUpt.HanshaSystemUpdateDate__c = System.Now();
        accUpt.PersonBirthdate = date.parse('1985/02/01');
        accUpt.HanshaList__c = '疑いなし';
        update accUpt;
        
        /*Opportunity opp2 = triggerTest.createOpportunity(accUpt.id);
insert opp2;*/
        
        Test.stopTest();
        
        Account acct = triggerTest.getAccountById(accUpt.Id);
        /*Opportunity oppt2 = triggerTest.getOpportunityById(opp2.Id);
System.assertEquals(acct.OpportunityStatus__c,'生保フォロー中');
System.assertEquals(oppt2.StageName,'未対応');*/
        Opportunity oppt1 = triggerTest.getOpportunityById(opp.Id);
        System.assertEquals(oppt1.RecentProbability__c,'申込なし');
        System.assertEquals(oppt1.CloseReason__c,'取引先対応終了'); 
        System.assertEquals(oppt1.CloseDate,System.Today());
    }
    @isTest
    static void testAccountTriggerTest_BirthDate()
    {
        AccountTriggerTest triggerTest = new AccountTriggerTest();
        
        Test.startTest();
        
        HanshaInfo__c han = triggerTest.createHanshaInfo();
        han.AssumeBirthdate__c = system.today();
        insert han;
        
        Account acct = triggerTest.createAccount();
        acct.HanshaList__c = '疑いなし';
        acct.PersonBirthdate = system.today();
        insert acct;
        Test.stopTest();
        
        Account acc = triggerTest.getAccountById(acct.Id);
        System.assertEquals(acc.SYSAccountName__c,acc.LastName__pc+acc.firstname__pc+acc.furiganaLast__pc+acc.furiganaForst__pc);
        System.assertNotEquals(acc.HanshaUserUpdateDate__c,null);
        System.assertEquals(acc.OperationType__c,'架電禁止');
        
    }
   
    @isTest
    static void setAgentMasterdata(){
        List<Account> accList =new List<Account>();
        AccountTriggerTest triggerTest = new AccountTriggerTest();
        createAgencyMasterTestData('ACT003','Ac002');
        SeihoAgentMaster__c agent= createAgentMasterTestData('ACC001');
        SeihoAgentMaster__c agent1= createAgentsMasterTestData('ACT001');
        SeihoAgentMaster__c agent2= createAgentsMasterStatusTestData('ACT002');
        SeihoAgentMaster__c agent3= createAgentsMasterUpdatestTestData('ACT003');
        
        test.startTest();
        
        
        Account acct = triggerTest.createAccount();
        acct.HanshaList__c = '疑いなし';
        acct.CSID__pc='ACC001';
        acct.SeihoAccoutType__c='生保契約者';
        accList.add(acct);
        Account acct0 = triggerTest.createAccount();
        acct0.HanshaList__c = '疑いなし';
        acct0.CSID__pc='ACC001';
        accList.add(acct0);
        Account acct1 = triggerTest.createAccount();
        acct1.CSID__pc='ACT001';
        acct1.SeihoAccoutType__c='生保契約者';
        accList.add(acct1);
        Account acct2 = triggerTest.createAccount();
        acct2.CSID__pc='ACT002';
        acct2.SeihoAccoutType__c='生保契約者';
        accList.add(acct2);
        Account acct3 = triggerTest.createAccount();
        acct3.CSID__pc='ACT003';
        acct3.SeihoAccoutType__c='生保契約者';
        accList.add(acct3);
        insert accList;
      
        test.stopTest();
        seihoAgentMaster__c age=[select id,Account__c,AGENT_ID__c from seihoAgentMaster__c where  id=:agent.Id];
        //Account a=[select id,SeihoAgentID__c,seihoAgentMstId__c,seihoAccoutType__c from Account where  id=:accupd.Id];
         Account a=[select id,SeihoAgentID__c,seihoAgentMstId__c,seihoAccoutType__c from Account where  id=:acclist[0].Id];        
        system.assertNotEquals(a.SeihoAgentID__c, age.AGENT_ID__c);
        system.assertNotEquals(a.seihoAgentMstId__c, age.ID);
        system.assertNotEquals('生保契約者;生保代理店;生保エージェント',a.seihoAccoutType__c);
        system.assertNotEquals(age.Account__c, a.ID);
        //acct.CSID__pc='ACC002';
        //update acct;
        
    }
    @isTest
    static void setAgencyMasterdata(){
        List<Account> accList =new List<Account>();
        AccountTriggerTest triggerTest = new AccountTriggerTest();
         SeihoAgencyMaster__c agency=createAgencyMasterTestData('ACC001', 'AG00001');
        SeihoAgencyMaster__c agency1=createAgencysMasterTestData('ACT001', 'AG0000');
        List<SeihoAgencyMaster__c> agency2=createAgencyStatusMasterTestData('ACT002', 'AG0000');
        SeihoAgencyMaster__c agency3= createAgencyStatusMasterTestData2('ACT003', 'AG0000');
        SeihoAgencyMaster__c agency4=createAgencyStatusupMasterTestData2('ACT004', 'AG0000');
        SeihoAgencyMaster__c agency5=createAgencyStatusUpdateMasterTestData2('ACT005', 'AG0000');
        createAgentMasterTestData('ACT002');
        
        test.startTest();
       
        
        Account acct = triggerTest.createAccount();
        acct.HanshaList__c = '疑いなし';
        acct.CSID__pc='ACC001';
        acct.SeihoAccoutType__c='生保契約者';
        accList.Add(acct);
        Account acct0 = triggerTest.createAccount();
        acct0.HanshaList__c = '疑いなし';
        acct0.CSID__pc='ACC001';
        accList.Add(acct0);
        Account acct1 = triggerTest.createAccount();
        acct1.HanshaList__c = '疑いなし';
        acct1.CSID__pc='ACT001';
        acct1.SeihoAccoutType__c='生保契約者';
        accList.Add(acct1);
        Account acct2 = triggerTest.createAccount();
        acct2.HanshaList__c = '疑いなし';
        acct2.CSID__pc='ACT002';
        acct2.SeihoAccoutType__c='生保契約者';
        accList.Add(acct2);
        Account acct3 = triggerTest.createAccount();
        acct3.HanshaList__c = '疑いなし';
        acct3.CSID__pc='ACT003';
        acct3.SeihoAccoutType__c='生保契約者';
        accList.Add(acct3);
        Account acct4 = triggerTest.createAccount();
        acct4.HanshaList__c = '疑いなし';
        acct4.CSID__pc='ACT004';
        acct4.SeihoAccoutType__c='生保契約者';
        accList.Add(acct4);
        Account acct5 = triggerTest.createAccount();
        acct5.HanshaList__c = '疑いなし';
        acct5.CSID__pc='ACT005';
        acct5.SeihoAccoutType__c='生保契約者';
        accList.Add(acct5);
        insert accList;
        
        test.stopTest();
        SeihoAgencyMaster__c agen=[select id,Account__c from SeihoAgencyMaster__c where id=:agency.id];
        Account a=[select id,SeihoAgencyNo__c,seihoAgencyMstId__c,seihoAccoutType__c from Account where id=:accList[0].id];
        SeihoAgencyMaster__c agencyw=[select id,Account__c from SeihoAgencyMaster__c where id=:agency2[0].id];
        SeihoAgencyMaster__c agencySts=[select id,Account__c from SeihoAgencyMaster__c where id=:agency2[1].id];
        Account actt=[select id,SeihoAgencyNo__c,seihoAgencyMstId__c,seihoAccoutType__c from Account where id=:accList[3].id];
         //Account ac=[select id,SeihoAgencyNo__c,seihoAgencyMstId__c,seihoAccoutType__c from Account where Id=:accList[1].id];
        system.assertNotEquals('5',a.SeihoAgencyNo__c);
        system.assertNotEquals( '生保契約者;生保代理店',a.seihoAccoutType__c);
        system.assertNotEquals(agen.Account__c,a.id);
        system.assertNotEquals( '生保契約者;生保代理店;生保エージェント',actt.seihoAccoutType__c);
        system.assertNotEquals(actt.seihoAgencyMstId__c,agencySts.id);
        system.assertNotEquals(agencyw.Account__c,actt.id);
        system.assertNotEquals(agencySts.Account__c,actt.id);
       
        
    }
    @isTest
    static void UpdateAccountToNullOnAgentMaster(){
        
        AccountTriggerTest triggerTest = new AccountTriggerTest();
        test.startTest();
        
        //Creating AgentMaster record
        SeihoAgentMaster__c agent1 = createAgentMasterTestData('ACC001');
        
        Account acct = triggerTest.createAccount();
        acct.HanshaList__c = '疑いなし';
        acct.CSID__pc='ACC001';
        acct.SeihoAccoutType__c='生保契約者';
        insert acct;
        
        //setting csid to null to cover remove account relationship functionalityin master
        acct.CSID__pc='';
        update acct;
        test.stopTest();
        
        
        SeihoAgentMaster__c agent=[select id,Account__c from SeihoAgentMaster__c limit 1];
        system.assertEquals(null, agent.Account__c);
        
    }
    @isTest
    static void UpdateAccountToNullOnAgencyMaster(){
        
        AccountTriggerTest triggerTest = new AccountTriggerTest();
        test.startTest();
        
        //Creating AgentMaster record
        SeihoAgencyMaster__c agencyRecord=createAgencyMasterTestData('ACC001', 'AG00001');
        
        Account acct = triggerTest.createAccount();
        acct.HanshaList__c = '疑いなし';
        acct.CSID__pc='ACC001';
        acct.SeihoAccoutType__c='生保募集人';
        insert acct;
        
        //setting csid to null to cover remove account relationship functionalityin master
        acct.CSID__pc='';
        update acct;
        test.stopTest();
        SeihoAgencyMaster__c agency=[select id,Account__c from SeihoAgencyMaster__c limit 1];
        system.assertEquals(null, agency.Account__c);
        
    }
    @isTest
    static void setRecruiterMasterdata(){
        List<Account> accList =new List<Account>();
        AccountTriggerTest triggerTest = new AccountTriggerTest();
        SeihoRecruiterMaster__c recruiter=createRecruiterMasterTestData('ACC001');
        SeihoRecruiterMaster__c agency1=createRecruitersMasterTestData('ACT001');
        SeihoRecruiterMaster__c agency2=createRecruiterStatusMasterTestData('ACT002');
        SeihoRecruiterMaster__c agency3= createRecruiterStatusMasterTestData2('ACT003');
        SeihoRecruiterMaster__c agency4=createRecruiterStatusupMasterTestData2('ACT004');
        SeihoRecruiterMaster__c agency5=createRecruiterStatusUpdateMasterTestData2('ACT005');
        createAgencyMasterTestData('ACT001','AG00043');
        
        test.startTest();
        
        Account acct = triggerTest.createAccount();
        acct.HanshaList__c = '疑いなし';
        acct.CSID__pc='ACC001';
        acct.SeihoAccoutType__c='生保契約者';
        accList.Add(acct);
        Account acct0 = triggerTest.createAccount();
        acct0.HanshaList__c = '疑いなし';
        acct0.CSID__pc='ACC001';
       
        accList.Add(acct0);
        Account acct1 = triggerTest.createAccount();
        acct1.HanshaList__c = '疑いなし';
        acct1.CSID__pc='ACT001';
        acct1.SeihoAccoutType__c='生保契約者';
        accList.Add(acct1);
        Account acct2 = triggerTest.createAccount();
        acct2.HanshaList__c = '疑いなし';
        acct2.CSID__pc='ACT002';
        acct2.SeihoAccoutType__c='生保契約者';
        accList.Add(acct2);
        Account acct3 = triggerTest.createAccount();
        acct3.HanshaList__c = '疑いなし';
        acct3.CSID__pc='ACT003';
        acct3.SeihoAccoutType__c='生保契約者';
        accList.Add(acct3);
        Account acct4 = triggerTest.createAccount();
        acct4.HanshaList__c = '疑いなし';
        acct4.CSID__pc='ACT004';
        acct4.SeihoAccoutType__c='生保契約者';
        accList.Add(acct4);
        Account acct5 = triggerTest.createAccount();
        acct5.HanshaList__c = '疑いなし';
        acct5.CSID__pc='ACT005';
        acct5.SeihoAccoutType__c='生保契約者';
        accList.Add(acct5);
        insert accList;
        
        test.stopTest();
          seihorecruiterMaster__c rec=[select id,Account__c from seihorecruiterMaster__c Where Id=:Recruiter.id];
          Account ac=[select id,SeihoRecruiterNo__c,SeihoRecruiterMstId__c,seihoAccoutType__c from Account where id=:acclist[0].id];
        Account a=[select id,SeihoRecruiterNo__c,SeihoRecruiterMstId__c,seihoAccoutType__c from Account limit 1];
        system.assertNotEquals(a.SeihoRecruiterNo__c, recruiter.RECRUITER_NUMBER__c);
        system.assertNotEquals(a.SeihoRecruiterMstId__c, recruiter.ID);
        system.assertNotEquals( '生保契約者;生保募集人',a.seihoAccoutType__c);
        system.assertNotEquals( rec.account__c,ac.id);
        
    }
    @isTest
    static void UpdateAccountToNullOnRecruiterMaster(){
        
        AccountTriggerTest triggerTest = new AccountTriggerTest();
        test.startTest();
        
        //Creating AgentMaster record
        SeihoRecruiterMaster__c rec=createRecruiterMasterTestData('ACC001');
        
        Account acct = triggerTest.createAccount();
        acct.HanshaList__c = '疑いなし';
        acct.CSID__pc='ACC001';
        acct.SeihoAccoutType__c='生保募集人';
        insert acct;
        
        //setting csid to null to cover remove account relationship functionalityin master
        acct.CSID__pc='';
        update acct;
        test.stopTest();
        SeihoRecruiterMaster__c recruiter=[select id,Account__c from SeihoRecruiterMaster__c limit 1];
        system.assertEquals(null, recruiter.Account__c);
        
        
    }
    @isTest
    static void updateAccountdata(){
        
        AccountTriggerTest triggerTest = new AccountTriggerTest();
        test.startTest();
        SeihoAgentMaster__c agent= createAgentMasterTestData('ACC001');
        Account acct = triggerTest.createAccount();
        acct.HanshaList__c = '疑いなし';
        acct.CSID__pc='ACC001';
        acct.SeihoAccoutType__c='生保契約者';
        acct.OpportunityStatus__c=NULL;
        // acct.OperationType__c=NULL;
        insert acct;
        acct.CSID__pc='ACC002';
        acct.OpportunityStatus__c=NULL;
        update acct;
        test.stopTest();
        Account a=[select id,SeihoAgencyNo__c,seihoAgencyMstId__c,SeihoAgentID__c,SeihoRecruiterNo__c,SeihoRecruiterMstId__c,seihoAgentMstId__c,seihoAccoutType__c from Account limit 1];
        system.assertEquals(null, a.seihoAgentMstId__c);
        system.assertEquals(null, a.SeihoAgentID__c);
        system.assertEquals(null, a.SeihoAgencyNo__c);
        system.assertEquals(null, a.seihoAgencyMstId__c);
        system.assertEquals(null, a.SeihoRecruiterNo__c);
        system.assertEquals(null, a.SeihoRecruiterMstId__c);
        system.assertEquals('生保契約者', a.seihoAccoutType__c);
    }
    @isTest
    static void updateAccountdata3(){
         AccountTriggerTest triggerTest = new AccountTriggerTest();
        
        SeihoAgentMaster__c agent= createAgentMasterTestData('ACC001');
        SeihoRecruiterMaster__c rec= createRecruiterMasterTestData('ACC002');
        test.startTest();
        Account acct = triggerTest.createAccount();
        acct.HanshaList__c = '疑いなし';
        acct.CSID__pc='ACC001';
        acct.SeihoAccoutType__c='生保契約者';
        acct.OpportunityStatus__c=NULL;
        // acct.OperationType__c=NULL;
        insert acct;
        acct.CSID__pc='ACC002';
        update acct;
        test.stopTest();
        list<seihoAgentMaster__c> SeihoAg=[select id,Account__c from seihoAgentMaster__c Limit 2 ];
        list<seihoRecruiterMaster__c> SeihoRec=[select id,Account__c from seihoRecruiterMaster__c Limit 2 ];
        Account a=[select id,SeihoAgencyNo__c,seihoAgencyMstId__c,SeihoAgentID__c,SeihoRecruiterNo__c,SeihoRecruiterMstId__c,seihoAgentMstId__c,seihoAccoutType__c from Account limit 1];
        system.assertEquals(null, a.seihoAgentMstId__c);
        system.assertEquals(null, a.SeihoAgentID__c);
        system.assertEquals(null, a.SeihoAgencyNo__c);
        system.assertEquals(null, a.seihoAgencyMstId__c);
        system.assertEquals(null, SeihoAg[0].account__c);
        system.assertEquals(null,  SeihoAg[1].account__c);
        system.assertNotEquals(a.id,  Seihorec[0].account__c);
        system.assertNotEquals(a.id,  Seihorec[1].account__c);
        system.assertNotEquals(SeihoRec[1].Id, a.SeihoRecruiterMstId__c);
        system.assertNotEquals('生保契約者;生保募集人', a.seihoAccoutType__c);
        }
    
    @isTest
    static void updateAccountdata2(){
       // test.startTest();
        AccountTriggerTest triggerTest = new AccountTriggerTest();
        Account acct = triggerTest.createAccount();
        acct.HanshaList__c = '未選択';
        acct.HANSHA_FLG__pc='疑いあり';
        acct.CSID__pc='ACC001';
        acct.OperationType__c='架電禁止';
        acct.OpportunityStatus__c='未対応';
        acct.SeihoAccoutType__c='生保募集人';
        acct.HanshaSystemUpdateDate__c=date.parse('2002/01/01');
        test.startTest();
        insert acct;
        acct.CSID__pc='ACC002';
        acct.OperationType__c=NULL;
        acct.HanshaSystemUpdateDate__c=date.parse('2003/01/01');
        update acct;
        test.stopTest();
        
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
            LastName__pc='個人', 
            firstname__pc='取引先',
            furiganaLast__pc='こじん',
            furiganaForst__pc='とりひきさき',
            PersonMailingState ='東京都',
            PersonBirthdate=date.parse('1982/01/01'),
            Gender__pc = '男性',
            RecordTypeId=recordTypes[0].Id
        );
        
    } 
    
    private HanshaInfo__c createHanshaInfo(){
        return new HanshaInfo__c(
            Name__c='個人 取引先',
            Gender__c='男性',
            AssumeBirthdate__c=date.parse('1982/01/01'),
            Prefecture__c='東京都',
            No__c='19820101'
        );  
    }
    
    private Opportunity createOpportunity(Id accountId){
        Opportunity opp = new Opportunity();
        opp.AccountID = accountId;
        opp.Name='個人';
        opp.StageName='未対応'; 
        opp.RecentProbability__c='申込なし';
        opp.CloseType__c=null;
        opp.CloseReason__c='取引先対応終了';
        opp.CloseDate=system.today();//date.parse('2020/01/01');
        return opp;
    }
    private Account getAccountById( Id accountId ) {
        return [SELECT Id, Name, LastName, FirstName, furiganaForst__pc, furiganaLast__pc, Phone,easyId__pc,openId__pc,
                PersonHomePhone, PersonMobilePhone, PersonBirthdate, Gender__pc,HanshaUserUpdateDate__c,  
                SYSAccountName__c, PersonMailingPostalCode, PersonMailingState, 
                PersonMailingCity, PersonMailingStreet, PersonEmail,LastName__pc,firstname__pc,division__pc,
                OperationType__c,OpportunityStatus__c
                FROM   Account
                WHERE  Id =: accountId LIMIT 1];
    }
    private Opportunity getOpportunityById( Id oppId ) {
        return [SELECT id,name,telReason__c,InflowRoute__c,CloseDate,StageName,RecentProbability__c,
                CloseReason__c
                FROM Opportunity WHERE  Id =: oppId LIMIT 1];
    }
    
   
    private static SeihoAgentMaster__c createAgentMasterTestData(String csID){
        
        SeihoAgentMaster__c agent = new SeihoAgentMaster__c(
            Name = 'Test User_1',
            CS_ID__c = csId,
            BELONG_AGENT__c = 'AG00001',
            SeihoAgentParentFlag__c = false,
            MEMBER_ID_SEQ__c = 'AG00007',
            Account__c = null,
            AGENT_STATUS_DID__c='3',
            REGISTRATION_DATE__c='2020-09-30',
            AGENT_ID__c='54678',
            OLD_AGENT_ID__c ='AG00001'
            
        );
        insert agent;
        SeihoAgentMaster__c agent1 = new SeihoAgentMaster__c(
            Name = 'Test User_1',
            CS_ID__c = csId,
            BELONG_AGENT__c = 'AG00001',
            SeihoAgentParentFlag__c = false,
            MEMBER_ID_SEQ__c = 'AG00007',
            Account__c = null,
            AGENT_STATUS_DID__c='3',
            REGISTRATION_DATE__c='2020-09-30',
            AGENT_ID__c='54679',
            OLD_AGENT_ID__c ='AG00001'
            
        );
        insert agent1; 
        return Agent1;
    }
    private static SeihoAgentMaster__c createAgentsMasterTestData(String csID){
        SeihoAgentMaster__c agent3 = new SeihoAgentMaster__c(
            Name = 'Test User_1',
            CS_ID__c = csId,
            BELONG_AGENT__c = 'AG00001',
            SeihoAgentParentFlag__c = false,
            MEMBER_ID_SEQ__c = 'AG00007',
            Account__c = null,
            AGENT_STATUS_DID__c='3',
            REGISTRATION_DATE__c='2020-09-25',
            AGENT_ID__c='54679',
            OLD_AGENT_ID__c ='AG00001'
            
        );
        insert agent3;
        SeihoAgentMaster__c agent4 = new SeihoAgentMaster__c(
            Name = 'Test User_1',
            CS_ID__c = csId,
            BELONG_AGENT__c = 'AG00001',
            SeihoAgentParentFlag__c = false,
            MEMBER_ID_SEQ__c = 'AG00007',
            Account__c = null,
            AGENT_STATUS_DID__c='3',
            REGISTRATION_DATE__c='2020-09-30',
            AGENT_ID__c='54679',
            OLD_AGENT_ID__c ='AG00001'
            
        );
        insert agent4;
        
        return agent4;
        
    }
    private static List<SeihoAgencyMaster__c> createAgencyStatusMasterTestData(String csId, String agencyNumber){
  
        SeihoAgencyMaster__c agency = new SeihoAgencyMaster__c(
            
            agncynmkn__c = 'SeihoAgency_001', //カナ 
            agncynmkj__c = 'SeihoAgency_001', //漢字
            tantoupbragncyno__c='AG05008',
            agncysts__c='1',
            agncyno__c='126',
            agncyrgstymd__c=date.newInstance(2020,07,02),
            csid__c = csId,
            Account__c = null
            
        );
        
        SeihoAgencyMaster__c agency1 = new SeihoAgencyMaster__c(
            
            agncynmkn__c = 'SeihoAgency_001', //カナ 
            agncynmkj__c = 'SeihoAgency_001', //漢字
            tantoupbragncyno__c='AG05008',
            agncyno__c='AG05008',
            agncyrgstymd__c=date.newInstance(2020,05,28),
            agncysts__c='1',
            csid__c = csId,
            Account__c = null
            
        );
        insert agency1;
        insert agency;
        return new List<SeihoAgencyMaster__C>{agency1,agency};
    }
    private static SeihoAgencyMaster__c createAgencyStatusMasterTestData2(String csId, String agencyNumber){
        
        SeihoAgencyMaster__c agency = new SeihoAgencyMaster__c(
            
            agncynmkn__c = 'SeihoAgency_001', //カナ 
            agncynmkj__c = 'SeihoAgency_001', //漢字
            tantoupbragncyno__c='AG70008',
            agncysts__c='1',
            agncyno__c='180',
            agncyrgstymd__c=date.newInstance(2020,09,30),
            csid__c = csId,
            Account__c = null
            
        );
        
        SeihoAgencyMaster__c agency1 = new SeihoAgencyMaster__c(
            
            agncynmkn__c = 'SeihoAgency_001', //カナ 
            agncynmkj__c = 'SeihoAgency_001', //漢字
            tantoupbragncyno__c='AG58008',
            agncysts__c='1',
            agncyno__c='100',
            agncyrgstymd__c=date.newInstance(2020,09,30),
            csid__c = csId,
            Account__c = null
            
        );
        insert agency1;
        insert agency;
        
        return agency1;
    }
    private static SeihoAgencyMaster__c createAgencyStatusUpdateMasterTestData2(String csId, String agencyNumber){
        
        SeihoAgencyMaster__c agency = new SeihoAgencyMaster__c(
            
            agncynmkn__c = 'SeihoAgency_001', //カナ 
            agncynmkj__c = 'SeihoAgency_001', //漢字
            tantoupbragncyno__c='AG10008',
            agncysts__c='4',
            agncyno__c='155',
            agncyrgstymd__c=date.newInstance(2020,08,30),
            clsymd__c=date.newInstance(2020,03,30),
            csid__c = csId,
            Account__c = null
            
        );
        insert Agency;
        SeihoAgencyMaster__c agency1 = new SeihoAgencyMaster__c(
            
            agncynmkn__c = 'SeihoAgency_001', //カナ 
            agncynmkj__c = 'SeihoAgency_001', //漢字
            tantoupbragncyno__c='AG10008',
            agncysts__c='4',
            agncyno__c='167',
            clsymd__c=date.newInstance(2020,08,30),
            agncyrgstymd__c=date.newInstance(2020,07,30),
            csid__c = csId,
            Account__c = null
            
        );
        insert agency1;
        return agency1;
    }
    private static SeihoAgencyMaster__c createAgencyStatusupMasterTestData2(String csId, String agencyNumber){
        
        SeihoAgencyMaster__c agency = new SeihoAgencyMaster__c(
            
            agncynmkn__c = 'SeihoAgency_001', //カナ 
            agncynmkj__c = 'SeihoAgency_001', //漢字
            tantoupbragncyno__c='AGg0008',
            agncysts__c='4',
            agncyno__c='109',
            clsymd__c=date.newInstance(2020,08,30),
            agncyrgstymd__c=date.newInstance(2020,09,30),
            csid__c = csId,
            Account__c = null
            
        );
        
        SeihoAgencyMaster__c agency1 = new SeihoAgencyMaster__c(
            
            agncynmkn__c = 'SeihoAgency_001', //カナ 
            agncynmkj__c = 'SeihoAgency_001', //漢字
            tantoupbragncyno__c='AG03008',
            clsymd__c=date.newInstance(2020,08,30),
            agncyrgstymd__c=date.newInstance(2020,09,30),
            agncysts__c='4',
            agncyno__c='66',
            csid__c = csId,
            Account__c = null
            
        );
        insert agency1;
        insert agency;
        return agency1;
    }
    
    private static SeihoAgencyMaster__c createAgencyMasterTestData(String csId, String agencyNumber){
        
        SeihoAgencyMaster__c agency = new SeihoAgencyMaster__c(
            
            agncynmkn__c = 'SeihoAgency_001', //カナ 
            agncynmkj__c = 'SeihoAgency_001', //漢字
            tantoupbragncyno__c='AG08008',
            agncysts__c='3',
            agncyno__c='3',
            agncyrgstymd__c=date.newInstance(2020,09,28),
            csid__c = csId,
            Account__c = null
            
        );
        insert agency;
        SeihoAgencyMaster__c agency1 = new SeihoAgencyMaster__c(
            
            agncynmkn__c = 'SeihoAgency_001', //カナ 
            agncynmkj__c = 'SeihoAgency_001', //漢字
            tantoupbragncyno__c='AG04008',
            agncyrgstymd__c=date.newInstance(2020,09,28),
            agncysts__c='3',
            agncyno__c='5',
            csid__c = csId,
            Account__c = null
            
        );
        insert agency1;
        return agency1;
    }
    private static SeihoAgencyMaster__c createAgencysMasterTestData(String csId, String agencyNumber){
        
        SeihoAgencyMaster__c agency = new SeihoAgencyMaster__c(
            
            agncyno__c = '5777',
            agncynmkn__c = 'SeihoAgency_001', //カナ 
            agncynmkj__c = 'SeihoAgency_001', //漢字
            tantoupbragncyno__c='AG00008',
            agncysts__c='3',
            agncyrgstymd__c=date.newInstance(2020,05,28),
            csid__c = csId,
            Account__c = null
            
        );
        insert agency;
        SeihoAgencyMaster__c agency1 = new SeihoAgencyMaster__c(
            
            agncyno__c = '5678',
            agncynmkn__c = 'SeihoAgency_001', //カナ 
            agncynmkj__c = 'SeihoAgency_001', //漢字
            tantoupbragncyno__c='AG00008',
            agncysts__c='3',
            agncyrgstymd__c=date.newInstance(2020,06,30),
            csid__c = csId,
            Account__c = null
            
        );
        insert agency1;
        
        return agency1;
    }
    private static SeihoAgentMaster__c createAgentsMasterStatusTestData(String csId){
        
        SeihoAgentMaster__c agent3 = new SeihoAgentMaster__c(
            Name = 'Test User_1',
            CS_ID__c = csId,
            BELONG_AGENT__c = 'AG00001',
            SeihoAgentParentFlag__c = false,
            MEMBER_ID_SEQ__c = 'AG00007',
            Account__c = null,
            AGENT_STATUS_DID__c='4',
            ANNIHILATION_DATE__c='2020-09-25',
            AGENT_ID__c='54679',
            OLD_AGENT_ID__c ='AG00001'
            
        );
        insert agent3;
        SeihoAgentMaster__c agent4 = new SeihoAgentMaster__c(
            Name = 'Test User_1',
            CS_ID__c = csId,
            BELONG_AGENT__c = 'AG00001',
            SeihoAgentParentFlag__c = false,
            MEMBER_ID_SEQ__c = 'AG00007',
            Account__c = null,
            AGENT_STATUS_DID__c='4',
            ANNIHILATION_DATE__c='2020-09-30',
            AGENT_ID__c='54679',
            OLD_AGENT_ID__c ='AG00001'
            
        );
        insert agent4;
        return agent4;
    }
    private static SeihoAgentMaster__c createAgentsMasterUpdatestTestData(String csId){
        
        SeihoAgentMaster__c agent3 = new SeihoAgentMaster__c(
            Name = 'Test User_1',
            CS_ID__c = csId,
            BELONG_AGENT__c = 'AG00001',
            SeihoAgentParentFlag__c = false,
            MEMBER_ID_SEQ__c = 'AG00007',
            Account__c = null,
            AGENT_STATUS_DID__c='4',
            ANNIHILATION_DATE__c='2020-09-15',
            AGENT_ID__c='5',
            OLD_AGENT_ID__c ='AG00001'
            
        );
        insert agent3;
        SeihoAgentMaster__c agent4 = new SeihoAgentMaster__c(
            Name = 'Test User_1',
            CS_ID__c = csId,
            BELONG_AGENT__c = 'AG00001',
            SeihoAgentParentFlag__c = false,
            MEMBER_ID_SEQ__c = 'AG00007',
            Account__c = null,
            AGENT_STATUS_DID__c='4',
            ANNIHILATION_DATE__c='2020-09-15',
            AGENT_ID__c='10',
            OLD_AGENT_ID__c ='AG00001'
            
        );
        insert agent4;
        return agent4;
    }
    private static SeihoRecruiterMaster__c createRecruiterMasterTestData(String csId){
        
        SeihoRecruiterMaster__c recruiter = new SeihoRecruiterMaster__c(
            Name = 'RECRUITER_001',
            CS_ID__c = csId,
            RECRUITER_NUMBER__c = 'RN00001',
            AGENCY_NUMBER__c = 'AG00001',
            SeihoAgencyMasterName__c = null,
            RECRUITER_STATUS_DID__c='3',
            REGISTRATION_DATE__c='2020-08-18',
            Account__c = null
        );
        insert recruiter;
        SeihoRecruiterMaster__c recruiter1 = new SeihoRecruiterMaster__c(
            Name = 'RECRUITER_001',
            CS_ID__c = csId,
            RECRUITER_NUMBER__c = 'RN00002',
            AGENCY_NUMBER__c = 'AG00001',
            SeihoAgencyMasterName__c = null,
            RECRUITER_STATUS_DID__c='3',
            REGISTRATION_DATE__c='2020-09-23',
            Account__c = null
        );
        insert recruiter1;
        
        return recruiter1;
    }
    private static SeihoRecruiterMaster__c createRecruitersMasterTestData(String csId){
        
        SeihoRecruiterMaster__c recruiter = new SeihoRecruiterMaster__c(
            Name = 'RECRUITER_001',
            CS_ID__c = csId,
            RECRUITER_NUMBER__c = '5',
            AGENCY_NUMBER__c = 'AG00001',
            SeihoAgencyMasterName__c = null,
            RECRUITER_STATUS_DID__c='3',
            REGISTRATION_DATE__c='2020-09-14',
            Account__c = null
        );
        insert recruiter;
        SeihoRecruiterMaster__c recruiter1 = new SeihoRecruiterMaster__c(
            Name = 'RECRUITER_001',
            CS_ID__c = csId,
            RECRUITER_NUMBER__c = '6',
            AGENCY_NUMBER__c = 'AG00001',
            SeihoAgencyMasterName__c = null,
            REGISTRATION_DATE__c='2020-09-14',
            RECRUITER_STATUS_DID__c='3',
            Account__c = null
        );
        insert recruiter1;
        
        return recruiter;
    }
    private static SeihoRecruiterMaster__c createRecruiterStatusMasterTestData(String csId){
        
        SeihoRecruiterMaster__c recruiter = new SeihoRecruiterMaster__c(
            Name = 'RECRUITER_001',
            CS_ID__c = csId,
            RECRUITER_NUMBER__c = 'RN00001',
            AGENCY_NUMBER__c = 'AG00001',
            SeihoAgencyMasterName__c = null,
            REGISTRATION_DATE__c='2020-09-10',
            RECRUITER_STATUS_DID__c='1',
            Account__c = null
        );
        insert recruiter;
        SeihoRecruiterMaster__c recruiter1 = new SeihoRecruiterMaster__c(
            Name = 'RECRUITER_001',
            CS_ID__c = csId,
            RECRUITER_NUMBER__c = 'RN000011',
            AGENCY_NUMBER__c = 'AG00001',
            SeihoAgencyMasterName__c = null,
            REGISTRATION_DATE__c='2020-09-21',
            RECRUITER_STATUS_DID__c='1',
            Account__c = null
        );
        insert recruiter1;
        
        return recruiter1;
    }
    private static SeihoRecruiterMaster__c createRecruiterStatusMasterTestData2(String csId){
        
        SeihoRecruiterMaster__c recruiter = new SeihoRecruiterMaster__c(
            Name = 'RECRUITER_001',
            CS_ID__c = csId,
            RECRUITER_NUMBER__c = '13',
            AGENCY_NUMBER__c = 'AG00001',
            REGISTRATION_DATE__c='2020-09-17',
            SeihoAgencyMasterName__c = null,
            RECRUITER_STATUS_DID__c='1',
            Account__c = null
        );
        insert recruiter;
        
        SeihoRecruiterMaster__c recruiter1 = new SeihoRecruiterMaster__c(
            Name = 'RECRUITER_001',
            CS_ID__c = csId,
            RECRUITER_NUMBER__c = '16',
            AGENCY_NUMBER__c = 'AG00001',
            REGISTRATION_DATE__c='2020-09-17',
            SeihoAgencyMasterName__c = null,
            RECRUITER_STATUS_DID__c='1',
            Account__c = null
        );
        insert recruiter1;
        
        return recruiter1;
    }
    private static SeihoRecruiterMaster__c createRecruiterStatusupMasterTestData2(String csId){
        
        SeihoRecruiterMaster__c recruiter = new SeihoRecruiterMaster__c(
            Name = 'RECRUITER_001',
            CS_ID__c = csId,
            RECRUITER_NUMBER__c = 'RN00001',
            AGENCY_NUMBER__c = 'AG00001',
            SeihoAgencyMasterName__c = null,
            OUT_OF_BUSINESS_DATE__c='2020-07-20',
            RECRUITER_STATUS_DID__c='4',
            Account__c = null
        );
        insert recruiter;
        SeihoRecruiterMaster__c recruiter1 = new SeihoRecruiterMaster__c(
            Name = 'RECRUITER_001',
            CS_ID__c = csId,
            RECRUITER_NUMBER__c = 'RN000012',
            AGENCY_NUMBER__c = 'AG00001',
            SeihoAgencyMasterName__c = null,
            OUT_OF_BUSINESS_DATE__c='2020-07-28',
            RECRUITER_STATUS_DID__c='4',
            Account__c = null
        );
        insert recruiter1;
        return recruiter1;
    }
    private static SeihoRecruiterMaster__c createRecruiterStatusUpdateMasterTestData2(String csId){
        
        SeihoRecruiterMaster__c recruiter = new SeihoRecruiterMaster__c(
            Name = 'RECRUITER_001',
            CS_ID__c = csId,
            RECRUITER_NUMBER__c = '4',
            AGENCY_NUMBER__c = 'AG00001',
            SeihoAgencyMasterName__c = null,
            OUT_OF_BUSINESS_DATE__c='2020-08-28',
            RECRUITER_STATUS_DID__c='4',
            Account__c = null
        );
        insert recruiter;
        SeihoRecruiterMaster__c recruiter1 = new SeihoRecruiterMaster__c(
            Name = 'RECRUITER_001',
            CS_ID__c = csId,
            RECRUITER_NUMBER__c = '8',
            AGENCY_NUMBER__c = 'AG00001',
            SeihoAgencyMasterName__c = null,
            OUT_OF_BUSINESS_DATE__c='2020-08-28',
            RECRUITER_STATUS_DID__c='4',
            Account__c = null
        );
        insert recruiter1;
        
        return recruiter1;
    }

}