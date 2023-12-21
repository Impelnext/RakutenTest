global class BatchDataMasking implements Database.Batchable<sObject> {

    private String lifeContractsQuery;

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query fields from LifeContract
        lifeContractsQuery = queryLifeContracts();
        return Database.getQueryLocator(lifeContractsQuery);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Work1__c> workRecords = new List<Work1__c>();

        for(sObject obj : scope) {
            if(obj instanceof LifeContract__c) {
                workRecords.addAll(createWorkRecords((LifeContract__c)obj, 'Life'));
            }
        }

        // Query for DamageContract and LittleContract
        List<DamageContract__c> damageContracts = Database.query(queryDamageContracts());
        List<LittleContract__c> littleContracts = Database.query(queryLittleContracts());

        // Processing DamageContract records
        for(DamageContract__c damageRecord : damageContracts) {
            workRecords.addAll(createWorkRecords(damageRecord, 'Damage'));
        }

        // Processing LittleContract records
        for(LittleContract__c littleRecord : littleContracts) {
            workRecords.addAll(createWorkRecords(littleRecord, 'Little'));
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
    
    // Query method for DamageContract
    private String queryDamageContracts() {
        return 'SELECT AccountId__c, TorihikisakiKana__c, TorihikisakiBD__c,PostalCode__c,PhoneNo__c,CellPhone__c,EasyId__c FROM DamageContract__c WHERE AccountId__c != null AND ContractStatusDisplay__c = \'有効\'';
    }

    // Query method for LittleContract
    private String queryLittleContracts() {
        return 'SELECT AccountId__c, SubscriberNameKana__c,SubscriberBirthdate__c,SubscriberZipcode__c,SubscriberTel__c,EasyId__c FROM LittleContract__c WHERE AccountId__c != null AND SubscriberStatusDisply__c = \'有効\'';
    }
        
    private List<Work1__c> createWorkRecords(SObject contract, String dataSource) {
        List<Work1__c> records = new List<Work1__c>();
        Work1__c workRecord = new Work1__c();
        
        workRecord.AccountId__c = (Id)contract.get('AccountId__c');
        workRecord.Data_Source__c = dataSource;

        if(contract instanceof LifeContract__c) {
            LifeContract__c lifeRecord = (LifeContract__c)contract;
            workRecord.NameKana__c = lifeRecord.KANA_CONTROR_NAME__c;
            workRecord.BirthDate__c = lifeRecord.CONTROR_BIRTH_DATE__c;
            workRecord.PostalCode__c = lifeRecord.CONTROR_POST_CODE__c;
            workRecord.Phone__c = lifeRecord.CONTRANT_PHONE__c;
            workRecord.MobilePhone__c = lifeRecord.CONTRANT_MOBILE_PHONE__c;
        } else if(contract instanceof DamageContract__c) {
            DamageContract__c damageRecord = (DamageContract__c)contract;
            workRecord.NameKana__c = damageRecord.TorihikisakiKana__c;
            workRecord.BirthDate__c = damageRecord.TorihikisakiBD__c;
            workRecord.PostalCode__c = damageRecord.PostalCode__c;
            workRecord.Phone__c = damageRecord.PhoneNo__c;
            workRecord.MobilePhone__c = damageRecord.CellPhone__c;
            workRecord.EasyId__c = damageRecord.EasyId__c;
        } else if(contract instanceof LittleContract__c) {
            LittleContract__c littleRecord = (LittleContract__c)contract;
            workRecord.NameKana__c = littleRecord.SubscriberNameKana__c;
            workRecord.BirthDate__c = littleRecord.SubscriberBirthdate__c;
            workRecord.PostalCode__c = littleRecord.SubscriberZipcode__c;
            workRecord.Phone__c = littleRecord.SubscriberTel__c;
            workRecord.EasyId__c = littleRecord.EasyId__c;
        }
        
        records.add(workRecord);
        return records;
    }
}