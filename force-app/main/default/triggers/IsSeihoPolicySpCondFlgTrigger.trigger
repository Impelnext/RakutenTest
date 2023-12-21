trigger IsSeihoPolicySpCondFlgTrigger on SeihoPolicySpCond__c (before insert,before update) {
//トリガを停止させたい場合はカスタム表示ラベル「IsLifeSpecialContractFlg」を0に設定
    if(Label.IsSeihoPolicySpCondFlg!= '0') {
        IsSeihoPolicySpCondFlgTrgHandler handler = new IsSeihoPolicySpCondFlgTrgHandler();
        // 前処理 
        if(Trigger.isBefore) {
            handler.setParentRecord(Trigger.new, Trigger.oldMap);
        }
    }
}