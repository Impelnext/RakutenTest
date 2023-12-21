({
    init : function(component, event, helper) {
        var message = '';
        var accFlg = false;

        console.log("SMSInfoCmpController init");
        var action = component.get("c.hasEditAuthor");
        action.setCallback(this, function(res){
            console.log("SMSInfoCmpController callback");
            var state = res.getState();
            console.log(state);
            if (state === "SUCCESS") {
                message = res.getReturnValue();
                //
                console.log("message:" + message);
                if (message != '') {
                    console.log("createErrorMessag0");

                    helper.createErrorMessage(component, message);
                    return;
                }
// データの復元
                var smsinfoId = component.get("v.recordId");
                if (smsinfoId != '' && smsinfoId != null) {
                    helper.getSMSInfo(component, smsinfoId);
                    helper.closeSubtab(component, smsinfoId);
                } else {
                    var url = window.location.href;
                    helper.getAccount(component, url);
                }

//             console.log("smsinfoId:" + smsinfoId);
//             不要なサブタブを消す
            //    if (smsinfoId != '' && smsinfoId != null) {
            //        helper.closeSubtab(component, smsinfoId);
            //    }
            }
        });
        $A.enqueueAction(action);
    },
    saveCheck : function(component, event, helper) {

        var smsinfoId = component.get("v.recordId");
        var smsinfo = component.get("v.smsinfo");
        var account = component.get("v.account");
        var lastStatus = component.get("v.lastStatus");
        // Set SenderPhoneNumber value in SMSInfo object
        smsinfo['SenderPhoneNumber__c'] = component.find("senderPhoneNumber").get("v.value");
        var action = component.get("c.checkSave");

        action.setParams({acc: account,smsInfo: smsinfo, lastStatus: lastStatus});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                // 
                var message = response.getReturnValue();
                // メッセージなし
                if (message === '') {
                    helper.doSave(component, smsinfo, account);
                } else {
                    console.log("createErrorMessag1");
                    helper.createErrorMessage(component, message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    handleCmpEvent : function(cmp, event,helper) {
        var smssubject = event.getParam("smssubject");
        var smsmessage = event.getParam("smsmessage");
        //var message = cmp.get("v.smsinfo.SendContents__c");
        //cmp.set("v.smsinfo.SendContents__c", message + " " + smsmessage);
        cmp.set("v.smsinfo.SendSubject__c", smssubject);
        cmp.set("v.smsinfo.SendContents__c", smsmessage);
    },
    openBankMasterSearch : function(component,event,helper){
		//$A.createComponent("c:BankMasterSearchCmp",{"showSearchPopup" : true,"sourceScreen" : "lightningCmp"},function(responseName, status, errorMessage){
		$A.createComponent("c:SMSTemplateCmp",{"showSearchPopup" : true,"sourceScreen" : "lightningCmp"},function(responseName, status, errorMessage){
			if(status === "SUCCESS"){
				var body = component.get("v.body");
                body.push([]);
                body.push(responseName);
                component.set("v.body", body);
			}else{
				alert('ErrorMessage ' + errorMessage);
			}
		});
    },
    clickCancel: function(component, event, helper) {
        var smsinfoId = component.get("v.recordId");
        var parentTabId;

        var workspaceAPI = component.find("workspace");
        if (smsinfoId == null) {
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                var focusedTabId = response.tabId;
                parentTabId = response.parentTabId;
                workspaceAPI.closeTab({tabId: focusedTabId});
            })
            .catch(function(error) {
                console.log(error);
            });
        } else {
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                var focusedTabId = response.tabId;
                parentTabId = response.parentTabId;

                workspaceAPI.openSubtab({
                    parentTabId : parentTabId,
                    recordId : smsinfoId,
                    focus :true,
                }).then(function(response) {
                    workspaceAPI.focusTab({tabId : response});
                    workspaceAPI.closeTab({tabId: focusedTabId});
                });
            })
            .catch(function(error) {
                console.log(error);
            });
       }
    }
});