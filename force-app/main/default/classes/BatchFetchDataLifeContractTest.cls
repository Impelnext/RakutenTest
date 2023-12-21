@isTest
    private class BatchFetchDataLifeContractTest {
        @isTest
        static void testBatchExecution() {
            // Create Account records for testing
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('個人取引先').getRecordTypeId();
            Account testAccount1 = new Account(RecordTypeId = recordTypeId,LastName = 'Test1');
            Account testAccount2 = new Account(RecordTypeId = recordTypeId,LastName = 'Test2');
            insert new List<Account>{ testAccount1, testAccount2 };
    
            // Create test data for LifeContract
            LifeContract__c lifeContract = new LifeContract__c(
                AccountId__c = testAccount1.Id,
                CSID__c = 'CS123',
                KANA_CONTROR_NAME__c = 'Test Kana',
                CONTROR_POST_CODE__c = '123456',
                CONTRANT_PHONE__c = '1234567890',
                CONTRANT_MOBILE_PHONE__c = '9876543210',
                Status__c = '01'
                
            );
            insert lifeContract;
            
                    Test.startTest();
    
            // Instantiate the batch class
            BatchFetchDataLifeContract batchClassInstance = new BatchFetchDataLifeContract();
            Database.executeBatch(batchClassInstance);
    
            Test.stopTest();
    
            // Add assertions to verify the results after batch execution
            Integer workRecordsCount = [SELECT COUNT() FROM Work1__c];
            System.assertEquals(1, workRecordsCount, 'Incorrect number of Work1 records created');
        }
    }