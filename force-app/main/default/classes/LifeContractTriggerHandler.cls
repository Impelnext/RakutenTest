/*
* @Class Name      : LifeContractTriggerHandler 
* @Description     : 生保契約情報トリガーハンドラ
* @Created Date    : 2019.05.15
* @Created By      : 
* @Modified Date   : 2019.12.26
* @Modified By     : Valsala Kumar
*/
public class LifeContractTriggerHandler {

    /**
     * コンストラクタ
     */
    public LifeContractTriggerHandler() {}
    
    /**
     * 生保契約情報作成・更新前処理
     * @param List<LifeContract__c>
     * @return 
     */
    public void onBeforeProcess(List<LifeContract__c> lifeContractList, Map<Id, LifeContract__c> oldMap){
        // 取引先Idを格納するセット
        Set<Id> accIdSet = new Set<Id>();
        for(LifeContract__c lifeContract : lifeContractList){
            if(   oldMap == Null || oldMap.size() == 0
               || lifeContract.AccountId__c <> oldMap.get(lifeContract.Id).AccountId__c){
                accIdSet.add(lifeContract.AccountId__c);
            }
            // IDに保険種類をセット
            //削除済みかどうかでName項目設定内容を振り分け
            if(lifeContract.DELETE_STATUS__c <> '1'){
                //削除済みでない場合は保険種類の名称をName項目に設定
                lifeContract.Name = lifeContract.INSURANCE_TYPE_DISPLAY__c;
            }else{
                lifeContract.Name = '【削除済み】' + lifeContract.INSURANCE_TYPE_DISPLAY__c;
            }
        }
        // 生保利用がFALSEの取引先が更新対象であるため、取得する
        if(accIdSet.size() > 0){
            List<Account> updateTargetAccountList = [SELECT Id,LifeUse__pc FROM Account WHERE Id IN :accIdSet AND LifeUse__pc = FALSE];
            system.debug('Test33'+ updateTargetAccountList);
            for(Account acc : updateTargetAccountList){
                acc.LifeUse__pc = TRUE;
            }
            // 取引先の生保利用項目を更新
            update updateTargetAccountList;
        }
    }

    
    /**
     * 生保契約情報作成前処理
     * @param List<LifeContract__c>
     * @return 
     */
    public void setAgencyRefBeforeInsert(List<LifeContract__c> newLifeContractList){
        //代理店マスタ取得用セット
        Set<String> agencyNumSet = new Set<String>();
        //すべての生保契約情報を繰り返し
        for(LifeContract__c lifeContract : newLifeContractList){
            if(String.isNotBlank(lifeContract.REFERRAL_AGENCY_NUM__c)){
                agencyNumSet.add(lifeContract.REFERRAL_AGENCY_NUM__c);
            }
            if(String.isNotBlank(lifeContract.AGENCY_NUM__c)){
                agencyNumSet.add(lifeContract.AGENCY_NUM__c);
            }
        }

        //代理店コードのセット
        setLifeContractAgencyValue(agencyNumSet, newLifeContractList);
    }

    /**
     * 生保契約情報更新前処理
     * @param List<LifeContract__c>
     * @return 
     */
    public void setAgencyRefBeforeUpdate(List<LifeContract__c> newLifeContractList, Map<Id, LifeContract__c> oldLifeContractMap){
        //代理店マスタ取得用セット
        Set<String> agencyNumSet = new Set<String>();
        //更新対象の生保契約情報
        List<LifeContract__c> updateTargetLifeContractList = new List<LifeContract__c>();
        //すべての生保契約情報を繰り返し
        for(LifeContract__c newLifeContract : newLifeContractList){
            //更新前の生保契約情報を取得
            LifeContract__c oldLifeContract = oldLifeContractMap.get(newLifeContract.Id);
            //更新対象フラグ
            boolean isTarget = false;
            //紹介代理店コードが更新される場合
            if(oldLifeContract.REFERRAL_AGENCY_NUM__c != newLifeContract.REFERRAL_AGENCY_NUM__c){
                //更新後の紹介代理店コードがNULLでない場合
                if(String.isNotBlank(newLifeContract.REFERRAL_AGENCY_NUM__c)){
                    agencyNumSet.add(newLifeContract.REFERRAL_AGENCY_NUM__c);
                }
                //更新対象にする
                isTarget = true;
            }
            //代理店コードが更新される場合
            if(oldLifeContract.AGENCY_NUM__c != newLifeContract.AGENCY_NUM__c){
                //更新後の代理店コードがNULLでない場合
                if(String.isNotBlank(newLifeContract.AGENCY_NUM__c)){
                    agencyNumSet.add(newLifeContract.AGENCY_NUM__c);
                }
                //更新対象にする
                isTarget = true;
            }
            //更新対象の場合
            if(isTarget){
                //更新対象生保契約情報リストに格納する
                updateTargetLifeContractList.add(newLifeContract);
            }
        }

        //代理店コードのセット
        setLifeContractAgencyValue(agencyNumSet, updateTargetLifeContractList);
    }

    public void setLifeContractAgencyValue(Set<String> agencyNumSet, List<LifeContract__c> lifeContractList){

        //代理店コード、代理店マップ
        Map<String ,SeihoAgencyMaster__c> agencyMasterMap = new Map<String, SeihoAgencyMaster__c>();
        for(SeihoAgencyMaster__c agency : [SELECT Id, agncyno__c FROM SeihoAgencyMaster__c WHERE agncyno__c IN :agencyNumSet]){
            agencyMasterMap.put(agency.agncyno__c, agency);
        }
        //更新対象を繰り返し
        for(LifeContract__c lifeContract : lifeContractList){
            //紹介代理店コードがNULLでない場合
            if(String.isNotBlank(lifeContract.REFERRAL_AGENCY_NUM__c)){
                if(agencyMasterMap.get(lifeContract.REFERRAL_AGENCY_NUM__c) != null)
                    lifeContract.REFERRAL_AGENCY__c = agencyMasterMap.get(lifeContract.REFERRAL_AGENCY_NUM__c).Id;
            }else{
                lifeContract.REFERRAL_AGENCY__c = null;
            }
            //代理店コードがNULLでない場合
            if(String.isNotBlank(lifeContract.AGENCY_NUM__c)){
                if(agencyMasterMap.get(lifeContract.AGENCY_NUM__c) != null)
                    lifeContract.AGENCY__c = agencyMasterMap.get(lifeContract.AGENCY_NUM__c).Id;
            }else{
                lifeContract.AGENCY__c = null;
            }
        }
    }
    
    
    /**
     * 生保契約情報作成前処理
     * @param List<LifeContract__c>
     * @return 
     */
    public void onBeforeInsertProcess(List<LifeContract__c> lifeContractList){
        // 生保契約情報に関連する取引先IDセット
        Set<String> seihoAccountIdSet = new Set<String>();
        // 生保契約情報に関連する契約申込番号セット
        Set<String> seihoAppNoSet = new Set<String>();
        for(LifeContract__c seiho : lifeContractList){
            // 取引先IDセット
            if (String.IsNotBlank(seiho.AccountId__c)) {
                seihoAccountIdSet.add(seiho.AccountId__c);
            }
            // 契約申込番号セット
            if (String.IsNotBlank(seiho.APPLICATION_NUM__c)) {
                seihoAppNoSet.add(seiho.APPLICATION_NUM__c);
            }
        }
        
        // 生保申込みに関連する商談IDセット
        Map<String, String> seihoOppIdMap = new Map<String, String>();
        // 生保申込みを取得
        List<SeihoOpportunity__c> updateSeihoOppList = [
                                                            SELECT Id, AppliNo__c, Opportunity__c
                                                              FROM SeihoOpportunity__c 
                                                             WHERE Ref_Account__c IN :seihoAccountIdSet 
                                                               AND AppliNo__c IN :seihoAppNoSet
                                                               AND Opportunity__c <> NULL
                                                        ];
        for(SeihoOpportunity__c seihoOpp : updateSeihoOppList){
            seihoOppIdMap.put(seihoOpp.AppliNo__c, seihoOpp.Opportunity__c);
        }
        
        // $$$$$$$$$$$ Is Query of Opportunity required as Id is valid $$$$$$$$$$$$$$$$$ //
        // 生保申込みの関連先商談を取得
        /*
        Map<Id, Opportunity> updateOppMap = new Map<Id, Opportunity> (
                                                                        [
                                                                            SELECT Id, Opportunity__c 
                                                                              FROM Opportunity 
                                                                             WHERE Id IN :seihoOppIdMap.values()
                                                                        ]
                                                                      );
        */
        // 商談情報設定
        for(LifeContract__c seiho : lifeContractList) {
            if (seihoOppIdMap.get(seiho.APPLICATION_NUM__c) != NULL) {
                //seiho.Opportunity__c = updateOppMap.get(seihoOppIdMap.get(seiho.AppliNo__c)).Id;
                seiho.Opportunity__c = seihoOppIdMap.get(seiho.APPLICATION_NUM__c);
            }
        }
    }
    
    
   /**
     * 生保契約情報更新前処理
     * @param List<LifeContract__c>
     * @param Map<Id, LifeContract__c>
     * @return 
     */
    public void onBeforeUpdateProcess(List<LifeContract__c> lifeContractList, Map<Id, LifeContract__c> oldMap){
        for(LifeContract__c seiho : lifeContractList){
            // 取引先変更判定
            // (変更前)生保契約情報．取引先名 <>(変更後)生保契約情報．取引先名
            if (seiho.AccountId__c <> oldMap.get(seiho.Id).AccountId__c && 
                seiho.Opportunity__c == oldMap.get(seiho.Id).Opportunity__c){
                // 商談との関連解消
                // 商談参照項目クリア
                seiho.Opportunity__c = NULL;
            }
        }
    }
    
    
    /**
     * 生保契約情報作成・更新後処理
     * @param List<LifeContract__c>
     * @param Map<Id,LifeContract__c>
     * @return 
     */
    public void onAfterProcess(List<LifeContract__c> lifeContractList, Map<Id, LifeContract__c> oldMap){
        // 取引先Idを格納するセット
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> oldaccIdSet = new Set<Id>();
        for(LifeContract__c seiho : lifeContractList){
            if(   oldMap == Null || oldMap.size() == 0
               || seiho.AccountId__c <> oldMap.get(seiho.Id).AccountId__c){
                if (seiho.AccountId__c != NULL)
                    accIdSet.add(seiho.AccountId__c);
            }
            if(   oldMap != Null && oldMap.size() > 0
               && seiho.AccountId__c <> oldMap.get(seiho.Id).AccountId__c
               && oldMap.get(seiho.Id).AccountId__c != NULL){
                oldaccIdSet.add(oldMap.get(seiho.Id).AccountId__c);
            }
        }
        
        // 更新対象取引先のマップ
        Map<ID, Account> mapUpdateAccounts = new Map<ID, Account>();
        // 更新対象取引先取得する
        if(accIdSet.size() > 0){
            // 関連先取引先取得
            List<Account> updateTargetAccountList = [
                                                        SELECT Id, SeihoOppApplyflg__c, SeihoAccoutType__c 
                                                          FROM Account 
                                                         WHERE Id IN :accIdSet
                                                    ];
            for(Account acc : updateTargetAccountList){
                // 取得した取引先レコードについて、生保申込フラグをTrueにする
                acc.SeihoOppApplyflg__c = TRUE;
                
                if(String.IsNotBlank(acc.SeihoAccoutType__c)){
                    if(!acc.SeihoAccoutType__c.containsIgnoreCase('生保契約者')){
                        acc.SeihoAccoutType__c += ';' + '生保契約者';
                    }
                }
                else{
                    acc.SeihoAccoutType__c = '生保契約者';
                }
                
                if (mapUpdateAccounts.get(acc.Id) == NULL) {
                    mapUpdateAccounts.put(acc.Id, acc);
                }
            }
        }
        
        // 元に連携した取引先取得する
        if(oldaccIdSet.size() > 0){
            // 関連先取引先取得
            List<Account> oldTargetAccounts =   [
                                                    SELECT Id, SeihoOppApplyflg__c, SeihoAccoutType__c 
                                                      FROM Account 
                                                     WHERE Id IN :oldaccIdSet
                                                ];
            // 関連先生保契約情報取得
            List<LifeContract__c> otherLifeContracts =  [
                                                            SELECT Id, AccountId__c 
                                                              FROM LifeContract__c 
                                                             WHERE AccountId__c IN :oldaccIdSet
                                                        ];
            Map<ID, Boolean> mapAccHasLifeContract = new Map<ID, Boolean>();
            for (LifeContract__c otherLC : otherLifeContracts) {
                if (otherLC.AccountId__c != NULL) {
                    mapAccHasLifeContract.put(otherLC.AccountId__c, TRUE);
                }
            }
            
            for (Account oldAcc : oldTargetAccounts) {
                // 元の取引先に生保契約情報は存在しない場合
                if (mapAccHasLifeContract.get(oldAcc.Id) == NULL) {
                    // 取得した取引先レコードについて、生保申込フラグをFALSEにする
                    oldAcc.SeihoOppApplyflg__c = FALSE;
                    
                    if (String.IsNotBlank(oldAcc.SeihoAccoutType__c)) {
                        if (oldAcc.SeihoAccoutType__c.containsIgnoreCase('生保契約者')) {
                            oldAcc.SeihoAccoutType__c = oldAcc.SeihoAccoutType__c.remove('生保契約者');
                        }
                    }
                }
                
                if (mapUpdateAccounts.get(oldAcc.Id) == NULL) {
                    mapUpdateAccounts.put(oldAcc.Id, oldAcc);
                }
            }
        }
        
        // 取引先の少短利用項目を更新
        if (!mapUpdateAccounts.IsEmpty())
            update mapUpdateAccounts.values();
    }
    
    
    /**
     * 生保契約情報作成・更新後処理
     * @param List<LifeContract__c>
     * @param Map<Id,LifeContract__c>
     * @return 
     */
    /** 契約者変更時の契約分割機能に伴い変更フラグON処理を撤廃 **/
/*    public void onAfterProcess(List<LifeContract__c> lifeContractList, Map<Id,LifeContract__c> oldMap){

        //取引先更新の判断フラグ
        boolean updateFlag = false;
        //取引先を格納するセット
        Set<Id> accountIdSet = new Set<Id>();
        for(LifeContract__c lifeContract : lifeContractList){
            accountIdSet.add(lifeContract.AccountId__c);
        }
        //更新用List
        Map<Id, Account> updateAccountMap = new Map<Id, Account>();

        //損保契約に紐づいている取引先の情報マップ
        Map<Id,Account> accountMap = new Map<Id,Account>();
        for(Account acc : [Select Id, furigana__c, Gender__pc, PersonBirthdate, nameChangedFlag__c, genderChangedFlag__c, birthdateChangedFlag__c from Account where Id IN: accountIdSet]){
            accountMap.put(acc.Id, acc);
        }

        for(LifeContract__c lifeContract : lifeContractList){
            if(lifeContract.KANA_CONTROR_NAME__c != oldMap.get(lifeContract.Id).KANA_CONTROR_NAME__c){
                if(accountMap.get(lifeContract.AccountId__c).furigana__c != lifeContract.KANA_CONTROR_NAME__c){
                    updateFlag = true;
                    accountMap.get(lifeContract.AccountId__c).nameChangedFlag__c = true;
                    updateAccountMap.put(accountMap.get(lifeContract.AccountId__c).Id, accountMap.get(lifeContract.AccountId__c));
                }
            }
            if(lifeContract.CONTROR_GENDER__c != oldMap.get(lifeContract.Id).CONTROR_GENDER__c){
                if(accountMap.get(lifeContract.AccountId__c).Gender__pc != lifeContract.CONTROR_GENDER__c){
                    updateFlag = true;
                    accountMap.get(lifeContract.AccountId__c).genderChangedFlag__c = true;
                    updateAccountMap.put(accountMap.get(lifeContract.AccountId__c).Id, accountMap.get(lifeContract.AccountId__c));
                }
            }
            if(lifeContract.CONTROR_BIRTH_DATE__c != oldMap.get(lifeContract.Id).CONTROR_BIRTH_DATE__c){
                Date birthDate = Date.parse(lifeContract.CONTROR_BIRTH_DATE__c);
                if(accountMap.get(lifeContract.AccountId__c).PersonBirthdate != birthDate){
                    updateFlag = true;
                    accountMap.get(lifeContract.AccountId__c).birthdateChangedFlag__c = true;
                    updateAccountMap.put(accountMap.get(lifeContract.AccountId__c).Id, accountMap.get(lifeContract.AccountId__c));
                }
            }
        }

        if(updateAccountMap.size() > 0){
            update updateAccountMap.values();
        }

    }*/
    
    /**
    * 生保契約情報作成前、更新前処理
    * @param List<LifeContract__c>
    * @param Map<Id,LifeContract__c>
    * @param String 
    * @return 
    */
    public void setAgencyMasterReference(List<LifeContract__c> newLifeContractList, Map<Id,LifeContract__c> oldLifeConMap,String operation){

        System.debug('Agency master setup');
        Set<String> agencyNumSet = new Set<String>();
        List<LifeContract__c> changedLifeContractList = new List<LifeContract__c>();

        if(operation.equals('insert')){
            for(LifeContract__c lifeContract : newLifeContractList){
                if(String.isNotBlank(lifeContract.AGENCY_NUM__c)){
                    agencyNumSet.add(lifeContract.AGENCY_NUM__c);
                }
            }
            setLifeContractAgency(newLifeContractList, agencyNumSet);

        }else if(operation.equals('update')){
            for(LifeContract__c lifeContract : newLifeContractList){
                LifeContract__c oldLifeCon = oldLifeConMap.get(lifeContract.Id);
                if(String.isNotBlank(lifeContract.AGENCY_NUM__c) && oldLifeCon.AGENCY_NUM__c != lifeContract.AGENCY_NUM__c ){
                    agencyNumSet.add(lifeContract.AGENCY_NUM__c);
                    changedLifeContractList.add(lifeContract);
                }else if(String.isBlank(lifeContract.AGENCY_NUM__c) && oldLifeCon.AGENCY_NUM__c != lifeContract.AGENCY_NUM__c){
                    changedLifeContractList.add(lifeContract);
                }
            }
            setLifeContractAgency(changedLifeContractList, agencyNumSet);
        }
        System.debug('-- agencyNumSet ' + agencyNumSet);                        
    }

    /**
    * 生保契約情報に金融機関名をセットする処理
    * @param List<LifeContract__c>
    * @param Map<Id,LifeContract__c>
    * @param String 
    * @return 
    */
    public void setBankName(List<LifeContract__c> newLifeContractList, Map<Id,LifeContract__c> newLifeContractMap, Map<Id,LifeContract__c> oldLifeContractMap, String operation){

        if(operation.equals('insert')){
            for(LifeContract__c lifeContract : newLifeContractList){
                if((String.isNotBlank(lifeContract.FNANCIAL_CODE__c) && String.isNotBlank(lifeContract.FINANCIAL_BRANCH_CODE__c)) || 
                  (String.isNotBlank(lifeContract.TOTAL_INS_FINANCIAL_CODE__c) && String.isNotBlank(lifeContract.TOTAL_INS_FINANCIAL_BRANCH_CODE__c))){
                    lifeContract.setBankNameFlag__c = true;
                }
            }
        }else if(operation.equals('update')){
            for(String lifeId : oldLifeContractMap.keySet()){
                if(oldLifeContractMap.get(lifeId).FNANCIAL_CODE__c != newLifeContractMap.get(lifeId).FNANCIAL_CODE__c || 
                   oldLifeContractMap.get(lifeId).FINANCIAL_BRANCH_CODE__c != newLifeContractMap.get(lifeId).FINANCIAL_BRANCH_CODE__c ||
                   oldLifeContractMap.get(lifeId).TOTAL_INS_FINANCIAL_CODE__c != newLifeContractMap.get(lifeId).TOTAL_INS_FINANCIAL_CODE__c ||
                   oldLifeContractMap.get(lifeId).TOTAL_INS_FINANCIAL_BRANCH_CODE__c != newLifeContractMap.get(lifeId).TOTAL_INS_FINANCIAL_BRANCH_CODE__c){
                        newLifeContractMap.get(lifeId).setBankNameFlag__c = true;
                }
            }
        }
    }

    /**
    * 生保契約情報に代理店を更新
    * @param List<LifeContract__c>
    * @param Set<String>
    * @return
    */
    public void setLifeContractAgency(List<LifeContract__c> lifeContractList,Set<String> agencyNumSet){

        Map<String,Id> seihoAgencyMasterMap = new Map<String,Id>();
        List<AgencyMaster__c> agencyList = [SELECT id,SeihoAgencyCode__c FROM AgencyMaster__c WHERE SeihoAgencyCode__c IN : agencyNumSet ];
        for(AgencyMaster__c agency : agencyList){
            seihoAgencyMasterMap.put(agency.SeihoAgencyCode__c, agency.Id);
        }

        System.debug('-- seihoAgencyMasterMap ' + seihoAgencyMasterMap);

        for(LifeContract__c lifeContract : lifeContractList){
            lifeContract.AgencyId__c = seihoAgencyMasterMap.get(lifeContract.AGENCY_NUM__c);
        }  
    }

    /**
    * 生保契約情報作成前、更新前処理
    * @param List<LifeContract__c>
    * @param Map<Id,LifeContract__c>
    * @param String 
    * @return 
    */
    public void setMasterReference(List<LifeContract__c> newLifeContractList, Map<Id,LifeContract__c> lifeContractNewMap, Map<Id,LifeContract__c> lifeContractOldMap,String operation){

        //カード会社コード用のリスト
        List<String> companyCodeList = new List<String>();
        //募集人番号用のリスト
        List<String> recruiterNoCodeList = new List<String>();
        //取扱いエージェント用のリスト
        List<String> handlingAgentList = new List<String>();
        //カード会社マスタからのカード会社コードを格納するマップ
        Map<String,Id> companyMasterMap = new Map<String,Id>();
        //生保募集人マスタからの募集人番号を格納するマップ
        Map<String,Id> recruiterMasterMap = new Map<String,Id>();
        //生保エージェントマスタからの会員識別SEQを格納するマップ
        Map<String,Id> handlingAgMasterMap = new Map<String,Id>();
        
        if(operation.equals('insert')){
            for(LifeContract__c life : newLifeContractList){
                if(!String.isEmpty(life.COMPANY_CODE__c)){
                    companyCodeList.add(life.COMPANY_CODE__c);
                }
                if(!String.isEmpty(life.RECRUITER_NUM__c)){
                    recruiterNoCodeList.add(life.RECRUITER_NUM__c);
                }
                if(!String.isEmpty(life.HANDLING_AGENT__c)){
                    handlingAgentList.add(life.HANDLING_AGENT__c);
                }
            }
        }

        if(operation.equals('update')){
            for(String lifeId : lifeContractOldMap.keySet()){
                //会社コード用の設定
                if(lifeContractOldMap.get(lifeId).COMPANY_CODE__c != lifeContractNewMap.get(lifeId).COMPANY_CODE__c){
                    //会社コードが消された場合
                    if(lifeContractNewMap.get(lifeId).COMPANY_CODE__c == null){
                        companyMasterMap.put(lifeContractOldMap.get(lifeId).COMPANY_CODE__c,null);
                    }else if(lifeContractOldMap.get(lifeId).COMPANY_CODE__c != null){
                        companyCodeList.add(lifeContractNewMap.get(lifeId).COMPANY_CODE__c);
                    }else{
                        //会社コードが最初にセットされた場合
                        companyCodeList.add(lifeContractNewMap.get(lifeId).COMPANY_CODE__c);
                    }
                }

                //募集人番号用の設定
                if(lifeContractOldMap.get(lifeId).RECRUITER_NUM__c != lifeContractNewMap.get(lifeId).RECRUITER_NUM__c){
                    //会社コードが消された場合
                    if(lifeContractNewMap.get(lifeId).RECRUITER_NUM__c == null){
                        recruiterMasterMap.put(lifeContractOldMap.get(lifeId).RECRUITER_NUM__c,null);
                    }else if(lifeContractOldMap.get(lifeId).RECRUITER_NUM__c != null){
                        recruiterNoCodeList.add(lifeContractNewMap.get(lifeId).RECRUITER_NUM__c);
                    }else{
                        //会社コードが最初にセットされた場合
                        recruiterNoCodeList.add(lifeContractNewMap.get(lifeId).RECRUITER_NUM__c);
                    }
                }
                
                //取扱いエージェント用の設定
                if(lifeContractOldMap.get(lifeId).HANDLING_AGENT__c != lifeContractNewMap.get(lifeId).HANDLING_AGENT__c){
                    //会社コードが消された場合
                    if(lifeContractNewMap.get(lifeId).HANDLING_AGENT__c == null){
                        handlingAgMasterMap.put(lifeContractOldMap.get(lifeId).HANDLING_AGENT__c,null);
                    }else if(lifeContractOldMap.get(lifeId).HANDLING_AGENT__c != null){
                        handlingAgentList.add(lifeContractNewMap.get(lifeId).HANDLING_AGENT__c);
                    }else{
                        //会社コードが最初にセットされた場合
                        handlingAgentList.add(lifeContractNewMap.get(lifeId).HANDLING_AGENT__c);
                    }
                }
            }
        }

        if(companyCodeList != null && companyCodeList.size() > 0){
            List<SeihoCcCompanyMaster__c> companyMasterList = [SELECT Id, CARD_COMPANY_CODE__c FROM SeihoCcCompanyMaster__c WHERE CARD_COMPANY_CODE__c IN: companyCodeList];
            for(SeihoCcCompanyMaster__c companyMaster : companyMasterList){
                companyMasterMap.put(companyMaster.CARD_COMPANY_CODE__c, companyMaster.Id);
            }
        }

        if(recruiterNoCodeList != null && recruiterNoCodeList.size() > 0){
            List<SeihoRecruiterMaster__c> recruiterMasterList = [SELECT Id, RECRUITER_NUMBER__c FROM SeihoRecruiterMaster__c WHERE RECRUITER_NUMBER__c IN: recruiterNoCodeList];
            for(SeihoRecruiterMaster__c recruitMaster : recruiterMasterList){
                recruiterMasterMap.put(recruitMaster.RECRUITER_NUMBER__c, recruitMaster.Id);
            }
        }

        if(handlingAgentList != null && handlingAgentList.size() > 0){
            List<SeihoAgentMaster__c> identificationMasterList = [SELECT Id, MEMBER_ID_SEQ__c FROM SeihoAgentMaster__c WHERE MEMBER_ID_SEQ__c IN: handlingAgentList];
            for(SeihoAgentMaster__c identityMaster : identificationMasterList){
                handlingAgMasterMap.put(identityMaster.MEMBER_ID_SEQ__c, identityMaster.Id);
            }
        }

        //更新の時でもマップの情報をリストに追加する。
        if(lifeContractNewMap != null && lifeContractNewMap.size() > 0) {
            newLifeContractList.addAll(lifeContractNewMap.values());
        }

        for(LifeContract__c life : newLifeContractList){
            if(   life.Id == Null
               || lifeContractOldMap.get(life.Id).COMPANY_CODE__c != lifeContractNewMap.get(life.Id).COMPANY_CODE__c){
                life.COMPANY_NAME__c = companyMasterMap.containsKey(life.COMPANY_CODE__c) ? companyMasterMap.get(life.COMPANY_CODE__c) : null;
            }
            if(   life.Id == Null
               || lifeContractOldMap.get(life.Id).RECRUITER_NUM__c != lifeContractNewMap.get(life.Id).RECRUITER_NUM__c){
                life.SEIHO_RECRUITER_NAME__c = recruiterMasterMap.containsKey(life.RECRUITER_NUM__c) ? recruiterMasterMap.get(life.RECRUITER_NUM__c) : null;
            }
            if(   life.Id == Null
               || lifeContractOldMap.get(life.Id).HANDLING_AGENT__c != lifeContractNewMap.get(life.Id).HANDLING_AGENT__c){
                life.AGENT_NAME__c = handlingAgMasterMap.containsKey(life.HANDLING_AGENT__c) ? handlingAgMasterMap.get(life.HANDLING_AGENT__c) : null;
            }
        }
    }
    
    
    // MEDIAIDα契約フラグ設定処理
    public void setMediaAlphaFlg(List<LifeContract__c> newLifeContractList, Map<Id, LifeContract__c> oldLifeConMap, String operation) {
        
        Set<String> lcParentIDNUMSet = new Set<String>();
        Set<String> childLCParentIDNUMSet = new Set<String>();
        Set<Id> lifeContractIDSet = new Set<Id>();
        for (LifeContract__c lifeContract : newLifeContractList) {
            
            LifeContract__c oldLifeContract = oldLifeConMap != NULL ? oldLifeConMap.get(lifeContract.Id) : NULL;
            // 主生保契約情報
            // MediaAlpha Child Contract
            if ((operation.equals('insert') && 
                 'メディエイドα'.equals(lifeContract.INSURANCE_TYPE_DISPLAY__c)) || 
                (operation.equals('update') && 
                 (lifeContract.IDENTIFICATION_NUM__c != oldLifeContract.IDENTIFICATION_NUM__c || 
                  lifeContract.INSURANCE_TYPE_DISPLAY__c != oldLifeContract.INSURANCE_TYPE_DISPLAY__c || 
                  lifeContract.PARENT_POL_PROD_CODE_DISPLAY__c != oldLifeContract.PARENT_POL_PROD_CODE_DISPLAY__c) && 
                 ('メディエイドα'.equals(lifeContract.INSURANCE_TYPE_DISPLAY__c)))) {
                
                if (String.isNotBlank(lifeContract.IDENTIFICATION_NUM__c) && 
                    String.isNotBlank(lifeContract.PARENT_POL_PROD_CODE_DISPLAY__c)) {
                    lcParentIDNUMSet.add(lifeContract.IDENTIFICATION_NUM__c);
                }
            }
            
            // 主生保契約情報
            // Parent Contract AND Child Contract
            // Skip Child Contract when Setting MediaAlpha Flag below
            if ( operation.equals('insert') || 
                (operation.equals('update') && 
                 (lifeContract.IDENTIFICATION_NUM__c != oldLifeContract.IDENTIFICATION_NUM__c || 
                  lifeContract.INSURANCE_TYPE_DISPLAY__c != oldLifeContract.INSURANCE_TYPE_DISPLAY__c))) {
                
                if (String.isNotBlank(lifeContract.IDENTIFICATION_NUM__c) && 
                    String.isNotBlank(lifeContract.INSURANCE_TYPE_DISPLAY__c)) {
                    lcParentIDNUMSet.add(lifeContract.IDENTIFICATION_NUM__c);
                    childLCParentIDNUMSet.add(lifeContract.IDENTIFICATION_NUM__c);
                }
                
                // MediaAlpha Parent, If IDENTIFICATION_NUM__c = NULL
                if (String.isBlank(lifeContract.IDENTIFICATION_NUM__c)) {
                    lifeContractIDSet.add(lifeContract.Id);
                }
                
            }
            
            // 元の主生保契約情報
            // Old MediaAlpha Child Contract
            if (operation.equals('update') && 
                (lifeContract.IDENTIFICATION_NUM__c != oldLifeContract.IDENTIFICATION_NUM__c || 
                 lifeContract.INSURANCE_TYPE_DISPLAY__c != oldLifeContract.INSURANCE_TYPE_DISPLAY__c || 
                 lifeContract.PARENT_POL_PROD_CODE_DISPLAY__c != oldLifeContract.PARENT_POL_PROD_CODE_DISPLAY__c) && 
                ('メディエイドα'.equals(oldLifeContract.INSURANCE_TYPE_DISPLAY__c))) {
                
                if (String.isNotBlank(oldLifeContract.IDENTIFICATION_NUM__c) && 
                    String.isNotBlank(oldLifeContract.PARENT_POL_PROD_CODE_DISPLAY__c)) {
                    lcParentIDNUMSet.add(oldLifeContract.IDENTIFICATION_NUM__c);
                    childLCParentIDNUMSet.add(oldLifeContract.IDENTIFICATION_NUM__c);
                }
            }
        }
        
        // 主生保契約情報を取得
        // Query Parent AND Child Contract
        List<LifeContract__c> parentLifeContractList =  [
                                                            SELECT Id
                                                                 , IDENTIFICATION_NUM__c
                                                                 , STATUS_DISPLAY__c
                                                                 , INSURANCE_TYPE_DISPLAY__c
                                                                 , MediaidAlfaFlg__c
                                                              FROM LifeContract__c
                                                             WHERE IDENTIFICATION_NUM__c IN :lcParentIDNUMSet
                                                                OR ID IN :lifeContractIDSet
                                                        ];
        Map<String, List<LifeContract__c>> mapParentLifeContracts = new Map<String, List<LifeContract__c>>();
        Map<Id, LifeContract__c> mapLifeContracts = new Map<Id, LifeContract__c>(parentLifeContractList);
        for (LifeContract__c parentLifeContract : parentLifeContractList) {
            if (String.IsNotBlank(parentLifeContract.IDENTIFICATION_NUM__c)) {
                if (mapParentLifeContracts.get(parentLifeContract.IDENTIFICATION_NUM__c) != NULL)
                    mapParentLifeContracts.get(parentLifeContract.IDENTIFICATION_NUM__c).add(parentLifeContract);
                else
                    mapParentLifeContracts.put(parentLifeContract.IDENTIFICATION_NUM__c, new List<LifeContract__c>{ parentLifeContract });
            }
        }
        
        // 元の主生保契約情報に関連する生保契約情報を取得
        // Query Child MediaAlpha Contract
        List<LifeContract__c> childLifeContractList = [
                                                        SELECT Id
                                                             , IDENTIFICATION_NUM__c
                                                             , STATUS_DISPLAY__c
                                                             , INSURANCE_TYPE_DISPLAY__c
                                                             , PARENT_POL_PROD_CODE_DISPLAY__c
                                                          FROM LifeContract__c
                                                         WHERE INSURANCE_TYPE_DISPLAY__c = 'メディエイドα'
                                                           AND IDENTIFICATION_NUM__c IN : childLCParentIDNUMSet
                                                           AND PARENT_POL_PROD_CODE_DISPLAY__c != NULL
                                                      ];
        Map<String, List<LifeContract__c>> mapChildLifeContracts = new Map<String, List<LifeContract__c>>();
        for (LifeContract__c childLifeContract : childLifeContractList) {
            if (String.IsNotBlank(childLifeContract.IDENTIFICATION_NUM__c)) {
                if (mapChildLifeContracts.get(childLifeContract.IDENTIFICATION_NUM__c) != NULL)
                    mapChildLifeContracts.get(childLifeContract.IDENTIFICATION_NUM__c).add(childLifeContract);
                else
                    mapChildLifeContracts.put(childLifeContract.IDENTIFICATION_NUM__c, new List<LifeContract__c>{ childLifeContract });
            }
        }
        
        Map<Id, LifeContract__c> mapLifeContractsToUpdate = new Map<Id, LifeContract__c>();
        for (LifeContract__c lifeContract : newLifeContractList) {
            
            LifeContract__c oldLifeContract = oldLifeConMap != NULL ? oldLifeConMap.get(lifeContract.Id) : NULL;
            // 主生保契約情報
            // MediaAlpha Child Contract
            // Get Parent Contract for MediaAlpha Child Contract
            // 子契約が無効になった場合、メディエイドα契約フラグはそのままにする（変更なし）
            if ((operation.equals('insert') && 
                 'メディエイドα'.equals(lifeContract.INSURANCE_TYPE_DISPLAY__c)) || 
                (operation.equals('update') && 
                 (lifeContract.IDENTIFICATION_NUM__c != oldLifeContract.IDENTIFICATION_NUM__c || 
                  lifeContract.INSURANCE_TYPE_DISPLAY__c != oldLifeContract.INSURANCE_TYPE_DISPLAY__c || 
                  lifeContract.PARENT_POL_PROD_CODE_DISPLAY__c != oldLifeContract.PARENT_POL_PROD_CODE_DISPLAY__c) && 
                 ('メディエイドα'.equals(lifeContract.INSURANCE_TYPE_DISPLAY__c)))) {
                
                if (String.isNotBlank(lifeContract.IDENTIFICATION_NUM__c) && 
                    String.isNotBlank(lifeContract.PARENT_POL_PROD_CODE_DISPLAY__c) && 
                    mapParentLifeContracts.get(lifeContract.IDENTIFICATION_NUM__c) != NULL) {
                    
                    // 条件に一致する生保契約情報のMEDIAIDα契約フラグを「有」に設定
                    // Set MediaAplha Flag to 有 for all the Parent Contracts for MediaAlpha Child Record
                    List<LifeContract__c> parentLifeContracts = mapParentLifeContracts.get(lifeContract.IDENTIFICATION_NUM__c);
                    for (LifeContract__c parentLifeContract : parentLifeContracts) {
                        if (lifeContract.PARENT_POL_PROD_CODE_DISPLAY__c == parentLifeContract.INSURANCE_TYPE_DISPLAY__c) {
                            parentLifeContract.MediaidAlfaFlg__c = '有';
                            
                            if (mapLifeContractsToUpdate.get(parentLifeContract.Id) == NULL) {
                                mapLifeContractsToUpdate.put(parentLifeContract.Id, parentLifeContract);
                            }
                        }
                    }
                }
            }
            
            // 主生保契約情報
            // Parent Contract AND Child Contract
            // Skip Child Contract when Setting MediaAlpha Flag below
            // 親契約が無効になった場合もメディエイドα契約フラグはそのままにする（変更なし）
            if ( operation.equals('insert') || 
                (operation.equals('update') && 
                 (lifeContract.IDENTIFICATION_NUM__c != oldLifeContract.IDENTIFICATION_NUM__c || 
                  lifeContract.INSURANCE_TYPE_DISPLAY__c != oldLifeContract.INSURANCE_TYPE_DISPLAY__c))) {
                
                Boolean bIsParent = FALSE;
                if (String.isNotBlank(lifeContract.IDENTIFICATION_NUM__c) && 
                    String.isNotBlank(lifeContract.INSURANCE_TYPE_DISPLAY__c) && 
                    mapLifeContracts.get(lifeContract.Id) != NULL && 
                    mapChildLifeContracts.get(lifeContract.IDENTIFICATION_NUM__c) != NULL) {
                    
                    // 条件に一致する生保契約情報のMEDIAIDα契約フラグを「有」に設定
                    // Set MediaAplha Flag for the Parent Contract thats is updated
                    List<LifeContract__c> childLifeContracts = mapChildLifeContracts.get(lifeContract.IDENTIFICATION_NUM__c);
                    for (LifeContract__c childLifeContract : childLifeContracts) {
                        if (childLifeContract.PARENT_POL_PROD_CODE_DISPLAY__c == lifeContract.INSURANCE_TYPE_DISPLAY__c) {
                            LifeContract__c lcToUpdate = mapLifeContracts.get(lifeContract.Id);
                            lcToUpdate.MediaidAlfaFlg__c = '有';
                            bIsParent = TRUE;
                            
                            if (mapLifeContractsToUpdate.get(lcToUpdate.Id) == NULL) {
                                mapLifeContractsToUpdate.put(lcToUpdate.Id, lcToUpdate);
                            }
                        }
                    }
                }
                
                if (!bIsParent && 
                    mapLifeContracts.get(lifeContract.Id) != NULL) {
                    
                    LifeContract__c lcToUpdate = mapLifeContracts.get(lifeContract.Id);
                    // Clear MediaAlpha Flag
                    lcToUpdate.MediaidAlfaFlg__c = NULL;
                    
                    if (mapLifeContractsToUpdate.get(lcToUpdate.Id) == NULL) {
                        mapLifeContractsToUpdate.put(lcToUpdate.Id, lcToUpdate);
                    }
                }
            }
            
            // 元の主生保契約情報
            // Old MediaAlpha Child Contract
            // 子契約が無効になった場合、メディエイドα契約フラグはそのままにする（変更なし）
            if (operation.equals('update') && 
                (lifeContract.IDENTIFICATION_NUM__c != oldLifeContract.IDENTIFICATION_NUM__c || 
                 lifeContract.INSURANCE_TYPE_DISPLAY__c != oldLifeContract.INSURANCE_TYPE_DISPLAY__c || 
                 lifeContract.PARENT_POL_PROD_CODE_DISPLAY__c != oldLifeContract.PARENT_POL_PROD_CODE_DISPLAY__c) && 
                ('メディエイドα'.equals(oldLifeContract.INSURANCE_TYPE_DISPLAY__c))) {
                
                if (String.isNotBlank(oldLifeContract.IDENTIFICATION_NUM__c) && 
                    String.isNotBlank(oldLifeContract.PARENT_POL_PROD_CODE_DISPLAY__c) && 
                    mapParentLifeContracts.get(oldLifeContract.IDENTIFICATION_NUM__c) != NULL) {
                    
                    Boolean bHasChild = FALSE;
                    // Check if Other Child MediaAlpha Contract exist
                    List<LifeContract__c> parentLifeContracts = mapParentLifeContracts.get(oldLifeContract.IDENTIFICATION_NUM__c);
                    List<LifeContract__c> childLifeContracts = mapChildLifeContracts.get(oldLifeContract.IDENTIFICATION_NUM__c);
                    if (childLifeContracts != NULL) {
                        for (LifeContract__c parentLifeContract : parentLifeContracts) {
                            for (LifeContract__c childLifeContract : childLifeContracts) {
                                if (childLifeContract.PARENT_POL_PROD_CODE_DISPLAY__c == parentLifeContract.INSURANCE_TYPE_DISPLAY__c && 
                                    childLifeContract.PARENT_POL_PROD_CODE_DISPLAY__c == oldLifeContract.PARENT_POL_PROD_CODE_DISPLAY__c) {
                                    bHasChild = TRUE;
                                }
                            }
                        }
                    }
                    
                    // Old MediaAlpha Contract has no other MediaAlpha Contracts
                    if (!bHasChild) {
                        // 検索結果が0件の場合、下記の条件に一致する生保契約情報のMEDIAIDα契約フラグを「NULL」に設定する
                        // Set MediaAplha Flag to NULL for all the Parent Contracts for MediaAlpha Child Record
                        for (LifeContract__c parentLifeContract : parentLifeContracts) {
                            if (oldLifeContract.PARENT_POL_PROD_CODE_DISPLAY__c == parentLifeContract.INSURANCE_TYPE_DISPLAY__c) {
                                parentLifeContract.MediaidAlfaFlg__c = NULL;
                                
                                if (mapLifeContractsToUpdate.get(parentLifeContract.Id) == NULL) {
                                    mapLifeContractsToUpdate.put(parentLifeContract.Id, parentLifeContract);
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // 主生保契約情報を更新する
        if (!mapLifeContractsToUpdate.IsEmpty()) 
            update mapLifeContractsToUpdate.values();
    }
    
    
    // ジュニア契約情報設定処理
    public void setJuniorFlg(List<LifeContract__c> newLifeContractList, Map<Id,LifeContract__c> oldLifeConMap, String operation) {
        
        Set<String> lcParentIDNUMSet = new Set<String>();
        Set<String> childLCParentIDNUMSet = new Set<String>();
        Set<Id> lifeContractIDSet = new Set<Id>();
        for (LifeContract__c lifeContract : newLifeContractList) {
            
            LifeContract__c oldLifeContract = oldLifeConMap != NULL ? oldLifeConMap.get(lifeContract.Id) : NULL;
            // 主生保契約情報
            // Junior Child Contract
            if ( operation.equals('insert') || 
                (operation.equals('update') && 
                 (lifeContract.JR_RIDER_SEQ_NUM__c != oldLifeContract.JR_RIDER_SEQ_NUM__c || 
                  lifeContract.INSURANCE_TYPE_DISPLAY__c != oldLifeContract.INSURANCE_TYPE_DISPLAY__c))) {
                
                if (String.isNotBlank(lifeContract.JR_RIDER_SEQ_NUM__c) && 
                    String.isNotBlank(lifeContract.INSURANCE_TYPE_DISPLAY__c)) {
                    lifeContractIDSet.add(lifeContract.Id);
                    lcParentIDNUMSet.add(lifeContract.JR_RIDER_SEQ_NUM__c);
                }
            }
            
            // 主生保契約情報
            // Junior Parent AND Child Contract
            // Skip Child Contract when Setting Junior Flag below
            if ( operation.equals('insert') || 
                (operation.equals('update') && 
                 (lifeContract.IDENTIFICATION_NUM__c != oldLifeContract.IDENTIFICATION_NUM__c || 
                  lifeContract.STATUS_DISPLAY__c != oldLifeContract.STATUS_DISPLAY__c || 
                  lifeContract.INSURANCE_TYPE_DISPLAY__c != oldLifeContract.INSURANCE_TYPE_DISPLAY__c))) {
                
                // Junior Parent
                if (String.isNotBlank(lifeContract.IDENTIFICATION_NUM__c) && 
                    String.isNotBlank(lifeContract.INSURANCE_TYPE_DISPLAY__c)) {
                    lcParentIDNUMSet.add(lifeContract.IDENTIFICATION_NUM__c);
                    childLCParentIDNUMSet.add(lifeContract.IDENTIFICATION_NUM__c);
                }
                
                // Junior Parent, If IDENTIFICATION_NUM__c = NULL
                if (String.isBlank(lifeContract.IDENTIFICATION_NUM__c) || 
                    String.isBlank(lifeContract.INSURANCE_TYPE_DISPLAY__c)) {
                    lifeContractIDSet.add(lifeContract.Id);
                }
                
                // Old Junior Parent
                if (operation.equals('update') && 
                    (String.isNotBlank(oldLifeContract.IDENTIFICATION_NUM__c) && 
                     String.isNotBlank(oldLifeContract.INSURANCE_TYPE_DISPLAY__c))) {
                    lcParentIDNUMSet.add(oldLifeContract.IDENTIFICATION_NUM__c);
                    childLCParentIDNUMSet.add(oldLifeContract.IDENTIFICATION_NUM__c);
                }
            }
            
            // 元の主生保契約情報
            // Old Junior Child Contract
            if (operation.equals('update') && 
                (lifeContract.JR_RIDER_SEQ_NUM__c != oldLifeContract.JR_RIDER_SEQ_NUM__c || 
                 lifeContract.INSURANCE_TYPE_DISPLAY__c != oldLifeContract.INSURANCE_TYPE_DISPLAY__c)) {
                
                if (String.isNotBlank(oldLifeContract.JR_RIDER_SEQ_NUM__c) && 
                    String.isNotBlank(oldLifeContract.INSURANCE_TYPE_DISPLAY__c)) {
                    lifeContractIDSet.add(oldLifeContract.Id);
                    lcParentIDNUMSet.add(oldLifeContract.JR_RIDER_SEQ_NUM__c);
                    childLCParentIDNUMSet.add(oldLifeContract.JR_RIDER_SEQ_NUM__c);
                }
            }
        }
        
        // 主生保契約情報を取得
        // 親契約が複数存在する場合は有効かつ登録口数の大きい方のレコードに関連付ける
        List<LifeContract__c> parentLifeContractList =  [
                                                            SELECT Id
                                                                 , IDENTIFICATION_NUM__c
                                                                 , INSURANCE_TYPE_DISPLAY__c
                                                                 , JR_RIDER_SEQ_NUM__c
                                                                 , STATUS_DISPLAY__c
                                                                 , JuniorFlg__c
                                                                 , JuniorContractFlg__c
                                                              FROM LifeContract__c
                                                             WHERE IDENTIFICATION_NUM__c IN :lcParentIDNUMSet
                                                                OR ID IN :lifeContractIDSet
                                                          ORDER BY REGISTRATION_NUM__c DESC
                                                        ];
        Map<String, List<LifeContract__c>> mapParentLifeContracts = new Map<String, List<LifeContract__c>>();
        Map<Id, LifeContract__c> mapLifeContracts = new Map<Id, LifeContract__c>(parentLifeContractList);
        for (LifeContract__c parentLifeContract : parentLifeContractList) {
            if (String.IsNotBlank(parentLifeContract.IDENTIFICATION_NUM__c)) {
                if (mapParentLifeContracts.get(parentLifeContract.IDENTIFICATION_NUM__c) != NULL)
                    mapParentLifeContracts.get(parentLifeContract.IDENTIFICATION_NUM__c).add(parentLifeContract);
                else
                    mapParentLifeContracts.put(parentLifeContract.IDENTIFICATION_NUM__c, new List<LifeContract__c>{ parentLifeContract });
            }
        }
        
        // 元の主生保契約情報に関連する生保契約情報を取得
        List<LifeContract__c> childLifeContractList =   [
                                                            SELECT Id
                                                                 , IDENTIFICATION_NUM__c
                                                                 , INSURANCE_TYPE_DISPLAY__c
                                                                 , JR_RIDER_SEQ_NUM__c
                                                                 , STATUS_DISPLAY__c
                                                                 , JuniorFlg__c
                                                                 , JuniorContractFlg__c
                                                              FROM LifeContract__c
                                                             WHERE JR_RIDER_SEQ_NUM__c IN : childLCParentIDNUMSet
                                                        ];
        Map<String, List<LifeContract__c>> mapChildLifeContracts = new Map<String, List<LifeContract__c>>();
        for (LifeContract__c childLifeContract : childLifeContractList) {
            if (String.IsNotBlank(childLifeContract.JR_RIDER_SEQ_NUM__c)) {
                if (mapChildLifeContracts.get(childLifeContract.JR_RIDER_SEQ_NUM__c) != NULL)
                    mapChildLifeContracts.get(childLifeContract.JR_RIDER_SEQ_NUM__c).add(childLifeContract);
                else
                    mapChildLifeContracts.put(childLifeContract.JR_RIDER_SEQ_NUM__c, new List<LifeContract__c>{ childLifeContract });
            }
        }
        
        Map<Id, LifeContract__c> mapLifeContractsToUpdate = new Map<Id, LifeContract__c>();
        for (LifeContract__c lifeContract : newLifeContractList) {
            
            LifeContract__c oldLifeContract = oldLifeConMap != NULL ? oldLifeConMap.get(lifeContract.Id) : NULL;
            
            // 主生保契約情報
            // Junior Child Contract
            // Get Parent Contract for Junior Child Contract
            // 子契約が無効になった場合、関連づけ削除+ジュニア契約有無はそのままにする（変更なし）
            if (( operation.equals('insert') || 
                 (operation.equals('update') && 
                  (lifeContract.JR_RIDER_SEQ_NUM__c != oldLifeContract.JR_RIDER_SEQ_NUM__c || 
                   lifeContract.INSURANCE_TYPE_DISPLAY__c != oldLifeContract.INSURANCE_TYPE_DISPLAY__c))) && 
                mapLifeContracts.get(lifeContract.Id) != NULL) {
                
                // Child Junior Contract
                LifeContract__c lcToUpdate = mapLifeContracts.get(lifeContract.Id);
                
                // 「ジュニア契約」の値にNULLを設定する（クリアする）
                lcToUpdate.JuniorContractFlg__c = NULL;
                
                if (String.IsNotBlank(lifeContract.JR_RIDER_SEQ_NUM__c) && 
                    String.IsNotBlank(lifeContract.INSURANCE_TYPE_DISPLAY__c) && 
                    mapParentLifeContracts.get(lifeContract.JR_RIDER_SEQ_NUM__c) != NULL) {
                    
                    // Parent Junior Contracts
                    // 条件に一致する生保契約情報のジュニア契約有無を「有」に設定
                    List<LifeContract__c> parentLifeContracts = mapParentLifeContracts.get(lifeContract.JR_RIDER_SEQ_NUM__c);
                    for (LifeContract__c parentLifeContract : parentLifeContracts) {
                        if (parentLifeContract.INSURANCE_TYPE_DISPLAY__c == lifeContract.INSURANCE_TYPE_DISPLAY__c) {
                            parentLifeContract.JuniorFlg__c = '有';
                            if (mapLifeContractsToUpdate.get(parentLifeContract.Id) == NULL) {
                                mapLifeContractsToUpdate.put(parentLifeContract.Id, parentLifeContract);
                            }
                            
                            // 親契約が複数存在する場合は有効かつ登録口数の大きい方のレコードに関連付ける
                            if ('有効'.equals(parentLifeContract.STATUS_DISPLAY__c)) {
                                lcToUpdate.JuniorContractFlg__c = parentLifeContract.Id;
                            }
                        }
                    }
                }
                
                if (mapLifeContractsToUpdate.get(lcToUpdate.Id) == NULL) {
                    mapLifeContractsToUpdate.put(lcToUpdate.Id, lcToUpdate);
                }
            }
            
            // 主生保契約情報
            // Junior Parent AND Child Contract
            // Skip Child Contract when Setting Junior Flag below
            if (( operation.equals('insert') || 
                 (operation.equals('update') && 
                  (lifeContract.IDENTIFICATION_NUM__c != oldLifeContract.IDENTIFICATION_NUM__c || 
                   lifeContract.STATUS_DISPLAY__c != oldLifeContract.STATUS_DISPLAY__c || 
                   lifeContract.INSURANCE_TYPE_DISPLAY__c != oldLifeContract.INSURANCE_TYPE_DISPLAY__c))) && 
                mapLifeContracts.get(lifeContract.Id) != NULL) {
                
                // Parent Junior Contract
                LifeContract__c lcToUpdate = mapLifeContracts.get(lifeContract.Id);
                
                // 「ジュニア契約」の値にNULLを設定する（クリアする）
                lcToUpdate.JuniorFlg__c = NULL;
                
                if (String.isNotBlank(lifeContract.IDENTIFICATION_NUM__c) && 
                    String.isNotBlank(lifeContract.INSURANCE_TYPE_DISPLAY__c) && 
                    mapChildLifeContracts.get(lifeContract.IDENTIFICATION_NUM__c) != NULL) {
                    
                    // Parent Contract to be linked
                    LifeContract__c parentLifeContract = NULL;
                    if (mapParentLifeContracts.get(lifeContract.IDENTIFICATION_NUM__c) != NULL) {
                        List<LifeContract__c> parentLifeContracts = mapParentLifeContracts.get(lifeContract.IDENTIFICATION_NUM__c);
                        for (LifeContract__c parentLC : parentLifeContracts) {
                            if (parentLC.INSURANCE_TYPE_DISPLAY__c == lifeContract.INSURANCE_TYPE_DISPLAY__c) {
                                // 親契約が複数存在する場合は有効かつ登録口数の大きい方のレコードに関連付ける
                                if ('有効'.equals(parentLC.STATUS_DISPLAY__c)) {
                                    parentLifeContract = parentLC;
                                }
                            }
                        }
                    }
                    
                    // Child Junior Contracts
                    List<LifeContract__c> childLifeContracts = mapChildLifeContracts.get(lifeContract.IDENTIFICATION_NUM__c);
                    for (LifeContract__c childLifeContract : childLifeContracts) {
                        if (childLifeContract.INSURANCE_TYPE_DISPLAY__c == lifeContract.INSURANCE_TYPE_DISPLAY__c) {
                            if ((parentLifeContract != NULL && 
                                 childLifeContract.JuniorContractFlg__c != parentLifeContract.Id) ||
                                (parentLifeContract == NULL && 
                                 childLifeContract.JuniorContractFlg__c != NULL)) {
                                // ジュニア契約情報に連携する
                                childLifeContract.JuniorContractFlg__c = parentLifeContract != NULL ? parentLifeContract.Id : NULL;
                                
                                if (mapLifeContractsToUpdate.get(childLifeContract.Id) == NULL) {
                                    mapLifeContractsToUpdate.put(childLifeContract.Id, childLifeContract);
                                }
                            }
                            
                            // 条件に一致する生保契約情報のジュニア契約有無を「有」に設定
                            // Set Junior Flag for the Parent Contract thats is updated
                            lcToUpdate.JuniorFlg__c = '有';
                        }
                    }
                }
                
                if (mapLifeContractsToUpdate.get(lcToUpdate.Id) == NULL) {
                    mapLifeContractsToUpdate.put(lcToUpdate.Id, lcToUpdate);
                }
                
                // Parent and Child with Old IDENTIFICATION_NUM__c
                // 親契約が無効になった際、別の有効な親契約が存在する場合は、
                // 上記のロジックに従って関連付けをし直す
                if (operation.equals('update') && 
                    (String.isNotBlank(oldLifeContract.IDENTIFICATION_NUM__c) && 
                     String.isNotBlank(oldLifeContract.INSURANCE_TYPE_DISPLAY__c)) && 
                    mapChildLifeContracts.get(oldLifeContract.IDENTIFICATION_NUM__c) != NULL) {
                    
                    // Parent Contract to be linked
                    LifeContract__c parentLifeContract = NULL;
                    if (mapParentLifeContracts.get(oldLifeContract.IDENTIFICATION_NUM__c) != NULL) {
                        List<LifeContract__c> parentLifeContracts = mapParentLifeContracts.get(oldLifeContract.IDENTIFICATION_NUM__c);
                        for (LifeContract__c parentLC : parentLifeContracts) {
                            if (parentLC.INSURANCE_TYPE_DISPLAY__c == oldLifeContract.INSURANCE_TYPE_DISPLAY__c) {
                                // 親契約が複数存在する場合は有効かつ登録口数の大きい方のレコードに関連付ける
                                if ('有効'.equals(parentLC.STATUS_DISPLAY__c)) {
                                    parentLifeContract = parentLC;
                                }
                            }
                        }
                    }
                    
                    // Old Child Junior Contracts Link the ParentId for Multiple Parent Case
                    // If No Parent exit set the Link to NULL
                    List<LifeContract__c> childLifeContracts = mapChildLifeContracts.get(oldLifeContract.IDENTIFICATION_NUM__c);
                    for (LifeContract__c childLifeContract : childLifeContracts) {
                        if (childLifeContract.INSURANCE_TYPE_DISPLAY__c == oldLifeContract.INSURANCE_TYPE_DISPLAY__c) {
                            if ((parentLifeContract != NULL && 
                                 childLifeContract.JuniorContractFlg__c != parentLifeContract.Id) ||
                                (parentLifeContract == NULL && 
                                 childLifeContract.JuniorContractFlg__c != NULL)) {
                                // 「ジュニア契約」情報に連携するか
                                // 「ジュニア契約」の値にNULLを設定する
                                childLifeContract.JuniorContractFlg__c = parentLifeContract != NULL ? parentLifeContract.Id : NULL;
                                
                                if (mapLifeContractsToUpdate.get(childLifeContract.Id) == NULL) {
                                    mapLifeContractsToUpdate.put(childLifeContract.Id, childLifeContract);
                                }
                            }
                        }
                    }
                }
            }
            
            // 元の主生保契約情報
            // Old Junior Child Contract
            // 子契約が無効になった場合、関連づけ削除+ジュニア契約有無はそのままにする（変更なし）
            if (operation.equals('update') && 
                (lifeContract.JR_RIDER_SEQ_NUM__c != oldLifeContract.JR_RIDER_SEQ_NUM__c || 
                 lifeContract.INSURANCE_TYPE_DISPLAY__c != oldLifeContract.INSURANCE_TYPE_DISPLAY__c) && 
                mapLifeContracts.get(oldLifeContract.Id) != NULL) {
                
                // Check if Other Child Junior Contract exist
                Boolean hasChild = false;
                // Child Junior Contracts
                List<LifeContract__c> childLifeContracts = mapChildLifeContracts.get(oldLifeContract.JR_RIDER_SEQ_NUM__c);
                if (childLifeContracts != NULL) {
                    for (LifeContract__c childLifeContract : childLifeContracts) {
                        if (childLifeContract.INSURANCE_TYPE_DISPLAY__c == oldLifeContract.INSURANCE_TYPE_DISPLAY__c) {
                            hasChild = true;
                        }
                    }
                }
                
                // Old Junior Parent Contracts
                if ((String.isNotBlank(oldLifeContract.JR_RIDER_SEQ_NUM__c) && 
                     String.isNotBlank(oldLifeContract.INSURANCE_TYPE_DISPLAY__c)) &&
                    mapParentLifeContracts.get(oldLifeContract.JR_RIDER_SEQ_NUM__c) != NULL && 
                    !hasChild) {
                    
                    // 検索結果が0件の場合、下記の条件に一致する生保契約情報のジュニア契約有無を「Null」に設定する
                    List<LifeContract__c> parentLifeContracts = mapParentLifeContracts.get(oldLifeContract.JR_RIDER_SEQ_NUM__c);
                    for (LifeContract__c parentLifeContract : parentLifeContracts) {
                        if (parentLifeContract.INSURANCE_TYPE_DISPLAY__c == oldLifeContract.INSURANCE_TYPE_DISPLAY__c) {
                            // 一致する主生保契約情報のジュニア契約有無を「NULL」に設定する
                            parentLifeContract.JuniorFlg__c = NULL;
                            
                            if (mapLifeContractsToUpdate.get(parentLifeContract.Id) == NULL) {
                                mapLifeContractsToUpdate.put(parentLifeContract.Id, parentLifeContract);
                            }
                        }
                    }
                }
            }
        }
        
        // 主生保契約情報を更新する
        if (!mapLifeContractsToUpdate.IsEmpty()) 
            update mapLifeContractsToUpdate.values();
    }
}