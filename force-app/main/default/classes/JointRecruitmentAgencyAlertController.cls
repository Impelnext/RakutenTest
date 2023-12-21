public class JointRecruitmentAgencyAlertController {

    public JointRecruitmentAgencyAlertController() {
    }
    
    @AuraEnabled
    public static map<String,Integer> getContractInfo(String accountId){

        Integer msgDisplayFlag = 0;
        Map<String,Integer> contractCountMap = new Map<String,Integer>();

        List<AggregateResult> lifeContractResult = [SELECT count(Id) lifeCnt FROM LifeContract__c WHERE AccountId__c =: accountId AND JointRecruitmentAgencySign__c = TRUE];
        for(AggregateResult res : lifeContractresult){
            msgDisplayFlag = (Integer)res.get('lifeCnt') == 0 ? msgDisplayFlag+= 1 : msgDisplayFlag;
            contractCountMap.put('lifeCnt',(Integer)res.get('lifeCnt'));
        }

        List<AggregateResult> damageContractResult = [SELECT count(Id) damageCnt FROM DamageContract__c WHERE AccountId__c =: accountId AND (JointRecruitmentAgencySign1__c = TRUE OR 
                                                      JointRecruitmentAgencySign2__c = TRUE OR JointRecruitmentAgencySign3__c = TRUE OR JointRecruitmentAgencySign4__c = TRUE OR
                                                      JointRecruitmentAgencySign5__c = TRUE)];
        for(AggregateResult res : damageContractResult){
            msgDisplayFlag = (Integer)res.get('damageCnt') == 0 ? msgDisplayFlag+= 1 : msgDisplayFlag;
            contractCountMap.put('damageCnt',(Integer)res.get('damageCnt'));
        }

        List<AggregateResult> littleContractResult = [SELECT count(Id) littleCnt FROM LittleContract__c WHERE AccountId__c =: accountId AND JointRecruitmentAgencySign__c = TRUE];
        System.debug('littleContractResult::'+littleContractResult);
        for(AggregateResult res : littleContractResult){
            msgDisplayFlag = (Integer)res.get('littleCnt') == 0 ? msgDisplayFlag+= 1 : msgDisplayFlag;
            contractCountMap.put('littleCnt',(Integer)res.get('littleCnt'));
        }
        contractCountMap.put('msgDisplayFlag', msgDisplayFlag);
        System.debug('contractCountMap::'+contractCountMap);
        return contractCountMap;
    }
}