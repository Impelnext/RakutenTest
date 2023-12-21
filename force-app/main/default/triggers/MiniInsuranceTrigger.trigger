/*
* @Class Name      : MiniInsuranceTrigger
* @Description     : ミニ保険トリガ
* @Created Date    : 2019.05.15
* @Created By      : 
* @Modified Date   : 
* @Modified        : 
*/
trigger MiniInsuranceTrigger on MiniInsurance__c (before insert, before update, after insert, after update) {
    if(Label.IsMiniInsuranceTriggerFlg != '0'){
        MiniInsuranceTriggerHandler handler = new MiniInsuranceTriggerHandler();
        //登録前処理
        if(Trigger.isBefore) {
            if(Trigger.isInsert){
                handler.onBeforeInsertProcess(Trigger.new);
            }
        }
        if( Trigger.isAfter ) {
            handler.onAfterProcess(Trigger.new, Trigger.oldMap);
        }
    }
}