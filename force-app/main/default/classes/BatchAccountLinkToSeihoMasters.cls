/****************************************************************************************/
/* Class Name       : BatchAccountLinkToSeihoMasters                                    */
/* Description      : 取引先-代理店、エージェント、募集人紐づけBatch                    */
/* @Created Date    : 2021.02.10                                                        */
/* @Created By      : SRM - ONYX（マスタ-取引先関連付け対応）                           */
/* @Modified Date   :                                                                   */
/* @Modified By     :                                                                   */
/****************************************************************************************/
global class BatchAccountLinkToSeihoMasters implements Schedulable,
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
    /* Method Name:    BatchAccountLinkToSeihoMasters                            */
    /* Description:                                                              */
    /*****************************************************************************/
    public BatchAccountLinkToSeihoMasters() {
    }
    
    /*****************************************************************************/
    /* Method Name:    start                                                     */
    /* Description:    start method of Batchable Interface                       */
    /*                 Forms SQL Query for Batch processing                      */
    /*****************************************************************************/
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // 取引先の取得
        // 本日更新分の取引先を取得する
        String strSql  = 'SELECT Id, CSID__pc, ';
               strSql += ' SeihoAgencyNo__c, SeihoAgencyMstId__c, ';
               strSql += ' SeihoRecruiterNo__c, SeihoRecruiterMstId__c, ';
               strSql += ' SeihoAgentID__c, SeihoAgentMstId__c, ';
               strSql += ' SeihoAccoutType__c ';
               strSql += ' FROM  Account WHERE ';
               strSql += ' LASTMODIFIEDDATE = TODAY ';
               strSql += ' ORDER BY CSID__pc ASC';
        return Database.getQueryLocator(strSql);
    }
    
    /**********************************************************************************/
    /* Method Name:    execute                                                        */
    /* Description:    execute method of Batchable Interface,                         */
    /*                 Link the Account to SeihoMasters                               */
    /**********************************************************************************/
    global void execute(Database.BatchableContext bc, SObject[] objList) {
        //200件ずつループしている。
        Map<Id, Account> accountMap = new Map<Id, Account>((List<Account>)objList);
        Map<Id, AccountHelper.AccountNXNo> accountNXNoMap = new Map<Id, AccountHelper.AccountNXNo>();
        for (Id accountId : accountMap.keyset()) {
            accountNXNoMap.put(accountId, new AccountHelper.AccountNXNo());
        }
        
        Boolean setAgency = TRUE;
        Boolean setRecruit = TRUE;
        Boolean setAgent = TRUE;
        
        // 以下の順でNX番号が一致するレコードを検索し、
        // 一致する場合は代理店、エージェント、募集人と取引先の関連付けを行う
        // ・生保契約情報
        // ・取引先
        // ・生保申込み
        AccountHelper.updateAccountsWithSeihoMasterInfo(accountMap, accountNXNoMap, setAgency, setRecruit, setAgent);
        
        // 関連付けを行う判定
        // 以下の順で取引先のNX番号が一致する全てのマスタレコードを検索し、
        // 一致する場合は取引先と代理店、エージェント、募集人の関連付けを行う
        // ・生保契約情報
        // ・取引先
        // ・生保申込み
        // 関連付けをクリア判定
        //  取引先と既存で紐付けであるマスタのNX番号は一致しない場合は、
        // 取引先と代理店、エージェント、募集人の関連付けをクリアする
        // Get SeihoMaster Records to be updated
        // Get NX Number from Account - LifeContract, Account and SiehoOpp
        // Get All SeihoMaster Records based on All NX Number
        // Get All SeihoMaster Records already linked to Account - Roll Back
        // Update All AgencyMaster with the Account Field Updated to latest or NULL
        AccountHelper.updateMastersWithAccountInfo(accountMap, accountNXNoMap);
    }
    
    /*****************************************************************************/
    /* Method Name:    finish                                                    */
    /* Description:    finish method of Batchable Interface                      */
    /*****************************************************************************/
    global void finish(Database.BatchableContext bc) {
    }
}