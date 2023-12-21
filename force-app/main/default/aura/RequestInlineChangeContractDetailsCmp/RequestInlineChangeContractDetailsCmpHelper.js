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

    getRequestContentsPickList: function(component, event,dependantSubject) {
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'RequestContents__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();          
                var ListOfDependentFieldsSubProcessing = depSubResponse[dependantSubject];
                 var plValues = [];
                for (var i = 0; i < ListOfDependentFieldsSubProcessing.length; i++) {
                    plValues.push({
                        label: ListOfDependentFieldsSubProcessing[i],
                        value: ListOfDependentFieldsSubProcessing[i]
                    });
                }
                component.set("v.requestContentsPickList", plValues);
            }           
        });
        $A.enqueueAction(subDepAction);       
    },
    getOtherRequestsPickList: function(component, event) {
        var action = component.get("c.getMultiPiklistValues");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'OtherRequests__c'
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
                component.set("v.otherRequestsPickList", plValues);
            }
        });
        $A.enqueueAction(action);
    },
	getOtherDocumentsToSendPicklist: function(component, event) {
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
                component.set("v.otherDocumentsToSendPicklist", plValues);
            }
        });
        $A.enqueueAction(action);
    },
	getPersonToBeChangedPicklist: function(component, event) {
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
                component.set("v.personToBeChangedPicklist", plValues);
            }
        });
        $A.enqueueAction(action);
    },
	getChangePointPicklist: function(component, event) {
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
                component.set("v.changePointPicklist", plValues);
            }
        });
        $A.enqueueAction(action);
    },
	getSubjectPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Subject__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var subjectPickMap = [];
                for(var key in result){
                    subjectPickMap.push({key: key, value: result[key]});
                }
                component.set("v.subjectPickMap", subjectPickMap);
            }
        });
        $A.enqueueAction(action);
    },	
     
	 getOtherOrderFlagPicklist: function(component, event) {
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
	getOtherOrderDocFlagPicklist: function(component, event) {
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
     getSendingReasonPicklist: function(component, event) {
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
	   getWhetherDestinationInformationChangedPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'WhetherDestinationInformationChanged__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var whetherDestinationInformationChangedPickMap = [];
                for(var key in result){
                    whetherDestinationInformationChangedPickMap.push({key: key, value: result[key]});
                }
                component.set("v.whetherDestinationInformationChangedPickMap", whetherDestinationInformationChangedPickMap);
            }
        });
        $A.enqueueAction(action);
    }
})