/*
* @Class Name      : RequestControllerTest 
* @Description     : Test Class RequestController 
* @Created Date    : 2019.11.18
* @Created By      : 
* @Modified Date   : 
* @Modified        : 
*/
@isTest
public class RequestControllerTest{
    @isTest
    static void TestSaveRequest1(){
        //Create Account
        Id accountId   = RequestControllerHandlerTest.createAccount('testAccount1');
        
        LifeContract__c lc = new LifeContract__c();
        lc.AccountId__c = accountId;
        lc.LIFE_MUTUAL_TYPE__c = '1';
        lc.POL_NUM__c = '87654321';
        insert lc;
        
        Id ReceptionId = RequestControllerHandlerTest.createReception('testReceptionName',accountId);
        List<String> listPloyNumbrs = new List<String>();
        listPloyNumbrs.add('12345678');
        Map<String,String> PolicyMap = new Map<String,String>();
        PolicyMap.put('PolicyNumber1','12345678');
        PolicyMap.put('PolicyNumber2','87654321');
        PolicyMap.put('PolicyNumber3','12345678');
        PolicyMap.put('PolicyNumber4','12345678');
        PolicyMap.put('PolicyNumber5','12345678');
        PolicyMap.put('PolicyNumber6','12345678');
        PolicyMap.put('PolicyNumber7','12345678');
        PolicyMap.put('PolicyNumber8','12345678');
        PolicyMap.put('PolicyNumber9','12345678');
        PolicyMap.put('PolicyNumber10','12345678');
        Request__c req = RequestControllerHandlerTest.saveRequest('生命専用ケース','減額','減額',accountId,ReceptionId,listPloyNumbrs,PolicyMap);
        List<Id> contractIds = RequestControllerHandlerTest.createContracts(accountId);
        
        Test.startTest();
        RequestController.saveRequest(req,ReceptionId,accountId,listPloyNumbrs);
        RequestController.hasDoubleByteSpace('１２３４　５６７８');
        RequestController.checkingDoubleByteName('生命専用ケース');
        RequestController.isNumericValidate('12345');
        RequestController.checkingOtherThanDoubleByte('test');
        RequestController.checkingOtherThanSingleByteNumber('１２３４５６７８');
        RequestController.checkingOtherThanSingleByte('ｔｅｓｔ');
        RequestController.getPolicyNumberValidate('12345678',listPloyNumbrs,0);
        RequestController.getPolicyNumberValidateRetention('12345678',listPloyNumbrs,1);
        RequestController.getContractInfo(ReceptionId);
        RequestController.createCase(contractIds,req.id);
        RequestController.getReportButtonDisplay(ReceptionId);
        RequestController.getSinglePicklist('Request__c','Type__c');
        RequestController.getDependentMap('Request__c','Class__c','Type__c');
        RequestController.getDependentAPIMap('Request__c','Class__c','Type__c');
        RequestController.getMultiPiklistValues('Request__c','PersonToBeChanged__c');
        RequestController.getAccountContract(ReceptionId);
        RequestController.fetchLookUpValues('test','Account');
        Test.stopTest();
    }
    
    @isTest
    static void TestSaveRequest2(){
        //Create Account
        Id accountId   = RequestControllerHandlerTest.createAccount('testAccount1');
        
        LifeContract__c lc = new LifeContract__c();
        lc.AccountId__c = accountId;
        lc.LIFE_MUTUAL_TYPE__c = '1';
        lc.POL_NUM__c = '12345678';
        insert lc;
        
        Id ReceptionId = RequestControllerHandlerTest.createReception('testReceptionName',accountId);
        List<String> listPloyNumbrs = new List<String>();
        listPloyNumbrs.add('12345678');
        Map<String,String> PolicyMap = new Map<String,String>();
        PolicyMap.put('PolicyNumber1','12345678');
        PolicyMap.put('PolicyNumber2','87654321');
        PolicyMap.put('PolicyNumber3','12345678');
        PolicyMap.put('PolicyNumber4','12345678');
        PolicyMap.put('PolicyNumber5','12345678');
        PolicyMap.put('PolicyNumber6','12345678');
        PolicyMap.put('PolicyNumber7','12345678');
        PolicyMap.put('PolicyNumber8','12345678');
        PolicyMap.put('PolicyNumber9','12345678');
        PolicyMap.put('PolicyNumber10','12345678');
        Request__c req = RequestControllerHandlerTest.saveRequest(
                                '生命専用ケース','減額','減額',
                                accountId,ReceptionId,listPloyNumbrs,PolicyMap);
        List<Id> contractIds = RequestControllerHandlerTest.createContracts(accountId);
        
        Test.startTest();
        RequestController.saveRequest(req,ReceptionId,accountId,listPloyNumbrs);
        Test.stopTest();
    }
    
    @isTest
    static void TestSaveRequestNegativeCase(){
        //Create Account
        Id accountId   = RequestControllerHandlerTest.createAccount('testAccount1');
        
        LifeContract__c lc = new LifeContract__c();
        lc.AccountId__c = accountId;
        lc.LIFE_MUTUAL_TYPE__c = '1';
        lc.POL_NUM__c = '87654321';
        insert lc;
        
        Id ReceptionId = RequestControllerHandlerTest.createReception('testReceptionName',accountId);
        List<String> listPloyNumbrs = new List<String>();
        listPloyNumbrs.add('12345678');
        Map<String,String> PolicyMap = new Map<String,String>();
        PolicyMap.put('PolicyNumber1','12345678');
        PolicyMap.put('PolicyNumber2','87654321');
        PolicyMap.put('PolicyNumber3','12345678');
        PolicyMap.put('PolicyNumber4','12345678');
        PolicyMap.put('PolicyNumber5','12345678');
        PolicyMap.put('PolicyNumber6','12345678');
        PolicyMap.put('PolicyNumber7','12345678');
        PolicyMap.put('PolicyNumber8','12345678');
        PolicyMap.put('PolicyNumber9','12345678');
        PolicyMap.put('PolicyNumber10','12345678');
        
        Request__c req = RequestControllerHandlerTest.saveRequest('生命専用ケース','減額','減額',accountId,ReceptionId,listPloyNumbrs,PolicyMap);
        List<Id> contractIds = RequestControllerHandlerTest.createContracts(accountId);
        
        Test.startTest();
        RequestController.createCase(null,req.id);
        RequestController.isNumericValidate('Test');
        RequestController.checkingOtherThanSingleByteNumber('Test');
        RequestController.checkingOtherThanDoubleByte('ｔｅｓｔ');
        RequestController.checkingOtherThanSingleByte('test');
        RequestController.checkingDoubleByteName('');
        Test.stopTest();
    }
    
    @isTest
    static void TestCreateCase(){
        //Create Account
        Id accountId   = RequestControllerHandlerTest.createAccount('testAccount1');
        
        LifeContract__c lc = new LifeContract__c();
        lc.AccountId__c = accountId;
        lc.LIFE_MUTUAL_TYPE__c = '1';
        lc.POL_NUM__c = '12345678';
        insert lc;
        
        Id ReceptionId = RequestControllerHandlerTest.createReception('testReceptionName',accountId);
        List<String> listPloyNumbrs = new List<String>();
        listPloyNumbrs.add('12345678');
        Map<String,String> PolicyMap = new Map<String,String>();
        PolicyMap.put('PolicyNumber1','12345678');
        PolicyMap.put('PolicyNumber2','87654321');
        PolicyMap.put('PolicyNumber3','12345678');
        PolicyMap.put('PolicyNumber4','12345678');
        PolicyMap.put('PolicyNumber5','12345678');
        PolicyMap.put('PolicyNumber6','12345678');
        PolicyMap.put('PolicyNumber7','12345678');
        PolicyMap.put('PolicyNumber8','12345678');
        PolicyMap.put('PolicyNumber9','12345678');
        PolicyMap.put('PolicyNumber10','12345678');
        Request__c req = RequestControllerHandlerTest.saveRequest(
                                'セールス専用ケース','生命_コール資料請求','生命_コール資料請求',
                                accountId,ReceptionId,listPloyNumbrs,PolicyMap);
        List<Id> contractIds = RequestControllerHandlerTest.createContracts(accountId);
        
        Test.startTest();
        RequestController.createCase(contractIds,req.id);
        Test.stopTest();
    }
    
}