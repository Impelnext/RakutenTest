/*
* @Class Name      : HealthCertificatePointTrigger
* @Description     : 健康診断書ポイントトリガ
* @Created Date    : 2023.02.06
* @Created By      : Takumi Nagaya
* @Modified Date   : 
* @Modified        : 
*/
trigger HealthCertificatePointTrigger on HealthCertificatePoint__c (before insert, before update) {
    
    if(Label.IsHealthCertificatePointTriggerFlg != '0') {
        
        HealthCertificatePointTriggerHandler handler = new HealthCertificatePointTriggerHandler();
        
        if(Trigger.isBefore) {
            handler.setParentRecord(Trigger.new, Trigger.oldMap);
        }
      
    }
}