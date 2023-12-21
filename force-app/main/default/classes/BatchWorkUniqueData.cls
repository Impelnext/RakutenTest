global class BatchWorkUniqueData implements Database.Batchable<sObject> {
    List<Work2__c> uniqueList;
    Map<String, Work2__c> csidMap;
    Map<String, Work2__c> easyIdMap;
    Map<String, Work2__c> nameKanaBirthDateMap;
    Map<String, Work2__c> postalPhoneMap;

    global Database.QueryLocator start(Database.BatchableContext bc) {
        uniqueList = new List<Work2__c>();
        return Database.getQueryLocator([
            SELECT Id, Data_Source__c, AccountId__c, CSID__c, EasyId__c, NameKana__c, BirthDate__c, PostalCode__c, Phone__c, MobilePhone__c
            FROM Work2__c
            ORDER BY LastModifiedDate DESC
        ]);
    }

    global void execute(Database.BatchableContext bc, List<Work2__c> scope) {
        csidMap = new Map<String, Work2__c>();
        easyIdMap = new Map<String, Work2__c>();
        nameKanaBirthDateMap = new Map<String, Work2__c>();
        postalPhoneMap = new Map<String, Work2__c>();
        uniqueList = new List<Work2__c>();

            for (Work2__c work2 : scope) {
                if (work2.CSID__c != null) {
                    csidMap.put(work2.CSID__c, work2);
                }
                if (work2.EasyId__c != null) {
                    easyIdMap.put(work2.EasyId__c, work2);
                }
                if (work2.NameKana__c != null && work2.BirthDate__c != null) {
                    String key = 'NameKana_BirthDate' + work2.NameKana__c + String.valueOf(work2.BirthDate__c);
                    nameKanaBirthDateMap.put(key, work2);
                }
                if (System.Label.BatchPostalCodeFlag == 'True' && work2.PostalCode__c != null) {
                    String key = 'PostalCode' + work2.PostalCode__c;
                    postalPhoneMap.put(key, work2);
                }
                if (work2.Phone__c != null || work2.MobilePhone__c != null) {
                    String key = 'Phone' + work2.Phone__c + String.valueOf(work2.MobilePhone__c);
                    postalPhoneMap.put(key, work2);
                }
            }

        createUniqueRecordsFromMap(csidMap);
        system.debug('csidMap' + csidMap);
        createUniqueRecordsFromMap(easyIdMap);
        system.debug('easyIdMap' + easyIdMap);
        createUniqueRecordsFromMap(nameKanaBirthDateMap);
        system.debug('nameKanaBirthDateMap' + nameKanaBirthDateMap);
        createUniqueRecordsFromMap(postalPhoneMap);
    }

    private void createUniqueRecordsFromMap(Map<String, Work2__c> recordMap) {
        Map<String, Work3__c> work3Map = new Map<String, Work3__c>();
        if(recordMap != null && !recordMap.isEmpty()){

            for (String key : recordMap.keySet()) {
                Work2__c work2 = recordMap.get(key);
                system.debug('recordMap' + recordMap.get(key));
                Boolean isDuplicate = false;

                if(work2!=null) {

                    for (Work2__c uniqueRecord : uniqueList) {
                        if (System.Label.BatchPostalCodeFlag == 'True') {
                            if (
                                ((uniqueRecord.CSID__c != null && work2.CSID__c != null) && uniqueRecord.CSID__c == work2.CSID__c) ||
                                ((uniqueRecord.EasyId__c != null && work2.EasyId__c != null) && uniqueRecord.EasyId__c == work2.EasyId__c) ||
                                (
                                    (uniqueRecord.NameKana__c != null && work2.NameKana__c != null && uniqueRecord.NameKana__c == work2.NameKana__c) &&
                                    (uniqueRecord.BirthDate__c != null && work2.BirthDate__c != null && uniqueRecord.BirthDate__c == work2.BirthDate__c) &&
                                    (
                                        (uniqueRecord.PostalCode__c != null && work2.PostalCode__c != null && uniqueRecord.PostalCode__c == work2.PostalCode__c) ||
                                        (uniqueRecord.Phone__c != null && work2.Phone__c != null && uniqueRecord.Phone__c == work2.Phone__c) ||
                                        (uniqueRecord.MobilePhone__c != null && work2.MobilePhone__c != null && uniqueRecord.MobilePhone__c == work2.MobilePhone__c) ||
                                        (uniqueRecord.Phone__c != null && work2.MobilePhone__c != null && uniqueRecord.Phone__c == work2.MobilePhone__c) ||
                                        (uniqueRecord.MobilePhone__c != null && work2.Phone__c != null && uniqueRecord.MobilePhone__c == work2.Phone__c)
                                    )
                                )
                            ) {
                                isDuplicate = true;
                                break;
                            }
                        }
                    }
                }

                if (!isDuplicate) {
                    uniqueList.add(work2);
                    String work3MapKey = '';
                    if (work2.CSID__c != null) {
                        work3MapKey += 'CSID' + work2.CSID__c;
                    }
                    if (work2.EasyId__c != null) {
                        work3MapKey += 'EasyId' + work2.EasyId__c;
                    }
                    if (work2.NameKana__c != null && work2.BirthDate__c != null) {
                        work3MapKey += 'NameKana_BirthDate' + work2.NameKana__c + String.valueOf(work2.BirthDate__c);
                    }
                    if (System.Label.BatchPostalCodeFlag == 'True' && work2.PostalCode__c != null) {
                        work3MapKey += 'PostalCode' + work2.PostalCode__c;
                    }
                    if (work2.Phone__c != null || work2.MobilePhone__c != null) {
                        work3MapKey += 'Phone' + work2.Phone__c + String.valueOf(work2.MobilePhone__c);
                    }

                    if (String.isNotBlank(work3MapKey) && !work3Map.containsKey(work3MapKey)) {
                        system.debug('work3MapKey' + work3MapKey);
                        if (System.Label.BatchPostalCodeFlag == 'True') {
                            Work3__c work3 = new Work3__c();
                            work3.Name = 'Work3 Record';
                            work3.AccountId__c = work2.AccountId__c;
                            work3Map.put(work3MapKey, work3);
                        }
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
        // Any finalization logic if needed
    }
}