/*
* @Class Name      : LeadTrigger
* @Description     : リードトリガ
* @Created Date    : 2019.05.15
* @Created By      : 
* @Modified Date   : 
* @Modified        : 
*/
trigger LeadTrigger on Lead (after insert, after update) {
    LeadTriggerHandler leadHandler = new LeadTriggerHandler();
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            leadHandler.onAfterInsertProcess(Trigger.new);
        }else if(Trigger.isUpdate){
            leadHandler.onAfterUpdateProcess(Trigger.new);
        }
    }
}