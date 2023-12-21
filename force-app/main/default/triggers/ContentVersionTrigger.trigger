trigger ContentVersionTrigger on ContentVersion (after insert) {

    for (ContentVersion cv: Trigger.new) {
        if (cv.SiteProcessId__c != null) {
            // コンテンツドキュメントリンクを保存する
            ContentDocumentLink conDocLink = new ContentDocumentLink();
            conDocLink.ContentDocumentId = cv.ContentDocumentId;
            conDocLink.LinkedEntityId = cv.SiteProcessId__c;
            conDocLink.ShareType = 'I'; // 必須 V、C、I(詳細の意味はAPI参照)
            conDocLink.Visibility = 'AllUsers'; // (他の設定値はAPI参照)
            insert conDocLink;

        }
    }
}