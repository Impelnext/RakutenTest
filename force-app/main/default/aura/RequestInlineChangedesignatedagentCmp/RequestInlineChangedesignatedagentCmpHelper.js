({
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
                    this.fetchDepValuesSubProcess(component, ListOfDependentFieldsSubProcessing,"v.processingPicklist");    
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
	/*getProcedureTypePicklist: function(component, event,dependantSubject) {    
        component.set("v.procedureType1PickList", dependantSubject);  
        component.set("v.procedureType2PickList", dependantSubject);
        component.set("v.procedureType3PickList", dependantSubject);
        component.set("v.procedureType4PickList", dependantSubject);
        component.set("v.procedureType5PickList", dependantSubject); 
        component.set("v.procedureType6PickList", dependantSubject);
        component.set("v.procedureType7PickList", dependantSubject);
        component.set("v.procedureType8PickList", dependantSubject);
        component.set("v.procedureType9PickList", dependantSubject);
        component.set("v.procedureType10PickList", dependantSubject);
    },*/
    getProcedureType1Picklist: function(component, event,dependantSubject) {  
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'ProcedureType1__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.procedureType1PickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.procedureType1PickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.procedureType1PickList");    
                }   
            }         
        });
        $A.enqueueAction(subDepAction);                
    },
    getProcedureType2Picklist: function(component, event,dependantSubject) {  
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'ProcedureType2__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.procedureType2PickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.procedureType2PickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.procedureType2PickList");    
                }   
            }         
        });
        $A.enqueueAction(subDepAction);                
    },
    getProcedureType3Picklist: function(component, event,dependantSubject) {  
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'ProcedureType3__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.procedureType3PickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.procedureType3PickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.procedureType3PickList");    
                }   
            }         
        });
        $A.enqueueAction(subDepAction);                
    },
    getProcedureType4Picklist: function(component, event,dependantSubject) {  
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'procedureType4__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.procedureType4PickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.procedureType4PickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.procedureType4PickList");    
                }   
            }         
        });
        $A.enqueueAction(subDepAction);                
    },
    getProcedureType5Picklist: function(component, event,dependantSubject) {  
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'ProcedureType5__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.procedureType5PickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.procedureType5PickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.procedureType5PickList");    
                }   
            }         
        });
        $A.enqueueAction(subDepAction);                
    },
    getProcedureType6Picklist: function(component, event,dependantSubject) {  
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'ProcedureType6__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.procedureType6PickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.procedureType6PickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.procedureType6PickList");    
                }   
            }         
        });
        $A.enqueueAction(subDepAction);                
    },
    getProcedureType7Picklist: function(component, event,dependantSubject) {  
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'ProcedureType7__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.procedureType7PickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.procedureType7PickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.procedureType7PickList");    
                }   
            }         
        });
        $A.enqueueAction(subDepAction);                
    },
    getProcedureType8Picklist: function(component, event,dependantSubject) {  
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'ProcedureType8__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.procedureType8PickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.procedureType8PickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.procedureType8PickList");    
                }   
            }         
        });
        $A.enqueueAction(subDepAction);                
    },
    getProcedureType9Picklist: function(component, event,dependantSubject) {  
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'ProcedureType9__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.procedureType9PickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.procedureType9PickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.procedureType9PickList");    
                }   
            }         
        });
        $A.enqueueAction(subDepAction);                
    },
    getProcedureType10Picklist: function(component, event,dependantSubject) {  
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'ProcedureType10__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.procedureType10PickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.procedureType10PickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.procedureType10PickList");    
                }   
            }         
        });
        $A.enqueueAction(subDepAction);                
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
    fetchDepValuesSubProcess: function(component, ListOfDependentFields,listSubDependingValues) {
		// create a empty array var for store dependent picklist values for controller field  
		var dependentFields = [];
		for (var i = 0; i < ListOfDependentFields.length; i++) {
			dependentFields.push(ListOfDependentFields[i]);
		}
		// set the dependentFields variable values to store(dependent picklist field) on lightning:select
		 component.set(listSubDependingValues, dependentFields);
	},
    getDoubleByteCheck: function(component,event,inputValue,resultValue) {
        var getValue = component.get(inputValue);
        if(getValue != ''){
             var action = component.get("c.checkingDoubleByteName");
            action.setParams({
                "givenValue" : getValue
            });
            //set callback   
            action.setCallback(this, function(response) {
                if (response.getState() === "SUCCESS") {
                    var StoreResponse = response.getReturnValue();
                    component.set(resultValue,StoreResponse);
                }
                else if(state === "ERROR"){
                    var errors = action.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            alert(errors[0].message);
                        }
                    }
                }
             });
             $A.enqueueAction(action);
        }
        else{
            component.set(resultValue,false);
        }      
    },
    getSingleByteCheck: function(component,event,inputValue,resultValue) {
        var getValue = component.get(inputValue);
        var action = component.get("c.checkingOtherThanSingleByte");
        action.setParams({
            "givenValue" : getValue
        });
        //set callback   
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var StoreResponse = response.getReturnValue();
                component.set(resultValue,StoreResponse);
            }
            else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }
         });
         $A.enqueueAction(action);
    },
    getNumericValidate: function(component, event,newReceiptDate,resultResp) {  
    	 var action = component.get("c.isNumericValidate");
        action.setParams({
            givenValue : newReceiptDate
        });
        action.setCallback(this, function(response){   
            if(response.getState() === "SUCCESS"){
                var result = response.getReturnValue();  
                component.set(resultResp, result);  
            }         
        });
        $A.enqueueAction(action); 
    },
    getOtherDetailDepPicklist: function(component,event) {
        var selectedValues1 = component.find("otherDetails1").get("v.value");
        var selectedValues2 = component.find("otherDetails2").get("v.value"); 
        var selectedValues3 = component.find("otherDetails3").get("v.value"); 
        var selectedValues4 = component.find("otherDetails4").get("v.value"); 
        var selectedValues5 = component.find("otherDetails5").get("v.value"); 
        var selectedValues6 = component.find("otherDetails6").get("v.value"); 
        var selectedValues7 = component.find("otherDetails7").get("v.value");
        var selectedValues8 = component.find("otherDetails8").get("v.value"); 
        var selectedValues9 = component.find("otherDetails9").get("v.value"); 
        var selectedValues10 = component.find("otherDetails10").get("v.value"); 	
        if(selectedValues1 == '指定範囲外' || selectedValues2 == '指定範囲外' || selectedValues3 == '指定範囲外' || selectedValues4 == '指定範囲外' || selectedValues5 == '指定範囲外' || selectedValues6 == '指定範囲外' 
        || selectedValues7 == '指定範囲外' || selectedValues8 == '指定範囲外' || selectedValues9 == '指定範囲外'|| selectedValues10 == '指定範囲外'){
            //No Change in Process PickList
        }else{
            var dependantSubject = component.get('v.dependantSubject');
            this.getProcessingPicklist(component, event,dependantSubject);
        }
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