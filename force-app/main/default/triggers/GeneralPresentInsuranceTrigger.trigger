/*
* @Class Name      : GeneralPresentInsuranceTrigger
* @Description     : 損保プレゼント保険トリガー
* @Created Date    : 2020.05.11
* @Created By      : Valsala Kumar J
* @Modified Date   : 
* @Modified        : 
*/
trigger GeneralPresentInsuranceTrigger on GeneralPresentInsurance__c (before insert, before update, after insert, after update) {
    if(Label.IsGeneralPresentInsuranceTriggerFlg != '0'){
        GeneralPresentInsuranceTriggerHandler handler = new GeneralPresentInsuranceTriggerHandler();
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