/*
* @Class Name      : SeimeiLiteratureTrigger
* @Description     : 生命発送物
* @Created Date    : 2020.07.1
* @Created By      : SRM 
* @Modified Date   : 2020.07.20
* @Modified By     : SRM
*/
trigger SeimeiLiteratureTrigger on SeimeiLiterature__c (before insert,before update) {

    if(Label.IsSeimeiLiteratureTriggerFlg!= '0') {  
        SeimeiLiteratureTriggerHandler handler = new SeimeiLiteratureTriggerHandler();
        // 前処理
        if(Trigger.isBefore) { 
            if(trigger.isInsert || trigger.isupdate){
                handler.onBeforeProcess(Trigger.new,Trigger.oldMap);
            }
        }
    } 
}