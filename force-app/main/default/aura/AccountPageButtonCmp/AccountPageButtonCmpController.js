({
    init : function(component, event, helper) {
        //有人チャット start
        var omniAPI = component.find("omniToolkit");
        omniAPI.getServicePresenceStatusId().then(function(result) {
            component.set("v.loginFlg", "login");
        });
        //有人チャット end
        var accountId = component.get("v.recordId");

        var action = component.get("c.getAccountContract");
        action.setParams({ accountId: accountId });

        action.setCallback(this, function(response) {
            var state = response.getState();
            
            //サーバーへのアクセスに成功した場合、保持する契約に沿ってボタンを使用不可に変更
            if (state === "SUCCESS") {
                var map = response.getReturnValue();
                for(var key in map){
                    if(key === "SEIHO" && map[key]){
                        component.find("btnSeihoHozen").set("v.disabled", false);
                    }
                    if(key === "SEIHO" && map[key]){
                        component.find("btnSeihoHokenkin").set("v.disabled", false);
                    }
                    //ONYXシステム対応で追加　開始
                    if(key === "SEIHO" && map[key]){
                        component.find("btnSeihoDaisa").set("v.disabled", false);
                    }
                    //ONYXシステム対応で追加　終了
                    if(key === "SEIHO_TOKUYAKU" && map[key]){
                        component.find("btnSeihoTokuyaku").set("v.disabled", false);
                    }
                    if(key === "SONPO" && map[key]){
                        component.find("btnSonpo").set("v.disabled", false);
                    }
                    if(key === "SYOTAN" && map[key]){
                        component.find("btnSyotan").set("v.disabled", false);
                    }
                    if(key === "FAQ" && map[key]){
                        $A.util.removeClass(component.find("btnKnowledgeFAQ"), "slds-hide");
                    }
                }
            }
        });
        $A.enqueueAction(action);

        var pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'c__ReceptionAccountDisplayCmp',
            },
            state: {
                "c__accountId": accountId

            }
        };
        component.set("v.pageReference", pageReference);

        var faqPageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Knowledge__kav',
                actionName: 'home'
            }
        };
        component.set("v.faqPageReference", faqPageReference);

        var actionForAccountAgeInfo = component.get("c.getAccountAgeInfo");
        actionForAccountAgeInfo.setParams({ accountId: accountId });
        actionForAccountAgeInfo.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var actAgeInfoMap = response.getReturnValue();
                component.set("v.ageClassCd", actAgeInfoMap["ageClassCd"]);
                component.set("v.appDlCd", actAgeInfoMap["appDlCd"]);
            }
        });
        $A.enqueueAction(actionForAccountAgeInfo);
    },
    handleClick: function(component, event, helper) {
        var navService = component.find("navCreateReception");
        var pageReference = component.get("v.pageReference");
        event.preventDefault();
        navService.navigate(pageReference);
    },
    handleFAQClick: function(component, event, helper) {
       var navService = component.find("navCreateReception");
       var pageReference = component.get("v.faqPageReference");
       event.preventDefault();
       navService.navigate(pageReference);
    },
    handleSMSClick: function(component, event, helper) {

        var accountId = component.get("v.recordId");
        var action = component.get("c.checkError");
        action.setParams({ accountId: accountId });

        action.setCallback(this, function(response) {
            var state = response.getState();
            
            //サーバーへのアクセスに成功した場合、保持する契約に沿ってボタンを使用不可に変更
            if (state === "SUCCESS") {
                var msg = response.getReturnValue();
                if (msg != '' && msg != null) {
                    helper.createErrorMessage(component, msg);
                    return;
                }
                var url = window.location.origin + '/lightning/o/SMSInfo__c/new?ws=%2Flightning%2Fr%2FAccount%2F' + accountId + '%2Fview&count=1';
                //alert(url);
                ////window.location.href = url;
                var workspaceAPI = component.find("workspace");
                workspaceAPI.openTab({
                    url: '/lightning/r/Account/' + accountId + '/view',
                    focus: true
                }).then(function(response) {
                    workspaceAPI.openSubtab({
                        parentTabId: response,
                        url: '/lightning/o/SMSInfo__c/new',
                        focus: true
                    });
                })
                .catch(function(error) {
                    console.log(error);
                });

            }
        });
        $A.enqueueAction(action);

    },
    handleReportOpen: function(component, event, helper){
        var loginFlg = component.get("v.loginFlg");
        var sourceLabel = event.getSource().get("v.label");
        var accountId = component.get("v.recordId");
        var reportID = "";
        if(sourceLabel == "生命(保全)一覧"){
            reportID = $A.get("{!$Label.c.ReportID_SeihoHozenList}");
        }else if(sourceLabel == "生命(保険金)一覧"){
            reportID = $A.get("{!$Label.c.ReportID_SeihoHokenkinList}");
        }else if(sourceLabel == "生命(特約)一覧"){
            reportID = $A.get("{!$Label.c.ReportID_SeihoTokuyakuList}");
        }else if(sourceLabel == "損保一覧"){
            reportID = $A.get("{!$Label.c.ReportID_SonpoContractList}");
        }else if(sourceLabel =="少短一覧"){
            reportID = $A.get("{!$Label.c.ReportID_ShotanContractList}");
        }
        //ONYXシステム対応で追加　開始
      	else if(sourceLabel == "生命(代サ)一覧"){
        	reportID=$A.get("{!$Label.c.ReportID_SeihoDaisaList}");  
        }
		//ONYXシステム対応で追加　終了
		
        //有人チャット start
        if(loginFlg == "login"){
            var pageReference2 = {
                type: 'standard__recordPage',
                attributes: {
                    recordId: reportID,
                    objectApiName: 'Report',
                    actionName: 'view'
                },
                state: {
                    fv0: accountId
                }
            };
            var navService = component.find("navCreateReception");
            event.preventDefault();
            navService.navigate(pageReference2);
        }else{
            var url = window.location.origin+'/lightning/r/Report/'+reportID+'/view?fv0='+accountId;
            //window.open("/lightning/r/Report/"+reportID+"/view&fv0="+accountId,"_blank","resizable=yes,toolbar=no,status=no,location=no,menubar=no,scrollbars=yes");
            window.open(url,"_blank","resizable=yes,toolbar=no,status=yes,location=no,menubar=yes,scrollbars=yes",false);
        }
        //有人チャット end
    },
    //有人チャット
    onStatusChanged : function(component, event, helper){
        var statusName = event.getParam("statusName");
        if(statusName == "オフライン"){
            component.set("v.loginFlg", "logout");
        }else{
            component.set("v.loginFlg", "login");
        }
    },
    //有人チャット
    onLogout : function(component, event, helper) {
        component.set("v.loginFlg", "logout");
    },    
    handleClickNewAppointment:function(component,event,helper){
		
        var recId= component.get("v.recordId");
        var action=component.get("c.getAccInternalCall");
        action.setParams({recordId:recId});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state === "SUCCESS"){
                var createRecordEvent =$A.get("e.force:createRecord");
                var acc=response.getReturnValue();
                if (acc && acc["PersonMailingPostalCode"] === "ERROR_PO_BLANK") {
                    helper.showWarningPopup(component, 
                    					"取引先の郵便番号が未入力です。",
                                      "代理店の訪問が可能な地域か確認の為、入力してください。");
                }
                else if (acc && acc["PersonMailingPostalCode"] === "ERROR_PO_NOAGENCY"){
                    //	helper.showWarningPopup(component, 
                    //						"対面代理店不在地域です。",
                    //                      "お客様にオンラインでの保険案内が可能か確認してください。");
                    
                    component.set('v.showNewAppointment', true);
                }
                else {
                        createRecordEvent.setParams({
                            entityApiName:"InternalCallEscalation__c",
                            defaultFieldValues:{
                                AccountId__c:acc["Id"],
                                LastName__c:acc["LastName"],
                                FirstName__c:acc["FirstName"],
                                LastNameKana__c:acc["furiganaLast__pc"],
                                FirstNameKana__c:acc["furiganaForst__pc"],
                                Gender__c:acc["Gender__pc"],
                                Phone__c:acc["PersonHomePhone"],
                                MobilePhone__c:acc["PersonMobilePhone"],
                                BirthDate__c:acc["PersonBirthdate"],
                                State__c:acc["PersonMailingState"],
                                City__c:acc["PersonMailingCity"],
                                Apart__c:acc["PersonMailingStreet"],
                                PostalCode__c:acc["PersonMailingPostalCode"],
                                WantMeetFlg__c:true,
                                InputPath__c:"内部コールセンター",
                                AssignmentStatus__c:"アサイン待ち"
                            }, 
                            
                            
                        });
                        
                        createRecordEvent.fire();
                        $A.get("e.force:closeQuickAction").fire();
                        
                    }
            }
        });
        $A.enqueueAction(action);
    },
    handleAppointmentPopupCancel : function(component, event, helper) {
        component.set('v.showNewAppointment',false);
    },
    handleAppointmentPopupOK : function (component, event, helper) {
        //var urlEvent = $A.get("e.force:navigateToURL");
        //urlEvent.setParams({
        //    "url": "/lightning/o/Account/list?filterName=Recent"
        //});
        //urlEvent.fire();

        var recId= component.get("v.recordId");
        var action=component.get("c.getAccInternalCallWithNoCheck");
        action.setParams({recordId:recId});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state === "SUCCESS"){
                var createRecordEvent =$A.get("e.force:createRecord");
                var acc=response.getReturnValue();
                
                createRecordEvent.setParams({
                    entityApiName:"InternalCallEscalation__c",
                    defaultFieldValues:{
                        AccountId__c:acc["Id"],
                        LastName__c:acc["LastName"],
                        FirstName__c:acc["FirstName"],
                        LastNameKana__c:acc["furiganaLast__pc"],
                        FirstNameKana__c:acc["furiganaForst__pc"],
                        Gender__c:acc["Gender__pc"],
                        Phone__c:acc["PersonHomePhone"],
                        MobilePhone__c:acc["PersonMobilePhone"],
                        BirthDate__c:acc["PersonBirthdate"],
                        State__c:acc["PersonMailingState"],
                        City__c:acc["PersonMailingCity"],
                        Apart__c:acc["PersonMailingStreet"],
                        PostalCode__c:acc["PersonMailingPostalCode"],
                        WantMeetFlg__c:true,
                        InputPath__c:"内部コールセンター",
                        AssignmentStatus__c:"アサイン待ち"
                    }
                });
                
                createRecordEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
        
        component.set('v.showNewAppointment', false);
    }
})