@isTest
    private class BatchFetchDataLittleContractTest {
        @isTest
        static void testBatchExecution() {
            // Create Account records for testing
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('個人取引先').getRecordTypeId();
            Account testAccount1 = new Account(RecordTypeId = recordTypeId,LastName = 'Test1');
            Account testAccount2 = new Account(RecordTypeId = recordTypeId,LastName = 'Test2');
            insert new List<Account>{ testAccount1, testAccount2 };
    
        // Create test data for LittleContract
        LittleContract__c littleContract = new LittleContract__c(
            AccountId__c = testAccount2.Id,
            CustomerNumber__c = '123',
            SubscriberNameKana__c = 'Test Subscriber Kana',
            SubscriberZipcode__c = '987123',
            SubscriberTel__c = '5432167890',
            CorporativeContactAddress__c = 'Test Address',
            SubscriberStatus__c ='80'
        );
        insert littleContract;
            
             Test.startTest();
    
            // Instantiate the batch class
            BatchFetchDataLittleContract batchClassInstance = new BatchFetchDataLittleContract();
            Database.executeBatch(batchClassInstance);
    
            Test.stopTest();
    
            // Add assertions to verify the results after batch execution
            Integer workRecordsCount = [SELECT COUNT() FROM Work1__c];
            System.assertEquals(1, workRecordsCount, 'Incorrect number of Work1 records created');
        }
    }