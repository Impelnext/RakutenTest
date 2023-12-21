/**
 * @File Name          : RequestInlineDocumentshippingcaseCmpHelper.js
 * @Description        : 
 * @Author             : SRM
 * @Group              : 
 * @Last Modified By   : SRM
 * @Last Modified On   : 12/24/2019, 7:22:38 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    12/24/2019   SRM     Initial Version
**/
({
        getReportGroupPicklist : function(component, event,dependantSubject) {
	    	var action = component.get("c.getDependentMap");
            action.setParams({
                objDetail : 'Request__c',
                contrfieldApiName : 'Subject__c',
                depfieldApiName : 'ReportGroup__c'
            });
            action.setCallback(this, function(response){   
                if(response.getState() == "SUCCESS"){
                    var responseValue = response.getReturnValue();
                    component.set("v.subReportGroupFieldMap",responseValue);
                    var dependentFieldReportGroupMap = component.get("v.subReportGroupFieldMap");
                    var result = dependentFieldReportGroupMap[dependantSubject];
                    var reportGroupPickMap = [];
                    for(var key in result){
                        reportGroupPickMap.push({key: key, value: key});
                    }
                    component.set("v.reportGroupPickMap", reportGroupPickMap);
                } else if(response.getState()  == "ERROR"){
                    var errors = action.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            alert(errors[0].message);
                        }
                    }
                }else if (response.getState()  === "INCOMPLETE") {
                    alert('サーバーからレスポンスがありません');
                }
            });
            $A.enqueueAction(action);	
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
    
/*    	getReportGroupPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'ReportGroup__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var reportGroupPickMap = [];
                for(var key in result){
                    reportGroupPickMap.push({key: key, value: result[key]});
                }
                component.set("v.reportGroupPickMap", reportGroupPickMap);
            }
        });
        $A.enqueueAction(action);
       },*/
	  /* getReportPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Report__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var reportPickMap = [];
                for(var key in result){
                    reportPickMap.push({key: key, value: result[key]});
                }
                component.set("v.reportPickMap", reportPickMap);
            }
        });
        $A.enqueueAction(action);
       },*/
       getReportPicklist: function(component, event) {
        var action = component.get("c.getMultiPiklistValues");
		action.setParams({
			objectName : 'Reception__c',
			fieldName : 'Report__c'
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
                var reportPickMap = [];
                for(var key in plValues){
                    reportPickMap.push({key: key, value: plValues[key]});
                }
                component.set("v.reportPickMap", reportPickMap);
            }
        });
        $A.enqueueAction(action);
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
     fetchPicklistValues: function(component,objDetails,controllerField, dependentField) {
        // call the server side function  
        var action = component.get("c.getDependentMap");
        // pass paramerters [object definition , contrller field name ,dependent field name] -
        // to server side function 
        action.setParams({
            'objDetail' : objDetails,
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField 
        });
        //set callback   
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var res=response.getReturnValue();
                var StoreResponse = {};
                var subMap = component.get("v.subReportGroupFieldMap");
                var subject=component.get("v.dependantSubject");
                var groupKey = subMap[subject];
                for( var key in res ) {
                    if( groupKey.indexOf(key) != -1 ) {
                        StoreResponse[key] = res[key];
                        continue;
                    }
                }

                // once set #StoreResponse to depnedentFieldMap attribute 
                component.set("v.depnedentFieldMap",StoreResponse);
                
                // create a empty array for store map keys(@@--->which is controller picklist values) 
                var listOfkeys = []; // for store all map keys (controller picklist values)
                var ControllerField = []; // for store controller picklist value to set on lightning:select. 
                
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                
                //set the controller field value for lightning:select
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
        // create a empty array var for store dependent picklist values for controller field  
        var dependentFields = [];
       // dependentFields.push('--- None ---');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            //dependentFields.push(ListOfDependentFields[i]);
            dependentFields.push({
                label: ListOfDependentFields[i],
                value: ListOfDependentFields[i]
            });
        }
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set("v.listDependingValues", dependentFields);
        
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