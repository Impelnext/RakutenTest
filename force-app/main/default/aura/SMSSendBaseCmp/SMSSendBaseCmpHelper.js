({
	createErrorMessage : function(components, message) {
        console.log('createErrorMessage:' + message);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            // "title": "Success!",
            "message": message,
            "type" : "error"
        });
        toastEvent.fire();
    }
})