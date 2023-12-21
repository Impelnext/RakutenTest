public class SMSSendBaseCmpController {

    static final String C_STATUS_SHITAGAKI = '下書き';
    static final String C_STATUS_OK = '送信済み(成功)';
    static final String C_STATUS_RETRY = 'リトライ中';

    /**
     * checkERROR エラーチェック
     */
    @AuraEnabled
    public static Integer checkError(String smsinfoId) {
        System.debug('■■■ called checkERROR');

        Integer error;
        String body;

        error = 0;
//smsinfoId = null; // for test
        if (!String.isEmpty(smsinfoId)) {
            System.debug('■■■ smsinfoId' + smsinfoId);

            try {
                SMSInfo__c sms = [ SELECT id, OwnerId, IsDeleted, Name, status__c, SMSPermissionFlg__c, SendContents__c
                    FROM SMSInfo__c WHERE Id =: smsinfoId Limit 1 ];
                System.debug('■■■ soql OK');

                /*
                * オブジェクトの書き込み権限チェック
                */
                if (!Schema.sObjectType.SMSInfo__c.isUpdateable()) {
                    error = 1;
                } else 
                /*
                * 承認済み、送信済（失敗）は、処理中断せず送信処理する
                */
                if (sms == null) {
                    error = 1;
                } else if (sms.status__c == C_STATUS_SHITAGAKI) {
                    error = 2; //下書き
                } else if (sms.status__c == C_STATUS_OK) {
                    error = 3; // 送信済(成功)
                } else if (sms.status__c == C_STATUS_RETRY) {
                    error = 4; // リトライ中
                } else if (sms.SMSPermissionFlg__c == false) {
                    error = 5; // フラグ許可なし
                } else if (sms.SendContents__c == null) {
                    error = 6; // メッセージなし
                } else if (sms.OwnerId != userinfo.getUserId()) {
                    error = 7; // 所有者とログインユーザが異なる
                }
                System.debug('■■■ ' + String.valueOf(error));
            } catch (Exception e) {
                error = 1; // オブジェクトエラー
                System.debug('■■■ Exception : ' + e.getMessage());
            }
        } else {
            System.debug('■■■ smsinfoId is empty');
        }
        return error;
    }
}