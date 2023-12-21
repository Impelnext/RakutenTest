({
    doInit : function(cmp, event, helper){
        var action = cmp.get("c.isNGAgencyContract");
        action.setParams({  contractId : cmp.get("v.recordId")  });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var options = [];
                var isNGAgencyContract = response.getReturnValue();
                if(isNGAgencyContract){
                    cmp.set("v.showError", true);
                }
            }
        });
        $A.enqueueAction(action);
    }
})