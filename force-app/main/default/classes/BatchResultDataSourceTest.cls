@isTest
private class BatchResultDataSourceTest {

    @isTest
    static void testBatchExecution() {
        // Create test Accounts
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            Account acc = new Account(Name = 'Test Account ' + i);
            testAccounts.add(acc);
        }
        insert testAccounts;

        // Create Work1 records using Account data with 'Life' as Data_Source value
        List<Work1__c> testData = new List<Work1__c>();
        for (Account acc : testAccounts) {
            Work1__c workRecord = new Work1__c(
                Data_Source__c = 'Life',
                AccountId__c = acc.Id
            );
            testData.add(workRecord);
        }
        insert testData;

        Test.startTest();
        // Start the batch job
        BatchResultDataSource batchJob = new BatchResultDataSource();
        Database.executeBatch(batchJob);
        Test.stopTest();

        List<Result__c> results = [SELECT Id, Data_Source__c, COUNTDISTINCT_AccountId__c, AccountId__c FROM Result__c];
        System.assertEquals(10, results.size(), 'Expected only 10 Result record for Data_Source__c = \'Life\'');
    }
}