/*
* @Class Name      : MiniInsuranceTriggerHandler 
* @Description     : ミニ保険トリガーハンドラ
* @Created Date    : 2019.05.15
* @Created By      : 
* @Modified Date   : 2019-12-23
* @Modified        : Valsala Kumar
*/
public class MiniInsuranceTriggerHandler {

    /**
     * コンストラクタ
     */
    public MiniInsuranceTriggerHandler() {}
    
    /**
     * ミニ保険作成前処理
     * @param List<MiniInsurance__c>
     * @return 
     */
    public void onBeforeInsertProcess(List<MiniInsurance__c> miniInsuranceList){
        //作成情報格納用マップ Key:ミニ保険申込ID
        Map<String,Account> targetAccountMap = new Map<String,Account>();
        
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
        for(MiniInsurance__c miniInsurance : miniInsuranceList){
            //手作成の場合、取引先が設定されている場合
            if(miniInsurance.AccountId__c != null){
               refAccIdList.add(miniInsurance.AccountId__c);
            }
            else{
                //20190808 修正開始 EasyIDに基づいての検索を外す
                // 楽天IDがある場合
                /*if(String.isNotBlank(miniInsurance.easy_id__c)){
                    easyIdList.add(miniInsurance.easy_id__c);
                }*/
                //20190808 修正終了 EasyIDに基づいての検索を外す
                // 姓名情報に空欄がない場合
                if(   String.isNotBlank(miniInsurance.LastName__c)
                        && String.isNotBlank(miniInsurance.FirstName__c)
                        && String.isNotBlank(miniInsurance.last_name_kana__c)
                        && String.isNotBlank(miniInsurance.first_name_kana__c)){
                    //氏名のキー情報を作成
                    String tmpName = miniInsurance.LastName__c + miniInsurance.FirstName__c + miniInsurance.last_name_kana__c + miniInsurance.first_name_kana__c;
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
        List<Account> updateAccList = new List<Account>();
        // 生保Web資料請求情報全件繰り返し
        for(MiniInsurance__c miniInsurance : miniInsuranceList){
            Account targetAccount;
            String nameInfo = '';
            // 手作成の場合、取引先が設定されている場合、名寄せ処理しない
            if(miniInsurance.AccountId__c != null){
                targetAccount = existRefAccountMap.get(miniInsurance.AccountId__c);
            }
            //20190808 修正開始 EasyIDに基づいての検索を外す
            // 楽天IDがある場合
            /*else if(String.isNotBlank(miniInsurance.easy_id__c) && existEasyIdAccountMap.get(miniInsurance.easy_id__c) <> Null){
                targetAccount = existEasyIdAccountMap.get(miniInsurance.easy_id__c);
            }*/
            //20190808 修正終了 EasyIDに基づいての検索を外す
            // 楽天IDで見つからなかった場合
            if(targetAccount == NULL){
                // 姓名情報に空欄がない場合
                if(   String.isNotBlank(miniInsurance.LastName__c)
                        && String.isNotBlank(miniInsurance.FirstName__c) 
                        && String.isNotBlank(miniInsurance.last_name_kana__c)
                        && String.isNotBlank(miniInsurance.first_name_kana__c)){
                    //氏名のキー情報作成
                    nameInfo = miniInsurance.LastName__c + miniInsurance.FirstName__c + miniInsurance.last_name_kana__c + miniInsurance.first_name_kana__c;
                    nameInfo = nameInfo.deleteWhitespace();
                    // 姓名情報が一致するレコードを繰り返す
                    List<Account> accList = existNameInfoAccountMap.get(nameInfo);
                    if(accList <> NULL){
                        for(Account acc : existNameInfoAccountMap.get(nameInfo)){
                            // 固定電話番号か携帯電話番号のいずれか一致する
                            if(   (miniInsurance.phone_num__c <> Null && acc.PersonHomePhone<>NULL && miniInsurance.phone_num__c.replace('-','').equals(acc.PersonHomePhone.replace('-','')))
                               || (miniInsurance.mobile_num__c <> Null && acc.PersonMobilePhone<>NULL && miniInsurance.mobile_num__c.replace('-','').equals(acc.PersonMobilePhone.replace('-','')))){
                                targetAccount = acc;
/*                                // ミニ保険に関連する取引先の更新
                                acc.PersonBirthdate = miniInsurance.Birthdate__c; // 生年月日
                                acc.Gender__pc = miniInsurance.Gender__c;         // 性別
                                acc.PersonHomePhone = miniInsurance.phone_num__c;    // 自宅電話番号
                                acc.PersonMobilePhone = miniInsurance.mobile_num__c; // 携帯電話番号
                                inputAddress(acc, miniInsurance);                 // 郵便番号・住所
                                acc.PersonEmail = miniInsurance.Email__c;         // メールアドレス
                                updateAccList.add(acc);*/
                                break;
                            }
                            // 生年月日かつ性別が一致する
                            else if(   miniInsurance.Birthdate__c == acc.PersonBirthdate
                                    && (miniInsurance.Gender__c <> Null && miniInsurance.Gender__c.equals(acc.Gender__pc))){
                                targetAccount = acc;
/*                                // ミニ保険に関連する取引先の更新
                                acc.PersonHomePhone = miniInsurance.phone_num__c;    // 自宅電話番号
                                acc.PersonMobilePhone = miniInsurance.mobile_num__c; // 携帯電話番号
                                inputAddress(acc, miniInsurance);                    // 郵便番号・住所
                                acc.PersonEmail = miniInsurance.Email__c;            // メールアドレス
                                updateAccList.add(acc);*/
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
                createTargetAccount(targetAccount, miniInsurance);
                insertAccList.add(targetAccount);
                if(   String.isNotBlank(miniInsurance.LastName__c)
                    && String.isNotBlank(miniInsurance.FirstName__c) 
                    && String.isNotBlank(miniInsurance.last_name_kana__c)
                    && String.isNotBlank(miniInsurance.first_name_kana__c)){
                    //氏名のキー情報作成
                    nameInfo = miniInsurance.LastName__c + miniInsurance.FirstName__c + miniInsurance.last_name_kana__c + miniInsurance.first_name_kana__c;
                    nameInfo = nameInfo.deleteWhitespace();
                    List<Account> accList = existNameInfoAccountMap.get(nameInfo);
                    if(accList == null){
                        accList = new List<Account>();
                    }
                    accList.add(targetAccount);
                    existNameInfoAccountMap.put(nameInfo, accList);
                }
            }
            targetAccountMap.put(miniInsurance.mini_apply_id__c, targetAccount);
        }
        insert insertAccList;
        update updateAccList;
        List<Id> accIdList = new List<Id>();
        for(Account acc : targetAccountMap.values()){
            accIdList.add(acc.Id);
        }
        
        // 商談
        // 案件の汎用レコードタイプIDを取得
        Id oppHanyoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hanyo').getRecordTypeId();
        DateTime insertDate = datetime.now();
        //商談のクローズ日は翌々月末日
        Date today = System.today();
        Date insertCloseDate = Date.newInstance(today.year(), today.month() + 3,0);
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
        // 対象取引先を繰り返す
        for(MiniInsurance__c miniInsurance : miniInsuranceList){
            Account acc = targetAccountMap.get(miniInsurance.mini_apply_id__c);
            if(accountOpportunityMap.get(acc.Id) == NULL){
                // 商談がない場合、新規作成
                Opportunity targetOpp = new Opportunity();
                // 商談の設定
                targetOpp.RecordTypeId = oppHanyoRecordTypeId;
                // 商談名
                /****** 20190527 修正開始 ******/
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
                /****** 20190527 修正エンド ******/
                // 商談ステータス
                targetOpp.StageName = '未割当';
                // 入電理由
                targetOpp.telReason__c = 'その他'; 
                // 申込日
                targetOpp.CloseDate = insertCloseDate;
                // 取引先Id
                targetOpp.AccountId = acc.Id;
                // リードソース
                targetOpp.InflowRoute__c = 'ミニ保険';
                // キャンペーン日時 = ミニ保険．システム日付
                targetOpp.CampaignDateTime__c = System.Now();
                
                //ミニ保険の設定
                inputMiniInsuranceAnket(targetOpp, miniInsurance);
                
                insertOpportunityList.add(targetOpp);
                accountOpportunityMap.put(acc.Id, targetOpp);
            }
        }
        // 新規商談Insert
        insert insertOpportunityList;
        
        // 生保Web資料請求の商談項目更新 Opportunity__c
        for(MiniInsurance__c miniInsurance : miniInsuranceList){
            miniInsurance.OpportunityId__c = accountOpportunityMap.get(targetAccountMap.get(miniInsurance.mini_apply_id__c).Id).Id;
            miniInsurance.AccountId__c = targetAccountMap.get(miniInsurance.mini_apply_id__c).Id;
        }
    }
        
    /**
     * ミニ保険更新前処理
     * @param List<MiniInsurance__c>
     * @return 
     */
/*    public void onBeforeUpdateProcess(List<MiniInsurance__c> miniInsuranceList){
        Map<Id, miniInsurance__c> accMiniInsuranceMap = new Map<Id, miniInsurance__c>();
        for(MiniInsurance__c miniInsurance : miniInsuranceList) {
            accMiniInsuranceMap.put(miniInsurance.AccountId__c, miniInsurance);
        }
        List<Account> updateAccList = new List<Account>();
        for(Account acc : [SELECT Id,furiganaLast__pc,furiganaForst__pc, SYSAccountName__c, Gender__pc, 
                                  PersonBirthdate, PersonHomePhone, PersonMobilePhone
                           FROM   Account 
                           WHERE  Id IN :accMiniInsuranceMap.keySet()]) {
            MiniInsurance__c miniInsurance = accMiniInsuranceMap.get(acc.Id);
            inputName(acc, miniInsurance);                    // 姓名・姓名カナ
            acc.PersonBirthdate = miniInsurance.Birthdate__c; // 生年月日
            acc.Gender__pc = miniInsurance.Gender__c;         // 性別
            inputAddress(acc, miniInsurance);                  // 郵便番号・住所
            acc.PersonHomePhone = miniInsurance.phone_num__c;    // 自宅電話番号
            acc.PersonMobilePhone = miniInsurance.mobile_num__c; // 携帯電話番号
            acc.PersonEmail = miniInsurance.Email__c;            // メールアドレス
            updateAccList.add(acc);
        }
        update updateAccList;
    }*/

    /**
     * ミニ保険After処理
     * @param List<MiniInsurance__c>
     * @return 
     */
    public void onAfterProcess(List<MiniInsurance__c> miniInsuranceList, Map<Id, MiniInsurance__c> oldMap){
        
        Map<Id, MiniInsurance__c> miniAccMap = new Map<Id, MiniInsurance__c>();
        Map<Id, MiniInsurance__c> miniOppMap = new Map<Id, MiniInsurance__c>();
        for( MiniInsurance__c mini : miniInsuranceList ) {
            miniAccMap.put(mini.AccountId__c, mini);
            miniOppMap.put(mini.OpportunityId__c, mini);
        }
        
        // 取引先更新
        List<Account> accList = [SELECT Id, LastName, LastName__pc, FirstName, firstname__pc,
                                        furiganaLast__pc, furiganaForst__pc, 
                                        PersonBirthdate, Gender__pc, PersonEmail, 
                                        PersonMailingPostalCode, PersonMailingState, 
                                        PersonMailingCity, PersonMailingStreet, 
                                        PersonHomePhone, PersonMobilePhone
                                FROM    Account
                                WHERE   Id =: miniAccMap.keySet()];
        List<Account> updateList = new List<Account>();
        for( Account acc : accList ) {
            MiniInsurance__c mini = miniAccMap.get(acc.Id); 
            inputName(acc, mini);
            acc.PersonBirthdate = mini.Birthdate__c;
            acc.Gender__pc = mini.Gender__c;
            acc.easyId__pc = mini.easy_id__c;
            acc.PersonEmail = mini.Email__c;
            inputAddress(acc, mini);
            acc.PersonHomePhone = mini.phone_num__c;
            acc.PersonMobilePhone = mini.mobile_num__c;
            if( oldMap == null 
            || mini.Birthdate__c != oldMap.get(mini.Id).Birthdate__c
            || mini.Gender__c != oldMap.get(mini.Id).Gender__c
            || mini.easy_id__c != oldMap.get(mini.Id).easy_id__c
            || mini.Email__c != oldMap.get(mini.Id).Email__c
            || mini.phone_num__c != oldMap.get(mini.Id).phone_num__c
            || mini.mobile_num__c != oldMap.get(mini.Id).mobile_num__c
            || mini.LastName__c != oldMap.get(mini.Id).LastName__c
            || mini.FirstName__c != oldMap.get(mini.Id).FirstName__c
            || mini.last_name_kana__c != oldMap.get(mini.Id).last_name_kana__c
            || mini.first_name_kana__c != oldMap.get(mini.Id).first_name_kana__c
            || mini.postal_code__c != oldMap.get(mini.Id).postal_code__c
            || mini.address1__c != oldMap.get(mini.Id).address1__c
            || mini.address2__c != oldMap.get(mini.Id).address2__c) {
                updateList.add(acc);
            }

        }
        update updateList;
        
        
        // 商談更新
        List<Opportunity> opportunityList = [
                                                SELECT  
                                                        Id, 
                                                        MiniUpdateDate__c,
                                                        Question1__c,
                                                        Question2__c,
                                                        Question3__c,
                                                        Question4__c,
                                                        Question5__c,
                                                        Question6__c,
                                                        Question7__c,
                                                        Question8__c,
                                                        Question9__c,
                                                        Question10__c,
                                                        Answer1__c,
                                                        Answer2__c,
                                                        Answer2_1__c,
                                                        Answer2_2__c,
                                                        Answer3__c,
                                                        Answer4__c,
                                                        Answer5__c,
                                                        Answer6__c,
                                                        Answer7__c,
                                                        Answer8__c,
                                                        Answer9__c,
                                                        Answer10__c,
                                                        ShortAnswer1__c,
                                                        ShortAnswer2__c,
                                                        ShortAnswer3__c,
                                                        ShortAnswer4__c,
                                                        ShortAnswer5__c,
                                                        ShortAnswer6__c,
                                                        ShortAnswer7__c,
                                                        ShortAnswer8__c,
                                                        ShortAnswer9__c,
                                                        ShortAnswer10__c,
                                                        MiniIssueDate__c
                                                   FROM Opportunity
                                                  WHERE Id =: miniOppMap.keySet()
                                                    AND MiniUpdateDate__c = NULL
                                                ];
        // 対象商談を繰り返す
        for(Opportunity opp : opportunityList){
            //ミニ保険の設定
            inputMiniInsuranceAnket(opp, miniOppMap.get(opp.Id));
        }
        update opportunityList;
    }

    /**
     * 取引先作成/更新処理
     * @param Account 作成/更新対象取引先
     * @param SeihoLead__c 作成/更新元となる生保Web資料請求情報
     * @return 
     */
    private void createTargetAccount(Account target , MiniInsurance__c miniInsurance){
        // 姓名情報
        inputName(target, MiniInsurance);
        // 生年月日
        target.PersonBirthdate = miniInsurance.Birthdate__c;
        // 性別
        target.Gender__pc = miniInsurance.Gender__c;
        // 楽天会員ID
        target.easyId__pc = miniInsurance.easy_id__c;
        // メール
        target.PersonEmail = miniInsurance.Email__c;
        // 住所情報
        inputAddress(target, miniInsurance);
        // 連絡先情報
        //******20180518 修正　開始*******/
        /*target.PersonHomePhone = miniInsurance.Phone__c;
        target.PersonMobilePhone = miniInsurance.MobilePhone__c;*/
        
        target.PersonHomePhone = miniInsurance.phone_num__c;
        target.PersonMobilePhone = miniInsurance.mobile_num__c;
        
        //******20180518 修正　エンド*******/
        // 顧客区分
        target.division__pc = '見込み顧客';
        
        //******20191219 修正　開始*******/
        target.OperationType__c = '割当可';
        target.OpportunityStatus__c = '未対応';
        //******20191219 修正　エンド*******/
    }
    
    private void inputAddress( Account target , MiniInsurance__c miniInsurance) {
        // 住所情報
        if(miniInsurance.postal_code__c != NULL && miniInsurance.postal_code__c.length() > 20){
            target.PersonMailingPostalCode = miniInsurance.postal_code__c.left(20);
        }else{
            target.PersonMailingPostalCode = miniInsurance.postal_code__c;
        }
        //2020-01-17 CC事務基盤強化PT Del Start
        //if(miniInsurance.State__c != NULL && miniInsurance.State__c.length() > 80){
        //    target.PersonMailingState = miniInsurance.State__c.left(80);
        //}else{
        //    target.PersonMailingState = miniInsurance.State__c;
        //}
        //if(miniInsurance.City__c != NULL && miniInsurance.City__c.length() > 40){
        //    target.PersonMailingCity = miniInsurance.City__c.left(40);
        //}else{
        //    target.PersonMailingCity = miniInsurance.City__c;
        //}
        //2020-01-17 CC事務基盤強化PT Del End
        
        //都道府県、市区町村はNullで更新
        target.PersonMailingState = Null;
        target.PersonMailingCity = Null;
            
        //都道府県市区町村を連結して更新
        String streetStr = '';
        if(String.isNotBlank(miniInsurance.address1__c)){
            streetStr = miniInsurance.address1__c;
        }
        if(String.isNotBlank(miniInsurance.address2__c)){
            streetStr = streetStr + miniInsurance.address2__c;
        }
        if(streetStr != NULL && streetStr.length() > 255){
            target.PersonMailingStreet = streetStr.left(255);
        }else{
            target.PersonMailingStreet = streetStr;
        }    
    }
    
    private void inputName( Account target , MiniInsurance__c miniInsurance) {
        // 姓名情報
            if(miniInsurance.LastName__c <> Null){
                if(miniInsurance.LastName__c.length() > 40){
                    target.LastName = miniInsurance.LastName__c.left(40);
                    target.LastName__pc = miniInsurance.LastName__c.left(40);
                }else{
                    target.LastName = miniInsurance.LastName__c;
                    target.LastName__pc = miniInsurance.LastName__c;
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
    

            if(miniInsurance.FirstName__c <> Null){
                if(miniInsurance.FirstName__c.length() > 40){
                    target.FirstName = miniInsurance.FirstName__c.left(40);
                    target.firstname__pc = miniInsurance.FirstName__c.left(40);
                }else{
                    target.FirstName = miniInsurance.FirstName__c;
                    target.firstname__pc = miniInsurance.FirstName__c;
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

        if( !String.isEmpty(miniInsurance.last_name_kana__c) ) {
            target.furiganaLast__pc = miniInsurance.last_name_kana__c;
        }
        if( !String.isEmpty(miniInsurance.first_name_kana__c)) {
            target.furiganaForst__pc = miniInsurance.first_name_kana__c;
        }
    }
    
    
    private void inputMiniInsuranceAnket( Opportunity targetOpp , MiniInsurance__c miniInsurance ) {
        targetOpp.MiniUpdateDate__c = System.Now();
        targetOpp.Question1__c = miniInsurance.Question1__c;
        targetOpp.Question2__c = miniInsurance.Question2__c;
        targetOpp.Question3__c = miniInsurance.Question3__c;
        targetOpp.Question4__c = miniInsurance.Question4__c;
        targetOpp.Question5__c = miniInsurance.Question5__c;
        targetOpp.Question6__c = miniInsurance.Question6__c;
        targetOpp.Question7__c = miniInsurance.Question7__c;
        targetOpp.Question8__c = miniInsurance.Question8__c;
        targetOpp.Question9__c = miniInsurance.Question9__c;
        targetOpp.Question10__c = miniInsurance.Question10__c;
        targetOpp.Answer1__c = miniInsurance.Answer1__c;
        targetOpp.Answer2__c = miniInsurance.Answer2__c;
        targetOpp.Answer2_1__c = miniInsurance.Answer2_1__c;
        targetOpp.Answer2_2__c = miniInsurance.Answer2_2__c;
        targetOpp.Answer3__c = miniInsurance.Answer3__c;
        targetOpp.Answer4__c = miniInsurance.Answer4__c;
        targetOpp.Answer5__c = miniInsurance.Answer5__c;
        targetOpp.Answer6__c = miniInsurance.Answer6__c;
        targetOpp.Answer7__c = miniInsurance.Answer7__c;
        targetOpp.Answer8__c = miniInsurance.Answer8__c;
        targetOpp.Answer9__c = miniInsurance.Answer9__c;
        targetOpp.Answer10__c = miniInsurance.Answer10__c;
        targetOpp.ShortAnswer1__c = miniInsurance.ShortAnswer1__c;
        targetOpp.ShortAnswer2__c = miniInsurance.ShortAnswer2__c;
        targetOpp.ShortAnswer3__c = miniInsurance.ShortAnswer3__c;
        targetOpp.ShortAnswer4__c = miniInsurance.ShortAnswer4__c;
        targetOpp.ShortAnswer5__c = miniInsurance.ShortAnswer5__c;
        targetOpp.ShortAnswer6__c = miniInsurance.ShortAnswer6__c;
        targetOpp.ShortAnswer7__c = miniInsurance.ShortAnswer7__c;
        targetOpp.ShortAnswer8__c = miniInsurance.ShortAnswer8__c;
        targetOpp.ShortAnswer9__c = miniInsurance.ShortAnswer9__c;
        targetOpp.ShortAnswer10__c = miniInsurance.ShortAnswer10__c;
        targetOpp.MiniIssueDate__c = miniInsurance.issue_date__c;
    }

}