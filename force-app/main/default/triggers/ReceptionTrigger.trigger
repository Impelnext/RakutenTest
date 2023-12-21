trigger ReceptionTrigger on Reception__c (before insert,before update,after insert,after update) {

    //トリガを停止させたい場合はカスタム表示ラベル「IsReceptionTriggerFlg」を0に設定
    if(Label.IsReceptionTriggerFlg!= '0') {
    
        ReceptionTriggerHandler RecpTrigHandler = new ReceptionTriggerHandler();
        List<Reception__c> recpList = new list<Reception__c>();
        
        if(Trigger.isAfter) {
            if(Trigger.isInsert){
                Map<Id, Reception__c> initMap = new Map<Id, Reception__c>();
                RecpTrigHandler.createCaseandReq(trigger.new,initMap);
            }
            else if(Trigger.isUpdate){
                RecpTrigHandler.createCaseandReq(trigger.new,Trigger.oldMap);
            }
        }
        
        if(Trigger.isBefore) {
            if(Trigger.isInsert){
                Map<Id, Reception__c> initMap = new Map<Id, Reception__c>();
                RecpTrigHandler.receptionSetAddress(trigger.new,initMap);
               //Onyx-生保代理店マスタの紐づけ
                RecpTrigHandler.receptionSetMasterRecord(trigger.new,initMap,trigger.newMap);
            }
            else if(Trigger.isUpdate){
                RecpTrigHandler.receptionSetAddress(trigger.new,Trigger.oldMap);
                //Onyx-生保代理店マスタの紐づけ
                RecpTrigHandler.receptionSetMasterRecord(trigger.new,Trigger.oldMap,trigger.newMap);
            }
        
            RecpTrigHandler.setLongTextToText(trigger.new);
        }
    }
}