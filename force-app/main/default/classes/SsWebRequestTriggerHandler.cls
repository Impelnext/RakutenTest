/*
* @Class Name      : SsWebRequestTriggerHandler 
* @Description     : 少短Web資料請求トリガーハンドラ
* @Created Date    : 2019.04.17
* @Created By      : 
* @Modified Date   : 
* @Modified        : 
*/
public class SsWebRequestTriggerHandler {

    /**
     * コンストラクタ
     */
    public SsWebRequestTriggerHandler() {}
  
    /**
     * 少短Web資料請求作成前処理
     * @param List<SsWebRequest__c>
     * @return 
     */
    public void onBeforeInsertProcess(List<SsWebRequest__c> ssWebRequestList){
        //作成情報格納用マップ ID:少短Web資料請求ID
        Map<String,Account> targetAccountMap = new Map<String,Account>();
        Map<String,Case> targetCaseMap = new Map<String,Case>();

        // 取引先の作成または更新
        Id accountPersonRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
          
        // 取引先IDセット
        Set<String> refAccIdList = new Set<String>();
        //20190808 修正開始 EasyIDに基づいての検索を外す
        // 楽天IDセット
        //Set<String> easyIdList = new Set<String>();
        //20190808 修正終了 EasyIDに基づいての検索を外す
        // 姓名情報セット
        Set<String> nameInfoList = new Set<String>();
        // 少短Web資料請求を繰り返し
        for(SsWebRequest__c ssWebRequestRecord : ssWebRequestList){
            // 手作成かつ取引先が設定される場合
            if(String.isNotBlank(ssWebRequestRecord.Ref_Account__c)){
               refAccIdList.add(ssWebRequestRecord.Ref_Account__c);
            }
            else{
                //20190808 修正開始 EasyIDに基づいての検索を外す
                // 楽天IDがある場合
                /*if(String.isNotBlank(ssWebRequestRecord.easy_id__c)){
                    easyIdList.add(ssWebRequestRecord.easy_id__c);
                }*/
                //20190808 修正終了 EasyIDに基づいての検索を外す
                // 姓名情報に空欄がない場合
                if(String.isNotBlank(ssWebRequestRecord.last_name__c) && String.isNotBlank(ssWebRequestRecord.first_name__c)
                         && String.isNotBlank(ssWebRequestRecord.last_name_kana__c) && String.isNotBlank(ssWebRequestRecord.first_name_kana__c)){
                    String tmpName = ssWebRequestRecord.last_name__c + ssWebRequestRecord.first_name__c 
                                     + ssWebRequestRecord.last_name_kana__c + ssWebRequestRecord.first_name_kana__c;
                    tmpName = tmpName.deleteWhitespace();
                    nameInfoList.add(tmpName);
                }
            }
        }
        // 既存の取引先を取得(取引先IDベース)
        Map<String,Account> existRefAccountMap = new Map<String,Account>();
        for(Account acc : [SELECT Id,furiganaLast__pc,furiganaForst__pc FROM Account WHERE Id IN :refAccIdList]){
            existRefAccountMap.put(acc.Id, acc);
        }
        //20190808 修正開始 EasyIDに基づいての検索を外す
        // 既存の取引先を取得(楽天IDベース)
        /*Map<String,Account> existEasyIdAccountMap = new Map<String,Account>();
        for(Account acc : [SELECT Id,furiganaLast__pc,furiganaForst__pc, easyId__pc FROM Account WHERE easyId__pc IN :easyIdList]){
            existEasyIdAccountMap.put(acc.easyId__pc , acc);
        }*/
        //20190808 修正終了 EasyIDに基づいての検索を外す
        // 既存の取引先を取得(姓名情報ベース)
        Map<String,List<Account>> existNameInfoAccountMap = new Map<String,List<Account>>();
        for(Account acc : [SELECT Id,furiganaLast__pc,furiganaForst__pc, SYSAccountName__c, Gender__pc, PersonBirthdate, PersonHomePhone, PersonMobilePhone FROM Account 
                           WHERE SYSAccountName__c IN :nameInfoList ORDER BY LastModifiedDate DESC]){
            if(existNameInfoAccountMap.get(acc.SYSAccountName__c) == NULL){
                List<Account> accList = new List<Account>();
                accList.add(acc);
                existNameInfoAccountMap.put(acc.SYSAccountName__c,accList);
            }else{
                existNameInfoAccountMap.get(acc.SYSAccountName__c).add(acc);
            }
        }
        List<Account> insertAccList = new List<Account>();
        // 少短Web資料請求情報全件繰り返し
        for(SsWebRequest__c ssWebRequestRecord : ssWebRequestList){
            Account targetAccount;
            String nameInfo = '';
            // 手作成の場合、取引先が設定されている場合、名寄せ処理しない
            if(String.isNotBlank(ssWebRequestRecord.Ref_Account__c)){
                targetAccount = existRefAccountMap.get(ssWebRequestRecord.Ref_Account__c);
            }
            //20190808 修正開始 EasyIDに基づいての検索を外す
            // 楽天IDがある場合
            /*else if(String.isNotBlank(ssWebRequestRecord.easy_id__c)){
                targetAccount = existEasyIdAccountMap.get(ssWebRequestRecord.easy_id__c);
            }*/
            //20190808 修正終了 EasyIDに基づいての検索を外す
            // 楽天IDで見つからなかった場合
            if(targetAccount == NULL){
                // 姓名情報に空欄がない場合
                if(String.isNotBlank(ssWebRequestRecord.last_name__c) && String.isNotBlank(ssWebRequestRecord.first_name__c) 
                         && String.isNotBlank(ssWebRequestRecord.last_name_kana__c) && String.isNotBlank(ssWebRequestRecord.first_name_kana__c)){
                    nameInfo = ssWebRequestRecord.last_name__c + ssWebRequestRecord.first_name__c 
                                     + ssWebRequestRecord.last_name_kana__c + ssWebRequestRecord.first_name_kana__c;
                    nameInfo = nameInfo.deleteWhitespace();
                    // 姓名情報が一致するレコードを繰り返す
                    List<Account> accList = existNameInfoAccountMap.get(nameInfo);
                    if(accList <> NULL){
                        for(Account acc : existNameInfoAccountMap.get(nameInfo)){
                            // 固定電話番号か携帯電話番号のいずれか一致する
                            if((acc.PersonHomePhone<>NULL && ((ssWebRequestRecord.tel1__c<>NULL && ssWebRequestRecord.tel1__c.replace('-','').equals(acc.PersonHomePhone.replace('-',''))) 
                                                            || (ssWebRequestRecord.tel2__c<>NULL && ssWebRequestRecord.tel2__c.replace('-','').equals(acc.PersonHomePhone.replace('-',''))) 
                                                            || (ssWebRequestRecord.tel3__c<>NULL && ssWebRequestRecord.tel3__c.replace('-','').equals(acc.PersonHomePhone.replace('-','')))))
                              || (acc.PersonMobilePhone<>NULL && ((ssWebRequestRecord.tel1__c<>NULL && ssWebRequestRecord.tel1__c.replace('-','').equals(acc.PersonMobilePhone.replace('-',''))) 
                                                              || (ssWebRequestRecord.tel2__c<>NULL && ssWebRequestRecord.tel2__c.replace('-','').equals(acc.PersonMobilePhone.replace('-',''))) 
                                                              || (ssWebRequestRecord.tel3__c<>NULL && ssWebRequestRecord.tel3__c.replace('-','').equals(acc.PersonMobilePhone.replace('-','')))))){
                                targetAccount = acc;
                                break;
                            }
                        }
                    }
                }
            }
            // 既存の取引先がない場合
            if(targetAccount == null){
                // 取引先を新規
                targetAccount = new Account();
                targetAccount.RecordTypeId = accountPersonRecordTypeId;
                createTargetAccount(targetAccount, ssWebRequestRecord);
                insertAccList.add(targetAccount);
                if(String.isNotBlank(ssWebRequestRecord.last_name__c) && String.isNotBlank(ssWebRequestRecord.first_name__c) 
                     && String.isNotBlank(ssWebRequestRecord.last_name_kana__c) && String.isNotBlank(ssWebRequestRecord.first_name_kana__c)){
                    nameInfo = ssWebRequestRecord.last_name__c + ssWebRequestRecord.first_name__c 
                                 + ssWebRequestRecord.last_name_kana__c + ssWebRequestRecord.first_name_kana__c;
                    nameInfo = nameInfo.deleteWhitespace();
                    List<Account> accList = existNameInfoAccountMap.get(nameInfo);
                    if(accList == null){
                        accList = new List<Account>();
                    }
                    accList.add(targetAccount);
                    existNameInfoAccountMap.put(nameInfo, accList);
                }
            }
            targetAccountMap.put(ssWebRequestRecord.id__c, targetAccount);
        }
        insert insertAccList;
        
        // 商談
        // 案件の生保レコードタイプIDを取得
        Id oppSeihoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Syotan').getRecordTypeId();
        DateTime insertDate = datetime.now();
        //商談のクローズ日は翌々月末日
        Date today = System.today();
        Date insertCloseDate = Date.newInstance(today.year(), today.month() + 3,0);
        String opportunityNameInsertStr = insertDate.format('yyyyMMdd') + '_' + '少短' + '_';
        // 少短Web資料、商談関連用マップ Key:少短Web資料請求ID
        Map<String,Opportunity> ssWebOpportunityMap = new Map<String,Opportunity>();
        // 少短Web資料請求を繰り返し
        for(SsWebRequest__c ssWebRequestRecord : ssWebRequestList){
            Account tmpAcc = targetAccountMap.get(ssWebRequestRecord.id__c);
            // 商談新規作成
            Opportunity targetOpp = new Opportunity();
            // 商談の設定
            targetOpp.RecordTypeId = oppSeihoRecordTypeId;
            // 商談名
            targetOpp.name = opportunityNameInsertStr;
            if(String.isNotBlank(tmpAcc.furiganaLast__pc)){
                targetOpp.name  = targetOpp.name + tmpAcc.furiganaLast__pc;
            }
            if(String.isNotBlank(tmpAcc.furiganaForst__pc)){
                targetOpp.name  = targetOpp.name + tmpAcc.furiganaForst__pc;
            }
            if(targetOpp.name.length()>80){
                targetOpp.name = targetOpp.name.left(80);
            }
            // 商談ステータス
            //targetOpp.StageName = 'C';
            targetOpp.StageName = '未対応';
            // 入電理由
            targetOpp.telReason__c = 'その他'; 
            // 申込日
            targetOpp.CloseDate = insertCloseDate;
            // 取引先Id
            targetOpp.AccountId = tmpAcc.Id;
            ssWebOpportunityMap.put(ssWebRequestRecord.id__c, targetOpp);
        }
        // 新規商談Insert
        insert ssWebOpportunityMap.values();
        
        // 少短Web資料請求の項目更新
        for(SsWebRequest__c ssWebRequestRecord : ssWebRequestList){
            ssWebRequestRecord.Opportunity__c = ssWebOpportunityMap.get(ssWebRequestRecord.id__c).Id;
            ssWebRequestRecord.Ref_Account__c = targetAccountMap.get(ssWebRequestRecord.id__c).Id;
        }
    }
    
    /**
     * 少短Web資料請求作成後処理
     * @param List<SsWebRequest__c>
     * @return 
     */
    public void onAfterInsertProcess(List<SsWebRequest__c> ssWebRequestList){
        Set<Id> ssWebIdSet = new Set<Id>();
        for(SsWebRequest__c ssWeb : ssWebRequestList){
            ssWebIdSet.add(ssWeb.Id);
        }
        createTargetCase(ssWebIdSet);
    }
        
    /**
     * 取引先作成/更新処理
     * @param Account 作成/更新対象取引先
     * @param SsWebRequest__c 作成/更新元となる少短Web資料請求情報
     * @return 
     */
    private void createTargetAccount(Account target , SsWebRequest__c ssWebRequestRecord){
        // 姓名情報
        // 姓名情報
        if(ssWebRequestRecord.last_name__c <> Null){
            target.LastName = ssWebRequestRecord.last_name__c.left(40);
            target.LastName__pc = ssWebRequestRecord.last_name__c.left(40);
        }else{
            target.LastName = '未登録';
            target.LastName__pc = '未登録';
        }
        if(ssWebRequestRecord.first_name__c <> Null){
            target.FirstName = ssWebRequestRecord.first_name__c.left(40);
            target.firstname__pc = ssWebRequestRecord.first_name__c.left(40);
        }else{
            target.FirstName = '未登録';
            target.firstname__pc = '未登録';
        }
        target.furiganaLast__pc = ssWebRequestRecord.last_name_kana__c;
        target.furiganaForst__pc = ssWebRequestRecord.first_name_kana__c;
        // 楽天会員ID
        target.easyId__pc = ssWebRequestRecord.easy_id__c;
        // メール
        target.PersonEmail = ssWebRequestRecord.email__c;
        // 住所情報
        if(ssWebRequestRecord.zip_code1__c != NULL && ssWebRequestRecord.zip_code1__c.length() > 20){
            target.PersonMailingPostalCode = ssWebRequestRecord.zip_code1__c.left(20);
        }else{
            target.PersonMailingPostalCode = ssWebRequestRecord.zip_code1__c;
        }
        if(ssWebRequestRecord.pref__c != NULL && ssWebRequestRecord.pref__c.length() > 80){
            target.PersonMailingState = ssWebRequestRecord.pref__c.left(80);
        }else{
            target.PersonMailingState = ssWebRequestRecord.pref__c;
        }
        if(ssWebRequestRecord.city__c != NULL && ssWebRequestRecord.city__c.length() > 40){
            target.PersonMailingCity = ssWebRequestRecord.city__c.left(40);
        }else{
            target.PersonMailingCity = ssWebRequestRecord.city__c;
        }
        String streetStr = '';
            if(String.isNotBlank(ssWebRequestRecord.address__c)){
                streetStr = ssWebRequestRecord.address__c;
            }
            if(String.isNotBlank(ssWebRequestRecord.building__c)){
                streetStr = streetStr + ssWebRequestRecord.building__c;
            }
        if(streetStr != NULL && streetStr.length() > 255){
            target.PersonMailingStreet = streetStr.left(255);
        }else{
            target.PersonMailingStreet = streetStr;
        }
        // 連絡先情報
        target.Phone = ssWebRequestRecord.tel1__c;
        target.PersonHomePhone = ssWebRequestRecord.tel1__c;
        target.PersonMobilePhone = ssWebRequestRecord.tel2__c;
        // 顧客区分
        target.division__pc = '見込み顧客';
    }
    
    /**
     * ケース作成処理
     * @param List 作成元となる少短Web資料請求情報のID情報
     * @return 
     */
    @future
    public static void createTargetCase(Set<Id> ssWebIDs){
        List<Case> insertTargetCaseList = new List<Case>();
        // ケース（資料請求（生命））のレコードタイプID
        Id caseSeihoRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('LittleLead_Web').getRecordTypeId();
        // 少短Web資料請求情報
        List<SsWebRequest__c> ssWebList = [SELECT ID,request_id__c,zip_code1__c,address_kana__c,request_date__c,Ref_Account__c 
                                           FROM SsWebRequest__c
                                           WHERE ID IN :ssWebIDs];
        Set<Id> accIdSet = new Set<Id>();
        for(SsWebRequest__c ssWeb : ssWebList){
            accIdSet.add(ssWeb.Ref_Account__c);
        }
        Map<Id,Account> accMap = new Map<Id,Account>([SELECT ID,personContactId FROM ACCOUNT WHERE ID IN :accIdSet]);
        for(SsWebRequest__c ssWeb : ssWebList){
            //ケースの新規作成
            Case targetCase = new Case();
            targetCase.recordTypeId = caseSeihoRecordTypeId;
            targetCase.AccountId = ssWeb.Ref_Account__c;
            targetCase.ContactId = accMap.get(ssWeb.Ref_Account__c).personContactId;
            //対応区分
            targetCase.class__c = 'セールス専用ケース';
            //対応種別
            targetCase.type__c = '少短_資料請求';
            // 発生源
            targetCase.Origin = 'Web';
            // 状況
            targetCase.Status = 'オープン';
            // 資料請求ID
            targetCase.DataRequestID__c = ssWeb.request_id__c;
            // 郵便番号
            targetCase.PostNumber__c = ssWeb.zip_code1__c;
            // 住所（ﾌﾘｶﾞﾅ）
            targetCase.AddressKana__c = ssWeb.address_kana__c;
            // 資料請求日時
            if(ssWeb.request_date__c != NULL){
                try{
                	targetCase.DocumentRequestDateTime__c = Datetime.valueOf(ssWeb.request_date__c);
                }catch(Exception e){
                    targetCase.DocumentRequestDateTime__c = null;
                }
            }
            insertTargetCaseList.add(targetCase);
        }
        insert insertTargetCaseList;
    }
}