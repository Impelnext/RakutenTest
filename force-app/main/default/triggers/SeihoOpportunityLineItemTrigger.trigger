trigger SeihoOpportunityLineItemTrigger on SeihoOpportunityLineItem__c (before insert, before update, after insert, after update, after delete) {
    if(Label.IsSeihoOpportunityLineItemTriggerFlg != '0'){
        SeihoOppLineItemTriggerHandler handler = new SeihoOppLineItemTriggerHandler();
        
        if(Trigger.isBefore){
            if(Trigger.isInsert){
                //生保申込との紐づき作成
                Map<Id,SeihoOpportunityLineItem__c> oldMap = new Map<Id,SeihoOpportunityLineItem__c>();
                handler.setParentRecord(Trigger.new, oldMap);
                /**** RIPCRM-179 修正　開始 ***/
                handler.setLineItemProductName(Trigger.new,null,Trigger.oldMap);
                /**** RIPCRM-179 修正　終了***/
            }else if(Trigger.isUpdate){
                //生保申込との紐づき作成
                handler.setParentRecord(Trigger.new, Trigger.oldMap);
                /**** RIPCRM-179 修正　開始 ***/
                handler.setLineItemProductName(Trigger.new,Trigger.newMap,Trigger.oldMap);
                /**** RIPCRM-179 修正　終了***/
            }
        }
        
        if(Trigger.isAfter){
            if(Trigger.isInsert){
                handler.deleteSeihoOppLineItem(Trigger.new);
                // Web申込保険料設定判定
                handler.updateWebSeihoOpportunities(Trigger.new, NULL);
            }else if(Trigger.isUpdate){
                // Web申込保険料設定判定
                handler.updateWebSeihoOpportunities(Trigger.new, Trigger.oldMap);
            }else if(Trigger.isDelete){
                // Web申込保険料設定判定
                handler.updateWebSeihoOpportunities(Trigger.old, NULL);
            }
        }
    }
}