/*
* @Class Name      : SeihoOpportunityTriggerHandler 
* @Description     : 生保申込みトリガーハンドラ
* @Created Date    : 2019.04.19
* @Created By      : 
* @Modified Date   : 2019-12-23
* @Modified        : Valsala Kumar
*/
public class SeihoOpportunityTriggerHandler {
    
    // 生保申込みレコードタイプ取得
    private static final Id seihoOppWebRecordId = Schema.SObjectType.SeihoOpportunity__c.getRecordTypeInfosByDeveloperName().get('SeihoOpportunityWeb').getRecordTypeId();
    private static final Id seihoOppPaperRecordId = Schema.SObjectType.SeihoOpportunity__c.getRecordTypeInfosByDeveloperName().get('SeihoOpportunityPaper').getRecordTypeId();
    
    /**
     * コンストラクタ
     */
    public SeihoOpportunityTriggerHandler() {}
    
    /**
     * 生保申込み作成後処理
     * @param List<SeihoOpportunity__c>
     * @return 
     */
    public void onBeforeProcess(List<SeihoOpportunity__c> seihoOpportunityList){
    
        //作成情報格納用マップ ID:生保申込みID
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
        
        // 生保申込みを繰り返し
        for(SeihoOpportunity__c seihoOpportunityRecord : seihoOpportunityList){
            //手作成の場合、取引先が設定されている場合
            if(seihoOpportunityRecord.Ref_Account__c != null){
               refAccIdList.add(seihoOpportunityRecord.Ref_Account__c);
            }
            else{
                //20190808 修正開始 EasyIDに基づいての検索を外す
                // 楽天IDがある場合
                /*if(String.isNotBlank(seihoOpportunityRecord.EasyId__c)){
                    easyIdList.add(seihoOpportunityRecord.EasyId__c);
                }*/
                //20190808 修正終了 EasyIDに基づいての検索を外す
                // 姓名情報に空欄がない場合
                //WEB申込の場合
                if(   String.isNotBlank(seihoOpportunityRecord.ApplyID__c)  //Web申込の場合はここに必ず値が入る
                        && String.isNotBlank(seihoOpportunityRecord.LastName__c)
                        && String.isNotBlank(seihoOpportunityRecord.FirstName__c)
                        && String.isNotBlank(seihoOpportunityRecord.LastNameKana__c)
                        && String.isNotBlank(seihoOpportunityRecord.FirstNameKana__c)){
                    String tmpName = seihoOpportunityRecord.LastName__c + seihoOpportunityRecord.FirstName__c 
                                    + seihoOpportunityRecord.LastNameKana__c + seihoOpportunityRecord.FirstNameKana__c;
                    tmpName = tmpName.deleteWhitespace();
                    nameInfoList.add(tmpName);
                //紙申込の場合
                } else if(   String.isBlank(seihoOpportunityRecord.ApplyID__c)
                        && String.isNotBlank(seihoOpportunityRecord.ApplicantName__c)
                        && String.isNotBlank(seihoOpportunityRecord.ApplicantNameKana__c)){
                    nameInfoList.add(seihoOpportunityRecord.ApplicantName__c.replace('　','') + seihoOpportunityRecord.ApplicantNameKana__c.replace('　',''));
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
        for(Account acc : [SELECT Id, easyId__pc, furiganaLast__pc, furiganaForst__pc FROM Account WHERE easyId__pc IN :easyIdList]){
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
        // 生保申込み情報全件繰り返し
        for(SeihoOpportunity__c seihoOpportunityRecord : seihoOpportunityList){
            Account targetAccount;
            String nameInfo = '';
            // 手作成の場合、取引先が設定されている場合、名寄せ処理しない
            if(seihoOpportunityRecord.Ref_Account__c != null){
                targetAccount = existRefAccountMap.get(seihoOpportunityRecord.Ref_Account__c);
            }
            //20190808 修正開始 EasyIDに基づいての検索を外す
            // 楽天IDがある場合
            /*else if(String.isNotBlank(seihoOpportunityRecord.EasyId__c) && existEasyIdAccountMap.get(seihoOpportunityRecord.EasyId__c) <> Null){
                targetAccount = existEasyIdAccountMap.get(seihoOpportunityRecord.EasyId__c);
            }*/
            //20190808 修正終了 EasyIDに基づいての検索を外す
            // 楽天IDで見つからなかった場合
            if(targetAccount == NULL){       
                // WEB申込で姓名情報に空欄がない場合
                if(   String.isNotBlank(seihoOpportunityRecord.ApplyID__c)  //Web申込の場合はここに必ず値が入る
                        && String.isNotBlank(seihoOpportunityRecord.LastName__c)
                        && String.isNotBlank(seihoOpportunityRecord.FirstName__c)
                        && String.isNotBlank(seihoOpportunityRecord.LastNameKana__c)
                        && String.isNotBlank(seihoOpportunityRecord.FirstNameKana__c)){
                    nameInfo = seihoOpportunityRecord.LastName__c + seihoOpportunityRecord.FirstName__c 
                               + seihoOpportunityRecord.LastNameKana__c + seihoOpportunityRecord.FirstNameKana__c;
                    nameInfo = nameInfo.deleteWhitespace();
                    // 姓名情報が一致するレコードを繰り返す
                    List<Account> accList = existNameInfoAccountMap.get(nameInfo);
                    if(accList <> NULL){
                        for(Account acc : existNameInfoAccountMap.get(nameInfo)){
                            // 固定電話番号か携帯電話番号のいずれか一致する
                            if(   (   seihoOpportunityRecord.Phone__c <> Null
                                   && acc.PersonHomePhone <> Null
                                   && seihoOpportunityRecord.Phone__c.replace('-','').equals(acc.PersonHomePhone.replace('-','')))
                               || (   seihoOpportunityRecord.MobilePhone__c <> Null
                                   && acc.PersonMobilePhone <> Null
                                   && seihoOpportunityRecord.MobilePhone__c.replace('-','').equals(acc.PersonMobilePhone.replace('-','')))){
                                targetAccount = acc;
                                break;
                            }
                            // 生年月日かつ性別が一致する
                            else if(   seihoOpportunityRecord.Birthdate__c == acc.PersonBirthdate
                                    && (seihoOpportunityRecord.Gender__c <> Null && seihoOpportunityRecord.Gender__c.equals(acc.Gender__pc))){
                                targetAccount = acc;
                                break;
                            }
                        }
                    }
                }
                //紙申込で姓名に空欄が無い場合
                else if(   String.isBlank(seihoOpportunityRecord.ApplyID__c)
                        && String.isNotBlank(seihoOpportunityRecord.ApplicantName__c)
                        && String.isNotBlank(seihoOpportunityRecord.ApplicantNameKana__c)){
                    
                    //姓名のキーを作成
                    nameInfo = seihoOpportunityRecord.ApplicantName__c + seihoOpportunityRecord.ApplicantNameKana__c;
                    nameInfo = nameInfo.replace('　','');
                    // 姓名情報が一致するレコードを繰り返す
                    List<Account> accList = existNameInfoAccountMap.get(nameInfo);
                    if(accList <> NULL){
                        for(Account acc : existNameInfoAccountMap.get(nameInfo)){
                            // 固定電話番号か携帯電話番号のいずれか一致する
                            if(   (   acc.PersonHomePhone <> Null
                                   && seihoOpportunityRecord.ApplicantPhoneNumber__c <> Null
                                   && seihoOpportunityRecord.ApplicantPhoneNumber__c.replace('-','').equals(acc.PersonHomePhone.replace('-','')))
                               || (   acc.PersonMobilePhone <> Null
                                   && seihoOpportunityRecord.ApplicantCellPhoneNumber__c <> Null
                                   && seihoOpportunityRecord.ApplicantCellPhoneNumber__c.replace('-','').equals(acc.PersonMobilePhone.replace('-','')))){
                                targetAccount = acc;
                                break;
                            }
                            // 生年月日かつ性別が一致する
                            else if(   seihoOpportunityRecord.ContracterBD__c <> Null
                                    && acc.PersonBirthdate <> Null
                                    && seihoOpportunityRecord.ApplicantGender__c <> Null
                                    && acc.Gender__pc <> Null
                                    && seihoOpportunityRecord.ContracterBD__c == acc.PersonBirthdate
                                    && seihoOpportunityRecord.ApplicantGender__c.equals(acc.Gender__pc)){
                                targetAccount = acc;
                                break;
                            }
                        }
                    }
                }
            }
            // 取引先を新規
            if(targetAccount == null){
                targetAccount = new Account();
                targetAccount.RecordTypeId = accountPersonRecordTypeId;
                createTargetAccount(targetAccount, seihoOpportunityRecord);
                insertAccList.add(targetAccount);
                if(   String.isNotBlank(seihoOpportunityRecord.ApplyID__c)  //Web申込の場合はここに必ず値が入る
                    && String.isNotBlank(seihoOpportunityRecord.LastName__c)
                    && String.isNotBlank(seihoOpportunityRecord.FirstName__c)
                    && String.isNotBlank(seihoOpportunityRecord.LastNameKana__c)
                    && String.isNotBlank(seihoOpportunityRecord.FirstNameKana__c)){
                    nameInfo = seihoOpportunityRecord.LastName__c + seihoOpportunityRecord.FirstName__c 
                           + seihoOpportunityRecord.LastNameKana__c + seihoOpportunityRecord.FirstNameKana__c;
                    nameInfo = nameInfo.deleteWhitespace();
                    List<Account> accList = existNameInfoAccountMap.get(nameInfo);
                    if(accList == null){
                        accList = new List<Account>();
                    }
                    accList.add(targetAccount);
                    existNameInfoAccountMap.put(nameInfo, accList);
                }
                else if(   String.isBlank(seihoOpportunityRecord.ApplyID__c)
                    && String.isNotBlank(seihoOpportunityRecord.ApplicantName__c)
                    && String.isNotBlank(seihoOpportunityRecord.ApplicantNameKana__c)){
                    
                    //姓名のキーを作成
                    nameInfo = seihoOpportunityRecord.ApplicantName__c + seihoOpportunityRecord.ApplicantNameKana__c;
                    nameInfo = nameInfo.replace('　','');
                    List<Account> accList = existNameInfoAccountMap.get(nameInfo);
                    if(accList == null){
                        accList = new List<Account>();
                    }
                    accList.add(targetAccount);
                    existNameInfoAccountMap.put(nameInfo, accList);
                }
            }
            targetAccountMap.put(seihoOpportunityRecord.Name, targetAccount);
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
        // 既存生保商談を取得
        List<Opportunity> existSeihoOpportunityList = [ 
                                                            SELECT Id, Name, AccountId, MiniSyncSubsc__c
                                                              FROM Opportunity
                                                             WHERE AccountId IN :accIdList
                                                               AND RecordType.DeveloperName = 'Seiho'
                                                               AND StageName <> '対応終了'
                                                          ORDER BY LastModifiedDate DESC
                                                      ];
        // 取引先、生保商談関連用マップに入れる
        for(Opportunity opp : existSeihoOpportunityList){
            if (accountOpportunityMap.get(opp.AccountId) == NULL) {
                accountOpportunityMap.put(opp.AccountId, opp);
            }
        }
        
        // 既存汎用商談を取得
        List<Opportunity> existHanyoOpportunityList = [ 
                                                            SELECT Id, Name, AccountId, MiniSyncSubsc__c
                                                              FROM Opportunity
                                                             WHERE AccountId IN :accIdList
                                                               AND RecordType.DeveloperName = 'Hanyo'
                                                               AND StageName <> '対応終了'
                                                          ORDER BY LastModifiedDate DESC
                                                      ];
        // 取引先、汎用商談関連用マップに入れる
        for(Opportunity opp : existHanyoOpportunityList){
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
                /******* 20180527 修正開始 ********/
                String targetOppname = opportunityNameInsertStr;
                if(String.isNotBlank(acc.furiganaLast__pc)){
                    targetOppname  = targetOppname + acc.furiganaLast__pc;
                }
                if(String.isNotBlank(acc.furiganaForst__pc)){
                    targetOppname  = targetOppname + acc.furiganaForst__pc;
                }
                if(targetOppname.length()>80){
                    targetOpp.name = targetOppname.left(80);
                }else{
                    targetOpp.name = targetOppname;
                }
                /******* 20180527 修正エンド ********/
                // 商談ステータス
                targetOpp.StageName = '未割当';
                // 入電理由
                targetOpp.telReason__c = 'その他';
                // 申込日
                targetOpp.CloseDate = insertCloseDate;
                // 取引先Id
                targetOpp.AccountId = acc.Id;
                // リードソース
                targetOpp.InflowRoute__c = '申込途中保存';
                // キャンペーン日時 = 生保申込み．システム日付
                targetOpp.CampaignDateTime__c = System.Now();
                
                insertOpportunityList.add(targetOpp);
                accountOpportunityMap.put(acc.Id, targetOpp);
            }
        }
        // 新規商談Insert
        insert insertOpportunityList;
        
        // ミニ保険同時申込Update用List
        List <Opportunity> miniSubscUpdateOppList = new List<Opportunity>();
        
        // 生保申込みの項目更新
        for(SeihoOpportunity__c seihoOpportunityRecord : seihoOpportunityList){
            //レコードタイプ設定
            if(seihoOpportunityRecord.ApplyID__c <> Null){
                seihoOpportunityRecord.RecordTypeId = seihoOppWebRecordId;
            }else{
                seihoOpportunityRecord.RecordTypeId = seihoOppPaperRecordId;
            }
            Opportunity opp = accountOpportunityMap.get(targetAccountMap.get(seihoOpportunityRecord.Name).Id);
            if (opp.MiniSyncSubsc__c != '有') {
                if (seihoOpportunityRecord.MiniSyncSubsc__c == '有' || seihoOpportunityRecord.MiniSyncSubsc__c == '‐' || seihoOpportunityRecord.MiniSyncSubsc__c == '－') {
                    opp.MiniSyncSubsc__c = seihoOpportunityRecord.MiniSyncSubsc__c;
                    miniSubscUpdateOppList.add(opp);
                } 
            }
            
            //商談設定
            seihoOpportunityRecord.Opportunity__c = opp.Id;
            seihoOpportunityRecord.Ref_Account__c = targetAccountMap.get(seihoOpportunityRecord.Name).Id;
        }
        update miniSubscUpdateOppList;
    }
    
    /**
     * 取引先作成/更新処理
     * @param Account 作成/更新対象取引先
     * @param SeihoOpportunity__c 作成/更新元となる生保申込み情報
     * @return 
     */
    private void createTargetAccount(Account target , SeihoOpportunity__c seihoOpportunityRecord){
        //紙申込の場合
        if(String.isBlank(seihoOpportunityRecord.ApplyID__c)){
            //姓
            if(seihoOpportunityRecord.ApplicantName__c <> Null){
                //紙申込の場合は姓名が連結されて連携されるため、全角スペースを区切り文字として切り取り
                String accountSei = seihoOpportunityRecord.ApplicantName__c.substringBefore('　');
                if(accountSei.length() > 40){
                    //姓
                    target.LastName = accountSei.substring(0,39);
                    target.LastName__pc = accountSei.substring(0,39);
                }else{
                    //姓
                    target.LastName = accountSei;
                    target.LastName__pc = accountSei;
                }
            }else{
                target.LastName = '未登録';
                target.LastName__pc = '未登録';
            }
            //名
            if(seihoOpportunityRecord.ApplicantName__c <> Null){
                //紙申込の場合は姓名が連結されて連携されるため、全角スペースを区切り文字として切り取り
                String accountMei = seihoOpportunityRecord.ApplicantName__c.substringAfter('　');
                if(accountMei.length() > 40){
                    //名
                    target.FirstName = accountMei.substring(0,39);
                    target.firstname__pc = accountMei.substring(0,39);
                }else{
                    //名
                    target.FirstName = accountMei;
                    target.firstname__pc = accountMei;
                }
            }else{
                target.FirstName = '';
                target.firstname__pc = '';
            }
            //フリガナ姓・名
            String furiganaSei;
            String furiganaMei;
            
            if(seihoOpportunityRecord.ApplicantNameKana__c <> Null){
                furiganaSei = seihoOpportunityRecord.ApplicantNameKana__c.substringBefore('　');
                furiganaMei = seihoOpportunityRecord.ApplicantNameKana__c.substringAfter('　');
            }
            target.furiganaLast__pc = furiganaSei;
            target.furiganaForst__pc = furiganaMei;
            // 生年月日
            target.PersonBirthdate = seihoOpportunityRecord.ContracterBD__c;
            // 性別
            target.Gender__pc = seihoOpportunityRecord.ApplicantGender__c;
            // 楽天会員ID
            target.easyId__pc = seihoOpportunityRecord.EasyId__c;
            // メール
            target.PersonEmail = Null;
            // 住所情報
            target.PersonMailingPostalCode = seihoOpportunityRecord.ContractPostalCode__c;
            target.PersonMailingState = Null;
            target.PersonMailingCity = Null;
            target.PersonMailingStreet = seihoOpportunityRecord.ContractPostalAddress__c;
            // 連絡先情報
            target.Phone = seihoOpportunityRecord.ApplicantPhoneNumber__c;
            target.PersonHomePhone = seihoOpportunityRecord.ApplicantPhoneNumber__c;
            target.PersonMobilePhone = seihoOpportunityRecord.ApplicantCellPhoneNumber__c;
            // 顧客区分
            target.division__pc = '見込み顧客';
            //******20191223 修正　開始*******/
            target.OperationType__c = '割当可';
            target.OpportunityStatus__c = '未対応';
            //******20191223 修正　エンド*******/
        }
        //WEB申込の場合
        else{
            if(seihoOpportunityRecord.LastName__c <> Null){
                if(seihoOpportunityRecord.LastName__c.length() > 40){
                    target.LastName = seihoOpportunityRecord.LastName__c.substring(0,39);
                    target.LastName__pc = seihoOpportunityRecord.LastName__c.substring(0,39);
                }else{
                    target.LastName = seihoOpportunityRecord.LastName__c;
                    target.LastName__pc = seihoOpportunityRecord.LastName__c;
                }
            }else{
                target.LastName = '未登録';
                target.LastName__pc = '未登録';
            }
            if(seihoOpportunityRecord.FirstName__c <> Null){
                if(seihoOpportunityRecord.FirstName__c.length() > 40){
                    target.FirstName = seihoOpportunityRecord.FirstName__c.substring(0,39);
                    target.firstname__pc = seihoOpportunityRecord.FirstName__c.substring(0,39);
                }else{
                    target.FirstName = seihoOpportunityRecord.FirstName__c;
                    target.firstname__pc = seihoOpportunityRecord.FirstName__c;
                }
            }else{
                target.FirstName = '';
                target.firstname__pc = '';
            }
            target.furiganaLast__pc = seihoOpportunityRecord.LastNameKana__c;   //取引先：255文字、申込：60文字のため切り捨ての必要なし
            target.furiganaForst__pc = seihoOpportunityRecord.FirstNameKana__c; //取引先：255文字、申込：60文字のため切り捨ての必要なし
            // 生年月日
            target.PersonBirthdate = seihoOpportunityRecord.Birthdate__c; //どちらも日付型のため型変換等の必要なし
            // 性別
            target.Gender__pc = seihoOpportunityRecord.Gender__c; //取引先：選択リスト、申込：テキスト255だが、制限付きリストではないため型変換不要
            // 楽天会員ID
            target.easyId__pc = seihoOpportunityRecord.EasyId__c;  //取引先：255文字、申込：10文字のため切り捨ての必要なし
            // メール
            target.PersonEmail = seihoOpportunityRecord.Email__c; //取引先、申込どちらもメール型のため型の変換は不要
            // 住所情報
            //郵便番号（最大20文字）
            if(seihoOpportunityRecord.PostalCode__c <> Null){
                if(seihoOpportunityRecord.PostalCode__c.length() > 20){
                    target.PersonMailingPostalCode = seihoOpportunityRecord.PostalCode__c.substring(0,19); //20文字までで切り捨て
                }else{
                    target.PersonMailingPostalCode = seihoOpportunityRecord.PostalCode__c;
                }
            }
            //都道府県（最大80文字）
            if(seihoOpportunityRecord.State__c <> Null){
                if(seihoOpportunityRecord.State__c.length() > 80){
                    target.PersonMailingState = seihoOpportunityRecord.State__c.substring(0,79);   //80文字までで切り捨て
                }else{
                    target.PersonMailingState = seihoOpportunityRecord.State__c;
                }
            }
            //市区町村（最大40文字）
            if(seihoOpportunityRecord.address1__c <> Null){
                if(seihoOpportunityRecord.address1__c.length() > 40){
                    target.PersonMailingCity = seihoOpportunityRecord.address1__c.substring(0,39); //40文字までで切り捨て
                }else{
                    target.PersonMailingCity = seihoOpportunityRecord.address1__c;
                }
            }
            //町名・番地（最大255文字）
            String strAddress = '';
            if(String.isNotBlank(seihoOpportunityRecord.address2__c)){
                strAddress = seihoOpportunityRecord.address2__c;
            }
            if(String.isNotBlank(seihoOpportunityRecord.address3__c)){
                strAddress = strAddress + seihoOpportunityRecord.address3__c;
            }
            if(strAddress <> Null){
                if(strAddress.length() > 255){
                    target.PersonMailingStreet = strAddress.substring(0,254); //255文字までで切り捨て
                }else{
                    target.PersonMailingStreet = strAddress;
                }
            }
            // 連絡先情報
            target.Phone = seihoOpportunityRecord.ApplicantPhoneNumber__c;
            target.PersonHomePhone = seihoOpportunityRecord.Phone__c; //取引先、申込どちらも電話型のため型の変換は不要
            target.PersonMobilePhone = seihoOpportunityRecord.MobilePhone__c; //取引先、申込どちらも電話型のため型の変換は不要
            // 顧客区分
            target.division__pc = '見込み顧客';
            //******20191223 修正　開始*******/
            target.OperationType__c = '割当可';
            target.OpportunityStatus__c = '未対応';
            //******20191223 修正　エンド*******/
        }
    }
    
    
    public void onBeforeUpdateProccess(List<SeihoOpportunity__c> seihoOpportunityList) {
        
        List <Id> seihoOppIdList = new List <Id>();
        for (SeihoOpportunity__c seihoOpportunityRecord : seihoOpportunityList) {
            if (String.IsNotBlank(seihoOpportunityRecord.Opportunity__c))
                seihoOppIdList.add(seihoOpportunityRecord.Opportunity__c);
        }
        Map<Id, Opportunity> oppIdMap = new Map<Id, Opportunity>();
        for (Opportunity opp : [SELECT Id, Name, MiniSyncSubsc__c FROM Opportunity WHERE Id = :seihoOppIdList]) {
            oppIdMap.put(opp.Id, opp);
        }
        
        // ミニ保険同時申込Update用List
        Map<Id, Opportunity> miniSubscUpdateOppMap = new Map<Id, Opportunity>();
        
        // 生保申込みの項目更新
        for (SeihoOpportunity__c seihoOpportunityRecord : seihoOpportunityList) {
            if (String.IsNotBlank(seihoOpportunityRecord.Opportunity__c)) {
                Opportunity opp = oppIdMap.get(seihoOpportunityRecord.Opportunity__c);
                if( miniSubscUpdateOppMap.containsKey(opp.Id) ) {
                    opp = miniSubscUpdateOppMap.get(opp.Id);
                }
                
                if (opp.MiniSyncSubsc__c != '有') {
                    if (seihoOpportunityRecord.MiniSyncSubsc__c == '有' || seihoOpportunityRecord.MiniSyncSubsc__c == '‐' || seihoOpportunityRecord.MiniSyncSubsc__c == '－') {
                        opp.MiniSyncSubsc__c = seihoOpportunityRecord.MiniSyncSubsc__c;
                        miniSubscUpdateOppMap.put(opp.Id, opp);
                    } 
                }
            }
        }
        update miniSubscUpdateOppMap.values();
    }
    
    
    /**
     * 生保申込み作成後処理
     * @param List<SeihoOpportunity__c>
     * @return 
     */
    public void onAfterProcess(List<SeihoOpportunity__c> seihoOpportunityList, Map<Id, SeihoOpportunity__c> oldMap){
        
        /*
        //生保申込みに関連する商談IDセット
        Set<String> seihoOppIdSet = new Set<String>();

        for(SeihoOpportunity__c seiho : seihoOpportunityList){
            System.debug('seiho ' + seiho.ApplySts__c);
            if(seiho.ApplySts__c == '申込完了'){
                seihoOppIdSet.add(seiho.Opportunity__c);
            }
        }
        System.debug('seihoOppIdSet ' + seihoOppIdSet);
        List<Opportunity> updateOpportunityList = [Select Id, StageName from Opportunity where Id IN: seihoOppIdSet];
        for(Opportunity opp : updateOpportunityList){
            opp.StageName = '対応終了';
        }

        System.debug('updateOpportunityList ' + updateOpportunityList);

        //商談の商談ステータスを更新
        if(updateOpportunityList != null && updateOpportunityList.size() > 0)
            update updateOpportunityList;
        */
        
        
        //******20191226 修正　開始*******/
        // Phase3対応
        
        //生保申込みに関連する商談IDセット
        Set<String> seihoOppIdSet = new Set<String>();
        Set<String> seihoOppClosedIdSet = new Set<String>();
        Set<String> seihoOppNotClosedIdSet = new Set<String>();
        //生保申込みに関連する取引先IDセット
        Set<String> seihoAccClosedIdSet = new Set<String>();
        
        for(SeihoOpportunity__c seiho : seihoOpportunityList){
            if (String.IsNotBlank(seiho.Opportunity__c)) {
                seihoOppIdSet.add(seiho.Opportunity__c);
                if ((seiho.ApplySts__c == '申込完了' && 
                     (oldMap == NULL || 
                      (oldMap.size() > 0 && 
                       seiho.ApplySts__c != oldMap.get(seiho.Id).ApplySts__c)))
                ||  seiho.RecordTypeId == seihoOppPaperRecordId){
                    // 申込完了である
                    seihoOppClosedIdSet.add(seiho.Opportunity__c);
                    if (String.IsNotBlank(seiho.Ref_Account__c)) {
                        seihoAccClosedIdSet.add(seiho.Ref_Account__c);
                    }
                }
                else {
                    // 申込完了でない
                    seihoOppNotClosedIdSet.add(seiho.Opportunity__c);
                }
            }
        }
        
        // 商談
        // 更新商談Update用マップ
        Map<Id, Opportunity> updateOpportunityMap = new Map<Id, Opportunity>();
        
        // 生保申込み、商談関連用マップ ID:商談ID
        // 関連先商談取得
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>(
                                                                [ 
                                                                    SELECT Id, RecordTypeId, StageName, 
                                                                           ANP__c, EstimatedANP__c, 
                                                                           CloseDate, CloseType__c, 
                                                                           RecentProbability__c, 
                                                                           LastProbability__c, 
                                                                           AgencyName__c, ApplySts__c 
                                                                      FROM Opportunity
                                                                     WHERE Id IN :seihoOppIdSet
                                                                ]
                                                            );
        
        
        // 商談クローズ処理
        // 取引先に紐づく他商談を取得
        List<Opportunity> accOtherOppList = [ 
                                                SELECT Id, StageName, 
                                                       CloseDate, CloseType__c, AccountId, 
                                                       CloseReason__c, RecentProbability__c, 
                                                       LastProbability__c 
                                                  FROM Opportunity
                                                 WHERE AccountId = :seihoAccClosedIdSet 
                                                   AND Id <> :seihoOppClosedIdSet
                                                   AND StageName <> '対応終了'
                                                   AND (RecordType.DeveloperName = 'Seiho' OR RecordType.DeveloperName = 'Hanyo')
                                            ];
        Map<Id, List<Opportunity>> accountOtherOppMap = new Map<Id, List<Opportunity>>();
        for(Opportunity targetOpp : accOtherOppList){
            if(accountOtherOppMap.get(targetOpp.AccountId) == NULL){
                List<Opportunity> accOppList = new List<Opportunity>();
                accOppList.add(targetOpp);
                accountOtherOppMap.put(targetOpp.AccountId,accOppList);
            }else{
                accountOtherOppMap.get(targetOpp.AccountId).add(targetOpp);
            }
        }
        
        for(SeihoOpportunity__c seiho : seihoOpportunityList){
            if (seiho.Opportunity__c != NULL && 
                oppMap.get(seiho.Opportunity__c) != NULL) {
                
                Opportunity targetOpp = oppMap.get(seiho.Opportunity__c);
                
                // 申込ステータス判定
                if ((seiho.ApplySts__c == '申込完了' && 
                     (oldMap == NULL || 
                      (oldMap.size() > 0 && 
                       seiho.ApplySts__c != oldMap.get(seiho.Id).ApplySts__c)))
                || seiho.RecordTypeId == seihoOppPaperRecordId){
                    
                    // Get Old Record for ANP Calculation
                    SeihoOpportunity__c oldseiho = oldMap != NULL ? oldMap.get(seiho.Id) : NULL;
                    
                    // 関連先商談の項目設定（ANP更新）+ 
                    // 関連先商談の項目設定（ANP初回設定）
                    updateClosedOpportunity(targetOpp, seiho, oldseiho);
                    
                    // 取引先に紐づく他商談処理
                    if(accountOtherOppMap.get(seiho.Ref_Account__c) != NULL){
                        
                        List<Opportunity> accOppList = accountOtherOppMap.get(seiho.Ref_Account__c);
                        // 商談クローズ処理
                        // 取引先に紐づく他商談を値設定
                        updateOtherClosedOpportunity(accOppList, seiho);
                        
                        // Update用Mapに追加
                        for(Opportunity rec : accOppList){
                            if(updateOpportunityMap.get(rec.id) == Null){
                                updateOpportunityMap.put(rec.id, rec);
                            }
                        }
                    }
                }
                else {
                    // 関連先商談の項目設定（申込途中保存）
                    // 取得した商談レコードについて、更新後の値をセットする。
                    updateDraftOpportunity(targetOpp, seiho);
                }
                
                // Update用Mapに追加
                if(updateOpportunityMap.get(targetOpp.id) == Null){
                    updateOpportunityMap.put(targetOpp.id, targetOpp);
                }
            }
        }
        
        //商談を更新
        if (updateOpportunityMap != null && updateOpportunityMap.size() > 0)
            update updateOpportunityMap.values();
        
        // 生保申込済みフラグ更新処理
        // 取引先取得
        List<Account> updateAccountList =   [ 
                                                SELECT Id, SeihoOppApplyflg__c 
                                                  FROM Account
                                                 WHERE Id = :seihoAccClosedIdSet 
                                            ];
        // 取得した取引先レコードについて、生保申込フラグをTrueにする
        for(Account targetAcc : updateAccountList){
            // 生保申込済みフラグ
            targetAcc.SeihoOppApplyflg__c = TRUE;
        }
        
        // 取引先を更新
        if(updateAccountList != null && updateAccountList.size() > 0)
            update updateAccountList;
        
        //******20191226 修正　エンド*******/
    }
    
    
    private void updateClosedOpportunity(Opportunity targetOpp, SeihoOpportunity__c seiho, SeihoOpportunity__c oldseiho) {
        // 関連先商談の項目設定（ANP更新）+ 
        // 関連先商談の項目設定（ANP初回設定）
        
        // 案件の生保レコードタイプIDを取得
        Id oppSeihoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Seiho').getRecordTypeId();
        // 関連先商談更新_申込完了
        // 商談の設定
        targetOpp.RecordTypeId = oppSeihoRecordTypeId;
        // 商談ステータス
        targetOpp.StageName = '対応終了';
        // 完了予定日
        targetOpp.CloseDate = Date.newinstance(
                                        seiho.LastModifiedDate.year(), 
                                        seiho.LastModifiedDate.month(), 
                                        seiho.LastModifiedDate.day());
        // ANP設定
        setANP(targetOpp, seiho, oldseiho);
        // 見込ANP
        targetOpp.EstimatedANP__c = targetOpp.ANP__c;
        // クローズ種別が申込以外の場合、クローズ理由をクリヤ
        if (targetOpp.CloseType__c <> '申込') {
            targetOpp.CloseReason__c = '';
        }
        // クローズ種別
        targetOpp.CloseType__c = '申込';
        // 最新見込確度
        targetOpp.RecentProbability__c = '申込済み';
        // 最終見込確度
        // （更新前）商談．最終見込確度=''の場合
        if (String.IsBlank(targetOpp.LastProbability__c)) {
            targetOpp.LastProbability__c = '申込済み';
        }
        // 代理店名
        targetOpp.AgentName__c = seiho.AgentName__c;
        // 申込ステータス
        targetOpp.ApplySts__c = '申込完了';
    }
    
    
    // ANP設定
    private void setANP(Opportunity targetOpp, SeihoOpportunity__c seiho, SeihoOpportunity__c oldseiho) {
        // ANP
        Decimal fee = 0;
        // 商談レコードタイプが「Web申込」の場合
        if (seiho.RecordTypeId == seihoOppWebRecordId) {
            if (String.isNotBlank(seiho.WebApplicationInsuFee__c) && 
                seiho.WebApplicationInsuFee__c.isNumeric()) {
                fee = Decimal.valueOf(seiho.WebApplicationInsuFee__c);
            }
        }
        // 商談レコードタイプが「紙申込」の場合
        else if(seiho.RecordTypeId == seihoOppPaperRecordId) {
            if (String.isNotBlank(seiho.ApplicationInsuFee__c) && 
                seiho.ApplicationInsuFee__c.isNumeric()) {
                fee = Decimal.valueOf(seiho.ApplicationInsuFee__c);
            }
        }
        // 商談.ANP <> null の場合
        if (targetOpp.ANP__c != NULL) {
            // 申込完了に変更された？
            // 申込完了変更判定
            // 条件： (① AND ③ ) OR ② OR ###INSERT###
            // ①: （変更前）申込ステータス ＜＞ 申込完了 
            // ②: （変更前）商談 ＜＞ （変更後）商談
            // ③: レコードタイプ = Web申込
            if(oldseiho == NULL
            || (  oldseiho.ApplySts__c != '申込完了'
               && seiho.RecordTypeId == seihoOppWebRecordId)
            || oldseiho.Opportunity__c != seiho.Opportunity__c) {
                // 関連先商談の項目設定（ANP加算）
                // 商談レコードタイプが「Web申込」の場合
                // ANPの値 = 既存のANPの値 + 生保申込み.Web申込保険料×12
                // OR
                // 商談レコードタイプが「紙申込」の場合
                // ANPの値 = 既存のANPの値 + 生保申込み.申込保険料×12
                targetOpp.ANP__c = targetOpp.ANP__c + (fee * 12);
            }
            // 保険料変更判定
            // 条件：（① AND ②）OR（③ AND ④）
            // ①:生保申込み．レコードタイプ = Web申込
            // ②:（更新前）生保申込み．Web申込保険料 <>（更新後）生保申込み．Web申込保険料
            // ③:生保申込み．レコードタイプ = 紙申込
            // ④:（更新前）生保申込み．申込保険料 <>（更新後）生保申込み．申込保険料
            else if((  seiho.RecordTypeId == seihoOppWebRecordId
                    && oldseiho.WebApplicationInsuFee__c != seiho.WebApplicationInsuFee__c)
                 || (  seiho.RecordTypeId == seihoOppPaperRecordId
                    && oldseiho.ApplicationInsuFee__c != seiho.ApplicationInsuFee__c)) {
                Decimal oldfee = 0;
                // 商談レコードタイプが「Web申込」の場合
                if (seiho.RecordTypeId == seihoOppWebRecordId) {
                    if (String.isNotBlank(oldseiho.WebApplicationInsuFee__c) 
                    &&  oldseiho.WebApplicationInsuFee__c.isNumeric()) {
                        oldfee = Decimal.valueOf(oldseiho.WebApplicationInsuFee__c);
                    }
                }
                // 商談レコードタイプが「紙申込」の場合
                else if(seiho.RecordTypeId == seihoOppPaperRecordId) {
                    if (String.isNotBlank(oldseiho.ApplicationInsuFee__c) 
                    &&  oldseiho.ApplicationInsuFee__c.isNumeric()) {
                        oldfee = Decimal.valueOf(oldseiho.ApplicationInsuFee__c);
                    }
                }
                // 関連先商談の項目設定（ANP変更）
                // 商談レコードタイプが「Web申込」の場合
                // ANPの値 = 既存のANPの値 + 生保申込み.Web申込保険料×12
                // - （更新前）生保申込み.Web申込保険料×12
                // + （更新後）生保申込み.Web申込保険料×12
                // OR
                // 商談レコードタイプが「紙申込」の場合
                // ANPの値 = 既存のANPの値 + 生保申込み.申込保険料×12
                // - （更新前）生保申込み.申込保険料×12
                // + （更新後）生保申込み.申込保険料×12
                targetOpp.ANP__c = targetOpp.ANP__c - (oldfee * 12) + (fee * 12);
            }
        }
        else {
            // 商談.ANP = null の場合
            // 関連先商談の項目設定（ANP初回設定）
            // 商談レコードタイプが「紙申込」の場合
            // ANPの値 = 生保申込み.申込保険料×12
            // OR
            // 商談レコードタイプが「Web申込」の場合
            // ANPの値 = 生保申込み.Web申込保険料×12
            targetOpp.ANP__c = fee * 12;
        }
    }
    
    
    private void updateOtherClosedOpportunity(List<Opportunity> accOtherOppList, SeihoOpportunity__c seiho) {
        for(Opportunity targetOpp : accOtherOppList){
            // 商談ステータス
            targetOpp.StageName = '対応終了';
            // 完了予定日
            targetOpp.CloseDate = Date.newinstance(
                                        seiho.LastModifiedDate.year(), 
                                        seiho.LastModifiedDate.month(), 
                                        seiho.LastModifiedDate.day());
            // クローズ種別
            targetOpp.CloseType__c = '対応打ち切り';
            // クローズ理由
            targetOpp.CloseReason__c = '他商談にて対応';
            // 最新見込確度
            targetOpp.RecentProbability__c = '申込なし';
            // 最終見込確度
            // （更新前）商談．最終見込確度=''の場合
            if (String.IsBlank(targetOpp.LastProbability__c)) {
                targetOpp.LastProbability__c = '申込なし';
            }
        }
    }
    
    
    private void updateDraftOpportunity(Opportunity targetOpp, SeihoOpportunity__c seiho) {
        // 案件の生保レコードタイプIDを取得
        Id oppSeihoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Seiho').getRecordTypeId();
        // 関連先商談更新_申込途中保存
        // 商談の設定
        targetOpp.RecordTypeId = oppSeihoRecordTypeId;
        // 見込ANP
        if (String.isNotBlank(seiho.WebApplicationInsuFee__c) && 
            seiho.WebApplicationInsuFee__c.isNumeric()) {
            // 見込ANP
            targetOpp.EstimatedANP__c = Decimal.valueOf(seiho.WebApplicationInsuFee__c) * 12;
        }
        // 代理店名
        targetOpp.AgentName__c = seiho.AgentName__c;
        // 申込ステータス
        targetOpp.ApplySts__c = seiho.ApplySts__c;
    }
}