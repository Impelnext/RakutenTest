/****************************************************************************************/
/* Class Name       : BatchSeihoAgencyMasterLinkToAccount                               */
/* Description      : 代理店-取引先紐づけBatch                                          */
/* @Created Date    : 2021.02.12                                                        */
/* @Created By      : SRM - ONYX（マスタ-取引先関連付け対応）                           */
/* @Modified Date   :                                                                   */
/* @Modified By     :                                                                   */
/****************************************************************************************/
global class BatchSeihoAgencyMasterLinkToAccount implements Schedulable,
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
    /* Method Name:    BatchSeihoAgencyMasterLinkToAccount                       */
    /* Description:                                                              */
    /*****************************************************************************/
    public BatchSeihoAgencyMasterLinkToAccount() {
    }
    
    /*****************************************************************************/
    /* Method Name:    start                                                     */
    /* Description:    start method of Batchable Interface                       */
    /*                 Forms SQL Query for Batch processing                      */
    /*****************************************************************************/
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String strSql  = 'SELECT Id, csid__c, Account__c ';
               strSql += ' FROM  SeihoAgencyMaster__c WHERE ';
               strSql += ' CSID_ChangeFlag__c = TRUE ';
               strSql += ' AND csid__c != NULL ORDER BY csid__c ASC';
        return Database.getQueryLocator(strSql);
    }
    
    /**********************************************************************************/
    /* Method Name:    execute                                                        */
    /* Description:    execute method of Batchable Interface,                         */
    /*                 Link the SiehoAgencyMaster to Account                          */
    /**********************************************************************************/
    global void execute(Database.BatchableContext bc, SObject[] objList) {
        //200件ずつループしている。
        Map<ID, SeihoAgencyMaster__c> seihoAgencyMap = new Map<ID, SeihoAgencyMaster__c>(
                                                                (List<SeihoAgencyMaster__c>)objList);
        // Collect all NXNos to List
        // 代理店のNX番号の取得
        // 生保代理店マスタ➡顧客番号(CSID)：csid__c
        Set<String> nxNos = new Set<String>();
        for(SeihoAgencyMaster__c seihoAgency : seihoAgencyMap.values()) {
            if (String.IsNotBlank(seihoAgency.csid__c)) {
                nxNos.add(seihoAgency.csid__c);
            }
        }
        
        // 以下の順でNX番号が一致するレコードを検索し、
        // 一致する場合は取引先と代理店オブジェクトに対し紐づけを行う
        // ・生保契約情報
        // ・取引先
        // ・生保申込み
        // NX番号とCRMIDでソート順
        Map<String, MasterHelper.MasterNXNo> mapAccounts = MasterHelper.getAllAccountsFromNXNumber(nxNos);
        // NX番号とCRMIDでソートして、最初の1件だけ代理店側を紐づけを行う
        for(SeihoAgencyMaster__c seihoAgency : seihoAgencyMap.values()) {
            seihoAgency.Account__c = (String.IsNotBlank(seihoAgency.csid__c) && 
                                      mapAccounts.get(seihoAgency.csid__c) != NULL) ? 
                                     mapAccounts.get(seihoAgency.csid__c).getAccountID() : 
                                     NULL;
            // 顧客番号更新フラグをFALSEにリセットする
            seihoAgency.CSID_ChangeFlag__c = FALSE;
        }
        
        // 生保代理店マスタを更新する
        if (!seihoAgencyMap.isEmpty()) {
            Update seihoAgencyMap.values();
        }
        
        // Update All Accounts related to SeihoAgencyMaster List
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
                                                    MasterHelper.getAllAccountsToBeLinkedToSeihoAgency(nxAccountIds));
        
        // 既に生保代理店マスタと紐付けである全ての取引先を取得
        Map<String, List<Account>> agencyAccountMap = MasterHelper.getAllAccountsLinkedToSeihoAgency(seihoAgencyMap.keyset());
        for (List<Account> agencyAccounts : agencyAccountMap.values()) {
            updateAccountMap.putAll(agencyAccounts);
        }
        
        Map<Id, AccountHelper.AccountNXNo> accountNXNoMap = new Map<Id, AccountHelper.AccountNXNo>();
        for (Id accountId : updateAccountMap.keyset()) {
            accountNXNoMap.put(accountId, new AccountHelper.AccountNXNo());
        }
        // 全ての対象取引先を更新する
        MasterHelper.updateAccountsWithSeihoAgencyInfo(updateAccountMap, accountNXNoMap);
    }
    
    /*****************************************************************************/
    /* Method Name:    finish                                                    */
    /* Description:    finish method of Batchable Interface                      */
    /*****************************************************************************/
    global void finish(Database.BatchableContext bc) {
    }
}