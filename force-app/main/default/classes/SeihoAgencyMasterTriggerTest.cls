/*
* @Class Name      : SeihoAgencyMasterTriggerTest 
* @Description     : 生保代理店トリガのテストクラス
* @Created Date    : 2020.05.29
* @Created By      : SRM
* @Modified Date   : 2020.06.18
* @Modified        : SRM
*/
@isTest
private class SeihoAgencyMasterTriggerTest {

  @isTest
    static void setCsidChangeFlag(){
       
        SeihoAgencyMaster__c agency = createAgencyMasterTestData('NX00001', 'AG00001','BC01', 'BR1');
       
        //tantoupbragncyno existence verification (所属代理店の存在チェック)
        System.assertEquals(True,[SELECT Id, CSID_ChangeFlag__c FROM SeihoAgencyMaster__c WHERE ID =: agency.Id][0].CSID_ChangeFlag__c);
       test.startTest();
        agency.csid__c = 'NX00002';
        update agency;
        test.stopTest();
        System.assertEquals(true,[SELECT Id, CSID_ChangeFlag__c FROM SeihoAgencyMaster__c WHERE Id =: agency.Id][0].CSID_ChangeFlag__c);
        //System.assertEquals(false,[SELECT Id, AgencyNameFlag__c FROM SeihoAgencyMaster__c WHERE Id =: agency.Id][0].AgencyNameFlag__c);
    }
    
    @isTest
    static void insertRecordSetCsidChangeFlag(){
       test.startTest();
        SeihoAgencyMaster__c agency = createAgencyMasterTestData('NX00001', 'AG00001','BC01', 'BR1');
       test.stopTest();
        //tantoupbragncyno existence verification (所属代理店の存在チェック)
        System.assertEquals(True,[SELECT Id, CSID_ChangeFlag__c FROM SeihoAgencyMaster__c WHERE ID =: agency.Id][0].CSID_ChangeFlag__c);
          }    
           
    @isTest
    static void setAccountReference(){
        Account acc = createAccountTestData('001','NX00001','');
        SeihoAgencyMaster__c agency = createAgencyMasterTestData('NX00001', 'AG00001','BC01', 'BR1');
        
        //AgencyId verification in Account
        System.assertNotEquals(agency.Id,[SELECT Id, SeihoAgencyMstId__c FROM Account WHERE CSID__pc =: agency.csid__c][0].SeihoAgencyMstId__c);
        //Agency Number verification in Account
        System.assertNotEquals(agency.agncyno__c,[SELECT Id, SeihoAgencyNo__c FROM Account WHERE CSID__pc =: agency.csid__c][0].SeihoAgencyNo__c);
        //Account Type verification in Account (blank to value)
    System.assertNotEquals('生保代理店', [SELECT Id, SeihoAccoutType__c FROM Account WHERE CSID__pc =: agency.csid__c][0].SeihoAccoutType__c);

        //Master verification
        System.assertNotEquals(acc.Id,[SELECT Id, Account__c FROM SeihoAgencyMaster__c WHERE ID =: agency.Id][0].Account__c);

        Account acc1 = createAccountTestData('002','NX00002','生保代理店');
        SeihoAgencyMaster__c agency1 = createAgencyMasterTestData('NX00002', 'AG00002','BC01', 'BR1');
        
        //Account Type verification in Account (生保代理店　already exists so no change in account type)
        System.assertEquals(1,(acc1.SeihoAccoutType__c).countMatches('生保代理店'));

        Account acc2 = createAccountTestData('003','NX00003','生保契約者;生保エージェント');
        SeihoAgencyMaster__c agency2 = createAgencyMasterTestData('NX00003', 'AG00003','BC01', 'BR1');
                
        //Account Type verification in Account (生保代理店 added)
        System.assertEquals(true, (acc2.SeihoAccoutType__c).containsIgnoreCase('生保エージェント'));
    }

    @isTest
    static void setAgencyMasterFlag(){
        Account acc = createAccountTestData('001','NX00001','生保代理店');
        SeihoAgencyMaster__c agency = createAgencyMasterTestData('NX00001', 'AG00001','BC01', 'BR1');
       
        //tantoupbragncyno existence verification (所属代理店の存在チェック)
        System.assertEquals(true,[SELECT Id, AgencyNameFlag__c FROM SeihoAgencyMaster__c WHERE ID =: agency.Id][0].AgencyNameFlag__c);
        agency.tantoupbragncyno__c = null;
        update agency;
        System.assertEquals(null,[SELECT Id, SeihoAgencyIkusei__c FROM SeihoAgencyMaster__c WHERE Id =: agency.Id][0].SeihoAgencyIkusei__c);
        System.assertEquals(false,[SELECT Id, AgencyNameFlag__c FROM SeihoAgencyMaster__c WHERE Id =: agency.Id][0].AgencyNameFlag__c);
    }

    @isTest
    static void updateAccountReferenceValueToValue(){
        Account acc1 = createAccountTestData('001','NX00001','生保代理店');      
        SeihoAgencyMaster__c agency = createAgencyMasterTestData('NX00001', '1','BC01', 'BR1');
        
        Id b4UpdateAccIdInMaster = [SELECT Id, Account__c FROM SeihoAgencyMaster__c WHERE ID =: agency.Id][0].Account__c;
        Id b4UpdateAgencyIdInAccnt = [SELECT Id, SeihoAgencyMstId__c FROM Account WHERE CSID__pc =: agency.csid__c][0].SeihoAgencyMstId__c;

        SeihoAgencyMaster__c agency1 = createAgencyMasterTestData('NX00002', '2','BC01', 'BR1');
        agency.csid__c = 'NX00002';
        test.startTest();
        update agency;
        Account acc2 = createAccountTestData('002','NX00002','生保代理店');

        test.stoptest();

        //Master verification
        System.assertEquals(b4UpdateAccIdInMaster,[SELECT Id, Account__c FROM SeihoAgencyMaster__c WHERE ID =: agency.Id][0].Account__c);
        //Account Type verification in Account
        System.assertEquals(true,(acc2.SeihoAccoutType__c).containsIgnoreCase('生保代理店'));
        //Agency Number verification in Account
        System.assertNotEquals(agency1.agncyno__c,[SELECT Id, SeihoAgencyNo__c FROM Account WHERE CSID__pc =: agency.csid__c][0].SeihoAgencyNo__c);        
        //Agency ID verification in Account
        System.assertNotEquals(agency1.Id,[SELECT Id, SeihoAgencyMstId__c FROM Account WHERE CSID__pc =: agency.csid__c][0].SeihoAgencyMstId__c);
    }

    @isTest
    static void updateAccountReferenceNullToValue(){
        SeihoAgencyMaster__c agency = createAgencyMasterTestData(null, 'AG00001','BC01', 'BR1');
        
        Id b4UpdateAccIdInMaster = [SELECT Id, Account__c FROM SeihoAgencyMaster__c WHERE ID =: agency.Id][0].Account__c;

        Account acc = createAccountTestData('002','NX00002','生保代理店');
        //SeihoAgencyMaster__c agency1 = createAgencyMasterTestData('NX00002', 'AG00002','BC01', 'BR1');
        agency.csid__c = 'NX00002';
        test.startTest();
        update agency;
        test.stoptest();

        //Master verification
        System.assertEquals(b4UpdateAccIdInMaster,[SELECT Id, Account__c FROM SeihoAgencyMaster__c WHERE ID =: agency.Id][0].Account__c);
        System.assertNotEquals(acc.Id,[SELECT Id, Account__c FROM SeihoAgencyMaster__c WHERE ID =: agency.Id][0].Account__c);
        //Account Type verification in Account
        System.assertEquals(true,(acc.SeihoAccoutType__c).containsIgnoreCase('生保代理店'));
        //Agency Number verification in Account
        System.assertNotEquals(agency.agncyno__c,[SELECT Id, SeihoAgencyNo__c FROM Account WHERE CSID__pc =: agency.csid__c][0].SeihoAgencyNo__c);        
        //Agency ID verification in Account
        System.assertNotEquals(agency.Id,[SELECT Id, SeihoAgencyMstId__c FROM Account WHERE CSID__pc =: agency.csid__c][0].SeihoAgencyMstId__c);
    }

    @isTest
    static void updateAccountReferenceValueToNull(){
        Account acc = createAccountTestData('001','NX00001','生保代理店');      
        SeihoAgencyMaster__c agency = createAgencyMasterTestData('NX00001', 'AG00001','BC01', 'BR1');
        
        Id b4UpdateAccIdInMaster = [SELECT Id, Account__c FROM SeihoAgencyMaster__c WHERE csid__c =: acc.CSID__pc][0].Account__c;
        Id b4UpdateAgencyIdInAccnt = [SELECT Id, SeihoAgencyMstId__c FROM Account WHERE CSID__pc =: agency.csid__c][0].SeihoAgencyMstId__c;
        String b4UpdateAgencyNoInAccnt=[SELECT Id, SeihoAgencyNo__c FROM Account WHERE CSID__pc =: agency.csid__c][0].SeihoAgencyNo__c;

        agency.csid__c = null;
        test.startTest();
        update agency;
        test.stoptest();

        //Master verification
        System.assertEquals(b4UpdateAccIdInMaster,[SELECT Id, Account__c FROM SeihoAgencyMaster__c WHERE ID =: agency.Id][0].Account__c);
        //Account Type-Account verification
        System.assertEquals(true,(acc.SeihoAccoutType__c).containsIgnoreCase('生保代理店'));
        //Agency Number-Account verification
        System.assertEquals(null,[SELECT Id, SeihoAgencyNo__c FROM Account WHERE Id =: acc.Id][0].SeihoAgencyNo__c);        
        //Agency ID-Account verification
        String x=[SELECT Id, SeihoAgencyMstId__c FROM Account WHERE Id =: acc.id][0].SeihoAgencyMstId__c;
        System.assertEquals(null,x);

    }
    
    @isTest
    static void noRelatedAccount(){
        Account acc = createAccountTestData('001','NX00002','生保代理店');
        SeihoAgencyMaster__c agency = createAgencyMasterTestData('NX00001','AG00001', 'BC01', 'BR1');
        List<Account> accountList = [SELECT Id, SeihoAgencyMstId__c FROM Account WHERE CSID__pc =: agency.csid__c];
        System.assertEquals(0,accountList.size());
    }
    
    @isTest
    static void setBankBranchName(){
        Account acc = createAccountTestData('001','NX00001','生保代理店');
        BankMaster__c bankMaster = createBankMasterTestData('BC01', 'BR1');
        SeihoAgencyMaster__c agency = createAgencyMasterTestData('NX00001', 'AG00001','BC01', 'BR1');
        
       System.assertEquals(bankMaster.BankName__c,[SELECT Id, Account__c,HurikomiBank__c FROM SeihoAgencyMaster__c WHERE ID =: agency.Id][0].HurikomiBank__c);
       System.assertEquals(bankMaster.BranchName__c,[SELECT Id, Account__c,HurikomiBranch__c FROM SeihoAgencyMaster__c WHERE ID =: agency.Id][0].HurikomiBranch__c);
    }
   
    @isTest
    static void updateBankBranchCodesToNull(){
        Account acc = createAccountTestData('001','NX00001','生保代理店');
        BankMaster__c bankMaster = createBankMasterTestData('BC01', 'BR1');
        SeihoAgencyMaster__c agency = createAgencyMasterTestData('NX00001', 'AG00001','BC01', 'BR1');
        agency.cmmsspymnbankcd__c = null;
        agency.cmmsspymnbrnchcd__c = null;
        test.startTest();
        update agency;
        test.stoptest();
        System.assertEquals(null, agency.HurikomiBank__c);
        System.assertEquals(null, agency.HurikomiBranch__c);               
    }

    @isTest
    static void updateBankBranchCodesValueToValue(){
        Account acc = createAccountTestData('001','NX00001','生保代理店');
        BankMaster__c bankMaster1 = createBankMasterTestData('BC02', 'BR2');
        SeihoAgencyMaster__c agency = createAgencyMasterTestData('NX00001', 'AG00001','BC01', 'BR1');
        String b4UpdateBankNameInMaster=[SELECT Id, HurikomiBank__c FROM SeihoAgencyMaster__c WHERE Id =: agency.Id][0].HurikomiBank__c;
        String b4UpdateBranchNameInMaster=[SELECT Id, HuriKomiBranch__c FROM SeihoAgencyMaster__c WHERE Id =: agency.Id][0].HuriKomiBranch__c;
        //BankMaster__c bankMaster2 = setBankBranchName1('BC02', 'BR2');
        agency.cmmsspymnbankcd__c = 'BC02';
        agency.cmmsspymnbrnchcd__c = 'BR2';
        
        test.startTest();
        update agency;
        test.stoptest();
        System.assertEquals(bankMaster1.BankName__c,[SELECT Id, Account__c,HurikomiBank__c FROM SeihoAgencyMaster__c WHERE ID =: agency.Id][0].HurikomiBank__c);
        System.assertEquals(bankMaster1.BranchName__c,[SELECT Id, Account__c,HurikomiBranch__c FROM SeihoAgencyMaster__c WHERE ID =: agency.Id][0].HurikomiBranch__c);
        System.assertNotEquals(b4UpdateBankNameInMaster, [SELECT Id, Account__c,HurikomiBank__c FROM SeihoAgencyMaster__c WHERE ID =: agency.Id][0].HurikomiBank__c);   
        System.assertNotEquals(b4UpdateBranchNameInMaster, [SELECT Id, Account__c,HurikomiBranch__c FROM SeihoAgencyMaster__c WHERE ID =: agency.Id][0].HurikomiBranch__c);  
    }
    
    static testmethod void createAgncyRecStsBased(){
     //生保エージェントマスターレコード插入部分
     //取引先レコード插入
     Account acc1 = createAccountTestData('001','NX00001','生保代理店');
     Account acc2 = createAccountTestData('001','NX00002','生保代理店');
     Account acc4 = createAccountTestData('001','NX00004','生保代理店');
     Account acc3 = createAccountTestData('001','NX00003','生保代理店');
     Test.startTest();
     //Cntd 1　Status Id = 3（生保エージェントマスターレコード插入）
     SeihoAgencyMaster__c Agncy1 =createAgncyMstTestDataStsBased('NX00001','3','2020-09-14', '1000');
     SeihoAgencyMaster__c Agncy2 =createAgncyMstTestDataStsBased('NX00001','3','2020-09-15', '1001');
     SeihoAgencyMaster__c Agncy3 =createAgncyMstTestDataStsBased('NX00001','3','2020-09-15', '1002');
     SeihoAgencyMaster__c Agncy4 =createAgncyMstTestDataStsBased('NX00002','1','2020-09-14', '1003');
     SeihoAgencyMaster__c Agncy5 =createAgncyMstTestDataStsBased('NX00002','1','2020-09-15', '1004');
     SeihoAgencyMaster__c Agncy6 =createAgncyMstTestDataStsBased('NX00002','1','2020-09-15', '1005');
     SeihoAgencyMaster__c Agncy7 =createAgncyMstTestDataStsBased('NX00004','4','2020-09-14', '1006');
     SeihoAgencyMaster__c Agncy8 =createAgncyMstTestDataStsBased('NX00004','4','2020-09-15', '1007');
     SeihoAgencyMaster__c Agncy9 =createAgncyMstTestDataStsBased('NX00004','4','2020-09-15', '1008');
     Test.stopTest();
     
      //確認
     System.assertNotEquals(acc1.Id,[Select Account__c from SeihoAgencyMaster__c where Id=:Agncy1.Id][0].Account__c);
    
      //確認
     System.assertNotEquals(acc1.Id,[Select Account__c from SeihoAgencyMaster__c where Id=:Agncy2.Id][0].Account__c);
      //確認
     System.assertNotEquals(acc1.Id,[Select Account__c from SeihoAgencyMaster__c where Id=:Agncy3.Id][0].Account__c);
      //確認
     System.assertNotEquals(acc2.Id,[Select Account__c from SeihoAgencyMaster__c where Id=:Agncy4.Id][0].Account__c);
     
     //確認
     System.assertNotEquals(acc2.Id,[Select Account__c from SeihoAgencyMaster__c where Id=:Agncy5.Id][0].Account__c);
     
     //確認
     System.assertNotEquals(acc2.Id,[Select Account__c from SeihoAgencyMaster__c where Id=:Agncy6.Id][0].Account__c);
      //確認
     System.assertNotEquals(acc4.Id,[Select Account__c from SeihoAgencyMaster__c where Id=:Agncy7.Id][0].Account__c);
      //確認
     System.assertNotEquals(acc4.Id,[Select Account__c from SeihoAgencyMaster__c where Id=:Agncy8.Id][0].Account__c);
     //確認
     System.assertNotEquals(acc4.Id,[Select Account__c from SeihoAgencyMaster__c where Id=:Agncy9.Id][0].Account__c);
     
     //生保エージェントマスターレコード更新部分
     Agncy1.csid__c ='NX00003';update Agncy1;
     //確認
     System.assertNotEquals(acc3.Id,[Select Account__c from SeihoAgencyMaster__c where Id=:Agncy1.Id][0].Account__c);
     Agncy2.csid__c ='NX00003';update Agncy2;
     //確認
     System.assertNotEquals(acc3.Id,[Select Account__c from SeihoAgencyMaster__c where Id=:Agncy2.Id][0].Account__c);
     Agncy3.csid__c ='NX00003';update Agncy3;
     //確認
     System.assertNotEquals(acc3.Id,[Select Account__c from SeihoAgencyMaster__c where Id=:Agncy3.Id][0].Account__c);
     Agncy4.csid__c ='NX00003';update Agncy4;
     //確認
     System.assertNotEquals(acc3.Id,[Select Account__c from SeihoAgencyMaster__c where Id=:Agncy4.Id][0].Account__c);
     Agncy5.csid__c ='NX00003';update Agncy5;
     //確認
     System.assertNotEquals(acc3.Id,[Select Account__c from SeihoAgencyMaster__c where Id=:Agncy5.Id][0].Account__c);
     Agncy6.csid__c ='NX00003';update Agncy6;
     //確認
     System.assertNotEquals(acc3.Id,[Select Account__c from SeihoAgencyMaster__c where Id=:Agncy6.Id][0].Account__c);
     Agncy7.csid__c ='NX00003';update Agncy7;
     //確認
     System.assertNotEquals(acc3.Id,[Select Account__c from SeihoAgencyMaster__c where Id=:Agncy7.Id][0].Account__c);
     Agncy8.csid__c ='NX00003';update Agncy8;
     //確認
     System.assertNotEquals(acc3.Id,[Select Account__c from SeihoAgencyMaster__c where Id=:Agncy8.Id][0].Account__c);
     Agncy9.csid__c ='NX00003';update Agncy9;
     //確認
     System.assertNotEquals(acc3.Id,[Select Account__c from SeihoAgencyMaster__c where Id=:Agncy9.Id][0].Account__c);
     
    }

           
    private static Account createAccountTestData(String identifier,String csId, String classification){

        Account acc = new Account(

            FirstName = 'user_' + identifier,
            LastName = 'Test',
            furiganaForst__pc = 'ユーザー_' + identifier,
            furiganaLast__pc = 'テスト',
            Gender__pc = '男性',
            CSID__pc = csId,
            SeihoAgencyMstId__c = null, 
            SeihoAccoutType__c = classification,
            SeihoAgencyNo__c = null
            
        );
        insert acc;

        return acc;
    }
    
    private static SeihoAgencyMaster__c createAgencyMasterTestData(String csId, String agencyNumber, String bankCode, String branchCode){

        SeihoAgencyMaster__c agency = new SeihoAgencyMaster__c(

            agncyno__c = agencyNumber,
            agncynmkn__c = 'SeihoAgency_001', //カナ 
            agncynmkj__c = 'SeihoAgency_001', //漢字
            tantoupbragncyno__c='AG00008',
            csid__c = csId,
            Account__c = null,
            cmmsspymnbankcd__c = bankCode,
            cmmsspymnbrnchcd__c = branchCode,
            HurikomiBank__c = null,
            HurikomiBranch__c = null,
            agncyrgstymd__c = Date.ValueOf('2020-09-14'),//ステータス条件のため追加
            agncysts__c='3' //ステータス条件のため追加
        );
        insert agency;

        return agency;
    }
    
    private static BankMaster__c createBankMasterTestData(String bankCode, String branchCode){

        BankMaster__c bankMaster = new BankMaster__c( 
            BankCode__c = bankCode,
            BranchCode__c = branchCode,
            BankName__c = 'Bank1',
            BranchName__c = 'Branch1'
        );
        insert bankMaster;

        return bankMaster;
    }

    private static BankMaster__c setBankBranchName1(String bankCode, String branchCode){

        BankMaster__c bm=new BankMaster__c(
        BankCode__c='BC02',
            BranchCode__c='BR2',
           BankName__c='Bank2',
            BranchName__c='Branch2'
        );
        insert bm;
        return bm;
    }
    private static SeihoAgencyMaster__c createAgncyMstTestDataStsBased(String csId, String statusCode, String regDate,String RecID){
    SeihoAgencyMaster__c Agency = new SeihoAgencyMaster__c(
        //Name = 'AGENCY_001',
        csid__c = csId,
        tantoupbragncyno__c = null,
        agncyno__c = RecID,
        agncyrgstymd__c=(statusCode=='3'||statusCode=='1' )?Date.ValueOf(regDate):null,
        clsymd__c=(statusCode=='4')?Date.ValueOf(regDate):null,
        agncysts__c= statusCode
    );
    insert Agency;
    return Agency;
    }

}