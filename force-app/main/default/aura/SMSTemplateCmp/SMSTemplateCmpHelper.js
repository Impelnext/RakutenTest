({
    popupOpen : function(cmp) {
        var modal = document.getElementById("Popup");
        modal.style.display = "block";
        console.log("PopupOpen");
       // return false;
    },
    popupClose : function(cmp) {
        var modal = document.getElementById("Popup");
        modal.style.display = "none";
        console.log("PopupClose");
        // return false;
    },
    getTempList : function(component) {
        var action = component.get("c.getTempList");
        //
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                // 
                var tempList = response.getReturnValue();
                component.set("v.tempList", tempList);

            }
        });
        $A.enqueueAction(action);
    },
    getTemp : function(cmp) {
        var tempId = cmp.get("v.tempId");
        var action = cmp.get("c.getTemp");
        action.setParams({tempId : tempId});
        //
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                // 
                var template = response.getReturnValue();
                console.log("tempId:" + template['Id']);
                cmp.set("v.template", template);
                this.popupOpen(cmp);
            }
        });
        $A.enqueueAction(action);
    },
    tempClose : function() {
        console.log("tempCloseHelper");
        // window.close();
        var closeElm = document.getElementsByClassName("slds-modal__close")[0];
        closeElm.click();
    },
    createErrorMessage : function(component, message) {
        console.log('message:' + message);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            // "title": "Success!",
            "message": message,
            "type" : "error"
        });
        toastEvent.fire();
    },
    reflesh : function(cmp) {
        var url = window.location.href;
        window.location.href = url;
    },
    isWritable : function(cmp) {
        var action = cmp.get("c.isWritable");
        //
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                // 
                var ret = response.getReturnValue();
                console.log("packed : " + ret);
                cmp.set("v.packed", ret);
            }
        });
        $A.enqueueAction(action);
    }
})