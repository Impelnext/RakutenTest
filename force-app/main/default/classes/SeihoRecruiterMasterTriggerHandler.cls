/*
* @Class Name      : SeihoRecruiterMasterTriggerHandler 
* @Description     : 生保募集人マスタ
* @Created Date    : 2020.05.26
* @Created By      : SRM
* @Modified Date   : 2020.07.20
* @Modified By     : SRM
* @Modified Date   : 2021.02.15
* @Modified By     : SRM - ONYX（マスタ-取引先関連付け対応）
*/
public class SeihoRecruiterMasterTriggerHandler{
    
    /**
    * 生保募集人マスタ - onBeforeProcess
    * @param List<SeihoRecruiterMaster__c>
    * @param map<Id,SeihoRecruiterMaster__c>
    * @return 
    */
    public void onBeforeProcess(List<SeihoRecruiterMaster__c> seihoRecruiterMasterList, Map<Id,SeihoRecruiterMaster__c> oldSeihoRecruiterMasterMap) {
        
        // 代理店番号を格納するセット
        Set<String> agencyNoSet = new Set<String>();
        
        for (SeihoRecruiterMaster__c recruit : seihoRecruiterMasterList) {
            // 新規登録・顧客番号更新の場合、
            // 顧客番号更新フラグをTRUEにする
            if (oldSeihoRecruiterMasterMap == NULL || 
                oldSeihoRecruiterMasterMap.get(recruit.id).CS_ID__c != recruit.CS_ID__c) {
                recruit.CSID_ChangeFlag__c = TRUE;
            }
            
            if (oldSeihoRecruiterMasterMap == NULL || 
                oldSeihoRecruiterMasterMap.get(recruit.id).AGENCY_NUMBER__c != recruit.AGENCY_NUMBER__c) {
                if (recruit.AGENCY_NUMBER__c != null) {
                    agencyNoSet.add(recruit.AGENCY_NUMBER__c);
                }
            }
        }
        
        //代理店番号に基づいて生保代理店マスタ情報を取得
        Map<String, SeihoAgencyMaster__c> agencyMap = new Map<String,SeihoAgencyMaster__c>();
        if(!agencyNoSet.isempty()) {
            agencyMap = MasterHelper.getSeihoAgencyMasterFromAgencyNo(agencyNoSet);
        }
        
        for (SeihoRecruiterMaster__c recruit : seihoRecruiterMasterList) {
            if (oldSeihoRecruiterMasterMap == NULL || 
                oldSeihoRecruiterMasterMap.get(recruit.id).AGENCY_NUMBER__c != recruit.AGENCY_NUMBER__c) {
                recruit.SeihoAgencyMasterName__c = agencyMap.get(recruit.AGENCY_NUMBER__c) != null ? agencyMap.get(recruit.AGENCY_NUMBER__c).Id : null;
            }
        }
    }
}