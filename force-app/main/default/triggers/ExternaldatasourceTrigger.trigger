/*
* @Class Name      : ExternaldatasourceTrigger
* @Description     : 外部データソーストリガ
* @Created Date    : 2019.12.19
* @Created By      : Valsala Kumar
* @Modified Date   : 
* @Modified        : 
*/
trigger ExternaldatasourceTrigger on Externaldatasource__c (before insert, before update, after insert, after update) {
    ExternaldatasourceTriggerHandler handler = new ExternaldatasourceTriggerHandler();
    //登録前処理 
    if(Trigger.isBefore) {
        if(Trigger.isInsert){
            handler.onBeforeInsertProcess(Trigger.new);
        }
    }
    if( Trigger.isAfter ) {
        handler.onAfterProcess(Trigger.new);
    }
}