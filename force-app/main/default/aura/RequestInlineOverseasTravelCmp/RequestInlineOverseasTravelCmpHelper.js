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
		            component.set("v.innerCmpNewRequest.AgentPrefectures__c",component.get('v.getAreaInfoMap').prefecture+component.get('v.getAreaInfoMap').municipality+component.get('v.getAreaInfoMap').chome);
                    //component.set("v.innerCmpNewRequest.AgentPrefectures__c", "v.mapAreaInfoMerge");
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
    
    
    getProcessingPicklist: function(component, event,dependantSubject) {
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'Processing__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.processingPickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.processingPickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.processingPicklist");    
                }   
            }         
        });
        $A.enqueueAction(subDepAction); 
    },	
	getShippingDocumentsPicklist: function(component, event,dependantSubject) {
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'ShippingDocuments__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.shippingDocumentsPickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.shippingDocumentsPickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.shippingDocumentsPickList");    
                }   
            }         
        });
        $A.enqueueAction(subDepAction);
    },   
	getDateOfShipmentPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'DateOfShipment__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var dateOfShipmentPickMap = [];
                for(var key in result){
                    dateOfShipmentPickMap.push({key: key, value: result[key]});
                }
                component.set("v.dateOfShipmentPickMap", dateOfShipmentPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getShippingMethodPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'ShippingMethod__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var shippingMethodPickMap = [];
                for(var key in result){
                    shippingMethodPickMap.push({key: key, value: result[key]});
                }
                component.set("v.shippingMethodPickMap", shippingMethodPickMap);
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
	},    
    getSingleByteNumberCheck: function(component,event,inputValue,resultValue) {
    	
        var getValue = component.get(inputValue);
        var numberRegx = /^\d+$/;
        if (getValue === undefined || 
            getValue === null || 
            getValue === '' || 
            numberRegx.test(getValue)) {
            component.set(resultValue, false);
        }
        else {
            component.set(resultValue, true);
        }
    }    
})