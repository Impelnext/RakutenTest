/*
* @Class Name      : HealthRefundPointTrigger
* @Description     : 健康還付ポイントトリガ
* @Created Date    : 2023.02.06
* @Created By      : Takumi Nagaya
* @Modified Date   : 
* @Modified        : 
*/
trigger HealthRefundPointTrigger on HealthRefundPoint__c (before insert, before update) {
    
    if(Label.IsHealthRefundPointTriggerFlg != '0') {
    
        HealthRefundPointTriggerHandler handler = new HealthRefundPointTriggerHandler();
        
        if(Trigger.isBefore) {
            handler.setParentRecord(Trigger.new, Trigger.oldMap);
        }
        
    }
    
}