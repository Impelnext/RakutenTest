({
    saveInlineRequestChangedesignatedagent : function(cmp, event, helper) {
        var params = event.getParam('arguments');
        var obj = params.parentNewRequest;
		
		// Check all Number Input field once again before Save
        helper.getSingleByteNumberCheck(cmp,event,"v.numberOfCopies","v.noOfCopiesErr");

		var DesignatedAgentNamekana1 = cmp.get("v.DesignatedAgentNamekana1");
        var DesignatedAgentNamekana2 = cmp.get("v.DesignatedAgentNamekana2");
        var DesignatedAgentNamekana3 = cmp.get("v.DesignatedAgentNamekana3");
        var DesignatedAgentNamekana4 = cmp.get("v.DesignatedAgentNamekana4");
        var DesignatedAgentNamekana5 = cmp.get("v.DesignatedAgentNamekana5");
        var DesignatedAgentNamekana6 = cmp.get("v.DesignatedAgentNamekana6");
        var DesignatedAgentNamekana7 = cmp.get("v.DesignatedAgentNamekana7");
        var DesignatedAgentNamekana8 = cmp.get("v.DesignatedAgentNamekana8");
        var DesignatedAgentNamekana9 = cmp.get("v.DesignatedAgentNamekana9");
        var DesignatedAgentNamekana10 = cmp.get("v.DesignatedAgentNamekana10");
        var DesignatedAgentNamekanji1 = cmp.get("v.DesignatedAgentNamekanji1");
        var DesignatedAgentNamekanji2 = cmp.get("v.DesignatedAgentNamekanji2");
        var DesignatedAgentNamekanji3 = cmp.get("v.DesignatedAgentNamekanji3");
        var DesignatedAgentNamekanji4 = cmp.get("v.DesignatedAgentNamekanji4");
        var DesignatedAgentNamekanji5 = cmp.get("v.DesignatedAgentNamekanji5");
        var DesignatedAgentNamekanji6 = cmp.get("v.DesignatedAgentNamekanji6");
        var DesignatedAgentNamekanji7 = cmp.get("v.DesignatedAgentNamekanji7");
        var DesignatedAgentNamekanji8 = cmp.get("v.DesignatedAgentNamekanji8");
        var DesignatedAgentNamekanji9 = cmp.get("v.DesignatedAgentNamekanji9");
        var DesignatedAgentNamekanji10 = cmp.get("v.DesignatedAgentNamekanji10");
	    var DesignatedDob1 = cmp.get("v.DesignatedDob1");
        var DesignatedDob2 = cmp.get("v.DesignatedDob2");
        var DesignatedDob3 = cmp.get("v.DesignatedDob3");
        var DesignatedDob4 = cmp.get("v.DesignatedDob4");
        var DesignatedDob5 = cmp.get("v.DesignatedDob5");
        var DesignatedDob6 = cmp.get("v.DesignatedDob6");
        var DesignatedDob7 = cmp.get("v.DesignatedDob7");
        var DesignatedDob8 = cmp.get("v.DesignatedDob8");
        var DesignatedDob9 = cmp.get("v.DesignatedDob9");
        var DesignatedDob10 = cmp.get("v.DesignatedDob10");
		
        var bHasError = false;
        obj.PolicyNumber1__c = cmp.get("v.innerCmpNewRequest").PolicyNumber1__c;
        if(obj.PolicyNumber1__c != ''){
            if (cmp.get("v.newDesignatedAgentNamekana1") == '' || 
            	cmp.get("v.newDesignatedAgentNamekanji1") == '' || 
            	cmp.get("v.relationshipWithInsured1") == '' || 
				cmp.get("v.innerCmpNewRequest").ProcedureType1__c == ''){
            	
                cmp.set("v.PolicyNumberValidate1",true);
                if (!bHasError) {cmp.find("policyNumber1").focus(); bHasError = true; }
            }
            else {
            	
				obj.ProcedureType1__c = cmp.get("v.innerCmpNewRequest").ProcedureType1__c;
		    	obj.ChangeDetails1__c = "新指定代理人氏名（カナ）:" +cmp.get("v.newDesignatedAgentNamekana1")+"\n"+
						        "新指定代理氏名（漢字）:" +cmp.get("v.newDesignatedAgentNamekanji1")+"\n"+
						        "被保険者との続柄:" +cmp.get("v.relationshipWithInsured1")+ "\n"+
						        "その他詳細:" + cmp.get("v.otherDetails1")+ "\n"+
						        "新指定代理生年月日:" +cmp.get("v.newDesignatedDob1") ;
            }
        }
		else{
			obj.ChangeDetails1__c = "";
			obj.ProcedureType1__c = "";
		}
        
		obj.PolicyNumber2__c = cmp.get("v.innerCmpNewRequest").PolicyNumber2__c;
        if(obj.PolicyNumber2__c != ''){
            if (cmp.get("v.newDesignatedAgentNamekana2") == '' || 
            	cmp.get("v.newDesignatedAgentNamekanji2") == '' || 
            	cmp.get("v.relationshipWithInsured2") == '' || 
            	cmp.get("v.innerCmpNewRequest").ProcedureType2__c == ''){
            	
                cmp.set("v.PolicyNumberValidate2",true);
                if (!bHasError) {cmp.find("policyNumber2").focus(); bHasError = true; }
            }
            else {
            	
				obj.ProcedureType2__c = cmp.get("v.innerCmpNewRequest").ProcedureType2__c;
		    	obj.ChangeDetails2__c = "新指定代理人氏名（カナ）:" +cmp.get("v.newDesignatedAgentNamekana2")+"\n"+
						        "新指定代理氏名（漢字）:" +cmp.get("v.newDesignatedAgentNamekanji2")+"\n"+
						        "被保険者との続柄:" +cmp.get("v.relationshipWithInsured2")+ "\n"+
						        "その他詳細:" + cmp.get("v.otherDetails2")+ "\n"+
						        "新指定代理生年月日:" +cmp.get("v.newDesignatedDob2") ;
            }
        }
		else{
			obj.ChangeDetails2__c = "";
			obj.ProcedureType2__c = "";
		}
		
		obj.PolicyNumber3__c = cmp.get("v.innerCmpNewRequest").PolicyNumber3__c;
        if(obj.PolicyNumber3__c != ''){
            if (cmp.get("v.newDesignatedAgentNamekana3") == '' || 
            	cmp.get("v.newDesignatedAgentNamekanji3") == '' || 
            	cmp.get("v.relationshipWithInsured3") == '' || 
            	cmp.get("v.innerCmpNewRequest").ProcedureType3__c == ''){
            	
                cmp.set("v.PolicyNumberValidate3",true);
                if (!bHasError) {cmp.find("policyNumber3").focus(); bHasError = true; }
            }
            else {
            	
				obj.ProcedureType3__c = cmp.get("v.innerCmpNewRequest").ProcedureType3__c;
		    	obj.ChangeDetails3__c = "新指定代理人氏名（カナ）:" +cmp.get("v.newDesignatedAgentNamekana3")+"\n"+
						        "新指定代理氏名（漢字）:" +cmp.get("v.newDesignatedAgentNamekanji3")+"\n"+
						        "被保険者との続柄:" +cmp.get("v.relationshipWithInsured3")+ "\n"+
						        "その他詳細:" + cmp.get("v.otherDetails3")+ "\n"+
						        "新指定代理生年月日:" +cmp.get("v.newDesignatedDob3") ;
            }
        }
		else{
			obj.ChangeDetails3__c = "";
			obj.ProcedureType3__c = "";
		}
		
		obj.PolicyNumber4__c = cmp.get("v.innerCmpNewRequest").PolicyNumber4__c;
        if(obj.PolicyNumber4__c != ''){
            if (cmp.get("v.newDesignatedAgentNamekana4") == '' || 
            	cmp.get("v.newDesignatedAgentNamekanji4") == '' || 
            	cmp.get("v.relationshipWithInsured4") == '' || 
            	cmp.get("v.innerCmpNewRequest").ProcedureType4__c == ''){
            	
                cmp.set("v.PolicyNumberValidate4",true);
                if (!bHasError) {cmp.find("policyNumber4").focus(); bHasError = true; }
            }
            else {
            	
				obj.ProcedureType4__c = cmp.get("v.innerCmpNewRequest").ProcedureType4__c;
		    	obj.ChangeDetails4__c = "新指定代理人氏名（カナ）:" +cmp.get("v.newDesignatedAgentNamekana4")+"\n"+
						        "新指定代理氏名（漢字）:" +cmp.get("v.newDesignatedAgentNamekanji4")+"\n"+
						        "被保険者との続柄:" +cmp.get("v.relationshipWithInsured4")+ "\n"+
						        "その他詳細:" + cmp.get("v.otherDetails4")+ "\n"+
						        "新指定代理生年月日:" +cmp.get("v.newDesignatedDob4") ;
            }
        }
		else{
			obj.ChangeDetails4__c = "";
			obj.ProcedureType4__c = "";
		}
		
		obj.PolicyNumber5__c = cmp.get("v.innerCmpNewRequest").PolicyNumber5__c;
        if(obj.PolicyNumber5__c != ''){
            if (cmp.get("v.newDesignatedAgentNamekana5") == '' || 
            	cmp.get("v.newDesignatedAgentNamekanji5") == '' || 
            	cmp.get("v.relationshipWithInsured5") == '' || 
            	cmp.get("v.innerCmpNewRequest").ProcedureType5__c == ''){
            	
                cmp.set("v.PolicyNumberValidate5",true);
                if (!bHasError) {cmp.find("policyNumber5").focus(); bHasError = true; }
            }
            else {
            	
				obj.ProcedureType5__c = cmp.get("v.innerCmpNewRequest").ProcedureType5__c;
		    	obj.ChangeDetails5__c = "新指定代理人氏名（カナ）:" +cmp.get("v.newDesignatedAgentNamekana5")+"\n"+
						        "新指定代理氏名（漢字）:" +cmp.get("v.newDesignatedAgentNamekanji5")+"\n"+
						        "被保険者との続柄:" +cmp.get("v.relationshipWithInsured5")+ "\n"+
						        "その他詳細:" + cmp.get("v.otherDetails5")+ "\n"+
						        "新指定代理生年月日:" +cmp.get("v.newDesignatedDob5") ;
            }
        }
		else{
			obj.ChangeDetails5__c = "";
			obj.ProcedureType5__c = "";
		}
		
		obj.PolicyNumber6__c = cmp.get("v.innerCmpNewRequest").PolicyNumber6__c;
        if(obj.PolicyNumber6__c != ''){
            if (cmp.get("v.newDesignatedAgentNamekana6") == '' || 
            	cmp.get("v.newDesignatedAgentNamekanji6") == '' || 
            	cmp.get("v.relationshipWithInsured6") == '' || 
            	cmp.get("v.innerCmpNewRequest").ProcedureType6__c == ''){
            	
                cmp.set("v.PolicyNumberValidate6",true);
                if (!bHasError) {cmp.find("policyNumber6").focus(); bHasError = true; }
            }
            else {
            	
				obj.ProcedureType6__c = cmp.get("v.innerCmpNewRequest").ProcedureType6__c;
		    	obj.ChangeDetails6__c = "新指定代理人氏名（カナ）:" +cmp.get("v.newDesignatedAgentNamekana6")+"\n"+
						        "新指定代理氏名（漢字）:" +cmp.get("v.newDesignatedAgentNamekanji6")+"\n"+
						        "被保険者との続柄:" +cmp.get("v.relationshipWithInsured6")+ "\n"+
						        "その他詳細:" + cmp.get("v.otherDetails6")+ "\n"+
						        "新指定代理生年月日:" +cmp.get("v.newDesignatedDob6") ;
            }
        }
		else{
			obj.ChangeDetails6__c = "";
			obj.ProcedureType6__c = "";
		}
		
		obj.PolicyNumber7__c = cmp.get("v.innerCmpNewRequest").PolicyNumber7__c;
        if(obj.PolicyNumber7__c != ''){
            if (cmp.get("v.newDesignatedAgentNamekana7") == '' || 
            	cmp.get("v.newDesignatedAgentNamekanji7") == '' || 
            	cmp.get("v.relationshipWithInsured7") == '' || 
            	cmp.get("v.innerCmpNewRequest").ProcedureType7__c == ''){
            	
                cmp.set("v.PolicyNumberValidate7",true);
                if (!bHasError) {cmp.find("policyNumber7").focus(); bHasError = true; }
            }
            else {
            	
				obj.ProcedureType7__c = cmp.get("v.innerCmpNewRequest").ProcedureType7__c;
		    	obj.ChangeDetails7__c = "新指定代理人氏名（カナ）:" +cmp.get("v.newDesignatedAgentNamekana7")+"\n"+
						        "新指定代理氏名（漢字）:" +cmp.get("v.newDesignatedAgentNamekanji7")+"\n"+
						        "被保険者との続柄:" +cmp.get("v.relationshipWithInsured7")+ "\n"+
						        "その他詳細:" + cmp.get("v.otherDetails7")+ "\n"+
						        "新指定代理生年月日:" +cmp.get("v.newDesignatedDob7") ;
            }
        }
		else{
			obj.ChangeDetails7__c = "";
			obj.ProcedureType7__c = "";
		}
		
		obj.PolicyNumber8__c = cmp.get("v.innerCmpNewRequest").PolicyNumber8__c;
        if(obj.PolicyNumber8__c != ''){
            if (cmp.get("v.newDesignatedAgentNamekana8") == '' || 
            	cmp.get("v.newDesignatedAgentNamekanji8") == '' || 
            	cmp.get("v.relationshipWithInsured8") == '' || 
            	cmp.get("v.innerCmpNewRequest").ProcedureType8__c == ''){
            	
                cmp.set("v.PolicyNumberValidate8",true);
                if (!bHasError) {cmp.find("policyNumber8").focus(); bHasError = true; }
            }
            else {
            	
				obj.ProcedureType8__c = cmp.get("v.innerCmpNewRequest").ProcedureType8__c;
		    	obj.ChangeDetails8__c = "新指定代理人氏名（カナ）:" +cmp.get("v.newDesignatedAgentNamekana8")+"\n"+
						        "新指定代理氏名（漢字）:" +cmp.get("v.newDesignatedAgentNamekanji8")+"\n"+
						        "被保険者との続柄:" +cmp.get("v.relationshipWithInsured8")+ "\n"+
						        "その他詳細:" + cmp.get("v.otherDetails8")+ "\n"+
						        "新指定代理生年月日:" +cmp.get("v.newDesignatedDob8") ;
            }
        }
		else{
			obj.ChangeDetails8__c = "";
			obj.ProcedureType8__c = "";
		}
		
		obj.PolicyNumber9__c = cmp.get("v.innerCmpNewRequest").PolicyNumber9__c;
        if(obj.PolicyNumber9__c != ''){
            if (cmp.get("v.newDesignatedAgentNamekana9") == '' || 
            	cmp.get("v.newDesignatedAgentNamekanji9") == '' || 
            	cmp.get("v.relationshipWithInsured9") == '' || 
            	cmp.get("v.innerCmpNewRequest").ProcedureType9__c == ''){
            	
                cmp.set("v.PolicyNumberValidate9",true);
                if (!bHasError) {cmp.find("policyNumber9").focus(); bHasError = true; }
            }
            else {
            	
				obj.ProcedureType9__c = cmp.get("v.innerCmpNewRequest").ProcedureType9__c;
		    	obj.ChangeDetails9__c = "新指定代理人氏名（カナ）:" +cmp.get("v.newDesignatedAgentNamekana9")+"\n"+
						        "新指定代理氏名（漢字）:" +cmp.get("v.newDesignatedAgentNamekanji9")+"\n"+
						        "被保険者との続柄:" +cmp.get("v.relationshipWithInsured9")+ "\n"+
						        "その他詳細:" + cmp.get("v.otherDetails9")+ "\n"+
						        "新指定代理生年月日:" +cmp.get("v.newDesignatedDob9") ;
            }
        }
		else{
			obj.ChangeDetails9__c = "";
			obj.ProcedureType9__c = "";
		}
		
		obj.PolicyNumber10__c = cmp.get("v.innerCmpNewRequest").PolicyNumber10__c;
        if(obj.PolicyNumber10__c != ''){
            if (cmp.get("v.newDesignatedAgentNamekana10") == '' || 
            	cmp.get("v.newDesignatedAgentNamekanji10") == '' || 
            	cmp.get("v.relationshipWithInsured10") == '' || 
            	cmp.get("v.innerCmpNewRequest").ProcedureType10__c == ''){
            	
                cmp.set("v.PolicyNumberValidate10",true);
                if (!bHasError) {cmp.find("policyNumber10").focus(); bHasError = true; }
            }
            else {
            	
				obj.ProcedureType10__c = cmp.get("v.innerCmpNewRequest").ProcedureType10__c;
		    	obj.ChangeDetails10__c = "新指定代理人氏名（カナ）:" +cmp.get("v.newDesignatedAgentNamekana10")+"\n"+
						        "新指定代理氏名（漢字）:" +cmp.get("v.newDesignatedAgentNamekanji10")+"\n"+
						        "被保険者との続柄:" +cmp.get("v.relationshipWithInsured10")+ "\n"+
						        "その他詳細:" + cmp.get("v.otherDetails10")+ "\n"+
						        "新指定代理生年月日:" +cmp.get("v.newDesignatedDob10") ;
            }
        }
		else{
			obj.ChangeDetails10__c = "";
			obj.ProcedureType10__c = "";
		}
		
        obj.Processing__c = cmp.get("v.innerCmpNewRequest").Processing__c;
        obj.ShippingDocuments__c = cmp.get("v.innerCmpNewRequest").ShippingDocuments__c;
        //obj.NumberOfCopies__c = cmp.get("v.innerCmpNewRequest").NumberOfCopies__c;
        obj.DateOfShipment__c = cmp.get("v.innerCmpNewRequest").DateOfShipment__c; 
        obj.ShippingMethod__c = cmp.get("v.innerCmpNewRequest").ShippingMethod__c;
		
        
		if(cmp.get("v.relationshipWithInsured1") == "その他親族" && cmp.get("v.otherDetails1") == ''){
            cmp.set("v.RelationshipInsureValidate1",true);
            if (!bHasError) {cmp.find("relationshipWithInsured1").focus(); bHasError = true; }
        }
		if(cmp.get("v.relationshipWithInsured2") == "その他親族" && cmp.get("v.otherDetails2") == ''){
            cmp.set("v.RelationshipInsureValidate2",true);
            if (!bHasError) {cmp.find("relationshipWithInsured2").focus(); bHasError = true; }
        }
		if(cmp.get("v.relationshipWithInsured3") == "その他親族" && cmp.get("v.otherDetails3") == ''){
            cmp.set("v.RelationshipInsureValidate3",true);
            if (!bHasError) {cmp.find("relationshipWithInsured3").focus(); bHasError = true; }
        }
		if(cmp.get("v.relationshipWithInsured4") == "その他親族" && cmp.get("v.otherDetails4") == ''){
            cmp.set("v.RelationshipInsureValidate4",true);
            if (!bHasError) {cmp.find("relationshipWithInsured4").focus(); bHasError = true; }
        }
		if(cmp.get("v.relationshipWithInsured5") == "その他親族" && cmp.get("v.otherDetails5") == ''){
            cmp.set("v.RelationshipInsureValidate5",true);
            if (!bHasError) {cmp.find("relationshipWithInsured5").focus(); bHasError = true; }
        }
		if(cmp.get("v.relationshipWithInsured6") == "その他親族" && cmp.get("v.otherDetails6") == ''){
            cmp.set("v.RelationshipInsureValidate6",true);
            if (!bHasError) {cmp.find("relationshipWithInsured6").focus(); bHasError = true; }
        }
		if(cmp.get("v.relationshipWithInsured7") == "その他親族" && cmp.get("v.otherDetails7") == ''){
            cmp.set("v.RelationshipInsureValidate7",true);
            if (!bHasError) {cmp.find("relationshipWithInsured7").focus(); bHasError = true; }
        }
		if(cmp.get("v.relationshipWithInsured8") == "その他親族" && cmp.get("v.otherDetails8") == ''){
            cmp.set("v.RelationshipInsureValidate8",true);
            if (!bHasError) {cmp.find("relationshipWithInsured8").focus(); bHasError = true; }
        }
		if(cmp.get("v.relationshipWithInsured9") == "その他親族" && cmp.get("v.otherDetails9") == ''){
            cmp.set("v.RelationshipInsureValidate9",true);
            if (!bHasError) {cmp.find("relationshipWithInsured9").focus(); bHasError = true; }
        }
		if(cmp.get("v.relationshipWithInsured10") == "その他親族" && cmp.get("v.otherDetails10") == ''){
            cmp.set("v.RelationshipInsureValidate10",true);
            if (!bHasError) {cmp.find("relationshipWithInsured10").focus(); bHasError = true; }
        }
		
		var numberOfCopies = cmp.get("v.numberOfCopies") == null ? "" : cmp.get("v.numberOfCopies");
		var noOfCopiesErr = cmp.get("v.noOfCopiesErr");
        
        obj.NumberOfCopies__c = cmp.get("v.numberOfCopies");

		if (bHasError ||
			DesignatedAgentNamekana1 || DesignatedAgentNamekana2  || DesignatedAgentNamekana3  || DesignatedAgentNamekana4  || DesignatedAgentNamekana5  ||
			DesignatedAgentNamekana6   || DesignatedAgentNamekana7  || DesignatedAgentNamekana8  || DesignatedAgentNamekana9  || DesignatedAgentNamekana10 || 
			DesignatedAgentNamekanji1  || DesignatedAgentNamekanji2 || DesignatedAgentNamekanji3 || DesignatedAgentNamekanji4 || DesignatedAgentNamekanji5 ||
			DesignatedAgentNamekanji6  || DesignatedAgentNamekanji7 || DesignatedAgentNamekanji8 || DesignatedAgentNamekanji9 || DesignatedAgentNamekanji10 ||
			DesignatedDob1 ||DesignatedDob2 ||DesignatedDob3 ||DesignatedDob4 || DesignatedDob5 || 
			DesignatedDob6 ||DesignatedDob7 ||DesignatedDob8 ||DesignatedDob9 || DesignatedDob10 || noOfCopiesErr)
		{
			var events = cmp.getEvent("ReqStopSaveComponentEvent");
			events.setParams({"param": true});
			events.fire();
		}
		else{
			var events = cmp.getEvent("ReqStopSaveComponentEvent");
			events.setParams({"param": false});
			events.fire();
		}
    },
    init : function(component,event,helper){
        component.set("v.innerCmpNewRequest.Processing__c",'手動');
		var dependantSubject = component.get('v.dependantSubject');
        helper.getProcessingPicklist(component, event,dependantSubject);
		helper.getShippingDocumentsPicklist(component, event,dependantSubject);
		helper.getDateOfShipmentPicklist(component, event);
		helper.getShippingMethodPicklist(component, event);
		//helper.getProcedureTypePicklist(component,event,dependantSubject);
		helper.getProcedureType1Picklist(component,event,dependantSubject);
        helper.getProcedureType2Picklist(component,event,dependantSubject);
        helper.getProcedureType3Picklist(component,event,dependantSubject);
        helper.getProcedureType4Picklist(component,event,dependantSubject);
        helper.getProcedureType5Picklist(component,event,dependantSubject);
        helper.getProcedureType6Picklist(component,event,dependantSubject);
        helper.getProcedureType7Picklist(component,event,dependantSubject);
        helper.getProcedureType8Picklist(component,event,dependantSubject);
        helper.getProcedureType9Picklist(component,event,dependantSubject);
        helper.getProcedureType10Picklist(component,event,dependantSubject);
    },
	handleProcessingPick : function(component, event, helper) {
        var disableFlag;
        var processingInput = component.get("v.innerCmpNewRequest.Processing__c");
        if(processingInput == "書類発送"){
            disableFlag = false;
        }else{
            disableFlag = true;
        }
        
        component.find("shippingDocumentsPickList").set("v.disabled", disableFlag);
        component.find("dateOfShipmentPickList").set("v.disabled", disableFlag);
        component.find("shippingMethodPickList").set("v.disabled", disableFlag);
        component.find("numberOfCopies").set("v.disabled", disableFlag);
        
        component.find("shippingDocumentsPickList").set("v.value", '');
        component.find("dateOfShipmentPickList").set("v.value", '');
        component.find("shippingMethodPickList").set("v.value", '');
        component.find("numberOfCopies").set("v.value", '');
        
        component.set("v.noOfCopiesErr",false);
    },
	handleRelationshipInsured1: function (component, event) {
        var disableFlag;
        component.set("v.otherDetails1","");
        var selectedValues = component.find("relationshipWithInsured1").get("v.value");
		component.set("v.relationshipWithInsured1",selectedValues);
        if(selectedValues == "その他親族"){
             disableFlag = false;
        }else{
            disableFlag = true;
        }
        component.find("otherDetails1").set("v.disabled", disableFlag);
        component.find("otherDetails1").set("v.value", '');
    },
	handleOtherDetails1: function (component, event,helper) {
        var selectedValues = component.find("otherDetails1").get("v.value");
		component.set("v.otherDetails1",selectedValues);
		if(selectedValues != ''){
            component.set("v.RelationshipInsureValidate1",false);
        }
        if(selectedValues == '指定範囲外'){
//            component.set("v.processingPicklist","書類発送");
            component.set("v.innerCmpNewRequest.Processing__c",'書類発送');
            component.find("shippingDocumentsPickList").set("v.disabled", false);
            component.find("dateOfShipmentPickList").set("v.disabled", false);
            component.find("shippingMethodPickList").set("v.disabled", false);
            component.find("numberOfCopies").set("v.disabled", false);
        }
        else{
            helper.getOtherDetailDepPicklist(component, event);
        }
    },
	handleRelationshipInsured2: function (component, event) {
	    var disableFlag;
		 component.set("v.otherDetails2","");
        var selectedValues = component.find("relationshipWithInsured2").get("v.value");
		component.set("v.relationshipWithInsured2",selectedValues);
		if(selectedValues == "その他親族"){
             disableFlag = false;
        }else{
            disableFlag = true;
        }
        component.find("otherDetails2").set("v.disabled", disableFlag);
        component.find("otherDetails2").set("v.value", '');
    },
	handleOtherDetails2: function (component, event,helper) {
        var selectedValues = component.find("otherDetails2").get("v.value");
		component.set("v.otherDetails2",selectedValues);
		if(selectedValues != ''){
            component.set("v.RelationshipInsureValidate2",false);
        }
        if(selectedValues == '指定範囲外'){
//            component.set("v.processingPicklist","書類発送");
            component.set("v.innerCmpNewRequest.Processing__c",'書類発送');
            component.find("shippingDocumentsPickList").set("v.disabled", false);
            component.find("dateOfShipmentPickList").set("v.disabled", false);
            component.find("shippingMethodPickList").set("v.disabled", false);
            component.find("numberOfCopies").set("v.disabled", false);
        }
        else{
           helper.getOtherDetailDepPicklist(component, event);
        }
    },
	handleRelationshipInsured3: function (component, event) {
		var disableFlag;
		 component.set("v.otherDetails3","");
        var selectedValues = component.find("relationshipWithInsured3").get("v.value");
		component.set("v.relationshipWithInsured3",selectedValues);
		if(selectedValues == "その他親族"){
             disableFlag = false;
        }else{
            disableFlag = true;
        }
        component.find("otherDetails3").set("v.disabled", disableFlag);
        component.find("otherDetails3").set("v.value", '');
    },
	handleOtherDetails3: function (component, event,helper) {
        var selectedValues = component.find("otherDetails3").get("v.value");
		component.set("v.otherDetails3",selectedValues);
		if(selectedValues != ''){
            component.set("v.RelationshipInsureValidate3",false);
        }
        if(selectedValues == '指定範囲外'){
//            component.set("v.processingPicklist","書類発送");
            component.set("v.innerCmpNewRequest.Processing__c",'書類発送');
            component.find("shippingDocumentsPickList").set("v.disabled", false);
            component.find("dateOfShipmentPickList").set("v.disabled", false);
            component.find("shippingMethodPickList").set("v.disabled", false);
            component.find("numberOfCopies").set("v.disabled", false);
        }
        else{
           helper.getOtherDetailDepPicklist(component, event);
        }
    },
	handleRelationshipInsured4: function (component, event) {
	    var disableFlag;
		 component.set("v.otherDetails4","");
        var selectedValues = component.find("relationshipWithInsured4").get("v.value");
		component.set("v.relationshipWithInsured4",selectedValues);
		if(selectedValues == "その他親族"){
             disableFlag = false;
        }else{
            disableFlag = true;
        }
        component.find("otherDetails4").set("v.disabled", disableFlag);
        component.find("otherDetails4").set("v.value", '');
    },
	handleOtherDetails4: function (component, event,helper) {
        var selectedValues = component.find("otherDetails4").get("v.value");
		component.set("v.otherDetails4",selectedValues);
		if(selectedValues != ''){
            component.set("v.RelationshipInsureValidate4",false);
        }
        if(selectedValues == '指定範囲外'){
//            component.set("v.processingPicklist","書類発送");
            component.set("v.innerCmpNewRequest.Processing__c",'書類発送');
            component.find("shippingDocumentsPickList").set("v.disabled", false);
            component.find("dateOfShipmentPickList").set("v.disabled", false);
            component.find("shippingMethodPickList").set("v.disabled", false);
            component.find("numberOfCopies").set("v.disabled", false);
        }
        else{
            helper.getOtherDetailDepPicklist(component, event);
        }
    },
	
	handleRelationshipInsured5: function (component, event) {
	    var disableFlag;
		 component.set("v.otherDetails5","");
        var selectedValues = component.find("relationshipWithInsured5").get("v.value");
		component.set("v.relationshipWithInsured5",selectedValues);
		if(selectedValues == "その他親族"){
             disableFlag = false;
        }else{
            disableFlag = true;
        }
        component.find("otherDetails5").set("v.disabled", disableFlag);
        component.find("otherDetails5").set("v.value", '');
    },
	handleOtherDetails5: function (component, event,helper) {
        var selectedValues = component.find("otherDetails5").get("v.value");
		component.set("v.otherDetails5",selectedValues);
		if(selectedValues != ''){
            component.set("v.RelationshipInsureValidate5",false);
        }
        if(selectedValues == '指定範囲外'){
//            component.set("v.processingPicklist","書類発送");
            component.set("v.innerCmpNewRequest.Processing__c",'書類発送');
            component.find("shippingDocumentsPickList").set("v.disabled", false);
            component.find("dateOfShipmentPickList").set("v.disabled", false);
            component.find("shippingMethodPickList").set("v.disabled", false);
            component.find("numberOfCopies").set("v.disabled", false);
        }
        else{
           helper.getOtherDetailDepPicklist(component, event);
        }
    },
	handleRelationshipInsured6: function (component, event) {
	    var disableFlag;
		component.set("v.otherDetails6","");
        var selectedValues = component.find("relationshipWithInsured6").get("v.value");
		component.set("v.relationshipWithInsured6",selectedValues);
		if(selectedValues == "その他親族"){
             disableFlag = false;
        }else{
            disableFlag = true;
        }
        component.find("otherDetails6").set("v.disabled", disableFlag);
        component.find("otherDetails6").set("v.value", '');
    },
	handleOtherDetails6: function (component, event,helper) {
        var selectedValues = component.find("otherDetails6").get("v.value");
		component.set("v.otherDetails6",selectedValues);
		if(selectedValues != ''){
            component.set("v.RelationshipInsureValidate6",false);
        }
        if(selectedValues == '指定範囲外'){
//            component.set("v.processingPicklist","書類発送");
            component.set("v.innerCmpNewRequest.Processing__c",'書類発送');
            component.find("shippingDocumentsPickList").set("v.disabled", false);
            component.find("dateOfShipmentPickList").set("v.disabled", false);
            component.find("shippingMethodPickList").set("v.disabled", false);
            component.find("numberOfCopies").set("v.disabled", false);
        }
        else{
           helper.getOtherDetailDepPicklist(component, event);
        }
    },
	handleRelationshipInsured7: function (component, event) {
        var disableFlag;
		component.set("v.otherDetails7","");
        var selectedValues = component.find("relationshipWithInsured7").get("v.value");
		component.set("v.relationshipWithInsured7",selectedValues);
		if(selectedValues == "その他親族"){
             disableFlag = false;
        }else{
            disableFlag = true;
        }
        component.find("otherDetails7").set("v.disabled", disableFlag);
        component.find("otherDetails7").set("v.value", '');
    },
	handleOtherDetails7: function (component, event,helper) {
        var selectedValues = component.find("otherDetails7").get("v.value");
		component.set("v.otherDetails7",selectedValues);
		if(selectedValues != ''){
            component.set("v.RelationshipInsureValidate7",false);
        }
        if(selectedValues == '指定範囲外'){
//            component.set("v.processingPicklist","書類発送");
            component.set("v.innerCmpNewRequest.Processing__c",'書類発送');
            component.find("shippingDocumentsPickList").set("v.disabled", false);
            component.find("dateOfShipmentPickList").set("v.disabled", false);
            component.find("shippingMethodPickList").set("v.disabled", false);
            component.find("numberOfCopies").set("v.disabled", false);
        }
        else{
            helper.getOtherDetailDepPicklist(component, event);
        }
    },
	handleRelationshipInsured8: function (component, event) {
	    var disableFlag;
		component.set("v.otherDetails8","");
        var selectedValues = component.find("relationshipWithInsured8").get("v.value");
		component.set("v.relationshipWithInsured8",selectedValues);
		if(selectedValues == "その他親族"){
             disableFlag = false;
        }else{
            disableFlag = true;
        }
        component.find("otherDetails8").set("v.disabled", disableFlag);
        component.find("otherDetails8").set("v.value", '');
    },
	handleOtherDetails8: function (component, event,helper) {
        var selectedValues = component.find("otherDetails8").get("v.value");
		component.set("v.otherDetails8",selectedValues);
		if(selectedValues != ''){
            component.set("v.RelationshipInsureValidate8",false);
        }
        if(selectedValues == '指定範囲外'){
//            component.set("v.processingPicklist","書類発送");
            component.set("v.innerCmpNewRequest.Processing__c",'書類発送');
            component.find("shippingDocumentsPickList").set("v.disabled", false);
            component.find("dateOfShipmentPickList").set("v.disabled", false);
            component.find("shippingMethodPickList").set("v.disabled", false);
            component.find("numberOfCopies").set("v.disabled", false);
        }
        else{
          	helper.getOtherDetailDepPicklist(component, event);
        }
    },
	handleRelationshipInsured9: function (component, event) {
	    var disableFlag;
		component.set("v.otherDetails9","");
        var selectedValues = component.find("relationshipWithInsured9").get("v.value");
		component.set("v.relationshipWithInsured9",selectedValues);
		if(selectedValues == "その他親族"){
             disableFlag = false;
        }else{
            disableFlag = true;
        }
        component.find("otherDetails9").set("v.disabled", disableFlag);
        component.find("otherDetails9").set("v.value", '');
    },
	handleOtherDetails9: function (component, event,helper) {
        var selectedValues = component.find("otherDetails9").get("v.value");
		component.set("v.otherDetails9",selectedValues);
		if(selectedValues != ''){
            component.set("v.RelationshipInsureValidate9",false);
        }
        if(selectedValues == '指定範囲外'){
//            component.set("v.processingPicklist","書類発送");
            component.set("v.innerCmpNewRequest.Processing__c",'書類発送');
            component.find("shippingDocumentsPickList").set("v.disabled", false);
            component.find("dateOfShipmentPickList").set("v.disabled", false);
            component.find("shippingMethodPickList").set("v.disabled", false);
            component.find("numberOfCopies").set("v.disabled", false);
        }
        else{
            helper.getOtherDetailDepPicklist(component, event);
        }
    },
	handleRelationshipInsured10: function (component, event) {
	    var disableFlag;
		component.set("v.otherDetails10","");
        var selectedValues = component.find("relationshipWithInsured10").get("v.value");
		component.set("v.relationshipWithInsured10",selectedValues);
		if(selectedValues == "その他親族"){
             disableFlag = false;
        }else{
            disableFlag = true;
        }
        component.find("otherDetails10").set("v.disabled", disableFlag);
        component.find("otherDetails10").set("v.value", '');
    },
	handleOtherDetails10: function (component, event,helper) {
        var selectedValues = component.find("otherDetails10").get("v.value");
		component.set("v.otherDetails10",selectedValues);
		if(selectedValues != ''){
            component.set("v.RelationshipInsureValidate10",false);
        }
        if(selectedValues == '指定範囲外'){
//            component.set("v.processingPicklist","書類発送");
            component.set("v.innerCmpNewRequest.Processing__c",'書類発送');
            component.find("shippingDocumentsPickList").set("v.disabled", false);
            component.find("dateOfShipmentPickList").set("v.disabled", false);
            component.find("shippingMethodPickList").set("v.disabled", false);
            component.find("numberOfCopies").set("v.disabled", false);
        }
        else{
           helper.getOtherDetailDepPicklist(component, event);
        }
    },
	
    handleDesignatedNameKana1 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newDesignatedAgentNamekana1","v.DesignatedAgentNamekana1");
    },
    handleDesignatedNameKana2 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newDesignatedAgentNamekana2","v.DesignatedAgentNamekana2");
    },
    handleDesignatedNameKana3 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newDesignatedAgentNamekana3","v.DesignatedAgentNamekana3");
    },
    handleDesignatedNameKana4 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newDesignatedAgentNamekana4","v.DesignatedAgentNamekana4");
    },
    handleDesignatedNameKana5 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newDesignatedAgentNamekana5","v.DesignatedAgentNamekana5");
    },
    handleDesignatedNameKana6 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newDesignatedAgentNamekana6","v.DesignatedAgentNamekana6");
    },
    handleDesignatedNameKana7 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newDesignatedAgentNamekana7","v.DesignatedAgentNamekana7");
    },
    handleDesignatedNameKana8 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newDesignatedAgentNamekana8","v.DesignatedAgentNamekana8");
    },
    handleDesignatedNameKana9 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newDesignatedAgentNamekana9","v.DesignatedAgentNamekana9");
    },
    handleDesignatedNameKana10 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newDesignatedAgentNamekana10","v.DesignatedAgentNamekana10");
    },
    handleDesignatedNameKanji1 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newDesignatedAgentNamekanji1","v.DesignatedAgentNamekanji1");
    },
    handleDesignatedNameKanji2 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newDesignatedAgentNamekanji2","v.DesignatedAgentNamekanji2");
    },
    handleDesignatedNameKanji3 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newDesignatedAgentNamekanji3","v.DesignatedAgentNamekanji3");
    },
    handleDesignatedNameKanji4 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newDesignatedAgentNamekanji4","v.DesignatedAgentNamekanji4");
    },
    handleDesignatedNameKanji5 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newDesignatedAgentNamekanji5","v.DesignatedAgentNamekanji5");
    },
    handleDesignatedNameKanji6 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newDesignatedAgentNamekanji6","v.DesignatedAgentNamekanji6");
    },
    handleDesignatedNameKanji7 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newDesignatedAgentNamekanji7","v.DesignatedAgentNamekanji7");
    },
    handleDesignatedNameKanji8 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newDesignatedAgentNamekanji8","v.DesignatedAgentNamekanji8");
    },
    handleDesignatedNameKanji9 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newDesignatedAgentNamekanji9","v.DesignatedAgentNamekanji9");
    },
    handleDesignatedNameKanji10 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newDesignatedAgentNamekanji10","v.DesignatedAgentNamekanji10");
    },
    handleDesignatedDob1 : function(component,event,helper) {
        var newDesignated1 = component.get("v.newDesignatedDob1");
        if(newDesignated1 !='' && newDesignated1.length != 8){
            component.set("v.DesignatedDob1", true);
        }else{
           helper.getNumericValidate(component, event,newDesignated1,"v.DesignatedDob1") ;
        }
    },
    handleDesignatedDob2 : function(component,event,helper) {
        var newDesignated2 = component.get("v.newDesignatedDob2");
        if(newDesignated2 !='' && newDesignated2.length != 8){
            component.set("v.DesignatedDob2", true);
        }else{
           helper.getNumericValidate(component, event,newDesignated2,"v.DesignatedDob2") ;
        }
    },
	handleDesignatedDob3 : function(component,event,helper) {
        var newDesignated3 = component.get("v.newDesignatedDob3");
        if(newDesignated3 !='' && newDesignated3.length != 8){
            component.set("v.DesignatedDob3", true);
        }else{
            helper.getNumericValidate(component, event,newDesignated3,"v.DesignatedDob3") ;
        }
    },
	handleDesignatedDob4 : function(component,event,helper) {
        var newDesignated4 = component.get("v.newDesignatedDob4");
        if(newDesignated4 !='' && newDesignated4.length != 8){
            component.set("v.DesignatedDob4", true);
        }else{
           helper.getNumericValidate(component, event,newDesignated4,"v.DesignatedDob4") ;
        }
    },
	handleDesignatedDob5 : function(component,event,helper) {
        var newDesignated5 = component.get("v.newDesignatedDob5");
        if(newDesignated5 !='' && newDesignated5.length != 8){
            component.set("v.DesignatedDob5", true);
        }else{
            helper.getNumericValidate(component, event,newDesignated5,"v.DesignatedDob5") ;
        }
    },
	handleDesignatedDob6 : function(component,event,helper) {
        var newDesignated6 = component.get("v.newDesignatedDob6");
        if(newDesignated6 !='' && newDesignated6.length != 8){
            component.set("v.DesignatedDob6", true);
        }else{
           helper.getNumericValidate(component, event,newDesignated6,"v.DesignatedDob6") ;
        }
    },
	handleDesignatedDob7 : function(component,event,helper) {
        var newDesignated7 = component.get("v.newDesignatedDob7");
        if(newDesignated7 !='' && newDesignated7.length != 8){
            component.set("v.DesignatedDob7", true);
        }else{
            helper.getNumericValidate(component, event,newDesignated7,"v.DesignatedDob7") ;
        }
    },
	handleDesignatedDob8 : function(component,event,helper) {
        var newDesignated8 = component.get("v.newDesignatedDob8");
        if(newDesignated8 !='' && newDesignated8.length != 8){
            component.set("v.DesignatedDob8", true);
        }else{
          helper.getNumericValidate(component, event,newDesignated8,"v.DesignatedDob8") ;
        }
    },
	handleDesignatedDob9 : function(component,event,helper) {
        var newDesignated9 = component.get("v.newDesignatedDob9");
        if(newDesignated9 !='' && newDesignated9.length != 8){
            component.set("v.DesignatedDob9", true);
        }else{
           helper.getNumericValidate(component, event,newDesignated9,"v.DesignatedDob9") ;
        }
    },
	handleDesignatedDob10 : function(component,event,helper) {
        var newDesignated10 = component.get("v.newDesignatedDob10");
        if(newDesignated10 !='' && newDesignated10.length != 8){
            component.set("v.DesignatedDob10", true);
        }else{
          helper.getNumericValidate(component, event,newDesignated10,"v.DesignatedDob10") ;
        }
    },
    handleNoOfCopies : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.numberOfCopies","v.noOfCopiesErr");
    }
    
})