trigger LifeApplicationSpecialTrigger on LifeApplicationSpecial__c (before insert, before update, after insert, after update) {
    LifeApplicationSpecialTriggerHandler handler = new LifeApplicationSpecialTriggerHandler();
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            //生保申込との紐づき作成
            Map<Id,LifeApplicationSpecial__c> oldMap = new Map<Id,LifeApplicationSpecial__c>();
            handler.setParentRecord(Trigger.new, oldMap);
        }else if(Trigger.isUpdate){
            //生保申込との紐づき作成
            handler.setParentRecord(Trigger.new, Trigger.oldMap);
        }
    }

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            handler.deleteLifeApplicationSpecial(Trigger.new);
        }
    }
}