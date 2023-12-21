public class BactchAgencyMasterUpdateDC implements Database.Batchable<sObject> {
    
    public Set<String> sonpoAgencyMasterSet { get; set; }
    public Map<String, Id> sonpoAgencyMasterMap { get; set; }
    
    public BactchAgencyMasterUpdateDC(Set<String> agencySet, Map<String, Id> agencyMap) {
        sonpoAgencyMasterSet = agencySet;
        sonpoAgencyMasterMap = agencyMap;
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, AgencyCode1__c, AgencyCode2__c, AgencyCode3__c, AgencyCode4__c, AgencyCode5__c, AgencyId1__c, AgencyId2__c, AgencyId3__c, AgencyId4__c, AgencyId5__c, AgencyCode__c FROM DamageContract__c'
        +' WHERE AgencyCode1__c IN :sonpoAgencyMasterSet OR AgencyCode2__c IN :sonpoAgencyMasterSet OR AgencyCode3__c IN :sonpoAgencyMasterSet OR AgencyCode4__c IN :sonpoAgencyMasterSet OR AgencyCode5__c IN :sonpoAgencyMasterSet';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<DamageContract__c> scope) {
        List<DamageContract__c> updateList = new List<DamageContract__c>();
        for(DamageContract__c damage : scope){
            damage.AgencyId1__c = sonpoAgencyMasterMap.containsKey(damage.AgencyCode1__c) ? sonpoAgencyMasterMap.get(damage.AgencyCode1__c) : damage.AgencyId1__c;
            damage.AgencyId2__c = sonpoAgencyMasterMap.containsKey(damage.AgencyCode2__c) ? sonpoAgencyMasterMap.get(damage.AgencyCode2__c) : damage.AgencyId2__c;
            damage.AgencyId3__c = sonpoAgencyMasterMap.containsKey(damage.AgencyCode3__c) ? sonpoAgencyMasterMap.get(damage.AgencyCode3__c) : damage.AgencyId3__c;
            damage.AgencyId4__c = sonpoAgencyMasterMap.containsKey(damage.AgencyCode4__c) ? sonpoAgencyMasterMap.get(damage.AgencyCode4__c) : damage.AgencyId4__c;
            damage.AgencyId5__c = sonpoAgencyMasterMap.containsKey(damage.AgencyCode5__c) ? sonpoAgencyMasterMap.get(damage.AgencyCode5__c) : damage.AgencyId5__c;
            updateList.add(damage);
        }
        Database.update(updateList);
    }
    
    public void finish(Database.BatchableContext bc) {
        // do nothing
    }
    
}