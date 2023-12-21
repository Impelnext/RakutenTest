({
    getChangesPickList: function(component, event,dependantSubject) {
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'Changes__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.changesPickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.changesPickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.changesPickList");    
                }   
            }         
        });
        $A.enqueueAction(subDepAction);
    },
	getDesignatedAccountPickList: function(component, event,dependantValue) {
		var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Changes__c',
            depfieldApiName : 'DesignatedAccount__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.designatedAccountPickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.designatedAccountPickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantValue];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.designatedAccountPickList");    
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