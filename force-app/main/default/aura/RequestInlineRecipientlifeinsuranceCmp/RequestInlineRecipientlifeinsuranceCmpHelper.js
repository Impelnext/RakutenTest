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
    	component.set("v.ProcedureType1PickList", dependantSubject);  
        component.set("v.ProcedureType2PickList", dependantSubject);
        component.set("v.ProcedureType3PickList", dependantSubject);
        component.set("v.ProcedureType4PickList", dependantSubject);
        component.set("v.ProcedureType5PickList", dependantSubject); 
        component.set("v.ProcedureType6PickList", dependantSubject);
        component.set("v.ProcedureType7PickList", dependantSubject);
        component.set("v.ProcedureType8PickList", dependantSubject);
        component.set("v.ProcedureType9PickList", dependantSubject);
        component.set("v.ProcedureType10PickList", dependantSubject);    
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
                component.set("v.ProcedureType1PickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.ProcedureType1PickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.ProcedureType1PickList");    
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
                component.set("v.ProcedureType2PickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.ProcedureType2PickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.ProcedureType2PickList");    
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
                component.set("v.ProcedureType3PickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.ProcedureType3PickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.ProcedureType3PickList");    
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
            depfieldApiName : 'ProcedureType4__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.ProcedureType4PickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.ProcedureType4PickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.ProcedureType4PickList");    
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
                component.set("v.ProcedureType5PickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.ProcedureType5PickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.ProcedureType5PickList");    
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
                component.set("v.ProcedureType6PickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.ProcedureType6PickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.ProcedureType6PickList");    
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
                component.set("v.ProcedureType7PickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.ProcedureType7PickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.ProcedureType7PickList");    
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
                component.set("v.ProcedureType8PickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.ProcedureType8PickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.ProcedureType8PickList");    
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
                component.set("v.ProcedureType9PickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.ProcedureType9PickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.ProcedureType9PickList");    
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
                component.set("v.ProcedureType10PickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.ProcedureType10PickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.ProcedureType10PickList");    
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
        var givenValue = component.get(inputValue);
        if(givenValue != ''){
             var action = component.get("c.checkingDoubleByteName");
            action.setParams({
                "givenValue" : givenValue
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
        var givenValue = component.get(inputValue);
        var action = component.get("c.checkingOtherThanSingleByte");
        action.setParams({
            "givenValue" : givenValue
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
    getRateValueCheck : function(component,event,inputValue,resultValue) {
    	
        var errflag = component.get(resultValue);
		if (errflag === undefined || 
            errflag === null || 
            errflag === false){
			var input = component.get(inputValue);
			if (input !== undefined && 
                input !== null && 
                input !== '' && 
                (input < 10 || input > 100) ){
				component.set(resultValue, true);
			}
			else{
				component.set(resultValue, false);
			}
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
    },
    getPolicyNumberValidate: function(component,event,PolicyNumber,policyNumberList,responsePolicyNumber){		
        if(policyNumberList != ''){
          var action = component.get("c.getPolicyNumberValidate");
          action.setParams({ "givenValue" : PolicyNumber,
                            "policyNumberList": policyNumberList});
          //set callback   
            action.setCallback(this, function(response) {
                if (response.getState() === "SUCCESS") {
                    var StoreResponse = response.getReturnValue();
                    component.set(responsePolicyNumber,StoreResponse);
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
    }
})