/*
 * @Class Name      : DisclosureDesignationTrigger
 * @Description     : 開示指定者トリガー
 * @Created Date    : 2021.06.24
 * @Created By      : Takasumi Ito
 * @Modified Date   : 2021.06.24
 * @Modified By     : Takasumi Ito
 */
trigger DisclosureDesignationTrigger on DisclosureDesignation__c (before insert, before update, after insert, after update) {

    DisclosureDesignationTriggerHandler triggerHandler = new DisclosureDesignationTriggerHandler();

    if ( Label.IsDisclosureDesignationTriggerFlg != '0' ) {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                triggerHandler.checkExistDiscDesPer(Trigger.new);
                triggerHandler.editByStatus(Trigger.new);
            } else if (Trigger.isUpdate) {
                triggerHandler.editByStatus(Trigger.new);
            }
        } else if (Trigger.isAfter) {
            triggerHandler.createDisclosureDesignationHistory(Trigger.new);
        }
    }

}