/*
* @Class Name      : SeihoAgentMasterTrigger
* @Description     : 生保エージェントマスタトリガ
* @Created Date    : 2020.05.28
* @Created By      : SRM 
* @Modified Date   : 2020.05.29
* @Modified By     : SRM 
* @Modified Date   : 2021.02.15
* @Modified By     : SRM - ONYX（マスタ-取引先関連付け対応）
*/
trigger SeihoAgentMasterTrigger on SeihoAgentMaster__c(before insert, before update, after insert, after update) {
    
    if(Label.IsSeihoAgentMasterTriggerFlg != '0') {
        SeihoAgentMasterTriggerHandler handler = new SeihoAgentMasterTriggerHandler();
        // 前処理
        if(Trigger.isBefore) {
            if(trigger.isInsert || trigger.isupdate){
                handler.onBeforeProcess(Trigger.new,Trigger.oldMap);
            }
        }
    }
}