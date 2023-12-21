@isTest
public class URLWithLimitedTriggerTest {
    @isTest
    static void testCreate() {
        URLWithLimit__c url = new URLWithLimit__c(LastName__c='TEST', FirstName__c='TEST', LimitTime__c = DateTime.now()+1);
        insert url;
    }
}