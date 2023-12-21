global class BatchWorkDataCleansing implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, Data_Source__c, AccountId__c, EasyId__c, NameKana__c, BirthDate__c, PostalCode__c, CSID__c, Phone__c, MobilePhone__c
            FROM Work1__c WHERE AccountId__c != null
        ]);
    }

    global void execute(Database.BatchableContext BC, List<Work1__c> scope) {
        List<Work2__c> work2List = new List<Work2__c>();

        for (Work1__c record : scope) {
            Work2__c work2Record = new Work2__c();

            // Perform cleansing on each field using the convert method from Cleansing class
            Cleansing cleans = new Cleansing();
            work2Record.Data_Source__c = record.Data_Source__c;
            work2Record.AccountId__c = record.AccountId__c;
            work2Record.EasyId__c = record.EasyId__c!=null ? record.EasyId__c.trim(): null;
            work2Record.CSID__c = record.CSID__c!=null ? record.CSID__c.trim(): null;
            work2Record.NameKana__c = record.NameKana__c!=null ? Cleansing.convert(record.NameKana__c, Cleansing.KANA_MAP): null;
            work2Record.BirthDate__c = record.BirthDate__c!=null ? Cleansing.convert(record.BirthDate__c, Cleansing.NUMBER_MAP): null;
            work2Record.PostalCode__c = record.PostalCode__c!=null ? Cleansing.convert(record.PostalCode__c, Cleansing.NUMBER_MAP): null;
            work2Record.Phone__c = record.Phone__c!=null ? Cleansing.convert(record.Phone__c, Cleansing.NUMBER_MAP): null;
            work2Record.MobilePhone__c = record.MobilePhone__c!=null ? Cleansing.convert(record.MobilePhone__c, Cleansing.NUMBER_MAP): null;

             work2List.add(work2Record);
        }

        // Insert the cleansed records in work2
        insert work2List;
    }

    global void finish(Database.BatchableContext BC) {

    }
}