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
    },

    showExampleModal : function(component) {      
        alert("show");
        var modal = component.find("exampleModal");
        $A.util.removeClass(modal, 'hideDiv');        
    },
    
    hideExampleModal : function(component) {
        alert("hide");
        var modal = component.find("exampleModal");
        alert(modal);
        $A.util.addClass(modal, 'hideDiv');
    },
})