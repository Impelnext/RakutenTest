/*
* @Class Name      : BpBMIPointTriggerHandler
* @Description     : 血圧BMIポイントトリガのハンドラー
* @Created Date    : 2023.02.06
* @Created By      : Takumi Nagaya
* @Modified Date   : 
* @Modified        : 
*/
public class BpBMIPointTriggerHandler {
    
    public BpBMIPointTriggerHandler(){}
    
    public void setParentRecord(List<BpBMIPoint__c> newList, Map<Id, BpBMIPoint__c> oldMap){
        Set<String> parentNoSet = new Set<String>();
        SeihoHelper helper = new SeihoHelper();
        for(BpBMIPoint__c target : newList){
            
            // Check if it is Insert or Update (Change) of POL_NUM__c Value
            if (oldMap == NULL || 
                oldMap.get(target.Id).POL_NUM__c != target.POL_NUM__c) {
                if( String.isNotBlank(target.POL_NUM__c) ) {
                    parentNoSet.add(target.POL_NUM__c);
                }
            }
        }
        
        if(parentNoSet.size() > 0){
            Map<String, Id> parentRecMap = new Map<String, Id>();
            parentRecMap = helper.getPolicyNumberMap( parentRecMap, parentNoSet );
            
            for(BpBMIPoint__c target : newList){
                if (oldMap == NULL || 
                    oldMap.get(target.Id).POL_NUM__c != target.POL_NUM__c) {
                    
                    // Initialize the LifeContract Lookup Fields
                    target.LifeContract__c = NULL;
                    
                    // Set the LifeContract ID, If POL_NUM__c match is found
                    if( String.isNotBlank(target.POL_NUM__c) && 
                        parentRecMap.get(target.POL_NUM__c) != Null ) {
                        target.LifeContract__c = parentRecMap.get(target.POL_NUM__c);
                    }
                }
            }
        }
    }
}