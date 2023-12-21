/*
* @Class Name      : BatchRunControlTrigger
* @Description     : バッチ起動制御トリガ
* @Created Date    : 2019.06.20
* @Created By      : 
* @Modified Date   : 
* @Modified        : 
*/

trigger BatchRunControlTrigger on BatchRunControl__c (after insert) {

    BatchRunControlTriggerHandler handler = new BatchRunControlTriggerHandler();
    //挿入後の処理
    if(Trigger.isAfter && Trigger.isInsert){
        handler.onAfterInsertProcess(Trigger.new);
    }
}