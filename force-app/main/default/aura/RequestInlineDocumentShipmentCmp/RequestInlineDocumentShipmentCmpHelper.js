({
	getSinglePickListvaues : function(component,event,PickLists,PickListVal,addressInfoWrapper) {
        
	 var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : PickListVal
		});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                console.log("PicklistResponse"+JSON.stringify(result));
                // create a empty array for store map keys(@@--->which is RequestContent picklist values) 
                var listOfkeys = [];// for store all map keys (RequestContent picklist values)
                var PickListFields = [];// for store RequestContent picklist value to set on lightning:select. 
                
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in result) {
                    listOfkeys.push(singlekey);
                }
                
                //set the PickListFields field value for lightning:select
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    PickListFields.push('--- None ---');
                }
                
                for (var j = 0;j < listOfkeys.length;j++) {
                    PickListFields.push(listOfkeys[j]);
                }
 
                // set the PickListFields variable values (controller picklist field)
               if(PickLists[0] ==PickListVal){
                    const indexOfAccount = PickListFields.indexOf('取引先から引用')
                   	if($A.util.isEmpty(addressInfoWrapper.reception.Account__r)){
                       if (indexOfAccount > -1) {
                           PickListFields.splice(indexOfAccount, 1);
                       }
                   }
                   const indexOfMaster = PickListFields.indexOf('申出人から引用');
                   if($A.util.isEmpty(addressInfoWrapper.reception.SeihoAgent__r) && $A.util.isEmpty(addressInfoWrapper.reception.SeihoRecruiter__r)) {
                       if (indexOfMaster > -1) {
                           PickListFields.splice(indexOfMaster, 1);
                       }
                   }
                component.set("v.shippingInputPLValues", PickListFields);
                                            
                }
                else if(PickLists[1]==PickListVal){
                component.set("v.dateOfShipmentPLValues", PickListFields);
                }
                 else if(PickLists[2]==PickListVal){
                component.set("v.shipmentMethodPLValues", PickListFields);
                }
               
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
    ReportGroupPickListValues : function(component, event,dependantSubject) {
		var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'ReportGroup__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() == "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.subReportGroupFieldMap",depSubResponse);
                var dependentFieldReportGroupMap = component.get("v.subReportGroupFieldMap");
                var ListOfDependentFieldsReportGroup = dependentFieldReportGroupMap[dependantSubject];
                if(ListOfDependentFieldsReportGroup.length > 0){
                    this.fetchDepValuesForSub(component, ListOfDependentFieldsReportGroup,"v.reportGroupPLValues");    
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
    
    ReportPickListValues : function(component, event,dependantReportGroup) {
		var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'ReportGroup__c',
            depfieldApiName : 'report_agency__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() == "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.reportFieldMap",depSubResponse);
                var dependentFieldReportMap = component.get("v.reportFieldMap");
                var ListOfDependentFieldsReport = dependentFieldReportMap[dependantReportGroup];
                if(ListOfDependentFieldsReport.length > 0){
                    this.fetchDepValuesForReport(component, ListOfDependentFieldsReport,"v.reportPLValues");    
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
    fetchDepValuesForReport: function(component, ListOfDependentFields,listSubDependingValues) {
        
        // Empty array var for store dependent picklist values 
        var dependentFields = [];
                
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push({
                label: ListOfDependentFields[i],
                value: ListOfDependentFields[i]
            });
        }
        
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set(listSubDependingValues, dependentFields);
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
    areaInfo : function(component,event){
        var receivedPostal = event.getSource().get('v.value');      
        var action = component.get('c.getAreaInfo');
        action.setParams({
            postalCode : receivedPostal
        });
        action.setCallback(this,function(response){
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {                 
                component.set('v.getAreaInfoMap',response.getReturnValue());
            }
            var areaInfo = JSON.parse(JSON.stringify(component.get("v.getAreaInfoMap")));
            console.log("areaInfo"+JSON.stringify(areaInfo));
                if (areaInfo!=''){
                  component.set("v.innerCmpNewRequest.Prefectures__c",areaInfo.prefecture);
                  component.set("v.innerCmpNewRequest.Address1__c",areaInfo.chome);
                  component.set("v.innerCmpNewRequest.City__c",areaInfo.municipality); 
                }
            component.set("v.innerCmpNewRequest.Address2__c",'');
        });  
        $A.enqueueAction(action);        
    },
    
    //Setting the Address section
    setAddress : function(component,event,addressInfoWrapper){
        var setAccountAddress = function(){
            if(!$A.util.isEmpty(addressInfoWrapper.reception.Account__r.PersonMailingAddress)){
                var addressFieldSet = JSON.parse(JSON.stringify(addressInfoWrapper.reception.Account__r.PersonMailingAddress));
                component.set("v.innerCmpNewRequest.Prefectures__c",addressInfoWrapper.reception.Account__r.PersonMailingAddress.state);
                component.set("v.innerCmpNewRequest.Address1__c",addressInfoWrapper.reception.Account__r.PersonMailingAddress.street);
                component.set("v.innerCmpNewRequest.Address2__c",'');
                component.set("v.innerCmpNewRequest.City__c",addressInfoWrapper.reception.Account__r.PersonMailingAddress.city); 
                component.set("v.innerCmpNewRequest.DestinationAddress__c",addressInfoWrapper.reception.Account__r.Name);
                component.set("v.innerCmpNewRequest.Postalcode__c",addressInfoWrapper.reception.Account__r.PersonMailingAddress.postalCode);
                    
            }
        };
        var setMasterAddress = function() {
            if(!$A.util.isEmpty(addressInfoWrapper.reception.SeihoRecruiter__c)){
    
                if(!$A.util.isEmpty(addressInfoWrapper.reception.SeihoRecruiter__r.SeihoAgencyMasterName__r)){
                   
                    component.set("v.innerCmpNewRequest.Prefectures__c",addressInfoWrapper.reception.SeihoRecruiter__r.SeihoAgencyMasterName__r.DestinationPrefccdName__c);
                    component.set("v.innerCmpNewRequest.Postalcode__c",addressInfoWrapper.reception.SeihoRecruiter__r.SeihoAgencyMasterName__r.mssgbyndzip__c);
                    component.set("v.innerCmpNewRequest.City__c",addressInfoWrapper.reception.SeihoRecruiter__r.SeihoAgencyMasterName__r.mssgbyndcityarea__c); 
                    component.set("v.innerCmpNewRequest.Address1__c",addressInfoWrapper.reception.SeihoRecruiter__r.SeihoAgencyMasterName__r.mssgbyndaddr1__c);
                    var address2 = (addressInfoWrapper.reception.SeihoRecruiter__r.SeihoAgencyMasterName__r.mssgbyndaddr2__c)?addressInfoWrapper.reception.SeihoRecruiter__r.SeihoAgencyMasterName__r.mssgbyndaddr2__c : '';
                    var address3 = (addressInfoWrapper.reception.SeihoRecruiter__r.SeihoAgencyMasterName__r.msgsbyndaddr3__c)?addressInfoWrapper.reception.SeihoRecruiter__r.SeihoAgencyMasterName__r.msgsbyndaddr3__c : '';
                    component.set("v.innerCmpNewRequest.Address2__c",address2+address3);
                    component.set("v.innerCmpNewRequest.DestinationAddress__c",addressInfoWrapper.reception.SeihoRecruiter__r.SeihoAgencyMasterName__r.agncynmkj__c);
                }
                
            }
            else if(!$A.util.isEmpty(addressInfoWrapper.reception.SeihoAgent__r)){
                    
                    if(component.get("v.innerCmpNewRequest.ShippingInput__c")!='申出人から引用'){
                        component.set("v.innerCmpNewRequest.ShippingInput__c",'申出人から引用');
                        window.setTimeout(
                            $A.getCallback(function() {
                                component.set("v.selectVal",'申出人から引用');
                            }), 5
                        );
                    }
                component.set("v.innerCmpNewRequest.Prefectures__c",addressInfoWrapper.reception.SeihoAgent__r.AGENT_REGION_DISPLAY__c);
                component.set("v.innerCmpNewRequest.Address1__c",addressInfoWrapper.reception.SeihoAgent__r.AGENT_ADDRESS1__c);
                component.set("v.innerCmpNewRequest.City__c",addressInfoWrapper.reception.SeihoAgent__r.AGENT_CITY__c); 
                component.set("v.innerCmpNewRequest.Address2__c",addressInfoWrapper.reception.SeihoAgent__r.AGENT_ADDRESS2__c);
                component.set("v.innerCmpNewRequest.Postalcode__c",addressInfoWrapper.reception.SeihoAgent__r.AGENT_POST_CODE__c);
                component.set("v.innerCmpNewRequest.DestinationAddress__c",addressInfoWrapper.reception.SeihoAgent__r.Name);
            }
        };
    
        if(component.get("v.innerCmpNewRequest.ShippingInput__c")=="申出人から引用") {
            setMasterAddress();
        } else if(component.get("v.innerCmpNewRequest.ShippingInput__c")=="取引先から引用") {
            setAccountAddress();
        } else {
            if(!$A.util.isEmpty(addressInfoWrapper.reception.Account__r)){ 
            
                if(component.get("v.innerCmpNewRequest.ShippingInput__c")!='取引先から引用'){
                    component.set("v.innerCmpNewRequest.ShippingInput__c",'取引先から引用');
                       window.setTimeout(
                        $A.getCallback(function() {
                            component.set("v.selectVal",'取引先から引用');
                        }), 5
                    );
                    setAccountAddress();
                }
            } else if(component.get("v.innerCmpNewRequest.ShippingInput__c")!='申出人から引用'){
                component.set("v.innerCmpNewRequest.ShippingInput__c",'申出人から引用');
                window.setTimeout(
                    $A.getCallback(function() {
                        component.set("v.selectVal",'申出人から引用');
                    }), 5
                );
                setMasterAddress();
            }
        }
    }



})