/*
* @Class Name      : callingImportTrigger 
* @Description     : 架電リスト取込みマスタトリガのテストクラス
* @Created Date    : 2020.07.15
* @Created By      : SRM
* @Modified Date   : 2020.07.20
* @Modified        : SRM
*/
trigger callingImportTrigger on CallingImport__c (before insert) {

    if(Label.IsCallingImportTriggerFlg!= '0') {
        
        CallingImportTriggerHandler callingImport = new CallingImportTriggerHandler();
        callingImport.onBeforeProcess(trigger.new);
       
    }
}