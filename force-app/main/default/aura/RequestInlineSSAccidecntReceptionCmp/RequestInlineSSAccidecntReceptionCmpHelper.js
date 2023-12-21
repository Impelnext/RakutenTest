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
    getsyotanShipmentPickList: function(component, event) {
        var action = component.get("c.getMultiPiklistValues");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'SendingProductsForSS__c'
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
                component.set("v.syotanShipmentPickList", plValues);

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
                var values = ["無"];
                component.set("v.lstOtherDocumentsToSend", values);
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
	 getReporterPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Reporter__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var reporterPickMap = [];
                for(var key in result){
                    reporterPickMap.push({key: key, value: result[key]});
                }
                component.set("v.reporterPickMap", reporterPickMap);
            }
        });
        $A.enqueueAction(action);
    },
     getDocumentDeliveryPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'DocumentDelivery__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var documentDeliveryPickMap = [];
                for(var key in result){
                    documentDeliveryPickMap.push({key: key, value: result[key]});
                }
                component.set("v.documentDeliveryPickMap", documentDeliveryPickMap);
            }
        });
        $A.enqueueAction(action);
    },
    getInquirySummaryPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'InquirySummaryForAccidentReception__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var InquirySummaryPickMap = [];
                for(var key in result){
                    InquirySummaryPickMap.push({key: key, value: result[key]});
                }
                component.set("v.InquirySummaryPickMap", InquirySummaryPickMap);
            }
        });
        $A.enqueueAction(action);
    },
    
    getNumberOfSendingCopiesPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'NumberOfSendingCopies__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var numberOfSendingCopiesPickMap = [];
                for(var key in result){
                    numberOfSendingCopiesPickMap.push({key: key, value: result[key]});
                }
                component.set("v.numberOfSendingCopiesPickMap", numberOfSendingCopiesPickMap);
            }
        });
        $A.enqueueAction(action);
    },
     getRegisteredInsurancePrmTransferAccountPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'RegisteredInsurancePrmTransferAccount__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var registeredInsurancePrmTransferAccountPickMap = [];
                for(var key in result){
                    registeredInsurancePrmTransferAccountPickMap.push({key: key, value: result[key]});
                }
                component.set("v.registeredInsurancePrmTransferAccountPickMap", registeredInsurancePrmTransferAccountPickMap);
            }
        });
        $A.enqueueAction(action);
    },
     getDepositCategoryPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'DepositCategory__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var depositCategoryPickMap = [];
                for(var key in result){
                    depositCategoryPickMap.push({key: key, value: result[key]});
                }
                component.set("v.depositCategoryPickMap", depositCategoryPickMap);
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