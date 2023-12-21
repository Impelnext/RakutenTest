/*
* @Class Name      : GeneralRequestTriggerHandler 
* @Description     : 損保資料請求トリガーハンドラ
* @Created Date    : 2019.04.19
* @Created By      : 
* @Modified Date   : 2019-06-21
* @Modified        : R, Kartikeyan
* @Modified Date   : 2019-12-23
* @Modified        : Valsala Kumar
*/
public class GeneralRequestTriggerHandler {

    /**
     * コンストラクタ
     */
    public GeneralRequestTriggerHandler() {}
  
    /**
     * 損保資料請求作成前処理
     * @param List<GeneralRequest__c>
     * @return 
     */
    public void onBeforeInsertProcess(List<GeneralRequest__c> generalRequestList){
        //作成情報格納用マップ ID:損保資料請求ID
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
        // 損保資料請求を繰り返し
        for(GeneralRequest__c generalRequestRecord : generalRequestList){
            if(generalRequestRecord.Ref_Account__c != null){
               refAccIdList.add(generalRequestRecord.Ref_Account__c);
            }
            else{
                //20190808 修正開始 EasyIDに基づいての検索を外す
                // 楽天IDがある場合
                /*if(String.isNotBlank(generalRequestRecord.easy_id__c)){
                    easyIdList.add(generalRequestRecord.easy_id__c);
                 }*/
                //20190808 修正終了 EasyIDに基づいての検索を外す
                // 姓名情報に空欄がない場合
                if(String.isNotBlank(generalRequestRecord.name__c) && String.isNotBlank(generalRequestRecord.furigana__c)){
                    String tmpName = generalRequestRecord.name__c + generalRequestRecord.furigana__c;
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
        for(Account acc : [SELECT Id,furiganaLast__pc,furiganaForst__pc,easyId__pc FROM Account WHERE easyId__pc IN :easyIdList]){
            existEasyIdAccountMap.put(acc.easyId__pc, acc);
        }*/
        //20190808 修正終了 EasyIDに基づいての検索を外す
        // 既存の取引先を取得(姓名情報ベース)
        Map<String,List<Account>> existNameInfoAccountMap = new Map<String,List<Account>>();
        for(Account acc : [SELECT Id, SYSAccountName__c, furiganaLast__pc,furiganaForst__pc, Gender__pc, PersonBirthdate, PersonHomePhone, PersonMobilePhone FROM Account 
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
        // 損保資料請求情報全件繰り返し
        for(GeneralRequest__c generalRequestRecord : generalRequestList){
            Account targetAccount;
            String nameInfo = '';
            // 手作成の場合、取引先が設定されている場合、名寄せ処理しない
            if(generalRequestRecord.Ref_Account__c != null){
                targetAccount = existRefAccountMap.get(generalRequestRecord.Ref_Account__c);
            }
            //20190808 修正開始 EasyIDに基づいての検索を外す
            // 楽天IDがある場合
            /*else if(String.isNotBlank(generalRequestRecord.easy_id__c)){
                targetAccount = existEasyIdAccountMap.get(generalRequestRecord.easy_id__c);
            }*/
            //20190808 修正終了 EasyIDに基づいての検索を外す
            // 楽天IDで見つからなかった場合
            if(targetAccount == NULL){
                // 姓名情報に空欄がない場合
                if(String.isNotBlank(generalRequestRecord.name__c) && String.isNotBlank(generalRequestRecord.furigana__c)){
                    nameInfo = generalRequestRecord.name__c + generalRequestRecord.furigana__c;
                    nameInfo = nameInfo.deleteWhitespace();
                    // 姓名情報が一致するレコードを繰り返す
                    List<Account> accList = existNameInfoAccountMap.get(nameInfo);
                    if(accList <> NULL){
                        for(Account acc : existNameInfoAccountMap.get(nameInfo)){
                            // 固定電話番号か携帯電話番号のいずれか一致する
                            if(generalRequestRecord.Phone__c<>NULL && ((acc.PersonHomePhone<>NULL && generalRequestRecord.Phone__c.replace('-','').equals(acc.PersonHomePhone.replace('-','')))
                            || (acc.PersonMobilePhone<>NULL && generalRequestRecord.phone__c.replace('-','').equals(acc.PersonMobilePhone.replace('-',''))))){
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
                createTargetAccount(targetAccount, generalRequestRecord);
                insertAccList.add(targetAccount);
                if(String.isNotBlank(generalRequestRecord.name__c) && String.isNotBlank(generalRequestRecord.furigana__c)){
                    nameInfo = generalRequestRecord.name__c + generalRequestRecord.furigana__c;
                    nameInfo = nameInfo.deleteWhitespace();
                    List<Account> accList = existNameInfoAccountMap.get(nameInfo);
                    if(accList == null){
                        accList = new List<Account>();
                    }
                    accList.add(targetAccount);
                    existNameInfoAccountMap.put(nameInfo, accList);
                }
            }
            targetAccountMap.put(generalRequestRecord.ForeignKey_Renban__c, targetAccount);
        }
        insert insertAccList;
        
        List<Id> accIdList = new List<Id>();
        for(Account acc : targetAccountMap.values()){
            accIdList.add(acc.Id);
        }
        
        // 商談
        // 案件の生保レコードタイプIDを取得
        Id oppSonpoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();
        //商談のクローズ日は翌月末日
        Date today = System.today();
        DateTime insertDate = datetime.now();
        Date insertCloseDate = Date.newInstance(today.year(), today.month() + 2,0);
        String opportunityNameInsertStr = insertDate.format('yyyyMMdd') + '_' + '損保' + '_';
        // 損保資料請求、商談関連用マップ Key:損保資料請求ID
        //Map<String,Opportunity> generalReqOpportunityMap = new Map<String,Opportunity>();
        // 取引先、商談関連用マップ ID:取引先ID
        Map<Id,Opportunity> generalReqOpportunityMap = new Map<Id,Opportunity>();
        // 新規商談Insert用リスト
        List<Opportunity> insertOpportunityList = new List<Opportunity>();
        // 既存商談を取得
        List<Opportunity> existOpportunityList = [SELECT Id, Name, AccountId
                                                  FROM Opportunity
                                                  WHERE AccountId IN :accIdList
                                                  AND RecordType.DeveloperName = 'Sonpo'
                                                  AND StageName <> '対応終了'
                                                  ORDER BY LastModifiedDate DESC];
        // 取引先、商談関連用マップに入れる
        for(Opportunity opp : existOpportunityList){
            if (generalReqOpportunityMap.get(opp.AccountId) == NULL) {
                generalReqOpportunityMap.put(opp.AccountId, opp);
            }
        }
        
        // 損保資料請求を繰り返し
        for(GeneralRequest__c generalRequestRecord : generalRequestList){
            Account tmpAcc = targetAccountMap.get(generalRequestRecord.ForeignKey_Renban__c);
            
            if(generalReqOpportunityMap.get(tmpAcc.Id) == NULL){
                // 商談がない場合、新規作成
                Opportunity targetOpp = new Opportunity();
                // 商談の設定
                targetOpp.RecordTypeId = oppSonpoRecordTypeId;
                // 商談名
                targetOpp.name = opportunityNameInsertStr;
                if(String.isNotBlank(tmpAcc.furiganaLast__pc)){
                   targetOpp.name = targetOpp.name + tmpAcc.furiganaLast__pc;
                }
                if(String.isNotBlank(tmpAcc.furiganaForst__pc)){
                   targetOpp.name = targetOpp.name + tmpAcc.furiganaForst__pc;
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
                // キャンペーン日時 = 損保資料請求．システム日付
                targetOpp.CampaignDateTime__c = System.Now();
                
                insertOpportunityList.add(targetOpp);
                //generalReqOpportunityMap.put(generalRequestRecord.ForeignKey_Renban__c, targetOpp);
                generalReqOpportunityMap.put(tmpAcc.Id, targetOpp);
            }
        }
        // 新規商談Insert
        insert insertOpportunityList;
        
        // 損保資料請求の項目更新
        for(GeneralRequest__c generalRequestRecord : generalRequestList){
            //ケース作成フラグをセットする。
            if(!Test.isRunningTest()){
                generalRequestRecord.caseCreationFlag__c = true;
            }
            //generalRequestRecord.Opportunity__c = generalReqOpportunityMap.get(generalRequestRecord.ForeignKey_Renban__c).Id;
            //if(String.isBlank(generalRequestRecord.Ref_Account__c)){
            //    generalRequestRecord.Ref_Account__c = targetAccountMap.get(generalRequestRecord.ForeignKey_Renban__c).Id;
            //}
            generalRequestRecord.Opportunity__c = generalReqOpportunityMap.get(targetAccountMap.get(generalRequestRecord.ForeignKey_Renban__c).Id).Id;
            generalRequestRecord.Ref_Account__c = targetAccountMap.get(generalRequestRecord.ForeignKey_Renban__c).Id;
        }
    }
    // Del Start 2019-06-21
    ///**
    // * 損保資料請求作成前処理
    // * @param List<GeneralRequest__c>
    // * @return 
    // */
    //public void onAfterInsertProcess(List<GeneralRequest__c> generalRequestList){
    //    Set<Id> generalReqSet = new Set<Id>();
    //    for(GeneralRequest__c generalReq : generalRequestList){
    //        generalReqSet.add(generalReq.Id);
    //    }
    //    createTargetCase(generalReqSet);
    //}  
    // Del End 2019-06-21
    
    /**
     * 取引先作成/更新処理
     * @param Account 作成/更新対象取引先
     * @param GeneralRequest__c 作成/更新元となる損保資料請求情報
     * @return 
     */
    private void createTargetAccount(Account target , GeneralRequest__c generalRequestRecord){
        // 姓名情報
        if(generalRequestRecord.name__c <> Null){
            target.LastName = generalRequestRecord.name__c.left(40);
            target.LastName__pc = generalRequestRecord.name__c.left(40);
        }else{
            target.LastName = '未登録';
            target.LastName__pc = '未登録';
        }
        target.furiganaLast__pc = generalRequestRecord.furigana__c;
        // 楽天会員ID
        target.easyId__pc = generalRequestRecord.easy_id__c;
        // メール
        target.PersonEmail = generalRequestRecord.email_address__c;
        // 住所情報
        if(generalRequestRecord.address__c != NULL && generalRequestRecord.address__c.length() > 255){
            target.PersonMailingStreet = generalRequestRecord.address__c.left(255);
        }else{
            target.PersonMailingStreet = generalRequestRecord.address__c;
        }
        // 連絡先情報
        target.Phone = generalRequestRecord.Phone__c;
        target.PersonHomePhone = generalRequestRecord.Phone__c;
        // 顧客区分
        target.division__pc = '見込み顧客';
        //******20191223 修正　開始*******/
        target.OperationType__c = '割当可';
        target.OpportunityStatus__c = '未対応';
        //******20191223 修正　エンド*******/
    }
    
    // Del Start 2019-06-21 
    ///**
    // * ケース作成処理
    // * @param List 作成元となる損保資料請求情報のID情報
    // * @return 
    // */
    //@future
    //public static void createTargetCase(Set<Id> generalReqIDs){
    //    List<Case> insertTargetCaseList = new List<Case>();
    //    // ケース（損保_ミドル連携）のレコードタイプID
    //    Id caseSeihoRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Sonpo_Middle').getRecordTypeId();
    //    // 損保資料請求情報
    //    List<GeneralRequest__c> generalReqList = [SELECT ID,Name,address__c,Ref_Account__c 
    //                                              FROM GeneralRequest__c
    //                                              WHERE ID IN :generalReqIDs];
    //    Set<Id> accIdSet = new Set<Id>();
    //    for(GeneralRequest__c generalReq : generalReqList){
    //        accIdSet.add(generalReq.Ref_Account__c);
    //    }
    //    Map<Id,Account> accMap = new Map<Id,Account>([SELECT ID,personContactId FROM ACCOUNT WHERE ID IN :accIdSet]);
    //    for(GeneralRequest__c generalReq : generalReqList){
    //        //ケースの新規作成
    //        Case targetCase = new Case();
    //        targetCase.recordTypeId = caseSeihoRecordTypeId;
    //        targetCase.AccountId = generalReq.Ref_Account__c;
    //        targetCase.ContactId = accMap.get(generalReq.Ref_Account__c).personContactId;
    //        //対応区分
    //        //targetCase.class__c = 'セールス専用ケース';
    //        //対応種別
    //        //targetCase.type__c = '損保_ミドル連携';
    //        // 発生源
    //        targetCase.Origin = 'Web';
    //        // 状況
    //        targetCase.Status = 'オープン';
    //        // 資料請求ID
    //        targetCase.DataRequestID__c = generalReq.Name;
    //        // 住所（ﾌﾘｶﾞﾅ）
    //        targetCase.AddressKana__c = generalReq.address__c;
    //        insertTargetCaseList.add(targetCase);
    //    }
    //    insert insertTargetCaseList;
    //}
    // Del End 2019-06-21
}