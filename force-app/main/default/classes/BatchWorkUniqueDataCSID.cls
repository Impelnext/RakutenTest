global class BatchWorkUniqueDataCSID implements Database.Batchable<sObject> {
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
        Map<String, Work3__c> work3Map = new Map<String, Work3__c>();
        uniqueList = new List<Work2__c>();

        for (Work2__c work2 : scope) {
            if (work2.CSID__c == null) {
                // Create Work3 record CSID__c is null
                Work3__c work3 = new Work3__c();
                work3.Name = 'Work3 Record';
                work3.AccountId__c = work2.AccountId__c;
                work3Map.put(String.valueOf(work2.Id), work3);
            } else {
                Boolean isDuplicate = false;
                for (Work2__c uniqueRecord : uniqueList) {
                    // Check CSID condition
                    if ((uniqueRecord.CSID__c != null && work2.CSID__c != null) && uniqueRecord.CSID__c == work2.CSID__c) {
                        isDuplicate = true;
                        break;
                    }
                }

                if (!isDuplicate) {
                    uniqueList.add(work2);
                    system.debug('uniqueList' + uniqueList);
                    String key1 = 'CSID' + work2.CSID__c;
                    system.debug('key1' + key1);

                    if (!work3Map.containsKey(key1)) {
                        Work3__c work3 = new Work3__c();
                        work3.Name = 'Work3 Record';
                        work3.AccountId__c = work2.AccountId__c;
                        work3Map.put(key1, work3);
                    }
                }
            }
        }

        if (!work3Map.isEmpty()) {
            insert work3Map.values();
            system.debug('work3Map' + work3Map);
        }
    }

    global void finish(Database.BatchableContext bc) {
    }
}