({
    getcontinuationProposalPicklist: function(component, event,dependantSubject) {
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
	getreasonForProposalPicklist: function(component, event,dependantSubject) {
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
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.reasonForProposalPickList");    
                }   
            }
		});
		$A.enqueueAction(subDepAction);
    },
	getproposalContentPicklist: function(component, event,dependantSubject) {
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
	getcancellationReasonPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'CancellationReason__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var cancellationReasonPickMap = [];
                for(var key in result){
                    cancellationReasonPickMap.push({key: key, value: result[key]});
                }
                component.set("v.cancellationReasonPickMap", cancellationReasonPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getcontentsOfGuidancePicklist: function(component, event,dependantSubject) {
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
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.listSubDepContentsOfGuidance");    
                }   
            }            
        });
        $A.enqueueAction(subDepAction);      
    },
	getfinalResultReasonPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'FinalResultReason__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var finalResultReasonPickMap = [];
                for(var key in result){
                    finalResultReasonPickMap.push({key: key, value: result[key]});
                }
                component.set("v.finalResultReasonPickMap", finalResultReasonPickMap);
            }
        });
        $A.enqueueAction(action);
    },
    getret1FirstOfferPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Ret1_FirstOffer__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var ret1FirstOfferPickMap = [];
                for(var key in result){
                    ret1FirstOfferPickMap.push({key: key, value: result[key]});
                }
                component.set("v.ret1FirstOfferPickMap", ret1FirstOfferPickMap);
            }
        });
        $A.enqueueAction(action);
    },
    getret1FinalResultsPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Ret1_FinalResults__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var ret1FinalResultsPickMap = [];
                for(var key in result){
                    ret1FinalResultsPickMap.push({key: key, value: result[key]});
                }
                component.set("v.ret1FinalResultsPickMap", ret1FinalResultsPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getret2FirstOfferPicklist: function(component, event) {
		var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Ret2_FirstOffer__c'
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {                
				var result = response.getReturnValue();
				var ret2FirstOfferPickMap = [];
				for(var key in result){
					ret2FirstOfferPickMap.push({key: key, value: result[key]});
				}
				component.set("v.ret2FirstOfferPickMap", ret2FirstOfferPickMap);
			}
		});
		$A.enqueueAction(action);
	},
	getret2FinalResultsPicklist: function(component, event) {
		var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Ret2_FinalResults__c'
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {                
				var result = response.getReturnValue();
				var ret2FinalResultsPickMap = [];
				for(var key in result){
					ret2FinalResultsPickMap.push({key: key, value: result[key]});
				}
				component.set("v.ret2FinalResultsPickMap", ret2FinalResultsPickMap);
			}
		});
		$A.enqueueAction(action);
	},
	getret3FirstOfferPicklist: function(component, event) {
		var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Ret3_FirstOffer__c'
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {                
				var result = response.getReturnValue();
				var ret3FirstOfferPickMap = [];
				for(var key in result){
					ret3FirstOfferPickMap.push({key: key, value: result[key]});
				}
				component.set("v.ret3FirstOfferPickMap", ret3FirstOfferPickMap);
			}
		});
		$A.enqueueAction(action);
	},
	getret3FinalResultsPicklist: function(component, event) {
		var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Ret3_FinalResults__c'
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {                
				var result = response.getReturnValue();
				var ret3FinalResultsPickMap = [];
				for(var key in result){
					ret3FinalResultsPickMap.push({key: key, value: result[key]});
				}
				component.set("v.ret3FinalResultsPickMap", ret3FinalResultsPickMap);
			}
		});
		$A.enqueueAction(action);
	},
	getret4FirstOfferPicklist: function(component, event) {
		var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Ret4_FirstOffer__c'
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {                
				var result = response.getReturnValue();
				var ret4FirstOfferPickMap = [];
				for(var key in result){
					ret4FirstOfferPickMap.push({key: key, value: result[key]});
				}
				component.set("v.ret4FirstOfferPickMap", ret4FirstOfferPickMap);
			}
		});
		$A.enqueueAction(action);
	},
	getret4FinalResultsPicklist: function(component, event) {
		var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Ret4_FinalResults__c'
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {                
				var result = response.getReturnValue();
				var ret4FinalResultsPickMap = [];
				for(var key in result){
					ret4FinalResultsPickMap.push({key: key, value: result[key]});
				}
				component.set("v.ret4FinalResultsPickMap", ret4FinalResultsPickMap);
			}
		});
		$A.enqueueAction(action);
	},
	getret5FirstOfferPicklist: function(component, event) {
		var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Ret5_FirstOffer__c'
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {                
				var result = response.getReturnValue();
				var ret5FirstOfferPickMap = [];
				for(var key in result){
					ret5FirstOfferPickMap.push({key: key, value: result[key]});
				}
				component.set("v.ret5FirstOfferPickMap", ret5FirstOfferPickMap);
			}
		});
		$A.enqueueAction(action);
	},
	getret5FinalResultsPicklist: function(component, event) {
		var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Ret5_FinalResults__c'
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {                
				var result = response.getReturnValue();
				var ret5FinalResultsPickMap = [];
				for(var key in result){
					ret5FinalResultsPickMap.push({key: key, value: result[key]});
				}
				component.set("v.ret5FinalResultsPickMap", ret5FinalResultsPickMap);
			}
		});
		$A.enqueueAction(action);
	},
	getret6FirstOfferPicklist: function(component, event) {
		var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Ret6_FirstOffer__c'
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {                
				var result = response.getReturnValue();
				var ret6FirstOfferPickMap = [];
				for(var key in result){
					ret6FirstOfferPickMap.push({key: key, value: result[key]});
				}
				component.set("v.ret6FirstOfferPickMap", ret6FirstOfferPickMap);
			}
		});
		$A.enqueueAction(action);
	},
	getret6FinalResultsPicklist: function(component, event) {
		var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Ret6_FinalResults__c'
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {                
				var result = response.getReturnValue();
				var ret6FinalResultsPickMap = [];
				for(var key in result){
					ret6FinalResultsPickMap.push({key: key, value: result[key]});
				}
				component.set("v.ret6FinalResultsPickMap", ret6FinalResultsPickMap);
			}
		});
		$A.enqueueAction(action);
	},
	getret7FirstOfferPicklist: function(component, event) {
		var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Ret7_FirstOffer__c'
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {                
				var result = response.getReturnValue();
				var ret7FirstOfferPickMap = [];
				for(var key in result){
					ret7FirstOfferPickMap.push({key: key, value: result[key]});
				}
				component.set("v.ret7FirstOfferPickMap", ret7FirstOfferPickMap);
			}
		});
		$A.enqueueAction(action);
	},
	getret7FinalResultsPicklist: function(component, event) {
		var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Ret7_FinalResults__c'
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {                
				var result = response.getReturnValue();
				var ret7FinalResultsPickMap = [];
				for(var key in result){
					ret7FinalResultsPickMap.push({key: key, value: result[key]});
				}
				component.set("v.ret7FinalResultsPickMap", ret7FinalResultsPickMap);
			}
		});
		$A.enqueueAction(action);
	},
	getret8FirstOfferPicklist: function(component, event) {
		var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Ret8_FirstOffer__c'
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {                
				var result = response.getReturnValue();
				var ret8FirstOfferPickMap = [];
				for(var key in result){
					ret8FirstOfferPickMap.push({key: key, value: result[key]});
				}
				component.set("v.ret8FirstOfferPickMap", ret8FirstOfferPickMap);
			}
		});
		$A.enqueueAction(action);
	},
	getret8FinalResultsPicklist: function(component, event) {
		var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Ret8_FinalResults__c'
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {                
				var result = response.getReturnValue();
				var ret8FinalResultsPickMap = [];
				for(var key in result){
					ret8FinalResultsPickMap.push({key: key, value: result[key]});
				}
				component.set("v.ret8FinalResultsPickMap", ret8FinalResultsPickMap);
			}
		});
		$A.enqueueAction(action);
	},
	getret9FirstOfferPicklist: function(component, event) {
		var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Ret9_FirstOffer__c'
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {                
				var result = response.getReturnValue();
				var ret9FirstOfferPickMap = [];
				for(var key in result){
					ret9FirstOfferPickMap.push({key: key, value: result[key]});
				}
				component.set("v.ret9FirstOfferPickMap", ret9FirstOfferPickMap);
			}
		});
		$A.enqueueAction(action);
	},
	getret9FinalResultsPicklist: function(component, event) {
		var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Ret9_FinalResults__c'
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {                
				var result = response.getReturnValue();
				var ret9FinalResultsPickMap = [];
				for(var key in result){
					ret9FinalResultsPickMap.push({key: key, value: result[key]});
				}
				component.set("v.ret9FinalResultsPickMap", ret9FinalResultsPickMap);
			}
		});
		$A.enqueueAction(action);
	},
	getret10FirstOfferPicklist: function(component, event) {
		var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Ret10_FirstOffer__c'
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {                
				var result = response.getReturnValue();
				var ret10FirstOfferPickMap = [];
				for(var key in result){
					ret10FirstOfferPickMap.push({key: key, value: result[key]});
				}
				component.set("v.ret10FirstOfferPickMap", ret10FirstOfferPickMap);
			}
		});
		$A.enqueueAction(action);
	},
	getret10FinalResultsPicklist: function(component, event) {
		var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Ret10_FinalResults__c'
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {                
				var result = response.getReturnValue();
				var ret10FinalResultsPickMap = [];
				for(var key in result){
					ret10FinalResultsPickMap.push({key: key, value: result[key]});
				}
				component.set("v.ret10FinalResultsPickMap", ret10FinalResultsPickMap);
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