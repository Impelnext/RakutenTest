@isTest
public with sharing class RequestSpecialContractReductionCmpTest {
    @isTest static void testMethod_T01(){
        Map<String, String> test
            = RequestSpecialContractReductionCmpCont.getSinglePicklist('Request__c', 'Ret1_FirstOffer__c');
    }
}