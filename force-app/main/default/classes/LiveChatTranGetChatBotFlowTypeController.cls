public class LiveChatTranGetChatBotFlowTypeController {

    public class LiveChatTranGetChatBotFlowTypeInput {
        @InvocableVariable(required=true)
        public String liveChatTranscriptId;
    }

    @InvocableMethod(label='チャットボットフロー種別取得処理 - LiveChatTranGetChatBotFlowTypeController ')
    public static List<String> getChatBotFlowType(List<LiveChatTranGetChatBotFlowTypeInput > inputs) {
        
        System.debug(Logginglevel.INFO, 'LiveChatTranGetChatBotFlowTypeController START ---------------------------------');
        
        Id liveChatTranscriptId = inputs[0].liveChatTranscriptId;

        // チャットのトランスクリプトオブジェクトからレコードを取得
        List<LiveChatTranscript> liveChatTranscripts = [SELECT ChatBotFlowType__c FROM LiveChatTranscript WHERE Id = :liveChatTranscriptId];

        String chatBotFlowType = '';
        for(LiveChatTranscript tran : liveChatTranscripts){
            if (tran.ChatBotFlowType__c == null) {
                continue;
            }
            chatBotFlowType = tran.ChatBotFlowType__c;
        }
        List<String> outputs = new List<String>();
        outputs.add(chatBotFlowType);

        System.debug(Logginglevel.INFO, 'LiveChatTranGetChatBotFlowTypeController END ---------------------------------');

        return outputs;
    }
}