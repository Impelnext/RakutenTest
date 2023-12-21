global class BatchWorkUniqueDataNameKanaPhone implements Database.Batchable<sObject> {
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
        Map<String, Work6__c> work6Map = new Map<String, Work6__c>();
        Set<String> work6Set = new Set<String>();
        uniqueList = new List<Work2__c>();

        for (Work2__c work2 : scope) {
            system.debug('work2' + work2);
            if (work2.NameKana__c == null || work2.BirthDate__c == null || (work2.Phone__c == null && work2.MobilePhone__c == null)) {
                // Create Work6 record  field is null
                Work6__c work6 = new Work6__c();
                work6.Name = 'Work6 Record';
                work6.AccountId__c = work2.AccountId__c;
                work6Map.put(String.valueOf(work2.Id), work6);
            } else {
                Boolean isDuplicate = false;
                for (Work2__c uniqueRecord : uniqueList) {
                    // Check NameKana, BirthDate, and Phone conditions
                    if ((uniqueRecord.NameKana__c == work2.NameKana__c) &&
                        (uniqueRecord.BirthDate__c == work2.BirthDate__c) &&
                        (
                            (uniqueRecord.Phone__c == work2.Phone__c) ||
                            (uniqueRecord.MobilePhone__c == work2.MobilePhone__c) ||
                            (uniqueRecord.Phone__c == work2.MobilePhone__c) ||
                            (uniqueRecord.MobilePhone__c == work2.Phone__c)
                        )) {
                        isDuplicate = true;
                        break;
                    }
                }

                if (!isDuplicate) {
                    uniqueList.add(work2);
                    String key1 = 'NameKana_BirthDate' + work2.NameKana__c + String.valueOf(work2.BirthDate__c);
                    String key2 = 'Phone' + work2.Phone__c + String.valueOf(work2.MobilePhone__c);

                    if (!(work6Set.contains(key1) && work6Set.contains(key2))) {
                        Work6__c work6 = new Work6__c();
                        work6.Name = 'Work6 Record';
                        work6.AccountId__c = work2.AccountId__c;
                        work6Map.put(key1, work6);
                        work6Set.add(key1);
                        work6Set.add(key2);
                    }
                }
            }
        }

        if (!work6Map.isEmpty()) {
            insert work6Map.values();
            system.debug('work6Map' + work6Map);
        }
    }

    global void finish(Database.BatchableContext bc) {

    }
}