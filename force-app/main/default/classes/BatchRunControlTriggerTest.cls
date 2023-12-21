/*
* @Class Name      : BatchRunControlTriggerTest 
* @Description     : バッチ起動制御トリガー（少短資料請求用のケース作成バッチ）のテストクラス
* @Created Date    : 2019.06.20
* @Created By      : 
* @Modified Date   : 
* @Modified        : 
*/

@isTest
public class BatchRunControlTriggerTest {
    
    public static boolean faliureCaseFlag = false;
    public static boolean batchExceptionFlag=false;
    public static boolean batchProcessedFlag=false;
    
    //正常にケースを作成するパタン(少短資料請求)
    @isTest
    static void createCaseRecordSyotanDoc(){
        
        Test.startTest();
        List<SyotanDocumentRequests__c> syotanDocList = CreateSyotanDocTestData(true);
        String jobId = CreateBatchRunControlData('0','BatchSyotanDocRequestCaseCreation');
        Test.stopTest();
        
        System.assertEquals('1', [SELECT ID, Status__c FROM BatchRunControl__c WHERE Name =: jobId][0].Status__c);
        Set<String> accIdSet = new Set<String>();
        for(SyotanDocumentRequests__c syotanDoc : [SELECT caseCreationFlag__c,Ref_Account__c FROM SyotanDocumentRequests__c WHERE ID IN: syotanDocList]){
            System.assertEquals(false, syotanDoc.caseCreationFlag__c);
            accIdSet.add(syotanDoc.Ref_Account__c);
        }
        Integer caseCount = [SELECT count() FROM Case WHERE AccountId IN: accIdSet];
        System.assertEquals(syotanDocList.size(), caseCount);
    }
    
    //ケースの作成にエラーが発生されるパタン（少短資料請求）
    @isTest
    static void caseCreationFailureSyotanDoc(){
        
        faliureCaseFlag = true;
        Test.startTest();
        List<SyotanDocumentRequests__c> syotanDocList = CreateSyotanDocTestData(true);
        String jobId = CreateBatchRunControlData('0','BatchSyotanDocRequestCaseCreation');
        Test.stopTest();
        
        System.assertEquals('2', [SELECT ID, Status__c FROM BatchRunControl__c WHERE Name =: jobId][0].Status__c);
        Set<String> accIdSet = new Set<String>();
        for(SyotanDocumentRequests__c syotanDoc : [SELECT caseCreationFlag__c,Ref_Account__c FROM SyotanDocumentRequests__c WHERE ID IN: syotanDocList]){
            System.assertEquals(true, syotanDoc.caseCreationFlag__c);
            accIdSet.add(syotanDoc.Ref_Account__c);
        }
        Integer caseCount = [SELECT count() FROM Case WHERE AccountId IN: accIdSet];
        System.assertEquals(0, caseCount);
    }
    
    //ケース作成バッチの対象データなしパタン（少短資料請求）
    @isTest
    static void noDataForBatchProcessSyotanDoc(){
        
        Test.startTest();
        faliureCaseFlag = false;
        List<SyotanDocumentRequests__c> syotanDocList = CreateSyotanDocTestData(false);
        String jobId = CreateBatchRunControlData('0','BatchSyotanDocRequestCaseCreation');
        Test.stopTest();
        
        System.assertEquals('0', [SELECT ID, Status__c FROM BatchRunControl__c WHERE Name =: jobId][0].Status__c);
        Set<String> accIdSet = new Set<String>();
        for(SyotanDocumentRequests__c syotanDoc : [SELECT caseCreationFlag__c,Ref_Account__c FROM SyotanDocumentRequests__c WHERE ID IN: syotanDocList]){
            System.assertEquals(false, syotanDoc.caseCreationFlag__c);
            accIdSet.add(syotanDoc.Ref_Account__c);
        }
        Integer caseCount = [SELECT count() FROM Case WHERE AccountId IN: accIdSet];
        System.assertEquals(0, caseCount);
    }
    
    //バッチ起動制御のステータス「0」以外の場合パタン（少短資料請求）
    @isTest
    static void badStatusSyotanDoc(){
        
        Test.startTest();
        faliureCaseFlag = false;
        List<SyotanDocumentRequests__c> syotanDocList = CreateSyotanDocTestData(true);
        String jobId = CreateBatchRunControlData('4','BatchSyotanDocRequestCaseCreation');
        Test.stopTest();
        
        System.assertEquals('4', [SELECT ID, Status__c FROM BatchRunControl__c WHERE Name =: jobId][0].Status__c);
        Set<String> accIdSet = new Set<String>();
        for(SyotanDocumentRequests__c syotanDoc : [SELECT caseCreationFlag__c,Ref_Account__c FROM SyotanDocumentRequests__c WHERE ID IN: syotanDocList]){
            System.assertEquals(true, syotanDoc.caseCreationFlag__c);
            accIdSet.add(syotanDoc.Ref_Account__c);
        }
        Integer caseCount = [SELECT count() FROM Case WHERE AccountId IN: accIdSet];
        System.assertEquals(0, caseCount);
    }
    
    /*
* 損保資料請求用のテストシナリオ
*/
    /*
    //正常にケースを作成するパタン(損保資料請求)
    @isTest
    static void createCaseRecordGeneralRequest(){
        
        Test.startTest();
        List<GeneralRequest__c> generalReqList = CreateGeneralReqTestData(true);
        String jobId = CreateBatchRunControlData('0','BatchGeneralRequestCaseCreation');
        Test.stopTest();
        
        System.assertEquals('1', [SELECT ID, Status__c FROM BatchRunControl__c WHERE Name =: jobId][0].Status__c);
        Set<String> accIdSet = new Set<String>();
        for(GeneralRequest__c generalReq : [SELECT caseCreationFlag__c,Ref_Account__c FROM GeneralRequest__c WHERE ID IN: generalReqList]){
            System.assertEquals(false, generalReq.caseCreationFlag__c);
            accIdSet.add(generalReq.Ref_Account__c);
        }
        Integer caseCount = [SELECT count() FROM Case WHERE AccountId IN: accIdSet];
        System.assertEquals(generalReqList.size(), caseCount);
    }
    
    //ケースの作成にエラーが発生されるパタン（損保資料請求）
    @isTest
    static void caseCreationFailureGeneralRequest(){
        
        faliureCaseFlag = true;
        Test.startTest();
        List<GeneralRequest__c> generalReqList = CreateGeneralReqTestData(true);
        String jobId = CreateBatchRunControlData('0','BatchGeneralRequestCaseCreation');
        Test.stopTest();
        
        System.assertEquals('2', [SELECT ID, Status__c FROM BatchRunControl__c WHERE Name =: jobId][0].Status__c);
        Set<String> accIdSet = new Set<String>();
        for(GeneralRequest__c generalReq : [SELECT caseCreationFlag__c,Ref_Account__c FROM GeneralRequest__c WHERE ID IN: generalReqList]){
            System.assertEquals(true, generalReq.caseCreationFlag__c);
            accIdSet.add(generalReq.Ref_Account__c);
        }
        Integer caseCount = [SELECT count() FROM Case WHERE AccountId IN: accIdSet];
        System.assertEquals(0, caseCount);
    }
    
    //ケース作成バッチの対象データなしパタン（損保資料請求）
    @isTest
    static void noDataForBatchProcessGeneralRequest(){
        
        Test.startTest();
        faliureCaseFlag = false;
        List<GeneralRequest__c> generalReqList = CreateGeneralReqTestData(false);
        String jobId = CreateBatchRunControlData('0','BatchGeneralRequestCaseCreation');
        Test.stopTest();
        
        System.assertEquals('0', [SELECT ID, Status__c FROM BatchRunControl__c WHERE Name =: jobId][0].Status__c);
        Set<String> accIdSet = new Set<String>();
        for(GeneralRequest__c generalReq : [SELECT caseCreationFlag__c,Ref_Account__c FROM GeneralRequest__c WHERE ID IN: generalReqList]){
            System.assertEquals(false, generalReq.caseCreationFlag__c);
            accIdSet.add(generalReq.Ref_Account__c);
        }
        Integer caseCount = [SELECT count() FROM Case WHERE AccountId IN: accIdSet];
        System.assertEquals(0, caseCount);
    }
    
    //バッチ起動制御のステータス「0」以外の場合パタン（損保資料請求）
    @isTest
    static void badStatusGeneralRequest(){
        
        Test.startTest();
        faliureCaseFlag = false;
        List<GeneralRequest__c> generalReqList = CreateGeneralReqTestData(true);
        String jobId = CreateBatchRunControlData('4','BatchGeneralRequestCaseCreation');
        Test.stopTest();
        
        System.assertEquals('4', [SELECT ID, Status__c FROM BatchRunControl__c WHERE Name =: jobId][0].Status__c);
        Set<String> accIdSet = new Set<String>();
        for(GeneralRequest__c generalReq : [SELECT caseCreationFlag__c,Ref_Account__c FROM GeneralRequest__c WHERE ID IN: generalReqList]){
            System.assertEquals(true, generalReq.caseCreationFlag__c);
            accIdSet.add(generalReq.Ref_Account__c);
        }
        Integer caseCount = [SELECT count() FROM Case WHERE AccountId IN: accIdSet];
        System.assertEquals(0, caseCount);
    }
    */
    //通常に損保契約の代理店コードを更新するパターン
    @isTest
    static void updateSonpoAgencyCode(){
        
        Test.startTest();
        List<AgencyMaster__c> agencyMasterList = createAgencyMasterData();
        List<DamageContract__c> damageContractList = createDamageContractData();
        String jobId = CreateBatchRunControlData('0','BatchSonpoAgencyCodeUpdate');
        Test.stopTest();
        
        System.assertEquals('1', [SELECT ID, Status__c FROM BatchRunControl__c WHERE Name =: jobId][0].Status__c);
        
        List<DamageContract__c> updatedDamageContract = [SELECT AgencyCode1__c, AgencyCode2__c, AgencyCode3__c, AgencyId1__c, AgencyId2__c, AgencyId3__c FROM DamageContract__c WHERE Id IN: damageContractList];
        for(DamageContract__c damage : updatedDamageContract){
            System.assertNotEquals(null, damage.AgencyId1__c);
            System.assertNotEquals(null, damage.AgencyId2__c);
            System.assertNotEquals(null, damage.AgencyId3__c);
        }
    }
    
    //損保契約の代理店コード更新にエラーが発生されるパターン
    @isTest
    static void updateFailureSonpoAgencyCode(){
        
        Test.startTest();
        faliureCaseFlag = true;
        List<AgencyMaster__c> agencyMasterList = createAgencyMasterData();
        List<DamageContract__c> damageContractList = createDamageContractData();
        String jobId = CreateBatchRunControlData('0','BatchSonpoAgencyCodeUpdate');
        Test.stopTest();
        
        System.assertEquals('2', [SELECT ID, Status__c FROM BatchRunControl__c WHERE Name =: jobId][0].Status__c);
        
        List<DamageContract__c> updatedDamageContract = [SELECT AgencyCode1__c, AgencyCode2__c, AgencyCode3__c, AgencyId1__c, AgencyId2__c, AgencyId3__c FROM DamageContract__c WHERE Id IN: damageContractList];
        for(DamageContract__c damage : updatedDamageContract){
            System.assertEquals(null, damage.AgencyId1__c);
            System.assertEquals(null, damage.AgencyId2__c);
            System.assertEquals(null, damage.AgencyId3__c);
        }
    }
    
    @isTest
    static void updateLifeContractBankName(){
        
        Test.startTest();
        List<BankMaster__c> bankMasterList = createBankMasterData();
        List<LifeContract__c> lifeContractList = createLifeContractTestData(bankMasterList);
        String jobId = CreateBatchRunControlData('0','BatchLifeContractBankNameUpdate');
        BatchLifeContractBankNameUpdate lifeUpdate = new BatchLifeContractBankNameUpdate(jobId,'BatchLifeContractBankNameUpdate');
        Database.executeBatch(lifeUpdate,200);
        Test.stopTest();
        
        List<LifeContract__c> updatedLifeContractList = [SELECT Id, FNANCIAL_CODE__c, FNANCIAL_NAME__c, FINANCIAL_BRANCH_CODE__c, FINANCIAL_BRANCH_NAME__c, TOTAL_INS_FINANCIAL_CODE__c, TOTAL_INS_FINANCIAL_NAME__c, 
                                                         TOTAL_INS_FINANCIAL_BRANCH_CODE__c, TOTAL_INS_FINANCIAL_BRANCH_NAME__c FROM LifeContract__c where Id IN: lifeContractList];
        
        Map<String,BankMaster__c> bankMasterMap = new Map<String,BankMaster__c>();
        for(BankMaster__c bMaster : bankMasterList){
            bankMasterMap.put(bMaster.BankCode__c + bMaster.BranchCode__c, bMaster);
        }
        
        Long startTime = Datetime.now().getTime();
        Long endTime = Datetime.now().getTime();
        while(endTime - startTime < 9000){
            endTime = Datetime.now().getTime();
        }
        
        if([SELECT Status__c FROM BatchRunControl__c WHERE Name =: jobId].get(0).Status__c == '1'){
            
            for(LifeContract__c life : updatedLifeContractList){
                if(!String.isEmpty(life.FNANCIAL_CODE__c) && !String.isEmpty(life.FINANCIAL_BRANCH_CODE__c)){
                    System.assertEquals(bankMasterMap.get(life.FNANCIAL_CODE__c + life.FINANCIAL_BRANCH_CODE__c).BankName__c, life.FNANCIAL_NAME__c);
                    System.assertEquals(bankMasterMap.get(life.FNANCIAL_CODE__c + life.FINANCIAL_BRANCH_CODE__c).BranchName__c, life.FINANCIAL_BRANCH_NAME__c);
                    System.assertEquals(bankMasterMap.get(life.TOTAL_INS_FINANCIAL_CODE__c + life.TOTAL_INS_FINANCIAL_BRANCH_CODE__c).BankName__c, life.TOTAL_INS_FINANCIAL_NAME__c);
                    System.assertEquals(bankMasterMap.get(life.TOTAL_INS_FINANCIAL_CODE__c + life.TOTAL_INS_FINANCIAL_BRANCH_CODE__c).BranchName__c, life.TOTAL_INS_FINANCIAL_BRANCH_NAME__c);
                }else{
                    System.assertEquals(null, life.FNANCIAL_NAME__c);
                    System.assertEquals(null, life.FINANCIAL_BRANCH_NAME__c);
                    System.assertEquals(null, life.TOTAL_INS_FINANCIAL_NAME__c);
                    System.assertEquals(null, life.TOTAL_INS_FINANCIAL_BRANCH_NAME__c);
                }
            }
        }
        
    }
    @isTest
    static void updateAgencyMasterSelfLookup(){
        Test.startTest();
        List<SeihoAgencyMaster__c> agencyMasterList = createAgencyMasterTestData();
        String jobId = CreateBatchRunControlData('0','BatchSeihoAgencyTrainingAgencyUpdate');
        BatchSeihoAgencyIkuseiUpdate  agencyUpdate = new BatchSeihoAgencyIkuseiUpdate(jobId,'BatchSeihoAgencyTrainingAgencyUpdate');
        Database.executeBatch(agencyUpdate,200);
        Test.stopTest();
        SeihoAgencyMaster__c updatedAgencyMasterList = [SELECT Id, tantoupbragncyno__c, AgencyNameFlag__c,SeihoAgencyIkusei__c FROM SeihoAgencyMaster__c where id=: agencyMasterList[3].id];
        System.assertEquals('1', [SELECT ID, Status__c FROM BatchRunControl__c WHERE Name =: jobId][0].Status__c);
        System.assertEquals([select id from SeihoAgencyMaster__c][2].id,[select id,SeihoAgencyIkusei__c from SeihoAgencyMaster__c ][3].SeihoAgencyIkusei__c);
        System.assertEquals(false,[select id,AgencyNameFlag__c from SeihoAgencyMaster__c ][3].AgencyNameFlag__c);
        System.assertEquals(null, [SELECT Id, ErrorMessage__c FROM BatchRunControl__c WHERE Name =: jobId][0].ErrorMessage__c);
        
        
    }    
    @isTest
    static void noRelatedParentAgencyUpdate(){
        Test.startTest();
        List<SeihoAgencyMaster__c> agencyMasterList = createAgencyMasterTestData();
        agencyMasterList[3].tantoupbragncyno__c=null;
        update agencyMasterList;
        String jobId = CreateBatchRunControlData('0','BatchSeihoAgencyTrainingAgencyUpdate');
        BatchSeihoAgencyIkuseiUpdate  agencyUpdate = new BatchSeihoAgencyIkuseiUpdate(jobId,'BatchSeihoAgencyTrainingAgencyUpdate');
        Database.executeBatch(agencyUpdate,200);
        Test.stopTest();
        System.assertEquals('1', [SELECT ID, Status__c FROM BatchRunControl__c WHERE Name =: jobId][0].Status__c);
        System.assertNotEquals([select id from SeihoAgencyMaster__c][2].id,[select id,SeihoAgencyIkusei__c from SeihoAgencyMaster__c ][3].SeihoAgencyIkusei__c);
        System.assertEquals(null,[select id,SeihoAgencyIkusei__c from SeihoAgencyMaster__c ][3].SeihoAgencyIkusei__c);
        System.assertEquals(false,[select id,AgencyNameFlag__c from SeihoAgencyMaster__c ][3].AgencyNameFlag__c);
        System.assertEquals(null, [SELECT Id, ErrorMessage__c FROM BatchRunControl__c WHERE Name =: jobId][0].ErrorMessage__c);
        
        
    }    
    @isTest
    static void updateFailureAgencyMasterSelfLookup(){
        batchExceptionFlag=true;
        
        String jobId = '';
        Test.startTest();
        List<SeihoAgencyMaster__c> agencyMasterList = createAgencyMasterTestData();
        SeihoAgencyMaster__c agencyMaster= agencyMasterList[3];
        agencyMasterList[0].agncyno__c = null;
        try{
            update agencyMaster;
            jobId = CreateBatchRunControlData('0','BatchSeihoAgencyTrainingAgencyUpdate');
            BatchSeihoAgencyIkuseiUpdate  agencyUpdate = new BatchSeihoAgencyIkuseiUpdate(jobId,'BatchSeihoAgencyTrainingAgencyUpdate');
            Database.executeBatch(agencyUpdate,200);
            Test.stopTest();
        }
        catch(Exception e)
        {
            
            
            System.assertEquals('2', [SELECT ID, Status__c FROM BatchRunControl__c WHERE Name =: jobId][0].Status__c);
            System.assertEquals(e.getMessage(), [SELECT ID, ErrorMessage__c FROM BatchRunControl__c WHERE Name =: jobId][0].ErrorMessage__c);
            System.assertEquals(false,[select id,AgencyNameFlag__c from SeihoAgencyMaster__c ][3].AgencyNameFlag__c);
            System.assertNotEquals([select id from SeihoAgencyMaster__c][2].id,[select id,SeihoAgencyIkusei__c from SeihoAgencyMaster__c ][3].SeihoAgencyIkusei__c);
            System.assertEquals(null,[select id,SeihoAgencyIkusei__c from SeihoAgencyMaster__c ][3].SeihoAgencyIkusei__c);
            
            
        }
        
    } 
    @isTest
    static void noDataForBatchProcessAgencyUpdate(){
        
        Test.startTest();
        String jobId = CreateBatchRunControlData('0','BatchSeihoAgencyTrainingAgencyUpdate');
        BatchSeihoAgencyIkuseiUpdate  agencyUpdate = new BatchSeihoAgencyIkuseiUpdate(jobId,'BatchSeihoAgencyTrainingAgencyUpdate');
        Database.executeBatch(agencyUpdate,200);
        Test.stopTest();
        System.assertEquals('0', [SELECT ID, Status__c FROM BatchRunControl__c WHERE Name =: jobId][0].Status__c);
        
    }
    @isTest
    static void badStatusAgencyUpdate(){
        
        List<SeihoAgencyMaster__c> agencyMasterList = createAgencyMasterTestData();
        String jobId = CreateBatchRunControlData('4','BatchSeihoAgencyTrainingAgencyUpdate');
        System.assertNotEquals(null,jobId);
        System.assertEquals('4', [SELECT ID, Status__c FROM BatchRunControl__c WHERE Name =: jobId][0].Status__c);
        if([SELECT Status__c FROM BatchRunControl__c WHERE Name =: jobId].get(0).Status__c == '4'){
            System.assertEquals(true,[select id,AgencyNameFlag__c from SeihoAgencyMaster__c ][3].AgencyNameFlag__c);
            System.assertNotEquals([select id from SeihoAgencyMaster__c][2].id,[select id,SeihoAgencyIkusei__c from SeihoAgencyMaster__c ][3].SeihoAgencyIkusei__c);
            System.assertEquals(null,[select id,SeihoAgencyIkusei__c from SeihoAgencyMaster__c ][3].SeihoAgencyIkusei__c);
            
        }
    }
    
    
    @isTest
    static void updateAgentMasterSelfLookup(){
        Test.startTest();
        List<SeihoAgentMaster__c> agentMasterList = createAgentMasterTestData();
        String jobId = CreateBatchRunControlData('0','BatchSeihoAgentParentUpdate');
        BatchSeihoAgentParentUpdate agentUpdate = new BatchSeihoAgentParentUpdate(jobId,'BatchSeihoAgentParentUpdate');
        Database.executeBatch(agentUpdate,200);
        Test.stopTest();
        SeihoAgentMaster__c updatedAgentMasterList = [SELECT Id, SeihoAgentParent__c, SeihoAgentParentFlag__c FROM SeihoAgentMaster__c where id=: agentMasterList[3].id];
        
        System.assertEquals('1', [SELECT ID, Status__c FROM BatchRunControl__c WHERE Name =: jobId][0].Status__c);
        System.assertEquals([select id from SeihoAgentMaster__c][2].id,[select id,SeihoAgentParent__c from SeihoAgentMaster__c ][3].SeihoAgentParent__c);
        System.assertEquals(false,[select id,SeihoAgentParentFlag__c from SeihoAgentMaster__c ][3].SeihoAgentParentFlag__c);
        System.assertEquals(null, [SELECT ID, ErrorMessage__c FROM BatchRunControl__c WHERE Name =: jobId][0].ErrorMessage__c);
        
        
        
    }
    @isTest
    static void noRelatedParentAgentMasterUpdate(){
        Test.startTest();
        List<SeihoAgentMaster__c> agentMasterList = createAgentMasterTestData();
        agentMasterList[4].BELONG_AGENT__c=null;
        update agentMasterList;
        String jobId = CreateBatchRunControlData('0','BatchSeihoAgentParentUpdate');
        BatchSeihoAgentParentUpdate agentUpdate = new BatchSeihoAgentParentUpdate(jobId,'BatchSeihoAgentParentUpdate');
        Database.executeBatch(agentUpdate,200);
        Test.stopTest();
        
        System.assertEquals('1', [SELECT ID, Status__c FROM BatchRunControl__c WHERE Name =: jobId][0].Status__c);
        System.assertNotEquals([select id from SeihoAgentMaster__c][2].id,[select id,SeihoAgentParent__c from SeihoAgentMaster__c ][2].SeihoAgentParent__c);
        System.assertEquals(false,[select id,SeihoAgentParentFlag__c from SeihoAgentMaster__c ][4].SeihoAgentParentFlag__c);
        System.assertEquals(null, [SELECT ID, ErrorMessage__c FROM BatchRunControl__c WHERE Name =: jobId][0].ErrorMessage__c);
        
        
        
    }
    @isTest
    static void updateFailureAgentMasterSelfLookup(){
        batchExceptionFlag=true;
        String jobId = '';
        Test.startTest();
        List<SeihoAgentMaster__c> agentMasterList = createAgentMasterTestData();
        SeihoAgentMaster__c agentMaster= agentMasterList[3];
        agentMasterList[0].BELONG_AGENT__c = null;
        try{
            update agentMaster;
            jobId = CreateBatchRunControlData('0','BatchSeihoAgentParentUpdate');
            BatchSeihoAgentParentUpdate  agentUpdate = new BatchSeihoAgentParentUpdate(jobId,'BatchSeihoAgentParentUpdate');
            Database.executeBatch(agentUpdate,200);
            Test.stopTest();
        }
        catch(Exception e)
        {
            
            
            System.assertEquals('2', [SELECT ID, Status__c FROM BatchRunControl__c WHERE Name =: jobId][0].Status__c);
            System.assertEquals(e.getMessage(), [SELECT ID, ErrorMessage__c FROM BatchRunControl__c WHERE Name =: jobId][0].ErrorMessage__c);
            System.assertEquals(false,[select id,SeihoAgentParentFlag__c from SeihoAgentMaster__c ][3].SeihoAgentParentFlag__c);
            System.assertNotEquals([select id from SeihoAgentMaster__c][2].id,[select id,SeihoAgentParent__c from SeihoAgentMaster__c ][3].SeihoAgentParent__c);
            System.assertEquals(null,[select id,SeihoAgentParent__c from SeihoAgentMaster__c ][3].SeihoAgentParent__c);
        }
    }    
    @isTest
    static void noDataForBatchProcessAgentUpdate(){
        
        Test.startTest();
        String jobId = CreateBatchRunControlData('0','BatchSeihoAgentParentUpdate');
        BatchSeihoAgentParentUpdate  agentUpdate = new BatchSeihoAgentParentUpdate(jobId,'BatchSeihoAgentParentUpdate');
        Database.executeBatch(agentUpdate,200);
        Test.stopTest();
        System.assertEquals('0', [SELECT ID, Status__c FROM BatchRunControl__c WHERE Name =: jobId][0].Status__c);
        
    }
    
    @isTest
    static void badStatusAgentUpdate(){
        
        List<SeihoAgentMaster__c> agentMasterList = createAgentMasterTestData();
        String jobId = CreateBatchRunControlData('4','BatchSeihoAgentParentUpdate');
        System.assertNotEquals(null,jobId);
        System.assertEquals('4', [SELECT ID, Status__c FROM BatchRunControl__c WHERE Name =: jobId][0].Status__c);
        if([SELECT Status__c FROM BatchRunControl__c WHERE Name =: jobId].get(0).Status__c == '4'){
            System.assertEquals(true,[select id,SeihoAgentParentFlag__c from SeihoAgentMaster__c ][3].SeihoAgentParentFlag__c);
            System.assertNotEquals([select id from SeihoAgentMaster__c][2].id,[select id,SeihoAgentParent__c from SeihoAgentMaster__c ][3].SeihoAgentParent__c);
            System.assertEquals(null,[select id,SeihoAgentParent__c from SeihoAgentMaster__c ][3].SeihoAgentParent__c);
            
        }
    }
    
    
    static String CreateBatchRunControlData(String status,String jobName){
        
        BatchRunControl__c bRunControl = new BatchRunControl__c(
            JobName__c = jobName,
            Status__c = status
        );
        insert bRunControl;
        
        String jobId = [SELECT Name FROM BatchRunControl__c WHERE ID =: bRunControl.Id][0].Name;
        
        return jobId;
    }
    
    /*
* 少短期資料請求用のテストデータ作成
*/
    
    static List<SyotanDocumentRequests__c> CreateSyotanDocTestData(boolean caseCreationFlag){
        
        List<SyotanDocumentRequests__c> syotanDocInsertList = new List<SyotanDocumentRequests__c>();
        
        for(Integer i=1;i<=3;i++){
            
            Account acc = new Account(
                LastName = 'Account 00' + i,
                FirstName = 'Test'
            );
            insert acc;
            
            System.debug([Select PersonContactId From Account WHERE ID=: acc.Id][0].PersonContactId);
            
            SyotanDocumentRequests__c syotanDoc = new SyotanDocumentRequests__c(
                id__c = 'TEST ID 00' + i,
                request_id__c = 'TEST ID 00' + i,
                Ref_Account__c = acc.Id,
                request_date__c = System.today(),
                zip_code1__c = '1360072',
                address_kana__c = '1-1-1',
                caseCreationFlag__c = caseCreationFlag
            );
            syotanDocInsertList.add(syotanDoc);
        }
        
        insert syotanDocInsertList;
        
        return syotanDocInsertList;
    }
    
    /*
* 損保期資料請求用のテストデータ作成
*/
    
    static List<GeneralRequest__c> CreateGeneralReqTestData(boolean caseCreationFlag){
        
        List<GeneralRequest__c> generalReqInsertList = new List<GeneralRequest__c>();
        
        for(Integer i=1;i<=3;i++){
            
            Account acc = new Account(
                LastName = 'Account 00' + i,
                FirstName = 'Test'
            );
            insert acc;
            
            GeneralRequest__c generalReq = new GeneralRequest__c(
                Name = 'TEST ID 00' + i,
                ForeignKey_Renban__c = 'TEST ID 00' + i,
                Ref_Account__c = acc.Id,
                address__c = '1-1-1',
                caseCreationFlag__c = caseCreationFlag
            );
            generalReqInsertList.add(generalReq);
        }
        
        insert generalReqInsertList;
        
        return generalReqInsertList;
    }
    
    static List<DamageContract__c> createDamageContractData(){
        
        List<DamageContract__c> damgageContractList = new List<DamageContract__c>();
        
        for(Integer i=1;i<=3;i++){
            
            Account acc = new Account(
                LastName = 'Account 00' + i,
                FirstName = 'Test'
            );
            insert acc;
            
            DamageContract__c damage = new DamageContract__c(
                Name = 'TEST SONPO 00' + i,
                AccountId__c = acc.Id,
                AgencyCode__c = '00'+ i + ',00'+ (i+1) + ',00' + (i+2)
            );
            damgageContractList.add(damage);
        }
        insert damgageContractList;
        return damgageContractList;
    }
    
    static List<AgencyMaster__c> createAgencyMasterData(){
        
        List<AgencyMaster__c> agencyMasterList = new List<AgencyMaster__c>();
        
        for(Integer j=1;j<=5;j++){
            AgencyMaster__c agency = new AgencyMaster__c(
                SonpoAgencyCode__c = '00' + j,
                SonpoAgencyName__c = 'SONPO Name 00' + j,
                SonpoAgencyNameKana__c = 'SONPO Kana 00' + j
            );
            agencyMasterList.add(agency);
        }
        insert agencyMasterList;
        return agencyMasterList;
    }
    
    static List<LifeContract__c> createLifeContractTestData(List<BankMaster__c> bankMasterList){
        
        List<LifeContract__c> lifeContractList = new List<LifeContract__c>();
        for(Integer i=1;i<=3;i++){
            
            LifeContract__c life = new LifeContract__c(
                Name = 'TEST Life ' + i,
                FNANCIAL_CODE__c = bankMasterList.get(i-1).BankCode__c,
                FINANCIAL_BRANCH_CODE__c = bankMasterList.get(i-1).BranchCode__c,
                TOTAL_INS_FINANCIAL_CODE__c = bankMasterList.get(i-1).BankCode__c,
                TOTAL_INS_FINANCIAL_BRANCH_CODE__c = bankMasterList.get(i-1).BranchCode__c
            );
            lifeContractList.add(life);
        }
        //金融機関コード、支店コードが入ってない生保契約（バッチ対象外になる）
        LifeContract__c life1 = new LifeContract__c(
            Name = 'TEST Life ' + 4,
            FNANCIAL_CODE__c = '',
            FINANCIAL_BRANCH_CODE__c = '',
            TOTAL_INS_FINANCIAL_CODE__c = '',
            TOTAL_INS_FINANCIAL_BRANCH_CODE__c = ''
        );
        lifeContractList.add(life1);
        insert lifeContractList;
        return lifeContractList;
    }
    
    static List<BankMaster__c> createBankMasterData(){
        
        List<BankMaster__c> bankMasterList =  new List<BankMaster__c>();
        
        BankMaster__c bankMaster1 = new BankMaster__c(
            BankCode__c = '0000',
            BankName__c = '日本銀行',
            BankName_Kana__c = 'ﾆﾂﾎﾟﾝ',
            BranchCode__c = '093',
            BranchName__c = '本店',
            BranchName_Kana__c = 'ﾎﾝﾃﾝ'
        );
        bankMasterList.add(bankMaster1);
        
        BankMaster__c bankMaster2 = new BankMaster__c(
            BankCode__c = '0000',
            BankName__c = '日本銀行',
            BankName_Kana__c = 'ﾆﾂﾎﾟﾝ',
            BranchCode__c = '550',
            BranchName__c = '青森支店',
            BranchName_Kana__c = 'ｱｵﾓﾘ'
        );
        bankMasterList.add(bankMaster2);
        
        BankMaster__c bankMaster3 = new BankMaster__c(
            BankCode__c = '9104',
            BankName__c = '大分県農業協同組合',
            BankName_Kana__c = 'ｵｵｲﾀｹﾝﾉｳｷﾖｳ',
            BranchCode__c = '120',
            BranchName__c = '豊後高田支店',
            BranchName_Kana__c = 'ﾌﾞﾝｺﾞﾀｶﾀ'
        );
        bankMasterList.add(bankMaster3);
        insert bankMasterList;
        
        return bankMasterList;
        
    }
    static List<SeihoAgencyMaster__c> createAgencyMasterTestData(){
        
        List<SeihoAgencyMaster__c> agencyMasterList = new List<SeihoAgencyMaster__c>();
        for(Integer i=1;i<=3;i++){
            
            SeihoAgencyMaster__c agency = new SeihoAgencyMaster__c(
                tantoupbragncyno__c='AG00006',
                agncyno__c='AG0000'+i,
                AgencyNameFlag__c=true
                
            );
            agencyMasterList.add(agency);
        }
        //金融機関コード、支店コードが入ってない生保契約（バッチ対象外になる）
        SeihoAgencyMaster__c agency1 = new SeihoAgencyMaster__c(
            tantoupbragncyno__c='AG00003',
            agncyno__c='AG00004',
            AgencyNameFlag__c=true
            
        );
        SeihoAgencyMaster__c agency2 = new SeihoAgencyMaster__c(
            agncyno__c='AG00005',
            AgencyNameFlag__c=false
            
        );
       
        agencyMasterList.add(agency1);
        agencyMasterList.add(agency2);
        /*agencyMasterList.add(agency3);*/
        insert agencyMasterList;
        return agencyMasterList;
    }
    static List<SeihoAgentMaster__c> createAgentMasterTestData(){
        List<SeihoAgentMaster__c> agentMasterList = new List<SeihoAgentMaster__c>();
        for(Integer i=1;i<=3;i++){
            
            SeihoAgentMaster__c agent = new SeihoAgentMaster__c(
                OLD_AGENT_ID__c='AG00006',
                MEMBER_ID_SEQ__c='AG0000'+i,
                BELONG_AGENT__c='AG0001'+i,
                SeihoAgentParentFlag__c=true
                
            );
            agentMasterList.add(agent);
        }
        //金融機関コード、支店コードが入ってない生保契約（バッチ対象外になる）
        SeihoAgentMaster__c agent1 = new SeihoAgentMaster__c(
            OLD_AGENT_ID__c='AG00006',
            MEMBER_ID_SEQ__c='AG00005',
            BELONG_AGENT__c='AG00003',
            SeihoAgentParentFlag__c=true
            
        );
        SeihoAgentMaster__c agent2 = new SeihoAgentMaster__c(
            BELONG_AGENT__c='AG00005',
            SeihoAgentParentFlag__c=false
            
        );
        
        agentMasterList.add(agent1);
        agentMasterList.add(agent2);
        insert agentMasterList;
        return agentMasterList;
    }
    
}