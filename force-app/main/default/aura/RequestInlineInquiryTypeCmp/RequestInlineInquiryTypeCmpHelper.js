({
	getRequestTypPickListValues : function(component, event,dependantSubject) {
		var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'RequestType__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() == "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.subDependingInquiryTypFieldMap",depSubResponse);
                var dependentFieldSubInqTypMap = component.get("v.subDependingInquiryTypFieldMap");
                var ListOfDependentFieldsInqTyp = dependentFieldSubInqTypMap[dependantSubject];
                if(ListOfDependentFieldsInqTyp.length > 0){
                    this.fetchDepValuesForSub(component, ListOfDependentFieldsInqTyp,"v.InquiryTypePLValues");    
                }   
            }
            else if(subDepResponse.getState()  == "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }else if (subDepResponse.getState()  === "INCOMPLETE") {
                alert('サーバーからレスポンスがありません');
            }
        });
        $A.enqueueAction(subDepAction);	
	},
    
    fetchDepValuesForSub: function(component, ListOfDependentFields,listSubDependingValues) {
        
        // Empty array var for store dependent picklist values 
        var dependentFields = [];
        
        dependentFields.push('--- None ---');
        
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set(listSubDependingValues, dependentFields);
    },
    createDynamicComponent:function(component,dynamicCmpName,attribute,responseName){
         console.log("Entering Dynamic cmp creation");
        var db=component.find("childCmp");
        $A.createComponent(dynamicCmpName,attribute,function(responseName,status, errorMessage){
            if (status === "SUCCESS") {  
                var body = component.get("v.body");
                body.push([]);
                body.push(responseName);
                console.log("BodyResponse"+responseName);
                component.set("v.body", body);
            }else{
                alert('ErrorMessage ' + errorMessage);
            }
        });
    }
})