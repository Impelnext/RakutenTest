@isTest
private class RequestPageButtonCmpControllerTest {
 @isTest
    static void TestgetAccountContract(){
        Id accountId   = RequestControllerHandlerTest.createAccount('testAccount1');
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
        
        Test.startTest(); 
        RequestPageButtonCmpController.getAccountContract(req.id);
        Test.stopTest();
    }
}