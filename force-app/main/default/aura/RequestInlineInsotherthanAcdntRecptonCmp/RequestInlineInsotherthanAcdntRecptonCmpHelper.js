({
   areaInfo : function(component,event){
        var receivedPostal = event.getSource().get('v.value'); 
        var action = component.get("c.getAreaInfo");
        action.setParams({
            postalCode : receivedPostal
        });
        action.setCallback(this,function(response){
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {                 
                component.set('v.getAreaInfoMap',response.getReturnValue());
				if(component.get("v.getAreaInfoMap").prefecture != ''){
                    component.set("v.innerCmpNewRequest.ChangedPrefecture__c", component.get("v.getAreaInfoMap").prefecture);
                }
                if(component.get("v.getAreaInfoMap").municipality != ''){  
                    component.set("v.innerCmpNewRequest.ChangedMunicipality__c", component.get("v.getAreaInfoMap").municipality);
                }      
                if(component.get("v.getAreaInfoMap").chome != ''){
                    component.set("v.innerCmpNewRequest.ChangedAddress1__c", component.get("v.getAreaInfoMap").chome);
                }
            }else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }else if (status === "INCOMPLETE") {
                alert('サーバーからレスポンスがありません');
            }
        });  
        $A.enqueueAction(action);    
    },
    getinquirySummaryPickList: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'InquirySummary__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var inquirySummaryPickMap = [];
                for(var key in result){
                    inquirySummaryPickMap.push({key: key, value: result[key]});
                }
                component.set("v.inquirySummaryPickMap", inquirySummaryPickMap);
            }
        });
        $A.enqueueAction(action);
    },	
	getCorrespondenceRequestPicklist: function(component, event,dependantSubject) {
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'CorrespondenceRequest__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.correspondenceRequestPickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.correspondenceRequestPickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.correspondenceRequestPickList");    
                }   
            }         
        });
        $A.enqueueAction(subDepAction);
	},
	getotherOrderFlagPickList: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'OtherOrderFlag__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var otherOrderFlagPickMap = [];
                for(var key in result){
                    otherOrderFlagPickMap.push({key: key, value: result[key]});
                }
                component.set("v.otherOrderFlagPickMap", otherOrderFlagPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getotherOrderDocFlagPickList: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'OtherOrderDocFlag__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var otherOrderDocFlagPickMap = [];
                for(var key in result){
                    otherOrderDocFlagPickMap.push({key: key, value: result[key]});
                }
                component.set("v.otherOrderDocFlagPickMap", otherOrderDocFlagPickMap);
            }
        });
        $A.enqueueAction(action);
    },
     getsendingReasonPickList: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'SendingReason__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var sendingReasonPickMap = [];
                for(var key in result){
                    sendingReasonPickMap.push({key: key, value: result[key]});
                }
                component.set("v.sendingReasonPickMap", sendingReasonPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getwhetherDestiInformationChngdPickList: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'WhetherDestinationInformationChanged__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var whetherDestiInformationChngdPickMap = [];
                for(var key in result){
                    whetherDestiInformationChngdPickMap.push({key: key, value: result[key]});
                }
                component.set("v.whetherDestiInformationChngdPickMap", whetherDestiInformationChngdPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getotherDocumentsToSendPickList: function(component, event) {
        var action = component.get("c.getMultiPiklistValues");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'OtherDocumentsToSend__c'
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
                component.set("v.otherDocumentsToSendPickList", plValues);
                var values = ["無"];
                component.set("v.lstOtherDocumentsToSend", values);
            }
        });
        $A.enqueueAction(action);
    },
    getpersonToBeChangedPickList: function(component, event) {
        var action = component.get("c.getMultiPiklistValues");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'PersonToBeChanged__c'
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
                component.set("v.personToBeChangedPickList", plValues);
            }
        });
        $A.enqueueAction(action);
    },
    getchangePointPickListPickList: function(component, event) {
        var action = component.get("c.getMultiPiklistValues");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'ChangePoint__c'
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
                component.set("v.changePointPickList", plValues);
            }
        });
        $A.enqueueAction(action);
    },
    fetchDepValuesSub: function(component, ListOfDependentFields,listSubDependingValues) {
		// create a empty array var for store dependent picklist values for controller field  
		var dependentFields = [];
		dependentFields.push('--- None ---');
		for (var i = 0; i < ListOfDependentFields.length; i++) {
			dependentFields.push(ListOfDependentFields[i]);
		}
		// set the dependentFields variable values to store(dependent picklist field) on lightning:select
		 component.set(listSubDependingValues, dependentFields);
	}
})