global class BatchFetchDataDamageContract implements Database.Batchable<sObject> {

    private String strQuery;

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query fields from LifeContract
        strQuery = queryDamageContracts();
        return Database.getQueryLocator(strQuery);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Work1__c> workRecords = new List<Work1__c>();

        for(sObject obj : scope) {
            if(obj instanceof DamageContract__c) {
                workRecords.addAll(createWorkRecords((DamageContract__c)obj, 'Damage'));
            }
        }
        // Insert Work1 records
        insert workRecords;
    }

    global void finish(Database.BatchableContext BC) {
    }

    // Query method for LittleContract
    private String queryDamageContracts() {
        return 'SELECT AccountId__c,TorihikisakiKana__c,TorihikisakiBD__c,PostalCode__c,PhoneNo__c,CellPhone__c,InsuraPolicyNo__c,EasyId__c FROM DamageContract__c WHERE AccountId__c != null AND ContractStatusDisplay__c = \'有効\'';
    }
        
    private List<Work1__c> createWorkRecords(SObject contract, String dataSource) {
        List<Work1__c> records = new List<Work1__c>();
        Work1__c workRecord = new Work1__c();
        
        workRecord.AccountId__c = (Id)contract.get('AccountId__c');
        workRecord.Data_Source__c = dataSource;

        DamageContract__c damageRecord = (DamageContract__c)contract;
        workRecord.CSID__c = damageRecord.InsuraPolicyNo__c;
        workRecord.NameKana__c = damageRecord.TorihikisakiKana__c;
        workRecord.BirthDate__c = damageRecord.TorihikisakiBD__c;
        workRecord.PostalCode__c = damageRecord.PostalCode__c;
        workRecord.Phone__c = damageRecord.PhoneNo__c;
        workRecord.MobilePhone__c = damageRecord.CellPhone__c;
        workRecord.EasyId__c = damageRecord.EasyId__c;
        
        records.add(workRecord);
        return records;
    }
}