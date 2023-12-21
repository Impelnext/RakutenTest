/*
* @Class Name      : CommonUtility 
* @Description     : CommonUtilityハンドラ
* @Created Date    : 2020.05.08
* @Created By      : Valsala Kumar J
* @Modified Date   : 
* @Modified        : 
*/
public class CommonUtility {
    
    /**
     * 取引先作成/更新処理
     * @param List<AccountInfo> 作成/更新元となる情報
     * @return List<Account> 作成/更新取引先
     */
    public List<Account> getAccounts(List<AccountInfo> srcList) {
        
        //作成情報格納用List
        List<Account> targetAccountList = new List<Account>();
        
        // 取引先の作成または更新
        Id accountPersonRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        
        // 取引先IDセット
        Set<String> refAccIdList = new Set<String>();
        // 姓名情報セット Name information set
        Set<String> nameInfoList = new Set<String>();
        // Accountを繰り返し Repeat Account
        for(AccountInfo src : srcList){
            //手作成の場合、取引先が設定されている場合
            if(src.accountId != null){
               refAccIdList.add(src.accountId);
            }
            else{
                // 姓名情報に空欄がない場合
                if(String.isNotBlank(src.nameInfo)){
                    //氏名のキー情報を作成
                    String tmpName = src.nameInfo;
                    tmpName = tmpName.deleteWhitespace();
                    nameInfoList.add(tmpName);
                }
            }
        }
        
        // 既存の取引先を取得(取引先IDベース)
        Map<String,Account> existRefAccountMap = new Map<String,Account>();
        for(Account acc : [SELECT Id, SYSAccountName__c, 
                                    LastName, LastName__pc, FirstName, firstname__pc,
                                    furiganaLast__pc, furiganaForst__pc, 
                                    PersonBirthdate, Gender__pc, PersonEmail, 
                                    PersonMailingPostalCode, PersonMailingState, 
                                    PersonMailingCity, PersonMailingStreet, 
                                    PersonHomePhone, PersonMobilePhone
                            FROM Account 
                            WHERE Id IN :refAccIdList]){
            existRefAccountMap.put(acc.Id, acc);
        }
        // 既存の取引先を取得(姓名情報ベース)
        Map<String,List<Account>> existNameInfoAccountMap = new Map<String,List<Account>>();
        for(Account acc :  [SELECT Id, SYSAccountName__c, 
                                    LastName, LastName__pc, FirstName, firstname__pc,
                                    furiganaLast__pc, furiganaForst__pc, 
                                    PersonBirthdate, Gender__pc, PersonEmail, 
                                    PersonMailingPostalCode, PersonMailingState, 
                                    PersonMailingCity, PersonMailingStreet, 
                                    PersonHomePhone, PersonMobilePhone
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
        Map<Id, Account> updateAccMap = new Map<Id, Account>();
        
        // Account情報全件繰り返し
        for(AccountInfo src : srcList){
            Account targetAccount = NULL;
            String nameInfo = '';
            // 手作成の場合、取引先が設定されている場合、名寄せ処理しない
            if(src.accountId != null){
                targetAccount = existRefAccountMap.get(src.accountId);
            }
            // 取引先が設定されている場合
            if(targetAccount == NULL){
                // 姓名情報に空欄がない場合
                if(String.isNotBlank(src.nameInfo)){
                    //氏名のキー情報作成
                    nameInfo = src.nameInfo;
                    nameInfo = nameInfo.deleteWhitespace();
                    // 姓名情報が一致するレコードを繰り返す
                    List<Account> accList = existNameInfoAccountMap.get(nameInfo);
                    if(accList <> NULL){
                        for(Account acc : existNameInfoAccountMap.get(nameInfo)){
                            // 固定電話番号か携帯電話番号のいずれか一致する
                            if((acc.PersonHomePhone<>NULL && ((src.homephone<>NULL && src.homephone.replace('-','').equals(acc.PersonHomePhone.replace('-',''))) 
                                                            || (src.mobilephone<>NULL && src.mobilephone.replace('-','').equals(acc.PersonHomePhone.replace('-','')))))
                              || (acc.PersonMobilePhone<>NULL && ((src.homephone<>NULL && src.homephone.replace('-','').equals(acc.PersonMobilePhone.replace('-',''))) 
                                                              || (src.mobilephone<>NULL && src.mobilephone.replace('-','').equals(acc.PersonMobilePhone.replace('-','')))))){
                                
                                // ソースに関連する取引先の更新
                                targetAccount = acc;
                                break;
                            }
                            // 生年月日かつ性別が一致する
                            else if(src.birthdate == acc.PersonBirthdate
                                    && (src.gender <> Null && src.gender.equals(acc.Gender__pc))){
                                // ソースに関連する取引先の更新
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
                initializeAccountInfo(targetAccount);
                setAccountInfo(targetAccount, src);
                insertAccList.add(targetAccount);
                if(String.isNotBlank(src.nameInfo)){
                    //氏名のキー情報作成
                    nameInfo = src.nameInfo;
                    nameInfo = nameInfo.deleteWhitespace();
                    List<Account> accList = existNameInfoAccountMap.get(nameInfo);
                    if(accList == null){
                        accList = new List<Account>();
                    }
                    accList.add(targetAccount);
                    existNameInfoAccountMap.put(nameInfo, accList);
                }
            }
            else if(targetAccount.Id != NULL && 
                    src.toUpdate) {
                setAccountInfo(targetAccount, src);
                updateAccMap.put(targetAccount.Id, targetAccount);
            }
            targetAccountList.add(targetAccount);
        }
        
        // Insert New Accounts
        if (insertAccList != NULL && insertAccList.size() > 0)
            insert insertAccList;
        // Update Old Accounts
        if (updateAccMap != NULL && updateAccMap.size() > 0)
            update updateAccMap.values();
        
        return targetAccountList;
    }
    
    
    private void initializeAccountInfo(Account target) {
        // 顧客区分
        target.division__pc = '見込み顧客';
        // 取引先ステータス
        target.OperationType__c = '割当可';
        // 対応状況
        target.OpportunityStatus__c = '未対応';
    }
    
    
    /**
     * 取引先作成/更新処理
     * @param Account 作成/更新対象取引先
     * @param AccountInfo 作成/更新元となる情報
     * @return 
     */
    private void setAccountInfo(Account target , AccountInfo src){
        // 姓名情報
        inputName(target, src);
        // 生年月日
        target.PersonBirthdate = src.birthdate;
        // 性別
        target.Gender__pc = src.gender;
        // 楽天会員ID
        target.easyId__pc = src.easyId;
        // メール
        target.PersonEmail = src.email;
        // 住所情報
        inputAddress(target, src);
        // 連絡先情報
        target.Phone = src.internalphone;
        target.PersonHomePhone = src.homephone;
        target.PersonMobilePhone = src.mobilephone;
        // Other Field Values
        if (src.params != NULL && src.params.size() > 0) {
            Map<String, Schema.sObjectfield> fielMap = Schema.sObjectType.Account.fields.getMap();
            for (String fieldapi : src.params.keyset()) {
                String value = src.params.get(fieldapi);
                Schema.DescribeFieldResult dfr = fielMap.get(fieldapi).getDescribe();
                Schema.DisplayType type = dfr.getType();
                if (type == Schema.DisplayType.Integer)
                    target.put(fieldapi, Integer.valueof(value));
                else if (type == Schema.DisplayType.Boolean)
                    target.put(fieldapi, Boolean.valueof(value));
                else if (type == Schema.DisplayType.Currency)
                    target.put(fieldapi, Decimal.valueof(value));
                else if (type == Schema.DisplayType.Percent)
                    target.put(fieldapi, Decimal.valueof(value));
                else if (type == Schema.DisplayType.Double)
                    target.put(fieldapi, Double.valueof(value));
                else if (type == Schema.DisplayType.Date)
                    target.put(fieldapi, Date.valueof(value)); // yyyy-MM-dd (Local)
                else if (type == Schema.DisplayType.DateTime)
                    target.put(fieldapi, DateTime.valueof(value)); // yyyy-MM-dd HH:mm:ss (Local)
                else
                    target.put(fieldapi, value);
            }
        }
    }
    
    
    private void inputAddress( Account target , AccountInfo src ) {
        // 住所情報
        if(src.postalcode != NULL && src.postalcode.length() > 20){
            target.PersonMailingPostalCode = src.postalcode.left(20);
        }else{
            target.PersonMailingPostalCode = src.postalcode;
        }
        if(src.state != NULL && src.state.length() > 80){
            target.PersonMailingState = src.state.left(80);
        }else{
            target.PersonMailingState = src.state;
        }
        if(src.city != NULL && src.city.length() > 40){
            target.PersonMailingCity = src.city.left(40);
        }else{
            target.PersonMailingCity = src.city;
        }
        if(src.street != NULL && src.street.length() > 255){
            target.PersonMailingStreet = src.street.left(255);
        }else{
            target.PersonMailingStreet = src.street;
        }
    }
    
    
    private void inputName( Account target , AccountInfo src ) {
        // 姓名情報
        if(src.lastname <> Null){
            if(src.lastname.length() > 40){
                target.LastName = src.lastname.left(40);
                target.LastName__pc = src.lastname.left(40);
            }else{
                target.LastName = src.lastname;
                target.LastName__pc = src.lastname;
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
        if(src.firstname <> Null){
            if(src.firstname.length() > 40){
                target.FirstName = src.firstname.left(40);
                target.firstname__pc = src.firstname.left(40);
            }else{
                target.FirstName = src.firstname;
                target.firstname__pc = src.firstname;
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
        if( !String.isEmpty(src.lastnamekana) ) {
            target.furiganaLast__pc = src.lastnamekana;
        }
        if( !String.isEmpty(src.firstnamekana) ) {
            target.furiganaForst__pc = src.firstnamekana;
        }
    }
}