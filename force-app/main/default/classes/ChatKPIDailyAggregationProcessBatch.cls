public class ChatKPIDailyAggregationProcessBatch implements Database.Batchable<sObject> {

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

        // ユーザロールを取得
        List<UserRole> userRoles = [SELECT DeveloperName FROM UserRole 
                                        WHERE DeveloperName = 'SubconSV' OR DeveloperName = 'SubconOP' OR DeveloperName = 'AgencySV' OR DeveloperName = 'AgencyOP' OR DeveloperName = 'LifeSV' OR DeveloperName = 'LifeOP' OR DeveloperName = 'DamageSV' OR DeveloperName = 'DamageOP' OR DeveloperName = 'LittleSV' 
                                        OR DeveloperName = 'LittleOP' OR DeveloperName = 'Reference' OR DeveloperName = 'LifeAgentSV' OR DeveloperName = 'LifeAgentOP' OR DeveloperName = 'DamageAgentSupSV' OR DeveloperName = 'DamageAgentSupOP' OR DeveloperName = 'LittleAgentSupSV' OR DeveloperName = 'LittleAgentSupOP'];
        List<Id> userRoleIds = new List<Id>();
        for(UserRole userRole : userRoles){
            userRoleIds.add(userRole.Id);
        }
        System.debug(Logginglevel.INFO, 'userRoleIds = ' + userRoleIds);
        // 集計対象ユーザの取得
        // KPI集計用のログインを取得
        List<User> users = [SELECT UserRoleId, LastLoginDate FROM User WHERE UserRoleId IN :userRoleIds];
        System.debug(Logginglevel.INFO, 'users = ' + users);
        System.debug(Logginglevel.INFO, 'users.size = ' + users.size());

        String query = '';
        if (Test.isRunningTest()){
            query = 'SELECT UserRoleId, LastLoginDate, Username FROM User WHERE Username = \'testChatKPIDaily@test.com\'';
        } else {
            query = 'SELECT UserRoleId, LastLoginDate FROM User WHERE UserRoleId IN :userRoleIds';
        }
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<User> targetRecords) {
        System.debug(Logginglevel.INFO, 'ChatKPIDailyAggregationProcessBatch START -------------------------------------------');
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

        List<Id> userIds = new List<Id>();
        for(User u : targetRecords) {
            userIds.add(u.Id);
        }

        // チャットのトランスクリプトイベントを取得
        List<LiveChatTranscriptEvent> LiveChatTranscriptEventlist = [SELECT e.Time, e.Type, e.LiveChatTranscriptId 
                                                                FROM LiveChatTranscriptEvent e, LiveChatTranscriptEvent.LiveChatTranscript t
                                                                WHERE t.CreatedDate >= :executionDate
                                                                AND e.Type IN (:TYPE_TRANS_FERRED_TO_QUEUE, :TYPE_TRANSFER, :TYPE_CHAT_REQUEST, :TYPE_LEAVE_VISITOR)
                                                                AND t.OwnerId IN :userIds];
        // KPI集計用の初回レスポンス時間の計算 チャットのトランスクリプトを取得
        List<LiveChatTranscript> aggregatedChatList = [SELECT Id, OwnerId 
                                                            FROM LiveChatTranscript 
                                                            WHERE CreatedDate >= :executionDate
                                                            AND OwnerId IN :userIds];
        // 同時セッション数 チャットのトランスクリプトイベントを取得
        List<LiveChatTranscriptEvent> LiveChatTranscriptEventAggregatedlist = [SELECT e.Time, e.Type, e.LiveChatTranscriptId 
                                                                                FROM LiveChatTranscriptEvent e, LiveChatTranscriptEvent.LiveChatTranscript t
                                                                                WHERE t.CreatedDate >= :executionDate
                                                                                AND e.Type IN (:TYPE_CHAT_REQUEST, :TYPE_LEAVE_VISITOR)
                                                                                AND t.OwnerId IN :userIds];

        // 種別＝転送承諾済みを含むCTIの一覧を取得
        List<LiveChatTranscriptEvent> LiveChatTranscriptEventlist4AHT = [SELECT t.Id, t.OwnerId, e.Id
                                                            FROM LiveChatTranscriptEvent e, LiveChatTranscriptEvent.LiveChatTranscript t
                                                            WHERE t.CreatedDate >= :executionDate
                                                            AND e.Type IN (:TYPE_TRANSFER)
                                                            AND t.OwnerId IN :userIds];

        for(User u : targetRecords){
            System.debug(Logginglevel.INFO, 'u = ' + u);

            // ユーザプレゼンス 対応可能
            Time availableChatTime = Time.newInstance(0, 0, 0, 0);
            Integer availableChatTimeInt = 0;
            List<AggregateResult> numOfAvailableChat = [SELECT SUM(StatusDuration)summary FROM UserServicePresence WHERE CreatedDate >= :executionDate AND UserId = :u.Id AND ServicePresenceStatus.DeveloperName = 'Available_Chat'];
            System.debug(Logginglevel.INFO, 'numOfAvailableChat = ' + numOfAvailableChat);
            if (numOfAvailableChat[0].get('summary') != null) {
                availableChatTimeInt = Integer.valueOf(numOfAvailableChat[0].get('summary'));
            }
            availableChatTime = Time.newInstance(0, 0, availableChatTimeInt, 0);
            System.debug(Logginglevel.INFO, 'availableChatTime = ' + availableChatTime);

            // ユーザプレゼンス 後処理
            Time caseworkTime = Time.newInstance(0, 0, 0, 0);
            Integer caseworkTimeInt = 0;
            List<AggregateResult> numOfCasework = [SELECT SUM(StatusDuration)summary FROM UserServicePresence WHERE CreatedDate >= :executionDate AND UserId = :u.Id AND ServicePresenceStatus.DeveloperName = 'Casework'];
            System.debug(Logginglevel.INFO, 'numOfCasework = ' + numOfCasework);
            if (numOfCasework[0].get('summary') != null) {
                caseworkTimeInt = Integer.valueOf(numOfCasework[0].get('summary'));
            }
            caseworkTime = Time.newInstance(0, 0, caseworkTimeInt, 0);
            System.debug(Logginglevel.INFO, 'caseworkTime = ' + caseworkTime);

            // ユーザプレゼンス ラスト対応
            Time lastchatTime = Time.newInstance(0, 0, 0, 0);
            Integer lastchatTimeInt = 0;
            List<AggregateResult> numOfLastchat = [SELECT SUM(StatusDuration)summary FROM UserServicePresence WHERE CreatedDate >= :executionDate AND UserId = :u.Id AND ServicePresenceStatus.DeveloperName = 'Lastchat'];
            System.debug(Logginglevel.INFO, 'numOfLastchat = ' + numOfLastchat);
            if (numOfLastchat[0].get('summary') != null) {
                lastchatTimeInt = Integer.valueOf(numOfLastchat[0].get('summary'));
            }
            lastchatTime = Time.newInstance(0, 0, lastchatTimeInt, 0);
            System.debug(Logginglevel.INFO, 'lastchatTime = ' + lastchatTime);

            // ユーザプレゼンス ランチ休憩
            Time lunchTime = Time.newInstance(0, 0, 0, 0);
            Integer lunchTimeInt = 0;
            List<AggregateResult> numOfLunch = [SELECT SUM(StatusDuration)summary FROM UserServicePresence WHERE CreatedDate >= :executionDate AND UserId = :u.Id AND ServicePresenceStatus.DeveloperName = 'Lunch'];
            System.debug(Logginglevel.INFO, 'numOfLunch = ' + numOfLunch);
            if (numOfLunch[0].get('summary') != null) {
                lunchTimeInt = Integer.valueOf(numOfLunch[0].get('summary'));
            }
            lunchTime = Time.newInstance(0, 0, lunchTimeInt, 0);
            System.debug(Logginglevel.INFO, 'lunchTime = ' + lunchTime);

            // ユーザプレゼンス プチ休憩
            Time breakTime = Time.newInstance(0, 0, 0, 0);
            Integer breakTimeInt = 0;
            List<AggregateResult> numOfBreak = [SELECT SUM(StatusDuration)summary FROM UserServicePresence WHERE CreatedDate >= :executionDate AND UserId = :u.Id AND ServicePresenceStatus.DeveloperName = 'Break'];
            System.debug(Logginglevel.INFO, 'numOfBreak = ' + numOfBreak);
            if (numOfBreak[0].get('summary') != null) {
                breakTimeInt = Integer.valueOf(numOfBreak[0].get('summary'));
            }
            breakTime = Time.newInstance(0, 0, breakTimeInt, 0);
            System.debug(Logginglevel.INFO, 'breakTime = ' + breakTime);

            // ユーザプレゼンス ミーティング
            Time meetingTime = Time.newInstance(0, 0, 0, 0);
            Integer meetingTimeInt = 0;
            List<AggregateResult> numOfMeeting = [SELECT SUM(StatusDuration)summary FROM UserServicePresence WHERE CreatedDate >= :executionDate AND UserId = :u.Id AND ServicePresenceStatus.DeveloperName = 'Meeting'];
            System.debug(Logginglevel.INFO, 'numOfMeeting = ' + numOfMeeting);
            if (numOfMeeting[0].get('summary') != null) {
                meetingTimeInt = Integer.valueOf(numOfMeeting[0].get('summary'));
            }
            meetingTime = Time.newInstance(0, 0, meetingTimeInt, 0);
            System.debug(Logginglevel.INFO, 'meetingTime = ' + meetingTime);

            // ユーザプレゼンス トレーニング
            Time trainingTime = Time.newInstance(0, 0, 0, 0);
            Integer trainingTimeInt = 0;
            List<AggregateResult> numOfTraining = [SELECT SUM(StatusDuration)summary FROM UserServicePresence WHERE CreatedDate >= :executionDate AND UserId = :u.Id AND ServicePresenceStatus.DeveloperName = 'Training'];
            System.debug(Logginglevel.INFO, 'numOfTraining = ' + numOfTraining);
            if (numOfTraining[0].get('summary') != null) {
                trainingTimeInt = Integer.valueOf(numOfTraining[0].get('summary'));
            }
            trainingTime = Time.newInstance(0, 0, trainingTimeInt, 0);
            System.debug(Logginglevel.INFO, 'trainingTime = ' + trainingTime);

            // ユーザプレゼンス チェック作業
            Time checkingTime = Time.newInstance(0, 0, 0, 0);
            Integer checkingTimeInt = 0;
            List<AggregateResult> numOfChecking = [SELECT SUM(StatusDuration)summary FROM UserServicePresence WHERE CreatedDate >= :executionDate AND UserId = :u.Id AND ServicePresenceStatus.DeveloperName = 'Checking'];
            System.debug(Logginglevel.INFO, 'numOfChecking = ' + numOfChecking);
            if (numOfChecking[0].get('summary') != null) {
                checkingTimeInt = Integer.valueOf(numOfChecking[0].get('summary'));
            }
            checkingTime = Time.newInstance(0, 0, checkingTimeInt, 0);
            System.debug(Logginglevel.INFO, 'checkingTime = ' + checkingTime);

            // ユーザプレゼンス その他作業
            Time otherWorkTime = Time.newInstance(0, 0, 0, 0);
            Integer otherWorkTimeInt = 0;
            List<AggregateResult> numOfOtherWork = [SELECT SUM(StatusDuration)summary FROM UserServicePresence WHERE CreatedDate >= :executionDate AND UserId = :u.Id AND ServicePresenceStatus.DeveloperName = 'OtherWork'];
            System.debug(Logginglevel.INFO, 'numOfOtherWork = ' + numOfOtherWork);
            if (numOfOtherWork[0].get('summary') != null) {
                otherWorkTimeInt = Integer.valueOf(numOfOtherWork[0].get('summary'));
            }
            otherWorkTime = Time.newInstance(0, 0, otherWorkTimeInt, 0);
            System.debug(Logginglevel.INFO, 'otherWorkTime = ' + otherWorkTime);

            // ユーザプレゼンス コールアサイン
            Time callAssignTime = Time.newInstance(0, 0, 0, 0);
            Integer callAssignTimeInt = 0;
            List<AggregateResult> numOfCallAssign = [SELECT SUM(StatusDuration)summary FROM UserServicePresence WHERE CreatedDate >= :executionDate AND UserId = :u.Id AND ServicePresenceStatus.DeveloperName = 'CallAssign'];
            System.debug(Logginglevel.INFO, 'numOfCallAssign = ' + numOfCallAssign);
            if (numOfCallAssign[0].get('summary') != null) {
                callAssignTimeInt = Integer.valueOf(numOfCallAssign[0].get('summary'));
            }
            callAssignTime = Time.newInstance(0, 0, callAssignTimeInt, 0);
            System.debug(Logginglevel.INFO, 'callAssignTime = ' + callAssignTime);

            // ユーザプレゼンス Webフォームアサイン
            Time webFormAssignTime = Time.newInstance(0, 0, 0, 0);
            Integer webFormAssignTimeInt = 0;
            List<AggregateResult> numOfWebFormAssign = [SELECT SUM(StatusDuration)summary FROM UserServicePresence WHERE CreatedDate >= :executionDate AND UserId = :u.Id AND ServicePresenceStatus.DeveloperName = 'WebFormAssign'];
            System.debug(Logginglevel.INFO, 'numOfWebFormAssign = ' + numOfWebFormAssign);
            if (numOfWebFormAssign[0].get('summary') != null) {
                webFormAssignTimeInt = Integer.valueOf(numOfWebFormAssign[0].get('summary'));
            }
            webFormAssignTime = Time.newInstance(0, 0, webFormAssignTimeInt, 0);
            System.debug(Logginglevel.INFO, 'webFormAssignTime = ' + webFormAssignTime);

            // ユーザプレゼンス 問合せフォームアサイン
            Time inquiryAssignTime = Time.newInstance(0, 0, 0, 0);
            Integer inquiryAssignTimeInt = 0;
            List<AggregateResult> numOfInquiryAssign = [SELECT SUM(StatusDuration)summary FROM UserServicePresence WHERE CreatedDate >= :executionDate AND UserId = :u.Id AND ServicePresenceStatus.DeveloperName = 'InquiryAssign'];
            System.debug(Logginglevel.INFO, 'numOfInquiryAssign = ' + numOfInquiryAssign);
            if (numOfInquiryAssign[0].get('summary') != null) {
                inquiryAssignTimeInt = Integer.valueOf(numOfInquiryAssign[0].get('summary'));
            }
            inquiryAssignTime = Time.newInstance(0, 0, inquiryAssignTimeInt, 0);
            System.debug(Logginglevel.INFO, 'inquiryAssignTime = ' + inquiryAssignTime);

            // ユーザプレゼンス 折り返し架電
            Time callbackCallTime = Time.newInstance(0, 0, 0, 0);
            Integer callbackCallTimeInt = 0;
            List<AggregateResult> numOfCallbackCall = [SELECT SUM(StatusDuration)summary FROM UserServicePresence WHERE CreatedDate >= :executionDate AND UserId = :u.Id AND ServicePresenceStatus.DeveloperName = 'CallbackCall'];
            System.debug(Logginglevel.INFO, 'numOfCallbackCall = ' + numOfCallbackCall);
            if (numOfCallbackCall[0].get('summary') != null) {
                callbackCallTimeInt = Integer.valueOf(numOfCallbackCall[0].get('summary'));
            }
            callbackCallTime = Time.newInstance(0, 0, callbackCallTimeInt, 0);
            System.debug(Logginglevel.INFO, 'callbackCallTime = ' + callbackCallTime);

            // ユーザプレゼンス スナッチ架電
            Time snatchCallTime = Time.newInstance(0, 0, 0, 0);
            Integer snatchCallTimeInt = 0;
            List<AggregateResult> numOfSnatchCall = [SELECT SUM(StatusDuration)summary FROM UserServicePresence WHERE CreatedDate >= :executionDate AND UserId = :u.Id AND ServicePresenceStatus.DeveloperName = 'SnatchCall'];
            System.debug(Logginglevel.INFO, 'numOfSnatchCall = ' + numOfSnatchCall);
            if (numOfSnatchCall[0].get('summary') != null) {
                snatchCallTimeInt = Integer.valueOf(numOfSnatchCall[0].get('summary'));
            }
            snatchCallTime = Time.newInstance(0, 0, snatchCallTimeInt, 0);
            System.debug(Logginglevel.INFO, 'snatchCallTime = ' + snatchCallTime);

            // KPI集計用のログアウトを取得
            List<UserServicePresence> logoutTime = [SELECT UserId,StatusEndDate FROM UserServicePresence WHERE UserId = :u.Id ORDER BY StatusEndDate DESC LIMIT 1];
            System.debug(Logginglevel.INFO, 'logoutTime = ' + logoutTime);

            // KPI集計用のOP応答数を取得
            List<AggregateResult> opNumberOfResponses = [SELECT COUNT(AgentId)cnt FROM LiveChatTranscriptEvent WHERE CreatedDate >= :executionDate AND AgentId = :u.Id AND Type = :TYPE_TRANSFER];
            System.debug(Logginglevel.INFO, 'opNumberOfResponses = ' + opNumberOfResponses);

            // KPI集計用の有効チャット数を取得
            List<AggregateResult> numberOfActiveChats = [SELECT COUNT(Id)cnt FROM LiveChatTranscript WHERE CreatedDate >= :executionDate AND OwnerId = :u.Id AND (SupportStatus__c = 'コール移行' OR SupportStatus__c = '対応完了(チャット完了)' OR SupportStatus__c = '対応完了(SMS完了)')];
            System.debug(Logginglevel.INFO, 'numberOfActiveChats = ' + numberOfActiveChats);

            // KPI集計用の有人チャットAnswered%を計算
            Decimal mannedChatAnswered;
            // 割る数が0か確認
            if(Integer.valueOf(opNumberOfResponses[0].get('cnt')) == 0){
                mannedChatAnswered = null;
            }else{
                mannedChatAnswered = (Decimal.valueOf(Integer.valueOf(numberOfActiveChats[0].get('cnt'))) / Decimal.valueOf(Integer.valueOf(opNumberOfResponses[0].get('cnt')))) * 100;
            }
            System.debug(Logginglevel.INFO, 'mannedChatAnswered = ' + mannedChatAnswered);

            // KPI集計用の有人チャット応対中離脱数を取得
            List<AggregateResult> numberOfWithdrawalsDuringMannedChat = [SELECT COUNT(Id)cnt FROM LiveChatTranscript WHERE CreatedDate >= :executionDate AND OwnerId = :u.Id AND SupportStatus__c = '途中切断'];
            System.debug(Logginglevel.INFO, 'numberOfWithdrawalsDuringMannedChat = ' + numberOfWithdrawalsDuringMannedChat);

            // KPI集計用の初回レスポンス時間の計算
            Time firstResponseTime = Time.newInstance(0, 0, 0, 0);
            Integer firstResponseTimeHoursInt = 0;
            Integer firstResponseTimeMinutesInt = 0;
            Integer firstResponseTimeSecondsInt = 0;

            for(LiveChatTranscript ChatTranscript : aggregatedChatList) {
                if (ChatTranscript.OwnerId != u.Id) {
                    // 他ユーザーの情報の場合はスキップ
                    continue;
                }
                System.debug(Logginglevel.INFO, 'ChatTranscript = ' + ChatTranscript);
                for(LiveChatTranscriptEvent event : LiveChatTranscriptEventlist ) {
                    if (event.LiveChatTranscriptId != ChatTranscript.Id) {
                        // チャットのトランスクリプトに紐づかないイベントの場合はスキップ
                        continue;
                    }
                    // 転送承認済み時間を取得
                    Integer TransferApprovedTimeHours = 0;
                    Integer TransferApprovedTimeMinues = 0;
                    Integer TransferApprovedTimeSeconds = 0;
                    if(event.Type == TYPE_TRANSFER) {
                        DateTime t = event.Time;
                        TransferApprovedTimeHours = t.hourGmt();
                        TransferApprovedTimeMinues = t.minuteGmt();
                        TransferApprovedTimeSeconds = t.secondGmt();
                    }
                    // チャット要求済み時間を取得
                    Integer ChatRequestedTimeHours = 0;
                    Integer ChatRequestedTimeMinues = 0;
                    Integer ChatRequestedTimeSeconds = 0;
                    if(event.Type == TYPE_CHAT_REQUEST) {
                        DateTime t = event.Time;
                        ChatRequestedTimeHours = t.hourGmt();
                        ChatRequestedTimeMinues = t.minuteGmt();
                        ChatRequestedTimeSeconds = t.secondGmt();
                    }
                    firstResponseTimeHoursInt += TransferApprovedTimeHours - ChatRequestedTimeHours;
                    firstResponseTimeMinutesInt += TransferApprovedTimeMinues - ChatRequestedTimeMinues;
                    firstResponseTimeSecondsInt += TransferApprovedTimeSeconds - ChatRequestedTimeSeconds;
                }
            }
            firstResponseTime = Time.newInstance(firstResponseTimeHoursInt, firstResponseTimeMinutesInt, firstResponseTimeSecondsInt, 0);

            // KPI集計用のSpeed of Answerを計算
            Time SpeedofAnswer = Time.newInstance(0, 0, 0, 0);
            Integer SpeedofAnswerHoursInt = 0;
            Integer SpeedofAnswerMinutesInt = 0;
            Integer SpeedofAnswerSecondsInt = 0;
            for(LiveChatTranscript ChatTranscript : aggregatedChatList) {
                if (ChatTranscript.OwnerId != u.Id) {
                    // 他ユーザーの情報の場合はスキップ
                    continue;
                }
                for(LiveChatTranscriptEvent event : LiveChatTranscriptEventlist ) {
                    if (event.LiveChatTranscriptId != ChatTranscript.Id) {
                        // チャットのトランスクリプトに紐づかないイベントの場合はスキップ
                        continue;
                    }
                    // 転送承認済み時間を取得
                    Integer TransferApprovedTimeHours = 0;
                    Integer TransferApprovedTimeMinues = 0;
                    Integer TransferApprovedTimeSeconds = 0;
                    if(event.Type == TYPE_TRANSFER) {
                        DateTime t = event.Time;
                        TransferApprovedTimeHours = t.hourGmt();
                        TransferApprovedTimeMinues = t.minuteGmt();
                        TransferApprovedTimeSeconds = t.secondGmt();
                    }
                    // キューに転送済み時間を取得
                    Integer TimeTransferredToQueueHours = 0;
                    Integer TimeTransferredToQueueMinues = 0;
                    Integer TimeTransferredToQueueSeconds = 0;
                    if(event.Type == TYPE_TRANS_FERRED_TO_QUEUE) {
                        DateTime t = event.Time;
                        TimeTransferredToQueueHours = t.hourGmt();
                        TimeTransferredToQueueMinues = t.minuteGmt();
                        TimeTransferredToQueueSeconds = t.secondGmt();
                    }
                    SpeedofAnswerHoursInt += TransferApprovedTimeHours - TimeTransferredToQueueHours;
                    SpeedofAnswerMinutesInt += TransferApprovedTimeMinues - TimeTransferredToQueueMinues;
                    SpeedofAnswerSecondsInt += TransferApprovedTimeSeconds - TimeTransferredToQueueSeconds;   
                }
            }
            SpeedofAnswer = Time.newInstance(SpeedofAnswerHoursInt, SpeedofAnswerMinutesInt, SpeedofAnswerSecondsInt, 0);

            // 途中離脱時間
            Time DepartureTime = Time.newInstance(0, 0, 0, 0);
            Integer DepartureTimeHoursInt = 0;
            Integer DepartureTimeMinutesInt = 0;
            Integer DepartureTimeSecondsInt = 0;
            for(LiveChatTranscript ChatTranscript : aggregatedChatList) {
                if (ChatTranscript.OwnerId != u.Id) {
                    // 他ユーザーの情報の場合はスキップ
                    continue;
                }
                for(LiveChatTranscriptEvent event : LiveChatTranscriptEventlist ) {
                    if (event.LiveChatTranscriptId != ChatTranscript.Id) {
                        // チャットのトランスクリプトに紐づかないイベントの場合はスキップ
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
                    // 転送承認済み時間を取得
                    Integer TransferApprovedTimeHours = 0;
                    Integer TransferApprovedTimeMinues = 0;
                    Integer TransferApprovedTimeSeconds = 0;
                    if(event.Type == TYPE_TRANSFER) {
                        DateTime t = event.Time;
                        TransferApprovedTimeHours = t.hourGmt();
                        TransferApprovedTimeMinues = t.minuteGmt();
                        TransferApprovedTimeSeconds = t.secondGmt();
                    }
                    DepartureTimeHoursInt += TimeWhenVisitorsLeaveHours - TransferApprovedTimeHours;
                    DepartureTimeMinutesInt += TimeWhenVisitorsLeaveMinues - TransferApprovedTimeMinues;
                    DepartureTimeSecondsInt += TimeWhenVisitorsLeaveSeconds - TransferApprovedTimeSeconds;   
                }
            }
            DepartureTime = Time.newInstance(DepartureTimeHoursInt, DepartureTimeMinutesInt, DepartureTimeSecondsInt, 0);

            // Average Speed of Answerの計算
            Integer averageSpeedOfAnswerInt = 0;
            if(Integer.valueOf(opNumberOfResponses[0].get('cnt')) != 0){
                averageSpeedOfAnswerInt = 
                    ((SpeedofAnswer.hour() * 60 * 60) 
                        + (SpeedofAnswer.minute() * 60) + SpeedofAnswer.second()) 
                            / Integer.valueOf(opNumberOfResponses[0].get('cnt'));
            }
            Time averageSpeedOfAnswer = Time.newInstance(0, 0, averageSpeedOfAnswerInt, 0);

            // AHTにて利用するQue着信数を取得.
            List<AggregateResult> queNumberOfCalls = [SELECT COUNT(e.Id)cnt FROM LiveChatTranscriptEvent e, LiveChatTranscriptEvent.LiveChatTranscript t WHERE t.CreatedDate >= :executionDate AND t.OwnerId = :u.Id AND e.Type = :TYPE_TRANS_FERRED_TO_QUEUE];
            System.debug(Logginglevel.INFO, 'queNumberOfCalls = ' + queNumberOfCalls);

            // AHT（Average Handle Time） 平均処理時間（秒） (チャットボット＋チャット時間）
            Time AverageHandleTime = Time.newInstance(0, 0, 0, 0);
            
            Integer AverageHandleTimeHoursInt = 0;
            Integer AverageHandleTimeMinutesInt = 0;
            Integer AverageHandleTimeSecondsInt = 0;

            for(LiveChatTranscriptEvent eventlist4AHT : LiveChatTranscriptEventlist4AHT) {
                if (eventlist4AHT.LiveChatTranscript.OwnerId != u.Id) {
                    // 他ユーザーの情報の場合はスキップ
                    continue;
                }
                System.debug(Logginglevel.INFO, 'eventlist4AHT = ' + eventlist4AHT);
                // 転送承諾済みのチャットのトランスクリプトイベントの無いチャットのトランスクリプトでのみ集計を実施
                for(LiveChatTranscriptEvent event : LiveChatTranscriptEventlist ) {
                    if (event.LiveChatTranscriptId != eventlist4AHT.LiveChatTranscriptId) {
                        // 以下のいずれかの条件に合致する場合はスキップする
                        // チャットのトランスクリプトに紐づかない
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
                    // チャット要求済み時間を取得
                    Integer ChatRequestedTimeHours = 0;
                    Integer ChatRequestedTimeMinues = 0;
                    Integer ChatRequestedTimeSeconds = 0;
                    if(event.Type == TYPE_CHAT_REQUEST) {
                        DateTime t = event.Time;
                        ChatRequestedTimeHours = t.hourGmt();
                        ChatRequestedTimeMinues = t.minuteGmt();
                        ChatRequestedTimeSeconds = t.secondGmt();
                    }
                    AverageHandleTimeHoursInt += TimeWhenVisitorsLeaveHours - ChatRequestedTimeHours;
                    AverageHandleTimeMinutesInt += TimeWhenVisitorsLeaveMinues - ChatRequestedTimeMinues;
                    AverageHandleTimeSecondsInt += TimeWhenVisitorsLeaveSeconds - ChatRequestedTimeSeconds;
                }
            }
            // 累積した時分を秒に変換する
            Integer AverageHandleTimeAllSeconds = (AverageHandleTimeHoursInt * 60 * 60) + (AverageHandleTimeMinutesInt * 60) + AverageHandleTimeSecondsInt;
            // 累積した秒を件数で割って平均値を出す
            if(Integer.valueOf(queNumberOfCalls[0].get('cnt')) == 0){
                AverageHandleTime = null;
            }else{
                Integer AverageHandleTimeSeconds = AverageHandleTimeAllSeconds / Integer.valueOf(queNumberOfCalls[0].get('cnt'));
                AverageHandleTime = Time.newInstance(0, 0, AverageHandleTimeSeconds, 0);
            }

            // Chat/h 有効チャット数/総有効チャット時間
            // 総有効チャット時間
            Decimal TotalActiveChatTime = 0;
            // Long TotalActiveChatTimeLong = 0;
            Integer TotalActiveChatTimeHoursInt = 0;
            Integer TotalActiveChatTimeMinutesInt = 0;
            Integer TotalActiveChatTimeSecoundsInt = 0;

            // '対応状況=コール移行完了 or チャット完了 or SMS送信完了' の全チャットのトランスクリプト
            List<LiveChatTranscript> SupportStatusChatList = [SELECT OwnerId,SupportStatus__c FROM LiveChatTranscript WHERE CreatedDate >= :executionDate AND (SupportStatus__c = 'コール移行' OR SupportStatus__c = '対応完了(SMS完了)' OR SupportStatus__c = '対応完了(チャット完了)')];
            System.debug(Logginglevel.INFO, 'SupportStatusChatList = ' + SupportStatusChatList);
            for(LiveChatTranscript ChatTranscript : SupportStatusChatList) {
                if (ChatTranscript.OwnerId != u.Id) {
                    // 他ユーザーの情報の場合はスキップ
                    continue;
                }
                // System.debug(Logginglevel.INFO, 'ChatTranscript = ' + ChatTranscript);
                for(LiveChatTranscriptEvent event : LiveChatTranscriptEventlist ) {
                    if (event.LiveChatTranscriptId != ChatTranscript.Id) {
                        // チャットのトランスクリプトに紐づかないイベントの場合はスキップ
                        continue;
                    }
                    //訪問者が退席時間
                    Integer TimeWhenVisitorsLeaveHours = 0;
                    Integer TimeWhenVisitorsLeaveMinues = 0;
                    Integer TimeWhenVisitorsLeaveSeconds = 0;
                    if(event.Type == TYPE_LEAVE_VISITOR) {
                        DateTime t = event.Time;
                        TimeWhenVisitorsLeaveHours = t.hourGmt();
                        TimeWhenVisitorsLeaveMinues = t.minuteGmt();
                        TimeWhenVisitorsLeaveSeconds = t.secondGmt();
                    }
                    Integer TransferApprovedTimeHours = 0;
                    Integer TransferApprovedTimeMinues = 0;
                    Integer TransferApprovedTimeSeconds = 0;
                    if(event.Type == TYPE_TRANSFER) {
                        DateTime t = event.Time;
                        TransferApprovedTimeHours = t.hourGmt();
                        TransferApprovedTimeMinues = t.minuteGmt();
                        TransferApprovedTimeSeconds = t.secondGmt();
                    }
                    TotalActiveChatTimeHoursInt += TimeWhenVisitorsLeaveHours - TransferApprovedTimeHours;
                    TotalActiveChatTimeMinutesInt += TimeWhenVisitorsLeaveMinues - TransferApprovedTimeMinues;
                    TotalActiveChatTimeSecoundsInt += TimeWhenVisitorsLeaveSeconds - TransferApprovedTimeSeconds;
                }
            }
            // 累積した時分秒をHourに変換する
            Decimal totalActiveChatTimeAllHour = 
                TotalActiveChatTimeHoursInt 
                + (Decimal.valueOf(TotalActiveChatTimeMinutesInt) / Decimal.valueOf(60))
                + (Decimal.valueOf(TotalActiveChatTimeSecoundsInt) / Decimal.valueOf(60) / Decimal.valueOf(60));
            if (totalActiveChatTimeAllHour > 1) {
                TotalActiveChatTime = Decimal.valueOf(Integer.valueOf(numberOfActiveChats[0].get('cnt'))) / totalActiveChatTimeAllHour;
            } else if (Integer.valueOf(numberOfActiveChats[0].get('cnt')) > 0) {
                TotalActiveChatTime = Integer.valueOf(numberOfActiveChats[0].get('cnt'));
            }
            System.debug(Logginglevel.INFO, 'TotalActiveChatTime = ' + TotalActiveChatTime);

            // 同時セッション数
            Integer sessionMaxMultiplicity = 0;
            // loop#1
            for (Integer i = 0 ; i < aggregatedChatList.size() ; i++) {
                if (aggregatedChatList[i].OwnerId != u.Id) {
                    // 他ユーザーの情報の場合はスキップ
                    continue;
                }
                // 一時的な同時セッション数カウンタ s.i = 0 をセットする
                Integer tmpCounter = 0;
                // loop#2
                for (Integer j = i+1 ; j < aggregatedChatList.size() ; j++) {
                    if (aggregatedChatList[j].OwnerId != u.Id) {
                        // 他ユーザーの情報の場合はスキップ
                        continue;
                    }
                    // 6. ti と tj に重複期間があるか ? true の場合 s.i ++ : false の場合 なにもしない
                    
                    DateTime TransferAcceptedTimeI;
                    DateTime TransferAcceptedTimeJ;
                    DateTime TimeWhenVisitorsLeaveI;
                    DateTime TimeWhenVisitorsLeaveJ;
                    for(LiveChatTranscriptEvent event : LiveChatTranscriptEventAggregatedlist ) {
                        if (event.LiveChatTranscriptId != aggregatedChatList[i].Id
                            && event.LiveChatTranscriptId != aggregatedChatList[j].Id) {
                            // チャットのトランスクリプトに紐づかないイベントの場合はスキップ
                            continue;
                        }
                        // 転送承諾済み時間
                        if(event.Type == TYPE_CHAT_REQUEST && event.LiveChatTranscriptId == aggregatedChatList[i].Id) {
                            TransferAcceptedTimeI = event.Time;
                            System.debug(Logginglevel.INFO, 'TransferAcceptedTimeI = ' + TransferAcceptedTimeI);
                        }
                        else if(event.Type == TYPE_CHAT_REQUEST && event.LiveChatTranscriptId == aggregatedChatList[j].Id) {
                            TransferAcceptedTimeJ = event.Time;
                            System.debug(Logginglevel.INFO, 'TransferAcceptedTimeJ = ' + TransferAcceptedTimeJ);
                        }
                        // 訪問者が退席時間
                        else if(event.Type == TYPE_LEAVE_VISITOR && event.LiveChatTranscriptId == aggregatedChatList[i].Id) {
                            TimeWhenVisitorsLeaveI = event.Time;
                            System.debug(Logginglevel.INFO, 'TimeWhenVisitorsLeaveI = ' + TimeWhenVisitorsLeaveI);
                        }
                        else if(event.Type == TYPE_LEAVE_VISITOR && event.LiveChatTranscriptId == aggregatedChatList[j].Id) {
                            TimeWhenVisitorsLeaveJ = event.Time;
                            System.debug(Logginglevel.INFO, 'TimeWhenVisitorsLeaveJ = ' + TimeWhenVisitorsLeaveJ);
                        }
                    }
                    System.debug(Logginglevel.INFO, 'TimeWhenVisitorsLeaveJ = ' + TimeWhenVisitorsLeaveJ);
                    if (TransferAcceptedTimeI < TimeWhenVisitorsLeaveJ || TimeWhenVisitorsLeaveJ < TimeWhenVisitorsLeaveI) {
                        tmpCounter++;
                    }
                    System.debug(Logginglevel.INFO, 'tmpCounter = ' + tmpCounter);
                }
                // 7. (Smax_dt.u < s.i ) ? true の場合 Smax_dt.u = s.i : false の場合 なにもしない
                if (sessionMaxMultiplicity < tmpCounter) {
                    sessionMaxMultiplicity = tmpCounter;
                }
                System.debug(Logginglevel.INFO, 'sessionMaxMultiplicity = ' + sessionMaxMultiplicity);
            }

            System.debug(Logginglevel.INFO, 'INSERT ChatKpiRawData__c START ============================');
            // insert用KPI_RAW_DATAオブジェクト
            ChatKpiRawData__c chatKpiRawDataObj = new ChatKpiRawData__c(
                AggregationDate__c = executionDate.date(),
                TargetUser__c = u.Id,

                PresenceAvailable__c = availableChatTime,
                PresenceAfterCallWork__c = caseworkTime,
                PresenceLastOp__c = lastchatTime,
                PresenceLanch__c = lunchTime,
                PresenceBreak__c = breakTime,
                PresenceMeeting__c = meetingTime,
                PresenceTrainning__c = trainingTime,
                PresenceChecking__c = checkingTime,
                PresenceOtherWork__c = otherWorkTime,
                PresenceCallAssign__c = callAssignTime,
                PresenceWebFormAssign__c = webFormAssignTime,
                PresenceInquiryAssign__c = inquiryAssignTime,
                PresenceCallbackCall__c = callbackCallTime,
                PresenceSnatchCall__c = snatchCallTime,

                LoginDatetime__c = u.LastLoginDate,
                CountChatRequests__c = null, // null set
                CountBotToCallRequests__c = null, // null set
                CountCallbackRequests__c = null, // null set
                CountQueInbounds__c = null, // null set
                CountOpReceptions__c = Integer.valueOf(opNumberOfResponses[0].get('cnt')),
                CountWebGuides__c = null, // null set
                CountFromBotToCallToGeneralBotFlows__c = null, // null set
                CountAnsweredGeneralChatbotFlow__c = null, // null set
                CountAnsweredBotToCallFlow__c = null, // null set
                CountAnsweredCallbackFlow__c = null, // null set
                CountAnsweredMannedChat__c = Integer.valueOf(numberOfActiveChats[0].get('cnt')),
                RateAnsweredGeneralChatbotFlow__c = null, // null set
                RateAnsweredBotToCallFlow__c = null, // null set
                RateAnsweredCallbackFlow__c = null, // null set
                RateAnsweredMannedChat__c = mannedChatAnswered,
                AbandonesGeneralChatbotFlow__c = null, // null set
                AbandonesBotToCallFlow__c = null, // null set
                AbandonesCallbackFlow__c = null, // null set
                AbandonesInQueue__c = null, // null set
                AbandonesMannedChat__c = Integer.valueOf(numberOfWithdrawalsDuringMannedChat[0].get('cnt')),
                TotalSpeedOfAnswer__c = firstResponseTime,
                SpeedOfAnswer__c = SpeedofAnswer,
                TotalSpeedOfAbandone__c = null, // null set
                TotalSpeedOfMannedChatAbandone__c = DepartureTime, 
                SpeedOfAbandone__c = null, // null set
                AverageSpeedOfAnswer__c = averageSpeedOfAnswer,
                AverageSpeedOfAbandone__c = null, // null set
                AverageHandleTime__c = AverageHandleTime,
                ChatPerOperationTime__c = TotalActiveChatTime,
                MaxParallelSessionCounts__c = sessionMaxMultiplicity,
                BatchContextId__c = randomString
            );
            if(logoutTime.size() == 0){
                chatKpiRawDataObj.LogoutDatetime__c = null;    
            }else{
                System.debug(Logginglevel.INFO, 'logoutTime = ' + logoutTime.size());
                chatKpiRawDataObj.LogoutDatetime__c = logoutTime[0].StatusEndDate;
            }
            // KPI_LOW_DATAオブジェクトにinsert
            insert chatKpiRawDataObj;
            System.debug(Logginglevel.INFO, 'INSERT ChatKpiRawData__c END ============================');
        }
        System.debug(Logginglevel.INFO, 'ChatKPIDailyAggregationProcessBatch END -------------------------------------------');

    }
    
    public void finish(Database.BatchableContext bc) {
        
    }
}