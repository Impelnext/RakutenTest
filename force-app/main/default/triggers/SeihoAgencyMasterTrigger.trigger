/*
* @Class Name      : SeihoAgencyMasterTrigger
* @Description     : 生保代理店マスタのトリガー
* @Created Date    : 2020.05.27
* @Created By      : SRM 
* @Modified Date   : 2020.05.28
* @Modified By     : SRM 
* @Modified Date   : 2021.02.15
* @Modified By     : SRM - ONYX（マスタ-取引先関連付け対応）
*/
trigger SeihoAgencyMasterTrigger on SeihoAgencyMaster__c (before insert, before update, after insert, after update) {
    
    if (Label.IsSeihoAgencyMasterTriggerFlg != '0') {
        SeihoAgencyMasterTriggerHandler handler = new SeihoAgencyMasterTriggerHandler();
        // 前処理
        if (Trigger.isBefore) {
            if(Trigger.isInsert || Trigger.isUpdate) {
                handler.onBeforeProcess(Trigger.new,Trigger.oldMap);
            }
        }
    }
}