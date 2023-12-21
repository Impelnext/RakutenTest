public with sharing class ChatterNotificationUtility {
    
    // 正常系通知
    public static void Success(String whoId, String whatId, String msg) {

        ChatterNotification(whoId, whatId, msg);

    }

    // 異常系通知
    public static void Error(String whoId, String msg) {

        ChatterNotification(whoId, null, msg);
        
    }

    public static void ChatterNotification(String whoId, String whatId, String msg) {
        
        if (whoId == null) {
            System.debug('通知先のIDが指定されていません。');
            return;
        }

        ConnectApi.FeedItemInput feedInput = new ConnectApi.FeedItemInput();
        ConnectApi.MentionSegmentInput mntInput = new ConnectApi.MentionSegmentInput();
        ConnectApi.MessageBodyInput msgInput = new ConnectApi.MessageBodyInput();
        ConnectApi.TextSegmentInput txtInput = new ConnectApi.TextSegmentInput();

        msgInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        txtInput.text = msg;
        msgInput.messageSegments.add(txtInput);
        if(whoId.contains(',')){
            for(String wid : whoId.split(',')){
                ConnectApi.MentionSegmentInput mnt = new ConnectApi.MentionSegmentInput();
                mnt.id = wid;
        		msgInput.messageSegments.add(mnt);
            }
        }else{
        	mntInput.id = whoId;
        	msgInput.messageSegments.add(mntInput);
        }
        feedInput.body = msgInput;
        if (whatId == null) {
            feedInput.subjectId = whoId;
        } else {
            feedInput.subjectId = whatId;
        }
        feedInput.feedElementType = ConnectApi.FeedElementType.FEEDITEM;
        ConnectApi.FeedElement feedRet = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedInput);

    }
}