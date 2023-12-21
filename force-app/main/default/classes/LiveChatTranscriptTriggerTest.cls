@isTest
public class LiveChatTranscriptTriggerTest
{
    @isTest(SeeAllData=true)
    static void LiveChatTranscriptTriggerTest_insert()
    {
        LiveChatTranscriptTriggerTest triggerTest = new LiveChatTranscriptTriggerTest();
              
        
        LiveChatButton LiveChatButtonObj = [SELECT Id FROM LiveChatButton WHERE DeveloperName ='MannedChat'];
        
        LiveChatVisitor lcv = new LiveChatVisitor();
        insert lcv;
                
        //チャットのトランスクリプト作成
        LiveChatTranscript lct = triggerTest.createLiveChatTra(LiveChatButtonObj.Id, lcv.id);
        insert lct;
        
        LiveChatTranscript liveChatObj = [SELECT Id, ChatType__c FROM LiveChatTranscript WHERE id =: lct.Id];
        System.AssertEquals(liveChatObj.ChatType__c, '保全有人チャット');
    }
    
    @isTest(SeeAllData=true)
    static void LiveChatTranscriptTriggerTest_insert2()
    {
        LiveChatTranscriptTriggerTest triggerTest = new LiveChatTranscriptTriggerTest();
              
        
        LiveChatButton LiveChatButtonObj = [SELECT Id FROM LiveChatButton WHERE DeveloperName ='BcpChatBtn'];
        
        LiveChatVisitor lcv = new LiveChatVisitor();
        insert lcv;
                
        //チャットのトランスクリプト作成
        LiveChatTranscript lct = triggerTest.createLiveChatTra(LiveChatButtonObj.Id, lcv.id);
        insert lct;
        
        LiveChatTranscript liveChatObj = [SELECT Id, ChatType__c FROM LiveChatTranscript WHERE id =: lct.Id];
        System.AssertEquals(liveChatObj.ChatType__c, 'BCP有人チャット');
    }
    
    @isTest(SeeAllData=true)
    static void LiveChatTranscriptTriggerTest_insert3()
    {
        LiveChatTranscriptTriggerTest triggerTest = new LiveChatTranscriptTriggerTest();
              
        
        LiveChatButton LiveChatButtonObj = [SELECT Id FROM LiveChatButton WHERE DeveloperName ='FileLoadChatBtn'];
        
        LiveChatVisitor lcv = new LiveChatVisitor();
        insert lcv;
                
        //チャットのトランスクリプト作成
        LiveChatTranscript lct = triggerTest.createLiveChatTra(LiveChatButtonObj.Id, lcv.id);
        insert lct;
        
        LiveChatTranscript liveChatObj = [SELECT Id, ChatType__c FROM LiveChatTranscript WHERE id =: lct.Id];
        System.AssertEquals(liveChatObj.ChatType__c, '損保保全有人チャット');
    }
    
    private LiveChatTranscript createLiveChatTra(Id LiveChatButtonId, Id lcvId){
        return new LiveChatTranscript(
            LiveChatButtonId = LiveChatButtonId,
            LiveChatVisitorid = lcvId
        );
    }
}