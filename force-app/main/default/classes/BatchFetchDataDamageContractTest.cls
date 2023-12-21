@isTest
    private class BatchFetchDataDamageContractTest {
        @isTest
        static void testBatchExecution() {
            // Create Account records for testing
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('個人取引先').getRecordTypeId();
            Account testAccount1 = new Account(RecordTypeId = recordTypeId,LastName = 'Test1');
            Account testAccount2 = new Account(RecordTypeId = recordTypeId,LastName = 'Test2');
            insert new List<Account>{ testAccount1, testAccount2 };
    
        // Create test data for DamageContract
        DamageContract__c damageContract = new DamageContract__c(
            AccountId__c = testAccount2.Id,
            TorihikisakiKana__c = 'Test Torihikisaki Kana',
            PostalCode__c = '654321',
            PhoneNo__c = '0987654321',
            CellPhone__c = '1234509876',
            ContractStartDate__c = '20231116',
            ContractEndDate__c ='20240914'
        );
            insert damageContract;
            
             Test.startTest();
    
            // Instantiate the batch class
            BatchFetchDataDamageContract batchClassInstance = new BatchFetchDataDamageContract();
            Database.executeBatch(batchClassInstance);
    
            Test.stopTest();
    
            // Add assertions to verify the results after batch execution
            Integer workRecordsCount = [SELECT COUNT() FROM Work1__c];
            System.assertEquals(1, workRecordsCount, 'Incorrect number of Work1 records created');
        }
    }