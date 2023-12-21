/*
* @Class Name      : ActivePointTrigger
* @Description     : 活動ポイントトリガ
* @Created Date    : 2023.02.06
* @Created By      : Takumi Nagaya
* @Modified Date   : 
* @Modified        : 
*/
trigger ActivePointTrigger on ActivePoint__c (before insert, before update) {
    
    if(Label.IsActivePointTriggerFlg  != '0') {
    
        ActivePointTriggerHandler handler = new ActivePointTriggerHandler();
        
        if(Trigger.isBefore) {
            handler.setParentRecord(Trigger.new, Trigger.oldMap);
        }
    }
}