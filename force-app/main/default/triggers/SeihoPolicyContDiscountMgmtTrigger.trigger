trigger SeihoPolicyContDiscountMgmtTrigger on SeihoPolicyContDiscountMgmt__c (before insert,before update) {
 //トリガを停止させたい場合はカスタム表示ラベル「IsLifeSpecialContractFlg」を0に設定
    if(Label.IsSeihoPolicyContDiscountFlg != '0') {
        SeihoPolicyContDiscountMgmtHand handler = new SeihoPolicyContDiscountMgmtHand();
        // 前処理 
        if(Trigger.isBefore) {
            handler.setParentRecord(Trigger.new, Trigger.oldMap);
        }
    }
}