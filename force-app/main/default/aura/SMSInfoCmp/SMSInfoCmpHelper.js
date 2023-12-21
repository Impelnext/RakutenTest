({
    checkEdit : function(component) {
        var message = '';
        var action = component.get("c.hasEditAuthor");
        action.setCallback(this, function(res){
            var state = res.getState();
            if (state === "SUCCESS") {
                message = res.getReturnValue();
                //
                if (message !== "") {
                    createErrorMessage(component, message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    getSMSInfo : function(component, smsInfoId) {
        var action = component.get("c.getSMSInfo");
        action.setParams({smsId: smsInfoId});
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var smsInfo = response.getReturnValue();
                var status = smsInfo['Status__c'];
                component.set("v.lastStatus", status);
                component.set("v.smsinfo", smsInfo);
                component.set("v.furigana",smsInfo['ContractorFurigana__c']);
                // ステータス選択リスト
                var options = [];
                if (status == "承認済み" || status == "送信済み(失敗)") {
                    // 活性状態
                    component.set("v.statusActive", false);
                    options = [{'label':'下書き','value':'下書き'},{'label': status,'value': status}];
                } else {
                    options = [{'label': status,'value': status}];
                }
                component.set("v.statusOptions", options);
            }
        });
        $A.enqueueAction(action);
    },
    getAccount : function(component, url) {

        var accId = '';
        try {
            var rx = new RegExp('Account(.*)');
            var rt = url.match(rx);
            if (Object.keys(rt).length > 1) {
                var rx2 = new RegExp('%2F(.*)%2F');
                var rt2 = rt[1].match(rx2);
                if (rt2 != null) {
                    accId = rt2[1];
                } else {
                    rx2 = new RegExp('\/(.*)\/');
                    rt2 = rt[1].match(rx2);
                    if (rt2 != null) {
                        accId = rt2[1];
                    }
                }
            }
            //accId = url.split('Account%2F')[1].split('%2F')[0];
        } catch(e) {
            this.createErrorMessage(component, "取引先情報が取得できませんでした。取引先から操作をしてください。");
            accId = component.get("v.account");
        }
        console.log("accId:"+ accId);
        var action = component.get("c.getAccount");
        action.setParams({accId: accId });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var acc = response.getReturnValue();
                // component.set("v.smsinfo",smsInfo);

                try {
                   if (acc == undefined || acc == null) {
//                        throw new Error("取引先情報が取得できませんでした。統合CRMでSMS送信情報を作成してください。");
                       acc = [];
                   }
                   //console.log('PermissionFlg:' + acc['SMSPermissionFlg__c']);
                   var furigana = acc['furigana__c'];
                   var sender = $A.get("$SObjectType.CurrentUser.Id");
                   console.log("loginuserId:" + sender);
                   console.log("personmobilephone:" + acc['PersonMobilePhone']);
                   //
                   var smsinfo = {
                       "DestinationPhoneNumber__c" : acc['PersonMobilePhone'],
                       "Sender__c" : sender,
////                   "SenderPhoneNumber__c" : "0120479142",
                       "Status__c" : "下書き"
                   };
                   component.set("v.furigana",furigana);
                   // component.set("v.sender", sender);
                   component.set("v.account", acc);
                   component.set("v.smsinfo", smsinfo);
                } catch(e) {
                    this.createErrorMessage(component, 'このエラーは現在調査中です。継続して問題ないです。' + e.message);
                    console.log("Exception :" + e.message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    doSave : function(component, smsinfo, account) {
        // 
        smsinfo['SenderPhoneNumber__c'] = component.find("senderPhoneNumber").get("v.value");
        // var smsinfo = component.get("v.smsinfo");
        var action = component.get("c.doSaveSMSInfo");
        // var recordId = component.get("v.recordId");
        var recordId;
        action.setParams({smsInfo: smsinfo, acc: account });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                // sfdcId
                recordId = response.getReturnValue();
                try {
                    //if (recordId == '' || recordId == null) {
                    if (recordId[0] == '' || recordId[0] == null) {
                        if (recordId[1] == '') {
                            throw new Error("SMS送信情報の保存に失敗しました。システム管理者に問い合わせてください。");
                        } else {
                            throw new Error(recordId[1]);
                        }
                    }
                    console.log("recordId:" + recordId[0]);
                    component.set("v.recordId", recordId[0]);
                    component.set("v.smsinfo", recordId[0]);
                    smsinfo = recordId[0];
////                var url = window.location.origin+'/lightning/r/SMSInfo__c/'+recordId[0]+'/view' + window.location.search;
////                window.location.href = url;
                    var workspaceAPI = component.find("workspace");
                    workspaceAPI.getFocusedTabInfo().then(function(response2) {
                        var focusedTabId = response2.tabId;
                        var parentTabId = response2.parentTabId;

                        workspaceAPI.openSubtab({
                            parentTabId : parentTabId,
                            recordId : smsinfo,
                            focus :true,
                        }).then(function(response2) {
                            workspaceAPI.closeTab({tabId: focusedTabId});
                            workspaceAPI.refreshTab({tabId : response2});
                            workspaceAPI.focusTab({tabId : response2});
                        });
                    })
                    .catch(function(error) {
                        console.log(error);
                    });
                } catch(e) {
                    this.createErrorMessage(component, e.message);
                }
            } else if (state === "INCOMPLETE") {
                // do something
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
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
    closeSubtab : function(components, recordId) {

        var workspaceAPI = components.find("workspace");

        var focusedTabId;
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            focusedTabId = response.tabId;
        })
        .catch(function(error) {
            console.log(error);
        })

        workspaceAPI.getAllTabInfo().then(function(response) {
            console.log(JSON.parse(JSON.stringify(response)));

            for(var i = 0; i < response.length; i++) {
                var subtabs = response[i].subtabs;

                for(var j = 0; j < subtabs.length; j++) {
                    var stabId = subtabs[j].tabId;
                    var srecordId = subtabs[j].recordId;

                    // 同じレコード
                    if (srecordId == recordId) {
                        // 新しいSTABは除く
                        console.log("ftab : stab = "+focusedTabId + ' : ' + stabId)
                        if (focusedTabId != stabId) {
                            console.log("closed:" + stabId);
                            workspaceAPI.closeTab({tabId: stabId});
                        }
                    }
                }
            }
        })
        .catch(function(error) {
            console.log(error);
        });
    }
})