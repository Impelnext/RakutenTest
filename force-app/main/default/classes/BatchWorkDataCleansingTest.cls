@isTest
private class BatchWorkDataCleansingTest {

    @isTest
    static void testBatchProcessing() {

        // Create Account records for testing
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('個人取引先').getRecordTypeId();
        Account testAccount1 = new Account(RecordTypeId = recordTypeId,LastName = 'Test1');
        Account testAccount2 = new Account(RecordTypeId = recordTypeId,LastName = 'Test2');
        insert new List<Account>{ testAccount1, testAccount2 };
        // Create test data - Work1__c records
        List<Work1__c> work1Records = new List<Work1__c>();
        for(Integer i = 0; i < 10; i++) {
            Work1__c w1 = new Work1__c(
                Data_Source__c = 'Test Source',
                AccountId__c = testAccount1.Id,
                EasyId__c = '  abc',
                NameKana__c = 'タナカ　ミノル',
                BirthDate__c = '2023/02/01',
                PostalCode__c = '１２３４－８９',
                Phone__c = '(123)-4567890'+i,
                MobilePhone__c = '9876-543210'
            );
            work1Records.add(w1);
        }
        insert work1Records;

        Test.startTest();

        // Start the batch job
        BatchWorkDataCleansing batchJob = new BatchWorkDataCleansing();
        Database.executeBatch(batchJob);

        Test.stopTest();

        // Assert the results
        List<Work2__c> work2Records = [SELECT Id, Data_Source__c, AccountId__c, EasyId__c, NameKana__c, BirthDate__c, PostalCode__c, Phone__c, MobilePhone__c FROM Work2__c];

        // Check if the same number of Work2 records as Work1 records were created
        System.assertEquals(work1Records.size(), work2Records.size());
        System.assertEquals('タナカミノル', work2Records[0].NameKana__c);
        System.assertEquals('9876543210', work2Records[0].MobilePhone__c);

    }
}