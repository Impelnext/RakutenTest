trigger AgentConversionWKTrigger on agentConversionWK__c (before insert, before update) {
    
    AgentConversionWKTriggerHandler handler = new AgentConversionWKTriggerHandler();
    
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            handler.onBeforeProcess(Trigger.new);
            handler.joinSkAgencyCode(Trigger.new);
        } else if( Trigger.isUpdate) {
            handler.onBeforeProcess(Trigger.new);
            handler.joinSkAgencyCode(Trigger.new);
        }
    }
}