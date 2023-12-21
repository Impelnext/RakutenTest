/*
* @Class Name      : OpportunityTrigger
* @Description     : 商談トリガ
* @Created Date    : 2020.01.08
* @Created By      : Valsala Kumar
* @Modified Date   : 
* @Modified By     : 
*/
trigger OpportunityTrigger on Opportunity (before insert, before update, after insert, after update, after delete) {
    //トリガを停止させたい場合はカスタム表示ラベル「IsOpportunityTriggerFlg」を0に設定
    if(Label.IsOpportunityTriggerFlg != '0') {
        OpportunityTriggerHandler handler = new OpportunityTriggerHandler();
        // 前処理 
        if(Trigger.isBefore) {
            // 作成前処理
            if(Trigger.isInsert) {
                handler.onBeforeInsertProcess(Trigger.new);
            }
            // 更新前処理
            if(Trigger.isUpdate) {
                handler.onBeforeUpdateProcess(Trigger.new, Trigger.oldMap);
            }
        }
        // 後処理 
        if(Trigger.isAfter) {
            // 作成・更新後処理
            if(Trigger.isInsert || Trigger.isUpdate) {
                handler.onAfterProcess(Trigger.new, Trigger.oldMap);
            }
            //削除後処理
            if(Trigger.isDelete) {
                handler.onAfterDeleteProcess(Trigger.old);
            }
        }
    }
}