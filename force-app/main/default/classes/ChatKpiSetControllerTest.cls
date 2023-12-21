@IsTest
public class ChatKpiSetControllerTest {
    
    @IsTest
    static void testSetKpi01() {

        LiveChatVisitor lcv = new LiveChatVisitor();
        insert lcv;
        LiveChatTranscript lct = new LiveChatTranscript();
        lct.LiveChatVisitorId = lcv.Id;
        insert lct;

        Test.startTest();
        List<ChatKpiSetController.ChatKpiSetInput > inputs = new List<ChatKpiSetController.ChatKpiSetInput >();
        ChatKpiSetController.ChatKpiSetInput prm = new ChatKpiSetController.ChatKpiSetInput();
        prm.kpiApiName = 'ChatBotFlowType__c';
        prm.kpiSettingValue = '生命フロー';
        prm.liveChatTranscriptId = lct.id;
        inputs.add(prm);
        ChatKpiSetController.setKpi(inputs);
        Test.stopTest();
    }

    @IsTest
    static void testSetKpi02() {

        LiveChatVisitor lcv = new LiveChatVisitor();
        insert lcv;
        LiveChatTranscript lct = new LiveChatTranscript();
        lct.LiveChatVisitorId = lcv.Id;
        insert lct;

        Test.startTest();
        List<ChatKpiSetController.ChatKpiSetInput > inputs = new List<ChatKpiSetController.ChatKpiSetInput >();
        ChatKpiSetController.ChatKpiSetInput prm = new ChatKpiSetController.ChatKpiSetInput();
        prm.kpiApiName = 'GuidedTo__c';
        prm.kpiSettingValue = '有人チャット';
        prm.liveChatTranscriptId = lct.id;
        inputs.add(prm);
        ChatKpiSetController.setKpi(inputs);
        Test.stopTest();
    }

    @IsTest
    static void testSetKpi03() {

        LiveChatVisitor lcv = new LiveChatVisitor();
        insert lcv;
        LiveChatTranscript lct = new LiveChatTranscript();
        lct.ChatBotFlowType__c = '生命フロー';
        lct.LiveChatVisitorId = lcv.Id;
        insert lct;

        Test.startTest();
        List<ChatKpiSetController.ChatKpiSetInput > inputs = new List<ChatKpiSetController.ChatKpiSetInput >();
        ChatKpiSetController.ChatKpiSetInput prm = new ChatKpiSetController.ChatKpiSetInput();
        prm.kpiApiName = 'ChatBotFlowType__c';
        prm.kpiSettingValue = '損保フロー';
        prm.liveChatTranscriptId = lct.id;
        inputs.add(prm);
        ChatKpiSetController.setKpi(inputs);
        Test.stopTest();
    }

}