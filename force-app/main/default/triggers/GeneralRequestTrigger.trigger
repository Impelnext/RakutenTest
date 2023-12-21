/*
* @Class Name      : GeneralRequestTrigger
* @Description     : 損保資料請求トリガ
* @Created Date    : 2019.04.19
* @Created By      : 
* @Modified Date   : 
* @Modified        : 
*/
trigger GeneralRequestTrigger on GeneralRequest__c (before insert, after insert) {
    GeneralRequestTriggerHandler handler = new GeneralRequestTriggerHandler();
    //登録前処理 
    if(Trigger.isBefore) {
        if(Trigger.isInsert){
            handler.onBeforeInsertProcess(Trigger.new);
        }
    }
    /*else{
        if(Trigger.isInsert){
            handler.onAfterInsertProcess(Trigger.new);
        }
    }*/
}