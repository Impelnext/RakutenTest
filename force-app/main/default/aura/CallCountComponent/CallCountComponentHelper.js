({
	showSpinner : function(component) {
		// スピナーON
        var spinner = component.find("spinner");
        $A.util.addClass(spinner, "slds-show");
	},
	hideSpinner : function(component) {
		// スピナーOFF
        var spinner = component.find("spinner");
        $A.util.addClass(spinner, "slds-hide");
	}
})