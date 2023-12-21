/*
* @Class Name      : SyotanDocumentRequestsTriggerHandler 
* @Description     : 少短資料請求トリガーハンドラ
* @Created Date    : 2019.05.17
* @Created By      : 
* @Modified Date   : 2019-06-21
* @Modified        : R, Kartikeyan
* @Modified Date   : 2019-12-20
* @Modified        : Valsala Kumar
*/
public class SyotanDocumentRequestsTriggerHandler {

    /**
     * コンストラクタ
     */
    public SyotanDocumentRequestsTriggerHandler() {}
  
    /**
     * 少短Web資料請求作成前処理
     * @param List<SyotanDocumentRequests>
     * @return 
     */
    public void onBeforeInsertProcess(List<SyotanDocumentRequests__c> syotanDocumentRequestsList){
        //作成情報格納用マップ ID:少短資料請求ID
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
        for(SyotanDocumentRequests__c syotanDocumentRequestsRecord : syotanDocumentRequestsList){
            // 手作成かつ取引先が設定される場合
            if(String.isNotBlank(syotanDocumentRequestsRecord.Ref_Account__c)){
               refAccIdList.add(syotanDocumentRequestsRecord.Ref_Account__c);
            }
            // 楽天IDがある場合
            //else if(String.isNotBlank(syotanDocumentRequestsRecord.easy_id__c)){
            //    easyIdList.add(syotanDocumentRequestsRecord.easy_id__c);
            //}
            // 姓名情報に空欄がない場合
            else if(String.isNotBlank(syotanDocumentRequestsRecord.last_name__c) && String.isNotBlank(syotanDocumentRequestsRecord.first_name__c)
                     && String.isNotBlank(syotanDocumentRequestsRecord.last_name_kana__c) && String.isNotBlank(syotanDocumentRequestsRecord.first_name_kana__c)){
                String tmpName = syotanDocumentRequestsRecord.last_name__c + syotanDocumentRequestsRecord.first_name__c 
                                 + syotanDocumentRequestsRecord.last_name_kana__c + syotanDocumentRequestsRecord.first_name_kana__c;
                tmpName = tmpName.deleteWhitespace();
                nameInfoList.add(tmpName);
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
            existEasyIdAccountMap.put(acc.easyId__pc, acc);
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
        for(SyotanDocumentRequests__c syotanDocumentRequestsRecord : syotanDocumentRequestsList){
            Account targetAccount;
            String nameInfo = '';
            // 手作成の場合、取引先が設定されている場合、名寄せ処理しない
            if(String.isNotBlank(syotanDocumentRequestsRecord.Ref_Account__c)){
                targetAccount = existRefAccountMap.get(syotanDocumentRequestsRecord.Ref_Account__c);
            }
            // 楽天IDがある場合
            //else if(String.isNotBlank(syotanDocumentRequestsRecord.easy_id__c)){
            //    targetAccount = existEasyIdAccountMap.get(syotanDocumentRequestsRecord.easy_id__c);
            //}
            // 姓名情報に空欄がない場合
            else if(String.isNotBlank(syotanDocumentRequestsRecord.last_name__c) && String.isNotBlank(syotanDocumentRequestsRecord.first_name__c) 
                     && String.isNotBlank(syotanDocumentRequestsRecord.last_name_kana__c) && String.isNotBlank(syotanDocumentRequestsRecord.first_name_kana__c)){
                nameInfo = syotanDocumentRequestsRecord.last_name__c + syotanDocumentRequestsRecord.first_name__c 
                                 + syotanDocumentRequestsRecord.last_name_kana__c + syotanDocumentRequestsRecord.first_name_kana__c;
                nameInfo = nameInfo.deleteWhitespace();
                
                // 姓名情報が一致するレコードを繰り返す
                List<Account> accList = existNameInfoAccountMap.get(nameInfo);
                if(accList <> NULL){
                    for(Account acc : existNameInfoAccountMap.get(nameInfo)){
                        // 固定電話番号か携帯電話番号のいずれか一致する
                        if((acc.PersonHomePhone<>NULL && ((syotanDocumentRequestsRecord.tel1__c<>NULL && syotanDocumentRequestsRecord.tel1__c.replace('-','').equals(acc.PersonHomePhone.replace('-',''))) 
                                                        || (syotanDocumentRequestsRecord.tel2__c<>NULL && syotanDocumentRequestsRecord.tel2__c.replace('-','').equals(acc.PersonHomePhone.replace('-',''))) 
                                                        || (syotanDocumentRequestsRecord.tel3__c<>NULL && syotanDocumentRequestsRecord.tel3__c.replace('-','').equals(acc.PersonHomePhone.replace('-','')))))
                          || (acc.PersonMobilePhone<>NULL && ((syotanDocumentRequestsRecord.tel1__c<>NULL && syotanDocumentRequestsRecord.tel1__c.replace('-','').equals(acc.PersonMobilePhone.replace('-',''))) 
                                                          || (syotanDocumentRequestsRecord.tel2__c<>NULL && syotanDocumentRequestsRecord.tel2__c.replace('-','').equals(acc.PersonMobilePhone.replace('-',''))) 
                                                          || (syotanDocumentRequestsRecord.tel3__c<>NULL && syotanDocumentRequestsRecord.tel3__c.replace('-','').equals(acc.PersonMobilePhone.replace('-','')))))){
                            targetAccount = acc;
                            break;
                        }
                    }
                }
            }
            // 既存の取引先がない場合
            if(targetAccount == null){
                // 取引先を新規
                targetAccount = new Account();
                targetAccount.RecordTypeId = accountPersonRecordTypeId;
                createTargetAccount(targetAccount, syotanDocumentRequestsRecord);
                insertAccList.add(targetAccount);
                if(String.isNotBlank(syotanDocumentRequestsRecord.last_name__c) && String.isNotBlank(syotanDocumentRequestsRecord.first_name__c) 
                     && String.isNotBlank(syotanDocumentRequestsRecord.last_name_kana__c) && String.isNotBlank(syotanDocumentRequestsRecord.first_name_kana__c)){
                    nameInfo = syotanDocumentRequestsRecord.last_name__c + syotanDocumentRequestsRecord.first_name__c 
                                 + syotanDocumentRequestsRecord.last_name_kana__c + syotanDocumentRequestsRecord.first_name_kana__c;
                    nameInfo = nameInfo.deleteWhitespace();
                    List<Account> accList = existNameInfoAccountMap.get(nameInfo);
                    if(accList == null){
                        accList = new List<Account>();
                    }
                    accList.add(targetAccount);
                    existNameInfoAccountMap.put(nameInfo, accList);
                }
            }
            targetAccountMap.put(syotanDocumentRequestsRecord.id__c, targetAccount);
        }
        insert insertAccList;
        
        List<Id> accIdList = new List<Id>();
        for(Account acc : targetAccountMap.values()){
            accIdList.add(acc.Id);
        }
        
        // 商談
        // 案件の生保レコードタイプIDを取得
        Id oppSyotanRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Syotan').getRecordTypeId();
        DateTime insertDate = datetime.now();
        //商談のクローズ日は翌月末日
        Date today = System.today();
        Date insertCloseDate = Date.newInstance(today.year(), today.month() + 2,0);
        String opportunityNameInsertStr = insertDate.format('yyyyMMdd') + '_' + '少短' + '_';
        // 少短Web資料請求、商談関連用マップ Key:少短資料請求ID
        //Map<String,Opportunity> syotanDocOpportunityMap = new Map<String,Opportunity>();
        // 取引先、商談関連用マップ ID:取引先ID
        Map<Id,Opportunity> syotanDocOpportunityMap = new Map<Id,Opportunity>();
        // 新規商談Insert用リスト
        List<Opportunity> insertOpportunityList = new List<Opportunity>();
        // 既存商談を取得
        List<Opportunity> existOpportunityList = [SELECT Id, Name, AccountId
                                                  FROM Opportunity
                                                  WHERE AccountId IN :accIdList
                                                  AND RecordType.DeveloperName = 'Syotan'
                                                  AND StageName <> '対応終了'
                                                  ORDER BY LastModifiedDate DESC];
        // 取引先、商談関連用マップに入れる
        for(Opportunity opp : existOpportunityList){
            if (syotanDocOpportunityMap.get(opp.AccountId) == NULL) {
                syotanDocOpportunityMap.put(opp.AccountId, opp);
            }
        }
        
        // 少短Web資料請求情報全件繰り返し
        for(SyotanDocumentRequests__c syotanDocumentRequestsRecord : syotanDocumentRequestsList){
            Account tmpAcc = targetAccountMap.get(syotanDocumentRequestsRecord.id__c);
            
            if(syotanDocOpportunityMap.get(tmpAcc.Id) == NULL){
                // 商談がない場合、新規作成
                Opportunity targetOpp = new Opportunity();
                // 商談の設定
                targetOpp.RecordTypeId = oppSyotanRecordTypeId;
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
                targetOpp.StageName = '未割当';
                // 入電理由
                targetOpp.telReason__c = 'その他'; 
                // 申込日
                targetOpp.CloseDate = insertCloseDate;
                // 取引先Id
                targetOpp.AccountId = tmpAcc.Id;
                // リードソース
                targetOpp.InflowRoute__c = '資料請求';
                // キャンペーン日時 = 少短資料請求．システム日付
                targetOpp.CampaignDateTime__c = System.Now();
                
                insertOpportunityList.add(targetOpp);
                //syotanDocOpportunityMap.put(syotanDocumentRequestsRecord.id__c, targetOpp);
                syotanDocOpportunityMap.put(tmpAcc.Id, targetOpp);
            }
        }
        // 新規商談Insert
        insert insertOpportunityList;
        
        // 少短Web資料請求の項目更新
        for(SyotanDocumentRequests__c syotanDocumentRequestsRecord : syotanDocumentRequestsList){
            //ケース作成フラグをセットする。
            if(!Test.isRunningTest()){
                syotanDocumentRequestsRecord.caseCreationFlag__c = true;
            }
            //syotanDocumentRequestsRecord.Ref_Syodan__c = syotanDocOpportunityMap.get(syotanDocumentRequestsRecord.id__c).Id;
            syotanDocumentRequestsRecord.Ref_Syodan__c = syotanDocOpportunityMap.get(targetAccountMap.get(syotanDocumentRequestsRecord.id__c).Id).Id;
            syotanDocumentRequestsRecord.Ref_Account__c = targetAccountMap.get(syotanDocumentRequestsRecord.id__c).Id;
        }
    }
    
    // Del Start 2019-06-21
    ///**
    // * 少短Web資料請求作成後処理
    // * @param List<SyotanDocumentRequests>
    // * @return 
    // */
    //public void onAfterInsertProcess(List<SyotanDocumentRequests__c> syotanDocumentRequestsList){
    //    Set<Id> syotanDocIdSet = new Set<Id>();
    //    for(SyotanDocumentRequests__c syotanDoc : syotanDocumentRequestsList){
    //        syotanDocIdSet.add(syotanDoc.Id);
    //    }
    //    createTargetCase(syotanDocIdSet);
    //}
    // Del End 2019-06-21
    
    /**
     * 取引先作成/更新処理
     * @param Account 作成/更新対象取引先
     * @param SyotanDocumentRequests 作成/更新元となる少短Web資料請求情報
     * @return 
     */
    private void createTargetAccount(Account target , SyotanDocumentRequests__c syotanDocumentRequestsRecord){
        // 姓名情報
        // 姓名情報
        if(syotanDocumentRequestsRecord.last_name__c <> Null){
            target.LastName = syotanDocumentRequestsRecord.last_name__c.left(40);
            target.LastName__pc = syotanDocumentRequestsRecord.last_name__c.left(40);
        }else{
            target.LastName = '未登録';
            target.LastName__pc = '未登録';
        }
        if(syotanDocumentRequestsRecord.first_name__c <> Null){
            target.FirstName = syotanDocumentRequestsRecord.first_name__c.left(40);
            target.firstname__pc = syotanDocumentRequestsRecord.first_name__c.left(40);
        }else{
            target.FirstName = '未登録';
            target.firstname__pc = '未登録';
        }
        target.furiganaLast__pc = syotanDocumentRequestsRecord.last_name_kana__c;
        target.furiganaForst__pc = syotanDocumentRequestsRecord.first_name_kana__c;
        // 楽天会員ID
        //target.easyId__pc = syotanDocumentRequestsRecord.easy_id__c;
        // 性別
        // **** todo ***** //
        //target.Gender__pc = syotanDocumentRequestsRecord.seibetsu_keiyaku__c;
        // メール
        target.PersonEmail = syotanDocumentRequestsRecord.email__c;
        // 住所情報
        if(syotanDocumentRequestsRecord.zip_code1__c != NULL && syotanDocumentRequestsRecord.zip_code1__c.length() > 20){
            target.PersonMailingPostalCode = syotanDocumentRequestsRecord.zip_code1__c.left(20);
        }else{
            target.PersonMailingPostalCode = syotanDocumentRequestsRecord.zip_code1__c;
        }
        if(syotanDocumentRequestsRecord.pref__c != NULL && syotanDocumentRequestsRecord.pref__c.length() > 80){
            target.PersonMailingState = syotanDocumentRequestsRecord.pref__c.left(80);
        }else{
            target.PersonMailingState = syotanDocumentRequestsRecord.pref__c;
        }
        if(syotanDocumentRequestsRecord.city__c != NULL && syotanDocumentRequestsRecord.city__c.length() > 40){
            target.PersonMailingCity = syotanDocumentRequestsRecord.city__c.left(40);
        }else{
            target.PersonMailingCity = syotanDocumentRequestsRecord.city__c;
        }
        String streetStr = '';
            if(String.isNotBlank(syotanDocumentRequestsRecord.address__c)){
                streetStr = syotanDocumentRequestsRecord.address__c;
            }
            if(String.isNotBlank(syotanDocumentRequestsRecord.building__c)){
                streetStr = streetStr + syotanDocumentRequestsRecord.building__c;
            }
        if(streetStr != NULL && streetStr.length() > 255){
            target.PersonMailingStreet = streetStr.left(255);
        }else{
            target.PersonMailingStreet = streetStr;
        }
        // 連絡先情報
        target.Phone = syotanDocumentRequestsRecord.tel1__c;
        target.PersonHomePhone = syotanDocumentRequestsRecord.tel1__c;
        target.PersonMobilePhone = syotanDocumentRequestsRecord.tel2__c;
        // 顧客区分
        target.division__pc = '見込み顧客';
        //******20191220 修正　開始*******/
        target.OperationType__c = '割当可';
        target.OpportunityStatus__c = '未対応';
        //******20191220 修正　エンド*******/
    }
    
    // Del Start 2019-06-21 
    ///**
    // * ケース作成処理
    // * @param List 作成元となる少短資料請求情報のID情報
    // * @return 
    // */
    //@future
    //public static void createTargetCase(Set<Id> syotanDocIDs){
    //    List<Case> insertTargetCaseList = new List<Case>();
    //    // ケース（資料請求（生命））のレコードタイプID
    //    Id caseSeihoRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('LittleLead_Call').getRecordTypeId();
    //    // 少短資料請求情報
    //    List<SyotanDocumentRequests__c> syotanDocList = [SELECT ID,request_id__c,zip_code1__c,address_kana__c,request_date__c,Ref_Account__c 
    //                                                     FROM SyotanDocumentRequests__c
    //                                                    WHERE ID IN :syotanDocIDs];
    //    Set<Id> accIdSet = new Set<Id>();
    //    for(SyotanDocumentRequests__c syotanDoc : syotanDocList){
    //        accIdSet.add(syotanDoc.Ref_Account__c);
    //    }
    //    Map<Id,Account> accMap = new Map<Id,Account>([SELECT ID,personContactId FROM ACCOUNT WHERE ID IN :accIdSet]);
    //    for(SyotanDocumentRequests__c syotanDoc : syotanDocList){
    //        //ケースの新規作成
    //        Case targetCase = new Case();
    //        targetCase.recordTypeId = caseSeihoRecordTypeId;
    //        targetCase.AccountId = syotanDoc.Ref_Account__c;
    //        targetCase.ContactId = accMap.get(syotanDoc.Ref_Account__c).personContactId;
    //        //対応区分
    //        targetCase.class__c = 'セールス専用ケース';
    //        //対応種別
    //        targetCase.type__c = '少短_資料請求';
    //        // 発生源
    //        targetCase.Origin = 'Web';
    //        // 状況
    //        targetCase.Status = 'オープン';
    //        // 資料請求ID
    //        targetCase.DataRequestID__c = syotanDoc.request_id__c;
    //        // 郵便番号
    //        targetCase.PostNumber__c = syotanDoc.zip_code1__c;
    //        // 住所（ﾌﾘｶﾞﾅ）
    //        targetCase.AddressKana__c = syotanDoc.address_kana__c;
    //        // 資料請求日時
    //        if(syotanDoc.request_date__c != NULL){
    //            try{
    //                targetCase.DocumentRequestDateTime__c = Datetime.newInstance(syotanDoc.request_date__c.year(), 
    //                                                                         syotanDoc.request_date__c.month(), 
    //                                                                         syotanDoc.request_date__c.day());
    //            }catch (Exception e){
    //                targetCase.DocumentRequestDateTime__c = null;
    //            }
    //        }
    //        insertTargetCaseList.add(targetCase);
    //    }
    //    insert insertTargetCaseList;
    //}
    // Del End 2019-06-21
}