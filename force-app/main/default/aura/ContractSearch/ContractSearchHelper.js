({
	showSpinner : function(component) {
		// スピナーON
        var spinner = component.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");
	},
	hideSpinner : function(component) {
		// スピナーOFF
        var spinner = component.find("spinner");
        $A.util.addClass(spinner, "slds-hide");
	},
    showToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "sticky": "sticky",
            "title": "Success!",
            "message": "The record has been updated successfully."
        });
        toastEvent.fire();
	}
})