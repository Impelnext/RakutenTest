public class ChatKPINoAgentDailyAggProcessBatch implements Database.Batchable<sObject> {

    private static final String TYPE_TRANS_FERRED_TO_QUEUE = 'TransferredToQueue';
    private static final String TYPE_TRANSFER = 'Transfer';
    private static final String TYPE_CHAT_REQUEST = 'ChatRequest';
    private static final String TYPE_LEAVE_VISITOR = 'LeaveVisitor';
    
    private DateTime yesterday = Datetime.now().addDays(-1);
    private DateTime executionDate = Datetime.newInstanceGmt(
                                                yesterday.yearGmt(), 
                                                yesterday.monthGmt(), 
                                                yesterday.dayGmt(), 
                                                15, 
                                                0, 
                                                0);
    private String randomString = '';

    public Database.Querylocator start(Database.BatchableContext bc){
        // 処理の実行日
        System.debug(Logginglevel.INFO, 'executionDate = ' + executionDate);
        String query = 'SELECT Username, Email, UserType FROM User WHERE UserType = \'AutomatedProcess\' LIMIT 1';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<User> targetRecords) {
        System.debug(Logginglevel.INFO, 'ChatKPINoAgentDailyAggProcessBatch START -------------------------------------------');
        System.debug(Logginglevel.INFO, 'executionDate = ' + executionDate);

        // 実行ログ記載のために実行ログIDを乱数で生成
        String charList = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_';
        integer position;
        for(Integer i = 0; i <= 11; i++) {
            position = Integer.valueof(String.valueof(Math.roundToLong(charList.length()*Math.random()))) -1;
            if(position < 0){
                position = 0;
            }
            randomString += charList.substring(position, position+1);
        }
        System.debug(Logginglevel.INFO, 'randomString = ' + randomString);

        // チャットのトランスクリプトイベントを取得
        List<LiveChatTranscriptEvent> LiveChatTranscriptEventlist = [SELECT Time,AgentId,Type,LiveChatTranscriptId FROM LiveChatTranscriptEvent 
                                                                        WHERE CreatedDate >= :executionDate
                                                                        AND Type IN (:TYPE_TRANS_FERRED_TO_QUEUE, :TYPE_TRANSFER, :TYPE_CHAT_REQUEST, :TYPE_LEAVE_VISITOR)];
        // KPI集計用の初回レスポンス時間の計算 チャットのトランスクリプトを取得
        List<LiveChatTranscript> aggregatedChatList = [SELECT Id,OwnerId FROM LiveChatTranscript 
                                                                        WHERE CreatedDate >= :executionDate];
        // 同時セッション数 チャットのトランスクリプトイベントを取得
        List<LiveChatTranscriptEvent> LiveChatTranscriptEventAggregatedlist = [SELECT Time,AgentId,Type,LiveChatTranscriptId FROM LiveChatTranscriptEvent 
                                                                        WHERE CreatedDate >= :executionDate
                                                                        AND Type IN (:TYPE_CHAT_REQUEST, :TYPE_LEAVE_VISITOR)];

        // 各集計用に必王なOP応答数を取得
        List<AggregateResult> opNumberOfResponses = [SELECT COUNT(AgentId)cnt FROM LiveChatTranscriptEvent WHERE CreatedDate >= :executionDate AND Type = :TYPE_TRANSFER];
        System.debug(Logginglevel.INFO, 'opNumberOfResponses = ' + opNumberOfResponses);

        // KPI集計用のチャットボット・有人チャットリクエスト数を取得  WHERE句でCreatedDateでスケジューラーから渡された引数で絞り込み（前日等）
        List<AggregateResult> numberOfRequestsChatbotAndMannedChat = [SELECT COUNT(OwnerId)cnt FROM LiveChatTranscript WHERE CreatedDate >= :executionDate AND (ChatBotFlowType__c = '生命フロー' OR ChatBotFlowType__c = '損保フロー' OR ChatBotFlowType__c = 'ペットフロー')];
        System.debug(Logginglevel.INFO, 'numberOfRequestsChatbotAndMannedChat = ' + numberOfRequestsChatbotAndMannedChat);

        // KPI集計用ボットtoコールリクエスト数を取得
        List<AggregateResult> numberOfBotToCallRequests = [SELECT COUNT(OwnerId)cnt FROM LiveChatTranscript WHERE CreatedDate >= :executionDate AND (ChatBotFlowType__c = '生命QRコードフロー' OR ChatBotFlowType__c = '損保QRコードフロー' OR ChatBotFlowType__c = 'ペットQRコードフロー')];
        System.debug(Logginglevel.INFO, 'numberOfBotToCallRequests = ' + numberOfBotToCallRequests);

        // KPI集計用の折り返し着信リクエスト数を取得
        List<AggregateResult> numberOfCallBackRequests = [SELECT COUNT(OwnerId)cnt FROM LiveChatTranscript WHERE CreatedDate >= :executionDate AND (ChatBotFlowType__c = '生命保険金折り返しフロー' OR ChatBotFlowType__c = '生命保全折り返しフロー' OR ChatBotFlowType__c = '損保折り返しフロー' OR ChatBotFlowType__c = 'ペット折り返しフロー')];
        System.debug(Logginglevel.INFO, 'numberOfCallBackRequests = ' + numberOfCallBackRequests);

        // KPI集計用のQue着信数を取得
        List<AggregateResult> queNumberOfCalls = [SELECT COUNT(e.Id)cnt FROM LiveChatTranscriptEvent e, LiveChatTranscriptEvent.LiveChatTranscript t WHERE t.CreatedDate >= :executionDate AND e.Type = :TYPE_TRANS_FERRED_TO_QUEUE];
        System.debug(Logginglevel.INFO, 'queNumberOfCalls = ' + queNumberOfCalls);

        // KPI集計用のWEB選択数を取得
        List<AggregateResult> numberOfWebSelections = [SELECT COUNT(OwnerId)cnt FROM LiveChatTranscript WHERE CreatedDate >= :executionDate AND GuidedTo__c = 'WEB'];
        System.debug(Logginglevel.INFO, 'numberOfWebSelections = ' + numberOfWebSelections);

        // KPI集計用のボットtoコールから通常ボット遷移数を取得
        List<AggregateResult> normalBotTransitionCount = [SELECT COUNT(OwnerId)cnt FROM LiveChatTranscript WHERE CreatedDate >= :executionDate AND (ChatBotFlowType__c = '生命フロー（生命BotToCallから遷移）' OR ChatBotFlowType__c = '損保フロー（損保BotToCallから遷移）' OR ChatBotFlowType__c = 'ペットフロー（ペットBotToCallから遷移）')];
        System.debug(Logginglevel.INFO, 'normalBotTransitionCount = ' + normalBotTransitionCount);

        // KPI集計用のチャットボット対応完了数を計算
        Integer numberOfCompletedChatbotResponses = Integer.valueOf(numberOfWebSelections[0].get('cnt')) + Integer.valueOf(opNumberOfResponses[0].get('cnt'));
        System.debug(Logginglevel.INFO, 'numberOfCompletedChatbotResponses = ' + numberOfCompletedChatbotResponses);

        // KPI集計用のボットtoコール完了数を取得
        List<AggregateResult> numberOfBotToCallCompletions = [SELECT COUNT(OwnerId)cnt FROM LiveChatTranscript WHERE CreatedDate >= :executionDate AND GuidedTo__c = 'BotToCall'];
        System.debug(Logginglevel.INFO, 'numberOfBotToCallCompletions = ' + numberOfBotToCallCompletions);

        // KPI集計用の折り返し着信用完了数を取得
        List<AggregateResult> numberOfCompletionsForCallback = [SELECT COUNT(OwnerId)cnt FROM LiveChatTranscript WHERE CreatedDate >= :executionDate AND (ChatBotFlowType__c = '生命保険金折り返しフロー' OR ChatBotFlowType__c = '生命保全折り返しフロー' OR ChatBotFlowType__c = '損保折り返しフロー' OR ChatBotFlowType__c = 'ペット折り返しフロー') AND GuidedTo__c = '有人チャット'];
        System.debug(Logginglevel.INFO, 'numberOfCompletionsForCallback = ' + numberOfCompletionsForCallback);

        // KPI集計用のチャットボットAnswered%を計算
        Decimal chatbotAnswered;
        // 割る数が0か確認
        if(Decimal.valueOf(Integer.valueOf(numberOfRequestsChatbotAndMannedChat[0].get('cnt'))) == 0){
            chatbotAnswered = null;
        }else{
            chatbotAnswered = ((Decimal.valueOf(Integer.valueOf(opNumberOfResponses[0].get('cnt'))) + Decimal.valueOf(Integer.valueOf(numberOfWebSelections[0].get('cnt')))) / Decimal.valueOf(Integer.valueOf(numberOfRequestsChatbotAndMannedChat[0].get('cnt')))) * 100;
        }
        System.debug(Logginglevel.INFO, 'chatbotAnswered = ' + chatbotAnswered);

        // KPI集計用のボットtoコールAnswered%を計算
        Decimal botToCallAnswered;
        // 割る数が0か確認
        if(Decimal.valueOf(Integer.valueOf(numberOfBotToCallRequests[0].get('cnt'))) - Decimal.valueOf(Integer.valueOf(normalBotTransitionCount[0].get('cnt'))) == 0){
            botToCallAnswered = null;
        }else{
            botToCallAnswered = (Decimal.valueOf(Integer.valueOf(numberOfBotToCallCompletions[0].get('cnt'))) / (Decimal.valueOf(Integer.valueOf(numberOfBotToCallRequests[0].get('cnt'))) - Decimal.valueOf(Integer.valueOf(normalBotTransitionCount[0].get('cnt'))))) * 100;
        }
        System.debug(Logginglevel.INFO, 'botToCallAnswered = ' + botToCallAnswered);

        // KPI集計用の折り返し着信Answered%を計算
        Decimal callbackAnswered;
        // 割る数が0か確認
        if(Decimal.valueOf(Integer.valueOf(numberOfCallBackRequests[0].get('cnt'))) == 0){
            callbackAnswered = null;
        }else{
            callbackAnswered = (Decimal.valueOf(Integer.valueOf(numberOfCompletionsForCallback[0].get('cnt'))) / Decimal.valueOf(Integer.valueOf(numberOfCallBackRequests[0].get('cnt')))) * 100;
        }
        System.debug(Logginglevel.INFO, 'callbackAnswered = ' + callbackAnswered);

        // KPI集計用のチャットボットフロー中離脱数を計算
        Integer numberOfWithdrawalsDuringChatbotFlow = Integer.valueOf(numberOfRequestsChatbotAndMannedChat[0].get('cnt')) - (Integer.valueOf(queNumberOfCalls[0].get('cnt')) + Integer.valueOf(numberOfWebSelections[0].get('cnt')));
        System.debug(Logginglevel.INFO, 'numberOfWithdrawalsDuringChatbotFlow = ' + numberOfWithdrawalsDuringChatbotFlow);

        // KPI集計用のボットtoコールフロー中離脱数を計算
        Integer numberOfWithdrawalsDuringBotToCallFlow = Integer.valueOf(numberOfBotToCallRequests[0].get('cnt')) - Integer.valueOf(normalBotTransitionCount[0].get('cnt')) - Integer.valueOf(numberOfBotToCallCompletions[0].get('cnt'));
        System.debug(Logginglevel.INFO, 'numberOfWithdrawalsDuringBotToCallFlow = ' + numberOfWithdrawalsDuringBotToCallFlow);

        // KPI集計用の折り返し着信フロー中離脱数を計算
        Integer numberOfWithdrawalsDuringReturnCallFlow = Integer.valueOf(numberOfCallBackRequests[0].get('cnt')) - Integer.valueOf(numberOfCompletionsForCallback[0].get('cnt'));
        System.debug(Logginglevel.INFO, 'numberOfWithdrawalsDuringReturnCallFlow = ' + numberOfWithdrawalsDuringReturnCallFlow);

        // KPI集計用の放棄数を計算
        Integer numberOfAbandons = Integer.valueOf(queNumberOfCalls[0].get('cnt')) - Integer.valueOf(opNumberOfResponses[0].get('cnt'));
        System.debug(Logginglevel.INFO, 'numberOfAbandons = ' + numberOfAbandons);

        // Total Speed of Abandone チャットボットの開始（入電）から放棄までの時間
        Time TotalSpeedOfAbandone = Time.newInstance(0, 0, 0, 0);
        Integer TotalSpeedOfAbandoneHoursInt = 0;
        Integer TotalSpeedOfAbandoneMinutesInt = 0;
        Integer TotalSpeedOfAbandoneSecondsInt = 0;
        for(LiveChatTranscript ChatTranscript : aggregatedChatList) {
            // 転送承諾済み以外のチャットのトランスクリプトイベントの無いチャットのトランスクリプトでのみ集計を実施
            for(LiveChatTranscriptEvent event : LiveChatTranscriptEventlist ) {
                if (event.LiveChatTranscriptId != ChatTranscript.Id || event.Type == TYPE_TRANSFER) {
                    // 以下のいずれかの条件に合致する場合はスキップする
                    // チャットのトランスクリプトに紐づかない
                    // 転送承諾済みのイベント
                    continue;
                }
                // 訪問者が退席時間
                Integer TimeWhenVisitorsLeaveHours = 0;
                Integer TimeWhenVisitorsLeaveMinues = 0;
                Integer TimeWhenVisitorsLeaveSeconds = 0;
                if(event.Type == TYPE_LEAVE_VISITOR) {
                    DateTime t = event.Time;
                    TimeWhenVisitorsLeaveHours = t.hourGmt();
                    TimeWhenVisitorsLeaveMinues = t.minuteGmt();
                    TimeWhenVisitorsLeaveSeconds = t.secondGmt();
                }
                // チャット要求済み時間
                Integer ChatRequestedTimeHours = 0;
                Integer ChatRequestedTimeMinues = 0;
                Integer ChatRequestedTimeSeconds = 0;
                if(event.Type == TYPE_CHAT_REQUEST) {
                    DateTime t = event.Time;
                    ChatRequestedTimeHours = t.hourGmt();
                    ChatRequestedTimeMinues = t.minuteGmt();
                    ChatRequestedTimeSeconds = t.secondGmt();
                }
                TotalSpeedOfAbandoneHoursInt += TimeWhenVisitorsLeaveHours - ChatRequestedTimeHours;
                TotalSpeedOfAbandoneMinutesInt += TimeWhenVisitorsLeaveMinues - ChatRequestedTimeMinues;
                TotalSpeedOfAbandoneSecondsInt += TimeWhenVisitorsLeaveSeconds - ChatRequestedTimeSeconds;
                TotalSpeedOfAbandone = Time.newInstance(TotalSpeedOfAbandoneHoursInt, TotalSpeedOfAbandoneMinutesInt, TotalSpeedOfAbandoneSecondsInt, 0);
            }
        }

        // Speed of Abandone キュー選択からオペレーター応答までに放棄した時間
        Time SpeedofAbandone = Time.newInstance(0, 0, 0, 0);
        Integer SpeedofAbandoneHoursInt = 0;
        Integer SpeedofAbandoneMinutesInt = 0;
        Integer SpeedofAbandoneSecondsInt = 0;
        for(LiveChatTranscript ChatTranscript : aggregatedChatList) {
            // 転送承諾済み以外のチャットのトランスクリプトイベントの無いチャットのトランスクリプトでのみ集計を実施
            for(LiveChatTranscriptEvent event : LiveChatTranscriptEventlist ) {
                if (event.LiveChatTranscriptId != ChatTranscript.Id || event.Type == TYPE_TRANSFER) {
                    // 以下のいずれかの条件に合致する場合はスキップする
                    // チャットのトランスクリプトに紐づかない
                    // 転送承諾済みのイベント
                    continue;
                }
                // 訪問者が退席時間
                Integer TimeWhenVisitorsLeaveHours = 0;
                Integer TimeWhenVisitorsLeaveMinues = 0;
                Integer TimeWhenVisitorsLeaveSeconds = 0;
                if(event.Type == TYPE_LEAVE_VISITOR) {
                    DateTime t = event.Time;
                    TimeWhenVisitorsLeaveHours = t.hourGmt();
                    TimeWhenVisitorsLeaveMinues = t.minuteGmt();
                    TimeWhenVisitorsLeaveSeconds = t.secondGmt();
                }
                // キューに転送済み時間
                Integer TimeTransferredToQueueHours = 0;
                Integer TimeTransferredToQueueMinues = 0;
                Integer TimeTransferredToQueueSeconds = 0;
                if(event.Type == TYPE_TRANS_FERRED_TO_QUEUE) {
                    DateTime t = event.Time;
                    TimeTransferredToQueueHours = t.hourGmt();
                    TimeTransferredToQueueMinues = t.minuteGmt();
                    TimeTransferredToQueueSeconds = t.secondGmt();
                }
                SpeedofAbandoneHoursInt += TimeWhenVisitorsLeaveHours - TimeTransferredToQueueHours;
                SpeedofAbandoneMinutesInt += TimeWhenVisitorsLeaveMinues - TimeTransferredToQueueMinues;
                SpeedofAbandoneSecondsInt += TimeWhenVisitorsLeaveSeconds - TimeTransferredToQueueSeconds;  
            }
        }
        SpeedofAbandone = Time.newInstance(SpeedofAbandoneHoursInt, SpeedofAbandoneMinutesInt, SpeedofAbandoneSecondsInt, 0);

        // Average Speed of Abandoneの計算
        Integer averageSpeedOfAbandoneInt = 0;
        if(Integer.valueOf(queNumberOfCalls[0].get('cnt')) != 0){
            averageSpeedOfAbandoneInt = 
                ((SpeedofAbandone.hour() * 60 * 60) 
                    + (SpeedofAbandone.minute() * 60) + SpeedofAbandone.second()) 
                        / Integer.valueOf(queNumberOfCalls[0].get('cnt'));
        }
        Time averageSpeedOfAbandone = Time.newInstance(0, 0, averageSpeedOfAbandoneInt, 0);
        

        System.debug(Logginglevel.INFO, 'INSERT ChatKpiRawData__c START ============================');
        // insert用KPI_RAW_DATAオブジェクト
        ChatKpiRawData__c chatKpiRawDataObj = new ChatKpiRawData__c(
            AggregationDate__c = executionDate.date(),
            TargetUser__c = null,

            PresenceAvailable__c = null,
            PresenceAfterCallWork__c = null,
            PresenceLastOp__c = null,
            PresenceLanch__c = null,
            PresenceBreak__c = null,
            PresenceMeeting__c = null,
            PresenceTrainning__c = null,
            PresenceChecking__c = null,
            PresenceOtherWork__c = null,
            PresenceCallAssign__c = null,
            PresenceWebFormAssign__c = null,
            PresenceInquiryAssign__c = null,
            PresenceCallbackCall__c = null,
            PresenceSnatchCall__c = null,

            LoginDatetime__c = null,
            LogoutDatetime__c = null,

            CountChatRequests__c = Integer.valueOf(numberOfRequestsChatbotAndMannedChat[0].get('cnt')),
            CountBotToCallRequests__c = Integer.valueOf(numberOfBotToCallRequests[0].get('cnt')),
            CountCallbackRequests__c = Integer.valueOf(numberOfCallBackRequests[0].get('cnt')),
            CountQueInbounds__c = Integer.valueOf(queNumberOfCalls[0].get('cnt')),
            CountOpReceptions__c = null,
            CountWebGuides__c = Integer.valueOf(numberOfWebSelections[0].get('cnt')),
            CountFromBotToCallToGeneralBotFlows__c = Integer.valueOf(normalBotTransitionCount[0].get('cnt')),
            CountAnsweredGeneralChatbotFlow__c = numberOfCompletedChatbotResponses,
            CountAnsweredBotToCallFlow__c = Integer.valueOf(numberOfBotToCallCompletions[0].get('cnt')),
            CountAnsweredCallbackFlow__c = Integer.valueOf(numberOfCompletionsForCallback[0].get('cnt')),
            CountAnsweredMannedChat__c = null,
            RateAnsweredGeneralChatbotFlow__c = chatbotAnswered,
            RateAnsweredBotToCallFlow__c = botToCallAnswered,
            RateAnsweredCallbackFlow__c = callbackAnswered,
            RateAnsweredMannedChat__c = null,
            AbandonesGeneralChatbotFlow__c = numberOfWithdrawalsDuringChatbotFlow,
            AbandonesBotToCallFlow__c = numberOfWithdrawalsDuringBotToCallFlow, 
            AbandonesCallbackFlow__c = numberOfWithdrawalsDuringReturnCallFlow,
            AbandonesInQueue__c = numberOfAbandons,
            AbandonesMannedChat__c = null,
            TotalSpeedOfAnswer__c = null,
            SpeedOfAnswer__c = null,
            TotalSpeedOfAbandone__c = TotalSpeedOfAbandone,
            TotalSpeedOfMannedChatAbandone__c = null, 
            SpeedOfAbandone__c = SpeedofAbandone,
            AverageSpeedOfAnswer__c = null,
            AverageSpeedOfAbandone__c = averageSpeedOfAbandone,
            AverageHandleTime__c = null,
            ChatPerOperationTime__c = null,
            MaxParallelSessionCounts__c = null,
            BatchContextId__c = randomString
        );

        // KPI_LOW_DATAオブジェクトにinsert
        insert chatKpiRawDataObj;
        System.debug(Logginglevel.INFO, 'INSERT ChatKpiRawData__c END ============================');
        System.debug(Logginglevel.INFO, 'ChatKPINoAgentDailyAggProcessBatch END -------------------------------------------');

    }
    
    public void finish(Database.BatchableContext bc) {
        
    }
}