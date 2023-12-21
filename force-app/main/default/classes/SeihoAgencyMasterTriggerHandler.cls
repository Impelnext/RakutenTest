/*
* @Class Name      : SeihoAgencyMasterTriggerHandler 
* @Description     : 生保代理店マスタのトリガーハンドラー
* @Created Date    : 2020.05.26
* @Created By      : SRM
* @Modified Date   : 2020.07.20
* @Modified By     : SRM
* @Modified Date   : 2021.02.15
* @Modified By     : SRM - ONYX（マスタ-取引先関連付け対応）
*/
public class SeihoAgencyMasterTriggerHandler {

    /**
    *　挿入・更新前処理
    * @param List<SeihoAgencyMaster__c>
    * @param Map<Id,SeihoAgencyMaster__c>
    * @return 
    */
    public void onBeforeProcess(List<SeihoAgencyMaster__c> seihoAgencyMasterList,Map<Id,SeihoAgencyMaster__c> oldSeihoAgencyMasterMap) {
        
        //銀行コードを格納するセット
        Set<String> bankCodeSet = new Set<String>();
        //支社コードを格納するセット
        Set<String> branchCodeSet = new Set<String>();
        //金融機関マスタ情報を格納するマップ
        Map<String,BankMaster__c> bankMasterMap = new Map<String,BankMaster__c>();
        
        for (SeihoAgencyMaster__c seihoAgency : seihoAgencyMasterList) {
            // 新規登録・顧客番号更新の場合、
            // 顧客番号更新フラグをTRUEにする
            if (oldSeihoAgencyMasterMap == NULL || 
                oldSeihoAgencyMasterMap.get(seihoAgency.Id).csid__c != seihoAgency.csid__c) {
                seihoAgency.CSID_ChangeFlag__c = TRUE;
            }
            
            if (oldSeihoAgencyMasterMap == null || 
                (oldSeihoAgencyMasterMap.get(seihoAgency.Id).cmmsspymnbankcd__c != seihoAgency.cmmsspymnbankcd__c || 
                 oldSeihoAgencyMasterMap.get(seihoAgency.Id).cmmsspymnbrnchcd__c != seihoAgency.cmmsspymnbrnchcd__c)) {
                if (seihoAgency.cmmsspymnbankcd__c != null && seihoAgency.cmmsspymnbrnchcd__c !=null) {
                    bankCodeSet.add(seihoAgency.cmmsspymnbankcd__c);
                    branchCodeSet.add(seihoAgency.cmmsspymnbrnchcd__c);
                }
            }
            
            if (oldSeihoAgencyMasterMap == null || 
                oldSeihoAgencyMasterMap.get(seihoAgency.Id).tantoupbragncyno__c != seihoAgency.tantoupbragncyno__c) {
                if (seihoAgency.tantoupbragncyno__c != null) {
                    seihoAgency.AgencyNameFlag__c = true;
                }
                else {
                    seihoAgency.SeihoAgencyIkusei__c = null;
                    seihoAgency.AgencyNameFlag__c = false;
                }
            }
        }
        
        //銀行コード、支社コードに基づいて金融機関マスタ情報を取得
        if(!bankCodeSet.isEmpty() && !branchCodeSet.isEmpty()){
            bankMasterMap = MasterHelper.getBankMasterFromBankCodeAndBranchCode(bankCodeSet,branchCodeSet);
        }
        
        for (SeihoAgencyMaster__c seihoAgency : seihoAgencyMasterList) { 
            if (oldSeihoAgencyMasterMap == null || 
                (oldSeihoAgencyMasterMap.get(seihoAgency.Id).cmmsspymnbankcd__c != seihoAgency.cmmsspymnbankcd__c || 
                 oldSeihoAgencyMasterMap.get(seihoAgency.Id).cmmsspymnbrnchcd__c != seihoAgency.cmmsspymnbrnchcd__c)) {
                seihoAgency.HurikomiBank__c = bankMasterMap.get(seihoAgency.cmmsspymnbankcd__c+seihoAgency.cmmsspymnbrnchcd__c) != null ?  bankMasterMap.get(seihoAgency.cmmsspymnbankcd__c+seihoAgency.cmmsspymnbrnchcd__c).BankName__c : '';
                seihoAgency.HurikomiBranch__c = bankMasterMap.get(seihoAgency.cmmsspymnbankcd__c+seihoAgency.cmmsspymnbrnchcd__c) != null ? bankMasterMap.get(seihoAgency.cmmsspymnbankcd__c+seihoAgency.cmmsspymnbrnchcd__c).BranchName__c : '';
            }
        }
    }
}