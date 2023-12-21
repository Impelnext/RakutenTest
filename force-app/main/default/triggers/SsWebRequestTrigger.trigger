/*
* @Class Name      : SsWebRequestTrigger
* @Description     : 少短Web資料請求トリガ
* @Created Date    : 2019.04.19
* @Created By      : 
* @Modified Date   : 
* @Modified        : 
*/
trigger SsWebRequestTrigger on SsWebRequest__c (before insert,after insert) {
    SsWebRequestTriggerHandler handler = new SsWebRequestTriggerHandler();
    //登録前処理 
    if(Trigger.isBefore) {
        if(Trigger.isInsert){
            handler.onBeforeInsertProcess(Trigger.new);
        }
    }else{
        if(Trigger.isInsert){
            handler.onAfterInsertProcess(Trigger.new);
        }
    }
}