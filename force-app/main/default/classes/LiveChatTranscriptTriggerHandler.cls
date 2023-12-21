public class LiveChatTranscriptTriggerHandler {
    // コンストラクタ
    public LiveChatTranscriptTriggerHandler() {
        
    }
    /**
     * チャットのトランスクリプト作成後処理
     * @param List<LiveChatTranscript>
     * @return 
     */
    public void onAfterInsertProcess(List<LiveChatTranscript> insertedChatList){
        if(insertedChatList.size() == 1){
            
            LiveChatTranscript liveChatObj = insertedChatList.get(0);
            List<LiveChatButton> LiveChatButtonObjLst = [SELECT Id, DeveloperName FROM LiveChatButton WHERE id =: liveChatObj.LiveChatButtonId];
            LiveChatTranscript liveChatUpdObj = [SELECT Id, ChatType__c FROM LiveChatTranscript WHERE id =: liveChatObj.Id];
            if(LiveChatButtonObjLst.size() > 0){
                LiveChatButton LiveChatButtonObj = LiveChatButtonObjLst.get(0);
                if(LiveChatButtonObj.DeveloperName == 'MannedChat'){
                    liveChatUpdObj.ChatType__c = '保全有人チャット';
                    update liveChatUpdObj;
                }
                if(LiveChatButtonObj.DeveloperName == 'BcpChatBtn'){
                    liveChatUpdObj.ChatType__c = 'BCP有人チャット';
                    update liveChatUpdObj;
                }
                if(LiveChatButtonObj.DeveloperName == 'FileLoadChatBtn'){
                    liveChatUpdObj.ChatType__c = '損保保全有人チャット';
                    update liveChatUpdObj;
                }
                if(LiveChatButtonObj.DeveloperName == 'okinawaChat'){
                    liveChatUpdObj.ChatType__c = '生命セールス有人チャット';
                    update liveChatUpdObj;
                }
            }
            
        }
    }
}