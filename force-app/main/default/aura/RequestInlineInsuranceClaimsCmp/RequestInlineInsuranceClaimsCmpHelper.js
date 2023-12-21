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
                    component.set("v.innerCmpNewRequest.MailingPrefectures__c", component.get("v.getAreaInfoMap").prefecture);
                }
                if(component.get("v.getAreaInfoMap").municipality != ''){  
                    component.set("v.innerCmpNewRequest.MailingCity__c", component.get("v.getAreaInfoMap").municipality);
                }      
                if(component.get("v.getAreaInfoMap").chome != ''){
                    component.set("v.innerCmpNewRequest.MailingAddress1__c", component.get("v.getAreaInfoMap").chome);
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

    getpaperlessDocumentPickList: function(component, event) {
        var action = component.get("c.getMultiPiklistValues");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'PaperlessDocument__c'
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
                component.set("v.paperlessDocumentPickList", plValues);
            }
        });
        $A.enqueueAction(action);
    },
	getbillingClassificationPickList: function(component, event) {
        var action = component.get("c.getMultiPiklistValues");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'BillingClassification__c'
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
                component.set("v.billingClassificationPickList", plValues);
            }
        });
        $A.enqueueAction(action);
    },
	
	getpresenceeOfDocumentIncludedPick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'PresenceeOfDocumentIncluded__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfCompanyPickMap = [];
                for(var key in result){
                    causeOfCompanyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.presenceeOfDocumentIncludedPickMap", causeOfCompanyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getsendingMethodPick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'SendingMethod__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfCompanyPickMap = [];
                for(var key in result){
                    causeOfCompanyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.sendingMethodPickMap", causeOfCompanyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getdestinationCategoryPick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'DestinationCategory__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfCompanyPickMap = [];
                for(var key in result){
                    causeOfCompanyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.destinationCategoryPickMap", causeOfCompanyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getcorrespondenceRequestPick: function(component, event,dependantSubject) {
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'CorrespondenceRequest__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.correspondenceRequestPickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.correspondenceRequestPickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.correspondenceRequestPickList");    
                }   
            }         
        });
        $A.enqueueAction(subDepAction);
},
	getparentalAuthorityConfirmationPick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'ParentalAuthorityConfirmation__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfCompanyPickMap = [];
                for(var key in result){
                    causeOfCompanyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.parentalAuthorityConfirmationPickMap", causeOfCompanyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getparentsLivingTogetherAndSeparatedPick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'ParentsLivingTogetherAndSeparated__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfCompanyPickMap = [];
                for(var key in result){
                    causeOfCompanyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.parentsLivingTogetherAndSeparatedPickMap", causeOfCompanyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	
	gettransferDesignatedAccountPick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'TransferDesignatedAccount__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfCompanyPickMap = [];
                for(var key in result){
                    causeOfCompanyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.transferDesignatedAccountPickMap", causeOfCompanyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getdepositCategoryPick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'DepositCategory__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfCompanyPickMap = [];
                for(var key in result){
                    causeOfCompanyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.depositCategoryPickMap", causeOfCompanyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getcancerMedicalAnnouncementPick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'CancerMedicalAnnouncement__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfCompanyPickMap = [];
                for(var key in result){
                    causeOfCompanyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.cancerMedicalAnnouncementPickMap", causeOfCompanyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	gethospitalizationDay2Pick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'HospitalizationDay2__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfCompanyPickMap = [];
                for(var key in result){
                    causeOfCompanyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.hospitalizationDay2PickMap", causeOfCompanyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getsurgeryPick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Surgery__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfCompanyPickMap = [];
                for(var key in result){
                    causeOfCompanyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.surgeryPickMap", causeOfCompanyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getdisasterCausePick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'DisasterCause__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfCompanyPickMap = [];
                for(var key in result){
                    causeOfCompanyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.disasterCausePickMap", causeOfCompanyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getreportToPolicePick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'ReportToPolice__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfCompanyPickMap = [];
                for(var key in result){
                    causeOfCompanyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.reportToPolicePickMap", causeOfCompanyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getoccurrenceStatusPick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'OccurrenceStatus__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfCompanyPickMap = [];
                for(var key in result){
                    causeOfCompanyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.occurrenceStatusPickMap", causeOfCompanyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getspecificDamagePick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'SpecificDamage__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfCompanyPickMap = [];
                for(var key in result){
                    causeOfCompanyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.specificDamagePickMap", causeOfCompanyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getcauseOfDeathPick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'CauseOfDeath__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfCompanyPickMap = [];
                for(var key in result){
                    causeOfCompanyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.causeOfDeathPickMap", causeOfCompanyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getpresenceOrAbsenceOfDeathCertificatePick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'PresenceOrAbsenceOfDeathCertificate__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfCompanyPickMap = [];
                for(var key in result){
                    causeOfCompanyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.presenceOrAbsenceOfDeathCertificatePickMap", causeOfCompanyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getlifeInsuranceMutualAidPick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'LifeInsuranceMutualAid__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfCompanyPickMap = [];
                for(var key in result){
                    causeOfCompanyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.lifeInsuranceMutualAidPickMap", causeOfCompanyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getheirPick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Heir__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfCompanyPickMap = [];
                for(var key in result){
                    causeOfCompanyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.heirPickMap", causeOfCompanyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getfixedSymptomsPick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'FixedSymptoms__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfCompanyPickMap = [];
                for(var key in result){
                    causeOfCompanyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.fixedSymptomsPickMap", causeOfCompanyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getoutOfBillingChargePick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'OutOfBillingCharge__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfCompanyPickMap = [];
                for(var key in result){
                    causeOfCompanyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.outOfBillingChargePickMap", causeOfCompanyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
    getanticancerDrugTreatmentPick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'AnticancerDrugTreatment__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var anticancerDrugTreatmentPickMap = [];
                for(var key in result){
                    anticancerDrugTreatmentPickMap.push({key: key, value: result[key]});
                }
                component.set("v.anticancerDrugTreatmentPickMap", anticancerDrugTreatmentPickMap);
            }
        });
        $A.enqueueAction(action);
    },
    gethormonalTreatmentPick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'HormonalTreatment__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var hormonalTreatmentPickMap = [];
                for(var key in result){
                    hormonalTreatmentPickMap.push({key: key, value: result[key]});
                }
                component.set("v.hormonalTreatmentPickMap", hormonalTreatmentPickMap);
            }
        });
        $A.enqueueAction(action);
    },
    getradiotherapyPick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Radiotherapy__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var radiotherapyPickMap = [];
                for(var key in result){
                    radiotherapyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.radiotherapyPickMap", radiotherapyPickMap);
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
    
    fetchPicklistValues: function(component,objDetails,controllerField, dependentField) {
       
        var action = component.get("c.getDependentMap");
        action.setParams({
            'objDetail' : objDetails,
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField 
        });
       
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
               var StoreResponse = response.getReturnValue();
                component.set("v.depnedentFieldMap",StoreResponse);
                var listOfkeys = []; 
                var ControllerField = []; 
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push('--- None ---');
                }
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push(listOfkeys[i]);
                }  
                component.set("v.listControllingValues", ControllerField);
            }else{
                alert('Something went wrong..');
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchDepValues: function(component, ListOfDependentFields) {
       
        var dependentFields = [];
        dependentFields.push('--- None ---');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        
        component.set("v.listDependingValues", dependentFields);
        
    },
    
	handleTreatmentDays : function(cmp,event){
		cmp.set("v.treatmentDays", null);
		var admitDate = new Date(cmp.get("v.innerCmpNewRequest").HospitalizationDate__c);
		var DischargeDate = new Date(cmp.get("v.innerCmpNewRequest").DischargeDate__c);
		var treatmentDays;
		if(cmp.get("v.innerCmpNewRequest").HospitalizationDate__c != '' 
		&& cmp.get("v.innerCmpNewRequest").DischargeDate__c != '' 
		&& cmp.get("v.innerCmpNewRequest").HospitalizationDate__c != null 
		&& cmp.get("v.innerCmpNewRequest").DischargeDate__c != null) {
			treatmentDays = (DischargeDate-admitDate)/8.64e7;
			treatmentDays = treatmentDays+1;
			if(isNaN(treatmentDays) || treatmentDays <= 0){
				treatmentDays = '';
			}
			cmp.set("v.treatmentDays", treatmentDays);
		}
	}
})