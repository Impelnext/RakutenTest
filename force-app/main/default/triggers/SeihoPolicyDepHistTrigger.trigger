trigger SeihoPolicyDepHistTrigger on SeihoPolicyDepHist__c (before insert,before update) {
//トリガを停止させたい場合はカスタム表示ラベル「IsLifeSpecialContractFlg」を0に設定
    if(Label.IsSeihoPolicyDepHistFlg != '0') {
        IsSeihoPolicyDepHistFlgTrgHandler handler = new IsSeihoPolicyDepHistFlgTrgHandler();
        // 前処理 
        if(Trigger.isBefore) {
            handler.setParentRecord(Trigger.new, Trigger.oldMap);
        }
    }
}