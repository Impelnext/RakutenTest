/*
* @Class Name      : PetFreeInsuranceTrigger
* @Description     : ペットフリー保険トリガー
* @Created Date    : 2020.08.07
* @Created By      : Valsala Kumar J
* @Modified Date   : 
* @Modified        : 
*/
trigger PetFreeInsuranceTrigger on PetFreeInsurance__c (before insert, before update, after insert, after update) {
    if(Label.IsPetFreeInsuranceTriggerFlg != '0'){
        PetFreeInsuranceTriggerHandler handler = new PetFreeInsuranceTriggerHandler();
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