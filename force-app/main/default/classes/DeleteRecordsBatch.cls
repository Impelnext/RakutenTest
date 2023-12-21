public class DeleteRecordsBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator('SELECT Id FROM work1__c');
    }

    public void execute(Database.BatchableContext context, List<work1__c> scope) {
        delete scope;
    }

    public void finish(Database.BatchableContext context) {

    }
}