/*
* @Class Name      : AccountTrigger
* @Description     : 取引先トリガ
* @Created Date    : 2019.05.16
* @Created By      : 
* @Modified Date   : 2020.01.08
* @Modified By     : Valsala Kumar
* @Modified Date   : 2020.06.10
* @Modified By     : SRM - ONYX
* @Modified Date   : 2021.02.15
* @Modified By     : SRM - ONYX（マスタ-取引先関連付け対応）
*/
trigger AccountTrigger on Account (before insert, before update, after insert, after update) {
    //トリガを停止させたい場合はカスタム表示ラベル「IsAccountTriggerFlg」を0に設定
    if(Label.IsAccountTriggerFlg != '0') {
        AccountTriggerHandler handler = new AccountTriggerHandler();
        // 前処理 
        if(Trigger.isBefore) {
            handler.onBeforeProcess(Trigger.new, Trigger.oldMap);
        }
        // 後処理 
        if(Trigger.isAfter) {
            // 更新後処理
            if(Trigger.isUpdate) {
                handler.onAfterUpdateProcess(Trigger.new, Trigger.oldMap);
            }
        }
    }
}