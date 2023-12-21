({
    getAccDetailsHelp:  function(component, event) 	{
    var accountPageRef = component.get("v.pageReference");
    var accountId = accountPageRef.state.c__accountId;
    component.set('v.accountId', accountId);
    var action = component.get("c.getAccDetails");
	action.setParams({  receptionAccId :  accountId}); 
        action.setCallback(this,function(response){
            var result = response.getState();
            if(result === "SUCCESS"){               
                var accDetails = response.getReturnValue();
                component.set("v.accDetails", accDetails);
                console.log("accDetails.furigana__c " + accDetails.furigana__c);
                component.find("NameOffererKana").set("v.value",accDetails.furigana__c);
            }
            var receptionSubTab = component.find("ReceptionSubTab");
            receptionSubTab.getFocusedTabInfo().then(function (response){
                var focusedTabId = response.tabId;
                receptionSubTab.setTabLabel({ 
                    tabId : focusedTabId,
                    label : "受付情報　登録"
                });
            });
        });
		$A.enqueueAction(action);
    },
   
    /** ONYXシステム対応で追加　開始 */
    getRecDetailsHelp:  function(component, event) 	{
   
        var accountPageRef = component.get("v.pageReference");
        var recId = accountPageRef.state.c__receptionId;
        var action2 = component.get("c.getAccReceptionDetails");
        action2.setParams({ receptionId:recId }); 
        action2.setCallback(this,function(response){
        var result = response.getState();
        if(result === "SUCCESS"){  
            var recDetailsJs = response.getReturnValue();
            if(recDetailsJs!=''){
                component.set("v.newReception",recDetailsJs);
                component.find("NameOffererKana").set("v.value",recDetailsJs.NameOffererKana__c);
                console.log(recDetailsJs);
                if(recDetailsJs.Account__r){
                    console.log(recDetailsJs.Account__r);
                    component.set("v.accDetails", recDetailsJs.Account__r);
                }
                var disableFlag;
                var addressInput = recDetailsJs.AdderssInputMethod__c;
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

                var newAreaInfoMap = {prefecture:recDetailsJs.MailingState__c,municipality:recDetailsJs.MailingCity__c,chome:recDetailsJs.Address1__c};
                component.set("v.getAreaInfoMap",newAreaInfoMap);
                // MultiPicklist Initialize
                var selectValues = recDetailsJs.Identification__c;
                if (selectValues) {
                    var slValues = selectValues.split(';');
                    component.set("v.newReception.Identification__c", slValues);
                }
                var selectValues1 = recDetailsJs.LF_InquiryName__c;
                if (selectValues1) {
                    var slValues = selectValues1.split(';');
                    component.set("v.newReception.LF_InquiryName__c", slValues);
                }
                var selectValues2 = recDetailsJs.DM_InquiryName__c;
                if (selectValues2) {
                    var slValues = selectValues2.split(';');
                    component.set("v.newReception.DM_InquiryName__c", slValues);
                    console.log(recDetailsJs);
                }
                var selectValues3 = recDetailsJs.LT_InquiryName__c;
                if (selectValues3) {
                    var slValues = selectValues3.split(';');
                    component.set("v.newReception.LT_InquiryName__c", slValues);
                }
                if(recDetailsJs.LF_Inquiry__c)
                    component.find("disableEnableLF").set("v.disabled", !recDetailsJs.LF_Inquiry__c);
                if(recDetailsJs.DM_Inquiry__c)
                    component.find("disableEnableDM").set("v.disabled", !recDetailsJs.DM_Inquiry__c);
                if(recDetailsJs.LT_Inquiry__c)
                    component.find("disableEnableLT").set("v.disabled", !recDetailsJs.LT_Inquiry__c);
            }
        }
        var receptionSubTab = component.find("ReceptionSubTab");
        receptionSubTab.getFocusedTabInfo().then(function (response){
                var focusedTabId = response.tabId;
                receptionSubTab.setTabLabel({ 
                    tabId : focusedTabId,
                    label : "受付情報" //登録"
                });
            });
        });
		$A.enqueueAction(action2);
    },

    setMasterRecord:function(component,event){
        var PageRef = component.get("v.pageReference");
        console.log("MasterName" + PageRef.state.c__masterName);
        console.log("MasterRecordId" + PageRef.state.c__MasterRecordId);
        console.log("ObjName" + PageRef.state.c__objName);
	    if(PageRef.state.c__MasterRecordId!='' && PageRef.state.c__objName=="SeihoRecruiterMaster__c"){
        	component.set("v.newReception.SeihoRecruiter__c", PageRef.state.c__MasterRecordId);
         	component.find("NameOffererKana").set("v.value",PageRef.state.c__kanaName); 
        	}
        else if(PageRef.state.c__MasterRecordId!='' && PageRef.state.c__objName=="SeihoAgentMaster__c"){
       		component.set("v.newReception.SeihoAgent__c", PageRef.state.c__MasterRecordId);
         	component.find("NameOffererKana").set("v.value",PageRef.state.c__kanaName);
        }
        var receptionSubTab = component.find("ReceptionSubTab");
        receptionSubTab.getFocusedTabInfo().then(function (response){
            var focusedTabId = response.tabId;
            receptionSubTab.setTabLabel({ 
                tabId : focusedTabId,
                label : "受付情報　登録"
            });
        });  
    },
    /** ONYXシステム対応で追加　終了 */ 
    
    getRelationshipPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Reception__c',
			fieldName : 'RelationshipWithContractor__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                   
                var result = response.getReturnValue();
                var relationshipPickMap = [];
                for(var key in result){
                    relationshipPickMap.push({key: key, value: result[key]});
                }
                component.set("v.relationshipPickMap", relationshipPickMap);
            }
        });
        $A.enqueueAction(action);
    },
     getBilleRelationshipPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Reception__c',
			fieldName : 'BilleeRelationship__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var billeRelationshipPickMap = [];
                for(var key in result){
                    billeRelationshipPickMap.push({key: key, value: result[key]});
                }
                component.set("v.billeRelationshipPickMap", billeRelationshipPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getAdderssInputMethodPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Reception__c',
			fieldName : 'AdderssInputMethod__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var adderssInputMethodPickMap = [];
                for(var key in result){
                    adderssInputMethodPickMap.push({key: key, value: result[key]});
                }
                component.set("v.adderssInputMethodPickMap", adderssInputMethodPickMap);
                component.find("adderssInputMethodPicklist").set("v.value","取引先から引用");
            }
        });
        $A.enqueueAction(action);
    },
	getOriginPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Reception__c',
			fieldName : 'Origin__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var originPickMap = [];
                for(var key in result){
                    originPickMap.push({key: key, value: result[key]});
                }
                component.set("v.originPickMap", originPickMap);
                component.find("originPicklist").set("v.value","電話");
            }
        });
        $A.enqueueAction(action);
    },
	getReceptionTeamPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Reception__c',
			fieldName : 'ReceptionTeam__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var receptionTeamPickMap = [];
                for(var key in result){
                    receptionTeamPickMap.push({key: key, value: result[key]});
                }
                component.set("v.receptionTeamPickMap", receptionTeamPickMap);
            }
        });
        $A.enqueueAction(action);
    },
     getIdentificationMultiList: function(component, event) {
         var action = component.get("c.getMultiPiklistValues");
		action.setParams({
			objectName : 'Reception__c',
			fieldName : 'Identification__c'
		});
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var plValues = [];
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        value: result[i],
                        label: result[i]
                        
                    });
                }
                component.set("v.genreIdentificationList", plValues);
            }
        });
        $A.enqueueAction(action);
    },
	getLFInquiryMultiList: function(component, event) {
        var action = component.get("c.getMultiPiklistValues");
		action.setParams({
			objectName : 'Reception__c',
			fieldName : 'LF_InquiryName__c'
		});
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var plValues = [];
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.genreLFInquiryList", plValues);
            }
        });
        $A.enqueueAction(action);
    },
	getDMInquiryMultiList: function(component, event) {
        var action = component.get("c.getMultiPiklistValues");
		action.setParams({
			objectName : 'Reception__c',
			fieldName : 'DM_InquiryName__c'
		});
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var plValues = [];
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.genreDMInquiryList", plValues);
            }
        });
        $A.enqueueAction(action);
    },
	getLTInquiryMultiList: function(component, event) {
        var action = component.get("c.getMultiPiklistValues");
		action.setParams({
			objectName : 'Reception__c',
			fieldName : 'LT_InquiryName__c'
		});
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var plValues = [];
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.genreLTInquiryList", plValues);
            }
        });
        $A.enqueueAction(action);
    },
    getContractInfo: function(component,event){
        var accountPageRef = component.get("v.pageReference");
        var accountId = accountPageRef.state.c__accountId;
        var action = component.get("c.getContractInfo");
        action.setParams({ recAccountId : accountId });
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
                    if(key === "SEIHO_TOKUYAKU" && map[key]){
                        component.find("btnSeihoTokuyaku").set("v.disabled", false);
                    }
                    if(key === "SONPO" && map[key]){
                        component.find("btnSonpo").set("v.disabled", false);
                    }
                    if(key === "SYOTAN" && map[key]){
                        component.find("btnSyotan").set("v.disabled", false);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    areaInfo : function(component,event){
        var receivedPostal = event.getSource().get('v.value');      
        var action = component.get('c.getAreaInfo');
        action.setParams({
            postalCode : receivedPostal
        });
        action.setCallback(this,function(response){
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {                 
                component.set('v.getAreaInfoMap',response.getReturnValue());
            }
        });  
        $A.enqueueAction(action);        
    },
    //handle Save
    saveReception : function(component, event) {
        // Double click prevention
        var bel=document.getElementsByClassName("slds-backdrop");
        var bl=bel.length;
        for(var cnt=0;cnt<bl;cnt++){
            bel[cnt].classList.add('slds-backdrop_open');
        }

        var PageRef = component.get("v.pageReference");
        var accountId = PageRef.state.c__accountId;
        component.set('v.accountId', accountId);

        var getAreaInfoMap = component.get("v.getAreaInfoMap");
        var rec = component.get("v.newReception");
        var action = component.get("c.saveReception");
        var receptionSubTab = component.find("ReceptionSubTab");
        var nameOfkana = component.find("NameOffererKana");
        component.set('v.newReception.NameOffererKana__c', nameOfkana.get("v.value"));
        
        var receptionId = PageRef.state.c__receptionId;
        var setClone = PageRef.state.c__isClone;
        
         if(receptionId != '' && setClone == 1 ){
            action.setParams({
                rec : rec,
                areaInfoMap : getAreaInfoMap,
                clone : setClone
                
            });   
        }
        //Onyx
       else if(!$A.util.isEmpty(accountId)){
            action.setParams({
                rec : rec,
                accountId : accountId,
                areaInfoMap : getAreaInfoMap,
                
            });
        }
        
        else{
          	 action.setParams({
                rec : rec,
                areaInfoMap : getAreaInfoMap
            });  
        }
        action.setCallback(this,function(response){
            var self = this;
            var state = response.getState();
            // Remove the mask
            var bel=document.getElementsByClassName("slds-backdrop");
            var bl=bel.length;
            for(var cnt=0;cnt<bl;cnt++){
                bel[cnt].classList.remove('slds-backdrop_open');
            }
            
            if(state === "SUCCESS"){
                alert('受付情報を作成しました');
                var recDetails = response.getReturnValue();
                /*$A.get("e.force:navigateToSObject").setParams({
                    recordId: recDetails.Id,
                    slideDevName: "detail"
                }).fire();*/
                receptionSubTab.getFocusedTabInfo().then(function (focusedTabResponse){
                    var focusedTabId = focusedTabResponse.tabId;
                    var parentTabId = focusedTabResponse.parentTabId;
                    receptionSubTab.openSubtab({
                        parentTabId : parentTabId,
                        recordId : recDetails.Id,
                        focus :true
                    }).then(function (openSubTabresponse){
                        receptionSubTab.setTabLabel({
                            tabId: openSubTabresponse,
                            label: recDetails.Name
                        });
                        self.closeOpenTab(component,focusedTabResponse,focusedTabId);
                    });
                }); 
            } else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //self.setInitFocus(component);
                        alert(errors[0].message);
                    }
                }
            }else if (status === "INCOMPLETE") {
                alert('サーバーからレスポンスがありません');
            }
        });
        $A.enqueueAction(action);
    },
    showHide : function(component) {
        var editForm = component.find("editForm");
        $A.util.toggleClass(editForm, "slds-hide");
        var viewForm = component.find("viewForm");
		$A.util.toggleClass(viewForm, "slds-hide");
    },
    closeOpenTab : function (component, focusedTabResponse,focusedTabId){

        var receptionTab = component.find("ReceptionSubTab");
        receptionTab.closeTab({
            tabId : focusedTabId
        });
    },
    setInitFocus: function(component) {
        var fields = component.find('NameOffererKana');
        Array.isArray(fields) ? fields[0].focus() : fields.focus();
	},
	getButtonReportNavigation: function(component, event) {
        var accountPageRef = component.get("v.pageReference");
        var accountId = accountPageRef.state.c__accountId;
        var action = component.get("c.getAccountContract");
        action.setParams({ accountId : accountId});
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
    },
    
    /*new added helper*/
    fetchPicklistValues: function(component,objDetails,controllerField, dependentField) {
       
        var action = component.get("c.getDependentMap");
        action.setParams({
            'objDetail' : objDetails,
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField 
        });
       
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
               var StoreResponse = response.getReturnValue();
                component.set("v.depnedentFieldMap",StoreResponse);
                var listOfkeys = []; 
                var ControllerField = []; 
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push('--- None ---');
                }
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push(listOfkeys[i]);
                }  
                component.set("v.listControllingValues", ControllerField);
            }else{
                alert('Something went wrong..');
            }
        });
        $A.enqueueAction(action);
    },
   
    /*new added helper*/    
    fetchDepValues: function(component, ListOfDependentFields) {
       
        var dependentFields = [];
        dependentFields.push('--- None ---');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);         
        }
        
        component.set("v.listDependingValues", dependentFields);
        
    },
       
    setMasterNameKana: function(component, masterId) {
        if(masterId) {
            var action = component.get("c.getMasterInfo");
            action.setParams({ masterId : masterId});
            action.setCallback(this,function(response){
                var result = response.getState();
                if(result === "SUCCESS"){
                    var map = response.getReturnValue();
                    for(var key in map ) {
                        if(key === 'KANA_NAME' && map[key]) {
                            component.find("NameOffererKana").set("v.value",map[key]);
                        }
                    }
                }
            });
            $A.enqueueAction(action);    
        }else{
            var PageRef = component.get("v.pageReference");
            component.find("NameOffererKana").set("v.value",PageRef.state.c__kanaName); 
        }
    },
       
})