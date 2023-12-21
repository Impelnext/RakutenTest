/****************************************************************************************/
/* Class Name       : BatchSeihoAgentMasterLinkToAccount                                */
/* Description      : エージェント-取引先紐づけBatch                                    */
/* @Created Date    : 2021.02.12                                                        */
/* @Created By      : SRM - ONYX（マスタ-取引先関連付け対応）                           */
/* @Modified Date   :                                                                   */
/* @Modified By     :                                                                   */
/****************************************************************************************/
global class BatchSeihoAgentMasterLinkToAccount implements Schedulable,
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
    /* Method Name:    BatchSeihoAgentMasterLinkToAccount                        */
    /* Description:                                                              */
    /*****************************************************************************/
    public BatchSeihoAgentMasterLinkToAccount() {
    }
    
    /*****************************************************************************/
    /* Method Name:    start                                                     */
    /* Description:    start method of Batchable Interface                       */
    /*                 Forms SQL Query for Batch processing                      */
    /*****************************************************************************/
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String strSql  = 'SELECT Id, CS_ID__c, Account__c ';
               strSql += ' FROM  SeihoAgentMaster__c WHERE ';
               strSql += ' CSID_ChangeFlag__c = TRUE ';
               strSql += ' AND CS_ID__c != NULL ORDER BY CS_ID__c ASC';
        return Database.getQueryLocator(strSql);
    }
    
    /**********************************************************************************/
    /* Method Name:    execute                                                        */
    /* Description:    execute method of Batchable Interface,                         */
    /*                 Link the SeihoAgentMaster to Account                           */
    /**********************************************************************************/
    global void execute(Database.BatchableContext bc, SObject[] objList) {
        //200件ずつループしている。
        Map<ID, SeihoAgentMaster__c> seihoAgentMap = new Map<ID, SeihoAgentMaster__c>(
                                                            (List<SeihoAgentMaster__c>)objList);
        // Collect all NXNos to List
        // エージェントのNX番号の取得
        // 生保エージェントマスタ➡顧客番号（CSID）：CS_ID__c
        Set<String> nxNos = new Set<String>();
        for(SeihoAgentMaster__c seihoAgent : seihoAgentMap.values()) {
            if (String.IsNotBlank(seihoAgent.CS_ID__c)) {
                nxNos.add(seihoAgent.CS_ID__c);
            }
        }
        
        // 以下の順でNX番号が一致するレコードを検索し、
        // 一致する場合は取引先とエージェントオブジェクトに対し紐づけを行う
        // ・生保契約情報
        // ・取引先
        // ・生保申込み
        // NX番号とCRMIDでソート順
        Map<String, MasterHelper.MasterNXNo> mapAccounts = MasterHelper.getAllAccountsFromNXNumber(nxNos);
        // NX番号とCRMIDでソートして、最初の1件だけエージェント側を紐づけを行う
        for(SeihoAgentMaster__c seihoAgent : seihoAgentMap.values()) {
            seihoAgent.Account__c = (String.IsNotBlank(seihoAgent.CS_ID__c) && 
                                      mapAccounts.get(seihoAgent.CS_ID__c) != NULL) ? 
                                     mapAccounts.get(seihoAgent.CS_ID__c).getAccountID() : 
                                     NULL;
            // 顧客番号更新フラグをFALSEにリセットする
            seihoAgent.CSID_ChangeFlag__c = FALSE;
        }
        
        // 生保エージェントマスタを更新する
        if (!seihoAgentMap.isEmpty()) {
            Update seihoAgentMap.values();
        }
        
        // Update All Accounts related to SeihoAgentMaster List
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
                                                    MasterHelper.getAllAccountsToBeLinkedToSeihoAgent(nxAccountIds));
        
        // 既に生保エージェントマスタと紐付けである全ての取引先を取得
        Map<String, List<Account>> agentAccountMap = MasterHelper.getAllAccountsLinkedToSeihoAgent(seihoAgentMap.keyset());
        for (List<Account> agentAccounts : agentAccountMap.values()) {
            updateAccountMap.putAll(agentAccounts);
        }
        
        Map<Id, AccountHelper.AccountNXNo> accountNXNoMap = new Map<Id, AccountHelper.AccountNXNo>();
        for (Id accountId : updateAccountMap.keyset()) {
            accountNXNoMap.put(accountId, new AccountHelper.AccountNXNo());
        }
        // 全ての対象取引先を更新する
        MasterHelper.updateAccountsWithSeihoAgentInfo(updateAccountMap, accountNXNoMap);
    }
    
    /*****************************************************************************/
    /* Method Name:    finish                                                    */
    /* Description:    finish method of Batchable Interface                      */
    /*****************************************************************************/
    global void finish(Database.BatchableContext bc) {
    }
}