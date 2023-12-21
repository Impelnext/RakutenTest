({
    doInit : function(cmp, event, helper){
        var action = cmp.get("c.getWarningAgency");
        action.setParams({  accountId : cmp.get("v.recordId")  });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var options = [];
                var warningList = response.getReturnValue();
                if(warningList.collectiveList.length > 0){
                    cmp.set("v.showError", true);
                }
            }
        });
        $A.enqueueAction(action);
    }
})