/*
* @Class Name      : SeihoLeadTriggerHandler 
* @Description     : 生保Web資料請求トリガーハンドラ
* @Created Date    : 2019.04.17
* @Created By      : 
* @Modified Date   : 2019-12-23
* @Modified        : Valsala Kumar
*/
public class SeihoLeadTriggerHandler {

    /**
     * コンストラクタ
     */
    public SeihoLeadTriggerHandler() {}
  
    /**
     * 生保Web資料請求作成前処理
     * @param List<SeihoLead__c>
     * @return 
     */
    public void onBeforeInsertProcess(List<SeihoLead__c> seihoLeadList){
        //作成情報格納用マップ ID:生保Web資料請求ID
        Map<Decimal,Account> targetAccountMap = new Map<Decimal,Account>();
        Map<Decimal,Case> targetCaseMap = new Map<Decimal,Case>();

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
        // 生保Web資料請求を繰り返し
        for(SeihoLead__c seihoLeadRecord : seihoLeadList){
            //手作成の場合、取引先が設定されている場合
            if(seihoLeadRecord.Ref_Account__c != null){
               refAccIdList.add(seihoLeadRecord.Ref_Account__c);
            }
            // 楽天IDがある場合
            else{
                //20190808 修正開始 EasyIDに基づいての検索を外す 
                /*if(String.isNotBlank(seihoLeadRecord.EasyId__c)){
                    easyIdList.add(seihoLeadRecord.EasyId__c);
                }*/
                //20190808 修正終了 EasyIDに基づいての検索を外す
                // 姓名情報に空欄がない場合
                if(   String.isNotBlank(seihoLeadRecord.LastName__c)
                        && String.isNotBlank(seihoLeadRecord.FirstName__c)
                        && String.isNotBlank(seihoLeadRecord.LastNameKana__c)
                        && String.isNotBlank(seihoLeadRecord.FirstNameKana__c)){
                    //氏名のキー情報を作成
                    String tmpName = seihoLeadRecord.LastName__c + seihoLeadRecord.FirstName__c + seihoLeadRecord.LastNameKana__c + seihoLeadRecord.FirstNameKana__c;
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
            existEasyIdAccountMap.put(acc.easyId__pc, acc);
        }*/
        //20190808 修正終了 EasyIDに基づいての検索を外す 
        // 既存の取引先を取得(姓名情報ベース)
        Map<String,List<Account>> existNameInfoAccountMap = new Map<String,List<Account>>();
        for(Account acc : [SELECT Id,furiganaLast__pc,furiganaForst__pc, SYSAccountName__c, Gender__pc, PersonBirthdate, PersonHomePhone, PersonMobilePhone
                           FROM Account 
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
        // 生保Web資料請求情報全件繰り返し
        for(SeihoLead__c seihoLeadRecord : seihoLeadList){
            Account targetAccount;
            String nameInfo = '';
            // 手作成の場合、取引先が設定されている場合、名寄せ処理しない
            if(seihoLeadRecord.Ref_Account__c != null){
                targetAccount = existRefAccountMap.get(seihoLeadRecord.Ref_Account__c);
            }
            //20190808 修正開始 EasyIDに基づいての検索を外す 
            // 楽天IDがある場合
            /*else if(String.isNotBlank(seihoLeadRecord.EasyId__c) && existEasyIdAccountMap.get(seihoLeadRecord.EasyId__c) <> Null){
                targetAccount = existEasyIdAccountMap.get(seihoLeadRecord.EasyId__c);
            }*/
            //20190808 修正終了 EasyIDに基づいての検索を外す 
            // 楽天IDで見つからなかった場合
            if(targetAccount == NULL){             
                // 姓名情報に空欄がない場合
                if(String.isNotBlank(seihoLeadRecord.LastName__c)
                    && String.isNotBlank(seihoLeadRecord.FirstName__c) 
                    && String.isNotBlank(seihoLeadRecord.LastNameKana__c)
                    && String.isNotBlank(seihoLeadRecord.FirstNameKana__c)){
                    //氏名のキー情報作成
                    nameInfo = seihoLeadRecord.LastName__c + seihoLeadRecord.FirstName__c + seihoLeadRecord.LastNameKana__c + seihoLeadRecord.FirstNameKana__c;
                    nameInfo = nameInfo.deleteWhitespace();
                    // 姓名情報が一致するレコードを繰り返す
                    List<Account> accList = existNameInfoAccountMap.get(nameInfo);
                    if(accList <> NULL){
                        for(Account acc : existNameInfoAccountMap.get(nameInfo)){
                            // 固定電話番号か携帯電話番号のいずれか一致する
                            if((seihoLeadRecord.Phone__c <> Null && acc.PersonHomePhone<>NULL && seihoLeadRecord.Phone__c.replace('-','').equals(acc.PersonHomePhone.replace('-','')))
                               || (seihoLeadRecord.MobilePhone__c <> Null && acc.PersonMobilePhone<>NULL && seihoLeadRecord.MobilePhone__c.replace('-','').equals(acc.PersonMobilePhone.replace('-','')))){
                                targetAccount = acc;
                                break;
                            }
                            // 生年月日かつ性別が一致する
                            else if(seihoLeadRecord.Birthdate__c == acc.PersonBirthdate
                                    && (seihoLeadRecord.Gender__c <> Null && seihoLeadRecord.Gender__c.equals(acc.Gender__pc))){
                                targetAccount = acc;
                                break;
                            }
                        }
                    }
                }
            }
            // 既存の取引先がない場合
            if(targetAccount == null){
                targetAccount = new Account();
                targetAccount.RecordTypeId = accountPersonRecordTypeId;
                createTargetAccount(targetAccount, seihoLeadRecord);
                insertAccList.add(targetAccount);
                if(   String.isNotBlank(seihoLeadRecord.LastName__c)
                    && String.isNotBlank(seihoLeadRecord.FirstName__c) 
                    && String.isNotBlank(seihoLeadRecord.LastNameKana__c)
                    && String.isNotBlank(seihoLeadRecord.FirstNameKana__c)){
                    //氏名のキー情報作成
                    nameInfo = seihoLeadRecord.LastName__c + seihoLeadRecord.FirstName__c + seihoLeadRecord.LastNameKana__c + seihoLeadRecord.FirstNameKana__c;
                    nameInfo = nameInfo.deleteWhitespace();
                    List<Account> accList = existNameInfoAccountMap.get(nameInfo);
                    if(accList == null){
                        accList = new List<Account>();
                    }
                    accList.add(targetAccount);
                    existNameInfoAccountMap.put(nameInfo, accList);
                }
            }
            targetAccountMap.put(seihoLeadRecord.CatalogOrderId__c, targetAccount);
        }
        insert insertAccList;
        List<Id> accIdList = new List<Id>();
        for(Account acc : targetAccountMap.values()){
            accIdList.add(acc.Id);
        }
        // 商談
        // 案件の生保レコードタイプIDを取得
        Id oppSeihoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Seiho').getRecordTypeId();
        DateTime insertDate = datetime.now();
        //商談のクローズ日は翌月末日
        Date today = System.today();
        Date insertCloseDate = Date.newInstance(today.year(), today.month() + 2,0);
        String opportunityNameInsertStr = insertDate.format('yyyyMMdd') + '_' + '生保' + '_';
        // 取引先、商談関連用マップ ID:取引先ID
        Map<Id,Opportunity> accountOpportunityMap = new Map<Id,Opportunity>();
        // 新規商談Insert用リスト
        List<Opportunity> insertOpportunityList = new List<Opportunity>();
        // 既存商談を取得
        List<Opportunity> existOpportunityList = [SELECT Id, Name, AccountId
                                                  FROM Opportunity
                                                  WHERE AccountId IN :accIdList
                                                  AND RecordType.DeveloperName = 'Seiho'
                                                  AND StageName <> '対応終了'
                                                  ORDER BY LastModifiedDate DESC];
        // 取引先、商談関連用マップに入れる
        for(Opportunity opp : existOpportunityList){
            if (accountOpportunityMap.get(opp.AccountId) == NULL) {
                accountOpportunityMap.put(opp.AccountId, opp);
            }
        }
        // 対象取引先を繰り返す
        for(Account acc : targetAccountMap.values()){
            if(accountOpportunityMap.get(acc.Id) == NULL){
                // 商談がない場合、新規作成
                Opportunity targetOpp = new Opportunity();
                // 商談の設定
                targetOpp.RecordTypeId = oppSeihoRecordTypeId;
                // 商談名
                targetOpp.name = opportunityNameInsertStr;
                if(String.isNotBlank(acc.furiganaLast__pc)){
                    targetOpp.name  = targetOpp.name + acc.furiganaLast__pc;
                }
                if(String.isNotBlank(acc.furiganaForst__pc)){
                    targetOpp.name  = targetOpp.name + acc.furiganaForst__pc;
                }
                if(targetOpp.name.length()>80){
                    targetOpp.name = targetOpp.name.left(80);
                }
                // 商談ステータス
                targetOpp.StageName = '未割当';
                // 入電理由
                targetOpp.telReason__c = 'その他'; 
                // 申込日
                targetOpp.CloseDate = insertCloseDate;
                // 取引先Id
                targetOpp.AccountId = acc.Id;
                // リードソース
                targetOpp.InflowRoute__c = '資料請求';
                // キャンペーン日時 = 生保Web資料請求．システム日付
                targetOpp.CampaignDateTime__c = System.Now();
                
                insertOpportunityList.add(targetOpp);
                accountOpportunityMap.put(acc.Id, targetOpp);
            }
        }
        // 新規商談Insert
        insert insertOpportunityList;
        
        // 生保Web資料請求の商談項目更新 Opportunity__c
        for(SeihoLead__c seihoLeadRecord : seihoLeadList){
            seihoLeadRecord.Opportunity__c = accountOpportunityMap.get(targetAccountMap.get(seihoLeadRecord.CatalogOrderId__c).Id).Id;
            seihoLeadRecord.Ref_Account__c = targetAccountMap.get(seihoLeadRecord.CatalogOrderId__c).Id;
        }
    }
    
    /**
     * 生保Web資料請求作成後処理
     * @param List<SeihoLead__c>
     * @return 
     */
    public void onAfterInsertProcess(List<SeihoLead__c> seihoLeadList){
        Set<Id> seihoLeadIdSet = new Set<Id>();
        for(SeihoLead__c seihoLead : seihoLeadList){
            seihoLeadIdSet.add(seihoLead.Id);
        }
        createTargetCase(seihoLeadIdSet);
    }
    /**
     * 取引先作成/更新処理
     * @param Account 作成/更新対象取引先
     * @param SeihoLead__c 作成/更新元となる生保Web資料請求情報
     * @return 
     */
    private void createTargetAccount(Account target , SeihoLead__c seihoLeadRecord){
        // 姓名情報
        if(seihoLeadRecord.LastName__c <> Null){
            if(seihoLeadRecord.LastName__c.length() > 40){
                target.LastName = seihoLeadRecord.LastName__c.left(40);
                target.LastName__pc = seihoLeadRecord.LastName__c.left(40);
            }else{
                target.LastName = seihoLeadRecord.LastName__c;
                target.LastName__pc = seihoLeadRecord.LastName__c;
            }
        }else{
            target.LastName = '未登録';
            target.LastName__pc = '未登録';
        }
        if(seihoLeadRecord.FirstName__c <> Null){
            if(seihoLeadRecord.FirstName__c.length() > 40){
                target.FirstName = seihoLeadRecord.FirstName__c.left(40);
                target.firstname__pc = seihoLeadRecord.FirstName__c.left(40);
            }else{
                target.FirstName = seihoLeadRecord.FirstName__c;
                target.firstname__pc = seihoLeadRecord.FirstName__c;
            }
        }else{
            target.FirstName = '';
            target.firstname__pc = '';
        }
        target.furiganaLast__pc = seihoLeadRecord.LastNameKana__c;
        target.furiganaForst__pc = seihoLeadRecord.FirstNameKana__c;
        // 生年月日
        target.PersonBirthdate = seihoLeadRecord.Birthdate__c;
        // 性別
        target.Gender__pc = seihoLeadRecord.Gender__c;
        // 楽天会員ID
        target.easyId__pc = seihoLeadRecord.EasyId__c;
        // メール
        target.PersonEmail = seihoLeadRecord.Email__c;
        // 住所情報
        if(seihoLeadRecord.PostalCode__c != NULL && seihoLeadRecord.PostalCode__c.length() > 20){
            target.PersonMailingPostalCode = seihoLeadRecord.PostalCode__c.left(20);
        }else{
            target.PersonMailingPostalCode = seihoLeadRecord.PostalCode__c;
        }
        if(seihoLeadRecord.State__c != NULL && seihoLeadRecord.State__c.length() > 80){
            target.PersonMailingState = seihoLeadRecord.State__c.left(80);
        }else{
            target.PersonMailingState = seihoLeadRecord.State__c;
        }
        if(seihoLeadRecord.City__c != NULL && seihoLeadRecord.City__c.length() > 40){
            target.PersonMailingCity = seihoLeadRecord.City__c.left(40);
        }else{
            target.PersonMailingCity = seihoLeadRecord.City__c;
        }
        String streetStr = '';
        if(String.isNotBlank(seihoLeadRecord.Street__c)){
            streetStr = seihoLeadRecord.Street__c;
        }
        if(String.isNotBlank(seihoLeadRecord.Apart__c)){
            streetStr = streetStr + seihoLeadRecord.Apart__c;
        }
        if(streetStr != NULL && streetStr.length() > 255){
            target.PersonMailingStreet = streetStr.left(255);
        }else{
            target.PersonMailingStreet = streetStr;
        }
        // 連絡先情報
        target.Phone = seihoLeadRecord.Phone__c;
        target.PersonHomePhone = seihoLeadRecord.Phone__c;
        target.PersonMobilePhone = seihoLeadRecord.MobilePhone__c;
        // 顧客区分
        target.division__pc = '見込み顧客';
        //******20191223 修正　開始*******/
        target.OperationType__c = '割当可';
        target.OpportunityStatus__c = '未対応';
        //******20191223 修正　エンド*******/
        
        //資料発送機能は6/3リリース対象外↓↓↓↓↓
        ////    2ndDM発送日、3rdDM発送日のクリア処理
        ////    3rdDM発送日が空欄でない、かつ、今回の生保申込の更新日時が3rdDM発送日の1年以後の場合
        //if(target.DM3rdDate__c != NULL && seihoLeadRecord.CatalogOrderDate__c > target.DM3rdDate__c.addYears(1)){
        //    // 2ndDM発送日、3rdDM発送日をクリア
        //  target.DM2ndDate__c = NULL;
        //    target.DM3rdDate__c = NULL;
        //}
        ////    2ndDM発送日が空欄でない、かつ、今回の生保申込の更新日時が2ndDM発送日の1年以後の場合
        //else if(target.DM2ndDate__c != NULL && seihoLeadRecord.CatalogOrderDate__c > target.DM2ndDate__c.addYears(1)){
        //    // 2ndDM発送日をクリア
        //  target.DM2ndDate__c = NULL;
        //}
        //資料発送機能は6/3リリース対象外↑↑↑↑↑
    }
    
    /**
     * ケース作成処理
     * @param List 作成元となる生保Web資料請求情報のID情報
     * @return 
     */
    @future
    public static void createTargetCase(Set<Id> seihoLeadIDs){
        List<Case> insertTargetCaseList = new List<Case>();
        // ケース（資料請求（生命））のレコードタイプID
        Id caseSeihoRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SeihoLead_Web').getRecordTypeId();
        // 少短Web資料請求情報
        List<SeihoLead__c> seihoLeadList = [SELECT ID,CatalogOrderId__c,PostalCode__c,PrefectureKana__c,CityKana__c,StreetKana__c
                                            ,CatalogOrderDate__c,InterestedProds01__c,InterestedProds02__c,InterestedProds03__c
                                            ,InterestedProds04__c,InterestedProds05__c,InterestedProds06__c,InterestedProds07__c
                                            ,InterestedProds08__c,InterestedProds09__c,InterestedProds10__c,InterestedProds11__c
                                            ,InterestedProds12__c,InterestedProds99__c,AgentCd__c,AgentName__c,RecruiterNo__c
                                            ,RecruiterName__c,Ref_Account__c 
                                            FROM SeihoLead__c
                                            WHERE ID IN :seihoLeadIDs];
        Set<Id> accIdSet = new Set<Id>();
        for(SeihoLead__c seihoLead : seihoLeadList){
            accIdSet.add(seihoLead.Ref_Account__c);
        }
        Map<Id,Account> accMap = new Map<Id,Account>([SELECT ID,personContactId FROM ACCOUNT WHERE ID IN :accIdSet]);
        for(SeihoLead__c seihoLeadRecord : seihoLeadList){
            //ケースの新規作成
            Case targetCase = new Case();
            targetCase.recordTypeId = caseSeihoRecordTypeId;
            targetCase.AccountId = seihoLeadRecord.Ref_Account__c;
            targetCase.ContactId = accMap.get(seihoLeadRecord.Ref_Account__c).personContactId;
            //対応区分
            targetCase.class__c = 'セールス専用ケース';
            //対応種別
            targetCase.type__c = '生命_資料請求';
            // 発生源
            targetCase.Origin = 'Web';
            // 状況
            targetCase.Status = 'オープン';
            // 資料請求ID
            if(seihoLeadRecord.CatalogOrderId__c <> Null){
                targetCase.DataRequestID__c = seihoLeadRecord.CatalogOrderId__c.format();
            }
            // 郵便番号
            //20190821 誤って変更後郵便番号に設定しているためコメントアウト START
            //if(seihoLeadRecord.PostalCode__c <> Null){
            //    targetCase.PostNumber__c = seihoLeadRecord.PostalCode__c.replace('-','');
            //}
            //20190821 誤って変更後郵便番号に設定しているためコメントアウト END
            // 住所（ﾌﾘｶﾞﾅ）
            targetCase.AddressKana__c = '';
            if(String.isNotBlank(seihoLeadRecord.PrefectureKana__c)){
                targetCase.AddressKana__c = seihoLeadRecord.PrefectureKana__c;
            }
            if(String.isNotBlank(seihoLeadRecord.CityKana__c)){
                targetCase.AddressKana__c = targetCase.AddressKana__c + seihoLeadRecord.CityKana__c;
            }
            if(String.isNotBlank(seihoLeadRecord.StreetKana__c)){
                targetCase.AddressKana__c = targetCase.AddressKana__c + seihoLeadRecord.StreetKana__c;
            }
            // 資料請求日時
            targetCase.DocumentRequestDateTime__c = seihoLeadRecord.CatalogOrderDate__c;
            // 興味がある商品1～12のチェックボックス
            // 申込番号のテキストは未設定
            targetCase.RakutenLifeplusSuper2000__c = seihoLeadRecord.InterestedProds01__c;
            targetCase.RakutenLifeLove__c = seihoLeadRecord.InterestedProds02__c;
            targetCase.RakutenLifeSmart2__c = seihoLeadRecord.InterestedProds03__c;
            targetCase.RakutenLifeplusWomenSupport__c = seihoLeadRecord.InterestedProds04__c;
            targetCase.RakutenLifepluscancerSupport__c = seihoLeadRecord.InterestedProds05__c;
            targetCase.RakutenLifeplusHospitalizationSupport__c = seihoLeadRecord.InterestedProds06__c;
            targetCase.RakutenLifeLong__c = seihoLeadRecord.InterestedProds07__c;
            targetCase.RakutenLifeToRelyOn__c = seihoLeadRecord.InterestedProds08__c;
            targetCase.RakutenLifeplusSuper__c = seihoLeadRecord.InterestedProds09__c;
            targetCase.RakutenLifeplusToRelyOn__c = seihoLeadRecord.InterestedProds10__c;
            targetCase.RakutenLifeplusCancerInsurance__c = seihoLeadRecord.InterestedProds11__c;
            targetCase.RakutenLifeplusTermInsurance__c = seihoLeadRecord.InterestedProds12__c;
            targetCase.GeneralBrochure__c = seihoLeadRecord.InterestedProds99__c;
            // 代理店コード
            targetCase.AgentCode__c = seihoLeadRecord.AgentCd__c;
            // 取扱代理店名
            targetCase.DealerName__c = seihoLeadRecord.AgentName__c;
            // 募集人番号
            targetCase.RecruiterNumber__c = seihoLeadRecord.RecruiterNo__c;
            // 募集人名
            targetCase.RecruiterName__c = seihoLeadRecord.RecruiterName__c;
            insert insertTargetCaseList;
        }
    }
}