({
    getProposalContentPickList: function(component, event,dependantSubject) {
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'ProposalContent__c'
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
                component.set("v.proposalContentPicklist", plValues);                          
            }
		});
		$A.enqueueAction(subDepAction);	
    },
	 getContentsOfGuidancePicklist: function(component, event,dependantSubject) {
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'ContentsOfGuidance__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.subDepContentsOfGuidanceFieldMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.subDepContentsOfGuidanceFieldMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.contentsOfGuidancePicklist");    
                }   
            }
            
        });
        $A.enqueueAction(subDepAction); 
    },
	getChangePlanPicklist: function(component, event) {
        var action = component.get("c.getMultiPiklistValues");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'ChangePlan__c'
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
                component.set("v.changePlanPicklist", plValues);
            }
        });
        $A.enqueueAction(action);
    },
	
	getRetentionFailurePicklist: function(component, event) {
        var action = component.get("c.getMultiPiklistValues");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'RetentionFailure__c'
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
                component.set("v.retentionFailurePicklist", plValues);
            }
        });
        $A.enqueueAction(action);
    },
	getReasonForProposalPicklist: function(component, event,dependantSubject) {
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'ReasonForProposal__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.reasonForProposalPickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.reasonForProposalPickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
				if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.reasonForProposalPicklist");    
                }   
            }
		});
        $A.enqueueAction(subDepAction);
    },
	getContinuationProposalPicklist: function(component, event,dependantSubject) {
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'ContinuationProposal__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.continuationProposalPickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.continuationProposalPickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
				if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.continuationProposalPickList");    
                }   
            }
		});
        $A.enqueueAction(subDepAction);
    },
	getRetentionSuccessPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'RetentionSuccess__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var retentionSuccessPickMap = [];
                for(var key in result){
                    retentionSuccessPickMap.push({key: key, value: result[key]});
                }
                component.set("v.retentionSuccessPickMap", retentionSuccessPickMap);
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