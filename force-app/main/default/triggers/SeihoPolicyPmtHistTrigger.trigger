trigger SeihoPolicyPmtHistTrigger on SeihoPolicyPmtHist__c (before insert,before update) {
if(Label.IsSeihoPolicyPmtFlg != '0') {
        SeihoPolicyPmtHistTriggerHandler handler = new SeihoPolicyPmtHistTriggerHandler();
        // 前処理 
        if(Trigger.isBefore) {
            handler.setParentRecord(Trigger.new, Trigger.oldMap);
        }
    }
}