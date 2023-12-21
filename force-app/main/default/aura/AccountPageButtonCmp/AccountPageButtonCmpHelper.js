({
	createErrorMessage : function(components, message) {
		console.log('createErrorMessage:' + message);

        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type" : "error"
        });
		toastEvent.fire();
	},
	showWarningPopup : function(component,title,msg){
		component.find('notifLib').showNotice({
			"variant": "error",
            "header" : title,
			"message": msg,
			closeCallback: function() {
			}
		});
	}
})