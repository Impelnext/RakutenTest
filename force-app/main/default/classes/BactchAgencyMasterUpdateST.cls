public class BactchAgencyMasterUpdateST implements Database.Batchable<sObject> {
    
    public Set<String> shotanAgencyMasterSet { get; set; }
    public Map<String, Id> shotanAgencyMasterMap { get; set; }
    
    public BactchAgencyMasterUpdateST(Set<String> agencySet, Map<String, Id> agencyMap) {
        shotanAgencyMasterSet = agencySet;
        shotanAgencyMasterMap = agencyMap;
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, AgencyId__c, AgencyCode__c FROM LittleContract__c WHERE AgencyCode__c IN: shotanAgencyMasterSet';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<LittleContract__c> scope) {
        List<LittleContract__c> updateList = new List<LittleContract__c>();
        for(LittleContract__c little : scope){
            little.AgencyId__c = shotanAgencyMasterMap.get(little.AgencyCode__c);
            updateList.add(little);
        }
        Database.update(updateList);
    }
    
    public void finish(Database.BatchableContext bc) {
        // do nothing
    }
    
}