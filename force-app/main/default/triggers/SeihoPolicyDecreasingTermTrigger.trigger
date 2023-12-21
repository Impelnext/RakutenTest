trigger SeihoPolicyDecreasingTermTrigger on SeihoPolicyDecreasingTerm__c (before insert,before update) {
 if(Label.IsSeihoPolicyDecreasingTermFlg != '0') {
        SeihoPolicyDecreasingTermHandler handler = new SeihoPolicyDecreasingTermHandler();
        // 前処理 
        if(Trigger.isBefore) {
            handler.setParentRecord(Trigger.new, Trigger.oldMap);
        }
    }
}