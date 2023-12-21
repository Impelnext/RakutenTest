/*
* @Class Name      : BatchRunControlTriggerHandler 
* @Description     : バッチ起動制御トリガーハンドラ
* @Created Date    : 2019.06.20
* @Created By      : 
* @Modified Date   : 
* @Modified        : 
*/

public class BatchRunControlTriggerHandler {

    public void onAfterInsertProcess(List<BatchRunControl__c> batchRunControlList){

        for(BatchRunControl__c bRunControl : batchRunControlList){
            //少短資料請求登録時にケースを作成する
            if(bRunControl.JobName__c.equalsIgnoreCase('BatchSyotanDocRequestCaseCreation') && bRunControl.Status__c == '0'){
                BatchSyotanDocRequestCaseCreation syotanDocBatch = new BatchSyotanDocRequestCaseCreation(bRunControl.Name, bRunControl.JobName__c);
                Database.executeBatch(syotanDocBatch,200);
            }
            /*
            //損保資料請求登録時にケースを作成する
            else if(bRunControl.JobName__c.equalsIgnoreCase('BatchGeneralRequestCaseCreation') && bRunControl.Status__c == '0'){
                BatchGeneralRequestCaseCreation generalReqBatch = new BatchGeneralRequestCaseCreation(bRunControl.Name, bRunControl.JobName__c);
                Database.executeBatch(generalReqBatch,200);
            }
            */
            //損保契約登録更新時に代理店マスタとの紐づけを行う
            else if(bRunControl.JobName__c.equalsIgnoreCase('BatchSonpoAgencyCodeUpdate') && bRunControl.Status__c == '0'){
                BatchSonpoAgencyCodeUpdate sonpoAgencyBatch = new BatchSonpoAgencyCodeUpdate(bRunControl.Name, bRunControl.JobName__c);
                Database.executeBatch(sonpoAgencyBatch,200);
            }
            //生保契約登録更新時に金融機関名称、支店名称を契約情報にセットする
            else if(bRunControl.JobName__c.equalsIgnoreCase('BatchLifeContractBankNameUpdate') && bRunControl.Status__c == '0'){
                BatchLifeContractBankNameUpdate lifeBankNameBatch = new BatchLifeContractBankNameUpdate(bRunControl.Name, bRunControl.JobName__c);
                Database.executeBatch(lifeBankNameBatch,200);
            }
            //生保代理店に所属管下代理店をセットするバッチ
            else if(bRunControl.JobName__c.equalsIgnoreCase('BatchSeihoAgencyTrainingAgencyUpdate') && bRunControl.Status__c == '0'){
                BatchSeihoAgencyIkuseiUpdate seihoAgencyIkuseiBatch = new BatchSeihoAgencyIkuseiUpdate(bRunControl.Name, bRunControl.JobName__c); 
                Database.executeBatch(seihoAgencyIkuseiBatch,200);
            }
            //生保エージェントに所属エージェントをセットするバッチ
            else if(bRunControl.JobName__c.equalsIgnoreCase('BatchSeihoAgentParentUpdate')&& bRunControl.Status__c=='0'){
                BatchSeihoAgentParentUpdate seihoAgentParentUpdBatch=new BatchSeihoAgentParentUpdate(bRunControl.Name,bRunControl.JobName__c); 
                Database.executeBatch(seihoAgentParentUpdBatch, 200);
            }
        }   
    }
}