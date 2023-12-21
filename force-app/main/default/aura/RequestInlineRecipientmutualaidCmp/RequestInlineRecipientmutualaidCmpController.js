/**
 * @File Name          : RequestInlineRecipientmutualaidCmpController.js
 * @Description        : 
 * @Author             : SRM
 * @Group              : 
 * @Last Modified By   : SRM
 * @Last Modified On   : 12/23/2019, 12:24:04 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    12/23/2019   SRM     Initial Version
**/
({
    saveInlineRecipientmutualaid : function(cmp, event, helper) {
        var params = event.getParam('arguments');
        var obj = params.parentNewRequest;
		
		// Check all Number Input field once again before Save
        helper.getSingleByteNumberCheck(cmp,event,"v.numberOfCopies","v.noOfCopiesErr");
		
        var bHasError = false;      
        if(cmp.get("v.productNameMultiPickList1Selected") != ''){
            if(cmp.get("v.currentRecipientName1") == '' ||
               cmp.get("v.relationshipBeneficiary1") == '' ||
               cmp.get("v.newRecipientNameKana1") == '' ||
               cmp.get("v.newRecipientName1") == '' ||
               cmp.get("v.relationshipNewPayee1") == '' ||
               cmp.get("v.newReceiptDate1") == '')
            {
                cmp.set("v.prod1",true);
                if (!bHasError) { cmp.find("productNameMultiPick1").focus(); bHasError = true; }
            }
            else{
                obj.ChangeDetails1__c = "商品名:" +cmp.get("v.productNameMultiPickList1Selected")+"\n"+
						        "現受取人氏名:" +cmp.get("v.currentRecipientName1")+"\n"+
						        "被保険者から見た現受取人の続柄:" + cmp.get("v.relationshipBeneficiary1")+"\n"+
						        "新受取人氏名（カナ）:" +cmp.get("v.newRecipientNameKana1")+"\n"+
        						"新受取人氏名（漢字）:" + cmp.get("v.newRecipientName1")+"\n"+
						        "被保険者から見た新受取人の続柄:" +cmp.get("v.relationshipNewPayee1")+"\n"+
            					"新受取人生年月日:" +cmp.get("v.newReceiptDate1");
            }
        }
        else{
            obj.ChangeDetails1__c = "";
        }
        if(cmp.get("v.productNameMultiPickList2Selected") != ''){
            if(cmp.get("v.currentRecipientName2") == '' ||
               cmp.get("v.relationshipBeneficiary2")== '' ||
               cmp.get("v.newRecipientNameKana2")== '' ||
               cmp.get("v.newRecipientName2")== '' ||
               cmp.get("v.relationshipNewPayee2")== '' ||
               cmp.get("v.newReceiptDate2")== '')
            {
                cmp.set("v.prod2",true);
                if (!bHasError) { cmp.find("productNameMultiPick2").focus(); bHasError = true; }
            }
            else{
                obj.ChangeDetails2__c = "商品名:" +cmp.get("v.productNameMultiPickList2Selected")+"\n"+
						        "現受取人氏名:" +cmp.get("v.currentRecipientName2")+"\n"+
						        "被保険者から見た現受取人の続柄:" + cmp.get("v.relationshipBeneficiary2")+"\n"+
						        "新受取人氏名（カナ）:" +cmp.get("v.newRecipientNameKana2")+"\n"+
        						"新受取人氏名（漢字）:" + cmp.get("v.newRecipientName2")+"\n"+
						        "被保険者から見た新受取人の続柄:" +cmp.get("v.relationshipNewPayee2")+"\n"+
            					"新受取人生年月日:" +cmp.get("v.newReceiptDate2"); 
            }
        }
        else{
            obj.ChangeDetails2__c = "";   
        }
        
        if(cmp.get("v.productNameMultiPickList3Selected") != ''){
            if(cmp.get("v.currentRecipientName3") == '' ||
               cmp.get("v.relationshipBeneficiary3")== '' ||
               cmp.get("v.newRecipientNameKana3")== '' ||
               cmp.get("v.newRecipientName3")== '' ||
               cmp.get("v.relationshipNewPayee3")== '' ||
               cmp.get("v.newReceiptDate3")== '')
            {
                cmp.set("v.prod3",true);
                if (!bHasError) { cmp.find("productNameMultiPick3").focus(); bHasError = true; }
            }
            else{
                obj.ChangeDetails3__c = "商品名:" +cmp.get("v.productNameMultiPickList3Selected")+"\n"+
						        "現受取人氏名:" +cmp.get("v.currentRecipientName3")+"\n"+
						        "被保険者から見た現受取人の続柄:" + cmp.get("v.relationshipBeneficiary3")+"\n"+
						        "新受取人氏名（カナ）:" +cmp.get("v.newRecipientNameKana3")+"\n"+
        						"新受取人氏名（漢字）:" + cmp.get("v.newRecipientName3")+"\n"+
						        "被保険者から見た新受取人の続柄:" +cmp.get("v.relationshipNewPayee3")+"\n"+
            					"新受取人生年月日:" +cmp.get("v.newReceiptDate3");
            }
		}
        else{
            obj.ChangeDetails3__c = "";   
        }    
        
        if(cmp.get("v.productNameMultiPickList4Selected") != ''){
            if(cmp.get("v.currentRecipientName4") == '' ||
               cmp.get("v.relationshipBeneficiary4")== '' ||
               cmp.get("v.newRecipientNameKana4")== '' ||
               cmp.get("v.newRecipientName4")== '' ||
               cmp.get("v.relationshipNewPayee4")== '' ||
               cmp.get("v.newReceiptDate4")== '')
            {
                cmp.set("v.prod4",true);
                if (!bHasError) { cmp.find("productNameMultiPick4").focus(); bHasError = true; }
            }
            else{
                obj.ChangeDetails4__c = "商品名:" +cmp.get("v.productNameMultiPickList4Selected")+"\n"+
						        "現受取人氏名:" +cmp.get("v.currentRecipientName4")+"\n"+
						        "被保険者から見た現受取人の続柄:" + cmp.get("v.relationshipBeneficiary4")+"\n"+
						        "新受取人氏名（カナ）:" +cmp.get("v.newRecipientNameKana4")+"\n"+
        						"新受取人氏名（漢字）:" + cmp.get("v.newRecipientName4")+"\n"+
						        "被保険者から見た新受取人の続柄:" +cmp.get("v.relationshipNewPayee4")+"\n"+
            					"新受取人生年月日:" +cmp.get("v.newReceiptDate4");
            }
        }
        else{
             obj.ChangeDetails4__c = "";   
        }    
        
        if(cmp.get("v.productNameMultiPickList5Selected") != ''){
            if(cmp.get("v.currentRecipientName5") == '' ||
               cmp.get("v.relationshipBeneficiary5")== '' ||
               cmp.get("v.newRecipientNameKana5")== '' ||
               cmp.get("v.newRecipientName5")== '' ||
               cmp.get("v.relationshipNewPayee5")== '' ||
               cmp.get("v.newReceiptDate5")== '')
            {
                cmp.set("v.prod5",true);
                if (!bHasError) { cmp.find("productNameMultiPick5").focus(); bHasError = true; }
            }
            else{
                obj.ChangeDetails5__c = "商品名:" +cmp.get("v.productNameMultiPickList5Selected")+"\n"+
						        "現受取人氏名:" +cmp.get("v.currentRecipientName5")+"\n"+
						        "被保険者から見た現受取人の続柄:" + cmp.get("v.relationshipBeneficiary5")+"\n"+
						        "新受取人氏名（カナ）:" +cmp.get("v.newRecipientNameKana5")+"\n"+
        						"新受取人氏名（漢字）:" + cmp.get("v.newRecipientName5")+"\n"+
						        "被保険者から見た新受取人の続柄:" +cmp.get("v.relationshipNewPayee5")+"\n"+
            					"新受取人生年月日:" +cmp.get("v.newReceiptDate5");
            }
		}
        else{
            obj.ChangeDetails5__c = "";    
        }    
        
        if(cmp.get("v.productNameMultiPickList6Selected") != ''){
            if(cmp.get("v.currentRecipientName6") == '' ||
               cmp.get("v.relationshipBeneficiary6")== '' ||
               cmp.get("v.newRecipientNameKana6")== '' ||
               cmp.get("v.newRecipientName6")== '' ||
               cmp.get("v.relationshipNewPayee6")== '' ||
               cmp.get("v.newReceiptDate6")== '')
            {
                cmp.set("v.prod6",true);
                if (!bHasError) { cmp.find("productNameMultiPick6").focus(); bHasError = true; }
            }
            else{
                obj.ChangeDetails6__c = "商品名:" +cmp.get("v.productNameMultiPickList6Selected")+"\n"+
						        "現受取人氏名:" +cmp.get("v.currentRecipientName6")+"\n"+
						        "被保険者から見た現受取人の続柄:" + cmp.get("v.relationshipBeneficiary6")+"\n"+
						        "新受取人氏名（カナ）:" +cmp.get("v.newRecipientNameKana6")+"\n"+
        						"新受取人氏名（漢字）:" + cmp.get("v.newRecipientName6")+"\n"+
						        "被保険者から見た新受取人の続柄:" +cmp.get("v.relationshipNewPayee6")+"\n"+
            					"新受取人生年月日:" +cmp.get("v.newReceiptDate6");
            }
		}
        else{
            obj.ChangeDetails6__c = "";   
        }
        
        if(cmp.get("v.productNameMultiPickList7Selected") != ''){
            if(cmp.get("v.currentRecipientName7") == '' ||
               cmp.get("v.relationshipBeneficiary7")== '' ||
               cmp.get("v.newRecipientNameKana7")== '' ||
               cmp.get("v.newRecipientName7")== '' ||
               cmp.get("v.relationshipNewPayee7")== '' ||
               cmp.get("v.newReceiptDate7")== '')
            {
                cmp.set("v.prod7",true);
                if (!bHasError) { cmp.find("productNameMultiPick7").focus(); bHasError = true; }
            }
            else{
                obj.ChangeDetails7__c = "商品名:" +cmp.get("v.productNameMultiPickList7Selected")+"\n"+
						        "現受取人氏名:" +cmp.get("v.currentRecipientName7")+"\n"+
						        "被保険者から見た現受取人の続柄:" + cmp.get("v.relationshipBeneficiary7")+"\n"+
						        "新受取人氏名（カナ）:" +cmp.get("v.newRecipientNameKana7")+"\n"+
        						"新受取人氏名（漢字）:" + cmp.get("v.newRecipientName7")+"\n"+
						        "被保険者から見た新受取人の続柄:" +cmp.get("v.relationshipNewPayee7")+"\n"+
            					"新受取人生年月日:" +cmp.get("v.newReceiptDate7"); 
            }
		}
        else{
            obj.ChangeDetails7__c = "" ;   
        }    
        
        if(cmp.get("v.productNameMultiPickList8Selected") != ''){
            if(cmp.get("v.currentRecipientName8") == '' ||
               cmp.get("v.relationshipBeneficiary8")== '' ||
               cmp.get("v.newRecipientNameKana8")== '' ||
               cmp.get("v.newRecipientName8")== '' ||
               cmp.get("v.relationshipNewPayee8")== '' ||
               cmp.get("v.newReceiptDate8")== '')
            {
                cmp.set("v.prod8",true);
                if (!bHasError) { cmp.find("productNameMultiPick8").focus(); bHasError = true; }
            }
            else{
                obj.ChangeDetails8__c = "商品名:" +cmp.get("v.productNameMultiPickList8Selected")+"\n"+
						        "現受取人氏名:" +cmp.get("v.currentRecipientName8")+"\n"+
						        "被保険者から見た現受取人の続柄:" + cmp.get("v.relationshipBeneficiary8")+"\n"+
						        "新受取人氏名（カナ）:" +cmp.get("v.newRecipientNameKana8")+"\n"+
        						"新受取人氏名（漢字）:" + cmp.get("v.newRecipientName8")+"\n"+
						        "被保険者から見た新受取人の続柄:" +cmp.get("v.relationshipNewPayee8")+"\n"+
            					"新受取人生年月日:" +cmp.get("v.newReceiptDate8");
            }
		}
        else{
             obj.ChangeDetails8__c = "";   
        }
        
        if(cmp.get("v.productNameMultiPickList9Selected") != ''){
            if(cmp.get("v.currentRecipientName9") == '' ||
               cmp.get("v.relationshipBeneficiary9")== '' ||
               cmp.get("v.newRecipientNameKana9")== '' ||
               cmp.get("v.newRecipientName9")== '' ||
               cmp.get("v.relationshipNewPayee9")== '' ||
               cmp.get("v.newReceiptDate9")== '')
            {
                cmp.set("v.prod9",true);
                if (!bHasError) { cmp.find("productNameMultiPick9").focus(); bHasError = true; }
            }
            else{
                 obj.ChangeDetails9__c = "商品名:" +cmp.get("v.productNameMultiPickList9Selected")+"\n"+
						        "現受取人氏名:" +cmp.get("v.currentRecipientName9")+"\n"+
						        "被保険者から見た現受取人の続柄:" + cmp.get("v.relationshipBeneficiary9")+"\n"+
						        "新受取人氏名（カナ）:" +cmp.get("v.newRecipientNameKana9")+"\n"+
        						"新受取人氏名（漢字）:" + cmp.get("v.newRecipientName9")+"\n"+
						        "被保険者から見た新受取人の続柄:" +cmp.get("v.relationshipNewPayee9")+"\n"+
            					"新受取人生年月日:" +cmp.get("v.newReceiptDate9");
            }
		}
        else{
            obj.ChangeDetails9__c = "";    
        }
       
        if(cmp.get("v.productNameMultiPickList10Selected") != ''){
            if(cmp.get("v.currentRecipientName10") == '' ||
               cmp.get("v.relationshipBeneficiary10")== '' ||
               cmp.get("v.newRecipientNameKana10")== '' ||
               cmp.get("v.newRecipientName10")== '' ||
               cmp.get("v.relationshipNewPayee10")== '' ||
               cmp.get("v.newReceiptDate10")== '')
            {
                cmp.set("v.prod10",true);
                if (!bHasError) { cmp.find("productNameMultiPick10").focus(); bHasError = true; }
            }
            else{
                obj.ChangeDetails10__c = "商品名:" +cmp.get("v.productNameMultiPickList10Selected")+"\n"+
						        "現受取人氏名:" +cmp.get("v.currentRecipientName10")+"\n"+
						        "被保険者から見た現受取人の続柄:" + cmp.get("v.relationshipBeneficiary10")+"\n"+
						        "新受取人氏名（カナ）:" +cmp.get("v.newRecipientNameKana10")+"\n"+
        						"新受取人氏名（漢字）:" + cmp.get("v.newRecipientName10")+"\n"+
						        "被保険者から見た新受取人の続柄:" +cmp.get("v.relationshipNewPayee10")+"\n"+
            					"新受取人生年月日:" +cmp.get("v.newReceiptDate10");
            }
		}
        else{
            obj.ChangeDetails10__c = "";  
        }
        
        obj.Processing__c = cmp.get("v.innerCmpNewRequest").Processing__c;
        obj.ShippingDocuments__c = cmp.get("v.innerCmpNewRequest").ShippingDocuments__c;
        //obj.NumberOfCopies__c = cmp.get("v.innerCmpNewRequest").NumberOfCopies__c;
        obj.DateOfShipment__c = cmp.get("v.innerCmpNewRequest").DateOfShipment__c; 
        obj.ShippingMethod__c = cmp.get("v.innerCmpNewRequest").ShippingMethod__c;
        var RecipientNameKana1 = cmp.get("v.RecipientNameKana1");
        var RecipientNameKana2 = cmp.get("v.RecipientNameKana2");
        var RecipientNameKana3 = cmp.get("v.RecipientNameKana3");
        var RecipientNameKana4 = cmp.get("v.RecipientNameKana4");
        var RecipientNameKana5 = cmp.get("v.RecipientNameKana5");
        var RecipientNameKana6 = cmp.get("v.RecipientNameKana6");
        var RecipientNameKana7 = cmp.get("v.RecipientNameKana7");
        var RecipientNameKana8 = cmp.get("v.RecipientNameKana8");
        var RecipientNameKana9 = cmp.get("v.RecipientNameKana9");
        var RecipientNameKana10 = cmp.get("v.RecipientNameKana10");
        var RecipientName1 = cmp.get("v.RecipientName1");
        var RecipientName2 = cmp.get("v.RecipientName2");
        var RecipientName3 = cmp.get("v.RecipientName3");
        var RecipientName4 = cmp.get("v.RecipientName4");
        var RecipientName5 = cmp.get("v.RecipientName5");
        var RecipientName6 = cmp.get("v.RecipientName6");
        var RecipientName7 = cmp.get("v.RecipientName7");
        var RecipientName8 = cmp.get("v.RecipientName8");
        var RecipientName9 = cmp.get("v.RecipientName9");
        var RecipientName10 = cmp.get("v.RecipientName10");
        var ReceiptDate1 = cmp.get("v.ReceiptDate1");
        var ReceiptDate2 = cmp.get("v.ReceiptDate2");
        var ReceiptDate3 = cmp.get("v.ReceiptDate3");
        var ReceiptDate4 = cmp.get("v.ReceiptDate4");
        var ReceiptDate5 = cmp.get("v.ReceiptDate5");
        var ReceiptDate6 = cmp.get("v.ReceiptDate6");
        var ReceiptDate7 = cmp.get("v.ReceiptDate7");
        var ReceiptDate8 = cmp.get("v.ReceiptDate8");
        var ReceiptDate9 = cmp.get("v.ReceiptDate9");
        var ReceiptDate10 = cmp.get("v.ReceiptDate10");
		
		var numberOfCopies = cmp.get("v.numberOfCopies") == null ? "" : cmp.get("v.numberOfCopies");
		var noOfCopiesErr = cmp.get("v.noOfCopiesErr");
        
        obj.NumberOfCopies__c = cmp.get("v.numberOfCopies");

        if( bHasError || RecipientNameKana1 || RecipientNameKana2 || RecipientNameKana3 || RecipientNameKana4 ||RecipientNameKana5 ||
            RecipientNameKana6 || RecipientNameKana7 || RecipientNameKana8 || RecipientNameKana9 ||RecipientNameKana10 ||
            RecipientName1 || RecipientName2 || RecipientName3 || RecipientName4 ||RecipientName5 ||
            RecipientName6 || RecipientName7 || RecipientName8 || RecipientName9 ||RecipientName10 ||
           	ReceiptDate1 || ReceiptDate2 || ReceiptDate3 || ReceiptDate4 ||ReceiptDate5 ||
        	ReceiptDate6 || ReceiptDate7 || ReceiptDate8 || ReceiptDate9 ||ReceiptDate10 || noOfCopiesErr 
          ) {
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
    init : function(component,event,helper) {
        var dependantSubject = component.get('v.dependantSubject');
        helper.getProcessingPicklist(component, event,dependantSubject);
        helper.getShippingDocumentsPicklist(component, event,dependantSubject);
        helper.getDateOfShipmentPicklist(component, event);
	    helper.getShippingMethodPicklist(component, event);
        
        component.set("v.innerCmpNewRequest.Processing__c",'手動');
    },
    handleRelationshipBeneficiary1: function (component, event) {
		//var selectedValues = event.getParam("value");
		var selectedValues = component.find("relationshipBeneficiary1").get("v.value");
		component.set("v.relationshipBeneficiary1",selectedValues);
    },
	  handleRelationshipNewPayee1: function (component, event) {
		//var selectedValues = event.getParam("value");
        var selectedValues = component.find("relationshipNewPayee1").get("v.value"); 
		component.set("v.relationshipNewPayee1",selectedValues);
    },
	  handleRelationshipBeneficiary2: function (component, event) {
        var selectedValues = component.find("relationshipBeneficiary2").get("v.value");
		component.set("v.relationshipBeneficiary2",selectedValues);
    },
	handleRelationshipNewPayee2: function (component, event) {
        var selectedValues = component.find("relationshipNewPayee2").get("v.value");
		component.set("v.relationshipNewPayee2",selectedValues);
    },	
	handleRelationshipBeneficiary3: function (component, event) {
        var selectedValues = component.find("relationshipBeneficiary3").get("v.value");
		component.set("v.relationshipBeneficiary3",selectedValues);
    },
	handleRelationshipNewPayee3: function (component, event) {
        var selectedValues = component.find("relationshipNewPayee3").get("v.value");
		component.set("v.relationshipNewPayee3",selectedValues);
    },
	handleRelationshipBeneficiary4: function (component, event) {
        var selectedValues = component.find("relationshipBeneficiary4").get("v.value");
		component.set("v.relationshipBeneficiary4",selectedValues);
    },
	handleRelationshipNewPayee4: function (component, event) {
        var selectedValues = component.find("relationshipNewPayee4").get("v.value");
		component.set("v.relationshipNewPayee4",selectedValues);
    },
	handleRelationshipBeneficiary5: function (component, event) {
        var selectedValues = component.find("relationshipBeneficiary5").get("v.value");
		component.set("v.relationshipBeneficiary5",selectedValues);
    },
	handleRelationshipNewPayee5: function (component, event) {
        var selectedValues = component.find("relationshipNewPayee5").get("v.value");
		component.set("v.relationshipNewPayee5",selectedValues);
    },
	handleRelationshipBeneficiary6: function (component, event) {
        var selectedValues = component.find("relationshipBeneficiary6").get("v.value");
		component.set("v.relationshipBeneficiary6",selectedValues);
    },
	handleRelationshipNewPayee6: function (component, event) {
        var selectedValues = component.find("relationshipNewPayee6").get("v.value");
		component.set("v.relationshipNewPayee6",selectedValues);
    },
	handleRelationshipBeneficiary7: function (component, event) {
        var selectedValues = component.find("relationshipBeneficiary7").get("v.value");
		component.set("v.relationshipBeneficiary7",selectedValues);
    },
	handleRelationshipNewPayee7: function (component, event) {
        var selectedValues = component.find("relationshipNewPayee7").get("v.value");
		component.set("v.relationshipNewPayee7",selectedValues);
    },
	handleRelationshipBeneficiary8: function (component, event) {
        var selectedValues = component.find("relationshipBeneficiary8").get("v.value");
		component.set("v.relationshipBeneficiary8",selectedValues);
    },
	handleRelationshipNewPayee8: function (component, event) {
        var selectedValues = component.find("relationshipNewPayee8").get("v.value");
		component.set("v.relationshipNewPayee8",selectedValues);
    },
	handleRelationshipBeneficiary9: function (component, event) {
        var selectedValues = component.find("relationshipBeneficiary9").get("v.value");
		component.set("v.relationshipBeneficiary9",selectedValues);
    },
	handleRelationshipNewPayee9: function (component, event) {
        var selectedValues = component.find("relationshipNewPayee9").get("v.value");
		component.set("v.relationshipNewPayee9",selectedValues);
    },
	handleRelationshipBeneficiary10: function (component, event) {
        var selectedValues = component.find("relationshipBeneficiary10").get("v.value");
		component.set("v.relationshipBeneficiary10",selectedValues);
    },
	handleRelationshipNewPayee10: function (component, event) {
        var selectedValues = component.find("relationshipNewPayee10").get("v.value");
		component.set("v.relationshipNewPayee10",selectedValues);
    },	
	handleProductNameMultiPick1: function (component, event) {
		var selectedOptionValue = event.getParam("value");
		component.set("v.productNameMultiPickList1Selected",selectedOptionValue);
    },
	handleProductNameMultiPick2: function (component, event) {
        var selectedValues = component.find("productNameMultiPick2").get("v.value");
		component.set("v.productNameMultiPickList2Selected",selectedValues);
    },
	handleProductNameMultiPick3: function (component, event) {
        var selectedValues = component.find("productNameMultiPick3").get("v.value");
		component.set("v.productNameMultiPickList3Selected",selectedValues);
    },
	handleProductNameMultiPick4: function (component, event) {
        var selectedValues = component.find("productNameMultiPick4").get("v.value");
		component.set("v.productNameMultiPickList4Selected",selectedValues);
    },
	handleProductNameMultiPick5: function (component, event) {
        var selectedValues = component.find("productNameMultiPick5").get("v.value");
		component.set("v.productNameMultiPickList5Selected",selectedValues);
    },
	handleProductNameMultiPick6: function (component, event) {
        var selectedValues = component.find("productNameMultiPick6").get("v.value");
		component.set("v.productNameMultiPickList6Selected",selectedValues);
    },
	handleProductNameMultiPick7: function (component, event) {
        var selectedValues = component.find("productNameMultiPick7").get("v.value");
		component.set("v.productNameMultiPickList7Selected",selectedValues);
    },
	handleProductNameMultiPick8: function (component, event) {
        var selectedValues = component.find("productNameMultiPick8").get("v.value");
		component.set("v.productNameMultiPickList8Selected",selectedValues);
    },
	handleProductNameMultiPick9: function (component, event) {
        var selectedValues = component.find("productNameMultiPick9").get("v.value");
		component.set("v.productNameMultiPickList9Selected",selectedValues);
    },
	handleProductNameMultiPick10: function (component, event) {
        var selectedValues = component.find("productNameMultiPick10").get("v.value");
		component.set("v.productNameMultiPickList10Selected",selectedValues);
    },
    handleProcessingPick : function(component, event, helper) {
        var disableFlag;
        var processingInput = component.get("v.innerCmpNewRequest.Processing__c");
        if(processingInput == "書類発送") {
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
    handleRecipientNameKana1 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientNameKana1","v.RecipientNameKana1");
    },
    handleRecipientNameKana2 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientNameKana2","v.RecipientNameKana2");
    },
    handleRecipientNameKana3 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientNameKana3","v.RecipientNameKana3");
    },
    handleRecipientNameKana4 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientNameKana4","v.RecipientNameKana4");
    },
    handleRecipientNameKana5 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientNameKana5","v.RecipientNameKana5");
    },
    handleRecipientNameKana6 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientNameKana6","v.RecipientNameKana6");
    },
    handleRecipientNameKana7 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientNameKana7","v.RecipientNameKana7");
    },
    handleRecipientNameKana8 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientNameKana8","v.RecipientNameKana8");
    },
    handleRecipientNameKana9 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientNameKana9","v.RecipientNameKana9");
    },
    handleRecipientNameKana10 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientNameKana10","v.RecipientNameKana10");
    },
    handleRecipientName1 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientName1","v.RecipientName1");
    },
    handleRecipientName2 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientName2","v.RecipientName2");
    },
    handleRecipientName3 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientName3","v.RecipientName3");
    },
    handleRecipientName4 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientName4","v.RecipientName4");
    },
    handleRecipientName5 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientName5","v.RecipientName5");
    },
    handleRecipientName6 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientName6","v.RecipientName6");
    },
    handleRecipientName7 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientName7","v.RecipientName7");
    },
    handleRecipientName8 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientName8","v.RecipientName8");
    },
    handleRecipientName9 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientName9","v.RecipientName9");
    },
    handleRecipientName10 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientName10","v.RecipientName10");
    },
    
    handleReceiptDate1 : function(component,event,helper) {
        var newReceiptDate1 = component.get("v.newReceiptDate1");
        if(newReceiptDate1 !='' && newReceiptDate1.length != 8) {
            component.set("v.ReceiptDate1", true);
        } else{
            component.set("v.ReceiptDate1", false);
            helper.getSingleByteCheck(component,event,"v.newReceiptDate1","v.ReceiptDate1");
        } 
    },
    handleReceiptDate2 : function(component,event,helper) {
        var newReceiptDate2 = component.get("v.newReceiptDate2");
        if(newReceiptDate2 != '' && newReceiptDate2.length != 8) {
            component.set("v.ReceiptDate2", true);
        } else{
            component.set("v.ReceiptDate2", false);
            helper.getSingleByteCheck(component,event,"v.newReceiptDate2","v.ReceiptDate2");
        } 
    },
	handleReceiptDate3 : function(component,event,helper) {
        var newReceiptDate3 = component.get("v.newReceiptDate3");
        if(newReceiptDate3 != '' && newReceiptDate3.length != 8) {
            component.set("v.ReceiptDate3", true);
        } else{
            component.set("v.ReceiptDate3", false);
            helper.getSingleByteCheck(component,event,"v.newReceiptDate3","v.ReceiptDate3");
        } 
    },
	handleReceiptDate4 : function(component,event,helper) {
        var newReceiptDate4 = component.get("v.newReceiptDate4");
        if(newReceiptDate4 != '' && newReceiptDate4.length != 8) {
            component.set("v.ReceiptDate4", true);
        } else{
            component.set("v.ReceiptDate4", false);
            helper.getSingleByteCheck(component,event,"v.newReceiptDate4","v.ReceiptDate4");
        } 
    },
	handleReceiptDate5 : function(component,event,helper) {
        var newReceiptDate5 = component.get("v.newReceiptDate5");
        if(newReceiptDate5 != '' && newReceiptDate5.length != 8) {
            component.set("v.ReceiptDate5", true);
        } else{
            component.set("v.ReceiptDate5", false);
            helper.getSingleByteCheck(component,event,"v.newReceiptDate5","v.ReceiptDate5");
        } 
    },
	handleReceiptDate6 : function(component,event,helper) {
        var newReceiptDate6 = component.get("v.newReceiptDate6");
        if(newReceiptDate6 != '' && newReceiptDate6.length != 8) {
            component.set("v.ReceiptDate6", true);
        } else{
            component.set("v.ReceiptDate6", false);
            helper.getSingleByteCheck(component,event,"v.newReceiptDate6","v.ReceiptDate6");
        } 
    },
	handleReceiptDate7 : function(component,event,helper) {
        var newReceiptDate7 = component.get("v.newReceiptDate7");
        if(newReceiptDate7 != '' && newReceiptDate7.length != 8) {
            component.set("v.ReceiptDate7", true);
        } else{
            component.set("v.ReceiptDate7", false);
            helper.getSingleByteCheck(component,event,"v.newReceiptDate7","v.ReceiptDate7");
        } 
    },
	handleReceiptDate8 : function(component,event,helper) {
        var newReceiptDate8 = component.get("v.newReceiptDate8");
        if(newReceiptDate8 != '' && newReceiptDate8.length != 8) {
            component.set("v.ReceiptDate8", true);
        } else{
            component.set("v.ReceiptDate8", false);
            helper.getSingleByteCheck(component,event,"v.newReceiptDate8","v.ReceiptDate8");
        } 
    },
	handleReceiptDate9 : function(component,event,helper) {
        var newReceiptDate9 = component.get("v.newReceiptDate9");
        if(newReceiptDate9 != '' && newReceiptDate9.length != 8) {
            component.set("v.ReceiptDate9", true);
        } else{
            component.set("v.ReceiptDate9", false);
            helper.getSingleByteCheck(component,event,"v.newReceiptDate9","v.ReceiptDate9");
        } 
    },
	handleReceiptDate10 : function(component,event,helper) {
        var newReceiptDate10 = component.get("v.newReceiptDate10");
        if(newReceiptDate10 != '' && newReceiptDate10.length != 8) {
            component.set("v.ReceiptDate10", true);
        } else{
            component.set("v.ReceiptDate10", false);
            helper.getSingleByteCheck(component,event,"v.newReceiptDate10","v.ReceiptDate10");
        } 
    },
    handleNoOfCopies : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.numberOfCopies","v.noOfCopiesErr");
    }
})