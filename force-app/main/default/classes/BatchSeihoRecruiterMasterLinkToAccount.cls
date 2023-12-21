/****************************************************************************************/
/* Class Name       : BatchSeihoRecruiterMasterLinkToAccount                            */
/* Description      : 募集人-取引先紐づけBatch                                          */
/* @Created Date    : 2021.02.12                                                        */
/* @Created By      : SRM - ONYX（マスタ-取引先関連付け対応）                           */
/* @Modified Date   :                                                                   */
/* @Modified By     :                                                                   */
/****************************************************************************************/
global class BatchSeihoRecruiterMasterLinkToAccount implements Schedulable,
                                        Database.Batchable<sObject>,
                                        Database.Stateful{
    
    /*****************************************************************************/
    /* Method Name:    execute                                                   */
    /* Description:    execute method of Schedulable Interface                   */
    /*****************************************************************************/
    global void execute(SchedulableContext sc) {
        database.executebatch(this);
    }
    
    /*****************************************************************************/
    /* Method Name:    BatchSeihoRecruiterMasterLinkToAccount                    */
    /* Description:                                                              */
    /*****************************************************************************/
    public BatchSeihoRecruiterMasterLinkToAccount() {
    }
    
    /*****************************************************************************/
    /* Method Name:    start                                                     */
    /* Description:    start method of Batchable Interface                       */
    /*                 Forms SQL Query for Batch processing                      */
    /*****************************************************************************/
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String strSql  = 'SELECT Id, CS_ID__c, Account__c ';
               strSql += ' FROM  SeihoRecruiterMaster__c WHERE ';
               strSql += ' CSID_ChangeFlag__c = TRUE ';
               strSql += ' AND CS_ID__c != NULL ORDER BY CS_ID__c ASC';
        return Database.getQueryLocator(strSql);
    }
    
    /**********************************************************************************/
    /* Method Name:    execute                                                        */
    /* Description:    execute method of Batchable Interface,                         */
    /*                 Link the SeihoRecruiterMaster to Account                       */
    /**********************************************************************************/
    global void execute(Database.BatchableContext bc, SObject[] objList) {
        //200件ずつループしている。
        Map<ID, SeihoRecruiterMaster__c> seihoRecruiterMap = new Map<ID, SeihoRecruiterMaster__c>(
                                                                    (List<SeihoRecruiterMaster__c>)objList);
        // Collect all NXNos to List
        // 募集人のNX番号の取得
        // 生保募集人マスタ➡顧客番号（CSID）：CS_ID__c
        Set<String> nxNos = new Set<String>();
        for(SeihoRecruiterMaster__c seihoRecruiter : seihoRecruiterMap.values()) {
            if (String.IsNotBlank(seihoRecruiter.CS_ID__c)) {
                nxNos.add(seihoRecruiter.CS_ID__c);
            }
        }
        
        // 以下の順でNX番号が一致するレコードを検索し、
        // 一致する場合は取引先と募集人オブジェクトに対し紐づけを行う
        // ・生保契約情報
        // ・取引先
        // ・生保申込み
        // NX番号とCRMIDでソート順
        Map<String, MasterHelper.MasterNXNo> mapAccounts = MasterHelper.getAllAccountsFromNXNumber(nxNos);
        // NX番号とCRMIDでソートして、最初の1件だけ募集人側を紐づけを行う
        for(SeihoRecruiterMaster__c seihoRecruiter : seihoRecruiterMap.values()) {
            seihoRecruiter.Account__c = (String.IsNotBlank(seihoRecruiter.CS_ID__c) && 
                                          mapAccounts.get(seihoRecruiter.CS_ID__c) != NULL) ? 
                                         mapAccounts.get(seihoRecruiter.CS_ID__c).getAccountID() : 
                                         NULL;
            // 顧客番号更新フラグをFALSEにリセットする
            seihoRecruiter.CSID_ChangeFlag__c = FALSE;
        }
        
        // 生保募集人マスタを更新する
        if (!seihoRecruiterMap.isEmpty()) {
            Update seihoRecruiterMap.values();
        }
        
        // Update All Accounts related to SeihoRecruiterMaster List
        // NX番号で一致する生保契約、取引先、生保申込みの順で
        // 紐付け先の全ての取引先を取得
        Set<ID> nxAccountIds = new Set<ID>();
        for (String nxNo : mapAccounts.keyset()) {
            if (mapAccounts.get(nxNo) != NULL) {
                nxAccountIds.addAll(mapAccounts.get(nxNo).accountIDs.values());
            }
        }
        
        // 更新対象の取引先を取得
        Map<ID, Account> updateAccountMap = new Map<ID, Account>(
                                                    MasterHelper.getAllAccountsToBeLinkedToSeihoRecruit(nxAccountIds));
        
        // 既に生保募集人マスタと紐付けである全ての取引先を取得
        Map<String, List<Account>> recruitAccountMap = MasterHelper.getAllAccountsLinkedToSeihoRecruit(seihoRecruiterMap.keyset());
        for (List<Account> recruitAccounts : recruitAccountMap.values()) {
            updateAccountMap.putAll(recruitAccounts);
        }
        
        Map<Id, AccountHelper.AccountNXNo> accountNXNoMap = new Map<Id, AccountHelper.AccountNXNo>();
        for (Id accountId : updateAccountMap.keyset()) {
            accountNXNoMap.put(accountId, new AccountHelper.AccountNXNo());
        }
        // 全ての対象取引先を更新する
        MasterHelper.updateAccountsWithSeihoRecruitInfo(updateAccountMap, accountNXNoMap);
    }
    
    /*****************************************************************************/
    /* Method Name:    finish                                                    */
    /* Description:    finish method of Batchable Interface                      */
    /*****************************************************************************/
    global void finish(Database.BatchableContext bc) {
    }
}