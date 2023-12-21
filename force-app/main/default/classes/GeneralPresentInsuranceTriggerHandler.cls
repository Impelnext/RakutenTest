/*
* @Class Name      : GeneralPresentInsuranceTriggerHandler 
* @Description     : 損保プレゼント保険トリガーハンドラ
* @Created Date    : 2020.05.08
* @Created By      : Valsala Kumar
* @Modified Date   : 2023.09.13
* @Modified        : Takumi Nagaya
*/
public class GeneralPresentInsuranceTriggerHandler {

    public static final String PRODUCT_NAME_MYCAR_PRESENT_INS = 'マイカー割プレゼント保険';
    public static final String PRODUCT_NAME_WORK_OUT_INS = 'ワークアウト保険';
    public static final String PRODUCT_NAME_MAMA_FREE_INS = '子育てあんしんミニ保険';

    /**
     * コンストラクタ
     */
    public GeneralPresentInsuranceTriggerHandler() {}
    
    
    /**
     * 損保プレゼント保険作成前処理
     * @param List<GeneralPresentInsurance__c>
     * @return 
     */
    public void onBeforeInsertProcess(List<GeneralPresentInsurance__c> generalPresentInsList){
        //作成情報格納用List Key:損保プレゼント保険ID
        // 既存取引先を取得
        // 取引先作成
        List<Account> targetAccountList = updateAccounts(generalPresentInsList, NULL);
        List<Id> accIdList = new List<Id>();
        for(Account acc : targetAccountList){
            accIdList.add(acc.Id);
        }
        
        // 商談
        // 案件の汎用レコードタイプIDを取得
        Id oppHanyoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hanyo').getRecordTypeId();
        DateTime insertDate = datetime.now();
        //商談のクローズ日は1年後末日
        Date today = System.today();
        Date insertCloseDate = Date.newInstance(today.year()+1, today.month()+1,0);
        String opportunityNameInsertStr = insertDate.format('yyyyMMdd') + '_' + '汎用' + '_';
        // 取引先、商談関連用マップ ID:取引先ID
        Map<Id,Opportunity> accountOpportunityMap = new Map<Id,Opportunity>();
        // 新規商談Insert用リスト
        List<Opportunity> insertOpportunityList = new List<Opportunity>();
        // 既存商談を取得
        List<Opportunity> existOpportunityList = [SELECT Id, Name, AccountId
                                                  FROM Opportunity
                                                  WHERE AccountId IN :accIdList
                                                  AND RecordType.DeveloperName = 'Hanyo'
                                                  AND StageName <> '対応終了'
                                                  ORDER BY LastModifiedDate DESC];
        // 取引先、商談関連用マップに入れる
        for(Opportunity opp : existOpportunityList){
            if (accountOpportunityMap.get(opp.AccountId) == NULL) {
                accountOpportunityMap.put(opp.AccountId, opp);
            }
        }
        Integer idx = 0;
        // 対象取引先を繰り返す
        for(GeneralPresentInsurance__c generalPresentIns : generalPresentInsList){
            Account acc = targetAccountList[idx];
            if(accountOpportunityMap.get(acc.Id) == NULL){
                // 商談がない場合、新規作成
                Opportunity targetOpp = new Opportunity();
                // 商談の設定
                targetOpp.RecordTypeId = oppHanyoRecordTypeId;
                // 商談名
                String targetOppname = opportunityNameInsertStr;
                if(String.isNotBlank(acc.furiganaLast__pc)){
                    targetOppname = targetOppname + acc.furiganaLast__pc;
                }
                if(String.isNotBlank(acc.furiganaForst__pc)){
                    targetOppname = targetOppname + acc.furiganaForst__pc;
                }
                if(targetOppname.length()>80){
                    targetOpp.name = targetOppname.left(80);
                }else{
                    targetOpp.name = targetOppname;
                }
                // 商談ステータス
                targetOpp.StageName = '未割当';
                // 入電理由
                targetOpp.telReason__c = 'その他'; 
                // クローズ日
                targetOpp.CloseDate = insertCloseDate;
                // 取引先Id
                targetOpp.AccountId = acc.Id;
                // リードソース
                targetOpp.InflowRoute__c = '損保プレゼント保険';
                // キャンペーン日時 = 損保プレゼント保険．システム日付
                targetOpp.CampaignDateTime__c = System.Now();
                
                //損保プレゼント保険の設定
                // inputGeneralPresentInsuranceAnket(targetOpp, generalPresentIns);
                
                insertOpportunityList.add(targetOpp);
                accountOpportunityMap.put(acc.Id, targetOpp);
            }
            idx++;
        }
        // 新規商談Insert
        insert insertOpportunityList;
        
        idx = 0;
        // 損保プレゼント保険の商談項目更新 Opportunity__c
        for(GeneralPresentInsurance__c generalPresentIns : generalPresentInsList){
            generalPresentIns.OpportunityId__c = accountOpportunityMap.get(targetAccountList[idx].Id).Id;
            generalPresentIns.AccountId__c = targetAccountList[idx].Id;
            // レコードタイプ
            if (PRODUCT_NAME_WORK_OUT_INS.equals(generalPresentIns.Name)) {
                generalPresentIns.RecordTypeId =
                    Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('WorkOutInsurance').getRecordTypeId();
            } else if (PRODUCT_NAME_MAMA_FREE_INS.equals(generalPresentIns.Name)) {
                generalPresentIns.RecordTypeId =
                    Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MamaFreeInsurance').getRecordTypeId();
            } else {
                generalPresentIns.RecordTypeId =
                    Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MyCarPresentInsurance').getRecordTypeId();
            }
            idx++;
        }
    }
    
    
    /**
     * 損保プレゼント保険After処理
     * @param List<GeneralPresentInsurance__c>
     * @return 
     */
    public void onAfterProcess(List<GeneralPresentInsurance__c> generalPresentInsList, Map<Id, GeneralPresentInsurance__c> oldMap){
        Map<Id, GeneralPresentInsurance__c> preOppMap = new Map<Id, GeneralPresentInsurance__c>();
        for( GeneralPresentInsurance__c generalPresentIns : generalPresentInsList ) {
            GeneralPresentInsurance__c oldGeneralPresentIns = oldMap != null ? oldMap.get(generalPresentIns.Id) : null;
            if(oldGeneralPresentIns == null 
            || isChangeMyCarPresentIns(generalPresentIns, oldGeneralPresentIns)
            || isChangeMobileFreeIns(generalPresentIns, oldGeneralPresentIns)
            || isChangeMamaFreeIns(generalPresentIns, oldGeneralPresentIns)) {
                preOppMap.put(generalPresentIns.OpportunityId__c, generalPresentIns);
            }
        }
        
        // Update Accounts for Update Trigger only
        // As Account is processed in Before Insert, 
        // After Insert process is not required for Account.
        if (oldMap != NULL)
            updateAccounts(generalPresentInsList, oldMap);
        
        // 商談更新
        List<Opportunity> opportunityList = [
                                                SELECT  
                                                        Id,
                                                        // MyCarPresentIns data
                                                        GeneralPresentUpdateDate__c,
                                                        GeneralPresentMydataShareAgree__c,
                                                        GeneralPresentMycarLinkageFlag__c,
                                                        GeneralPresentInsExpiryYearMonth1__c,
                                                        GeneralPresentInsExpiryDate1__c,
                                                        GeneralPresentEntryDate__c,
                                                        GeneralPresentIpMailMagaAgree__c,
                                                        GeneralPresentEntryNumber__c,
                                                        GeneralPresentEntryStatus__c,
                                                        GeneralPresentInsStartDate__c,
                                                        GeneralPresentInsEndDate__c,
                                                        GeneralPresentInsExpiredDate__c,
                                                        // WorkOutIns data
                                                        GeneralPresentUpdateDateForWOI__c,
                                                        GeneralPresentCrossPermissionForWOI__c,
                                                        GeneralPresentEntryNumberForWOI__c,
                                                        GeneralPresentEntryStatusForWOI__c,
                                                        GeneralPresentInsStartDateForWOI__c,
                                                        GeneralPresentInsEndDateForWOI__c,
                                                        GeneralPresentInsExpiredDateForWOI__c,
                                                        // MamaFreeIns data
                                                        GeneralPresentUpdateDateForMama__c,
                                                        GeneralPresentEntryDateForMama__c,
                                                        GeneralPresentEntryNumberForMama__c,
                                                        GeneralPresentEntryStatusForMama__c,
                                                        GeneralPresentIpMailMagaAgreeForMama__c,
                                                        GeneralPresentMydataShareAgreeForMama__c,
                                                        GeneralPresentInsStartDateForMama__c,
                                                        GeneralPresentInsEndDateForMama__c,
                                                        GeneralPresentCrossPermissionForMama__c
                                                   FROM Opportunity
                                                  WHERE Id =: preOppMap.keySet()
                                                    //AND GeneralPresentUpdateDate__c = NULL
                                                ];
        // 対象商談を繰り返す
        for(Opportunity opp : opportunityList){
            //損保プレゼント保険の設定
            inputGeneralPresentInsuranceAnket(opp, preOppMap.get(opp.Id));
        }
        update opportunityList;
    }

    private boolean isChangeMyCarPresentIns(GeneralPresentInsurance__c newModel, GeneralPresentInsurance__c oldModel) {

        boolean result = false;

        if (newModel.RecordTypeId ==
                Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MyCarPresentInsurance').getRecordTypeId()
                && (newModel.MydataShareAgree__c != oldModel.MydataShareAgree__c
                    || newModel.MycarLinkageFlag__c != oldModel.MycarLinkageFlag__c
                    || newModel.InsExpiryYearMonth1__c != oldModel.InsExpiryYearMonth1__c
                    || newModel.InsExpiryDate1__c != oldModel.InsExpiryDate1__c
                    || newModel.EntryDate__c != oldModel.EntryDate__c
                    || newModel.IpMailMagaAgree__c != oldModel.IpMailMagaAgree__c
                    || newModel.EntryNumber__c != oldModel.EntryNumber__c
                    || newModel.EntryStatus__c != oldModel.EntryStatus__c
                    || newModel.InsStartDate__c != oldModel.InsStartDate__c
                    || newModel.InsEndDate__c != oldModel.InsEndDate__c
                    || newModel.InsExpiredDate__c != oldModel.InsExpiredDate__c)) {
            result = true;
        }
        return result;
    }

    private boolean isChangeMobileFreeIns(GeneralPresentInsurance__c newModel, GeneralPresentInsurance__c oldModel) {

        boolean result = false;

        if (newModel.RecordTypeId ==
                Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('WorkOutInsurance').getRecordTypeId()
                && (newModel.EntryNumber__c != oldModel.EntryNumber__c
                    || newModel.EntryStatus__c != oldModel.EntryStatus__c
                    || newModel.InsStartDate__c != oldModel.InsStartDate__c
                    || newModel.InsEndDate__c != oldModel.InsEndDate__c
                    || newModel.InsExpiredDate__c != oldModel.InsExpiredDate__c
                    || newModel.CrossPermission__c != oldModel.CrossPermission__c)) {
            result = true;
        }
        return result;
    }

    private boolean isChangeMamaFreeIns(GeneralPresentInsurance__c newModel, GeneralPresentInsurance__c oldModel) {

        boolean result = false;

        if (newModel.RecordTypeId ==
                Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MamaFreeInsurance').getRecordTypeId()
                && (newModel.EntryDate__c != oldModel.EntryDate__c
                    || newModel.EntryNumber__c != oldModel.EntryNumber__c
                    || newModel.EntryStatus__c != oldModel.EntryStatus__c
                    || newModel.IpMailMagaAgree__c != oldModel.IpMailMagaAgree__c
                    || newModel.MydataShareAgree__c != oldModel.MydataShareAgree__c
                    || newModel.InsStartDate__c != oldModel.InsStartDate__c
                    || newModel.InsEndDate__c != oldModel.InsEndDate__c
                    || newModel.CrossPermission__c != oldModel.CrossPermission__c)) {
            result = true;
        }
        return result;
    }

    /**
     * 取引先作成/更新処理
     * @param Account 作成/更新対象取引先
     * @param GeneralPresentInsurance__c 作成/更新元となる損保プレゼント保険情報
     * @return 
     */
    private List<Account> updateAccounts(List<GeneralPresentInsurance__c> generalPresentInsList, Map<Id, GeneralPresentInsurance__c> oldMap){
        
        List<AccountInfo> accountInfos = new List<AccountInfo>();
        // 損保プレゼント保険を繰り返し
        for(GeneralPresentInsurance__c generalPresentIns : generalPresentInsList){
            AccountInfo accInfo = getAccountInfo(generalPresentIns);
            GeneralPresentInsurance__c oldGeneralPresentIns = oldMap != null ? oldMap.get(generalPresentIns.Id) : null;
            if(oldGeneralPresentIns == null 
            || generalPresentIns.Birthday__c != oldGeneralPresentIns.Birthday__c
            || generalPresentIns.Gender__c != oldGeneralPresentIns.Gender__c
            || generalPresentIns.easyId__c != oldGeneralPresentIns.easyId__c
            || generalPresentIns.Email__c != oldGeneralPresentIns.Email__c
            || generalPresentIns.Phone__c != oldGeneralPresentIns.Phone__c
            || generalPresentIns.MobilePhone__c != oldGeneralPresentIns.MobilePhone__c
            || generalPresentIns.LastName__c != oldGeneralPresentIns.LastName__c
            || generalPresentIns.FirstName__c != oldGeneralPresentIns.FirstName__c
            || generalPresentIns.LastNameFurigana__c != oldGeneralPresentIns.LastNameFurigana__c
            || generalPresentIns.FirstNameFurigana__c != oldGeneralPresentIns.FirstNameFurigana__c
            || generalPresentIns.PostCode__c != oldGeneralPresentIns.PostCode__c
            || generalPresentIns.Prefecture__c != oldGeneralPresentIns.Prefecture__c
            || generalPresentIns.City__c != oldGeneralPresentIns.City__c
            || generalPresentIns.TownName__c != oldGeneralPresentIns.TownName__c) {
                // If New or Existing Account, then is Account to be Updated
                accInfo.toUpdate = true;
            }
            // Get Existing Accounts OR Create New Account.
            accountInfos.add(accInfo);
        }
        
        // 既存の取引先を取得
        // 既存の取引先がない場合作成
        CommonUtility util = new CommonUtility();
        //作成情報格納用List Key:損保プレゼント保険ID
        List<Account> targetAccountList = util.getAccounts(accountInfos);
        return targetAccountList;
    }
    
    
    private void inputGeneralPresentInsuranceAnket( Opportunity targetOpp , GeneralPresentInsurance__c generalPresentIns ) {
        if (generalPresentIns.RecordTypeId ==
                Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MyCarPresentInsurance').getRecordTypeId()) {

            targetOpp.GeneralPresentUpdateDate__c = System.Now();
            targetOpp.GeneralPresentMydataShareAgree__c = generalPresentIns.MydataShareAgree__c;
            targetOpp.GeneralPresentMycarLinkageFlag__c = generalPresentIns.MycarLinkageFlag__c;
            targetOpp.GeneralPresentInsExpiryYearMonth1__c = generalPresentIns.InsExpiryYearMonth1__c;
            targetOpp.GeneralPresentInsExpiryDate1__c = generalPresentIns.InsExpiryDate1__c;
            targetOpp.GeneralPresentEntryDate__c = generalPresentIns.EntryDate__c;
            targetOpp.GeneralPresentIpMailMagaAgree__c = generalPresentIns.IpMailMagaAgree__c;
            targetOpp.GeneralPresentEntryNumber__c = generalPresentIns.EntryNumber__c;
            targetOpp.GeneralPresentEntryStatus__c = generalPresentIns.EntryStatus__c;
            targetOpp.GeneralPresentInsStartDate__c = generalPresentIns.InsStartDate__c;
            targetOpp.GeneralPresentInsEndDate__c = generalPresentIns.InsEndDate__c;
            targetOpp.GeneralPresentInsExpiredDate__c = generalPresentIns.InsExpiredDate__c;

        } else if (generalPresentIns.RecordTypeId ==
                    Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('WorkOutInsurance').getRecordTypeId()) {

            targetOpp.GeneralPresentUpdateDateForWOI__c = System.Now();
            targetOpp.GeneralPresentCrossPermissionForWOI__c = generalPresentIns.CrossPermission__c;
            targetOpp.GeneralPresentEntryNumberForWOI__c = generalPresentIns.EntryNumber__c;
            targetOpp.GeneralPresentEntryStatusForWOI__c = generalPresentIns.EntryStatus__c;
            targetOpp.GeneralPresentInsStartDateForWOI__c = generalPresentIns.InsStartDate__c;
            targetOpp.GeneralPresentInsEndDateForWOI__c = generalPresentIns.InsEndDate__c;
            targetOpp.GeneralPresentInsExpiredDateForWOI__c = generalPresentIns.InsExpiredDate__c;

        } else if (generalPresentIns.RecordTypeId ==
                    Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MamaFreeInsurance').getRecordTypeId()) {

            targetOpp.GeneralPresentUpdateDateForMama__c = System.Now();
            targetOpp.GeneralPresentEntryDateForMama__c = generalPresentIns.EntryDate__c;
            targetOpp.GeneralPresentEntryNumberForMama__c = generalPresentIns.EntryNumber__c;
            targetOpp.GeneralPresentEntryStatusForMama__c = generalPresentIns.EntryStatus__c;
            targetOpp.GeneralPresentIpMailMagaAgreeForMama__c = generalPresentIns.IpMailMagaAgree__c;
            targetOpp.GeneralPresentMydataShareAgreeForMama__c = generalPresentIns.MydataShareAgree__c;
            targetOpp.GeneralPresentInsStartDateForMama__c = generalPresentIns.InsStartDate__c;
            targetOpp.GeneralPresentInsEndDateForMama__c = generalPresentIns.InsEndDate__c;
            targetOpp.GeneralPresentCrossPermissionForMama__c = generalPresentIns.CrossPermission__c;

        }
    }
    
    private AccountInfo getAccountInfo(GeneralPresentInsurance__c generalPresentIns) {
        AccountInfo src = new AccountInfo();
        // ID
        src.accountid = generalPresentIns.AccountId__c;
        // 姓名情報
        src.lastname = generalPresentIns.LastName__c;
        src.firstname = generalPresentIns.FirstName__c;
        src.lastnamekana = generalPresentIns.LastNameFurigana__c;
        src.firstnamekana = generalPresentIns.FirstNameFurigana__c;
        // 姓名情報に空欄がない場合
        if (String.isNotBlank(generalPresentIns.LastName__c)
            && String.isNotBlank(generalPresentIns.FirstName__c) 
            && String.isNotBlank(generalPresentIns.LastNameFurigana__c)
            && String.isNotBlank(generalPresentIns.FirstNameFurigana__c)){
            //氏名のキー情報作成
            src.nameinfo = generalPresentIns.LastName__c + generalPresentIns.FirstName__c 
                        + generalPresentIns.LastNameFurigana__c + generalPresentIns.FirstNameFurigana__c;
            src.nameinfo = src.nameinfo.deleteWhitespace();
        }
        // 楽天会員ID
        src.easyid = generalPresentIns.easyId__c;
        // 連絡先情報
        src.homephone = generalPresentIns.Phone__c;
        src.mobilephone = generalPresentIns.MobilePhone__c;
        // 生年月日
        src.birthdate = generalPresentIns.Birthday__c;
        // 性別
        src.gender = generalPresentIns.Gender__c;
        // メール
        src.email = generalPresentIns.Email__c;
        // 住所情報
        src.postalcode = generalPresentIns.PostCode__c;
        src.state = generalPresentIns.Prefecture__c;
        src.city = generalPresentIns.City__c;
        src.street = generalPresentIns.TownName__c;
        
        // Other Info
        Map<String, String> params = new Map<String, String>();
        src.params = params;
        
        return src;
    }
}