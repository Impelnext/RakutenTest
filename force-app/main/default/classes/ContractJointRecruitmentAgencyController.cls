public class ContractJointRecruitmentAgencyController {

    
    @AuraEnabled
    public static ContractWrapper getContractInfo(String recordId){

        ContractWrapper wrapper = new ContractWrapper();

        Id recId = (Id) recordId;
        System.debug('recId ' + recId);
        List<String> searchList = new List<String>();
        Map<String,List<AgencyMaster__c>> contractJointAgencyMap = new Map<String,List<AgencyMaster__c>>();

        if(recId.getSobjectType().getDescribe().getName().equals('LifeContract__c')){

            List<LifeContract__c> lifeConList = [SELECT AgencyId__r.SeihoAgencyCode__c FROM LifeContract__c WHERE Id =: recId];
            for(LifeContract__c life : lifeConList){
                if(life.AgencyId__r.SeihoAgencyCode__c != null)
                    searchList.add(life.AgencyId__r.SeihoAgencyCode__c);
            }
            System.debug('--- searchList ' + searchList);
            if(searchList != null && searchList.size() > 0)
                wrapper = getAgencyInfo('SeihoAgencyCode__c', recId, searchList);

            system.debug('wrapper ' + wrapper);

        }else if(recId.getSobjectType().getDescribe().getName().equals('DamageContract__c')){

            List<DamageContract__c> damageConList = [SELECT AgencyId1__r.SonpoAgencyCode__c, AgencyId2__r.SonpoAgencyCode__c, AgencyId3__r.SonpoAgencyCode__c, 
                                                    AgencyId4__r.SonpoAgencyCode__c, AgencyId5__r.SonpoAgencyCode__c FROM DamageContract__c WHERE Id =: recId];

            for(DamageContract__c damage : damageConList){
                searchList.add(damage.AgencyId1__r.SonpoAgencyCode__c != null ? damage.AgencyId1__r.SonpoAgencyCode__c :null);
                searchList.add(damage.AgencyId2__r.SonpoAgencyCode__c != null ? damage.AgencyId2__r.SonpoAgencyCode__c :null);
                searchList.add(damage.AgencyId3__r.SonpoAgencyCode__c != null ? damage.AgencyId3__r.SonpoAgencyCode__c :null);
                searchList.add(damage.AgencyId4__r.SonpoAgencyCode__c != null ? damage.AgencyId4__r.SonpoAgencyCode__c :null);
                searchList.add(damage.AgencyId5__r.SonpoAgencyCode__c != null ? damage.AgencyId5__r.SonpoAgencyCode__c :null);
            }

            System.debug('---searchList ' + searchList);
            System.debug('---searchList size ' + searchList.size());
            Set<String> checkSet = new Set<String>(searchList);
            checkSet.remove(null);
            System.debug('---checkSet ' + checkSet);
            searchList.clear();
            searchList.addAll(checkSet);
            if(searchList != null && searchList.size() > 0)
                wrapper = getAgencyInfo('SonpoAgencyCode__c', recId, searchList);

        }else if(recId.getSobjectType().getDescribe().getName().equals('LittleContract__c')){

            List<LittleContract__c> littleConList = [SELECT AgencyId__r.ShotanAgencyCode__c FROM LittleContract__c WHERE Id =: recId];
            for(LittleContract__c little : littleConList){
                if(little.AgencyId__r.ShotanAgencyCode__c != null)
                    searchList.add(little.AgencyId__r.ShotanAgencyCode__c);
            }

            if(searchList != null && searchList.size() > 0)
                wrapper = getAgencyInfo('ShotanAgencyCode__c', recId, searchList);
        }
        System.debug('contractJointAgencyMap ' + contractJointAgencyMap);
        return wrapper;
    }

    public static ContractWrapper getAgencyInfo(String fieldName, Id recId, List<String> searchList){

        System.debug('-- getAgencyInfo called');
        Boolean isExistingAgreementFlag  = false;
        ContractWrapper wrapper = new ContractWrapper();

        Map<String,List<AgencyMaster__c>> contractJointAgencyMap = new Map<String,List<AgencyMaster__c>>();

        String queryString  = 'SELECT Id, SeihoAgencyCode__c, SonpoAgencyCode__c, ShotanAgencyCode__c, SonpoGeneralUnitCarFlag__c, SonpoGeneralUnitFireFlag__c, SonpoGeneralUnitAccidentFlag__c, SonpoDisplayText__c,ExistingAgreementFlag__c ';
               queryString += 'FROM AgencyMaster__c WHERE ' + fieldName + ' IN: searchList AND JointRecruitmentPermissionFlag__c = TRUE';

        List<AgencyMaster__c> agencyMasterList = Database.query(queryString);
            
        System.debug('--- agencyMasterList ' + agencyMasterList.size());
        for(AgencyMaster__c agency : agencyMasterList){
            wrapper.agencyMasterList.add(agency);      
            wrapper.jointAgencyMsgFlag = true;
            if(agency.ExistingAgreementFlag__c)
                wrapper.isExistingAgreementFlag = true;
        }
        return wrapper;
    }

    public class ContractWrapper{

        @AuraEnabled
        public List<AgencyMaster__c> agencyMasterList = new List<AgencyMaster__c>();
        
        @AuraEnabled
        public boolean jointAgencyMsgFlag{get;set;}

        @AuraEnabled
        public boolean isExistingAgreementFlag {get;set;}
            
    }
}