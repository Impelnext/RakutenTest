@isTest
private class BatchFetchDataCleansingLifeContractTest {

    @isTest
    static void testBatchProcessing() {
        // Create test data - Accounts
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('個人取引先').getRecordTypeId();
            Account testAccount1 = new Account(RecordTypeId = recordTypeId,LastName = 'Test1');
            Account testAccount2 = new Account(RecordTypeId = recordTypeId,LastName = 'Test2');
            insert new List<Account>{ testAccount1, testAccount2 };

        // Create test data - LifeContract records associated with the Account
        List<LifeContract__c> lifeContracts = new List<LifeContract__c>();
        for(Integer i = 0; i < 10; i++) {
            LifeContract__c lc = new LifeContract__c(
                AccountId__c = testAccount1.Id,
                KANA_CONTROR_NAME__c = 'Test Name' + i,
                CONTROR_POST_CODE__c = '12345',
                CONTRANT_PHONE__c = '1234567890',
                CONTRANT_MOBILE_PHONE__c = '9876543210',
                WEB_USER_ID__c = 'UserId' + i,
                Status__c = '01'
            );
            lifeContracts.add(lc);
        }
        insert lifeContracts;

        // Create test data - SeihoMember records
        List<SeihoMember__c> seihoMembers = new List<SeihoMember__c>();
        for(Integer i = 0; i < 5; i++) {
            SeihoMember__c sm = new SeihoMember__c(
                Name = 'UserId' + i,
                EasyId__c = 'EasyId' + i
            );
            seihoMembers.add(sm);
        }
        insert seihoMembers;

        Test.startTest();

        // Start the batch job
        BatchFetchDataCleansingLifeContract batchJob = new BatchFetchDataCleansingLifeContract();
        Database.executeBatch(batchJob);

        Test.stopTest();

        List<Work1__c> workRecords = [SELECT Id, NameKana__c, EasyId__c FROM Work1__c];
        System.assertEquals(10, workRecords.size());

    }
}