@IsTest
public class LiveChatTranGetChatBotFlowTypeCntrlTest {
    
    @IsTest
    static void test01() {

        LiveChatVisitor lcv = new LiveChatVisitor();
        insert lcv;
        LiveChatTranscript lct = new LiveChatTranscript();
        lct.LiveChatVisitorId = lcv.Id;
        insert lct;

        Test.startTest();
        List<LiveChatTranGetChatBotFlowTypeController.LiveChatTranGetChatBotFlowTypeInput > inputs = new List<LiveChatTranGetChatBotFlowTypeController.LiveChatTranGetChatBotFlowTypeInput >();
        LiveChatTranGetChatBotFlowTypeController.LiveChatTranGetChatBotFlowTypeInput prm = new LiveChatTranGetChatBotFlowTypeController.LiveChatTranGetChatBotFlowTypeInput();
        prm.liveChatTranscriptId = lct.id;
        inputs.add(prm);
        LiveChatTranGetChatBotFlowTypeController.getChatBotFlowType(inputs);
        Test.stopTest();
    }

}