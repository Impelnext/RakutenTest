/*
* @Class Name      : CaseTrigger
* @Description     : ケーストリガ
* @Created Date    : 2019.04.18
* @Created By      : 
* @Modified Date   : 2019.08.15
* @Modified        : AB折田
* @Modified Date   : 2019.11.12
* @Modified        : SRM-Kumar
* @Modified Date   : 2020.05.08
* @Modified        : SRM-Kumar
*/
trigger CaseTrigger on Case (before insert, before update, after insert, after update) {
    //トリガを停止させたい場合はカスタム表示ラベル「IsCaseTriggerFlg」を0に設定
    if(Label.IsCaseTriggerFlg != '0') {
        CaseTriggerHandler handler = new CaseTriggerHandler();
        
        if(Trigger.isBefore){
            if(Trigger.isInsert){
                //handler.setCaseRecordType(Trigger.new);
                Map<Id, Case> initMap = new Map<Id, Case>();
                handler.setCaseOwner(Trigger.new, initMap);
                handler.setLfCntContractorBeforeNameKanji(Trigger.new);
                // LifeSFDCMigration - Link Case to Accounts
                handler.setSeimeiCaseAccounts(Trigger.new, NULL);
            }else if(Trigger.isUpdate){
                //handler.setCaseRecordType(Trigger.new);
                handler.updateCaseRecordType(Trigger.new, Trigger.oldMap);
                handler.setCaseOwner(Trigger.new, Trigger.oldMap);
                //handler.setNGAgencyGroup(Trigger.new);
                handler.setLfCntContractorBeforeNameKanji(Trigger.new);
                // LifeSFDCMigration - Link Case to Accounts
                handler.setSeimeiCaseAccounts(Trigger.new, Trigger.oldMap);
            }
            
            // NG代理店設定
            handler.setNGAgency(Trigger.new);
        }
        
        // 生保からケース作成、または、画面でケース作成
        if(Trigger.isAfter){
            if(Trigger.isInsert){
                //handler.onAfterInsertProcess(Trigger.new);
                handler.setAccountOpenCaseAfterInsert(Trigger.New);
            }else if(Trigger.isUpdate){
                handler.setAccountOpenCaseAfterUpdateDelete(Trigger.new);
            }else if(Trigger.isDelete){
                handler.setAccountOpenCaseAfterUpdateDelete(Trigger.old);
            }
        }
    }
}