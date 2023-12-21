@isTest
public with sharing class RequestPageControllerTest {
    @isTest static void testMethod_T01(){
        case testCase = new case();
        insert testCase;

        Id testCaseId = [Select id From Case Limit 1].Id;
        String test = RequestPageController.getRequestId(testCaseId);
    }
}