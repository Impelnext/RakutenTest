global class BatchFetchDataLittleContract implements Database.Batchable<sObject> {

    private String strQuery;

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query fields from LifeContract
        strQuery = queryLittleContracts();
        return Database.getQueryLocator(strQuery);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Work1__c> workRecords = new List<Work1__c>();

        for(sObject obj : scope) {
            if(obj instanceof LittleContract__c) {
                workRecords.addAll(createWorkRecords((LittleContract__c)obj, 'Little'));
            }
        }
        // Insert Work1 records
        insert workRecords;
    }

    global void finish(Database.BatchableContext BC) {
    }

    // Query method for LittleContract
    private String queryLittleContracts() {
        return 'SELECT AccountId__c, SubscriberNameKana__c,SubscriberBirthdate__c,SubscriberZipcode__c,SubscriberTel__c,EasyId__c, CorporativeContactAddress__c,CustomerNumber__c FROM LittleContract__c WHERE AccountId__c != null AND SubscriberStatusDisply__c = \'有効\'';
    }
        
    private List<Work1__c> createWorkRecords(SObject contract, String dataSource) {
        List<Work1__c> records = new List<Work1__c>();
        Work1__c workRecord = new Work1__c();
        
        workRecord.AccountId__c = (Id)contract.get('AccountId__c');
        workRecord.Data_Source__c = dataSource;

        LittleContract__c littleRecord = (LittleContract__c)contract;
        workRecord.NameKana__c = littleRecord.SubscriberNameKana__c;
        workRecord.BirthDate__c = littleRecord.SubscriberBirthdate__c;
        workRecord.PostalCode__c = littleRecord.SubscriberZipcode__c;
        workRecord.Phone__c = littleRecord.SubscriberTel__c;
        workRecord.EasyId__c = littleRecord.EasyId__c;
        workRecord.MobilePhone__c = littleRecord.CorporativeContactAddress__c;
        workRecord.CSID__c = littleRecord.CustomerNumber__c;
        
        records.add(workRecord);
        return records;
    }
}