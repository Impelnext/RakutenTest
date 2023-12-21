/*
* @Class Name      : SeihoAgentMasterTriggerHandler 
* @Description     : 生保エージェントマスタのトリガーハンドラー
* @Created Date    : 2020.05.26
* @Created By      : SRM
* @Modified Date   : 2020.07.20
* @Modified By     : SRM
* @Modified Date   : 2021.02.15
* @Modified By     : SRM - ONYX（マスタ-取引先関連付け対応）
*/
public class SeihoAgentMasterTriggerHandler {
    
    /**
    * 作成前・更新前処理
    * @param List<SeihoAgentMaster__c>
    * @param Map<Id, SeihoAgentMaster__c>
    * @return 
    */
    public void onBeforeProcess(List<SeihoAgentMaster__c> seihoAgentMasterList, Map<Id,SeihoAgentMaster__c> oldSeihoAgentMasterMap) {
        
        //銀行コードを格納するセット
        Set<String> bankCodeSet = new Set<String>();
        //支社コードを格納するセット
        Set<String> branchCodeSet = new Set<String>();
        //金融機関マスタ情報を格納するマップ
        Map<String, BankMaster__c> bankMasterMap = new Map<String, BankMaster__c>();
        
        for (SeihoAgentMaster__c seihoAgent : seihoAgentMasterList) {
            // 新規登録・顧客番号更新の場合、
            // 顧客番号更新フラグをTRUEにする
            if (oldSeihoAgentMasterMap == NULL || 
                oldSeihoAgentMasterMap.get(seihoAgent.Id).CS_ID__c != seihoAgent.CS_ID__c) {
                seihoAgent.CSID_ChangeFlag__c = TRUE;
            }
            
            if(oldSeihoAgentMasterMap == null || 
               (oldSeihoAgentMasterMap.get(seihoAgent.Id).BANK_CODE__c != seihoAgent.BANK_CODE__c || 
                oldSeihoAgentMasterMap.get(seihoAgent.Id).BRANCH_CODE__c != seihoAgent.BRANCH_CODE__c)) {
                if (seihoAgent.BANK_CODE__c != NULL && seihoAgent.BRANCH_CODE__c != NULL) {
                    bankCodeSet.add(seihoAgent.BANK_CODE__c);
                    branchCodeSet.add(seihoAgent.BRANCH_CODE__c);
                }
            }
            
            if (oldSeihoAgentMasterMap == NULL || 
                oldSeihoAgentMasterMap.get(seihoAgent.Id).BELONG_AGENT__c != seihoAgent.BELONG_AGENT__c) {
                if (seihoAgent.BELONG_AGENT__c != NULL) {
                    seihoAgent.SeihoAgentParentFlag__c = TRUE;
                }
                else{
                    seihoAgent.SeihoAgentParent__c = NULL;
                    seihoAgent.SeihoAgentParentFlag__c = FALSE;
                }
            }
        }
        
        //銀行コード、支社コードに基づいて金融機関マスタ情報を取得
        if (!bankCodeSet.isEmpty() && !branchCodeSet.isEmpty()) {
            bankMasterMap = MasterHelper.getBankMasterFromBankCodeAndBranchCode(bankCodeSet,branchCodeSet);
        }
        
        for (SeihoAgentMaster__c seihoAgent : seihoAgentMasterList) {
            if(oldSeihoAgentMasterMap == NULL || 
               (oldSeihoAgentMasterMap.get(seihoAgent.Id).BANK_CODE__c != seihoAgent.BANK_CODE__c || 
                oldSeihoAgentMasterMap.get(seihoAgent.Id).BRANCH_CODE__c != seihoAgent.BRANCH_CODE__c)){
                seihoAgent.BankName__c = bankMasterMap.get(seihoAgent.BANK_CODE__c+seihoAgent.BRANCH_CODE__c) != NULL ?  bankMasterMap.get(seihoAgent.BANK_CODE__c+seihoAgent.BRANCH_CODE__c).BankName__c : '';
                seihoAgent.BranchName__c = bankMasterMap.get(seihoAgent.BANK_CODE__c+seihoAgent.BRANCH_CODE__c) != NULL ? bankMasterMap.get(seihoAgent.BANK_CODE__c+seihoAgent.BRANCH_CODE__c).BranchName__c : '';
            }
        }
    }
}