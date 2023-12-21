public class BactchAgencyMasterUpdateSH implements Database.Batchable<sObject> {
    
    public Set<String> seihoAgencyMasterSet { get; set; }
    public Map<String, Id> seihoAgencyMasterMap { get; set; }
    
    public BactchAgencyMasterUpdateSH(Set<String> agencySet, Map<String, Id> agencyMap) {
        seihoAgencyMasterSet = agencySet;
        seihoAgencyMasterMap = agencyMap;
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, AgencyId__c, AGENCY_NUM__c FROM LifeContract__c WHERE AGENCY_NUM__c IN: seihoAgencyMasterSet';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<LifeContract__c> scope) {
        List<LifeContract__c> updateList = new List<LifeContract__c>();
        for(LifeContract__c life : scope){
            life.AgencyId__c = seihoAgencyMasterMap.get(life.AGENCY_NUM__c);
            updateList.add(life);
        }
        Database.update(updateList);
    }
    
    public void finish(Database.BatchableContext bc) {
        // do nothing
    }
    
}