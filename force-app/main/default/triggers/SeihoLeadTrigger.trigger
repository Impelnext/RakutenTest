/*
* @Class Name      : SeihoLeadTrigger
* @Description     : 生保Web資料請求トリガ
* @Created Date    : 2019.04.17
* @Created By      : 
* @Modified Date   : 
* @Modified        : 
*/
trigger SeihoLeadTrigger on SeihoLead__c (before insert,after insert) {
    if(Label.IsSeihoLeadTriggerFlg != '0'){
        SeihoLeadTriggerHandler handler = new SeihoLeadTriggerHandler();
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
}