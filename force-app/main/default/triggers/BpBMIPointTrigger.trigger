/*
* @Class Name      : BpBMIPointTrigger
* @Description     : 血圧BMIポイントトリガ
* @Created Date    : 2023.02.06
* @Created By      : Takumi Nagaya
* @Modified Date   : 
* @Modified        : 
*/
trigger BpBMIPointTrigger on BpBMIPoint__c (before insert, before update) {
    
    if(Label.IsBpBMIPointTriggerFlg != '0') {
    
        BpBMIPointTriggerHandler handler = new BpBMIPointTriggerHandler();
        
        if(Trigger.isBefore) {
            handler.setParentRecord(Trigger.new, Trigger.oldMap);
        }
    }
}