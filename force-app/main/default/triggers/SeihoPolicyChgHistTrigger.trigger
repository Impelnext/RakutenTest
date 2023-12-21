/*
* @Class Name      : SeihoPolicyChgHistTrigger
* 
* @Created Date    : 2019.10.21
* @Created By      : 
* @Modified Date   : 
* @Modified        : 
*/

trigger SeihoPolicyChgHistTrigger on SeihoPolicyChgHist__c (before insert,before update) {
	  if(Label.IsSeihoPolicyChgHistFlg != '0') {
          SeihoPolicyChgHistTriggerHandler handler = new SeihoPolicyChgHistTriggerHandler();
        // 前処理 
        if(Trigger.isBefore) {
            handler.setParentRecord(Trigger.new, Trigger.oldMap);
        }
      }
}