/*
* @Class Name      : SeihoPolicyDeathBenefitRcptTrg
* @Description     : 生保契約死亡保険金受取人トリガ
* @Created Date    : 2020.01.20
* @Created By      : 
* @Modified Date   : 2020.09.18
* @Modified        : Valsala Kumar
*/
trigger SeihoPolicyDeathBenefitRcptTrg on SeihoPolicyDeathBenefitRcpt__c (before insert,before update, after insert, after update) {
//トリガを停止させたい場合はカスタム表示ラベル「IsLifeSpecialContractFlg」を0に設定
    if(Label.IseihoPolicyDeathBenefitRcptFlg != '0') {
        SeihoPolicyDeathBenefitRcptTrgHand handler = new SeihoPolicyDeathBenefitRcptTrgHand();
        // 前処理 
        if(Trigger.isBefore) {
            handler.setParentRecord(Trigger.new, Trigger.oldMap);
        }
        
        // 後処理 
        if(Trigger.isAfter) {
            handler.setParentInfo(Trigger.new, Trigger.oldMap);
        }
    }
}