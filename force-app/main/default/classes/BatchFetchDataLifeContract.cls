global class BatchFetchDataLifeContract implements Database.Batchable<sObject> {

    private String strQuery;

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query fields from LifeContract
        strQuery = queryLifeContracts();
        return Database.getQueryLocator(strQuery);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Work1__c> workRecords = new List<Work1__c>();
        
        for(sObject obj : scope) {
            if(obj instanceof LifeContract__c) {
                workRecords.addAll(createWorkRecords((LifeContract__c)obj, 'Life'));
            }
        }
        // Insert Work1 records
        insert workRecords;
    }

    global void finish(Database.BatchableContext BC) {
    }

    // Query method for LifeContract
    private String queryLifeContracts() {
        return 'SELECT AccountId__c, KANA_CONTROR_NAME__c,CONTROR_BIRTH_DATE__c,CONTROR_POST_CODE__c,CONTRANT_PHONE__c,CONTRANT_MOBILE_PHONE__c FROM LifeContract__c WHERE AccountId__c != null AND STATUS_DISPLAY__c = \'有効\'';
    }
        
    private List<Work1__c> createWorkRecords(SObject contract, String dataSource) {
        List<Work1__c> records = new List<Work1__c>();
        Work1__c workRecord = new Work1__c();
        
        workRecord.AccountId__c = (Id)contract.get('AccountId__c');
        workRecord.Data_Source__c = dataSource;
        
        LifeContract__c lifeRecord = (LifeContract__c)contract;
        workRecord.NameKana__c = lifeRecord.KANA_CONTROR_NAME__c;
        workRecord.BirthDate__c = lifeRecord.CONTROR_BIRTH_DATE__c;
        workRecord.PostalCode__c = lifeRecord.CONTROR_POST_CODE__c;
        workRecord.Phone__c = lifeRecord.CONTRANT_PHONE__c;
        workRecord.MobilePhone__c = lifeRecord.CONTRANT_MOBILE_PHONE__c;
        
        records.add(workRecord);
        return records;
    }
}