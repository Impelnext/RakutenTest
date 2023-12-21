({    
    doInit : function(cmp, event, helper){
        var action = cmp.get("c.getWarningAgency");
        action.setParams({  recordId : cmp.get("v.recordId")  });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var options = [];
                var warningList = response.getReturnValue();

                helper.showNgAgencyPopup(cmp, warningList);
            }
        });
        $A.enqueueAction(action);
    },
})