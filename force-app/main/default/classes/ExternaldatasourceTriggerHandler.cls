/*
* @Class Name      : ExternaldatasourceTriggerHandler 
* @Description     : 外部データソーストリガーハンドラ
* @Created Date    : 2019.12.19
* @Created By      : Valsala Kumar
* @Modified Date   : 
* @Modified        : 
*/
public class ExternaldatasourceTriggerHandler {

    /**
     * コンストラクタ
     */
    public ExternaldatasourceTriggerHandler() {}
    
    /**
     * 外部データソース作成前処理
     * @param List<Externaldatasource__c>
     * @return 
     */
    public void onBeforeInsertProcess(List<Externaldatasource__c> extDataSrcList){
        //作成情報格納用マップ Key:外部データソース申込ID
        List<Account> targetAccountList = new List<Account>();
        
        // 取引先の作成または更新
        Id accountPersonRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        
        // 取引先IDセット
        Set<String> refAccIdList = new Set<String>();
        // 姓名情報セット
        Set<String> nameInfoList = new Set<String>();
        // 生保Web資料請求を繰り返し
        for(Externaldatasource__c extDataSrc : extDataSrcList){
            //手作成の場合、取引先が設定されている場合
            if(extDataSrc.AccountId__c != null){
               refAccIdList.add(extDataSrc.AccountId__c);
            }
            else{
                // 姓名情報に空欄がない場合
                if(   String.isNotBlank(extDataSrc.LastName__c)
                        && String.isNotBlank(extDataSrc.FirstName__c)
                        && String.isNotBlank(extDataSrc.LastNameFurigana__c)
                        && String.isNotBlank(extDataSrc.FirstNameFurigana__c)){
                    //氏名のキー情報を作成
                    String tmpName = extDataSrc.LastName__c + extDataSrc.FirstName__c + extDataSrc.LastNameFurigana__c + extDataSrc.FirstNameFurigana__c;
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
        List<Account> updateAccList = new List<Account>();
        
        // 生保Web資料請求情報全件繰り返し
        for(Externaldatasource__c extDataSrc : extDataSrcList){
            Account targetAccount;
            String nameInfo = '';
            // 手作成の場合、取引先が設定されている場合、名寄せ処理しない
            if(extDataSrc.AccountId__c != null){
                targetAccount = existRefAccountMap.get(extDataSrc.AccountId__c);
            }
            // 取引先が設定されている場合
            if(targetAccount == NULL){
                // 姓名情報に空欄がない場合
                if(   String.isNotBlank(extDataSrc.LastName__c)
                        && String.isNotBlank(extDataSrc.FirstName__c) 
                        && String.isNotBlank(extDataSrc.LastNameFurigana__c)
                        && String.isNotBlank(extDataSrc.FirstNameFurigana__c)){
                    //氏名のキー情報作成
                    nameInfo = extDataSrc.LastName__c + extDataSrc.FirstName__c + extDataSrc.LastNameFurigana__c + extDataSrc.FirstNameFurigana__c;
                    nameInfo = nameInfo.deleteWhitespace();
                    // 姓名情報が一致するレコードを繰り返す
                    List<Account> accList = existNameInfoAccountMap.get(nameInfo);
                    if(accList <> NULL){
                        for(Account acc : existNameInfoAccountMap.get(nameInfo)){
                            // 固定電話番号か携帯電話番号のいずれか一致する
                            if((acc.PersonHomePhone<>NULL && ((extDataSrc.HomePhone__c<>NULL && extDataSrc.HomePhone__c.replace('-','').equals(acc.PersonHomePhone.replace('-',''))) 
                                                            || (extDataSrc.MobilePhone__c<>NULL && extDataSrc.MobilePhone__c.replace('-','').equals(acc.PersonHomePhone.replace('-','')))))
                              || (acc.PersonMobilePhone<>NULL && ((extDataSrc.HomePhone__c<>NULL && extDataSrc.HomePhone__c.replace('-','').equals(acc.PersonMobilePhone.replace('-',''))) 
                                                              || (extDataSrc.MobilePhone__c<>NULL && extDataSrc.MobilePhone__c.replace('-','').equals(acc.PersonMobilePhone.replace('-','')))))){
                                
                                // 外部データソースに関連する取引先の更新
                                targetAccount = acc;
                                break;
                            }
                            // 生年月日かつ性別が一致する
                            else if(   extDataSrc.Birthday__c == acc.PersonBirthdate
                                    && (extDataSrc.Gender__c <> Null && extDataSrc.Gender__c.equals(acc.Gender__pc))){
                                // 外部データソースに関連する取引先の更新
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
                createTargetAccount(targetAccount, extDataSrc);
                insertAccList.add(targetAccount);
                if(   String.isNotBlank(extDataSrc.LastName__c)
                    && String.isNotBlank(extDataSrc.FirstName__c) 
                    && String.isNotBlank(extDataSrc.LastNameFurigana__c)
                    && String.isNotBlank(extDataSrc.FirstNameFurigana__c)){
                    //氏名のキー情報作成
                    nameInfo = extDataSrc.LastName__c + extDataSrc.FirstName__c + extDataSrc.LastNameFurigana__c + extDataSrc.FirstNameFurigana__c;
                    nameInfo = nameInfo.deleteWhitespace();
                    List<Account> accList = existNameInfoAccountMap.get(nameInfo);
                    if(accList == null){
                        accList = new List<Account>();
                    }
                    accList.add(targetAccount);
                    existNameInfoAccountMap.put(nameInfo, accList);
                }
            }
            targetAccountList.add(targetAccount);
        }
        insert insertAccList;
        update updateAccList;
        List<Id> accIdList = new List<Id>();
        for(Account acc : targetAccountList){
            accIdList.add(acc.Id);
        }
        
        // 商談
        // 案件の汎用レコードタイプIDを取得
        Id oppHanyoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hanyo').getRecordTypeId();
        DateTime insertDate = datetime.now();
        //商談のクローズ日は翌月末日
        Date today = System.today();
        Date insertCloseDate = Date.newInstance(today.year(), today.month() + 2,0);
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
        for(Externaldatasource__c extDataSrc : extDataSrcList){
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
                // 申込日
                targetOpp.CloseDate = insertCloseDate;
                // 取引先Id
                targetOpp.AccountId = acc.Id;
                // リードソース
                targetOpp.InflowRoute__c = '外部データソース';
                // キャンペーン日時 = 外部データソース．システム日付
                targetOpp.CampaignDateTime__c = System.Now();
                
                //外部データソースの設定
                inputExternalDataSourceAnket(targetOpp, extDataSrc);
                
                insertOpportunityList.add(targetOpp);
                accountOpportunityMap.put(acc.Id, targetOpp);
            }
            idx++;
        }
        // 新規商談Insert
        insert insertOpportunityList;
        
        idx = 0;
        // 生保Web資料請求の商談項目更新 Opportunity__c
        for(Externaldatasource__c extDataSrc : extDataSrcList){
            extDataSrc.OpportunityId__c = accountOpportunityMap.get(targetAccountList[idx].Id).Id;
            extDataSrc.AccountId__c = targetAccountList[idx].Id;
            idx++;
        }
    }
    
    
    /**
     * 外部データソースAfter処理
     * @param List<Externaldatasource__c>
     * @return 
     */
    public void onAfterProcess(List<Externaldatasource__c> extDataSrcList){
        
        Map<Id, Externaldatasource__c> extOppMap = new Map<Id, Externaldatasource__c>();
        for( Externaldatasource__c extDataSrc : extDataSrcList ) {
            extOppMap.put(extDataSrc.OpportunityId__c, extDataSrc);
        }
        
        // 商談更新
        List<Opportunity> opportunityList = [
                                                SELECT  
                                                        Id, 
                                                        ExLeadUpdateDate__c,
                                                        Item1__c,
                                                        Item2__c,
                                                        Item3__c,
                                                        Item4__c,
                                                        Item5__c,
                                                        Item6__c,
                                                        Item7__c,
                                                        Item8__c,
                                                        Item9__c,
                                                        Item10__c,
                                                        ItemLong1__c,
                                                        ItemLong2__c,
                                                        ItemLong3__c,
                                                        ItemLong4__c,
                                                        ItemLong5__c,
                                                        ItemLong6__c,
                                                        ItemLong7__c,
                                                        ItemLong8__c,
                                                        ItemLong9__c,
                                                        ItemLong10__c
                                                   FROM Opportunity
                                                  WHERE Id =: extOppMap.keySet()
                                                    AND ExLeadUpdateDate__c = NULL
                                                ];
        // 対象商談を繰り返す
        for(Opportunity opp : opportunityList){
            //外部データソースの設定
            inputExternalDataSourceAnket(opp, extOppMap.get(opp.Id));
        }
        update opportunityList;
    }
    
    
    /**
     * 取引先作成/更新処理
     * @param Account 作成/更新対象取引先
     * @param SeihoLead__c 作成/更新元となる生保Web資料請求情報
     * @return 
     */
    private void createTargetAccount(Account target , Externaldatasource__c extDataSrc){
        // 姓名情報
        inputName(target, extDataSrc);
        // 生年月日
        target.PersonBirthdate = extDataSrc.Birthday__c;
        // 性別
        target.Gender__pc = extDataSrc.Gender__c;
        // 楽天会員ID
        target.easyId__pc = extDataSrc.easyId__c;
        // メール
        target.PersonEmail = extDataSrc.Email__c;
        // 住所情報
        inputAddress(target, extDataSrc);
        // 連絡先情報
        target.Phone = extDataSrc.InternalPhone__c;
        target.PersonHomePhone = extDataSrc.HomePhone__c;
        target.PersonMobilePhone = extDataSrc.MobilePhone__c;
        // 顧客区分
        target.division__pc = '見込み顧客';
        // 取引先ステータス
        target.OperationType__c = '割当可';
        // 対応状況
        target.OpportunityStatus__c = '未対応';
    }
    
    
    private void inputAddress( Account target , Externaldatasource__c extDataSrc ) {
        // 住所情報
        if(extDataSrc.PostCode__c != NULL && extDataSrc.PostCode__c.length() > 20){
            target.PersonMailingPostalCode = extDataSrc.PostCode__c.left(20);
        }else{
            target.PersonMailingPostalCode = extDataSrc.PostCode__c;
        }
        if(extDataSrc.Prefecture__c != NULL && extDataSrc.Prefecture__c.length() > 80){
            target.PersonMailingState = extDataSrc.Prefecture__c.left(80);
        }else{
            target.PersonMailingState = extDataSrc.Prefecture__c;
        }
        if(extDataSrc.City__c != NULL && extDataSrc.City__c.length() > 40){
            target.PersonMailingCity = extDataSrc.City__c.left(40);
        }else{
            target.PersonMailingCity = extDataSrc.City__c;
        }
        String streetStr = '';
        if(String.isNotBlank(extDataSrc.TownName__c)){
            streetStr = extDataSrc.TownName__c;
        }
        if(streetStr != NULL && streetStr.length() > 255){
            target.PersonMailingStreet = streetStr.left(255);
        }else{
            target.PersonMailingStreet = streetStr;
        }
    }
    
    
    private void inputName( Account target , Externaldatasource__c extDataSrc ) {
        // 姓名情報
        if(extDataSrc.LastName__c <> Null){
            if(extDataSrc.LastName__c.length() > 40){
                target.LastName = extDataSrc.LastName__c.left(40);
                target.LastName__pc = extDataSrc.LastName__c.left(40);
            }else{
                target.LastName = extDataSrc.LastName__c;
                target.LastName__pc = extDataSrc.LastName__c;
            }
        }else if( String.isEmpty(target.LastName) 
               || String.isEmpty(target.LastName__pc) ) {
            if( String.isEmpty(target.LastName) ) {
                target.LastName = '未登録';
            }
            if( String.isEmpty(target.LastName__pc) ) {
                target.LastName__pc = '未登録';
            }
        }
        if(extDataSrc.FirstName__c <> Null){
            if(extDataSrc.FirstName__c.length() > 40){
                target.FirstName = extDataSrc.FirstName__c.left(40);
                target.firstname__pc = extDataSrc.FirstName__c.left(40);
            }else{
                target.FirstName = extDataSrc.FirstName__c;
                target.firstname__pc = extDataSrc.FirstName__c;
            }
        }else if( String.isEmpty(target.FirstName) 
               || String.isEmpty(target.firstname__pc) ) {
            if( String.isEmpty(target.FirstName) ) {
                target.FirstName = '';
            }
            if( String.isEmpty(target.firstname__pc) ) {
                target.firstname__pc = '';
            }
        }
        if( !String.isEmpty(extDataSrc.LastNameFurigana__c) ) {
            target.furiganaLast__pc = extDataSrc.LastNameFurigana__c;
        }
        if( !String.isEmpty(extDataSrc.FirstNameFurigana__c) ) {
            target.furiganaForst__pc = extDataSrc.FirstNameFurigana__c;
        }
    }
    
    
    private void inputExternalDataSourceAnket( Opportunity targetOpp , Externaldatasource__c extDataSrc ) {
        targetOpp.DateSource__c = extDataSrc.DateSource__c;
        targetOpp.ExLeadUpdateDate__c = System.Now();
        targetOpp.Item1__c = extDataSrc.Item1__c;
        targetOpp.Item2__c = extDataSrc.Item2__c;
        targetOpp.Item3__c = extDataSrc.Item3__c;
        targetOpp.Item4__c = extDataSrc.Item4__c;
        targetOpp.Item5__c = extDataSrc.Item5__c;
        targetOpp.Item6__c = extDataSrc.Item6__c;
        targetOpp.Item7__c = extDataSrc.Item7__c;
        targetOpp.Item8__c = extDataSrc.Item8__c;
        targetOpp.Item9__c = extDataSrc.Item9__c;
        targetOpp.Item10__c = extDataSrc.Item10__c;
        targetOpp.ItemLong1__c = extDataSrc.ItemLong1__c;
        targetOpp.ItemLong2__c = extDataSrc.ItemLong2__c;
        targetOpp.ItemLong3__c = extDataSrc.ItemLong3__c;
        targetOpp.ItemLong4__c = extDataSrc.ItemLong4__c;
        targetOpp.ItemLong5__c = extDataSrc.ItemLong5__c;
        targetOpp.ItemLong6__c = extDataSrc.ItemLong6__c;
        targetOpp.ItemLong7__c = extDataSrc.ItemLong7__c;
        targetOpp.ItemLong8__c = extDataSrc.ItemLong8__c;
        targetOpp.ItemLong9__c = extDataSrc.ItemLong9__c;
        targetOpp.ItemLong10__c = extDataSrc.ItemLong10__c;
        targetOpp.Date__c = extDataSrc.Date__c;
    }
    
    
}