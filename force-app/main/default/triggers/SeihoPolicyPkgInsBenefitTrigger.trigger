trigger SeihoPolicyPkgInsBenefitTrigger on SeihoPolicyPkgInsBenefit__c (before insert,before update) {
 //トリガを停止させたい場合はカスタム表示ラベル「IsLifeSpecialContractFlg」を0に設定
    if(Label.IsSeihoPolicyPkgInsBenefitFlg != '0') {
        SeihoPolicyPkgInsBenefitHandler handler = new SeihoPolicyPkgInsBenefitHandler();
        // 前処理 
        if(Trigger.isBefore) {
            handler.setParentRecord(Trigger.new, Trigger.oldMap);
        }
    }
}