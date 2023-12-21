/*
* @Class Name      : SMSInfoTrigger
* @Description     : SMS送信情報トリガ
* @Created Date    : 2020.06.06
* @Created By      : IM)M.Tanaka
* @Modified Date   : 
* @Modified        : 
*/
// Modify 2023/03/09 RIPCRM-838_SMS承認・送信プロセスの変更 By ショウ　Start
//trigger SMSInfoTrigger on SMSInfo__c (before delete) {
trigger SMSInfoTrigger on SMSInfo__c (before delete,after update) {
// Modify 2023/03/09 RIPCRM-838_SMS承認・送信プロセスの変更 By ショウ　End
    // 前処理 
    if(Trigger.isBefore) {
        for (SMSInfo__c smsinfo :
            [SELECT Id, Status__c FROM SMSInfo__C WHERE Status__c <> '下書き' AND Id IN :Trigger.old]) {
            Trigger.oldMap.get(smsinfo.Id).addError('下書き以外のステータスでは削除できません。');
        }
    }
    // Add 2023/03/09 RIPCRM-838_SMS承認・送信プロセスの変更 By ショウ　Start
    if(Trigger.isAfter) {
        if(Trigger.isUpdate){
            Set<Id> idSet = new Set<Id>();
            for(SMSInfo__c sms:Trigger.new) {
                if(sms.status__c == '承認済み'){
                    idSet.add(sms.id);
                }
            }
            if(idSet.size()>0){
                SMSInfoTriggerHandler.sendMail(idSet);
            }
        }
    }
    // Add 2023/03/09 RIPCRM-838_SMS承認・送信プロセスの変更 By ショウ　End
}