trigger LiveChatTranscriptTrigger on LiveChatTranscript (after insert) {
    System.debug('update operation');
    LiveChatTranscriptTriggerHandler handler = new LiveChatTranscriptTriggerHandler();
    // 前処理 
    if(Trigger.isAfter) {
        handler.onAfterInsertProcess(Trigger.new);
    }
}