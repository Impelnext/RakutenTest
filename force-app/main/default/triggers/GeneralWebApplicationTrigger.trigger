/*
* @Class Name      : GeneralWebApplicationTrigger
* @Description     : 損保Web申込途中保存情報トリガ
* @Created Date    : 2019.04.19
* @Created By      : 
* @Modified Date   : 
* @Modified        : 
*/
trigger GeneralWebApplicationTrigger on GeneralWebApplication__c (before insert, before update) {
    GeneralWebApplicationTriggerHandler handler = new GeneralWebApplicationTriggerHandler();
    //登録前処理 
    if(Trigger.isBefore) {
        if(Trigger.isInsert){
            handler.onBeforeProcess(Trigger.new);
        }
    }
}