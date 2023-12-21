({
	init : function(component, event, helper) {
	//有人チャット start
	var omniAPI = component.find("omniToolkit");
	omniAPI.getServicePresenceStatusId().then(function(result) {
		component.set("v.loginFlg", "login");
	});
	//有人チャット end
	var receptionId = component.get("v.recordId");    
	var action = component.get("c.getAccountContract");
	action.setParams({ receptionId : receptionId});
	action.setCallback(this,function(response){
		var result = response.getState();
		if(result === "SUCCESS"){
			var map = response.getReturnValue();
			for(var key in map){
				if(key === "SEIHO" && map[key]){
					component.find("btnSeihoHozen").set("v.disabled", false);
				} 
				if(key === "SEIHO" && map[key]){
					component.find("btnSeihoHokenkin").set("v.disabled", false);
				} 
				if(key === "SEIHO_TOKUYAKU"  && map[key]){ 
					component.find("btnSeihoTokuyaku").set("v.disabled", false);
				} 
				if(key === "SONPO" && map[key]){
					component.find("btnSonpo").set("v.disabled", false);
				} 
				if(key === "SYOTAN" && map[key]){
					component.find("btnSyotan").set("v.disabled", false);
				}
				if(key !== "SEIHO" && key !== "SEIHO_TOKUYAKU" && key !== "SYOTAN" && key !== "SONPO" ){
					component.set("v.accountId",key);
				}				
            }
		}
	});
	$A.enqueueAction(action);

	var pageReference = {
		type: 'standard__component',
		attributes: {
			componentName: 'c__RequestDisplayCmp',
		},
		state: {
			"c__receptionId": receptionId
		}
    };    
	component.set("v.pageReference",pageReference);
	
	//ONYXシステム対応で追加　開始
	var pageReference2 = {
		type: 'standard__component',
		attributes: {
			componentName: 'c__ReceptionAccountDisplayCmp',
		},
        state: {
            "c__receptionId":receptionId,
            "c__isClone":1
		}
    };
	component.set("v.pageReference2",pageReference2);
	//ONYXシステム対応で追加　終了
    },
    handleClick: function(component, event, helper) {
        var navService = component.find("navCreateRequest");
        var pageReference = component.get("v.pageReference");
        event.preventDefault();
        navService.navigate(pageReference);
	},
    handleReceptionCopy: function(component, event, helper) {
        var navService = component.find("navCreateRequest");
        var pageReference2 = component.get("v.pageReference2");
        event.preventDefault();
        navService.navigate(pageReference2);
	},
	handleReportOpen: function(component, event, helper){
        var sourceLabel = event.getSource().get("v.label");
		var reportID = "";
		var accountId = component.get("v.accountId");
		var loginFlg = component.get("v.loginFlg");
		//alert('accountId ' + accountId);
        if(sourceLabel == "生命(保全)一覧"){
            reportID = $A.get("{!$Label.c.ReportID_SeihoHozenList}");
        }else if(sourceLabel == "生命(保険金)一覧"){
            reportID = $A.get("{!$Label.c.ReportID_SeihoHokenkinList}");
        }else if(sourceLabel == "生命(特約)一覧"){
            reportID = $A.get("{!$Label.c.ReportID_SeihoTokuyakuList}");
        }else if(sourceLabel == "損保一覧"){
            reportID = $A.get("{!$Label.c.ReportID_SonpoContractList}");
        }else{
            reportID = $A.get("{!$Label.c.ReportID_ShotanContractList}");
        }
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
            var navService = component.find("navCreateRequest");
            event.preventDefault();
            navService.navigate(pageReference2);
        }else{		
    		var url = window.location.origin+'/lightning/r/Report/'+reportID+'/view?fv0='+accountId;
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
    }
})