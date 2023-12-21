/*
* @Class Name      : MasterHelper
* @Description     : マスタヘルパー
* @Created Date    : 2020.05.27
* @Created By      : SRM
* @Modified Date   : 2021.02.11
* @Modified By     : SRM - ONYX（マスタ-取引先関連付け対応）
*/
public class MasterHelper {

    /**
     * コンストラクタ
     */
    public MasterHelper() {}
    
    
    /**
     * getAccountsFromCSID
     * Get Accounts based on CSID key
     * @param List<String>
     * @return Map<String, Account>
     */
   public static Map<String, Account> getAccountsFromCSID(List<String> csIds) {
        Map<String, Account> mapAccounts = new Map<String, Account>();
        if (csIds != NULL && csIds.size() > 0) {
            List<Account> accList = [
                                         SELECT Id,
                                                CSID__pc,
                                                CRMID__c,
                                                seihoAccoutType__c,
                                                seihoAgencyNo__c,
                                                seihoRecruiterNo__c,
                                                seihoAgencyMstId__c
                                           FROM Account
                                          WHERE CSID__pc IN :csIds 
                                       ORDER BY CSID__pc, CRMID__c
                                    ];
            
            for (Account acc : accList) {
                // First CRMID will be Set to Map
                // the Next CRMIDs will not be updated to Map
                if (String.IsNotBlank(acc.CSID__pc) && 
                    mapAccounts.get(acc.CSID__pc) == NULL) {
                    mapAccounts.put(acc.CSID__pc, acc);
                }
            }
        }
        return mapAccounts;
    }
    
    
    /**
     * getAllAccountsFromCSID
     * Get All Accounts based on CSID key
     * @param List<String>
     * @return Map<String, List<Account>>
     */
   public static Map<String, List<Account>> getAllAccountsFromCSID(Set<String> csIds) {
        Map<String, List<Account>> mapAllAccounts = new Map<String, List<Account>>();
        if (csIds != NULL && csIds.size() > 0) {
            List<Account> accList = [
                                         SELECT Id,
                                                CSID__pc,
                                                CRMID__c,
                                                seihoAccoutType__c,
                                                seihoAgencyNo__c,
                                                seihoRecruiterNo__c,
                                                seihoAgencyMstId__c
                                           FROM Account
                                          WHERE CSID__pc IN :csIds 
                                       ORDER BY CSID__pc, CRMID__c
                                    ];
            
            for (Account acc : accList) {
                // All Accounts based on CRMID are added to Map
                if (String.IsNotBlank(acc.CSID__pc)) {
                    if (mapAllAccounts.get(acc.CSID__pc) == NULL) {
                        mapAllAccounts.put(acc.CSID__pc, new List<Account>{acc});
                    }
                    else {
                        mapAllAccounts.get(acc.CSID__pc).add(acc);
                    }
                }
            }
        }
        return mapAllAccounts;
    }
    
    /**
     * getAllAccountsLinkedToSeihoAgency
     * Get All Accounts based on 生保代理店マスタID Key
     * @param List<String>
     * @return Map<String, List<Account>>
     */
   public static Map<String, List<Account>> getAllAccountsLinkedToSeihoAgency(Set<ID> agencyIds) {
        Map<String, List<Account>> mapAllAccounts = new Map<String, List<Account>>();
        if (agencyIds != NULL && agencyIds.size() > 0) {
            List<Account> accList = [
                                         SELECT Id,
                                                CSID__pc,
                                                CRMID__c,
                                                SeihoAccoutType__c,
                                                SeihoAgencyNo__c,
                                                SeihoAgencyMstId__c
                                           FROM Account
                                          WHERE SeihoAgencyMstId__c IN :agencyIds
                                            AND SeihoAgencyMstId__c != NULL
                                       ORDER BY SeihoAgencyMstId__c, CRMID__c
                                    ];
            
            for (Account acc : accList) {
                // All Accounts based on 生保代理店マスタID are added to Map
                if (String.IsNotBlank(acc.SeihoAgencyMstId__c)) {
                    if (mapAllAccounts.get(acc.SeihoAgencyMstId__c) == NULL) {
                        mapAllAccounts.put(acc.SeihoAgencyMstId__c, new List<Account>{acc});
                    }
                    else {
                        mapAllAccounts.get(acc.SeihoAgencyMstId__c).add(acc);
                    }
                }
            }
        }
        return mapAllAccounts;
    }
    
    /**
     * getAllAccountsLinkedToSeihoAgent
     * Get All Accounts based on 生保エージェントマスタID Key
     * @param List<String>
     * @return Map<String, List<Account>>
     */
   public static Map<String, List<Account>> getAllAccountsLinkedToSeihoAgent(Set<ID> agentIds) {
        Map<String, List<Account>> mapAllAccounts = new Map<String, List<Account>>();
        if (agentIds != NULL && agentIds.size() > 0) {
            List<Account> accList = [
                                         SELECT Id,
                                                CSID__pc,
                                                CRMID__c,
                                                SeihoAccoutType__c,
                                                SeihoAgentID__c,
                                                SeihoAgentMstId__c
                                           FROM Account
                                          WHERE SeihoAgentMstId__c IN :agentIds
                                            AND SeihoAgentMstId__c != NULL
                                       ORDER BY SeihoAgentMstId__c, CRMID__c
                                    ];
            
            for (Account acc : accList) {
                // All Accounts based on 生保エージェントマスタID are added to Map
                if (String.IsNotBlank(acc.SeihoAgentMstId__c)) {
                    if (mapAllAccounts.get(acc.SeihoAgentMstId__c) == NULL) {
                        mapAllAccounts.put(acc.SeihoAgentMstId__c, new List<Account>{acc});
                    }
                    else {
                        mapAllAccounts.get(acc.SeihoAgentMstId__c).add(acc);
                    }
                }
            }
        }
        return mapAllAccounts;
    }
    
    /**
     * getAllAccountsLinkedToSeihoRecruit
     * Get All Accounts based on 生保募集人マスタID Key
     * @param List<String>
     * @return Map<String, List<Account>>
     */
   public static Map<String, List<Account>> getAllAccountsLinkedToSeihoRecruit(Set<ID> recruitIds) {
        Map<String, List<Account>> mapAllAccounts = new Map<String, List<Account>>();
        if (recruitIds != NULL && recruitIds.size() > 0) {
            List<Account> accList = [
                                         SELECT Id,
                                                CSID__pc,
                                                CRMID__c,
                                                SeihoAccoutType__c,
                                                SeihoRecruiterNo__c,
                                                SeihoRecruiterMstId__c
                                           FROM Account
                                          WHERE SeihoRecruiterMstId__c IN :recruitIds
                                            AND SeihoRecruiterMstId__c != NULL
                                       ORDER BY SeihoRecruiterMstId__c, CRMID__c
                                    ];
            
            for (Account acc : accList) {
                // All Accounts based on 生保募集人マスタID are added to Map
                if (String.IsNotBlank(acc.SeihoRecruiterMstId__c)) {
                    if (mapAllAccounts.get(acc.SeihoRecruiterMstId__c) == NULL) {
                        mapAllAccounts.put(acc.SeihoRecruiterMstId__c, new List<Account>{acc});
                    }
                    else {
                        mapAllAccounts.get(acc.SeihoRecruiterMstId__c).add(acc);
                    }
                }
            }
        }
        return mapAllAccounts;
    }
    
    /**
     * getAllAccountsToBeLinkedToSeihoAgency
     * Get All Accounts based on AccountID
     * @param Set<ID>
     * @return List<Account>
     */
   public static List<Account> getAllAccountsToBeLinkedToSeihoAgency(Set<ID> accountIds) {
        List<Account> accList = new List<Account>();
        if (accountIds != NULL && accountIds.size() > 0) {
            accList = [
                             SELECT Id,
                                    CSID__pc,
                                    CRMID__c,
                                    SeihoAccoutType__c,
                                    SeihoAgencyNo__c,
                                    SeihoAgencyMstId__c
                               FROM Account
                              WHERE ID IN :accountIds
                      ];
        }
        return accList;
    }
    
    /**
     * getAllAccountsToBeLinkedToSeihoAgent
     * Get All Accounts based on AccountID
     * @param Set<ID>
     * @return List<Account>
     */
   public static List<Account> getAllAccountsToBeLinkedToSeihoAgent(Set<ID> accountIds) {
        List<Account> accList = new List<Account>();
        if (accountIds != NULL && accountIds.size() > 0) {
            accList = [
                             SELECT Id,
                                    CSID__pc,
                                    CRMID__c,
                                    SeihoAccoutType__c,
                                    SeihoAgentID__c,
                                    SeihoAgentMstId__c
                               FROM Account
                              WHERE ID IN :accountIds
                      ];
        }
        return accList;
    }
    
    /**
     * getAllAccountsToBeLinkedToSeihoRecruit
     * Get All Accounts based on AccountID
     * @param Set<ID>
     * @return List<Account>
     */
   public static List<Account> getAllAccountsToBeLinkedToSeihoRecruit(Set<ID> accountIds) {
        List<Account> accList = new List<Account>();
        if (accountIds != NULL && accountIds.size() > 0) {
            accList = [
                             SELECT Id,
                                    CSID__pc,
                                    CRMID__c,
                                    SeihoAccoutType__c,
                                    SeihoRecruiterNo__c,
                                    SeihoRecruiterMstId__c
                               FROM Account
                              WHERE ID IN :accountIds
                      ];
        }
        return accList;
    }
    
    /**
     * updateAccountsWithSeihoAgencyInfo
     * Update Related Accounts With SiehoAgencyInfo
     * @param Map<ID, Account>
     * @return void
     */
    public static void updateAccountsWithSeihoAgencyInfo( Map<ID, Account> accountMap,
                                                          Map<Id, AccountHelper.AccountNXNo> accountNXNoMap ) {
        Boolean setAgency = TRUE;
        Boolean setRecruit = FALSE;
        Boolean setAgent = FALSE;
        
        // 以下の順でNX番号が一致するレコードを検索し、
        // 一致する場合は代理店、エージェント、募集人と取引先の関連付けを行う
        // ・生保契約情報
        // ・取引先
        // ・生保申込み
        AccountHelper.updateAccountsWithSeihoMasterInfo(accountMap, accountNXNoMap, setAgency, setRecruit, setAgent);
    }
    
    /**
     * updateAccountsWithSeihoRecruitInfo
     * Update Related Accounts With SiehoRecruitInfo
     * @param Map<ID, Account>
     * @return void
     */
    public static void updateAccountsWithSeihoRecruitInfo( Map<ID, Account> accountMap,
                                                           Map<Id, AccountHelper.AccountNXNo> accountNXNoMap ) {
        Boolean setAgency = FALSE;
        Boolean setRecruit = TRUE;
        Boolean setAgent = FALSE;
        
        // 以下の順でNX番号が一致するレコードを検索し、
        // 一致する場合は代理店、エージェント、募集人と取引先の関連付けを行う
        // ・生保契約情報
        // ・取引先
        // ・生保申込み
        AccountHelper.updateAccountsWithSeihoMasterInfo(accountMap, accountNXNoMap, setAgency, setRecruit, setAgent);
    }
    
    /**
     * updateAccountsWithSeihoAgentInfo
     * Update Related Accounts With SiehoAgentInfo
     * @param Map<ID, Account>
     * @return void
     */
    public static void updateAccountsWithSeihoAgentInfo( Map<ID, Account> accountMap,
                                                         Map<Id, AccountHelper.AccountNXNo> accountNXNoMap ) {
        Boolean setAgency = FALSE;
        Boolean setRecruit = FALSE;
        Boolean setAgent = TRUE;
        
        // 以下の順でNX番号が一致するレコードを検索し、
        // 一致する場合は代理店、エージェント、募集人と取引先の関連付けを行う
        // ・生保契約情報
        // ・取引先
        // ・生保申込み
        AccountHelper.updateAccountsWithSeihoMasterInfo(accountMap, accountNXNoMap, setAgency, setRecruit, setAgent);
    }
    
    /**
     * getAllAccountsFromNXNumber
     * Get All Account IDs based on NXNumber (CSID key)
     * 以下の順でNX番号が一致するレコードを検索し、
     * 一致する場合は取引先と代理店、募集人、エージェントの
     * 3オブジェクトに対し紐づけを行う
     * ・生保契約情報
     * ・取引先
     * ・生保申込み
     * @param Set<String>
     * @return Map<String, MasterNXNo>
     */
    public static Map<String, MasterNXNo> getAllAccountsFromNXNumber( Set<String> nxNos ) {
        Map<String, MasterNXNo> mapAccounts = new Map<String, MasterNXNo>();
        if (nxNos != NULL && nxNos.size() > 0) {
            
            // 生保契約情報の取得
            // 代理店のNX番号と一致する生保契約情報を抽出する
            // 生保契約情報➡顧客番号（CSID）：CSID__c
            List<LifeContract__c> lfcList = [
                                                 SELECT Id,
                                                        CSID__c,
                                                        AccountId__c,
                                                        AccountId__r.CRMID__c
                                                   FROM LifeContract__c
                                                  WHERE CSID__c IN :nxNos
                                                    AND CSID__c != NULL
                                                    AND AccountId__c != NULL
                                               ORDER BY CSID__c,
                                                        AccountId__r.CRMID__c
                                            ];
            // 代理店の関連付け
            // 生保契約情報に関連する取引先と代理店の関連付けを行う
            for (LifeContract__c lfc : lfcList) {
                // All Account IDs based on 生保契約情報 - 顧客番号 are added to Map
                // NX番号とCRMIDでソート順
                if (String.IsNotBlank(lfc.CSID__c) && 
                    String.IsNotBlank(lfc.AccountId__c) && 
                    String.IsNotBlank(lfc.AccountId__r.CRMID__c)) {
                    MasterNXNo masterInfo = NULL;
                    if (mapAccounts.get(lfc.CSID__c) == NULL) {
                        masterInfo = new MasterNXNo();
                        masterInfo.NXNo = lfc.CSID__c;
                    }
                    else {
                        masterInfo = mapAccounts.get(lfc.CSID__c);
                    }
                    masterInfo.accountCRMIDs.add(lfc.AccountId__r.CRMID__c);
                    masterInfo.accountIDs.put(lfc.AccountId__r.CRMID__c, lfc.AccountId__c);
                    mapAccounts.put(lfc.CSID__c, masterInfo);
                }
            }
            
            // 取引先NX番号 - 代理店関連付け
            // 関連済みを削除したリストからNX番号が一致する取引先を抽出す
            // 取引先➡顧客番号（CSID）：CSID__pc
            List<Account> accList = [
                                         SELECT Id,
                                                CSID__pc,
                                                CRMID__c
                                           FROM Account
                                          WHERE CSID__pc IN :nxNos
                                            AND CSID__pc != NULL
                                       ORDER BY CSID__pc,
                                                CRMID__c
                                    ];
            // 代理店の関連付け
            // NX番号が一致する取引先と代理店の関連付けを行う
            for (Account acc : accList) {
                // All Account IDs based on 取引先 - 顧客番号 are added to Map
                // NX番号とCRMIDでソート順
                if (String.IsNotBlank(acc.CSID__pc) && 
                    String.IsNotBlank(acc.Id) && 
                    String.IsNotBlank(acc.CRMID__c)) {
                    MasterNXNo masterInfo = NULL;
                    if (mapAccounts.get(acc.CSID__pc) == NULL) {
                        masterInfo = new MasterNXNo();
                        masterInfo.NXNo = acc.CSID__pc;
                    }
                    else {
                        masterInfo = mapAccounts.get(acc.CSID__pc);
                    }
                    masterInfo.accountCRMIDs.add(acc.CRMID__c);
                    masterInfo.accountIDs.put(acc.CRMID__c, acc.Id);
                    mapAccounts.put(acc.CSID__pc, masterInfo);
                }
            }
            
            // 生保申込みの取得
            // 代理店のNX番号と一致する生保申込みを抽出する
            // 生保申込み➡契約者の顧客番号：ContracterCustoNo__c
            List<SeihoOpportunity__c> soList = [
                                                     SELECT Id,
                                                            ContracterCustoNo__c,
                                                            Ref_Account__c,
                                                            Ref_Account__r.CRMID__c
                                                       FROM SeihoOpportunity__c
                                                      WHERE ContracterCustoNo__c IN :nxNos
                                                        AND ContracterCustoNo__c != NULL
                                                        AND Ref_Account__c != NULL
                                                   ORDER BY ContracterCustoNo__c,
                                                            Ref_Account__r.CRMID__c
                                               ];
            // 代理店の関連付け
            // 生保申込みに関連する取引先と代理店の関連付けを行う
            for (SeihoOpportunity__c so : soList) {
                // All Account IDs based on 生保申込み - 契約者の顧客番号 are added to Map
                // NX番号とCRMIDでソート順
                if (String.IsNotBlank(so.ContracterCustoNo__c) && 
                    String.IsNotBlank(so.Ref_Account__c) && 
                    String.IsNotBlank(so.Ref_Account__r.CRMID__c)) {
                    MasterNXNo masterInfo = NULL;
                    if (mapAccounts.get(so.ContracterCustoNo__c) == NULL) {
                        masterInfo = new MasterNXNo();
                        masterInfo.NXNo = so.ContracterCustoNo__c;
                    }
                    else {
                        masterInfo = mapAccounts.get(so.ContracterCustoNo__c);
                    }
                    masterInfo.accountCRMIDs.add(so.Ref_Account__r.CRMID__c);
                    masterInfo.accountIDs.put(so.Ref_Account__r.CRMID__c, so.Ref_Account__c);
                    mapAccounts.put(so.ContracterCustoNo__c, masterInfo);
                }
            }
        }
        return mapAccounts;
    }
    
    
    /**
     * getSeihoAgencyMasterFromAgencyNo
     * Get SeihoAgencyMasters based on AgencyNo key
     * @param List<String>
     * @return Map<String, SeihoAgencyMaster__c>
     */
   public static Map<String, seihoAgencyMaster__c> getSeihoAgencyMasterFromAgencyNo(Set<String> agencyNos) {
        Map<String, seihoAgencyMaster__c> mapMasters = new Map<String, seihoAgencyMaster__c>();
        if (agencyNos != NULL && agencyNos.size() > 0) {
            List<SeihoAgencyMaster__c> masterList = [
                                     SELECT Id,
                                            agncyno__c
                                       FROM seihoAgencyMaster__c
                                      WHERE agncyno__c IN :agencyNos
                                    ];
            for (seihoAgencyMaster__c master : masterList) {
                if (String.IsNotBlank(master.agncyno__c)) {
                    mapMasters.put(master.agncyno__c, master);
                }
            }
        }
        return mapMasters;
    }
    
    
    public static Map<String, seihoRecruiterMaster__c> getSeihoRecruiterMasterFromRecruiterNo(Set<String> recruiterNos) {
        Map<String, seihoRecruiterMaster__c> mapMasters = new Map<String, seihoRecruiterMaster__c>();
        if (recruiterNos != NULL && recruiterNos.size() > 0) {
            List<seihoRecruiterMaster__c> masterList = [
                                     SELECT Id,
                                            RECRUITER_NUMBER__c
                                       FROM seihoRecruiterMaster__c
                                      WHERE RECRUITER_NUMBER__c IN :recruiterNos
                                    ];
            for (seihoRecruiterMaster__c master : masterList) {
                if (String.IsNotBlank(master.RECRUITER_NUMBER__c)) {
                    mapMasters.put(master.RECRUITER_NUMBER__c, master);
                }
            }
        }
        return mapMasters;
    }
    
    
    public static Map<String, Request__c> getRequestFromRequestNo(List<String> RequestNos) {
        Map<String, Request__c> mapRequest = new Map<String, Request__c>();
        if (RequestNos != NULL && RequestNos.size() > 0) {
            List<Request__c> requestList = [
                                     SELECT Id,
                                            RequestNumber__c
                                       FROM Request__c
                                      WHERE RequestNumber__c IN :RequestNos
                                    ];
            for (Request__c request : requestList) {
                if (String.IsNotBlank(request.RequestNumber__c)) {
                    mapRequest.put(request.RequestNumber__c, request);
                }
            }
        }
        return mapRequest;
    }
    
    
    public static Map<String, seihoAgentMaster__c> getSeihoAgentMasterFromBelongAgentId(set<String> belongAgentIds) {
        Map<String, seihoAgentMaster__c> mapMasters = new Map<String, seihoAgentMaster__c>();
        if (belongAgentIds != NULL && belongAgentIds.size() > 0) {
            List<SeihoAgentMaster__c> masterList = [
                                     SELECT Id,
                                            BELONG_AGENT__c,
                                            MEMBER_ID_SEQ__c
                                       FROM SeihoAgentMaster__c
                                      WHERE MEMBER_ID_SEQ__c IN :belongAgentIds
                                    ];
            for (SeihoAgentMaster__c master : masterList) {
                if (String.IsNotBlank(master.MEMBER_ID_SEQ__c)) {
                    mapMasters.put(master.MEMBER_ID_SEQ__c, master);
                }
            }
        }
        return mapMasters;
    }
    
    
    public static Map<String, BankMaster__c> getBankMasterFromBankcodeAndBranchcode(set<String> bankCodeSet,set<String> branchCodeSet) {
        Map<String, bankMaster__c> mapMasters = new Map<String, bankMaster__c>();
        if ((bankCodeSet != NULL && bankCodeSet.size() > 0) && ((branchCodeSet != NULL && branchCodeSet.size() > 0))) {
            List<bankMaster__c> masterList =  [
                                                SELECT bankCode__c, branchCode__c, bankName__c, branchName__c 
                                                  FROM bankMaster__c 
                                                 WHERE bankCode__c IN: bankCodeSet AND branchCode__c IN: branchCodeSet
                                              ];
            
            for (bankMaster__c master : masterList) {
                if (String.IsNotBlank(master.bankCode__c) && String.IsNotBlank(master.branchCode__c)) {
                    mapMasters.put(master.bankCode__c+master.branchCode__c, master);
                }
            }
        }
        return mapMasters;
    }
    
    
    //ONYX
    /*** getSeihoAgencyMasterFromReception
     * Get SeihoAgencyMasters based on recruiter Id
     * @param Set<Id>
     * @return Map<Id, SeihoRecruiterMaster__c>
     */
    public static Map<String, seimeiDocumentMaster__c> getSeimeiDocumentMasterFromDocumentCode(Set<String> documentCodes) {
        Map<String, seimeiDocumentMaster__c> mapMasters = new Map<String, seimeiDocumentMaster__c>();
        if (documentCodes != NULL && documentCodes.size() > 0) {
            List<seimeiDocumentMaster__c> seimeiDocumentMasterList = [
                                     SELECT Id,
                                            DocumentCode__c
                                       FROM seimeiDocumentMaster__c
                                      WHERE DocumentCode__c IN :documentCodes
                                    ];
            for (seimeiDocumentMaster__c master : seimeiDocumentMasterList) {
                if (String.IsNotBlank(master.DocumentCode__c)) {
                    mapMasters.put(master.DocumentCode__c, master);
                }
            }
        }
        return mapMasters;
    }
    
    
    public static Map<id,SeihoRecruiterMaster__c> getRecruiterMap(Set<id> RecruiterIds){
         return new map<Id,SeihoRecruiterMaster__c>([Select Id,SeihoAgencyMasterName__r.Id,SeihoAgencyMasterName__c from SeihoRecruiterMaster__c where id =:RecruiterIds]);
     }
     
     
     /*** getSeihoRecruiterMasterFromRequest
      * Get SeihoRecruiterMaster based on reception Id
      * @param Set<Id>
      * @return Map<Id, Reception__c>
      */
     public static Map<id,Reception__c> getReceptionMap(Set<id> ReceptionIds){
         return new map<Id,Reception__c>([Select Id,SeihoRecruiter__c,SeihoAgency__c,SeihoAgent__c from Reception__c where id =:ReceptionIds]);
     }
     
    /**
     * マスタに基づいてNX番号情報
     * @Class Name      : MasterNXNo
     * @Description     : Wrapper Class for Master NXNos
     */
    public class MasterNXNo {
        public String NXNo                  { get; set; }
        // Set of All Accounts CRMID
        public Set<String> accountCRMIDs    { get; set; }
        // Map of All Accounts with CRMID as Key
        public Map<String, ID> accountIDs   { get; set; }
        
        public MasterNXNo() {
            accountCRMIDs = new Set<String>();
            accountIDs = new Map<String, ID>();
        }
        
        // Get AccountID with the First CRMID
        public ID getAccountID() {
            ID accountId = NULL;
            if (String.IsNotBlank(NXNo)) {
                if (accountCRMIDs != NULL && 
                    !accountCRMIDs.IsEmpty()) {
                    // Sort the CRMID List to get the First CRMID
                    List<String> sortedCRMIDs = new List<String>( accountCRMIDs );
                    sortedCRMIDs.sort();
                    String crmId = sortedCRMIDs.get(0);
                    if (accountIDs != NULL && 
                        accountIDs.get(crmId) != NULL) {
                        accountId = accountIDs.get(crmId);
                    }
                }
            }
            return accountId;
        }
    }
}