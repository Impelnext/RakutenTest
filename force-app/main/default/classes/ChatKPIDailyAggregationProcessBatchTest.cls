@isTest
public class ChatKPIDailyAggregationProcessBatchTest {
    @IsTest() static void testBatch() {
        
        //ユーザ作成
        Profile p = [Select id,name From Profile Where name = '生保担当ロール' LIMIT 1];
        User u;
        u = new User();
        u.LastName = 'testChatKPIDaily';
        u.Alias = 'test';
        u.Email = 'testChatKPIDaily@test.com';
        u.UserName = u.Email;
        u.EmailEncodingKey = 'ISO-2022-JP';
        u.TimeZoneSidKey = 'Asia/Tokyo';
        u.LocaleSidKey = 'ja_JP';
        u.LanguageLocaleKey = 'ja';
        u.profileId = p.Id;
        insert u;
        
        LiveChatVisitor lcv = new LiveChatVisitor();
        insert lcv;
                
        //チャットのトランスクリプト作成
        List<LiveChatTranscript> LiveChatTranscriptList = new List<LiveChatTranscript>();
        LiveChatTranscript lct = new LiveChatTranscript(
            OwnerId = u.Id,
            CreatedDate = datetime.now().addhours(-1),
            ChatBotFlowType__c = '楽天生命',
            SupportStatus__c = '対応完了(SMS完了)',
            LiveChatVisitorId = lcv.Id
            );
        LiveChatTranscriptList.add(lct);
        insert LiveChatTranscriptList;
        
        //チャットのトランスクリプトイベント作成
        List<LiveChatTranscriptEvent> LiveChatTranscriptEventlist = new List<LiveChatTranscriptEvent>();
        LiveChatTranscriptEvent lcte1 = new LiveChatTranscriptEvent(
            Time = datetime.now().addhours(-1), 
            CreatedDate = datetime.now().addhours(-1), 
            Type = 'Transfer', 
            LiveChatTranscriptId = lct.id
        );
        LiveChatTranscriptEventlist.add(lcte1);

        LiveChatTranscriptEvent lcte2 = new LiveChatTranscriptEvent(
            Time = datetime.now().addhours(-1), 
            CreatedDate = datetime.now().addhours(-1), 
            Type = 'TransferredToQueue', 
            LiveChatTranscriptId = lct.id
        );
        LiveChatTranscriptEventlist.add(lcte2);

        LiveChatTranscriptEvent lcte3 = new LiveChatTranscriptEvent(
            Time = datetime.now().addhours(-1), 
            CreatedDate = datetime.now().addhours(-1), 
            Type = 'ChatRequest', 
            LiveChatTranscriptId = lct.id
        );
        LiveChatTranscriptEventlist.add(lcte3);

        LiveChatTranscriptEvent lcte4 = new LiveChatTranscriptEvent(
            Time = datetime.now().addhours(-1), 
            CreatedDate = datetime.now().addhours(-1), 
            Type = 'LeaveVisitor', 
            LiveChatTranscriptId = lct.id
        );
        LiveChatTranscriptEventlist.add(lcte4);

        insert LiveChatTranscriptEventlist;

        ChatKPIDailyAggregationProcessBatch resultBatch= new ChatKPIDailyAggregationProcessBatch();  
    
        Test.startTest();
        system.runAs(u){
            Database.executeBatch(resultBatch, 1);
        }
        Test.stopTest();
    }
}