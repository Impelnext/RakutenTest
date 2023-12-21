@isTest
private class BatchContractDataCleansingTest {
    @isTest
    static void testCleansingBatch() {
        // Create test Account
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;

        // Create test Work1 record associated with the Account
        Work1__c testWork1 = new Work1__c(
            Data_Source__c = 'Life',
            AccountId__c = testAccount.Id,
            NameKana__c = 'サト ウ',
            BirthDate__c = '2023/11/01',
            PostalCode__c = '123-4567',
            Phone__c = '123-4567-890',
            MobilePhone__c = '9876543210'
        );
        insert testWork1;

        Test.startTest();
        // Execute the batch job
        BatchWorkDataCleansing batchJob = new BatchWorkDataCleansing();
        Database.executeBatch(batchJob);
        Test.stopTest();

        // Validate the creation of Work2 records
        Integer work2Count = [SELECT COUNT() FROM Work2__c];
        System.assertEquals(1, work2Count, 'Expected number of Work2 records');

        // Validate that Work2 record was created with correct field values
        Work2__c createdWork2 = [SELECT Id, Data_Source__c, AccountId__c, NameKana__c, BirthDate__c, PostalCode__c, Phone__c, MobilePhone__c FROM Work2__c LIMIT 1];
        System.assertEquals('Life', createdWork2.Data_Source__c);
        System.assertEquals('1234567890', createdWork2.Phone__c);
        System.assertEquals('サトウ', createdWork2.NameKana__c);
        System.assertEquals('20231101', createdWork2.BirthDate__c);
    }
}