/*
* @Class Name      : LittleContractTrigger
* @Description     : 少短契約情報トリガ
* @Created Date    : 2019.05.15
* @Created By      : 
* @Modified Date   : 2019.12.26
* @Modified By     : Valsala Kumar
*/
trigger LittleContractTrigger on LittleContract__c (before insert, before update, after insert, after update) {
    //トリガを停止させたい場合はカスタム表示ラベル「IsLittleContractTriggerFlg」を0に設定
    if(Label.IsLittleContractTriggerFlg != '0') {
        LittleContractTriggerHandler handler = new LittleContractTriggerHandler();
        // 前処理 
        if(Trigger.isBefore) {
            //handler.onBeforeProcess(Trigger.new, Trigger.oldMap);
            if(Trigger.isInsert){
                handler.setAgencyMasterReference(Trigger.new,null,'insert');
                handler.onBeforeInsertProcess(Trigger.new);
            }
            if(Trigger.isUpdate){
                handler.setAgencyMasterReference(Trigger.new,Trigger.oldMap,'update');
                handler.onBeforeUpdateProcess(Trigger.new,Trigger.oldMap);
            }
        }
        
        //挿入後の処理
        if(Trigger.isAfter){
            if(Trigger.isInsert){
                //handler.onAfterProcess(Trigger.new);
                handler.onAfterProcess(Trigger.new, NULL);
            }
            //if(Trigger.isUpdate && UserInfo.getUserId().equals(Label.BATCH_USER_ID)){
                /** 契約者変更時の契約分割機能に伴い変更フラグON処理を撤廃 **/
                //handler.onAfterUpdateProcess(Trigger.new, Trigger.oldMap);
            //}
            if(Trigger.isUpdate){
                handler.onAfterProcess(Trigger.new, Trigger.oldMap);
            }
        }
    }
}