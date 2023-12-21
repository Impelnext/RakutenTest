({
    init : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.getContractAgeInfo");
        action.setParams({ recordId: recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var contractAgeInfoMap = response.getReturnValue();
                component.set("v.ageClassCd", contractAgeInfoMap["ageClassCd"]);
                component.set("v.ageClassCdForInsured", contractAgeInfoMap["ageClassCdForInsured"]);
            }
        });
        $A.enqueueAction(action);
    }
})