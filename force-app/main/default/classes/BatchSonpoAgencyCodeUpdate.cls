/*
* @Class Name      : BatchSonpoAgencyCodeUpdate
* @Description     : 損保契約の代理店コードを更新するバッチ
* @Created Date    : 2020.02.19
* @Created By      : R,Karthikeyan
* @Modified Date   : 
* @Modified        : 
*/

global class BatchSonpoAgencyCodeUpdate implements Database.Batchable<SObject>,Database.Stateful{

    //バッチ起動制御オブジェクトの処理IDを格納
    public String batchControlJobId{get;set;}
    //バッチ起動制御オブジェクトの処理名を格納
    public String batchJobName{get;set;}
    //バッチ処理済フラグ
    public boolean batchProcessedFlag{get;set;}
    //バッチ処理中の例外発生管理フラグ
    public boolean batchExceptionFlag{get;set;}
    //バッチ対象の損保契約レコードの総件数を格納
    public Integer damageContractRecordCount{get;set;}
     //更新対象レコードの総件数
     public Integer updatedRecordCount{get;set;}

    public BatchSonpoAgencyCodeUpdate(String jobId, String jobName) {
        batchControlJobId = jobId;
        batchJobName = jobName;
        damageContractRecordCount = 0;
        updatedRecordCount = 0;
        batchProcessedFlag = false;
        batchExceptionFlag = false;
    }

    /**
     * BatchableインタフェースのStart関数
     * @param Database.BatchableContext
     * @return 
     */
    global Database.QueryLocator start(Database.BatchableContext bc){

        String query = 'SELECT Id, AgencyCode__c, AgencyCode1__c, AgencyCode2__c, AgencyCode3__c, AgencyCode4__c, AgencyCode5__c, AgencyId1__c, AgencyId2__c, AgencyId3__c, ';
               query += 'AgencyId4__c, AgencyId5__c, isAgencyCodeChanged__c FROM DamageContract__c WHERE isAgencyCodeChanged__c = true';

        Integer damageContractRecordCount = [SELECT count() FROM DamageContract__c WHERE isAgencyCodeChanged__c = true];  

        return Database.getQueryLocator(query);
    }

    /**
     * Batchableインタフェースのexecute関数
     * @param Database.BatchableContext
     * @param List<DamageContract__c>
     * @return 
     */
    global void execute(Database.BatchableContext bc, List<DamageContract__c> damageContractList){

        batchProcessedFlag = true;
        Map<String,Id> agencyMasterMap = new Map<String,Id>();
        List<DamageContract__c> damageContractUpdateList = new List<DamageContract__c>();

        agencyMasterMap = searchAgencyMaster(clearDamageContractAgencyCode(damageContractList));
        damageContractUpdateList = setDamageContractAgency(damageContractList, agencyMasterMap);

        try {
            UPDATE damageContractUpdateList;
            updatedRecordCount += damageContractUpdateList.size();
        } catch (Exception e) {
            batchExceptionFlag = true;
            BatchCaseCreationHelper.updateBatchRunStatus(batchControlJobId, '2', e.getMessage(), batchJobName, damageContractRecordCount, updatedRecordCount);
        }
    }

    /**
     * Batchableインタフェースのfinish関数
     * @param Database.BatchableContext
     * @return 
     */
    global void finish(Database.BatchableContext bc){

        if(batchProcessedFlag && !batchExceptionFlag)
            //成功ステータスを更新
            BatchCaseCreationHelper.updateBatchRunStatus(batchControlJobId, '1', null,batchJobName, damageContractRecordCount, updatedRecordCount);
    }
    
    /**
    * 代理店マスタの検索
    * @param List<DamageContract__c>
    * @return Map<String,Id>
    */
    public Map<String,Id> searchAgencyMaster(List<DamageContract__c> newDamageContractList){
        
        System.debug(Logginglevel.ERROR, 'inside search ' + newDamageContractList);
        System.debug(Logginglevel.ERROR, '■searchAgencyMaster001 : ' + Limits.getCpuTime());

        //検索用の代理店コードリスト
        List<String> inputAgencyCodeList = new List<String>();
        Map<String,Id> agencyMasterMap = new Map<String,Id>();

        for(Sobject damage : newDamageContractList){
            System.debug(Logginglevel.ERROR, '--agency code ' + damage.get('AgencyCode__c'));
            List<String> agencyCodeList = damage.get('AgencyCode__c') != null ? ((String)damage.get('AgencyCode__c')).split(',') : new List<String>();
            if(agencyCodeList.size() >= 2){
                for(Integer index = 0;index<agencyCodeList.size();index++){
                    damage.put('AgencyCode' + String.valueOf(index+1) + '__c',agencyCodeList.get(index));
                }
            }else if(agencyCodeList.size() == 1){
                damage.put('AgencyCode1__c',agencyCodeList.get(0));
            }
            
            System.debug(Logginglevel.ERROR, '-- inside Damage contract list ' + newDamageContractList);

            if(String.isNotBlank((String)damage.get('AgencyCode__c'))){
                for(String  key : ((String)damage.get('AgencyCode__c')).split(',')){
                    inputAgencyCodelist.add(key);
                }
                System.debug(Logginglevel.ERROR, 'inputAgencyCodeList ' + inputAgencyCodeList);
            }        
            System.debug(Logginglevel.ERROR, 'out inputAgencyCodeList ' + inputAgencyCodeList);
        }

        System.debug(Logginglevel.ERROR, '■searchAgencyMaster002 : ' + Limits.getCpuTime());
        List<AgencyMaster__c> agencyList = [SELECT id,SonpoAgencyCode__c FROM AgencyMaster__c WHERE SonpoAgencyCode__c IN: inputAgencyCodeList];
        System.debug(Logginglevel.ERROR, 'agencyList::'+agencyList );
        for(AgencyMaster__c agency : agencyList){
            agencyMasterMap.put(agency.SonpoAgencyCode__c, agency.Id);
        }
        return agencyMasterMap;
    }

    /**
    * 生保契約情報の項目クリア
    * @param List<DamageContract__c>
    * @return List<DamageContract__c>
    */
    public List<DamageContract__c> clearDamageContractAgencyCode(List<DamageContract__c> damageContractList){

        System.debug(Logginglevel.ERROR, '■clearDamageContractAgencyCode001 : ' + Limits.getCpuTime());
        for(DamageContract__c damageContract : damageContractList){

            damageContract.AgencyCode1__c = '';
            damageContract.AgencyCode2__c = '';
            damageContract.AgencyCode3__c = '';
            damageContract.AgencyCode4__c = '';
            damageContract.AgencyCode5__c = '';

            damageContract.AgencyId1__c = null;
            damageContract.AgencyId2__c = null;
            damageContract.AgencyId3__c = null;
            damageContract.AgencyId4__c = null;
            damageContract.AgencyId5__c = null;
        }
        System.debug(Logginglevel.ERROR, '■clearDamageContractAgencyCode002 : ' + Limits.getCpuTime());
        return damageContractList;
    }

    /**
    * 生保契約情報に代理店を更新
    * @param List<DamageContract__c>
    * @param Map<String,Id>
    * @return List<DamageContract__c>
    */
    public List<DamageContract__c> setDamageContractAgency(List<DamageContract__c> damageContractList, Map<String,Id> agencyMasterMap){

        System.debug(Logginglevel.ERROR, '■setDamageContractAgency001 : ' + Limits.getCpuTime());
        for(DamageContract__c damage : damageContractList){

            damage.AgencyId1__c = agencyMasterMap.get(damage.AgencyCode1__c) != null ? agencyMasterMap.get(damage.AgencyCode1__c) : null;
            damage.AgencyId2__c = agencyMasterMap.get(damage.AgencyCode2__c) != null ? agencyMasterMap.get(damage.AgencyCode2__c) : null;
            damage.AgencyId3__c = agencyMasterMap.get(damage.AgencyCode3__c) != null ? agencyMasterMap.get(damage.AgencyCode3__c) : null;
            damage.AgencyId4__c = agencyMasterMap.get(damage.AgencyCode4__c) != null ? agencyMasterMap.get(damage.AgencyCode4__c) : null;
            damage.AgencyId5__c = agencyMasterMap.get(damage.AgencyCode5__c) != null ? agencyMasterMap.get(damage.AgencyCode5__c) : null;

            damage.isAgencyCodeChanged__c = false;

            //テスト用のコード、エラー起きるパターン
            if(Test.isRunningTest() && BatchRunControlTriggerTest.faliureCaseFlag){
                damage.AgencyId1__c = '5000p000002bCpzAAE';
            }
        }
        System.debug(Logginglevel.ERROR, '■setDamageContractAgency002 : ' + Limits.getCpuTime());
        return damageContractList;
    }
}