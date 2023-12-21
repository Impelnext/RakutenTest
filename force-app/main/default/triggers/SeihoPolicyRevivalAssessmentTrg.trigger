trigger SeihoPolicyRevivalAssessmentTrg on SeihoPolicyRevivalAssessment__c (before insert,before update) {
//トリガを停止させたい場合はカスタム表示ラベル「IsLifeSpecialContractFlg」を0に設定
    if(Label.IsSeihoPolicyRevivalAssessmentFlg!= '0') {
        SeihoPolicyRevivalAssessmentHandler handler = new SeihoPolicyRevivalAssessmentHandler();
        // 前処理 
        if(Trigger.isBefore) {
            handler.setParentRecord(Trigger.new, Trigger.oldMap);
        }
    }
}