({
	getMyPageProposalPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'MyPageProposal__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var myPageProposalPickMap = [];
                for(var key in result){
                    myPageProposalPickMap.push({key: key, value: result[key]});
                }
                component.set("v.myPageProposalPickMap", myPageProposalPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getChangeHistoryPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'ChangeHistory__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var changeHistoryPickMap = [];
                for(var key in result){
                    changeHistoryPickMap.push({key: key, value: result[key]});
                }
                component.set("v.changeHistoryPickMap", changeHistoryPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getIssuePicklist: function(component, event,dependantSubject) {
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'Issue__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.issuePickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.issuePickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.issuePickList");    
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
	}
      
})