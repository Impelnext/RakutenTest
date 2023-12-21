/*
* @Class Name      : SeihoRecruiterMasterTrigger
* @Description     : 生保募集人マスタトリガ
* @Created Date    : 2020.05.26
* @Created By      : SRM 
* @Modified Date   : 2020.05.27
* @Modified By     : SRM 
* @Modified Date   : 2021.02.15
* @Modified By     : SRM - ONYX（マスタ-取引先関連付け対応）
*/
trigger SeihoRecruiterMasterTrigger on SeihoRecruiterMaster__c(before insert, before update, after insert, after update) {
    
    if(Label.IsSeihoRecruiterMasterTriggerFlg != '0') {
        SeihoRecruiterMasterTriggerHandler handler = new SeihoRecruiterMasterTriggerHandler();
        // 前処理
        if(Trigger.isBefore){
            if(trigger.isInsert || trigger.isupdate){
                handler.onBeforeProcess(Trigger.new,Trigger.oldMap);
            }
        }
    }
}