/*
* @Class Name      : AccountTriggerHandler 
* @Description     : 取引先トリガーハンドラ
* @Created Date    : 2019.05.16
* @Created By      : 
* @Modified Date   : 2020.01.08
* @Modified By     : Valsala Kumar
* @Modified Date   : 2020.06.10
* @Modified By     : SRM - ONYX
* @Modified Date   : 2021.02.15
* @Modified By     : SRM - ONYX（マスタ-取引先関連付け対応）
*/
public class AccountTriggerHandler {
    /**
     * コンストラクタ
     */
    public AccountTriggerHandler() {}
    
    /**
     * 取引先情報作成・更新前処理
     * @param List<Account>
     * @param Map<Id,Account>
     * @return 
     */
    public void onBeforeProcess(List<Account> accountList, Map<Id,Account> oldMap){
//      List<Id> accountIdList = new List<Id>();
        
        //取引先情報を格納するマップ
        List<SObject> mastersObj = new List<SObject>();
        Map<String,List<SObject>> accountMasterMap = new Map<String,List<SObject>>();
        
        for(Account account : accountList){
            
            account.SYSAccountName__c = '';
            if(String.isNotBlank(account.LastName__pc)){
                account.SYSAccountName__c = account.LastName__pc;
            }
            if(String.isNotBlank(account.firstname__pc)){
                account.SYSAccountName__c = account.SYSAccountName__c + account.firstname__pc;
            }
            if(String.isBlank(account.LastName__pc) && String.isBlank(account.firstname__pc) && String.isNotBlank(account.LastName)){
                account.SYSAccountName__c = account.SYSAccountName__c + account.LastName;
            }
            if(String.isBlank(account.LastName__pc) && String.isBlank(account.firstname__pc) && String.isNotBlank(account.FirstName)){
                account.SYSAccountName__c = account.SYSAccountName__c + account.FirstName;
            }
            if(String.isNotBlank(account.furiganaLast__pc)){
                account.SYSAccountName__c = account.SYSAccountName__c + account.furiganaLast__pc;
            }
            if(String.isNotBlank(account.furiganaForst__pc)){
                account.SYSAccountName__c = account.SYSAccountName__c + account.furiganaForst__pc;
            }
            account.SYSAccountName__c = account.SYSAccountName__c.deleteWhitespace();
//          if( account.Id != null ) {
//              accountIdList.add(account.Id);
//          }

            account.PersonalBirthText__c = '';
            if(account.PersonBirthdate != null){
                account.PersonalBirthText__c = Datetime.newInstance(
                                                    account.PersonBirthdate.year(),
                                                    account.PersonBirthdate.month(),
                                                    account.PersonBirthdate.day())
                                                    .format('yyyy-MM-dd');
            }
        }
        
        processHanshaFlg(accountList, oldMap);
        
        setHanshaUserUpdateDate(accountList, oldMap);
        
//      setUseFlag(accountList, accountIdList);
        
        // 架電禁止取引先判定
        processKadenKinshiAccount(accountList, oldMap);
    }
    
    
    /**
     * 取引先情報更新後処理
     * @param List<Account>
     * @param Map<Id,Account>
     * @return 
     */
    public void onAfterUpdateProcess(List<Account> accountList, Map<Id,Account> oldMap){
    
        // 全商談終了取引先判定
        Set<Id> closedAccountIds = new Set<Id>();
        for(Account account : accountList){
            if(oldMap != null
            && account.OpportunityStatus__c == '全商談終了'
            && oldMap.get(account.Id).OpportunityStatus__c != '全商談終了') {
                closedAccountIds.add(account.Id);
            }
        }
        
        // 関連するオープン中の商談を取得
        Map<Id, List<Opportunity>> openOppMap = new Map<Id, List<Opportunity>>();
        List<Opportunity> openOppList = [
                                            SELECT Id
                                                    , StageName
                                                    , RecentProbability__c
                                                    , CloseType__c
                                                    , CloseReason__c
                                                    , AccountId
                                                    , CloseDate
                                                FROM Opportunity
                                                WHERE AccountId IN :closedAccountIds
                                                AND StageName != '対応終了'
                                                AND CloseType__c = NULL
                                        ];
        for(Opportunity o : openOppList) {
            if (openOppMap.get(o.AccountId) == NULL) {
                List<Opportunity> lst = new List<Opportunity>();
                lst.add(o);
                openOppMap.put(o.AccountId, lst);
            }
            else {
                openOppMap.get(o.AccountId).add(o);
            }
        }
        
        // 商談更新値設定
        for(Account a : accountList){
            if (openOppMap.get(a.Id) != NULL) {
                List<Opportunity> oppList= openOppMap.get(a.Id);
                for (Opportunity o : oppList) {
                    // 商談ステータス
                    o.StageName = '対応終了';
                    // 最新見込確度
                    o.RecentProbability__c = '申込なし';
                    // クローズ種別
                    o.CloseType__c = '対応打ち切り';
                    // 取引先ステータスが架電禁止？
                    if(a.OperationType__c == '架電禁止') {
                        // 取引先.取引先ステータス = '架電禁止'の場合
                        // クローズ理由
                        o.CloseReason__c = '取引先架電禁止';
                    }
                    else {
                        // 取引先.取引先ステータス <> '架電禁止'の場合
                        // クローズ理由
                        o.CloseReason__c = '取引先対応終了';
                    }
                    // 完了予定日 = 取引先．最終更新日時
                    if(a.LastModifiedDate != null){
                        o.CloseDate = Date.newinstance(a.LastModifiedDate.year(),
                                                    a.LastModifiedDate.month(),
                                                    a.LastModifiedDate.day());
                    }
                }
            }
        }
        // 商談更新
        if (openOppList.size() > 0) update openOppList;
        }
        
    
//    /**
//     * 損保利用 / 少短利用 / 生保利用 / オープンケース有無 チェック
//     */
//    public void setUseFlag( List<account> accountList, List<Id> accountIdList ) {
//        Map<Id, Set<String> > childMap = new Map<Id, Set<String> >();
//        if( accountIdList.size() == 0 ) {
//            return;
//        }
//        List<account_useFlag__mdt> settingList = [SELECT Id, Object__c, relatedToField__c, updateTargetField__c FROM account_useFlag__mdt];
//        Map<String, String> objUpdateFieldMap = new Map<String, String>();
//        for( account_useFlag__mdt setting : settingList ) {
//            String query ='SELECT Id, AccountId__c ';
//            query += ' FROM ' + setting.Object__c;
//            query += ' WHERE ' + setting.relatedToField__c + ' IN :accountIdList';
//
//            for(SObject obj : Database.query(query) ) {
//                Id accId = (Id)obj.get(setting.relatedToField__c);
//                if( !childMap.containsKey(accId) ) {
//                    childMap.put(accId, new Set<String>());
//                }
//                childMap.get(accId).add(obj.getSObjectType().getDescribe().getName());
//            }
//            objUpdateFieldMap.put(setting.Object__c, setting.updateTargetField__c);
//        }
//
//        for( Account acc : accountList) {
//            if( childMap.containsKey(acc.Id) ) {
//                Set<String> relatedObjSet = childMap.get(acc.Id);
//                for( String relatedObj : relatedObjSet ) {
//                    acc.put(objUpdateFieldMap.get(relatedObj), objUpdateFieldMap.containsKey(relatedObj));
//                }
//            } else {
//                acc.DamageUse__pc = false;
//            }
//        }
//    }
    
    
    /*
        * 反社ユーザー更新日付更新処理
        */
    public void setHanshaUserUpdateDate(List<Account> accountList, Map<Id,Account> oldMap){
        
        for(Account account : accountList){
            if(oldMap == null){
                // 新規の場合
                if(account.HanshaList__c == '疑いなし' || account.HanshaList__c == '反社確定'){
                    account.HanshaUserUpdateDate__c = Datetime.now();  
                }
            }else{
                // 更新の場合
                Account oldAccount = oldMap.get(account.Id);
                //システム更新用の反社フラグが変わった場合
                if(account.HanshaSystemUpdateDate__c != oldAccount.HanshaSystemUpdateDate__c){
                    if(account.HANSHA_FLG__pc == '疑いあり'){
                        account.HanshaList__c = '未選択';
                    }
                }

                //ユーザ更新用の反社フラグが変わった場合
                if(account.HanshaList__c != oldAccount.HanshaList__c){
                    if(account.HanshaList__c != '未選択'){
                        account.HanshaUserUpdateDate__c = Datetime.now();
                    }else{
                        account.HanshaUserUpdateDate__c = Null;
                    }
                }
            }
        }
    }
    
    
    /*
    * 反社フラグ設定を行う
    */
    public void processHanshaFlg(List<Account> accountList, Map<Id,Account> oldMap){
        List<Account> targetList = new List<Account>();
        
        // 値変更された対応レコードを取得
        for(Account account : accountList){
            if(oldMap == null){
                // 新規の場合
                targetList.add(account);
            }else{
                // 更新の場合
                Account oldAccount = oldMap.get(account.Id);
                System.debug('FirstName:' + account.FirstName + ' ' + oldAccount.FirstName);
                System.debug('LastName:' + account.LastName + ' ' + oldAccount.LastName);
                System.debug('Gender__pc:' + account.Gender__pc + ' ' + oldAccount.Gender__pc);
                System.debug('PersonMailingState:' + account.PersonMailingState 
                                                        + ' ' + oldAccount.PersonMailingState);
                System.debug('PersonMailingCity:' + account.PersonMailingCity 
                                                        + ' ' + oldAccount.PersonMailingCity);
                System.debug('PersonMailingStreet:' + account.PersonMailingStreet 
                                                        + ' ' + oldAccount.PersonMailingStreet);
                System.debug('PersonBirthdate:' + account.PersonBirthdate + ' ' + oldAccount.PersonBirthdate);
                if(account.FirstName != oldAccount.FirstName
                    || account.LastName != oldAccount.LastName
                    || account.Gender__pc != oldAccount.Gender__pc
                    || account.PersonMailingState != oldAccount.PersonMailingState
                    || account.PersonMailingCity != oldAccount.PersonMailingCity
                    || account.PersonMailingStreet != oldAccount.PersonMailingStreet
                    || account.PersonBirthdate != oldAccount.PersonBirthdate){
                        
                    targetList.add(account);
                }
            }
        }
        
        List<String> targetAccountNames = new List<String>();
        for(Account account : targetList){
            targetAccountNames.add(getAccountName(account));
        }
        
        System.debug('targetAccountNames:' + targetAccountNames);
        
        // 反社マップ取得（key:取引先名、value:反社情報リスト）
        Map<String, List<HanshaInfo__c>> hanshaMap = getHanshaInfoMap(targetAccountNames);
        
        System.debug('hanshaMap:' + targetAccountNames);
        
        for(Account account : accountList){
            List<HanshaInfo__c> hanshaInfoList = hanshaMap.get(getAccountName(account));
            System.debug(account.LastName + ' ' + account.FirstName + ':' + hanshaInfoList);
            if(hanshaInfoList == null){
                continue;
            }
            for(HanshaInfo__c hanshaInfo : hanshaInfoList){
                
                if(isTargetAccount(account, hanshaInfo)){
                    account.HANSHA_FLG__pc = '疑いあり';
                    System.debug(account.HANSHA_FLG__pc);
                    Date hanshaDate = DateUtil.getDate1(hanshaInfo.No__c);
                    if(hanshaDate != null){
                        account.HanshaSystemUpdateDate__c = hanshaDate;
                    }
                }
            }
        }
        
    }
    
    // 架電禁止取引先判定
    private void processKadenKinshiAccount(List<Account> accountList, Map<Id,Account> oldMap){
        // 架電禁止の取引先？
        for(Account a : accountList) {
            if(a.StopCallingFlg__c
            || a.HANSHA_FLG__pc == '疑いあり'
            || a.HanshaList__c == '反社確定'
            || a.MeetingSalesflg__c
            || a.PastDataCalling__c
            || (a.PersonHomePhone == NULL
                && a.PersonMobilePhone == NULL)) {
                // 取引先ステータスセット
                // 取引先ステータス
                a.OperationType__c = '架電禁止';
                
                if(oldMap == null){
                    // 新規の場合
                    // 対応状況
                    a.OpportunityStatus__c = NULL;
                }
                else if(oldMap != null
                        && oldMap.get(a.Id).OpportunityStatus__c == NULL) {
                    // 更新前の取引先．対応状況 = nullの場合
                    a.OpportunityStatus__c = NULL;
                }
                else if(oldMap != null
                        && oldMap.get(a.Id).OpportunityStatus__c != NULL) {
                    // 更新前の取引先．対応状況 <> nullの場合
                    a.OpportunityStatus__c = '全商談終了';
                }
            }
            // 取引先ステータス更新（全商談終了）
            else if ((oldMap != null
                        && oldMap.get(a.Id).OperationType__c == '架電禁止') 
                        || a.OperationType__c == NULL) {
                // 取引先ステータスセット
                // 取引先ステータス
                a.OperationType__c = '有効商談なし';
                // 対応状況
                a.OpportunityStatus__c = '全商談終了';
            }
        }
    }
    
    public Boolean isTargetAccount(Account account, HanshaInfo__c hanshaInfo){
        
        System.debug('Gender__c:' + hanshaInfo.Gender__c + ' ' + account.Gender__pc);
        System.debug('Prefecture__c:' + hanshaInfo.Prefecture__c + ' ' + hanshaInfo.Prefecture__c);
        System.debug('PersonBirthdate:' + account.PersonBirthdate);
        
        if(hanshaInfo.Gender__c == account.Gender__pc &&
            isSamePrefecture(account, hanshaInfo.Prefecture__c) &&
            account.PersonBirthdate != null){
            
            Date nextYear = hanshaInfo.AssumeBirthdate__c.addYears(1);
            Date prevYear = hanshaInfo.AssumeBirthdate__c.addYears(-1);
                
            System.debug('account.PersonBirthdate:' + account.PersonBirthdate);
            if(account.PersonBirthdate >= prevYear && account.PersonBirthdate <= nextYear){
                return true;
            }
        }
        
        return false;
    }
    
    public Boolean isSamePrefecture(Account account, String prefecture){
        List<String> address = new List<String>();
        if(account.PersonMailingState != null) address.add(account.PersonMailingState);
        if(account.PersonMailingCity != null) address.add(account.PersonMailingCity);
        if(account.PersonMailingStreet != null) address.add(account.PersonMailingStreet);
        
        System.debug('address:' + String.join(address, '') + ' ' + prefecture);
        if(String.join(address, '').startsWith(prefecture)){
            return true;
        }else{
            return false;
        }
    }
    
    /*
    * 反社マップ取得（key:取引先名、value:反社情報リスト）
    */
    private Map<String, List<HanshaInfo__c>> getHanshaInfoMap(List<String> accountNames){
        
        List<HanshaInfo__c> hanshaList = [SELECT Id,No__c,Name__c,Gender__c,Prefecture__c,AssumeBirthdate__c
                                            FROM HanshaInfo__c
                                            WHERE Name__c IN :accountNames
                                            AND No__c != null
                                            AND Name__c != null
                                            AND Gender__c != null
                                            AND Prefecture__c != null
                                            AND AssumeBirthdate__c != null
                                            ORDER BY No__c ASC];
        
        Map<String, List<HanshaInfo__c>> hanshaMap = new Map<String, List<HanshaInfo__c>>();
        
        for(HanshaInfo__c hanshaInfo : hanshaList){
            List<HanshaInfo__c> mapList ;
            
            hanshaInfo.Name__c = hanshaInfo.Name__c.replaceAll('　', ' ');
            
            if(!hanshaMap.containsKey(hanshaInfo.Name__c)){
                mapList = new List<HanshaInfo__c>();
                hanshaMap.put(hanshaInfo.Name__c, mapList);
            }else{
                mapList = hanshaMap.get(hanshaInfo.Name__c);
            }
            
            mapList.add(hanshaInfo);
        }
        
        return hanshaMap;
        
    }
    
    /*
    * 取引先名取得
    */
    public String getAccountName(Account account){
        List<String> names = new List<String>();
        if(account.LastName != null) names.add(account.LastName);
        if(account.FirstName != null) names.add(account.FirstName);
        return String.join(names, ' ');
    }
}