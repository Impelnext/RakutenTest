/*
* @Class Name      : LifeSpecialContractTrigger
* @Description     : 生保特約トリガ
* @Created Date    : 2019.05.31
* @Created By      : 
* @Modified Date   : 2020.09.18
* @Modified        : Valsala Kumar
*/
trigger LifeSpecialContractTrigger on LifeSpecialContract__c (before insert, before update, after insert, after update) {
    //トリガを停止させたい場合はカスタム表示ラベル「IsLifeSpecialContractFlg」を0に設定
    if(Label.IsLifeSpecialContractFlg != '0') {
        LifeSpecialContractTriggerHandler handler = new LifeSpecialContractTriggerHandler();
        // 前処理 
        if(Trigger.isBefore) {
            handler.setParentRecord(Trigger.new, Trigger.oldMap);
        }
        
        // 後処理 
        if(Trigger.isAfter) {
            handler.setParentInfo(Trigger.new, Trigger.oldMap);
        }
    }
}