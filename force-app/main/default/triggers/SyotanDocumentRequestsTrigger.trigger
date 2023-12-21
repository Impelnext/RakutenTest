/*
* @Class Name      : SyotanDocumentRequestsTrigger
* @Description     : 少短資料請求トリガ
* @Created Date    : 2019.05.17
* @Created By      : 
* @Modified Date   : 
* @Modified        : 
*/
trigger SyotanDocumentRequestsTrigger on SyotanDocumentRequests__c (before insert,after insert) {
    SyotanDocumentRequestsTriggerHandler handler = new SyotanDocumentRequestsTriggerHandler();
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