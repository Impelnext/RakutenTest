({
    openBankMasterSearch : function(component, event, helper) {
        var params = event.getParam('arguments');
        console.log("params value " + params.showSearchPopup);
        component.set("v.showSearchPopup",params.showSearchPopup);
    },
    init : function(component, event, helper) {
       helper.getTempList(component);
       helper.isWritable(component);
    },
    selectTemp : function(cmp, evt) {
        console.log("selectTemp");
        var selValue = evt.currentTarget.value.split("$0#D%H");
        var selectedId = evt.currentTarget.id;
        var selSubject = selValue[0];
        var selectedMsg = selValue[1];
        console.log("selMsg:" + selectedMsg);
        cmp.set("v.tempId", selectedId);
        cmp.set("v.tempSubject", selSubject);
        cmp.set("v.tempMsg", selectedMsg);
    },
    tempEdit : function(cmp, event, helper) {
        var btnName = event.getSource().get("v.label");
        var tempId = cmp.get("v.tempId");
        if (btnName == "編集" && tempId == null) {
            alert("テンプレートが選択されていません。");
            return false;
        }
        var type;
        var url;
        if (window.confirm("SMS送信テンプレートの編集画面に遷移しますか？\r当ページに戻るには、SMS送信情報画面から再度操作してください。")) {
            /****
            if (btnName == "新規追加") {
                //jvar url = window.location.origin+'/lightning/o/SMSMessageTemplate__c/new' + window.location.search;
                var url = '/lightning/o/SMSMessageTemplate__c/new' + window.location.search;
            } else if (btnName == "編集"){
                var url = window.location.origin+'/lightning/r/SMSMessageTemplate__c/'+tempId+'/view' + window.location.search;
            }
            console.log("btnName:" + btnName);
            window.location.href = url;
            // window.open(url,"_blank","resizable=yes,toolbar=no,status=yes,location=no,menubar=yes,scrollbars=yes",false);
            ****/
            if (btnName == "新規追加") {
                url = '/lightning/o/SMSMessageTemplate__c/new';
            } else if (btnName == "編集"){
                url = window.location.origin+'/lightning/r/SMSMessageTemplate__c/'+tempId+'/view';
            }

            var workspaceAPI = cmp.find("workspace");
            workspaceAPI.getFocusedTabInfo().then(function(response2) {
                var focusedTabId = response2.tabId;
                var parentTabId = response2.parentTabId;

                workspaceAPI.openSubtab({
                    parentTabId : parentTabId,
                    url: url,
                    focus :true,
                }).then(function(response2) {
//                    workspaceAPI.closeTab({tabId: focusedTabId});
                    workspaceAPI.refreshTab({tabId : response2});
                    workspaceAPI.focusTab({tabId : response2});
                });
            })
            .catch(function(error) {
                console.log(error);
            });

            cmp.set("v.errorFlag",false)
            cmp.set("v.showSearchResultFlg", false);
            cmp.set("v.showSearchPopup",false);
        } else {
            return false;
        }
    },
    tempSave : function(cmp, event, helper) {
        var template = cmp.get("v.template");
        var action = component.get("c.doSaveTemp");
        action.setParams({temp : template});
        //
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var message = response.getReturnValue();
                // 
                if (message === 'SUCCESS') {
                    helper.tempClose(cmp);
                } else {
                    helper.createErrorMessage(cmp, message);
                }
            }
        });
        $A.enqueueAction(action);
        helper.popupClose(cmp);
    },
    tempDelete : function(cmp, event, helper) {
        var template = cmp.get("v.template");
        var action = cmp.get("c.doDeleteTemp");
        action.setParams({temp : template});
        //
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var message = response.getReturnValue();
                // 
                if (message !== 'SUCCESS') {
                    helper.createErrorMessage(cmp, message);
                }
            }
        });
        $A.enqueueAction(action);
        helper.popupClose(cmp);
    },
    tempCancel : function(cmp, helper) {
        console.log("cancel");
        helper.popupClose(cmp);
    },
    tempCloseJump : function(cmp, helper) {
        console.log("tempClose");

        cmp.set("v.errorFlag",false)
        cmp.set("v.showSearchResultFlg", false);
        cmp.set("v.showSearchPopup",false);
    },
    tempInsertJump : function(cmp, event, helper) {
        console.log("template Insert");

        var selectedRecord = cmp.get("v.selectedRecord");

        var tempSubject = cmp.get("v.tempSubject");
        var tempMsg = cmp.get("v.tempMsg");
        //
        if (tempSubject == null) {
            alert("テンプレートが選択されていません。");
            return false;
        }

        var cmpEvent = cmp.getEvent('cmpEvent');
            cmpEvent.setParams({
                "smssubject" : tempSubject,
                "smsmessage" : tempMsg,
            }).fire();

        cmp.set("v.errorFlag", false)
        cmp.set("v.showSearchResultFlg", false);
        cmp.set("v.showSearchPopup", false);
    },
    tempInsert : function(cmp, event, helper) {
        console.log("template Insert");
        var cmpEvent = cmp.getEvent("cmpEvent");
        // var cmpEvent = $A.get("e.c:SMSTemplateEvent");
        var tempSubject = cmp.get("v.tempSubject");
        var tempMsg = cmp.get("v.tempMsg");
        cmpEvent.setParams({
            "smssubject" : tempSubject,
            "smsmessage" : tempMsg
        });
        cmpEvent.fire();
    }
})