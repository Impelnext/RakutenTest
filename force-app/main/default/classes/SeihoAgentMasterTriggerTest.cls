/*
* @Class Name      : SeihoAgentMasterTriggerTest 
* @Description     : 生保エージェントマスタトリガのテストクラス
* @Created Date    : 2020.05.29
* @Created By      : SRM
* @Modified Date   : 2020.06.18
* @Modified        : SRM
*/
@isTest
private class SeihoAgentMasterTriggerTest {
   
    @isTest
    static void setCsidChangeFlag(){
       
        SeihoAgentMaster__c agent = createAgentMasterTestData('NX00001','BC01', 'BR1');
       
        //tantoupbragncyno existence verification (所属代理店の存在チェック)
        System.assertEquals(True,[SELECT Id, CSID_ChangeFlag__c FROM SeihoAgentMaster__c WHERE ID =: agent.Id][0].CSID_ChangeFlag__c);
       test.startTest();
        agent.cs_id__c = 'NX00002';
        update agent;
        test.stopTest();
        System.assertEquals(true,[SELECT Id, CSID_ChangeFlag__c FROM SeihoAgentMaster__c WHERE Id =: agent.Id][0].CSID_ChangeFlag__c);
        //System.assertEquals(false,[SELECT Id, AgencyNameFlag__c FROM SeihoAgencyMaster__c WHERE Id =: agency.Id][0].AgencyNameFlag__c);
    }
    @isTest
    static void InsertRecordsetCsidChangeFlag(){
        test.startTest();
        SeihoAgentMaster__c agent = createAgentMasterTestData('NX00001','BC01', 'BR1');
       test.stopTest();
        //tantoupbragncyno existence verification (所属代理店の存在チェック)
        System.assertEquals(True,[SELECT Id, CSID_ChangeFlag__c FROM SeihoAgentMaster__c WHERE ID =: agent.Id][0].CSID_ChangeFlag__c);
        //System.assertEquals(true,[SELECT Id, CSID_ChangeFlag__c FROM SeihoAgentMaster__c WHERE Id =: agent.Id][0].CSID_ChangeFlag__c);
        //System.assertEquals(false,[SELECT Id, AgencyNameFlag__c FROM SeihoAgencyMaster__c WHERE Id =: agency.Id][0].AgencyNameFlag__c);
    }
  @isTest
    static void setAccountReference(){
        Account acc = createAccountTestData('001','NX00001','');
        SeihoAgentMaster__c agent = createAgentMasterTestData('NX00001', 'BC01','BR1');
        
        //Agent Master Id verification in Account
        System.assertNotEquals(agent.Id,[SELECT Id, SeihoAgentMstId__c FROM Account WHERE CSID__pc =: agent.CS_ID__c][0].SeihoAgentMstId__c);
        //Agent Id verification in Account
        System.assertNotEquals(agent.AGENT_ID__c,[SELECT Id, SeihoAgentID__c FROM Account WHERE CSID__pc =: agent.CS_ID__c][0].SeihoAgentID__c);
        //Account Type verification in Account (blank to value)
        system.debug('agentType'+acc.SeihoAccoutType__c);
        System.assertNotEquals('生保エージェント', [SELECT Id, SeihoAccoutType__c FROM Account WHERE CSID__pc =: agent.CS_ID__c][0].SeihoAccoutType__c);
        //Master verification
        System.assertNotEquals(acc.Id,[SELECT Id, Account__c FROM SeihoAgentMaster__c WHERE ID =: agent.Id][0].Account__c);

        Account acc1 = createAccountTestData('002','NX00002','生保契約者;生保代理店');
        SeihoAgentMaster__c agent1 = createAgentMasterTestData('NX00002', 'BC01','BR1');
         System.assertNotEquals('生保契約者;生保エージェント',[SELECT Id, SeihoAccoutType__c FROM Account WHERE CSID__pc =: agent1.CS_ID__c][0].SeihoAccoutType__c);
        //Account Type verification in Account (生保エージェント　already exists so no change in account type)
        System.assertNotEquals(1,[SELECT Id, SeihoAccoutType__c FROM Account WHERE CSID__pc =: agent1.CS_ID__c][0].SeihoAccoutType__c.countMatches('生保エージェント'));
       
        Account acc2 = createAccountTestData('003','NX00003','生保エージェント');
        SeihoAgentMaster__c agent2 = createAgentMasterTestData('NX00003', 'BC01','BR1');

        //Account Type verification in Account (生保募集人 added)
        System.assertEquals(true,(acc2.SeihoAccoutType__c).containsIgnoreCase('生保エージェント'));
    }

    @isTest
    static void setAgentMasterFlag(){
        Account acc = createAccountTestData('001','NX00001','生保エージェント');
        SeihoAgentMaster__c agent = createAgentMasterTestData('NX00001', 'BC01','BR1');
       
        //AgentMaster reference verification
        System.assertEquals(true,[SELECT Id, SeihoAgentParentFlag__c FROM SeihoAgentMaster__c WHERE BELONG_AGENT__c!=null][0].SeihoAgentParentFlag__c);
        agent.BELONG_AGENT__c = null;
        update agent;
        System.assertEquals(null,[SELECT SeihoAgentParent__c FROM SeihoAgentMaster__c WHERE Id =: agent.Id][0].SeihoAgentParent__c);
        System.assertEquals(false,[SELECT SeihoAgentParentFlag__c from SeihoAgentMaster__c WHERE Id =: agent.Id][0].SeihoAgentParentFlag__c);
    }

    @isTest
    static void updateAccountReferenceValueToValue(){
        Account acc1 = createAccountTestData('001','NX00001','生保エージェント');   
        SeihoAgentMaster__c agent = createAgentMasterTestData('NX00001', 'BC01','BR1');
        
        Id b4UpdateAccIdInMaster = [SELECT Id, Account__c FROM SeihoAgentMaster__c WHERE ID =: agent.Id][0].Account__c;
          SeihoAgentMaster__c agent1 = [SELECT Id,CS_ID__c, Account__c,BELONG_AGENT__c FROM SeihoAgentMaster__c WHERE ID =: agent.Id];
        Id b4UpdateAgentIdInAccnt = [SELECT Id, SeihoAgentMstId__c FROM Account WHERE CSID__pc =: agent.CS_ID__c][0].SeihoAgentMstId__c;
        agent1.CS_ID__c ='NX00002';
        test.startTest();
        update agent1;
         Account acc2 = createAccountTestData('002','NX00002','生保エージェント');

        test.stoptest();

        //Master verification
        System.assertEquals(b4UpdateAccIdInMaster,[SELECT Id, Account__c,BELONG_AGENT__c FROM SeihoAgentMaster__c WHERE ID =: agent.Id][0].Account__c);
        //system.debug('seihoagent'+[select id,Account__c from SeihoAgentMaster__c]);
        System.assertNotEquals(acc1.id,[SELECT Id, Account__c FROM SeihoAgentMaster__c WHERE ID =:agent1.Id][0].Account__c);
        //Account Type verification in Account
        System.assertEquals(true, (acc2.SeihoAccoutType__c).containsIgnoreCase('生保エージェント'));
        //Agent Id verification in Account
       // System.assertEquals([SELECT Id, Account__c,BELONG_AGENT__c FROM SeihoAgentMaster__c WHERE ID =: agent.Id][0].BELONG_AGENT__c,[SELECT Id, SeihoAgentID__c FROM Account WHERE CSID__pc =: agent1.CS_ID__c][0].SeihoAgentID__c);        
        //Agent Master ID verification in Account
        System.assertNotEquals(agent1.id,[SELECT Id, SeihoAgentMstId__c FROM Account WHERE CSID__pc =: agent.CS_ID__c][0].SeihoAgentMstId__c);
        System.assertNotEquals(agent1.BELONG_AGENT__c,[SELECT Id, SeihoAgentMstId__c FROM Account WHERE CSID__pc =: agent.CS_ID__c][0].SeihoAgentMstId__c);
        System.assertNotEquals(false, (acc2.SeihoAccoutType__c).containsIgnoreCase('生保エージェント'));
        
        //Agent Number-old Account verification
       // System.assertEquals(agent.BELONG_AGENT__c,[SELECT Id, SeihoAgentID__c FROM Account WHERE CSID__pc =: agent.CS_ID__c][0].SeihoAgentID__c);        
        //Agent ID-old Account verification
        //System.assertEquals(agent.Id,[SELECT Id, SeihoAgentMstId__c FROM Account WHERE CSID__pc =: agent.CS_ID__c][0].SeihoAgentMstId__c);
    }

    @isTest
    static void updateAccountReferenceNullToValue(){
        SeihoAgentMaster__c agent = createAgentMasterTestData(null, 'BC01','BR1');
        
        Id b4UpdateAccIdInMaster = [SELECT Id, Account__c FROM SeihoAgentMaster__c WHERE ID =: agent.Id][0].Account__c;

        Account acc2 = createAccountTestData('002','NX00002','生保エージェント');
        agent.CS_ID__c = 'NX00002';
        test.startTest();
        update agent;
        test.stoptest();
        //Master verification
        System.assertEquals(b4UpdateAccIdInMaster,[SELECT Id, Account__c FROM SeihoAgentMaster__c WHERE ID =: agent.Id][0].Account__c);
        System.assertNotEquals(acc2.Id,[SELECT Id, Account__c FROM SeihoAgentMaster__c WHERE ID =: agent.Id][0].Account__c);
        //Account Type verification in Account
        System.assertEquals(true, (acc2.SeihoAccoutType__c).containsIgnoreCase('生保エージェント'));
        //Agent Id verification in Account
        System.assertNotEquals(agent.AGENT_ID__c,[SELECT Id, SeihoAgentID__c FROM Account WHERE CSID__pc =: agent.CS_ID__c][0].SeihoAgentID__c);        
        //Agent Master ID verification in Account
        System.assertNotEquals(agent.Id,[SELECT Id, SeihoAgentMstId__c FROM Account WHERE CSID__pc =: agent.CS_ID__c][0].SeihoAgentMstId__c);
    }

    @isTest
    static void updateAccountReferenceValueToNull(){
        Account acc = createAccountTestData('001','NX00001','生保エージェント');      
        SeihoAgentMaster__c agent = createAgentMasterTestData('NX00001', 'BC01','BR1');
        
        Id b4UpdateAccIdInMaster = [SELECT Id, Account__c FROM SeihoAgentMaster__c WHERE CS_ID__c =: acc.CSID__pc][0].Account__c;
        Id b4UpdateAgentIdInAccnt = [SELECT Id, SeihoAgentMstId__c FROM Account WHERE CSID__pc =: agent.CS_ID__c][0].SeihoAgentMstId__c;
        String b4UpdateAgentNoInAccnt=[SELECT Id, SeihoAgentID__c FROM Account WHERE CSID__pc =: agent.CS_ID__c][0].SeihoAgentID__c;

        agent.CS_ID__c = null;
        test.startTest();
        update agent;
        test.stoptest();
        //Master verification
        System.assertEquals(b4UpdateAccIdInMaster,[SELECT Id, Account__c FROM SeihoAgentMaster__c WHERE ID =: agent.Id][0].Account__c);
        //Account Type-Account verification
        System.assertEquals(true, (acc.SeihoAccoutType__c).containsIgnoreCase('生保エージェント'));
        //Agent Number-Account verification
        System.assertEquals(null,[SELECT Id, SeihoAgentID__c FROM Account WHERE Id =: acc.id][0].SeihoAgentID__c);        
        //Agent ID-Account verification
        String x=[SELECT Id, SeihoAgentMstId__c FROM Account WHERE Id =: acc.id][0].SeihoAgentMstId__c;
        System.assertEquals(null,x);
        
    }
    
    @isTest
    static void noRelatedAccount(){
        Account acc = createAccountTestData('001','NX00002','生保エージェント');
        SeihoAgentMaster__c agent = createAgentMasterTestData('NX00001', 'BC01','BR1');
        List<Account> accountList=[SELECT Id, SeihoAgentMstId__c FROM Account WHERE CSID__pc =: agent.CS_ID__c];
        System.assertEquals(0,accountList.size());
    }
    
    @isTest
    static void setBankBranchNameTest(){
        Account acc = createAccountTestData('001','NX00001','生保エージェント');
        BankMaster__c bankMaster = createBankMasterTestData('BC01','BR1');
        SeihoAgentMaster__c agent = createAgentMasterTestData('NX00001', 'BC01','BR1');
        
        System.assertEquals(bankMaster.BankName__c,[SELECT Id, Account__c,BankName__c FROM SeihoAgentMaster__c WHERE ID =: agent.Id][0].BankName__c);
        System.assertEquals(bankMaster.BranchName__c,[SELECT Id, Account__c,BranchName__c FROM SeihoAgentMaster__c WHERE ID =: agent.Id][0].BranchName__c);
    }
  
    @isTest
    static void UpdateBankBranchCodesToNull(){
        Account acc = createAccountTestData('001','NX00001','生保代理店');
        BankMaster__c bankMaster = createBankMasterTestData('BC01', 'BR1');
        SeihoAgentMaster__c agent = createAgentMasterTestData('NX00001', 'BC01', 'BR1');
        agent.BANK_CODE__c = null;
        agent.BRANCH_CODE__c = null;
        test.startTest();
        update agent;
        test.stoptest();
        System.assertEquals(null, agent.BankName__c);
        System.assertEquals(null, agent.BranchName__c);
    }

    @isTest
    static void updateBankBranchCodesValueToValue(){
        Account acc = createAccountTestData('001','NX00001','生保代理店');
        BankMaster__c bankMaster = createBankMasterTestData('BC01', 'BR1');
        SeihoAgentMaster__c agent = createAgentMasterTestData('NX00001', 'BC02', 'BR2');
        String b4UpdateBankNameInMaster=[SELECT Id, BankName__c FROM SeihoAgentMaster__c WHERE Id =: agent.Id][0].BankName__c;
        String b4UpdateBranchNameInMaster=[SELECT Id, BranchName__c FROM SeihoAgentMaster__c WHERE Id =: agent.Id][0].BranchName__c;
        agent.BANK_CODE__c='BC01';
        agent.BRANCH_CODE__c='BR1';
       
        test.startTest();
        update agent;
        test.stoptest();
        System.assertEquals(bankMaster.BankName__c,[SELECT Id, BankName__c FROM SeihoAgentMaster__c WHERE Id =: agent.Id][0].BankName__c);
        System.assertEquals(bankMaster.BranchName__c,[SELECT Id, BranchName__c FROM SeihoAgentMaster__c WHERE Id =: agent.Id][0].BranchName__c);
        System.assertNotEquals(b4UpdateBankNameInMaster, [SELECT Id, BankName__c FROM SeihoAgentMaster__c WHERE Id =: agent.Id][0].BankName__c);   
        System.assertNotEquals(b4UpdateBranchNameInMaster, [SELECT Id, BranchName__c FROM SeihoAgentMaster__c WHERE Id =: agent.Id][0].BranchName__c);  
    }
    //ステータス条件のため追加
    static testmethod void createAgntRecStsBased(){
     //生保エージェントマスターレコード插入部分
     //取引先レコード插入
     Account acc1 = createAccountTestData('001','NX00001','生保代理店');
     //Cntd 1　Status Id = 3（生保エージェントマスターレコード插入）
     SeihoAgentMaster__c Agent1 =createAgntMstrTestDataStsBased('NX00001','3','2020-09-14', '1000');
     //確認
     System.assertNotEquals(acc1.Id,[Select Account__c from SeihoAgentMaster__c where Id=:Agent1.Id][0].Account__c);
     //Cntd 2　Status Id = 3 prioritise based on Latest date
     SeihoAgentMaster__c Agent2 =createAgntMstrTestDataStsBased('NX00001','3','2020-09-15', '1000');
      //確認
     System.assertNotEquals(acc1.Id,[Select Account__c from SeihoAgentMaster__c where Id=:Agent2.Id][0].Account__c);
     //Cntd 2　Status Id = 3 prioritise based on Latest AgentId
     SeihoAgentMaster__c Agent3 =createAgntMstrTestDataStsBased('NX00001','3','2020-09-15', '1001');
      //確認
     System.assertNotEquals(acc1.Id,[Select Account__c from SeihoAgentMaster__c where Id=:Agent3.Id][0].Account__c);
     
     //取引先レコード插入
     Account acc2 = createAccountTestData('001','NX00002','生保代理店');
     //Cntd 1　Status Id = 4（生保エージェントマスターレコード插入）
     SeihoAgentMaster__c Agent4 =createAgntMstrTestDataStsBased('NX00002','4','2020-09-14', '1000');
      //確認
     System.assertNotEquals(acc2.Id,[Select Account__c from SeihoAgentMaster__c where Id=:Agent4.Id][0].Account__c);
     //Cntd 2　Status Id = 4 prioritise based on Latest date
     SeihoAgentMaster__c Agent5 =createAgntMstrTestDataStsBased('NX00002','4','2020-09-15', '1000');
     //確認
     System.assertNotEquals(acc2.Id,[Select Account__c from SeihoAgentMaster__c where Id=:Agent5.Id][0].Account__c);
     //Cntd 2　Status Id = 4 prioritise based on Latest AgentId
     SeihoAgentMaster__c Agent6 =createAgntMstrTestDataStsBased('NX00002','4','2020-09-15', '1001');
     //確認
     System.assertNotEquals(acc2.Id,[Select Account__c from SeihoAgentMaster__c where Id=:Agent6.Id][0].Account__c);
     
     //生保エージェントマスターレコード更新部分
     //取引先レコード插入
     Account acc3 = createAccountTestData('001','NX00003','生保代理店');
     //生保エージェントマスターレコード插入
     Agent1.CS_ID__c ='NX00003';update Agent1;
     //確認
     System.assertNotEquals(acc3.Id,[Select Account__c from SeihoAgentMaster__c where Id=:Agent1.Id][0].Account__c);
     Agent2.CS_ID__c ='NX00003';update Agent2;
     //確認
     System.assertNotEquals(acc3.Id,[Select Account__c from SeihoAgentMaster__c where Id=:Agent2.Id][0].Account__c);
     Agent3.CS_ID__c ='NX00003';update Agent3;
     //確認
     System.assertNotEquals(acc3.Id,[Select Account__c from SeihoAgentMaster__c where Id=:Agent3.Id][0].Account__c);
     Agent4.CS_ID__c ='NX00003';update Agent4;
     //確認
     System.assertNotEquals(acc3.Id,[Select Account__c from SeihoAgentMaster__c where Id=:Agent4.Id][0].Account__c);
     Agent5.CS_ID__c ='NX00003';update Agent5;
     //確認
     System.assertNotEquals(acc3.Id,[Select Account__c from SeihoAgentMaster__c where Id=:Agent5.Id][0].Account__c);
     Agent6.CS_ID__c ='NX00003';update Agent6;
     //確認
     System.assertNotEquals(acc3.Id,[Select Account__c from SeihoAgentMaster__c where Id=:Agent6.Id][0].Account__c);
     
    }
    private static Account createAccountTestData(String identifier,String csId, String classification){

        Account acc = new Account(
            FirstName = 'user_' + identifier,
            LastName = 'Test',
            furiganaForst__pc = 'ユーザー_' + identifier,
            furiganaLast__pc = 'テスト',
            Gender__pc = '男性',
            CSID__pc = csId,
            SeihoAgentMstId__c = null,
            SeihoAccoutType__c = classification,
            SeihoAgentID__c = null
        );
        insert acc;

        return acc;
    }
    
    private static SeihoAgentMaster__c createAgentMasterTestData(String csId, String bankCode, String branchCode){

        SeihoAgentMaster__c agent = new SeihoAgentMaster__c(
            Name = 'Test User_1',
            CS_ID__c = csId,
            AGENT_ID__c = 'AG00001',
            BELONG_AGENT__c = 'AG00001',
            SeihoAgentParentFlag__c = false,
            MEMBER_ID_SEQ__c = 'AG00007',
            Account__c = null,
            OLD_AGENT_ID__c ='AG00001',
            BANK_CODE__c = bankCode,
            BRANCH_CODE__c = branchCode,
            BankName__c = null,
            BranchName__c = null,
            AGENT_STATUS_DID__c='3', //ステータス条件のため追加
            REGISTRATION_DATE__c='2020-09-14'//ステータス条件のため追加
        );
        insert agent;

        return agent;
    }
       //ステータス条件のため追加
       private static SeihoAgentMaster__c createAgntMstrTestDataStsBased(String csId, String statusCode, String regDate,String AgntID){
       
        SeihoAgentMaster__c agent = new SeihoAgentMaster__c(
            Name = 'Test User_1',
            CS_ID__c = csId,
            BELONG_AGENT__c = 'AG00001',
            SeihoAgentParentFlag__c = false,
            MEMBER_ID_SEQ__c = 'AG00007',
            Account__c = null,
            OLD_AGENT_ID__c ='AG00001',
            AGENT_STATUS_DID__c=statusCode, 
            REGISTRATION_DATE__c=(statusCode=='3')?regDate:null,
            ANNIHILATION_DATE__c=(statusCode=='4')?regDate:null,
            AGENT_ID__c=AgntID
        );
        insert agent;

        return agent;
    }

    private static BankMaster__c createBankMasterTestData(String bankCode, String branchCode){

        BankMaster__c bm = new BankMaster__c(
            BankCode__c = bankCode,
            BranchCode__c = branchCode,
            BankName__c = 'Bank1',
            BranchName__c = 'Branch1'
        );
        insert bm;

        return bm;
    }

    private static BankMaster__c setBankBranchName1(String bankCode, String branchCode){

        BankMaster__c bm = new BankMaster__c(
            BankCode__c = bankCode,
            BranchCode__c = branchCode,
            BankName__c = 'Bank2',
            BranchName__c = 'Branch2'
        );
        insert bm;

        return bm;
    }

}