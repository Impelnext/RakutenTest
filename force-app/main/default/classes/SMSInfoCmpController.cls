public with sharing class SMSInfoCmpController {
    // 定数
    private static final String STATUS_DRAFT = '下書き';
    private static final String STATUS_APPROSAL = '承認済み';
    private static final String STATUS_RETRY = 'リトライ中';
    private static final String STATUS_SENTSUCCESS = '送信済み(成功)';
    private static final String STATUS_SENTFAILURE = '送信済み(失敗)';
    private static final String STR_SUCCSESS = 'SUCCESS';
    private static final String MSG_HASNOEDIT = 'SMSを送信する権限がありません。';
    private static final String MSG_HASNOAPPROSAL = '承諾がないので送信できません。';
    private static final String MSG_NOTCHANGESTATUS = 'ステータスは下書き以外へ変更できません。';
    private static final String MSG_NOTCHANGEAPPROSED = '承認済みの場合、変更できません。';
    private static final String MSG_NOTCHANGESENT = '送信済みの場合、変更できません。';
    private static final String MSG_PHONENUMBERMISS = '送信先電話番号は半角数字11桁で設定してください。';
    private static final String MSG_PERMISSIONFLAGDIFF = 'パーミッションフラグの選択がないので保存できません。';

    private static final String MSG_NOPHONENUMBERMISS = '「送信先電話番号」が入力されていません。取引先の「携帯」項目を確認してくだい。';
    private static final String C_MSG = 'ご自身は承認申請先に選べません。';
    private static final String C_MSG2 = '承認申請先: 必須種別以外の値';
    private static final String C_MSG3 = '承認申請先を指定してください。';
    private static final String C_MSG4 = 'このレコードはロックされています。編集する必要がある場合は、システム管理者にお問い合わせください。';

    // コンストラクタ
    public SMSInfoCmpController() {

    }

    // 初期処理
    // @AuraEnabled
    // public static void init() {
    //     System.debug('start init.');
    // }

    // 編集権限チェック
    @AuraEnabled
    public static string hasEditAuthor(){
        String retStr = '';
        // SMS送信情報編集権限
        if (!Schema.sObjectType.SMSInfo__c.isUpdateable()) {
            retStr = MSG_HASNOEDIT;
        }
        return retStr;
    }
    // 取引先情報取得
    @AuraEnabled
    public static Account getAccount(Id accId){
        
        System.debug('■ accountId:' + accId);
        Account rec = [
            SELECT Id
                 , Name
                 , SMSPermissionFlgLife__c
                 , SMSPermissionFlgSonpo__c
                 , SMSPermissionFlgLittle__c
                 , PersonMobilePhone
                 , furigana__c
             FROM
                  Account
            WHERE 
                Id = :accId
        ];
        return rec;
    }

    // SMS送信情報取得
    @AuraEnabled
    public static SMSInfo__c getSMSInfo(Id smsId) {

        System.debug('■ smsinfoId:' + smsId);
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
                ,ApprovalUser__c
            FROM 
                SMSInfo__c
            WHERE
                Id = :smsId
        ];
        //
        return rec;
    }
    // 保存処理
    @AuraEnabled
    //public static String doSaveSMSInfo(SMSInfo__c smsInfo, Account acc) {
    public static List<String> doSaveSMSInfo(SMSInfo__c smsInfo, Account acc) {

        System.debug('■ sdoSave start.');
        System.debug('■ 送信先電話番号：' + smsInfo.DestinationPhoneNumber__c);
        String retStr = '';
        List<String> retListStr = new List<String>();
        retListStr.add('');
        retListStr.add('');
        //
        if (acc != null) {
            smsInfo.Name = 'SMS送信-' + acc.Name;
            smsInfo.Account__c = acc.Id;
            smsInfo.Branch_smsid__c = 1;
        } else {
            if (smsInfo.Branch_smsid__c == null) {
                smsInfo.Branch_smsid__c = 0;
            }
            smsInfo.Branch_smsid__c = smsInfo.Branch_smsid__c + 1;
        }

        /*
        if (smsInfo.ApprovalUser__c == null || smsInfo.ApprovalUser__c == '') {
            retListStr[0] = null;
            retListStr[1] = C_MSG3;
            return retListStr;
        }
        */


        System.debug('■ ApprovalUser : ' + smsInfo.ApprovalUser__c);

        System.Savepoint sp = Database.setSavepoint();
        try {
            upsert smsInfo;
            retStr = smsInfo.Id;

        } catch (Exception e) {
            //■ e.getMessage()  :
            System.debug('■ e.getMessage() : ' + e.getMessage());
            retListStr[1] = e.getMessage();
            if (retListStr[1].Contains(C_MSG)) {
                retListStr[1] = C_MSG;
            } else if (retListStr[1].Contains(C_MSG2)) {
                retListStr[1] = C_MSG3;
            } else if (retListStr[1].Contains(C_MSG4)) {
                retListStr[1] = C_MSG4;
            }
            // retStr = STR_SUCCSESS;
            Database.rollback(sp);
            // throw new AuraHandledException(e.getMessage());
        }

        System.debug('■ retStr:' + retStr);
        retListStr[0] = retStr;
        return retListStr;
    }
    // 保存処理前チェック
    @AuraEnabled
    public static String checkSave(Account acc, SMSinfo__c smsInfo, String lastStatus) {

        System.debug('■ called checkSave');

        //
        String retStr = '';
        // Pattern

        try {

        // 編集からの保存＆承認申請中
        if (smsInfo.Id != null && System.Approval.isLocked(smsInfo.Id)) {
            retStr = C_MSG4;
            return retStr;
        }

        // 送信先電話番号確認
        if (smsInfo.DestinationPhoneNumber__c == null) {
            retStr = MSG_NOPHONENUMBERMISS;
            return retStr;
        }

        if (smsInfo.Status__c == STATUS_DRAFT) {
            // ハイフン削除
            if (smsInfo.DestinationPhoneNumber__c.contains('-')) {
                smsInfo.DestinationPhoneNumber__c = smsInfo.DestinationPhoneNumber__c.replace('-','');
            }
            // 送信先電話番号
            if (!Pattern.matches('[0-9]{11}', smsInfo.DestinationPhoneNumber__c)) {
                retStr = MSG_PHONENUMBERMISS;
                return retStr;
            }
        }

        System.debug('■ ApprovalUser : ' + smsInfo.ApprovalUser__c);
        // 承認先はキューに変更、以下の部分をコメントアウト by Harry 2020-10-7 start
        /**
        // 承認申請先がない
        if (smsInfo.ApprovalUser__c == null) {
            retStr = C_MSG3;
            return retStr;
        // 承認申請先が自分
        } else if (smsInfo.ApprovalUser__c == userinfo.getUserId()) {
            retStr = C_MSG;
            return retStr;
        }
         */
        // 承認先はキューに変更、以上の部分をコメントアウト by Harry 2020-10-7 end
        // ステータスチェック
        if (lastStatus == STATUS_APPROSAL || lastStatus == STATUS_SENTFAILURE) {
            // 下書き以外
            if (smsInfo.Status__c != STATUS_DRAFT ) {
                if (smsInfo.Status__c != lastStatus){
                    retStr = MSG_NOTCHANGESTATUS;
                    return retStr;
                } else {
                    retStr = MSG_NOTCHANGEAPPROSED;
                    return retStr;
                }
            }
        // } else if (smsInfo.Status__c == STATUS_APPROSAL || smsInfo.Status__c == STATUS_SENTFAILURE) {
            //
            // retStr = MSG_NOTCHANGEAPPROSED;
        } else if (smsInfo.Status__c == STATUS_RETRY || smsInfo.Status__c == STATUS_SENTSUCCESS) {
            retStr = MSG_NOTCHANGESENT;
            return retStr;
        } 
        // 
        if (acc != null) {
            // パーミッション
            if (!acc.SMSPermissionFlgLife__c && 
                !acc.SMSPermissionFlgSonpo__c && 
                !acc.SMSPermissionFlgLittle__c) {
                retStr = MSG_HASNOAPPROSAL;
                return retStr;
            }
        } else {
            // パーミッション
            if (!smsInfo.SMSpermissionFlg__c) {
                retStr = MSG_HASNOAPPROSAL;
                return retStr;
            }
        }
        // 送信元のチェック
        // 以下連動パターン以外の場合、データ保存が不可、エラーメッセージが表示される。
        // 送信元          ⇒ SMSパーミッションフラグ
        // -------------------------------------------------
        // 生命保全         ⇒ SMSパーミッション取得（生命）
        // 生命保険金       ⇒ SMSパーミッション取得（生命）
        // 生命保険金部     ⇒ SMSパーミッション取得（生命）
        // 損保保全CCS      ⇒ SMSパーミッション取得（損保）
        // 損保ネット       ⇒ SMSパーミッション取得（損保）
        // 損保BO           ⇒ SMSパーミッション取得（損保）
        // 少短保全         ⇒ SMSパーミッション取得（少短）
        // 保険比較         ⇒ 保存不可
        // 保険セールス     ⇒ 保存不可
        if (acc != NULL && 
            !((( '0120479142'.equals(smsInfo.SenderPhoneNumber__c) || 
                 '0120949132'.equals(smsInfo.SenderPhoneNumber__c) || 
                 '0120977002'.equals(smsInfo.SenderPhoneNumber__c) ) && 
                 acc.SMSPermissionFlgLife__c ) ||
              (( '0120966909'.equals(smsInfo.SenderPhoneNumber__c) || 
                 '0120560650'.equals(smsInfo.SenderPhoneNumber__c) || 
                 // Modify 2023/08/15 RIPCRM-975_統合CRM　SMS送信元番号 （名称）追加依頼の件 By 範　Start
                 '0120540933'.equals(smsInfo.SenderPhoneNumber__c) || 
                 '0120610565'.equals(smsInfo.SenderPhoneNumber__c) ) && 
                 // Modify 2023/08/15 RIPCRM-975_統合CRM　SMS送信元番号 （名称）追加依頼の件 By 範　End
                 acc.SMSPermissionFlgSonpo__c ) || 
              (  '0120987014'.equals(smsInfo.SenderPhoneNumber__c) && 
                 acc.SMSPermissionFlgLittle__c ))) {
            retStr = MSG_PERMISSIONFLAGDIFF;
            return retStr;
        }
        } catch (Exception e) {

            retStr = '保存に失敗しました。' + smsinfo.Id + e.getMessage();
        }
        System.debug('■ checksave OK');
        return retStr;
    }
}