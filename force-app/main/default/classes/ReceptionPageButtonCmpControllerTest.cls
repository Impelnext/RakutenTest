@isTest
private class ReceptionPageButtonCmpControllerTest {
 @isTest
    static void TestgetAccountContract(){
        Id accountId   = RequestControllerHandlerTest.createAccount('testAccount1');
        Id ReceptionId = RequestControllerHandlerTest.createReception('testReceptionName',accountId);
        
        Test.startTest(); 
        ReceptionPageButtonCmpController.getAccountContract(ReceptionId);
        Test.stopTest();
    }
}