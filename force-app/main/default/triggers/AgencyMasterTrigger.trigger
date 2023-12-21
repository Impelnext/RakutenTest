/*
* @Class Name      : AgencyMasterTrigger
* @Description     : 代理店マスタトリガー
* @Created Date    : 2019.09.05
* @Created By      : R.Karthikeyan
* @Modified Date   : 
* @Modified        : 
*/
trigger AgencyMasterTrigger on AgencyMaster__c (after insert, before update, after delete) {
    
    if(Label.IsAgencyMasterTriggerFlg != '0'){
        AgencyMasterTriggerHandler handler = new AgencyMasterTriggerHandler();
        if(Trigger.isAfter){
            if(Trigger.isInsert){
                handler.afterInsertUpdateProcess(Trigger.new,null,null,'insert');
            }
            if(Trigger.isDelete){
                handler.afterDeleteProcess(Trigger.oldMap);
            }
        }
        if(Trigger.isBefore){
            if(Trigger.isUpdate){
                System.debug('UPDATE TRIGGER FIRED');
                handler.afterInsertUpdateProcess(null,Trigger.oldMap,Trigger.newMap,'update');
            }
        }
    }
}