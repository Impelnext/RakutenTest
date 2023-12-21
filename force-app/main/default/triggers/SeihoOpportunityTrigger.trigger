/*
* @Class Name      : SeihoOpportunityTrigger
* @Description     : 生保申込みトリガ
* @Created Date    : 2019.04.17
* @Created By      : 
* @Modified Date   : 
* @Modified        : 
*/
trigger SeihoOpportunityTrigger on SeihoOpportunity__c (before insert, after insert, before update, after update) {
    if(Label.IsSeihoOpportunityTriggerFlg != '0'){
        SeihoOpportunityTriggerHandler handler = new SeihoOpportunityTriggerHandler();
        //登録前処理 
        if(Trigger.isBefore) {
            if (Trigger.isInsert) {
                handler.onBeforeProcess(Trigger.new);
            }
            if (Trigger.isUpdate) {
                handler.onBeforeUpdateProccess(Trigger.new);
            }
        }
        //挿入後の処理
        if(Trigger.isAfter){
            handler.onAfterProcess(Trigger.new, trigger.oldMap);
        }
    }
}