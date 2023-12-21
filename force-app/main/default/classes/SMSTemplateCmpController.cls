public with sharing class SMSTemplateCmpController {
    //
    private static final String STR_SUCCSESS = 'SUCCESS';
    private static final String MSG_SAVEEXEPTION = 'SMSメッセージテンプレートの保存に失敗しました。システム管理者に問い合わせてください。';
    private static final String MSG_DELETEEXEPTION = 'SMSメッセージテンプレートの削除に失敗しました。システム管理者に問い合わせてください。';

    @AuraEnabled
    public static List<Object> getTempList() {
        List<Object> retList = [
            SELECT
                Id
                ,Name
                ,MessageDetail__c
                ,Order__c 
            FROM 
                SMSMessageTemplate__c
            ORDER BY 
                Order__c ASC NULLS LAST,
                Name ASC
        ];
        return retList;
    }

    @AuraEnabled
    public static SMSMessageTemplate__c getTemp(Id tempId) {
        SMSMessageTemplate__c temp = [
            SELECT
                Id
                ,Name
                ,MessageDetail__c
                ,Order__c 
            FROM 
                SMSMessageTemplate__c
            WHERE 
                Id = :tempId
        ];
        return temp;
    }

    @AuraEnabled
    public static String doSaveTemp(SMSMessageTemplate__c temp) {
        String retStr = '';
        System.Savepoint sp = Database.setSavepoint();
        try {
            upsert temp;
            retStr = STR_SUCCSESS;
        } catch (Exception e) {
            //
            System.debug(e.getMessage());
            retStr = MSG_SAVEEXEPTION;
            Database.rollback(sp);

        }
        return retStr;
    }

    @AuraEnabled
    public static String doDeleteTemp(SMSMessageTemplate__c temp) {
        String retStr = '';
        System.Savepoint sp = Database.setSavepoint();
        try {
            delete temp;
            retStr = STR_SUCCSESS;
        } catch (Exception e) {
            //
            System.debug(e.getMessage());
            retStr = MSG_DELETEEXEPTION;
            Database.rollback(sp);

        }
        return retStr;
    }

    @AuraEnabled
    public static String updateMessage(Id smsId,String subject, String message) {
        String retStr = '';
        //
        SMSInfo__c rec = [
            SELECT
                Id
                ,Name
                ,DestinationPhoneNumber__c
                ,ContractorFurigana__c
                ,Sender__c
                ,SenderPhoneNumber__c
                ,Status__c
                ,SendSubject__c
                ,SendContents__c
                ,SendDateTime__c
                ,SendResult__c
                ,Branch_smsid__c
                ,smsid__c
                ,SMSPermissionFlg__c
                ,Account__c
                ,DifferentPhoneNumber__c
            FROM 
                SMSInfo__c
            WHERE
                Id = :smsId
        ];
        //
        if (rec.Status__c !='下書き') {
            retStr = 'SMS送信情報のステータスが下書きで更新されていません。';
            return retStr;
        }
        System.Savepoint sp = Database.setSavepoint();
        try {
            rec.SendSubject__c = subject;
            if (String.isBlank(rec.SendContents__c)) {
                rec.SendContents__c = '';
            }
            // rec.SendContents__c = rec.SendContents__c + ' ' + message;
            rec.SendContents__c = rec.SendContents__c + ' ' + message;
            rec.Branch_smsid__c = rec.Branch_smsid__c + 1;
            update rec;
        } catch(Exception e) {
            System.debug(e.getMessage());
            retStr = 'テンプレート情報を反映できませんでした。システム管理者にお問い合わせ下さい。';
            Database.rollback(sp);
        }
        return retStr;
    }

    @AuraEnabled
    public static Boolean isWritable() {
        Boolean ret = false;
        if (!Schema.sObjectType.SMSMessageTemplate__c.isUpdateable()) {
            ret = true;
        }
        return ret;
    }

}