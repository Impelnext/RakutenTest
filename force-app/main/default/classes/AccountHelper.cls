/*
* @Class Name      : AccountHelper 
* @Description     : 取引先ヘルパークラス
* @Created Date    : 2019.05.16
* @Created By      : 
* @Modified Date   : 2020.06.10
* @Modified By     : SRM - ONYX
* @Modified Date   : 2021.02.10
* @Modified By     : SRM - ONYX（マスタ-取引先関連付け対応）
*/
public class AccountHelper {
    
    /*
     * 取引先カナ名取得
     */
    // Iyappan commit test
    public static String getAccFurigana(String recordId){
        
        // 取引先検索
        List<Account> accounts = [SELECT furiganaLast__pc,furiganaForst__pc FROM Account WHERE Id = :recordId];
        
        if(accounts.size() == 1){
            Account acc = accounts[0];
            //フリガナ姓、フリガナ名を文字列結合して返却
            String strFurigana = '';
            if(String.isNotBlank((String)acc.get('furiganaLast__pc'))){
                strFurigana += (String)acc.get('furiganaLast__pc');
            }
            if(String.isNotBlank((String)acc.get('furiganaForst__pc'))){
                strFurigana += (String)acc.get('furiganaForst__pc');
            }
            return strFurigana;
        }
        
        //レコードIDが存在しない場合は空文字を返却
        return '';
    }
    
    
    /**
     * NX番号（CSID）に基づいてマスタ情報全てを取得
     * @param List<String>
     * @return Map<String, List<SObject>>
     */
    public static Map<String, List<SObject>> getAllMastersFromCSID( Set<String> agencyNXNos, 
                                                                    Set<String> recruitNXNos, 
                                                                    Set<String> agentNXNos ) {
        
        Map<String, List<SObject>> mastersMap = new Map<String, List<SObject>>();
        List<SeihoAgencyMaster__c> seihoAgencyList = new List<SeihoAgencyMaster__c>();
        List<SeihoRecruiterMaster__c> seihoRecruiterList = new List<SeihoRecruiterMaster__c>();
        List<SeihoAgentMaster__c> seihoAgentList = new List<SeihoAgentMaster__c>();
        if (!agencyNXNos.IsEmpty()) {
            seihoAgencyList =       [
                                         SELECT Id, CSID__c, agncyno__c, Account__c 
                                           FROM SeihoAgencyMaster__c 
                                          WHERE CSID__c IN :agencyNXNos 
                                       ORDER BY CSID__c
                                    ];
        }
        if (!recruitNXNos.IsEmpty()) {
            seihoRecruiterList =    [
                                        SELECT Id, CS_ID__c, RECRUITER_NUMBER__c, Account__c 
                                          FROM SeihoRecruiterMaster__c 
                                         WHERE CS_ID__c IN :recruitNXNos 
                                      ORDER BY CS_ID__c
                                    ];
        }
        if (!agentNXNos.IsEmpty()) {
            seihoAgentList =        [
                                        SELECT Id, CS_ID__c, BELONG_AGENT__c, Account__c 
                                          FROM SeihoAgentMaster__c 
                                         WHERE CS_ID__c IN :agentNXNos 
                                      ORDER BY CS_ID__c
                                    ];
        }
        
        // Collect all the Master Record and set to Map
        //生保代理店マスタ
        if(seihoAgencyList != null){
            for (SeihoAgencyMaster__c seihoAgency : seihoAgencyList) {
                if (String.IsNotBlank(seihoAgency.CSID__c) ) {
                    if (mastersMap.get(seihoAgency.CSID__c) != NULL) {
                        mastersMap.get(seihoAgency.CSID__c).add(seihoAgency);
                    }
                    else {
                        mastersMap.put(seihoAgency.CSID__c, new List<SObject>{seihoAgency});
                    }
                }
            }
        }
        //生保募集人マスタ
        if(seihoRecruiterList != null){
            for (SeihoRecruiterMaster__c seihoRecruiter : seihoRecruiterList) {
                if (String.IsNotBlank(seihoRecruiter.CS_ID__c)) {
                    if (mastersMap.get(seihoRecruiter.CS_ID__c) != NULL) {
                        mastersMap.get(seihoRecruiter.CS_ID__c).add(seihoRecruiter);
                    }
                    else {
                        mastersMap.put(seihoRecruiter.CS_ID__c, new List<SObject>{seihoRecruiter});
                    }
                }
            }
        }
        //生保エージェントマスタ
        if(seihoAgentList != null){
            for (SeihoAgentMaster__c seihoAgent : seihoAgentList) {
                if (String.IsNotBlank(seihoAgent.CS_ID__c)) {
                    if (mastersMap.get(seihoAgent.CS_ID__c) != NULL) {
                        mastersMap.get(seihoAgent.CS_ID__c).add(seihoAgent);
                    }
                    else {
                        mastersMap.put(seihoAgent.CS_ID__c, new List<SObject>{seihoAgent});
                    }
                }
            } 
        }
        
        return mastersMap;
    }
    
    
    /**
     * 取引先ID（AccountID）に基づいてマスタ情報全てを取得
     * @param Set<ID>
     * @return Map<ID, List<SObject>>
     */
    public static Map<ID, List<SObject>> getAllMastersLinkedToAccount( Set<ID> accountIds ) {
        
        Map<ID, List<SObject>> mastersMap = new Map<ID, List<SObject>>();
        List<SeihoAgencyMaster__c> seihoAgencyList = new List<SeihoAgencyMaster__c>();
        List<SeihoRecruiterMaster__c> seihoRecruiterList = new List<SeihoRecruiterMaster__c>();
        List<SeihoAgentMaster__c> seihoAgentList = new List<SeihoAgentMaster__c>();
        if (!accountIds.IsEmpty()) {
            seihoAgencyList =       [
                                         SELECT Id, CSID__c, agncyno__c, Account__c 
                                           FROM SeihoAgencyMaster__c 
                                          WHERE Account__c IN :accountIds 
                                       ORDER BY Account__c
                                    ];
            seihoRecruiterList =    [
                                        SELECT Id, CS_ID__c, RECRUITER_NUMBER__c, Account__c 
                                          FROM SeihoRecruiterMaster__c 
                                         WHERE Account__c IN :accountIds 
                                      ORDER BY Account__c
                                    ];
            seihoAgentList =        [
                                        SELECT Id, CS_ID__c, BELONG_AGENT__c, Account__c 
                                          FROM SeihoAgentMaster__c 
                                         WHERE Account__c IN :accountIds 
                                      ORDER BY Account__c
                                    ];
        }
        
        // Collect all the Master Record and set to Map
        //生保代理店マスタ
        if(seihoAgencyList != null){
            for (SeihoAgencyMaster__c seihoAgency : seihoAgencyList) {
                if (String.IsNotBlank(seihoAgency.Account__c) ) {
                    if (mastersMap.get(seihoAgency.Account__c) != NULL) {
                        mastersMap.get(seihoAgency.Account__c).add(seihoAgency);
                    }
                    else {
                        mastersMap.put(seihoAgency.Account__c, new List<SObject>{seihoAgency});
                    }
                }
            }
        }
        //生保募集人マスタ
        if(seihoRecruiterList != null){
            for (SeihoRecruiterMaster__c seihoRecruiter : seihoRecruiterList) {
                if (String.IsNotBlank(seihoRecruiter.Account__c)) {
                    if (mastersMap.get(seihoRecruiter.Account__c) != NULL) {
                        mastersMap.get(seihoRecruiter.Account__c).add(seihoRecruiter);
                    }
                    else {
                        mastersMap.put(seihoRecruiter.Account__c, new List<SObject>{seihoRecruiter});
                    }
                }
            }
        }
        //生保エージェントマスタ
        if(seihoAgentList != null){
            for (SeihoAgentMaster__c seihoAgent : seihoAgentList) {
                if (String.IsNotBlank(seihoAgent.Account__c)) {
                    if (mastersMap.get(seihoAgent.Account__c) != NULL) {
                        mastersMap.get(seihoAgent.Account__c).add(seihoAgent);
                    }
                    else {
                        mastersMap.put(seihoAgent.Account__c, new List<SObject>{seihoAgent});
                    }
                }
            } 
        }
        
        return mastersMap;
    }
    
    
    /**
     * 顧客番号（CSID）に基づいてマスタ情報を取得
     * @param List<String>
     * @return Map<String,List<SObject>>
     */
    public static Map<String, List<SObject>> getMastersFromCSID( Set<String> csIdList ){
        
        Map<String, List<SObject>> mastersMap = new Map<String, List<SObject>>();
        
        //生保代理店マスタ
        Map<String, SeihoAgencyMaster__c> mapAgency = getSeihoAgencyMastersFromCSID(csIdList);
        for (String csId : mapAgency.keyset()) {
            if (mastersMap.get(csId) != NULL) {
                mastersMap.get(csId).add(mapAgency.get(csId));
            }
            else {
                mastersMap.put(csId, new List<SObject>{mapAgency.get(csId)});
            }
        }
        
        //生保募集人マスタ
        Map<String, SeihoRecruiterMaster__c> mapRecruiter = getSeihoRecruiterMastersFromCSID(csIdList);
        for (String csId : mapRecruiter.keyset()) {
            if (mastersMap.get(csId) != NULL) {
                mastersMap.get(csId).add(mapRecruiter.get(csId));
            }
            else {
                mastersMap.put(csId, new List<SObject>{mapRecruiter.get(csId)});
            }
        }
        
        //生保エージェントマスタ
        Map<String, SeihoAgentMaster__c> mapAgent = getSeihoAgentMastersFromCSID(csIdList);
        for (String csId : mapAgent.keyset()) {
            if (mastersMap.get(csId) != NULL) {
                mastersMap.get(csId).add(mapAgent.get(csId));
            }
            else {
                mastersMap.put(csId, new List<SObject>{mapAgent.get(csId)});
            }
        }
        
        return mastersMap;
    }
    
    
    /**
     * 顧客番号（CSID）に基づいてマスタ情報を取得
     * @param Map<Id, Set<String>>
     * @return Map<ID, SeihoAgencyMaster__c>
     */
    public static Map<String, SeihoAgencyMaster__c> getSeihoAgencyMastersFromCSID( Set<String> csIdList ) {
        
        Map<String, SeihoAgencyMaster__c> mapAgency = new Map<String, SeihoAgencyMaster__c>();
        if (csIdList != NULL && !csIdList.IsEmpty()) {
            List<SeihoAgencyMaster__c> seihoAgencyList =       [
                                                                     SELECT Id,
                                                                            CSID__c,
                                                                            agncyno__c,
                                                                            Account__c,
                                                                            AgncystsName__c,
                                                                            agncyrgstymd__c,
                                                                            clsymd__c
                                                                       FROM SeihoAgencyMaster__c
                                                                      WHERE CSID__c IN :csIdList
                                                                   ORDER BY CSID__c
                                                               ];
            
            // Collect Agency Master Record and set to Map
            //生保代理店マスタ
            if(seihoAgencyList != null){
                for (SeihoAgencyMaster__c seihoAgency : seihoAgencyList) {
                    if (String.IsNotBlank(seihoAgency.CSID__c)) {
                        if ('有効'.equals(seihoAgency.AgncystsName__c)) {
                            if (mapAgency.get(seihoAgency.CSID__c) == NULL ||
                                !'有効'.equals(mapAgency.get(seihoAgency.CSID__c).AgncystsName__c)) {
                                mapAgency.put(seihoAgency.CSID__c, seihoAgency);
                            }
                            else if (seihoAgency.agncyrgstymd__c != NULL && 
                                     (mapAgency.get(seihoAgency.CSID__c).agncyrgstymd__c == NULL || 
                                      seihoAgency.agncyrgstymd__c > mapAgency.get(seihoAgency.CSID__c).agncyrgstymd__c)) {
                                mapAgency.put(seihoAgency.CSID__c, seihoAgency);
                            }
                            else if (seihoAgency.agncyrgstymd__c != NULL && 
                                     seihoAgency.agncyrgstymd__c == mapAgency.get(seihoAgency.CSID__c).agncyrgstymd__c) {
                                if (seihoAgency.agncyno__c != NULL && 
                                    (mapAgency.get(seihoAgency.CSID__c).agncyno__c == NULL || 
                                     Integer.valueOf(seihoAgency.agncyno__c) > Integer.valueOf(mapAgency.get(seihoAgency.CSID__c).agncyno__c))) {
                                    mapAgency.put(seihoAgency.CSID__c, seihoAgency);
                                }
                            }
                        }
                        else 
                        if ('申込中'.equals(seihoAgency.AgncystsName__c) && 
                             (mapAgency.get(seihoAgency.CSID__c) == NULL || 
                              !'有効'.equals(mapAgency.get(seihoAgency.CSID__c).AgncystsName__c))) {
                            if (mapAgency.get(seihoAgency.CSID__c) == NULL || 
                                !'申込中'.equals(mapAgency.get(seihoAgency.CSID__c).AgncystsName__c)) {
                                mapAgency.put(seihoAgency.CSID__c, seihoAgency);
                            }
                            else if (seihoAgency.agncyrgstymd__c != NULL && 
                                     (mapAgency.get(seihoAgency.CSID__c).agncyrgstymd__c == NULL || 
                                      seihoAgency.agncyrgstymd__c > mapAgency.get(seihoAgency.CSID__c).agncyrgstymd__c)) {
                                mapAgency.put(seihoAgency.CSID__c, seihoAgency);
                            }
                            else if (seihoAgency.agncyrgstymd__c != NULL && 
                                     seihoAgency.agncyrgstymd__c == mapAgency.get(seihoAgency.CSID__c).agncyrgstymd__c) {
                                if (seihoAgency.agncyno__c != NULL && 
                                    (mapAgency.get(seihoAgency.CSID__c).agncyno__c == NULL || 
                                     Integer.valueOf(seihoAgency.agncyno__c) > Integer.valueOf(mapAgency.get(seihoAgency.CSID__c).agncyno__c))) {
                                    mapAgency.put(seihoAgency.CSID__c, seihoAgency);
                                }
                            }
                        }
                        else 
                        if ('廃業'.equals(seihoAgency.AgncystsName__c) && 
                             (mapAgency.get(seihoAgency.CSID__c) == NULL || 
                              (!'有効'.equals(mapAgency.get(seihoAgency.CSID__c).AgncystsName__c) && 
                               !'申込中'.equals(mapAgency.get(seihoAgency.CSID__c).AgncystsName__c)))) {
                            if (mapAgency.get(seihoAgency.CSID__c) == NULL || 
                                !'廃業'.equals(mapAgency.get(seihoAgency.CSID__c).AgncystsName__c)) {
                                mapAgency.put(seihoAgency.CSID__c, seihoAgency);
                            }
                            else if (seihoAgency.clsymd__c != NULL && 
                                     (mapAgency.get(seihoAgency.CSID__c).clsymd__c == NULL || 
                                      seihoAgency.clsymd__c > mapAgency.get(seihoAgency.CSID__c).clsymd__c)) {
                                mapAgency.put(seihoAgency.CSID__c, seihoAgency);
                            }
                            else if (seihoAgency.clsymd__c != NULL && 
                                     seihoAgency.clsymd__c == mapAgency.get(seihoAgency.CSID__c).clsymd__c) {
                                if (seihoAgency.agncyno__c != NULL && 
                                    (mapAgency.get(seihoAgency.CSID__c).agncyno__c == NULL || 
                                     Integer.valueOf(seihoAgency.agncyno__c) > Integer.valueOf(mapAgency.get(seihoAgency.CSID__c).agncyno__c))) {
                                    mapAgency.put(seihoAgency.CSID__c, seihoAgency);
                                }
                            }
                        }
                    }
                }
            }
        }
        return mapAgency;
    }
    
    /**
     * 複数NX番号は取引先に存在する場合、
     * マスタ情報をステータス順番で取得する
     * @param  Map<ID, Set<String>>
     * @param  Map<String, SeihoAgencyMaster__c>
     * @return Map<ID, SeihoAgencyMaster__c>
     */
    public static Map<ID, SeihoAgencyMaster__c> getSeihoAgencyMastersToLinkToAccounts( Map<ID, Set<String>> nxNosMap, 
                                                                                       Map<String, SeihoAgencyMaster__c> mapAgency ){
        
        Map<ID, SeihoAgencyMaster__c>  mapAccAgency = new Map<ID, SeihoAgencyMaster__c>();
        for (ID accountId : nxNosMap.keyset()) {
            if (nxNosMap.get(accountId) != NULL) {
                Set<String> accNxNos = nxNosMap.get(accountId);
                for (String accNxNo : accNxNos) {
                    if (mapAgency.get(accNxNo) != NULL) {
                        SeihoAgencyMaster__c seihoAgency = mapAgency.get(accNxNo);
                        if (String.IsNotBlank(seihoAgency.CSID__c)) {
                            if ('有効'.equals(seihoAgency.AgncystsName__c)) {
                                if (mapAccAgency.get(accountId) == NULL ||
                                    !'有効'.equals(mapAccAgency.get(accountId).AgncystsName__c)) {
                                    mapAccAgency.put(accountId, seihoAgency);
                                }
                                else if (seihoAgency.agncyrgstymd__c != NULL && 
                                         (mapAccAgency.get(accountId).agncyrgstymd__c == NULL || 
                                          seihoAgency.agncyrgstymd__c > mapAccAgency.get(accountId).agncyrgstymd__c)) {
                                    mapAccAgency.put(accountId, seihoAgency);
                                }
                                else if (seihoAgency.agncyrgstymd__c != NULL && 
                                         seihoAgency.agncyrgstymd__c == mapAccAgency.get(accountId).agncyrgstymd__c) {
                                    if (seihoAgency.agncyno__c != NULL && 
                                        (mapAccAgency.get(accountId).agncyno__c == NULL || 
                                         Integer.valueOf(seihoAgency.agncyno__c) > Integer.valueOf(mapAccAgency.get(accountId).agncyno__c))) {
                                        mapAccAgency.put(accountId, seihoAgency);
                                    }
                                }
                            }
                            else 
                            if ('申込中'.equals(seihoAgency.AgncystsName__c) && 
                                 (mapAccAgency.get(accountId) == NULL || 
                                  !'有効'.equals(mapAccAgency.get(accountId).AgncystsName__c))) {
                                if (mapAccAgency.get(accountId) == NULL || 
                                    !'申込中'.equals(mapAccAgency.get(accountId).AgncystsName__c)) {
                                    mapAccAgency.put(accountId, seihoAgency);
                                }
                                else if (seihoAgency.agncyrgstymd__c != NULL && 
                                         (mapAccAgency.get(accountId).agncyrgstymd__c == NULL || 
                                          seihoAgency.agncyrgstymd__c > mapAccAgency.get(accountId).agncyrgstymd__c)) {
                                    mapAccAgency.put(accountId, seihoAgency);
                                }
                                else if (seihoAgency.agncyrgstymd__c != NULL && 
                                         seihoAgency.agncyrgstymd__c == mapAccAgency.get(accountId).agncyrgstymd__c) {
                                    if (seihoAgency.agncyno__c != NULL && 
                                        (mapAccAgency.get(accountId).agncyno__c == NULL || 
                                         Integer.valueOf(seihoAgency.agncyno__c) > Integer.valueOf(mapAccAgency.get(accountId).agncyno__c))) {
                                        mapAccAgency.put(accountId, seihoAgency);
                                    }
                                }
                            }
                            else 
                            if ('廃業'.equals(seihoAgency.AgncystsName__c) && 
                                 (mapAccAgency.get(accountId) == NULL || 
                                  (!'有効'.equals(mapAccAgency.get(accountId).AgncystsName__c) && 
                                   !'申込中'.equals(mapAccAgency.get(accountId).AgncystsName__c)))) {
                                if (mapAccAgency.get(accountId) == NULL || 
                                    !'廃業'.equals(mapAccAgency.get(accountId).AgncystsName__c)) {
                                    mapAccAgency.put(accountId, seihoAgency);
                                }
                                else if (seihoAgency.clsymd__c != NULL && 
                                         (mapAccAgency.get(accountId).clsymd__c == NULL || 
                                          seihoAgency.clsymd__c > mapAccAgency.get(accountId).clsymd__c)) {
                                    mapAccAgency.put(accountId, seihoAgency);
                                }
                                else if (seihoAgency.clsymd__c != NULL && 
                                         seihoAgency.clsymd__c == mapAccAgency.get(accountId).clsymd__c) {
                                    if (seihoAgency.agncyno__c != NULL && 
                                        (mapAccAgency.get(accountId).agncyno__c == NULL || 
                                         Integer.valueOf(seihoAgency.agncyno__c) > Integer.valueOf(mapAccAgency.get(accountId).agncyno__c))) {
                                        mapAccAgency.put(accountId, seihoAgency);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return mapAccAgency;
    }
    
    /**
     * 顧客番号（CSID）に基づいてマスタ情報を取得
     * @param List<String>
     * @return Map<String, SeihoRecruiterMaster__c>
     */
    public static Map<String, SeihoRecruiterMaster__c> getSeihoRecruiterMastersFromCSID( Set<String> csIdList ) {
        
        Map<String, SeihoRecruiterMaster__c> mapRecruiter = new Map<String, SeihoRecruiterMaster__c>();
        List<SeihoRecruiterMaster__c> seihoRecruiterList = [
                                                                SELECT Id,
                                                                       CS_ID__c,
                                                                       RECRUITER_NUMBER__c,
                                                                       Account__c,
                                                                       RECRUITER_STATUS_DISPLAY__c,
                                                                       REGISTRATION_DATE__c,
                                                                       OUT_OF_BUSINESS_DATE__c
                                                                  FROM SeihoRecruiterMaster__c
                                                                 WHERE CS_ID__c IN: csIdList
                                                              ORDER BY CS_ID__c
                                                            ];
        
        // Collect all the Master Record and set to Map
        //生保募集人マスタ
        if(seihoRecruiterList != null){
            for (SeihoRecruiterMaster__c seihoRecruiter : seihoRecruiterList) {
                if (String.IsNotBlank(seihoRecruiter.CS_ID__c)) {
                    if ('有効'.equals(seihoRecruiter.RECRUITER_STATUS_DISPLAY__c)) {
                        if (mapRecruiter.get(seihoRecruiter.CS_ID__c) == NULL || 
                            !'有効'.equals(mapRecruiter.get(seihoRecruiter.CS_ID__c).RECRUITER_STATUS_DISPLAY__c)) {
                            mapRecruiter.put(seihoRecruiter.CS_ID__c, seihoRecruiter);
                        }
                        else if (seihoRecruiter.REGISTRATION_DATE__c != NULL && 
                                 (mapRecruiter.get(seihoRecruiter.CS_ID__c).REGISTRATION_DATE__c == NULL || 
                                  Date.valueOf(seihoRecruiter.REGISTRATION_DATE__c.replace('/', '-')) > 
                                  Date.valueOf(mapRecruiter.get(seihoRecruiter.CS_ID__c).REGISTRATION_DATE__c.replace('/', '-')))){
                            mapRecruiter.put(seihoRecruiter.CS_ID__c, seihoRecruiter);
                        }
                        else if (seihoRecruiter.REGISTRATION_DATE__c != NULL && 
                                 seihoRecruiter.REGISTRATION_DATE__c == mapRecruiter.get(seihoRecruiter.CS_ID__c).REGISTRATION_DATE__c) {
                            if (seihoRecruiter.RECRUITER_NUMBER__c != NULL && 
                                (mapRecruiter.get(seihoRecruiter.CS_ID__c).RECRUITER_NUMBER__c == NULL || 
                                 seihoRecruiter.RECRUITER_NUMBER__c.compareTo(mapRecruiter.get(seihoRecruiter.CS_ID__c).RECRUITER_NUMBER__c) > 0)) {
                                mapRecruiter.put(seihoRecruiter.CS_ID__c, seihoRecruiter);
                            }
                        }
                    }
                    else 
                    if ('申込中'.equals(seihoRecruiter.RECRUITER_STATUS_DISPLAY__c) && 
                         (mapRecruiter.get(seihoRecruiter.CS_ID__c) == NULL || 
                          !'有効'.equals(mapRecruiter.get(seihoRecruiter.CS_ID__c).RECRUITER_STATUS_DISPLAY__c))) {
                        if (mapRecruiter.get(seihoRecruiter.CS_ID__c) == NULL || 
                            !'申込中'.equals(mapRecruiter.get(seihoRecruiter.CS_ID__c).RECRUITER_STATUS_DISPLAY__c)) {
                            mapRecruiter.put(seihoRecruiter.CS_ID__c, seihoRecruiter);
                        }
                        else if (seihoRecruiter.REGISTRATION_DATE__c != NULL && 
                                 (mapRecruiter.get(seihoRecruiter.CS_ID__c).REGISTRATION_DATE__c == NULL || 
                                  Date.valueOf(seihoRecruiter.REGISTRATION_DATE__c.replace('/', '-')) > 
                                  Date.valueOf(mapRecruiter.get(seihoRecruiter.CS_ID__c).REGISTRATION_DATE__c.replace('/', '-')))) {
                            mapRecruiter.put(seihoRecruiter.CS_ID__c, seihoRecruiter);
                        }
                        else if (seihoRecruiter.REGISTRATION_DATE__c != NULL && 
                                 seihoRecruiter.REGISTRATION_DATE__c == mapRecruiter.get(seihoRecruiter.CS_ID__c).REGISTRATION_DATE__c) {
                            if (seihoRecruiter.RECRUITER_NUMBER__c != NULL && 
                                (mapRecruiter.get(seihoRecruiter.CS_ID__c).RECRUITER_NUMBER__c == NULL || 
                                 seihoRecruiter.RECRUITER_NUMBER__c.compareTo(mapRecruiter.get(seihoRecruiter.CS_ID__c).RECRUITER_NUMBER__c) > 0)) {
                                mapRecruiter.put(seihoRecruiter.CS_ID__c, seihoRecruiter);
                            }
                        }
                    }
                    else 
                    if ('廃業'.equals(seihoRecruiter.RECRUITER_STATUS_DISPLAY__c) && 
                         (mapRecruiter.get(seihoRecruiter.CS_ID__c) == NULL || 
                          (!'有効'.equals(mapRecruiter.get(seihoRecruiter.CS_ID__c).RECRUITER_STATUS_DISPLAY__c) && 
                           !'申込中'.equals(mapRecruiter.get(seihoRecruiter.CS_ID__c).RECRUITER_STATUS_DISPLAY__c))) ){
                        if (mapRecruiter.get(seihoRecruiter.CS_ID__c) == NULL || 
                            !'廃業'.equals(mapRecruiter.get(seihoRecruiter.CS_ID__c).RECRUITER_STATUS_DISPLAY__c)) {
                            mapRecruiter.put(seihoRecruiter.CS_ID__c, seihoRecruiter);
                        }
                        else if (seihoRecruiter.OUT_OF_BUSINESS_DATE__c != NULL && 
                                 (mapRecruiter.get(seihoRecruiter.CS_ID__c).OUT_OF_BUSINESS_DATE__c == NULL || 
                                  Date.valueOf(seihoRecruiter.OUT_OF_BUSINESS_DATE__c.replace('/', '-')) > 
                                  Date.valueOf(mapRecruiter.get(seihoRecruiter.CS_ID__c).OUT_OF_BUSINESS_DATE__c.replace('/', '-')))) {
                            mapRecruiter.put(seihoRecruiter.CS_ID__c, seihoRecruiter);
                        }
                        else if (seihoRecruiter.OUT_OF_BUSINESS_DATE__c != NULL && 
                                 seihoRecruiter.OUT_OF_BUSINESS_DATE__c == mapRecruiter.get(seihoRecruiter.CS_ID__c).OUT_OF_BUSINESS_DATE__c) {
                            if (seihoRecruiter.RECRUITER_NUMBER__c != NULL && 
                                (mapRecruiter.get(seihoRecruiter.CS_ID__c).RECRUITER_NUMBER__c == NULL || 
                                 seihoRecruiter.RECRUITER_NUMBER__c.compareTo(mapRecruiter.get(seihoRecruiter.CS_ID__c).RECRUITER_NUMBER__c) > 0)) {
                                mapRecruiter.put(seihoRecruiter.CS_ID__c, seihoRecruiter);
                            }
                        }
                    }
                }
            }
        }
        return mapRecruiter;
    }
    
    /**
     * 複数NX番号は取引先に存在する場合、
     * マスタ情報をステータス順番で取得する
     * @param  Map<ID, Set<String>>
     * @param  Map<String, SeihoRecruiterMaster__c>
     * @return Map<ID, SeihoRecruiterMaster__c>
     */
    public static Map<ID, SeihoRecruiterMaster__c> getSeihoRecruiterMastersToLinkToAccounts( Map<ID, Set<String>> nxNosMap, 
                                                                                             Map<String, SeihoRecruiterMaster__c> mapRecruiter ) {
        
        Map<ID, SeihoRecruiterMaster__c> mapAccRecruiter = new Map<ID, SeihoRecruiterMaster__c>();
        for (ID accountId : nxNosMap.keyset()) {
            if (nxNosMap.get(accountId) != NULL) {
                Set<String> accNxNos = nxNosMap.get(accountId);
                for (String accNxNo : accNxNos) {
                    if (mapRecruiter.get(accNxNo) != NULL) {
                        SeihoRecruiterMaster__c seihoRecruiter = mapRecruiter.get(accNxNo);
                        if (String.IsNotBlank(seihoRecruiter.CS_ID__c)) {
                            if ('有効'.equals(seihoRecruiter.RECRUITER_STATUS_DISPLAY__c)) {
                                if (mapAccRecruiter.get(accountId) == NULL || 
                                    !'有効'.equals(mapAccRecruiter.get(accountId).RECRUITER_STATUS_DISPLAY__c)) {
                                    mapAccRecruiter.put(accountId, seihoRecruiter);
                                }
                                else if (seihoRecruiter.REGISTRATION_DATE__c != NULL && 
                                         (mapAccRecruiter.get(accountId).REGISTRATION_DATE__c == NULL || 
                                          Date.valueOf(seihoRecruiter.REGISTRATION_DATE__c.replace('/', '-')) > 
                                          Date.valueOf(mapAccRecruiter.get(accountId).REGISTRATION_DATE__c.replace('/', '-')))){
                                    mapAccRecruiter.put(accountId, seihoRecruiter);
                                }
                                else if (seihoRecruiter.REGISTRATION_DATE__c != NULL && 
                                         seihoRecruiter.REGISTRATION_DATE__c == mapAccRecruiter.get(accountId).REGISTRATION_DATE__c) {
                                    if (seihoRecruiter.RECRUITER_NUMBER__c != NULL && 
                                        (mapAccRecruiter.get(accountId).RECRUITER_NUMBER__c == NULL || 
                                         seihoRecruiter.RECRUITER_NUMBER__c.compareTo(mapAccRecruiter.get(accountId).RECRUITER_NUMBER__c) > 0)) {
                                        mapAccRecruiter.put(accountId, seihoRecruiter);
                                    }
                                }
                            }
                            else 
                            if ('申込中'.equals(seihoRecruiter.RECRUITER_STATUS_DISPLAY__c) && 
                                 (mapAccRecruiter.get(accountId) == NULL || 
                                  !'有効'.equals(mapAccRecruiter.get(accountId).RECRUITER_STATUS_DISPLAY__c))) {
                                if (mapAccRecruiter.get(accountId) == NULL || 
                                    !'申込中'.equals(mapAccRecruiter.get(accountId).RECRUITER_STATUS_DISPLAY__c)) {
                                    mapAccRecruiter.put(accountId, seihoRecruiter);
                                }
                                else if (seihoRecruiter.REGISTRATION_DATE__c != NULL && 
                                         (mapAccRecruiter.get(accountId).REGISTRATION_DATE__c == NULL || 
                                          Date.valueOf(seihoRecruiter.REGISTRATION_DATE__c.replace('/', '-')) > 
                                          Date.valueOf(mapAccRecruiter.get(accountId).REGISTRATION_DATE__c.replace('/', '-')))) {
                                    mapAccRecruiter.put(accountId, seihoRecruiter);
                                }
                                else if (seihoRecruiter.REGISTRATION_DATE__c != NULL && 
                                         seihoRecruiter.REGISTRATION_DATE__c == mapAccRecruiter.get(accountId).REGISTRATION_DATE__c) {
                                    if (seihoRecruiter.RECRUITER_NUMBER__c != NULL && 
                                        (mapAccRecruiter.get(accountId).RECRUITER_NUMBER__c == NULL || 
                                         seihoRecruiter.RECRUITER_NUMBER__c.compareTo(mapAccRecruiter.get(accountId).RECRUITER_NUMBER__c) > 0)) {
                                        mapAccRecruiter.put(accountId, seihoRecruiter);
                                    }
                                }
                            }
                            else 
                            if ('廃業'.equals(seihoRecruiter.RECRUITER_STATUS_DISPLAY__c) && 
                                 (mapAccRecruiter.get(accountId) == NULL || 
                                  (!'有効'.equals(mapAccRecruiter.get(accountId).RECRUITER_STATUS_DISPLAY__c) && 
                                   !'申込中'.equals(mapAccRecruiter.get(accountId).RECRUITER_STATUS_DISPLAY__c))) ){
                                if (mapAccRecruiter.get(accountId) == NULL || 
                                    !'廃業'.equals(mapAccRecruiter.get(accountId).RECRUITER_STATUS_DISPLAY__c)) {
                                    mapAccRecruiter.put(accountId, seihoRecruiter);
                                }
                                else if (seihoRecruiter.OUT_OF_BUSINESS_DATE__c != NULL && 
                                         (mapAccRecruiter.get(accountId).OUT_OF_BUSINESS_DATE__c == NULL || 
                                          Date.valueOf(seihoRecruiter.OUT_OF_BUSINESS_DATE__c.replace('/', '-')) > 
                                          Date.valueOf(mapAccRecruiter.get(accountId).OUT_OF_BUSINESS_DATE__c.replace('/', '-')))) {
                                    mapAccRecruiter.put(accountId, seihoRecruiter);
                                }
                                else if (seihoRecruiter.OUT_OF_BUSINESS_DATE__c != NULL && 
                                         seihoRecruiter.OUT_OF_BUSINESS_DATE__c == mapAccRecruiter.get(accountId).OUT_OF_BUSINESS_DATE__c) {
                                    if (seihoRecruiter.RECRUITER_NUMBER__c != NULL && 
                                        (mapAccRecruiter.get(accountId).RECRUITER_NUMBER__c == NULL || 
                                         seihoRecruiter.RECRUITER_NUMBER__c.compareTo(mapAccRecruiter.get(accountId).RECRUITER_NUMBER__c) > 0)) {
                                        mapAccRecruiter.put(accountId, seihoRecruiter);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return mapAccRecruiter;
    }
    
    /**
     * 顧客番号（CSID）に基づいてマスタ情報を取得
     * @param List<String>
     * @return Map<String, SeihoAgentMaster__c>
     */
    public static Map<String, SeihoAgentMaster__c> getSeihoAgentMastersFromCSID( Set<String> csIdList ) {
        
        Map<String, SeihoAgentMaster__c> mapAgent = new Map<String, SeihoAgentMaster__c>();
        List<SeihoAgentMaster__c> seihoAgentList =          [
                                                                SELECT Id,
                                                                       CS_ID__c,
                                                                       BELONG_AGENT__c,
                                                                       Account__c,
                                                                       AGENT_ID__c,
                                                                       AGENT_STATUS_DISPLAY__c,
                                                                       REGISTRATION_DATE__c,
                                                                       ANNIHILATION_DATE__c
                                                                  FROM SeihoAgentMaster__c
                                                                 WHERE CS_ID__c IN: csIdList
                                                              ORDER BY CS_ID__c
                                                            ];
        
        // Collect all the Master Record and set to Map
        //生保エージェントマスタ
        if(seihoAgentList != null){
            for (SeihoAgentMaster__c seihoAgent : seihoAgentList) {
                if (String.IsNotBlank(seihoAgent.CS_ID__c)) {
                    if ('有効'.equals(seihoAgent.AGENT_STATUS_DISPLAY__c)) {
                        if (mapAgent.get(seihoAgent.CS_ID__c) == NULL || 
                            !'有効'.equals(mapAgent.get(seihoAgent.CS_ID__c).AGENT_STATUS_DISPLAY__c)) {
                            mapAgent.put(seihoAgent.CS_ID__c, seihoAgent);
                        }
                        else if (seihoAgent.REGISTRATION_DATE__c != NULL && 
                                 (mapAgent.get(seihoAgent.CS_ID__c).REGISTRATION_DATE__c == NULL || 
                                  Date.valueOf(seihoAgent.REGISTRATION_DATE__c.replace('/', '-')) > 
                                  Date.valueOf(mapAgent.get(seihoAgent.CS_ID__c).REGISTRATION_DATE__c.replace('/', '-')))) {
                            mapAgent.put(seihoAgent.CS_ID__c, seihoAgent);
                        }
                        else if (seihoAgent.REGISTRATION_DATE__c != NULL && 
                                 seihoAgent.REGISTRATION_DATE__c == mapAgent.get(seihoAgent.CS_ID__c).REGISTRATION_DATE__c) {
                            if (seihoAgent.AGENT_ID__c != NULL && 
                                (mapAgent.get(seihoAgent.CS_ID__c).AGENT_ID__c == NULL || 
                                 seihoAgent.AGENT_ID__c > mapAgent.get(seihoAgent.CS_ID__c).AGENT_ID__c)) {
                                mapAgent.put(seihoAgent.CS_ID__c, seihoAgent);
                            }
                        }
                    }
                    else 
                    if ('申込中'.equals(seihoAgent.AGENT_STATUS_DISPLAY__c) && 
                         (mapAgent.get(seihoAgent.CS_ID__c) == NULL || 
                          !'有効'.equals(mapAgent.get(seihoAgent.CS_ID__c).AGENT_STATUS_DISPLAY__c))) {
                        if (mapAgent.get(seihoAgent.CS_ID__c) == NULL || 
                            !'申込中'.equals(mapAgent.get(seihoAgent.CS_ID__c).AGENT_STATUS_DISPLAY__c)) {
                            mapAgent.put(seihoAgent.CS_ID__c, seihoAgent);
                        }
                        else if (seihoAgent.REGISTRATION_DATE__c != NULL && 
                                 (mapAgent.get(seihoAgent.CS_ID__c).REGISTRATION_DATE__c == NULL || 
                                  Date.valueOf(seihoAgent.REGISTRATION_DATE__c.replace('/', '-')) > 
                                  Date.valueOf(mapAgent.get(seihoAgent.CS_ID__c).REGISTRATION_DATE__c.replace('/', '-')))) {
                            mapAgent.put(seihoAgent.CS_ID__c, seihoAgent);
                        }
                        else if (seihoAgent.REGISTRATION_DATE__c != NULL && 
                                 seihoAgent.REGISTRATION_DATE__c == mapAgent.get(seihoAgent.CS_ID__c).REGISTRATION_DATE__c) {
                            if (seihoAgent.AGENT_ID__c != NULL && 
                                (mapAgent.get(seihoAgent.CS_ID__c).AGENT_ID__c == NULL || 
                                 seihoAgent.AGENT_ID__c > mapAgent.get(seihoAgent.CS_ID__c).AGENT_ID__c)) {
                                mapAgent.put(seihoAgent.CS_ID__c, seihoAgent);
                            }
                        }
                    }
                    else 
                    if ('廃業'.equals(seihoAgent.AGENT_STATUS_DISPLAY__c) && 
                         (mapAgent.get(seihoAgent.CS_ID__c) == NULL || 
                          (!'有効'.equals(mapAgent.get(seihoAgent.CS_ID__c).AGENT_STATUS_DISPLAY__c) && 
                           !'申込中'.equals(mapAgent.get(seihoAgent.CS_ID__c).AGENT_STATUS_DISPLAY__c)))) {
                        if (mapAgent.get(seihoAgent.CS_ID__c) == NULL || 
                            !'廃業'.equals(mapAgent.get(seihoAgent.CS_ID__c).AGENT_STATUS_DISPLAY__c)) {
                            mapAgent.put(seihoAgent.CS_ID__c, seihoAgent);
                        }
                        else if (seihoAgent.ANNIHILATION_DATE__c != NULL && 
                                 (mapAgent.get(seihoAgent.CS_ID__c).ANNIHILATION_DATE__c == NULL || 
                                  Date.valueOf(seihoAgent.ANNIHILATION_DATE__c.replace('/', '-')) > 
                                  Date.valueOf(mapAgent.get(seihoAgent.CS_ID__c).ANNIHILATION_DATE__c.replace('/', '-')))) {
                            mapAgent.put(seihoAgent.CS_ID__c, seihoAgent);
                        }
                        else if (seihoAgent.ANNIHILATION_DATE__c != NULL && 
                                 seihoAgent.ANNIHILATION_DATE__c == mapAgent.get(seihoAgent.CS_ID__c).ANNIHILATION_DATE__c) {
                            if (seihoAgent.AGENT_ID__c != NULL && 
                                (mapAgent.get(seihoAgent.CS_ID__c).AGENT_ID__c == NULL || 
                                 seihoAgent.AGENT_ID__c > mapAgent.get(seihoAgent.CS_ID__c).AGENT_ID__c)) {
                                mapAgent.put(seihoAgent.CS_ID__c, seihoAgent);
                            }
                        }
                    }
                }
            }
        }
        return mapAgent;
    }
    
    /**
     * 複数NX番号は取引先に存在する場合、
     * マスタ情報をステータス順番で取得する
     * @param  Map<ID, Set<String>>
     * @param  Map<String, SeihoAgentMaster__c>
     * @return Map<ID, SeihoAgentMaster__c>
     */
    public static Map<ID, SeihoAgentMaster__c> getSeihoAgentMastersToLinkToAccounts( Map<ID, Set<String>> nxNosMap, 
                                                                                     Map<String, SeihoAgentMaster__c> mapAgent ){
        
        Map<ID, SeihoAgentMaster__c> mapAccAgent = new Map<ID, SeihoAgentMaster__c>();
        for (ID accountId : nxNosMap.keyset()) {
            if (nxNosMap.get(accountId) != NULL) {
                Set<String> accNxNos = nxNosMap.get(accountId);
                for (String accNxNo : accNxNos) {
                    if (mapAgent.get(accNxNo) != NULL) {
                        SeihoAgentMaster__c seihoAgent = mapAgent.get(accNxNo);
                        if (String.IsNotBlank(seihoAgent.CS_ID__c)) {
                            if ('有効'.equals(seihoAgent.AGENT_STATUS_DISPLAY__c)) {
                                if (mapAccAgent.get(accountId) == NULL || 
                                    !'有効'.equals(mapAccAgent.get(accountId).AGENT_STATUS_DISPLAY__c)) {
                                    mapAccAgent.put(accountId, seihoAgent);
                                }
                                else if (seihoAgent.REGISTRATION_DATE__c != NULL && 
                                         (mapAccAgent.get(accountId).REGISTRATION_DATE__c == NULL || 
                                          Date.valueOf(seihoAgent.REGISTRATION_DATE__c.replace('/', '-')) > 
                                          Date.valueOf(mapAccAgent.get(accountId).REGISTRATION_DATE__c.replace('/', '-')))) {
                                    mapAccAgent.put(accountId, seihoAgent);
                                }
                                else if (seihoAgent.REGISTRATION_DATE__c != NULL && 
                                         seihoAgent.REGISTRATION_DATE__c == mapAccAgent.get(accountId).REGISTRATION_DATE__c) {
                                    if (seihoAgent.AGENT_ID__c != NULL && 
                                        (mapAccAgent.get(accountId).AGENT_ID__c == NULL || 
                                         seihoAgent.AGENT_ID__c > mapAccAgent.get(accountId).AGENT_ID__c)) {
                                        mapAccAgent.put(accountId, seihoAgent);
                                    }
                                }
                            }
                            else 
                            if ('申込中'.equals(seihoAgent.AGENT_STATUS_DISPLAY__c) && 
                                 (mapAccAgent.get(accountId) == NULL || 
                                  !'有効'.equals(mapAccAgent.get(accountId).AGENT_STATUS_DISPLAY__c))) {
                                if (mapAccAgent.get(accountId) == NULL || 
                                    !'申込中'.equals(mapAccAgent.get(accountId).AGENT_STATUS_DISPLAY__c)) {
                                    mapAccAgent.put(accountId, seihoAgent);
                                }
                                else if (seihoAgent.REGISTRATION_DATE__c != NULL && 
                                         (mapAccAgent.get(accountId).REGISTRATION_DATE__c == NULL || 
                                          Date.valueOf(seihoAgent.REGISTRATION_DATE__c.replace('/', '-')) > 
                                          Date.valueOf(mapAccAgent.get(accountId).REGISTRATION_DATE__c.replace('/', '-')))) {
                                    mapAccAgent.put(accountId, seihoAgent);
                                }
                                else if (seihoAgent.REGISTRATION_DATE__c != NULL && 
                                         seihoAgent.REGISTRATION_DATE__c == mapAccAgent.get(accountId).REGISTRATION_DATE__c) {
                                    if (seihoAgent.AGENT_ID__c != NULL && 
                                        (mapAccAgent.get(accountId).AGENT_ID__c == NULL || 
                                         seihoAgent.AGENT_ID__c > mapAccAgent.get(accountId).AGENT_ID__c)) {
                                        mapAccAgent.put(accountId, seihoAgent);
                                    }
                                }
                            }
                            else 
                            if ('廃業'.equals(seihoAgent.AGENT_STATUS_DISPLAY__c) && 
                                 (mapAccAgent.get(accountId) == NULL || 
                                  (!'有効'.equals(mapAccAgent.get(accountId).AGENT_STATUS_DISPLAY__c) && 
                                   !'申込中'.equals(mapAccAgent.get(accountId).AGENT_STATUS_DISPLAY__c)))) {
                                if (mapAccAgent.get(accountId) == NULL || 
                                    !'廃業'.equals(mapAccAgent.get(accountId).AGENT_STATUS_DISPLAY__c)) {
                                    mapAccAgent.put(accountId, seihoAgent);
                                }
                                else if (seihoAgent.ANNIHILATION_DATE__c != NULL && 
                                         (mapAccAgent.get(accountId).ANNIHILATION_DATE__c == NULL || 
                                          Date.valueOf(seihoAgent.ANNIHILATION_DATE__c.replace('/', '-')) > 
                                          Date.valueOf(mapAccAgent.get(accountId).ANNIHILATION_DATE__c.replace('/', '-')))) {
                                    mapAccAgent.put(accountId, seihoAgent);
                                }
                                else if (seihoAgent.ANNIHILATION_DATE__c != NULL && 
                                         seihoAgent.ANNIHILATION_DATE__c == mapAccAgent.get(accountId).ANNIHILATION_DATE__c) {
                                    if (seihoAgent.AGENT_ID__c != NULL && 
                                        (mapAccAgent.get(accountId).AGENT_ID__c == NULL || 
                                         seihoAgent.AGENT_ID__c > mapAccAgent.get(accountId).AGENT_ID__c)) {
                                        mapAccAgent.put(accountId, seihoAgent);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return mapAccAgent;
    }
    
    // Initialize Master Fields in Account
    public static void initializeMasterInfo( Map<Id, Account> accountMap,
                                             Boolean setAgency,
                                             Boolean setRecruit,
                                             Boolean setAgent ) {
        for (Account acc : accountMap.values()) {
            // Initialize the Master Fields
            if (setAgency) {
                acc.SeihoAgencyNo__c = NULL;
                acc.SeihoAgencyMstId__c = NULL;
                if (String.IsNotBlank(acc.SeihoAccoutType__c) && 
                    acc.SeihoAccoutType__c.containsIgnoreCase('生保代理店')) {
                    acc.SeihoAccoutType__c = acc.SeihoAccoutType__c.remove('生保代理店');
                }
            }
            if (setRecruit) {
                acc.SeihoRecruiterNo__c = NULL;
                acc.SeihoRecruiterMstId__c = NULL;
                if (String.IsNotBlank(acc.SeihoAccoutType__c) && 
                    acc.SeihoAccoutType__c.containsIgnoreCase('生保募集人')) {
                    acc.SeihoAccoutType__c = acc.SeihoAccoutType__c.remove('生保募集人');
                }
            }
            if (setAgent) {
                acc.SeihoAgentID__c = NULL;
                acc.SeihoAgentMstId__c = NULL;
                if (String.IsNotBlank(acc.SeihoAccoutType__c) && 
                    acc.SeihoAccoutType__c.containsIgnoreCase('生保エージェント')) {
                    acc.SeihoAccoutType__c = acc.SeihoAccoutType__c.remove('生保エージェント');
                }
            }
        }
    }
    
    // 取得した・生保契約情報・取引先・生保申込みからNX番号が一致する
    // 代理店、エージェント、募集人と取引先の関連付けを行う
    public static void setMastersInfoInAccountFromNXNo( Map<Id, Account> accountMap, 
                                                        Map<Id, AccountNXNo> accountNXNoMap, 
                                                        Boolean setAgency, 
                                                        Boolean setRecruit, 
                                                        Boolean setAgent ) {
        // 取引先のNX番号マップ
        Map<Id, Set<String>> nxNosMap = new Map<Id, Set<String>>();
        for (Id accountId : accountNXNoMap.keyset()) {
            if (accountNXNoMap.get(accountId) != NULL) {
                nxNosMap.put(accountId, NULL);
            }
        }
        
        // 取引先に関連する生保契約情報を取得する
        getNXNoFromLifeContract(nxNosMap);
        
        // 取引先を取得する
        getNXNoFromAccount(nxNosMap, accountMap);
        
        // 取引先に関連する生保申込みを取得する
        getNXNoFromSeihoOpportunity(nxNosMap);
        
        // NX顧客番号（CSID）に基づいてマスタ情報を取得
        // 以下の順でNX番号が一致するレコードを検索し、
        // 一致する場合は代理店、エージェント、募集人と取引先の関連付けを行う
        // ・生保契約情報
        // ・取引先
        // ・生保申込み
        // マスタはステータス順番で紐付けを行う
        
        // NX番号に基づいて生保代理店マスタを取得
        // 取得した「生保契約情報・取引先・生保申込み」からNX番号が一致する
        // 生保代理店マスタと取引先の関連付けを行う
        if (setAgency && !nxNosMap.isEmpty()) {
            setAgencyMasterInfoInAccount(nxNosMap, accountMap, accountNXNoMap);
        }
        
        // NX番号に基づいて生保募集人マスタを取得
        // 取得した「生保契約情報・取引先・生保申込み」からNX番号が一致する
        // 生保募集人マスタと取引先の関連付けを行う
        if (setRecruit && !nxNosMap.isEmpty()) {
            setRecruiterMasterInfoInAccount(nxNosMap, accountMap, accountNXNoMap);
        }
        
        // NX番号に基づいて生保エージェントマスタを取得
        // 取得した「生保契約情報・取引先・生保申込み」からNX番号が一致する
        // 生保エージェントマスタと取引先の関連付けを行う
        if (setAgent && !nxNosMap.isEmpty()) {
            setAgentMasterInfoInAccount(nxNosMap, accountMap, accountNXNoMap);
        }
    }
    
    // ・生保契約情報
    // 取引先に関連する生保契約情報を取得する
    public static void getNXNoFromLifeContract( Map<Id, Set<String>> nxNosMap ) {
        // Get AccountIds to Search NXNos
        if (nxNosMap.isEmpty()) {
            return;
            // NOTREACHED
        }
        
        // 取引先に関連する生保契約情報を取得する
        List<LifeContract__c> lfcList = [
                                             SELECT Id,
                                                    CSID__c,
                                                    AccountId__c
                                               FROM LifeContract__c
                                              WHERE AccountId__c IN :nxNosMap.keyset()
                                                AND CSID__c != NULL
                                                AND AccountId__c != NULL
                                           ORDER BY CSID__c
                                        ];
        // 生保契約情報のNX番号を抽出する
        // 生保契約情報➡顧客番号（CSID）：CSID__c
        for (LifeContract__c lfc : lfcList) {
            if (String.IsNotBlank(lfc.AccountId__c) && 
                String.IsNotBlank(lfc.CSID__c)) {
                if (nxNosMap.get(lfc.AccountId__c) == NULL) {
                    nxNosMap.put(lfc.AccountId__c, new Set<String>{ lfc.CSID__c });
                }
                else {
                    nxNosMap.get(lfc.AccountId__c).add(lfc.CSID__c);
                }
            }
        }
    }
    
    // ・取引先
    // 取引先を取得する。
    public static void getNXNoFromAccount( Map<Id, Set<String>> nxNosMap, 
                                           Map<Id, Account> accountMap ) {
        // Get AccountIds to Search NXNos
        if (nxNosMap.isEmpty()) {
            return;
            // NOTREACHED
        }
        
        // 取引先を取得する
        // 取引先のNX番号を抽出する
        // 取引先➡顧客番号（CSID）：CSID__pc
        for (Account acc : accountMap.values()) {
        
            if (String.IsNotBlank(acc.Id) && 
                String.IsNotBlank(acc.CSID__pc)) {
                if (nxNosMap.get(acc.Id) == NULL) {
                    nxNosMap.put(acc.Id, new Set<String>{ acc.CSID__pc });
                }
                else {
                    nxNosMap.get(acc.Id).add(acc.CSID__pc);
                }
            }
        }
    }
    
    // ・生保申込み
    // 取引先に関連する生保申込みを取得する
    public static void getNXNoFromSeihoOpportunity( Map<Id, Set<String>> nxNosMap ) {
        // Get AccountIds to Search NXNos
        if (nxNosMap.isEmpty()) {
            return;
            // NOTREACHED
        }
        
        // 取引先に関連する生保申込みを取得する
        List<SeihoOpportunity__c> soList = [
                                                 SELECT Id,
                                                        ContracterCustoNo__c,
                                                        Ref_Account__c
                                                   FROM SeihoOpportunity__c
                                                  WHERE Ref_Account__c IN :nxNosMap.keyset()
                                                    AND ContracterCustoNo__c != NULL
                                                    AND Ref_Account__c != NULL
                                               ORDER BY ContracterCustoNo__c
                                           ];
        // 生保申込みのNX番号を抽出する
        // 生保契約情報➡契約者の顧客番号（CSID）：ContracterCustoNo__c
        for (SeihoOpportunity__c so : soList) {
            if (String.IsNotBlank(so.Ref_Account__c) && 
                String.IsNotBlank(so.ContracterCustoNo__c)) {
                if (nxNosMap.get(so.Ref_Account__c) == NULL) {
                    nxNosMap.put(so.Ref_Account__c, new Set<String>{ so.ContracterCustoNo__c });
                }
                else {
                    nxNosMap.get(so.Ref_Account__c).add(so.ContracterCustoNo__c);
                }
            }
        }
    }
    
    // NX番号に基づいて生保代理店マスタを取得
    public static void setAgencyMasterInfoInAccount( Map<ID, Set<String>> nxNosMap, 
                                                     Map<ID, Account> accountMap, 
                                                     Map<ID, AccountNXNo> accountNXNoMap ) {
        if (nxNosMap != NULL && !nxNosMap.IsEmpty()) {
            Set<String> nxNos = new Set<String>();
            // NULL or Blank CSID should not be added to Map set
            for (ID accId : nxNosMap.keyset()) {
                if (nxNosMap.get(accId) != NULL) {
                    nxNos.addAll(nxNosMap.get(accId));
                }
            }
            
            // 取引先と生保代理店マスタのマップ
            Map<String, SeihoAgencyMaster__c> mapAgency = getSeihoAgencyMastersFromCSID(nxNos);
            // Account can have many Different NXNos from LifeContract, Account & SeihoOpportunity,
            // then link the Agency Master record based on the Status Priority.
            // 複数NX番号は取引先に存在する場合、
            // マスタ情報をステータス順番で取得する
            Map<ID, SeihoAgencyMaster__c> mapAccAgency  = getSeihoAgencyMastersToLinkToAccounts( nxNosMap, mapAgency );
            for (Account acc : accountMap.values()) {
                // Set the 生保代理店マスタ Fields based on NX顧客番号
                if (nxNosMap.get(acc.Id) != NULL && 
                    mapAccAgency.get(acc.Id) != NULL && 
                    String.IsBlank(acc.SeihoAgencyMstId__c)) {
                    SeihoAgencyMaster__c sh  = mapAccAgency.get(acc.Id);
                    acc.SeihoAgencyNo__c = sh.agncyno__c;
                    acc.SeihoAgencyMstId__c = sh.Id;
                    if(acc.SeihoAccoutType__c != null) {
                        if(!acc.SeihoAccoutType__c.containsIgnoreCase('生保代理店')) {
                            acc.SeihoAccoutType__c = acc.SeihoAccoutType__c+';'+'生保代理店';
                        }
                    }else{
                        acc.SeihoAccoutType__c = '生保代理店';
                    }
                    
                    // Collect the Matched CSID(NXNo) for the Account
                    // NX番号が一致する場合、取引先NX番号リストに追加する
                    if (accountNXNoMap.get(acc.Id) != NULL) {
                        // Is Matched NXNo to be set to agencyNXNo ?
                        //accountNXNoMap.get(acc.Id).agencyNXNo = nxNosMap.get(acc.Id);
                        accountNXNoMap.get(acc.Id).allAgencyNXNos = nxNosMap.get(acc.Id);
                    }
                }
            }
        }
    }
    
    // NX番号に基づいて生保募集人マスタを取得
    public static void setRecruiterMasterInfoInAccount( Map<ID, Set<String>> nxNosMap, 
                                                        Map<Id, Account> accountMap, 
                                                        Map<Id, AccountNXNo> accountNXNoMap ) {
        if (nxNosMap != NULL && !nxNosMap.IsEmpty()) {
            Set<String> nxNos = new Set<String>();
            // NULL or Blank CSID should not be added to Map set
            for (ID accId : nxNosMap.keyset()) {
                if (nxNosMap.get(accId) != NULL) {
                    nxNos.addAll(nxNosMap.get(accId));
                }
            }
            
            // 取引先と生保募集人マスタのマップ
            Map<String, SeihoRecruiterMaster__c> mapRecruiter = getSeihoRecruiterMastersFromCSID(nxNos);
            // Account can have many Different NXNos from LifeContract, Account & SeihoOpportunity,
            // then link the Recruiter Master record based on the Status Priority.
            // 複数NX番号は取引先に存在する場合、
            // マスタ情報をステータス順番で取得する
            Map<ID, SeihoRecruiterMaster__c> mapAccRecruiter  = getSeihoRecruiterMastersToLinkToAccounts( nxNosMap, mapRecruiter );
            for (Account acc : accountMap.values()) {
                // Set the 生保募集人マスタ Fields based on NX顧客番号
                if (nxNosMap.get(acc.Id) != NULL && 
                    mapAccRecruiter.get(acc.Id) != NULL && 
                    String.IsBlank(acc.SeihoRecruiterMstId__c)) {
                    SeihoRecruiterMaster__c  sr = mapAccRecruiter.get(acc.Id);
                    acc.SeihoRecruiterNo__c = sr.RECRUITER_NUMBER__c;
                    acc.SeihoRecruiterMstId__c = sr.Id;
                    if(acc.SeihoAccoutType__c != null) {
                        if(!acc.SeihoAccoutType__c.containsIgnoreCase('生保募集人')) {
                            acc.SeihoAccoutType__c = acc.SeihoAccoutType__c+';'+'生保募集人';
                        }
                    }else{
                        acc.SeihoAccoutType__c = '生保募集人';
                    }
                    
                    // Collect the Matched CSID(NXNo) for the Account
                    // NX番号が一致する場合、取引先NX番号リストに追加する
                    if (accountNXNoMap.get(acc.Id) != NULL) {
                        // Is Matched NXNo to be set to agencyNXNo ?
                        //accountNXNoMap.get(acc.Id).recruitNXNo = nxNosRecruiterMap.get(acc.Id);
                        accountNXNoMap.get(acc.Id).allRecruitNXNos = nxNosMap.get(acc.Id);
                    }
                }
            }
        }
    }
    
    // NX番号に基づいて生保エージェントマスタを取得
    public static void setAgentMasterInfoInAccount( Map<ID, Set<String>> nxNosMap, 
                                                    Map<Id, Account> accountMap, 
                                                    Map<Id, AccountNXNo> accountNXNoMap ) {
        if (nxNosMap != NULL && !nxNosMap.IsEmpty()) {
            Set<String> nxNos = new Set<String>();
            // NULL or Blank CSID should not be added to Map set
            for (ID accId : nxNosMap.keyset()) {
                if (nxNosMap.get(accId) != NULL) {
                    nxNos.addAll(nxNosMap.get(accId));
                }
            }
            
            // 取引先と生保エージェントマスタのマップ
            Map<String, SeihoAgentMaster__c> mapAgent = getSeihoAgentMastersFromCSID(nxNos);
            // Account can have many Different NXNos from LifeContract, Account & SeihoOpportunity,
            // then link the Agent Master record based on the Status Priority.
            // 複数NX番号は取引先に存在する場合、
            // マスタ情報をステータス順番で取得する
            Map<ID, SeihoAgentMaster__c> mapAccAgent  = getSeihoAgentMastersToLinkToAccounts( nxNosMap, mapAgent );
            for (Account acc : accountMap.values()) {
                // Set the 生保エージェントマスタ Fields based on NX顧客番号
                if (nxNosMap.get(acc.Id) != NULL && 
                    mapAccAgent.get(acc.Id) != NULL && 
                    String.IsBlank(acc.SeihoAgentMstId__c)) {
                    SeihoAgentMaster__c se  = mapAccAgent.get(acc.Id);
                    acc.SeihoAgentID__c = se.AGENT_ID__c;
                    acc.SeihoAgentMstId__c = se.id;
                    if(acc.SeihoAccoutType__c != null) {
                        if(!acc.SeihoAccoutType__c.containsIgnoreCase('生保エージェント')) {
                            acc.SeihoAccoutType__c = acc.SeihoAccoutType__c+';'+'生保エージェント';
                        }
                    }else{
                        acc.SeihoAccoutType__c = '生保エージェント';
                    }
                    
                    // Collect the Matched CSID(NXNo) for the Account
                    // NX番号が一致する場合、取引先NX番号リストに追加する
                    if (accountNXNoMap.get(acc.Id) != NULL) {
                        // Is Matched NXNo to be set to agencyNXNo ?
                        //accountNXNoMap.get(acc.Id).agentNXNo = nxNosAgentMap.get(acc.Id);
                        accountNXNoMap.get(acc.Id).allAgentNXNos = nxNosMap.get(acc.Id);
                    }
                }
            }
        }
    }
    
    /**
     * updateAccountsWithSeihoMasterInfo
     * Update Related Accounts With SiehoMasterInfo
     * @param Map<ID, Account>
     * @return void
     */
    public static void updateAccountsWithSeihoMasterInfo( Map<ID, Account> accountMap, 
                                                          Map<Id, AccountNXNo> accountNXNoMap, 
                                                          Boolean setAgency, 
                                                          Boolean setRecruit, 
                                                          Boolean setAgent ) {
        // Initialize Master Fields in Account
        initializeMasterInfo(accountMap, setAgency, setRecruit, setAgent);
        
        // 以下の順でNX番号が一致するレコードを検索し、
        // 一致する場合は代理店、エージェント、募集人と取引先の関連付けを行う
        // ・生保契約情報
        // ・取引先
        // ・生保申込み
        setMastersInfoInAccountFromNXNo(accountMap, accountNXNoMap, setAgency, setRecruit, setAgent);
        
        // 取引先を更新する
        if (!accountMap.isEmpty()) {
            Update accountMap.values();
        }
    }
    
    /**
     * updateMastersWithAccountInfo
     * Update Related Masters With AccountInfo
     * @param Map<ID, Account>
     * @param Map<Id, AccountNXNo>
     * @return void
     */
    public static void updateMastersWithAccountInfo( Map<ID, Account> accountMap, 
                                                     Map<Id, AccountNXNo> accountNXNoMap ) {
        // accountNXNoMapには全て取引先の全てNX番号はあります。
        // NX番号一致する全てのマスタを取得する
        if (!accountNXNoMap.IsEmpty()) {
            Set<String> agencyNXNos = new Set<String>();
            Set<String> recruitNXNos = new Set<String>();
            Set<String> agentNXNos = new Set<String>();
            for (ID accId : accountNXNoMap.keyset()) {
                if (accountNXNoMap.get(accId) != NULL) {
                    AccountNXNo accountNXno = accountNXNoMap.get(accId);
                    if (accountNXno != NULL) {
                        if ( accountNXno.allAgencyNXNos != NULL && 
                            !accountNXno.allAgencyNXNos.IsEmpty()) {
                            agencyNXNos.addAll(accountNXno.allAgencyNXNos);
                        }
                        if ( accountNXno.allRecruitNXNos != NULL && 
                            !accountNXno.allRecruitNXNos.IsEmpty()) {
                            recruitNXNos.addAll(accountNXno.allRecruitNXNos);
                        }
                        if ( accountNXno.allAgentNXNos != NULL && 
                            !accountNXno.allAgentNXNos.IsEmpty()) {
                            agentNXNos.addAll(accountNXno.allAgentNXNos);
                        }
                    }
                }
            }
            
            // 既に取引先と紐付けである全てのマスタを取得
            Map<ID, List<SObject>> existMasterLinkedAccounts = getAllMastersLinkedToAccount(accountMap.keyset());
            for (ID accountId : existMasterLinkedAccounts.keyset()) {
                if (existMasterLinkedAccounts.get(accountId) != NULL) {
                    List<SObject> masterSObjList = existMasterLinkedAccounts.get(accountId);
                    for (SObject sobj : masterSObjList) {
                        if (sobj.getSobjectType() == seihoAgencyMaster__c.sobjectType) {
                            SeihoAgencyMaster__c sh = (SeihoAgencyMaster__c)sobj;
                            if (String.IsNotBlank(sh.CSID__c)) {
                                agencyNXNos.add(sh.CSID__c);
                            }
                        }
                        if (sobj.getSobjectType() == SeihoRecruiterMaster__c.sobjectType) {
                            SeihoRecruiterMaster__c sr = (SeihoRecruiterMaster__c)sobj;
                            if (String.IsNotBlank(sr.CS_ID__c)) {
                                recruitNXNos.add(sr.CS_ID__c);
                            }
                        }
                        if (sobj.getSobjectType() == seihoAgentMaster__c.sobjectType) {
                            SeihoAgentMaster__c se = (SeihoAgentMaster__c)sobj;
                            if (String.IsNotBlank(se.CS_ID__c)) {
                                agentNXNos.add(se.CS_ID__c);
                            }
                        }
                    }
                }
            }
            
            // NX番号一致するマスタを格納するマップ
            Map<String, List<SObject>> accountMasterMap = getAllMastersFromCSID(agencyNXNos, recruitNXNos, agentNXNos);
            
            // 全て（新規参照と既存参照）のマスターにアカウント紐付けを設定する
            setAccountReferenceInMaster(accountMasterMap, existMasterLinkedAccounts);
        }
    }
    
    /**
     * 取引先情報をマスタにセットする
     * @param Map<Id, Account> accountMap
     * @param Map<String, List<SObject>>
     * @param Map<ID, List<SObject>>
     */
    public static void setAccountReferenceInMaster( Map<String, List<SObject>> accountMasterMap, 
                                                    Map<ID, List<SObject>> existMasterLinkedAccounts ) {
        
        //マスタの更新マップ
        Map<Id, SeihoAgencyMaster__c> seihoAgencyUpdateMap = new Map<Id, SeihoAgencyMaster__c>();
        Map<Id, SeihoRecruiterMaster__c> seihoRecruiterUpdateMap = new Map<Id, SeihoRecruiterMaster__c>();
        Map<Id, SeihoAgentMaster__c> seihoAgentUpdateMap = new Map<Id, SeihoAgentMaster__c>();
        // 以下の順でNX番号が一致するレコードを検索し、
        // 一致する場合は取引先と代理店オブジェクトに対し紐づけを行う
        // ・生保契約情報
        // ・取引先
        // ・生保申込み
        // NX番号とCRMIDでソート順
        // accountMasterMap has the List of the below NXNos
        // 1. NXnos from the Masters to be linked new to Account
        // 2. NXnos from the Masters already linked to Account
        Map<String, MasterHelper.MasterNXNo> accNXNoMap = MasterHelper.getAllAccountsFromNXNumber(accountMasterMap.keyset());
        
        for (String nxNo : accountMasterMap.keyset()) {
            List<SObject> masterSObjList = accountMasterMap.get(nxNo);
            for (SObject sobj : masterSObjList) {
                if (sobj.getSobjectType() == seihoAgencyMaster__c.sobjectType) {
                    SeihoAgencyMaster__c sh = (SeihoAgencyMaster__c)sobj;
                    sh.Account__c = (String.IsNotBlank(sh.CSID__c) && 
                                      accNXNoMap.get(sh.CSID__c) != NULL) ? 
                                     accNXNoMap.get(sh.CSID__c).getAccountID() : 
                                     NULL;
                    if (seihoAgencyUpdateMap.get(sh.Id) == NULL) {
                        seihoAgencyUpdateMap.put(sh.Id, sh);
                    }
                }
                if (sobj.getSobjectType() == SeihoRecruiterMaster__c.sobjectType) {
                    SeihoRecruiterMaster__c sr = (SeihoRecruiterMaster__c)sobj;
                    sr.Account__c = (String.IsNotBlank(sr.CS_ID__c) && 
                                      accNXNoMap.get(sr.CS_ID__c) != NULL) ? 
                                     accNXNoMap.get(sr.CS_ID__c).getAccountID() : 
                                     NULL;
                    if (seihoRecruiterUpdateMap.get(sr.Id) == NULL) {
                        seihoRecruiterUpdateMap.put(sr.Id, sr);
                    }
                }
                if (sobj.getSobjectType() == seihoAgentMaster__c.sobjectType) {
                    SeihoAgentMaster__c se = (SeihoAgentMaster__c)sobj;
                    se.Account__c = (String.IsNotBlank(se.CS_ID__c) && 
                                      accNXNoMap.get(se.CS_ID__c) != NULL) ? 
                                     accNXNoMap.get(se.CS_ID__c).getAccountID() : 
                                     NULL;
                    if (seihoAgentUpdateMap.get(se.Id) == NULL) {
                        seihoAgentUpdateMap.put(se.Id, se);
                    }
                }
            }
        }
        
        // Update Masters that are already linked to Accounts, 
        // But NO CSID in the Master Record.
        // When CSID is Blank in Master, 
        // then clear the Account Link in the Master.
        // 既に取引先と紐付けである全てのマスタを取得
        // マスタのCSIDはブランク値の場合のみ、
        // 取引先の紐付けをクリアする
        for (ID accountId : existMasterLinkedAccounts.keyset()) {
            List<SObject> masterSObjList = existMasterLinkedAccounts.get(accountId);
            for (SObject sobj : masterSObjList) {
                if (sobj.getSobjectType() == seihoAgencyMaster__c.sobjectType) {
                    SeihoAgencyMaster__c sh = (SeihoAgencyMaster__c)sobj;
                    if (String.IsBlank(sh.CSID__c)) {
                        sh.Account__c = NULL;
                        if (seihoAgencyUpdateMap.get(sh.Id) == NULL) {
                            seihoAgencyUpdateMap.put(sh.Id, sh);
                        }
                    }
                }
                if (sobj.getSobjectType() == SeihoRecruiterMaster__c.sobjectType) {
                    SeihoRecruiterMaster__c sr = (SeihoRecruiterMaster__c)sobj;
                    if (String.IsBlank(sr.CS_ID__c)) {
                        sr.Account__c = NULL;
                        if (seihoRecruiterUpdateMap.get(sr.Id) == NULL) {
                            seihoRecruiterUpdateMap.put(sr.Id, sr);
                        }
                    }
                }
                if (sobj.getSobjectType() == seihoAgentMaster__c.sobjectType) {
                    SeihoAgentMaster__c se = (SeihoAgentMaster__c)sobj;
                    if (String.IsBlank(se.CS_ID__c)) {
                        se.Account__c = NULL;
                        if (seihoAgentUpdateMap.get(se.Id) == NULL) {
                            seihoAgentUpdateMap.put(se.Id, se);
                        }
                    }
                }
            }
        }
        
        if (!seihoAgencyUpdateMap.isempty())
            update seihoAgencyUpdateMap.values();
        if (!seihoAgentUpdateMap.isempty())
            update seihoAgentUpdateMap.values();
        if (!seihoRecruiterUpdateMap.isempty())
            update seihoRecruiterUpdateMap.values();
    }
    
    /**
     * 取引先に基づいてNX番号情報
     * @Class Name      : AccountNXNo
     * @Description     : Wrapper Class for Accounts NXNos
     */
    public class AccountNXNo {
        public ID accountId { get; set; }
        public String agencyNXNo { get; set; }
        public String recruitNXNo { get; set; }
        public String agentNXNo { get; set; }
        public Set<String> allAgencyNXNos { get; set; }
        public Set<String> allRecruitNXNos { get; set; }
        public Set<String> allAgentNXNos { get; set; }
    }
}