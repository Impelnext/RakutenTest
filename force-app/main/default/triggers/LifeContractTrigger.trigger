/*
* @Class Name      : LifeContractTrigger
* @Description     : 生保契約情報トリガ
* @Created Date    : 2019.05.15
* @Created By      : 
* @Modified Date   : 2019.12.26
* @Modified By     : Valsala Kumar
*/
trigger LifeContractTrigger on LifeContract__c (before insert, before update, after insert, after update) {
    //トリガを停止させたい場合はカスタム表示ラベル「IsLifeContractTriggerFlg」を0に設定
    if(Label.IsLifeContractTriggerFlg != '0') {
        LifeContractTriggerHandler handler = new LifeContractTriggerHandler();
        // 前処理 
        if(Trigger.isBefore) {
            handler.onBeforeProcess(Trigger.new, Trigger.oldMap);
            if(Trigger.isInsert){
                // 生保代理店マスタの設定
                handler.setAgencyRefBeforeInsert(Trigger.new);
                // 代理店マスタの設定
                handler.setAgencyMasterReference(Trigger.new,null,'insert');
                // 各種マスタの設定
                // 生保クレジットカード会社マスタ
                // 生保募集人マスタ
                // 生保エージェントマスタ
                handler.setMasterReference(Trigger.new,null,null,'insert');
                handler.setBankName(Trigger.new,null,null,'insert');
                // 商談情報設定
                handler.onBeforeInsertProcess(Trigger.new);
            }else if(Trigger.isUpdate){
                handler.setAgencyRefBeforeUpdate(Trigger.new, Trigger.oldMap);
                handler.setAgencyMasterReference(Trigger.new,Trigger.oldMap,'update');
                List<LifeContract__c> newLifeContractList = new List<LifeContract__c>();
                handler.setMasterReference(newLifeContractList,Trigger.newMap,Trigger.oldMap,'update');
                handler.setBankName(Trigger.new,Trigger.newMap,Trigger.oldMap,'update');
                // 取引先変更の場合、商談との関連解消
                handler.onBeforeUpdateProcess(Trigger.new, Trigger.oldMap);
            }
        }
        //後処理
        //if(Trigger.isAfter && UserInfo.getUserId().equals(Label.BATCH_USER_ID)){
            /** 契約者変更時の契約分割機能に伴い変更フラグON処理を撤廃 **/
            //handler.onAfterProcess(Trigger.new, trigger.oldMap);
        //}
        //後処理
        if(Trigger.isAfter){
            // 生保申込済みフラグ更新
            handler.onAfterProcess(Trigger.new, Trigger.oldMap);
            if(Trigger.isInsert) {
                //MEDIAIDα契約フラグ設定
                handler.setMediaAlphaFlg(Trigger.new, NULL, 'insert');
                //ジュニア契約情報設定処理
                handler.setJuniorFlg(Trigger.new, NULL, 'insert');
            }
            else if(Trigger.isUpdate) {
                //MEDIAIDα契約フラグ設定
                handler.setMediaAlphaFlg(Trigger.new, Trigger.oldMap, 'update');
                //ジュニア契約情報設定処理
                handler.setJuniorFlg(Trigger.new, Trigger.oldMap, 'update');
            }
        }
    }
}