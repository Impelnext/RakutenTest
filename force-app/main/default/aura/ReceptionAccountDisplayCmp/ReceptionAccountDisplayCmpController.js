({
    doInit: function(component, event, helper) {
        var pageRef = component.get("v.pageReference");
        if(!$A.util.isEmpty(pageRef.state.c__accountId)){
        	helper.getAccDetailsHelp(component, event); 
        }
        helper.getRelationshipPicklist(component, event);
		helper.getBilleRelationshipPicklist(component, event);
		helper.getAdderssInputMethodPicklist(component, event);
		helper.getOriginPicklist(component, event);
		helper.getReceptionTeamPicklist(component, event);
        helper.getIdentificationMultiList(component, event);
		helper.getLFInquiryMultiList(component, event);
		helper.getDMInquiryMultiList(component, event);
        helper.getLTInquiryMultiList(component, event);
        helper.getContractInfo(component,event);
        helper.getButtonReportNavigation(component,event);
        //ONYXシステム対応で追加
        if(!$A.util.isEmpty(pageRef.state.c__MasterRecordId )){
			helper.setMasterRecord(component,event);
        }
        //受付情報の複製用
       if(!$A.util.isEmpty(pageRef.state.c__receptionId) ){
        	helper.getRecDetailsHelp(component, event);
        }
        //有人チャット start
        var omniAPI = component.find("omniToolkit");
        omniAPI.getServicePresenceStatusId().then(function(result) {
            component.set("v.loginFlg", "login");
        });
        //有人チャット end
        
         //New Added Helper
        helper.fetchPicklistValues(component,'Reception__c','PrimaryCompletion_MajorItem__c', 'PrimaryCompletion_MediumItem__c');
	
    },
    
    //New Added controller major Handler
     onControllerFieldChange: function(component, event, helper) { 
        
        var controllerValueKey =event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.depnedentFieldMap"); 
		 component.set("v.listDependingValues", ['--- None ---']);
		 component.set("v.bDisabledDependentFld" , true);
		 component.set("v.freeWordFld" , true); 
		 component.find("primaryCompletionMediumItemPickList").set("v.value", '');
		 component.find("primaryCompletionFreeWord").set("v.value", ''); 
		 component.set("v.mediumPickListWar" , false);
         if (controllerValueKey != '--- None ---') {
			component.set("v.majorPickListErr" , false);
            component.set("v.majorPickListWar" , false); 
            component.set("v.mediumPickListErr" , true);
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey]; 
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);
                helper.fetchDepValues(component, ListOfDependentFields);             
            }
        } else {
				component.set("v.majorPickListErr" , true);             
				component.set("v.mediumPickListErr" , true);
        }
    },
    
    //New Added dependent medium Handler
    onDependentFieldChange: function(component, event, helper) { 

        var dependentValueKey = event.getSource().get("v.value");// get selected dependent field value
        component.set("v.freeWordFld" , true);  
        console.log("dependentValueKey = " + dependentValueKey);
        component.find("primaryCompletionFreeWord").set("v.value", '');      
		if (dependentValueKey != '--- None ---') {
            component.set("v.mediumPickListErr" , false);
            component.set("v.mediumPickListWar" , false);
        	if(dependentValueKey == 'その他'){
          		component.set("v.freeWordFld" , false);          
        	}
        } else {
			component.set("v.mediumPickListErr" , true);
        }
        
    },
    handleIdenPicklistChange: function (component, event, helper) {  
        var selectedValues = event.getParam("value");
    },
	handleLFInquiryPicklistChange: function (component, event, helper) { 
        var selectedValues = event.getParam("value");        
    },   
	handleDMInquiryPicklistChange: function (component, event, helper) {  
        var selectedValues = event.getParam("value");
    },
	handleLTInquiryPicklistChange: function (component, event, helper) { 
        var selectedValues = event.getParam("value");
    },
    handleRelationshipPick : function(component, event, helper) {
        var relationshipWithContractor = component.get("v.newReception.RelationshipWithContractor__c");
    },
	 handleBilleeRelPick : function(component, event, helper) {
        var billeeRelationship = component.get("v.newReception.BilleeRelationship__c");
    },
	handleAddressInputPick : function(component, event, helper) {
        var disableFlag;
        var addressInput = component.get("v.newReception.AdderssInputMethod__c");
        if(addressInput == "手動入力"){
            disableFlag = false;
        }else{
            disableFlag = true;
        }
        component.find("Addressee").set("v.disabled", disableFlag);
        component.find("MailingPostalCode").set("v.disabled", disableFlag);
        component.find("MailingState").set("v.disabled", disableFlag);
        component.find("MailingCity").set("v.disabled", disableFlag);
        component.find("Address1").set("v.disabled", disableFlag);
        component.find("Address2").set("v.disabled", disableFlag);

        component.find("Addressee").set("v.value", '');
        component.find("MailingPostalCode").set("v.value", '');
        component.find("MailingState").set("v.value", '');
        component.find("MailingCity").set("v.value", '');
        component.find("Address1").set("v.value", '');
        component.find("Address2").set("v.value", '');
    },
	 handleOriginPick : function(component, event, helper) {
        var originPick = component.get("v.newReception.Origin__c");
    },
	 handleReceptionTeamPick : function(component, event, helper) {
        var receptionTeam = component.get("v.newReception.ReceptionTeam__c");
    },
     showLFinquiry : function(cmp,event,helper){
        let checkBoxState = event.getSource().get('v.value');
        cmp.find("disableEnableLF").set("v.disabled", !checkBoxState);	 
    },   
    showDMinquiry : function(cmp,event,helper){  
         let checkBoxState = event.getSource().get('v.value');
        cmp.find("disableEnableDM").set("v.disabled", !checkBoxState);
    },
    showLTinquiry : function(cmp,event,helper){
        let checkBoxState = event.getSource().get('v.value');
        cmp.find("disableEnableLT").set("v.disabled", !checkBoxState);
    },
    handleAreaInfo : function(cmp,event,helper){
        helper.areaInfo(cmp, event);             
    },

    // Handle Enter & Space KeyDown event in Button Div
    // Use as Common Method for other components also
    preventDefault: function(component, event, helper) {
        var keycode = event.code;
        if (keycode == 'Enter' || keycode == 'Space'){
            event.preventDefault();
            event.stopImmediatePropagation();
        }
    },
    
    //handle Save
    handleSaveReception : function(component, event, helper) {
        
		var majorPickListErr = component.get("v.majorPickListErr");
		var mediumPickListErr = component.get("v.mediumPickListErr");
        var majorPickListWar = component.get("v.majorPickListWar");
		var mediumPickListWar = component.get("v.mediumPickListWar");
        
        /** ONYXシステム対応で追加　開始 */
        var validRecord = true;
		var AccountName = component.find("AccName");
        var adderssInputMethod = component.find("adderssInputMethodPicklist").get("v.value");
        
       if($A.util.isEmpty(AccountName.get("v.value")) && (adderssInputMethod=="取引先から引用"||(adderssInputMethod!="手動入力" && adderssInputMethod!="リクエストで指定"))) {
            validRecord = false;
            console.log("SettingErr");
            alert('募集人またはエージェントから受付登録する場合、送付先の入力方法には「手入力」または「リクエストで指定」を選択してください。');
        }
        
        //Error Message for controller & dependent field.
        if(majorPickListErr){
            component.set("v.majorPickListWar" , true); 
            component.find('primaryCompletionMajorItemPickList').focus();
        }
        if(mediumPickListErr){
            component.set("v.mediumPickListWar" , true);
            component.find('primaryCompletionMediumItemPickList').focus();
        }
        
        if(validRecord && !majorPickListErr && !mediumPickListErr){
            helper.saveReception(component, event);
       }
       /** ONYXシステム対応で追加　終了 */ 
    },
    handleCancel : function(component, event, helper) {
        helper.showHide(component);
        event.preventDefault();
        var accountPageRef = component.get("v.pageReference");
        var accountId = accountPageRef.state.c__accountId;
        /** ONYXシステム対応で追加　開始 */
        var receptionId = accountPageRef.state.c__receptionId;
        var isClone = accountPageRef.state.c__isClone;
        var MasterId = accountPageRef.state.c__MasterRecordId;
        /** ONYXシステム対応で追加　終了 */ 
        component.set('v.accountId', accountId);
        
        if(receptionId != '' && isClone == 1 ) {
            $A.get("e.force:navigateToSObject").setParams({
                        recordId: receptionId,
                        slideDevName: "detail"
                    }).fire();
            }       
        else if(accountId != ''){
            $A.get("e.force:navigateToSObject").setParams({
                        recordId: accountId,
                        slideDevName: "detail"
                    }).fire();
        }
        else if(MasterId != '' && accountId =='' ){
            $A.get("e.force:navigateToSObject").setParams({
                recordId: MasterId,
                slideDevName: "detail"
            }).fire();
        }
        
        var receptionSubTab = component.find("ReceptionSubTab");
        receptionSubTab.getFocusedTabInfo().then(function (response){
            var focusedTabId = response.tabId;
            receptionSubTab.closeTab({ tabId : focusedTabId});
        });
 	},
	handleReportOpen: function(component, event, helper){
        var sourceLabel = event.getSource().get("v.label");
		var reportID = "";
        var accountId = component.get("v.accountId");
        var loginFlg = component.get("v.loginFlg");
        
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
            var navService = component.find("navCreateReceptionRADC");
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
    },

    onRecruiterChenged : function(component, event, helper){
        var master=component.find("Recruiter").get("v.value");
        var masterId=(master.length>0)?master[0]:'';
        helper.setMasterNameKana(component, masterId);
    },
    onAgentChenged : function(component, event, helper){
        var master=component.find("Agent").get("v.value");
        var masterId=(master.length>0)?master[0]:'';
        helper.setMasterNameKana(component, masterId);
    }
})