global class BatchWorkUniqueDataNameKanaPostalCode implements Database.Batchable<sObject> {
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
        Map<String, Work5__c> work5Map = new Map<String, Work5__c>();
        Set<String> work5Set = new Set<String>();
        uniqueList = new List<Work2__c>();

        for (Work2__c work2 : scope) {
            system.debug('work2' + work2);
            if (work2.NameKana__c == null || work2.BirthDate__c == null || work2.PostalCode__c == null) {
                // Create Work5 record if any field is null
                Work5__c work5 = new Work5__c();
                work5.Name = 'Work5 Record';
                work5.AccountId__c = work2.AccountId__c;
                work5Map.put(String.valueOf(work2.Id), work5);
            } else {
                Boolean isDuplicate = false;
                for (Work2__c uniqueRecord : uniqueList) {
                    // Check NameKana, BirthDate, and PostalCode conditions
                    if ((uniqueRecord.NameKana__c == work2.NameKana__c) &&
                        (uniqueRecord.BirthDate__c == work2.BirthDate__c) &&
                        (uniqueRecord.PostalCode__c == work2.PostalCode__c)) {
                        isDuplicate = true;
                        break;
                    }
                }

                if (!isDuplicate) {
                    uniqueList.add(work2);
                    String key = 'NameKana' + work2.NameKana__c + 'BirthDate' + String.valueOf(work2.BirthDate__c) + 'PostalCode' + work2.PostalCode__c;

                    if (!work5Set.contains(key)) {
                        Work5__c work5 = new Work5__c();
                        work5.Name = 'Work5 Record';
                        work5.AccountId__c = work2.AccountId__c;
                        work5Map.put(key, work5);
                        work5Set.add(key);
                    }
                }
            }
        }

        if (!work5Map.isEmpty()) {
            insert work5Map.values();
            system.debug('work5Map' + work5Map);
        }
    }

    global void finish(Database.BatchableContext bc) {

    }
}