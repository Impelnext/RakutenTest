trigger RequestTrigger on Request__c (before insert, before update,after insert,after update) {
    //トリガを停止させたい場合はカスタム表示ラベル「IsRequestTriggerFlg」を0に設定
    if(Label.IsRequestTriggerFlg != '0') {
        RequestTriggerHandler handler = new RequestTriggerHandler();
      
        // 前処理   
        if(Trigger.isBefore) {
            if(Trigger.isInsert){
                Map<Id, Request__c> initMap = new Map<Id, Request__c>();
                handler.onBeforeProcess(Trigger.new, initMap);
            }else{
                handler.onBeforeProcess(Trigger.new, Trigger.oldMap);
            }
            handler.setLongTextToText(trigger.new);
        }
        if(Trigger.isAfter) {
            if(Trigger.isInsert){
                Map<Id, Request__c> initMap = new Map<Id, Request__c>();
              handler.onAfterProcess(Trigger.new, initMap);

            }else{
                handler.onAfterProcess(Trigger.new, Trigger.oldMap);
            }
        }
    }
}