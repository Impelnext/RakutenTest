@isTest
private class SeihoRecruiterMasterTriggerTest{
   @isTest
    static void setCsidChangeFlag(){
       
        SeihoRecruiterMaster__c recruiter = createRecruiterMasterTestData('NX00001');
       
        //tantoupbragncyno existence verification (所属代理店の存在チェック)
        System.assertEquals(True,[SELECT Id, CSID_ChangeFlag__c FROM SeihoRecruiterMaster__c WHERE ID =: recruiter.Id][0].CSID_ChangeFlag__c);
       test.startTest();
        recruiter.cs_id__c = 'NX00002';
        update recruiter;
        test.stopTest();
        System.assertEquals(true,[SELECT Id, CSID_ChangeFlag__c FROM SeihoRecruiterMaster__c WHERE Id =: recruiter.Id][0].CSID_ChangeFlag__c);
        //System.assertEquals(false,[SELECT Id, AgencyNameFlag__c FROM SeihoAgencyMaster__c WHERE Id =: agency.Id][0].AgencyNameFlag__c);
    }
    @isTest
    static void InsertRecordsetCsidChangeFlag(){
       test.startTest();
        SeihoRecruiterMaster__c recruiter = createRecruiterMasterTestData('NX00001');
       test.stopTest();
        //tantoupbragncyno existence verification (所属代理店の存在チェック)
        System.assertEquals(True,[SELECT Id, CSID_ChangeFlag__c FROM SeihoRecruiterMaster__c WHERE ID =: recruiter.Id][0].CSID_ChangeFlag__c);
       
        
        
        //System.assertEquals(true,[SELECT Id, CSID_ChangeFlag__c FROM SeihoRecruiterMaster__c WHERE Id =: recruiter.Id][0].CSID_ChangeFlag__c);
        //System.assertEquals(false,[SELECT Id, AgencyNameFlag__c FROM SeihoAgencyMaster__c WHERE Id =: agency.Id][0].AgencyNameFlag__c);
    }
    @isTest
    static void setAccountReference(){
        
        Account acc = createAccountTestData('001','NX00001','',null);
        SeihoRecruiterMaster__c recruiter = createRecruiterMasterTestData('NX00001');
        
        //Recruiter Id verification in Account
        System.assertNotEquals(recruiter.Id,[SELECT Id, SeihoRecruiterMstId__c FROM Account WHERE CSID__pc =: recruiter.CS_ID__c][0].SeihoRecruiterMstId__c);
        //Recruiter Number verification in Account 
        System.assertNotEquals(recruiter.RECRUITER_NUMBER__c,[SELECT Id, SeihoRecruiterNo__c FROM Account WHERE CSID__pc =: recruiter.CS_ID__c][0].SeihoRecruiterNo__c);
        //Account Type verification in Account (blank to value)
        System.assertNotEquals('生保募集人', [SELECT Id, SeihoAccoutType__c FROM Account WHERE CSID__pc =: recruiter.CS_ID__c][0].SeihoAccoutType__c);
        
        //Master verification
        System.assertNotEquals(acc.Id,[SELECT Id, Account__c FROM SeihoRecruiterMaster__c WHERE ID =: recruiter.Id][0].Account__c);
        
        Account acc1 = createAccountTestData('002','NX00002','生保募集人',null);
        SeihoRecruiterMaster__c recruiter1 = createRecruiterMasterTestData('NX00002');
        
        //Account Type verification in Account (生保代理店　already exists so no change in account type)
        System.assertEquals(1,(acc1.SeihoAccoutType__c).countMatches('生保募集人'));
        
        Account acc2 = createAccountTestData('003','NX00003','生保契約者;生保エージェント',null);
        SeihoRecruiterMaster__c recruiter2 = createRecruiterMasterTestData('NX00003');
        
        //Account Type verification in Account (生保募集人 added)
        System.assertEquals(true,(acc2.SeihoAccoutType__c).containsIgnoreCase('生保エージェント'));
    }
    
    @isTest
    static void setAgencyMasterReference(){
        SeihoAgencyMaster__c agency = createAgencyMasterTestData();
        Account acc = createAccountTestData('001','NX00001', '生保募集人',null);
        SeihoRecruiterMaster__c recruiter = createRecruiterMasterTestData('NX00001');
        //AgencyMaster reference verification
        System.assertEquals(agency.Id,[SELECT Id, SeihoAgencyMasterName__c FROM SeihoRecruiterMaster__c WHERE ID =: recruiter.Id][0].SeihoAgencyMasterName__c);
        recruiter.AGENCY_NUMBER__c = null;
        update recruiter;
        //AgencyMaster reference verification for null agency number
        System.assertEquals(null,[SELECT Id, SeihoAgencyMasterName__c FROM SeihoRecruiterMaster__c WHERE ID =: recruiter.Id][0].SeihoAgencyMasterName__c);
        
    }
    
    @isTest
    static void updateAccountReferenceValueToValue(){
        
        Account acc1 = createAccountTestData('001','NX00001', '生保募集人',null);        
        SeihoRecruiterMaster__c recruiter = createRecruiterMasterTestData('NX00001');
        
        Id b4UpdateAccIdInMaster = [SELECT Id, Account__c FROM SeihoRecruiterMaster__c WHERE ID =: recruiter.Id][0].Account__c;
        Id b4UpdateRecruiterIdInAccnt = [SELECT Id, SeihoRecruiterMstId__c FROM Account WHERE CSID__pc =: recruiter.CS_ID__c][0].SeihoRecruiterMstId__c;
        
        Account acc2 = createAccountTestData('002','NX00002','生保募集人',null);
        recruiter.CS_ID__c = 'NX00002';
        
        test.startTest();
        update recruiter;
        test.stoptest();
        //Master verification
        System.assertEquals(b4UpdateAccIdInMaster,[SELECT Id, Account__c FROM SeihoRecruiterMaster__c WHERE ID =: recruiter.Id][0].Account__c);
        System.assertNotEquals(acc2.Id,[SELECT Id, Account__c FROM SeihoRecruiterMaster__c WHERE ID =: recruiter.Id][0].Account__c);
        //Account Type verification in Account
        System.assertEquals(true,(acc2.SeihoAccoutType__c).containsIgnoreCase('生保募集人'));
        //Recruiter Number verification in Account
        System.assertNotEquals(recruiter.RECRUITER_NUMBER__c,[SELECT Id, SeihoRecruiterNo__c FROM Account WHERE CSID__pc =: recruiter.CS_ID__c][0].SeihoRecruiterNo__c);
        //Recruiter ID verification in Account
        System.assertNotEquals(recruiter.Id,[SELECT Id, SeihoRecruiterMstId__c FROM Account WHERE CSID__pc =: recruiter.CS_ID__c][0].SeihoRecruiterMstId__c);
        System.assertEquals(b4UpdateRecruiterIdInAccnt,[SELECT Id, SeihoRecruiterMstId__c FROM Account WHERE CSID__pc =: recruiter.CS_ID__c][0].SeihoRecruiterMstId__c);
    }
    
    @isTest
    static void updateAccountReferenceNullToValue(){
        
        SeihoRecruiterMaster__c recruiter = createRecruiterMasterTestData(null);
        Id b4UpdateAccIdInMaster = [SELECT Id, Account__c FROM SeihoRecruiterMaster__c WHERE ID =: recruiter.Id][0].Account__c;
        Account acc = createAccountTestData('002','NX00002','生保募集人',null);
        recruiter.CS_ID__c = 'NX00002';
        
        test.startTest();
        update recruiter;
        test.stoptest();
        
        //Master verification
        System.assertEquals(b4UpdateAccIdInMaster,[SELECT Id, Account__c FROM SeihoRecruiterMaster__c WHERE ID =: recruiter.Id][0].Account__c);
        System.assertNotEquals(acc.Id,[SELECT Id, Account__c FROM SeihoRecruiterMaster__c WHERE ID =: recruiter.Id][0].Account__c);
        //Account Type verification in Account
        System.assertEquals(true,(acc.SeihoAccoutType__c).containsIgnoreCase('生保募集人'));
        //Recruiter Number verification in Account
        System.assertNotEquals(recruiter.RECRUITER_NUMBER__c,[SELECT Id, SeihoRecruiterNo__c FROM Account WHERE CSID__pc =: recruiter.CS_ID__c][0].SeihoRecruiterNo__c);
        //Recruiter ID verification in Account
        System.assertNotEquals(recruiter.Id,[SELECT Id, SeihoRecruiterMstId__c FROM Account WHERE CSID__pc =: recruiter.CS_ID__c][0].SeihoRecruiterMstId__c);
    }
    
    @isTest
    static void updateAccountReferenceValueToNull(){
        
        Account acc = createAccountTestData('001','NX00001','生保募集人',null);
        SeihoRecruiterMaster__c recruiter = createRecruiterMasterTestData('NX00001');
        
        Id b4UpdateAccIdInMaster = [SELECT Id, Account__c FROM SeihoRecruiterMaster__c WHERE ID =: recruiter.Id][0].Account__c;
        Id b4UpdateRecruiterIdInAccnt = [SELECT Id, SeihoRecruiterMstId__c FROM Account WHERE CSID__pc =: recruiter.CS_ID__c][0].SeihoRecruiterMstId__c;
        String b4UpdateRecruiterNoInAccnt=[SELECT Id, SeihoRecruiterNo__c FROM Account WHERE CSID__pc =: recruiter.CS_ID__c][0].SeihoRecruiterNo__c;
        
        recruiter.CS_ID__c = null;
        
        test.startTest();
        update recruiter;
        test.stoptest();
        //Master verification
        System.assertEquals(b4UpdateAccIdInMaster,[SELECT Id, Account__c FROM SeihoRecruiterMaster__c WHERE ID =: recruiter.Id][0].Account__c);
        //Account verification
        //ID-Account verification
        String x=[SELECT Id, SeihoRecruiterMstId__c FROM Account WHERE ID =: acc.Id][0].SeihoRecruiterMstId__c;
        System.assertEquals(null,x);
        //Account Type-Account verification
        System.assertEquals(true,(acc.SeihoAccoutType__c).containsIgnoreCase('生保募集人'));
        //Recruiter Number-Account verification
        System.assertEquals(null,[SELECT Id, SeihoRecruiterNo__c FROM Account WHERE ID =: acc.Id][0].SeihoRecruiterNo__c);
    }
    
    @isTest
    static void noRelatedAccount(){
        Account acc = createAccountTestData('001','NX00002','生保募集人',null);
        SeihoRecruiterMaster__c recruiter = createRecruiterMasterTestData('NX00001');
        SeihoAgencyMaster__c agency=createAgencyMasterTestData();
        List<Account> accountList=[SELECT Id, SeihoRecruiterMstId__c FROM Account WHERE CSID__pc =: recruiter.CS_ID__c];
        System.assertEquals(0,accountList.size());
    }
    
    @isTest
    static void noRelatedAgencyMaster(){
        Account acc = createAccountTestData('001','NX00001','生保募集人',null);
        SeihoRecruiterMaster__c recruiter = createRecruiterMasterTestData('NX00001');
        List<SeihoAgencyMaster__c> agencyList=[SELECT Id, agncyno__c FROM SeihoAgencyMaster__c WHERE agncyno__c =: recruiter.AGENCY_NUMBER__c];
        
        System.assertEquals(0,agencyList.size());
    }
    
    @isTest
    static void relatedToStatus(){
        Account acc = createAccountTestData('001','NX00001',null,null);
        SeihoRecruiterMaster__c recruiter = new SeihoRecruiterMaster__c(
            Name = 'RECRUITER_001',
            CS_ID__c = 'NX00001',
            RECRUITER_NUMBER__c = '10',
            AGENCY_NUMBER__c = 'AG00001',
            SeihoAgencyMasterName__c = null,
            REGISTRATION_DATE__c='2020-09-14',
            RECRUITER_STATUS_DID__c='3',
            Account__c = null
        );
        insert recruiter;
        test.startTest();
        SeihoRecruiterMaster__c recruiter01=createRecruitersMasterTestData('NX00001');
        
        
        SeihoRecruiterMaster__c recruiter1=createRecruiterStatusMasterTestData('NX00001');
        Account acc1 = createAccountTestData('001','NX00001','生保募集人',recruiter1.Id); 
        SeihoRecruiterMaster__c recruiter2=createRecruiterStatusMasterTestData('NX00001');
        Account acc2 = createAccountTestData('001','NX00001','生保募集人',recruiter2.Id);
        SeihoRecruiterMaster__c recruiter3=createRecruiterStatusUpdateMasterTestData2('NX00001');
        Account acc3 = createAccountTestData('001','NX00001','生保募集人',recruiter3.Id);
        test.stopTest();
        Account rec=[select seihoAccoutType__c,SeihoRecruiterNo__c from Account where id=:acc.id];
        
        System.assertNotEquals(recruiter.RECRUITER_NUMBER__c,rec.SeihoRecruiterNo__c);
        // System.assertEquals(Null,acc1.SeihoRecruiterNo__c);
        
        
    }
    
    //ステータス条件のため追加
    static testmethod void createRecruRecStsBased(){
        //生保エージェントマスターレコード插入部分
        //取引先レコード插入
        
        Account acc1 = createAccountTestData('001','NX00001','生保代理店',Null);
        Account acc2 = createAccountTestData('001','NX00002','生保代理店',Null);
        Account acc4 = createAccountTestData('001','NX00004','生保代理店',Null);
        Account acc3 = createAccountTestData('001','NX00003','生保代理店',Null);
        Test.startTest();
        //Cntd 1　Status Id = 3（生保エージェントマスターレコード插入）
        SeihoRecruiterMaster__c Rec1 =createRecMstrTestDataStsBased('NX00001','3','2020-09-14', '1000');
        //確認
        SeihoRecruiterMaster__c Rec2 =createRecMstrTestDataStsBased('NX00001','3','2020-09-15', '1000');
        SeihoRecruiterMaster__c Rec3 =createRecMstrTestDataStsBased('NX00001','3','2020-09-15', '1001');
        SeihoRecruiterMaster__c Rec4 =createRecMstrTestDataStsBased('NX00002','1','2020-09-14', '1000');
        SeihoRecruiterMaster__c Rec5 =createRecMstrTestDataStsBased('NX00002','1','2020-09-15', '1000');
        SeihoRecruiterMaster__c Rec6 =createRecMstrTestDataStsBased('NX00002','1','2020-09-15', '1001');
        SeihoRecruiterMaster__c Rec7 =createRecMstrTestDataStsBased('NX00004','4','2020-09-14', '1000');
        SeihoRecruiterMaster__c Rec8 =createRecMstrTestDataStsBased('NX00004','4','2020-09-15', '1000');
        SeihoRecruiterMaster__c Rec9 =createRecMstrTestDataStsBased('NX00004','4','2020-09-15', '1001');
        Test.stopTest();
        System.assertNotEquals(acc1.Id,[Select Account__c from SeihoRecruiterMaster__c where Id=:Rec1.Id][0].Account__c);
        //Cntd 2　Status Id = 3 prioritise based on Latest date
        
        //確認
        System.assertNotEquals(acc1.Id,[Select Account__c from SeihoRecruiterMaster__c where Id=:Rec2.Id][0].Account__c);
        //Cntd 2　Status Id = 3 prioritise based on Latest AgentId
        
        //確認
        System.assertNotEquals(acc1.Id,[Select Account__c from SeihoRecruiterMaster__c where Id=:Rec3.Id][0].Account__c);
        
        //取引先レコード插入
        
        //Cntd 1　Status Id = 4（生保エージェントマスターレコード插入）
        
        //確認
        System.assertNotEquals(acc2.Id,[Select Account__c from SeihoRecruiterMaster__c where Id=:Rec4.Id][0].Account__c);
        //Cntd 2　Status Id = 4 prioritise based on Latest date
        
        //確認
        System.assertNotEquals(acc2.Id,[Select Account__c from SeihoRecruiterMaster__c where Id=:Rec5.Id][0].Account__c);
        //Cntd 2　Status Id = 4 prioritise based on Latest AgentId
        
        //確認
        System.assertNotEquals(acc2.Id,[Select Account__c from SeihoRecruiterMaster__c where Id=:Rec6.Id][0].Account__c);
        
        //Cntd 1　Status Id = 4（生保エージェントマスターレコード插入）
        
        //確認
        System.assertNotEquals(acc4.Id,[Select Account__c from SeihoRecruiterMaster__c where Id=:Rec7.Id][0].Account__c);
        //Cntd 2　Status Id = 4 prioritise based on Latest date
        //確認
        System.assertNotEquals(acc4.Id,[Select Account__c from SeihoRecruiterMaster__c where Id=:Rec8.Id][0].Account__c);
        //Cntd 2　Status Id = 4 prioritise based on Latest AgentId
        
        
        //確認
        System.assertNotEquals(acc4.Id,[Select Account__c from SeihoRecruiterMaster__c where Id=:Rec9.Id][0].Account__c);
        //生保エージェントマスターレコード更新部分
        //取引先レコード插入
        
        //生保エージェントマスターレコード插入
        Rec1.CS_ID__c ='NX00003';update Rec1;
        //確認
        System.assertNotEquals(acc3.Id,[Select Account__c from SeihoRecruiterMaster__c where Id=:Rec1.Id][0].Account__c);
        Rec2.CS_ID__c ='NX00003';update Rec2;
        //確認
        System.assertNotEquals(acc3.Id,[Select Account__c from SeihoRecruiterMaster__c where Id=:Rec2.Id][0].Account__c);
        Rec3.CS_ID__c ='NX00003';update Rec3;
        //確認
        System.assertNotEquals(acc3.Id,[Select Account__c from SeihoRecruiterMaster__c where Id=:Rec3.Id][0].Account__c);
        Rec4.CS_ID__c ='NX00003';update Rec4;
        //確認
        System.assertNotEquals(acc3.Id,[Select Account__c from SeihoRecruiterMaster__c where Id=:Rec4.Id][0].Account__c);
        Rec5.CS_ID__c ='NX00003';update Rec5;
        //確認
        System.assertNotEquals(acc3.Id,[Select Account__c from SeihoRecruiterMaster__c where Id=:Rec5.Id][0].Account__c);
        Rec6.CS_ID__c ='NX00003';update Rec6;
        //確認
        System.assertNotEquals(acc3.Id,[Select Account__c from SeihoRecruiterMaster__c where Id=:Rec6.Id][0].Account__c);
        Rec7.CS_ID__c ='NX00003';update Rec7;
        //確認
        System.assertNotEquals(acc3.Id,[Select Account__c from SeihoRecruiterMaster__c where Id=:Rec7.Id][0].Account__c);
        Rec8.CS_ID__c ='NX00003';update Rec8;
        //確認
        System.assertNotEquals(acc3.Id,[Select Account__c from SeihoRecruiterMaster__c where Id=:Rec8.Id][0].Account__c);
        Rec9.CS_ID__c ='NX00003';update Rec9;
        //確認
        System.assertNotEquals(acc3.Id,[Select Account__c from SeihoRecruiterMaster__c where Id=:Rec9.Id][0].Account__c);
        
    }
    
    private static Account createAccountTestData(String identifier,String csId, String classification,string masterId){
        
        Account acc = new Account(
            FirstName = 'user_' + identifier,
            LastName = 'Test',
            furiganaForst__pc = 'ユーザー_' + identifier,
            furiganaLast__pc = 'テスト',
            Gender__pc = '男性',
            CSID__pc = csId,
            SeihoRecruiterMstId__c = masterId,
            SeihoAccoutType__c=classification
        );
        insert acc;
        
        return acc;
    }
    
    private static SeihoRecruiterMaster__c createRecruiterMasterTestData(String csId ){
        
        SeihoRecruiterMaster__c recruiter = new SeihoRecruiterMaster__c(
            Name = 'RECRUITER_001',
            CS_ID__c = csId,
            RECRUITER_NUMBER__c = 'RN00001',
            AGENCY_NUMBER__c = 'AG00001',
            SeihoAgencyMasterName__c = null,
            //REGISTRATION_DATE__c=RegistrationDate,
            RECRUITER_STATUS_DID__c='3',
            Account__c = null
        );
        insert recruiter;
        
        return recruiter;
    }
    
    private static SeihoAgencyMaster__c createAgencyMasterTestData(){
        
        SeihoAgencyMaster__c agency = new SeihoAgencyMaster__c(
            agncyno__c = 'AG00001',
            agncynmkn__c = 'SeihoAgency_001', //カナ 
            agncynmkj__c = 'SeihoAgency_001'//漢字
        );
        insert agency;
        
        return agency;
    }
    
    private static SeihoAgencyMaster__c createUnrelatedAgencyMasterTestData(){
        
        SeihoAgencyMaster__c agency1 = new SeihoAgencyMaster__c(
            agncyno__c = 'AG00002',
            agncynmkn__c = 'SeihoAgency_001', //カナ 
            agncynmkj__c = 'SeihoAgency_001' //漢字 
        );
        insert agency1;
        
        return agency1;
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
        
        return recruiter1;
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
    private static SeihoRecruiterMaster__c createRecMstrTestDataStsBased(String csId, String statusCode, String regDate,String RecID){
        SeihoRecruiterMaster__c recruiter = new SeihoRecruiterMaster__c(
            Name = 'RECRUITER_001',
            CS_ID__c = csId,
            RECRUITER_NUMBER__c = RecID,
            AGENCY_NUMBER__c = 'AG00001',
            REGISTRATION_DATE__c=(statusCode=='3'||statusCode=='1' )?regDate:null,
            OUT_OF_BUSINESS_DATE__c=(statusCode=='4')?regDate:null,
            SeihoAgencyMasterName__c = null,
            RECRUITER_STATUS_DID__c=statusCode,
            Account__c = null
        );
        insert recruiter;
        return recruiter;
    }

}