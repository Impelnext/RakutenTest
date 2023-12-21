({
    doInit : function(cmp, event, helper){
        var action = cmp.get("c.getAccountInfo");
        action.setParams({  recordId : cmp.get("v.recordId")  });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var options = [];
                var account = response.getReturnValue();
                if(account && account.DamageUse__pc == true){
                    helper.showWarningPopup(cmp, 
                           "損保契約を保有するお客様です。", 
                           "契約情報の確認は白画面（もしくは損保チーム）に確認してください。");
                }
            }
        });
        $A.enqueueAction(action);
    }
})