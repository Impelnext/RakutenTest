@IsTest
public class ChatKPINoAgentDailyAggProcessBatchTest {
	 @IsTest() static void testBatch() {
         LiveChatVisitor lcv = new LiveChatVisitor();
         insert lcv;

         List<LiveChatTranscript> aggregatedChatList = new List<LiveChatTranscript>();
         LiveChatTranscript lct = new LiveChatTranscript(LiveChatVisitorId = lcv.Id);
         aggregatedChatList.add(lct);
         insert aggregatedChatList;
                  
         List<LiveChatTranscriptEvent> LiveChatTranscriptEventlist = new List<LiveChatTranscriptEvent>();
         LiveChatTranscriptEvent lcte = new LiveChatTranscriptEvent(
             Time = datetime.now(), 
             Type = 'TransferredToQueue', 
             LiveChatTranscriptId = lct.Id
         );
         LiveChatTranscriptEventlist.add(lcte);
         
         LiveChatTranscriptEvent lcte2 = new LiveChatTranscriptEvent(
             Time = datetime.now(), 
             Type = 'ChatRequest', 
             LiveChatTranscriptId = lct.Id
         );
         LiveChatTranscriptEventlist.add(lcte2);
         
         LiveChatTranscriptEvent lcte3 = new LiveChatTranscriptEvent(
             Time = datetime.now(), 
             Type = 'LeaveVisitor', 
             LiveChatTranscriptId = lct.Id
         );
         LiveChatTranscriptEventlist.add(lcte3);
         
         insert LiveChatTranscriptEventlist;
         
         Test.startTest();
         ChatKPINoAgentDailyAggProcessBatch resultBatch = new ChatKPINoAgentDailyAggProcessBatch();  
         Database.executeBatch(resultBatch, 1);
         Test.stopTest();
    }
}