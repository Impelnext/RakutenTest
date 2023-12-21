/*
* @Class Name      : GeneralWebApplicationTriggerHandler 
* @Description     : 損保Web申込途中保存情報トリガーハンドラ
* @Created Date    : 2019.04.19
* @Created By      : 
* @Modified Date   : 2019.12.20
* @Modified        : Valsala Kumar
*/
public class GeneralWebApplicationTriggerHandler {

    /**
     * コンストラクタ
     */
    public GeneralWebApplicationTriggerHandler() {}
  
    /**
     * 損保資料請求作成・更新前処理
     * @param List<GeneralWebApplication__c>
     * @return 
     */
    public void onBeforeProcess(List<GeneralWebApplication__c> generalWebApplicationList){
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
        for(GeneralWebApplication__c generalWebApplicationRecord : generalWebApplicationList){
            //手作成の場合、取引先が設定されている場合
            if(generalWebApplicationRecord.Ref_Account__c != null){
               refAccIdList.add(generalWebApplicationRecord.Ref_Account__c);
            }
            else{
                //20190808 修正開始 EasyIDに基づいての検索を外す
                // 楽天IDがある場合
                /*if(String.isNotBlank(generalWebApplicationRecord.easy_id__c)){
                    easyIdList.add(generalWebApplicationRecord.easy_id__c);
                }*/
                //20190808 修正終了 EasyIDに基づいての検索を外す
                // 姓名情報に空欄がない場合
                if(String.isNotBlank(generalWebApplicationRecord.name_keiyaku__c) && String.isNotBlank(generalWebApplicationRecord.name_keiyaku_k__c)){
                    String tmpName = generalWebApplicationRecord.name_keiyaku__c + generalWebApplicationRecord.name_keiyaku_k__c;
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
        // 損保資料請求情報全件繰り返し
        for(GeneralWebApplication__c generalWebApplicationRecord : generalWebApplicationList){
            Account targetAccount;
            String nameInfo = '';
            // 手作成の場合、取引先が設定されている場合、名寄せ処理しない
            if(generalWebApplicationRecord.Ref_Account__c != null){
                targetAccount = existRefAccountMap.get(generalWebApplicationRecord.Ref_Account__c);
            }
            //20190808 修正開始 EasyIDに基づいての検索を外す
            // 楽天IDがある場合
            /*else if(String.isNotBlank(generalWebApplicationRecord.easy_id__c)){
                targetAccount = existEasyIdAccountMap.get(generalWebApplicationRecord.easy_id__c);
            }*/
            //20190808 修正終了 EasyIDに基づいての検索を外す
            // 楽天IDで見つからなかった場合
            if(targetAccount == NULL){
                // 姓名情報に空欄がない場合
                if(String.isNotBlank(generalWebApplicationRecord.name_keiyaku__c) && String.isNotBlank(generalWebApplicationRecord.name_keiyaku_k__c)){
                    nameInfo = generalWebApplicationRecord.name_keiyaku__c + generalWebApplicationRecord.name_keiyaku_k__c;
                    nameInfo = nameInfo.deleteWhitespace();
                    // 姓名情報が一致するレコードを繰り返す
                    List<Account> accList = existNameInfoAccountMap.get(nameInfo);
                    if(accList <> NULL){
                        for(Account acc : existNameInfoAccountMap.get(nameInfo)){
                            // 固定電話番号か携帯電話番号のいずれか一致する
                            String phone1 = '';
                            if(String.isNotBlank(generalWebApplicationRecord.tel_keiyaku_area__c)){
                                phone1 = phone1 + generalWebApplicationRecord.tel_keiyaku_area__c;
                            }
                            if(String.isNotBlank(generalWebApplicationRecord.tel_keiyaku_city__c)){
                                phone1 = phone1 + generalWebApplicationRecord.tel_keiyaku_city__c;
                            }
                            if(String.isNotBlank(generalWebApplicationRecord.tel_keiyaku_number__c)){
                                phone1 = phone1 + generalWebApplicationRecord.tel_keiyaku_number__c;
                            }
                            String phone2 = '';
                            if(String.isNotBlank(generalWebApplicationRecord.tel_keiyaku2_area__c)){
                                phone2 = phone2 + generalWebApplicationRecord.tel_keiyaku2_area__c;
                            }
                            if(String.isNotBlank(generalWebApplicationRecord.tel_keiyaku2_city__c)){
                                phone2 = phone2 + generalWebApplicationRecord.tel_keiyaku2_city__c;
                            }
                            if(String.isNotBlank(generalWebApplicationRecord.tel_keiyaku2_number__c)){
                                phone2 = phone2 + generalWebApplicationRecord.tel_keiyaku2_number__c;
                            }
                            if((phone1 <> NULL && ((acc.PersonHomePhone <> NULL && phone1.replace('-','').equals(acc.PersonHomePhone.replace('-','')))
                                             ||(acc.PersonMobilePhone<> NULL && phone1.replace('-','').equals(acc.PersonMobilePhone.replace('-','')))))
                            || (phone2 <> NULL && ((acc.PersonHomePhone <> NULL && phone2.replace('-','').equals(acc.PersonHomePhone.replace('-','')))
                                             ||(acc.PersonMobilePhone<> NULL && phone2.replace('-','').equals(acc.PersonMobilePhone.replace('-','')))))){
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
                createTargetAccount(targetAccount, generalWebApplicationRecord);
                insertAccList.add(targetAccount);
                if(String.isNotBlank(generalWebApplicationRecord.name_keiyaku__c) && String.isNotBlank(generalWebApplicationRecord.name_keiyaku_k__c)){
                    nameInfo = generalWebApplicationRecord.name_keiyaku__c + generalWebApplicationRecord.name_keiyaku_k__c;
                    nameInfo = nameInfo.deleteWhitespace();
                    List<Account> accList = existNameInfoAccountMap.get(nameInfo);
                    if(accList == null){
                        accList = new List<Account>();
                    }
                    accList.add(targetAccount);
                    existNameInfoAccountMap.put(nameInfo, accList);
                }
            }
            targetAccountMap.put(generalWebApplicationRecord.ForeignKey_GeneralWebApplication__c, targetAccount);
        }
        insert insertAccList;
        List<Id> accIdList = new List<Id>();
        for(Account acc : targetAccountMap.values()){
            accIdList.add(acc.Id);
        }
        Map<Id, Account> accPersonContactIdMap = new Map<Id, Account>([SELECT Id, personContactId FROM Account WHERE Id IN :accIdList]);
        
        // 商談
        // 案件の生保レコードタイプIDを取得
        Id oppSonpoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();
        //商談のクローズ日は翌月末日
        DateTime insertDate = datetime.now();
        Date today = System.today();
        Date insertCloseDate = Date.newInstance(today.year(), today.month() + 2,0);
        String opportunityNameInsertStr = insertDate.format('yyyyMMdd') + '_' + '損保' + '_';
        // 損保資料請求、商談関連用マップ Key:損保資料請求ID
        //Map<String,Opportunity> generalWebOpportunityMap = new Map<String,Opportunity>();
        // 取引先、商談関連用マップ ID:取引先ID
        Map<Id,Opportunity> generalWebOpportunityMap = new Map<Id,Opportunity>();
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
            if (generalWebOpportunityMap.get(opp.AccountId) == NULL) {
                generalWebOpportunityMap.put(opp.AccountId, opp);
            }
        }
        // 損保資料請求情報全件繰り返し
        for(GeneralWebApplication__c generalWebApplicationRecord : generalWebApplicationList){
            Account tmpAcc = targetAccountMap.get(generalWebApplicationRecord.ForeignKey_GeneralWebApplication__c);
            
            if(generalWebOpportunityMap.get(tmpAcc.Id) == NULL){
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
                targetOpp.InflowRoute__c = '申込途中保存';
                // キャンペーン日時 = 損保Web申込途中保存．システム日付
                targetOpp.CampaignDateTime__c = System.Now();
                
                insertOpportunityList.add(targetOpp);
                //generalWebOpportunityMap.put(generalWebApplicationRecord.ForeignKey_GeneralWebApplication__c, targetOpp);
                generalWebOpportunityMap.put(tmpAcc.Id, targetOpp);
            }
        }
        // 新規商談Insert
        insert insertOpportunityList;
        
        // 損保資料請求の項目更新
        for(GeneralWebApplication__c generalWebApplicationRecord : generalWebApplicationList){
            //generalWebApplicationRecord.Opportunity__c = generalWebOpportunityMap.get(generalWebApplicationRecord.ForeignKey_GeneralWebApplication__c).Id;
            generalWebApplicationRecord.Opportunity__c = generalWebOpportunityMap.get(targetAccountMap.get(generalWebApplicationRecord.ForeignKey_GeneralWebApplication__c).Id).Id;
            generalWebApplicationRecord.Ref_Account__c = targetAccountMap.get(generalWebApplicationRecord.ForeignKey_GeneralWebApplication__c).Id;
        }
    }
    
    /**
     * 取引先作成/更新処理
     * @param Account 作成/更新対象取引先
     * @param GeneralWebApplication__c 作成/更新元となる損保資料請求情報
     * @return 
     */
    private void createTargetAccount(Account target , GeneralWebApplication__c generalWebApplicationRecord){
        // 姓名情報
        if(generalWebApplicationRecord.name_keiyaku__c <> Null){
            target.LastName = generalWebApplicationRecord.name_keiyaku__c.left(40);
            target.LastName__pc = generalWebApplicationRecord.name_keiyaku__c.left(40);
        }else{
            target.LastName = '未登録';
            target.LastName__pc = '未登録';
        }
        target.furiganaLast__pc = generalWebApplicationRecord.name_keiyaku_k__c;
        target.Gender__pc = generalWebApplicationRecord.seibetsu_keiyaku__c;
        // 楽天会員ID
        target.easyId__pc = generalWebApplicationRecord.easy_id__c;
        target.openId__pc = generalWebApplicationRecord.open_id__c;
        // メール
        target.PersonEmail = generalWebApplicationRecord.mail_keiyaku__c;
        // 住所情報
        if(generalWebApplicationRecord.yubin_keiyaku__c != NULL && generalWebApplicationRecord.yubin_keiyaku__c.length() > 20){
            target.PersonMailingPostalCode = generalWebApplicationRecord.yubin_keiyaku__c.left(20);
        }else{
            target.PersonMailingPostalCode = generalWebApplicationRecord.yubin_keiyaku__c;
        }
        if(generalWebApplicationRecord.jusho_keiyaku__c != NULL && generalWebApplicationRecord.jusho_keiyaku__c.length() > 255){
            target.PersonMailingStreet = generalWebApplicationRecord.jusho_keiyaku__c.left(255);
        }else{
            target.PersonMailingStreet = generalWebApplicationRecord.jusho_keiyaku__c;
        }
        // 連絡先情報
        String phone1 = '';
        if(String.isNotBlank(generalWebApplicationRecord.tel_keiyaku_area__c)){
            phone1 = phone1 + generalWebApplicationRecord.tel_keiyaku_area__c;
        }
        if(String.isNotBlank(generalWebApplicationRecord.tel_keiyaku_city__c)){
            phone1 = phone1 + generalWebApplicationRecord.tel_keiyaku_city__c;
        }
        if(String.isNotBlank(generalWebApplicationRecord.tel_keiyaku_number__c)){
            phone1 = phone1 + generalWebApplicationRecord.tel_keiyaku_number__c;
        }
        String phone2 = '';
        if(String.isNotBlank(generalWebApplicationRecord.tel_keiyaku2_area__c)){
            phone2 = phone2 + generalWebApplicationRecord.tel_keiyaku2_area__c;
        }
        if(String.isNotBlank(generalWebApplicationRecord.tel_keiyaku2_city__c)){
            phone2 = phone2 + generalWebApplicationRecord.tel_keiyaku2_city__c;
        }
        if(String.isNotBlank(generalWebApplicationRecord.tel_keiyaku2_number__c)){
            phone2 = phone2 + generalWebApplicationRecord.tel_keiyaku2_number__c;
        }
        
        target.Phone = phone1;
        target.PersonHomePhone = phone1;
        target.PersonMobilePhone = phone2;
        // 顧客区分
        target.division__pc = '見込み顧客';
        //******20191223 修正　開始*******/
        target.OperationType__c = '割当可';
        target.OpportunityStatus__c = '未対応';
        //******20191223 修正　エンド*******/
    }
}