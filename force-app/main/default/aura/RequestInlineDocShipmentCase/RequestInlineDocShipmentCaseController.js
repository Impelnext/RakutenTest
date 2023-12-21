({
    saveInlineDocumentshippingcase : function(cmp, event) {
        var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;       
        obj.ReportGroup__c = cmp.get("v.innerCmpNewRequest").ReportGroup__c;
        obj.report_agency__c = cmp.get("v.innerCmpNewRequest").report_agency__c;
        obj.Remarks__c = cmp.get("v.innerCmpNewRequest").Remarks__c;
        obj.NumberOfCopies__c = cmp.get("v.innerCmpNewRequest").NumberOfCopies__c; 
        obj.DateOfShipment__c = cmp.get("v.innerCmpNewRequest").DateOfShipment__c;
        obj.ShippingMethod__c = cmp.get("v.innerCmpNewRequest").ShippingMethod__c;  		
        obj.ShippingInput__c = cmp.get("v.innerCmpNewRequest").ShippingInput__c;  		
        obj.DestinationAddress__c = cmp.get("v.innerCmpNewRequest").DestinationAddress__c;
        obj.Postalcode__c = cmp.get("v.innerCmpNewRequest").Postalcode__c;
        obj.Prefectures__c = cmp.get("v.innerCmpNewRequest").Prefectures__c;
        obj.City__c = cmp.get("v.innerCmpNewRequest").City__c;
        obj.Address1__c = cmp.get("v.innerCmpNewRequest").Address1__c;
        obj.Address2__c = cmp.get("v.innerCmpNewRequest").Address2__c;
    },    
    init : function(component,event,helper){
		helper.getDateOfShipmentPicklist(component, event);
		helper.getShippingMethodPicklist(component, event);
        helper.fetchPicklistValues(component,"Request__c","Subject__c", "ReportGroup__c");
        helper.fetchPicklistValues(component,"Request__c","ReportGroup__c", "report_agency__c");

        var addressInfoWrapper = JSON.parse(JSON.stringify(component.get("v.recContractWrapper")));        
        //Fetching single pick list values
	    helper.getShippingInputPickList(component,event,'ShippingInput__c',addressInfoWrapper);
        helper.setAddress(component,event,addressInfoWrapper);
        
    },
    handleAreaInfo : function(component,event,helper){
        if(component.find("ShippingInput").get("v.value") == "手動入力"){
            helper.areaInfo(component, event);
		}
    },
    onChangeShippingInp : function(component, event, helper){
        var selection = event.getSource().get("v.value");
         
         if(selection=="手動入力"||selection=="--- None ---"){
           component.find("Prefectures").set("v.disabled",false);
           component.find("Address1").set("v.disabled",false);
           component.find("Address2").set("v.disabled",false);
           component.find("City").set("v.disabled",false);
           component.find("DestinationAddress").set("v.disabled",false);
           component.find("PostalCode").set("v.disabled",false);
           component.set("v.innerCmpNewRequest.Prefectures__c",'');
           component.set("v.innerCmpNewRequest.Address1__c",'');
           component.set("v.innerCmpNewRequest.City__c",''); 
           component.set("v.innerCmpNewRequest.Address2__c",'');
           component.set("v.innerCmpNewRequest.Postalcode__c",'');
           component.set("v.innerCmpNewRequest.DestinationAddress__c",'');
             
         }else{
            var addressInfoWrapper = JSON.parse(JSON.stringify(component.get("v.recContractWrapper")));
             
            //Setting Address values from Account or Master
            helper.setAddress(component,event,addressInfoWrapper);
            component.find("Prefectures").set("v.disabled",true);
            component.find("Address1").set("v.disabled",true);
            component.find("Address2").set("v.disabled",true);
            component.find("City").set("v.disabled",true);
            component.find("PostalCode").set("v.disabled",true);
            component.find("DestinationAddress").set("v.disabled",true);
         }
     
     },
     onControllerFieldChange: function(component, event, helper) {     
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        if (controllerValueKey != '--- None ---') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields,"ReportGroupDependant");    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", ['--- None ---']);
            }  
            
        } else {
            component.set("v.listDependingValues", ['--- None ---']);
            component.set("v.bDisabledDependentFld" , true);
        }
    }
})