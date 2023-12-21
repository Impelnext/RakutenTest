trigger ExC_URLWithLimitEventTrigger on ExC_URLWithLimitEvent__e (after insert) {

    URLWithLimit__c CurrentUwl = null;
    Boolean noteFlg;
    
    try {
        for (ExC_URLWithLimitEvent__e evt: Trigger.new) {
            URLWithLimit__c uwl = [
                SELECT
                Id,
                Case__r.Id,
                Status__c,
                TryCount__c,
                CustomerInputArea__c,
                OwnerId,
                GroupName__c
                FROM URLWithLimit__c
                WHERE HashValue__c = :evt.HashValue__c
            ];
            CurrentUwl = uwl;
            
            if(evt.Status__c!=null) uwl.Status__c = evt.Status__c;
            uwl.TryCount__c = evt.TryCount__c;
            uwl.CustomerInputArea__c = evt.CustomerInputArea__c;
            
            update uwl;
            
            //if (noteFlg && evt.Status__c.equals('顧客回答済み')) {
            
            if (evt.Status__c!=null && evt.Status__c == '顧客回答済み') {
                String msgText = 'お客様から個人情報を受領しました。\n';
                msgText += 'オブジェクト：ケース\n';
                msgText += '紐づけ先ケースID：' + uwl.Case__r.Id + '\n\n';
                
                String mentionId = uwl.OwnerId;
                CollaborationGroup[] grps = [SELECT Id FROM CollaborationGroup WHERE Name = :uwl.GroupName__c];
                if(grps.size()==1) mentionId = mentionId + ',' + grps[0].id;
                ChatterNotificationUtility.Success(mentionId, uwl.Case__r.Id, msgText);
            }
        }
    } catch (Exception e) {
        
        System.debug(e.getMessage());
        if (CurrentUwl != null) {
            String msgText = '個人情報の受領に失敗しました。\n';
            msgText += '紐づけ先ケースID：' + CurrentUwl.Case__r.Id + '\n';
            msgText += 'エラー箇所：期限付きURL更新\n\n';
            
            ChatterNotificationUtility.Error(CurrentUwl.OwnerId, msgText);
            
            /*
            String msgText = 'フォーム問合せ情報の登録処理でエラーが発生しました。\n';
            if (currentInq != null) {
                msgText += 'フォーム問合せ情報・ID：' + currentInq.Id + '\n';
            }
            msgText += 'エラー箇所：フォーム問合せ情報作成・通知処理\n\n';
            msgText += 'エラーメッセージ：' + e.getMessage()+'\n\n';
            
            ChatterNotificationUtility.Error(grp.Id, msgText);
             */
            
        }
    }
}