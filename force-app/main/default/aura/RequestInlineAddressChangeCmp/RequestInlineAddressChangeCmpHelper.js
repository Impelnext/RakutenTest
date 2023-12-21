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
	getJuniorSpecialContractPicklist : function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'JuniorSpecialContract__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var juniorSpecialContractPickMap = [];
                for(var key in result){
                    juniorSpecialContractPickMap.push({key: key, value: result[key]});
                }
                component.set("v.juniorSpecialContractPickMap", juniorSpecialContractPickMap);
                component.find("specialContract").set("v.value","無");
            }
            else if(state === "ERROR"){
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
    getAgencyChangePicklist : function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'ChangeAgencyRegistration__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var agencyChangePickMap = [];
                for(var key in result){
                    agencyChangePickMap.push({key: key, value: result[key]});
                }
                component.set("v.agencyChangePickMap", agencyChangePickMap);
                component.find("agencyChange").set("v.value","無");
            }
            else if(state === "ERROR"){
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
    getRegistrationChangePicklist : function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'AGRegistrationChange__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var registrationChangePickMap = [];
                for(var key in result){
                    registrationChangePickMap.push({key: key, value: result[key]});
                }
                component.set("v.registrationChangePickMap", registrationChangePickMap);
                component.find("registrationChange").set("v.value","無");
            }
            else if(state === "ERROR"){
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
    getRecruiterRegistrationPicklist : function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'RecruiterRegistration__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var recruiterRegPickMap = [];
                for(var key in result){
                    recruiterRegPickMap.push({key: key, value: result[key]});
                }
                component.set("v.recruiterRegPickMap", recruiterRegPickMap);
                component.find("recruiterReg").set("v.value","無");
            }
            else if(state === "ERROR"){
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
    getProcessingPickList: function(component, event,dependantSubject) {
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'Processing__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.subDepnedentProcessingFieldMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.subDepnedentProcessingFieldMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.processingPicklist");    
                }   
            }
            else if(subDepResponse.getState()  === "ERROR"){
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