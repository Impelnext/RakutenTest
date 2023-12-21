global class BatchWorkUniqueDataEasyId implements Database.Batchable<sObject> {
    List<Work2__c> uniqueList;

    global Database.QueryLocator start(Database.BatchableContext bc) {
        uniqueList = new List<Work2__c>();
        return Database.getQueryLocator([
            SELECT Id, Data_Source__c, AccountId__c, CSID__c, EasyId__c, NameKana__c, BirthDate__c, PostalCode__c, Phone__c, MobilePhone__c
            FROM Work2__c
            ORDER BY LastModifiedDate DESC
        ]);
    }

    global void execute(Database.BatchableContext bc, List<Work2__c> scope) {
        Map<String, Work4__c> work4Map = new Map<String, Work4__c>();
        uniqueList = new List<Work2__c>();

        for (Work2__c work2 : scope) {
            if (work2.EasyId__c == null) {
                // Create Work4 record if EasyId is null
                Work4__c work4 = new Work4__c();
                work4.Name = 'Work4 Record';
                work4.AccountId__c = work2.AccountId__c;
                work4Map.put(String.valueOf(work2.Id), work4);
            } else {
                Boolean isDuplicate = false;
                for (Work2__c uniqueRecord : uniqueList) {
                    // Check EasyId condition
                    if ((uniqueRecord.EasyId__c != null && work2.EasyId__c != null) && uniqueRecord.EasyId__c == work2.EasyId__c) {
                        isDuplicate = true;
                        break;
                    }
                }

                if (!isDuplicate) {
                    uniqueList.add(work2);
                    system.debug('uniqueList' + uniqueList);
                    String key1 = 'EasyId' + work2.EasyId__c;
                    system.debug('key1' + key1);

                    if (!work4Map.containsKey(key1)) {
                        Work4__c work4 = new Work4__c();
                        work4.Name = 'Work4 Record';
                        work4.AccountId__c = work2.AccountId__c;
                        work4Map.put(key1, work4);
                    }
                }
            }
        }

        if (!work4Map.isEmpty()) {
            insert work4Map.values();
            system.debug('work4Map' + work4Map);
        }
    }

    global void finish(Database.BatchableContext bc) {
    }
}