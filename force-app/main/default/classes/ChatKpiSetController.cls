public class ChatKpiSetController {

    public class ChatKpiSetInput {
        @InvocableVariable(required=true)
        public String liveChatTranscriptId;
        @InvocableVariable(required=true)
        public String kpiApiName;
        @InvocableVariable(required=true)
        public String kpiSettingValue;
    }

    @InvocableMethod(label='チャットKPI値セット処理 - ChatKpiSetController ')
    public static void setKpi(List<ChatKpiSetInput > inputs) {
        
        System.debug(Logginglevel.INFO, 'ChatKpiSetController START ---------------------------------');
        
        Id liveChatTranscriptId = inputs[0].liveChatTranscriptId;

        // チャットのトランスクリプトオブジェクトからレコードを取得
        List<LiveChatTranscript> liveChatTranscripts = [SELECT Id, Name, ChatBotFlowType__c, GuidedTo__c FROM LiveChatTranscript WHERE Id = :liveChatTranscriptId];

        // 該当するIdのチャットフロー種別にKPI値をセット
        String kpiApiName = inputs[0].kpiApiName;
        String kpiSettingValue = inputs[0].kpiSettingValue;
        if(kpiApiName == 'ChatBotFlowType__c'){
            for(LiveChatTranscript liveChatTranscript : liveChatTranscripts){
                if (liveChatTranscript.ChatBotFlowType__c != null) {
                    // 既に値がセットされている場合はスキップ
                    continue;
                }
                liveChatTranscript.ChatBotFlowType__c = kpiSettingValue;
            }
            update liveChatTranscripts;
            System.debug(Logginglevel.INFO, 'INSERT liveChatTranscripts, kpiApiName = ChatBotFlowType__c');
        }else if(kpiApiName == 'GuidedTo__c'){
            for(LiveChatTranscript liveChatTranscript : liveChatTranscripts){
                liveChatTranscript.GuidedTo__c = kpiSettingValue;
            }
            update liveChatTranscripts;
            System.debug(Logginglevel.INFO, 'INSERT liveChatTranscripts, kpiApiName = GuidedTo__c');
        }else {
            // デバッグログ出力
            System.debug(Logginglevel.WARN, 'KPIAPI名がチャットボットフロー種別または誘導先に該当しません。');
        }
        System.debug(Logginglevel.INFO, 'ChatKpiSetController END ---------------------------------');
    }
}