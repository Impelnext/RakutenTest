({
    saveInlineRecipientlifeinsurance : function(cmp, event,helper) {
        var params = event.getParam('arguments');
		var obj = params.parentNewRequest;
        
		// Check all Number Input field once again before Save
        helper.getSingleByteNumberCheck(cmp,event,"v.receiveRate1","v.recRate1");
        helper.getRateValueCheck(cmp,event,"v.receiveRate1","v.recRate1");
        helper.getSingleByteNumberCheck(cmp,event,"v.receiveRate2","v.recRate2");
        helper.getRateValueCheck(cmp,event,"v.receiveRate2","v.recRate2");
        helper.getSingleByteNumberCheck(cmp,event,"v.receiveRate3","v.recRate3");
        helper.getRateValueCheck(cmp,event,"v.receiveRate3","v.recRate3");
        helper.getSingleByteNumberCheck(cmp,event,"v.receiveRate4","v.recRate4");
        helper.getRateValueCheck(cmp,event,"v.receiveRate4","v.recRate4");
        helper.getSingleByteNumberCheck(cmp,event,"v.receiveRate5","v.recRate5");
        helper.getRateValueCheck(cmp,event,"v.receiveRate5","v.recRate5");
        helper.getSingleByteNumberCheck(cmp,event,"v.receiveRate6","v.recRate6");
        helper.getRateValueCheck(cmp,event,"v.receiveRate6","v.recRate6");
        helper.getSingleByteNumberCheck(cmp,event,"v.receiveRate7","v.recRate7");
        helper.getRateValueCheck(cmp,event,"v.receiveRate7","v.recRate7");
        helper.getSingleByteNumberCheck(cmp,event,"v.receiveRate8","v.recRate8");
        helper.getRateValueCheck(cmp,event,"v.receiveRate8","v.recRate8");
        helper.getSingleByteNumberCheck(cmp,event,"v.receiveRate9","v.recRate9");
        helper.getRateValueCheck(cmp,event,"v.receiveRate9","v.recRate9");
        helper.getSingleByteNumberCheck(cmp,event,"v.receiveRate10","v.recRate10");
        helper.getRateValueCheck(cmp,event,"v.receiveRate10","v.recRate10");
        helper.getSingleByteNumberCheck(cmp,event,"v.numberOfCopies","v.noOfCopiesErr");

		var receiveRate1 = cmp.get("v.receiveRate1") == null ? "" : cmp.get("v.receiveRate1");
		var receiveRate2 = cmp.get("v.receiveRate2") == null ? "" : cmp.get("v.receiveRate2");
		var receiveRate3 = cmp.get("v.receiveRate3") == null ? "" : cmp.get("v.receiveRate3");
		var receiveRate4 = cmp.get("v.receiveRate4") == null ? "" : cmp.get("v.receiveRate4");
		var receiveRate5 = cmp.get("v.receiveRate5") == null ? "" : cmp.get("v.receiveRate5");
		var receiveRate6 = cmp.get("v.receiveRate6") == null ? "" : cmp.get("v.receiveRate6");
		var receiveRate7 = cmp.get("v.receiveRate7") == null ? "" : cmp.get("v.receiveRate7");
		var receiveRate8 = cmp.get("v.receiveRate8") == null ? "" : cmp.get("v.receiveRate8");
		var receiveRate9 = cmp.get("v.receiveRate9") == null ? "" : cmp.get("v.receiveRate9");
		var receiveRate10 = cmp.get("v.receiveRate10") == null ? "" : cmp.get("v.receiveRate10");
		var numberOfCopies = cmp.get("v.numberOfCopies") == null ? "" : cmp.get("v.numberOfCopies");
		
		var noOfCopiesErr = cmp.get("v.noOfCopiesErr");
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
        var RecipientNameKanji1 = cmp.get("v.RecipientNameKanji1");
        var RecipientNameKanji2 = cmp.get("v.RecipientNameKanji2");
        var RecipientNameKanji3 = cmp.get("v.RecipientNameKanji3");
        var RecipientNameKanji4 = cmp.get("v.RecipientNameKanji4");
        var RecipientNameKanji5 = cmp.get("v.RecipientNameKanji5");
        var RecipientNameKanji6 = cmp.get("v.RecipientNameKanji6");
        var RecipientNameKanji7 = cmp.get("v.RecipientNameKanji7");
        var RecipientNameKanji8 = cmp.get("v.RecipientNameKanji8");
        var RecipientNameKanji9 = cmp.get("v.RecipientNameKanji9");
        var RecipientNameKanji10 = cmp.get("v.RecipientNameKanji10");
        
        obj.ProcedureType1__c = cmp.get("v.innerCmpNewRequest").ProcedureType1__c;
		obj.PolicyNumber1__c = cmp.get("v.innerCmpNewRequest").PolicyNumber1__c;
		
		var bHasError = false;
        if(obj.PolicyNumber1__c != ''){
            if (cmp.get("v.innerCmpNewRequest").ProcedureType1__c == '' || 
            	cmp.get("v.newRecipientNameKana1") == '' || 
            	cmp.get("v.newRecipientNameKanji1") == '' || 
            	cmp.get("v.relationshipWithInsured1") == '' || 
            	receiveRate1 === ''){
            	
                cmp.set("v.PolicyNumberValidate1",true);
                if (!bHasError) { cmp.find("policyNumber1").focus(); bHasError = true; }
            }
            else {
            	
		    	obj.ChangeDetails1__c = "新受取人氏名（カナ）:" +cmp.get("v.newRecipientNameKana1")+"\n"+
	                            "新受取人氏名（漢字）:" +cmp.get("v.newRecipientNameKanji1")+"\n"+
	                            "被保険者との続柄:"    +cmp.get("v.relationshipWithInsured1")+ "\n"+
	                            "その他詳細:"       + cmp.get("v.otherDetails1")+ "\n"+
	                            "新受取人生年月日:" +cmp.get("v.newReceiptDate1")+ "\n"+
	                            "受取割合:" +  receiveRate1;
            }
        }
		else{
			obj.ChangeDetails1__c = "";
		}
		
        obj.ProcedureType2__c = cmp.get("v.innerCmpNewRequest").ProcedureType2__c;
        obj.PolicyNumber2__c = cmp.get("v.innerCmpNewRequest").PolicyNumber2__c;
        
        if(obj.PolicyNumber2__c != ''){
			if (cmp.get("v.innerCmpNewRequest").ProcedureType2__c == '' || 
            	cmp.get("v.newRecipientNameKana2") == '' || 
			 	cmp.get("v.newRecipientNameKanji2") == '' || 
			 	cmp.get("v.relationshipWithInsured2") == '' || 
			 	receiveRate2 === ''){
			 	
                cmp.set("v.PolicyNumberValidate2",true);
                if (!bHasError) { cmp.find("policyNumber2").focus(); bHasError = true; }
            }
            else{
            	
                obj.ChangeDetails2__c = "新受取人氏名（カナ）:" +cmp.get("v.newRecipientNameKana2")+"\n"+
						        "新受取人氏名（漢字）:" +cmp.get("v.newRecipientNameKanji2")+"\n"+
						        "被保険者との続柄:" +cmp.get("v.relationshipWithInsured2")+"\n"+ 
						        "その他詳細:" +cmp.get("v.otherDetails2")+"\n"+ 
						        "新受取人生年月日:" +cmp.get("v.newReceiptDate2")+ "\n"+
								"受取割合:" + receiveRate2;
            }
        }
		else{
			obj.ChangeDetails2__c = "";
		}
		
        obj.ProcedureType3__c = cmp.get("v.innerCmpNewRequest").ProcedureType3__c;
        obj.PolicyNumber3__c = cmp.get("v.innerCmpNewRequest").PolicyNumber3__c;
        
        if(obj.PolicyNumber3__c != ''){
			if (cmp.get("v.innerCmpNewRequest").ProcedureType3__c == '' || 
            	cmp.get("v.newRecipientNameKana3") == '' || 
			  	cmp.get("v.newRecipientNameKanji3") == '' || 
			  	cmp.get("v.relationshipWithInsured3") == '' || 
			  	receiveRate3 === ''){
			  	
                cmp.set("v.PolicyNumberValidate3",true);
                if (!bHasError) { cmp.find("policyNumber3").focus(); bHasError = true; }
            }
            else{
            	
                obj.ChangeDetails3__c = "新受取人氏名（カナ）:" +cmp.get("v.newRecipientNameKana3")+"\n"+
						        "新受取人氏名（漢字）:" +cmp.get("v.newRecipientNameKanji3")+"\n"+
						        "被保険者との続柄:" +cmp.get("v.relationshipWithInsured3")+"\n"+ 
						        "その他詳細:" +cmp.get("v.otherDetails3")+"\n"+ 
						        "新受取人生年月日:" +cmp.get("v.newReceiptDate3")+ "\n"+
								"受取割合:" + receiveRate3;
            }
        }
		else{
			obj.ChangeDetails3__c = "";
		}
		
        obj.ProcedureType4__c = cmp.get("v.innerCmpNewRequest").ProcedureType4__c;
        obj.PolicyNumber4__c = cmp.get("v.innerCmpNewRequest").PolicyNumber4__c;
        
        if(obj.PolicyNumber4__c != ''){
			if (cmp.get("v.innerCmpNewRequest").ProcedureType4__c == '' || 
            	cmp.get("v.newRecipientNameKana4") == '' || 
				cmp.get("v.newRecipientNameKanji4") == '' || 
				cmp.get("v.relationshipWithInsured4") == '' || 
				receiveRate4 === ''){
				
                cmp.set("v.PolicyNumberValidate4",true);
                if (!bHasError) { cmp.find("policyNumber4").focus(); bHasError = true; }
            }
            else{
            	
                obj.ChangeDetails4__c = "新受取人氏名（カナ）:" +cmp.get("v.newRecipientNameKana4")+"\n"+
						        "新受取人氏名（漢字）:" +cmp.get("v.newRecipientNameKanji4")+"\n"+
						        "被保険者との続柄:" +cmp.get("v.relationshipWithInsured4")+"\n"+ 
						        "その他詳細:" +cmp.get("v.otherDetails4")+"\n"+ 
						        "新受取人生年月日:" +cmp.get("v.newReceiptDate4")+ "\n"+
								"受取割合:" + receiveRate4;
            }
        }
		else{
			obj.ChangeDetails4__c = "";
		}
		
	    obj.ProcedureType5__c = cmp.get("v.innerCmpNewRequest").ProcedureType5__c;
        obj.PolicyNumber5__c = cmp.get("v.innerCmpNewRequest").PolicyNumber5__c;
        
        if(obj.PolicyNumber5__c != ''){
			if (cmp.get("v.innerCmpNewRequest").ProcedureType5__c == '' || 
            	cmp.get("v.newRecipientNameKana5") == '' || 
				cmp.get("v.newRecipientNameKanji5") == '' || 
				cmp.get("v.relationshipWithInsured5") == '' || 
				receiveRate5 === ''){
				
                cmp.set("v.PolicyNumberValidate5",true);
                if (!bHasError) { cmp.find("policyNumber5").focus(); bHasError = true; }
            }
            else{
                obj.ChangeDetails5__c = "新受取人氏名（カナ）:" +cmp.get("v.newRecipientNameKana5")+"\n"+
						        "新受取人氏名（漢字）:" +cmp.get("v.newRecipientNameKanji5")+"\n"+
						        "被保険者との続柄:" +cmp.get("v.relationshipWithInsured5")+"\n"+ 
						        "その他詳細:" +cmp.get("v.otherDetails5")+"\n"+ 
						        "新受取人生年月日:" +cmp.get("v.newReceiptDate5")+ "\n"+
								"受取割合:" + receiveRate5;
            }
        }
		else{
			obj.ChangeDetails5__c = "";
		}
		
		obj.ProcedureType6__c = cmp.get("v.innerCmpNewRequest").ProcedureType6__c;
        obj.PolicyNumber6__c = cmp.get("v.innerCmpNewRequest").PolicyNumber6__c;
        
        if(obj.PolicyNumber6__c != ''){
			if (cmp.get("v.innerCmpNewRequest").ProcedureType6__c == '' || 
            	cmp.get("v.newRecipientNameKana6") == '' || 
				cmp.get("v.newRecipientNameKanji6") == '' || 
				cmp.get("v.relationshipWithInsured6") == '' || 
				receiveRate6 === ''){
				
                cmp.set("v.PolicyNumberValidate6",true);
                if (!bHasError) { cmp.find("policyNumber6").focus(); bHasError = true; }
            }
            else{
            	
                obj.ChangeDetails6__c = "新受取人氏名（カナ）:" +cmp.get("v.newRecipientNameKana6")+"\n"+
						        "新受取人氏名（漢字）:" +cmp.get("v.newRecipientNameKanji6")+"\n"+
						        "被保険者との続柄:" +cmp.get("v.relationshipWithInsured6")+"\n"+ 
						        "その他詳細:" +cmp.get("v.otherDetails6")+"\n"+ 
						        "新受取人生年月日:" +cmp.get("v.newReceiptDate6")+ "\n"+
								"受取割合:" + receiveRate6;
            }
        }
		else{
			obj.ChangeDetails6__c = "";
		}
		
		obj.ProcedureType7__c = cmp.get("v.innerCmpNewRequest").ProcedureType7__c;
        obj.PolicyNumber7__c = cmp.get("v.innerCmpNewRequest").PolicyNumber7__c;
        
        if(obj.PolicyNumber7__c != ''){
			if (cmp.get("v.innerCmpNewRequest").ProcedureType7__c == '' || 
            	cmp.get("v.newRecipientNameKana7") == '' || 
				cmp.get("v.newRecipientNameKanji7") == '' || 
				cmp.get("v.relationshipWithInsured7") == '' || 
				receiveRate7 === ''){
				
                cmp.set("v.PolicyNumberValidate7",true);
                if (!bHasError) { cmp.find("policyNumber7").focus(); bHasError = true; }
            }
            else{
            	
                obj.ChangeDetails7__c = "新受取人氏名（カナ）:" +cmp.get("v.newRecipientNameKana7")+"\n"+
						        "新受取人氏名（漢字）:" +cmp.get("v.newRecipientNameKanji7")+"\n"+
						        "被保険者との続柄:" +cmp.get("v.relationshipWithInsured7")+"\n"+ 
						        "その他詳細:" +cmp.get("v.otherDetails7")+"\n"+ 
						        "新受取人生年月日:" +cmp.get("v.newReceiptDate7")+ "\n"+
								"受取割合:" + receiveRate7;
            }
        }
		else{
			obj.ChangeDetails7__c = "";
		}
		
		obj.ProcedureType8__c = cmp.get("v.innerCmpNewRequest").ProcedureType8__c;
        obj.PolicyNumber8__c = cmp.get("v.innerCmpNewRequest").PolicyNumber8__c;
        
        if(obj.PolicyNumber8__c != ''){
			if (cmp.get("v.innerCmpNewRequest").ProcedureType8__c == '' || 
            	cmp.get("v.newRecipientNameKana8") == '' || 
				cmp.get("v.newRecipientNameKanji8") == '' || 
				cmp.get("v.relationshipWithInsured8") == '' || 
				receiveRate8 === ''){
				
                cmp.set("v.PolicyNumberValidate8",true);
                if (!bHasError) { cmp.find("policyNumber8").focus(); bHasError = true; }
            }
            else{
            	
                obj.ChangeDetails8__c = "新受取人氏名（カナ）:" +cmp.get("v.newRecipientNameKana8")+"\n"+
			                    "新受取人氏名（漢字）:" +cmp.get("v.newRecipientNameKanji8")+"\n"+
			                    "被保険者との続柄:" +cmp.get("v.relationshipWithInsured8")+"\n"+ 
			                    "その他詳細:" +cmp.get("v.otherDetails8")+"\n"+ 
			                    "新受取人生年月日:" +cmp.get("v.newReceiptDate8")+ "\n"+
			                    "受取割合:" + receiveRate8;
            }
        }
		else{
			obj.ChangeDetails8__c = "";
		}
		
		obj.ProcedureType9__c = cmp.get("v.innerCmpNewRequest").ProcedureType9__c;
        obj.PolicyNumber9__c = cmp.get("v.innerCmpNewRequest").PolicyNumber9__c;
        
        if(obj.PolicyNumber9__c != ''){
			if (cmp.get("v.innerCmpNewRequest").ProcedureType9__c == '' || 
            	cmp.get("v.newRecipientNameKana9") == '' || 
				cmp.get("v.newRecipientNameKanji9") == '' || 
				cmp.get("v.relationshipWithInsured9") == '' || 
				receiveRate9 === ''){
				
                cmp.set("v.PolicyNumberValidate9",true);
                if (!bHasError) { cmp.find("policyNumber9").focus(); bHasError = true; }
            }
            else{
            	
                obj.ChangeDetails9__c = "新受取人氏名（カナ）:" +cmp.get("v.newRecipientNameKana9")+"\n"+
						        "新受取人氏名（漢字）:" +cmp.get("v.newRecipientNameKanji9")+"\n"+
						        "被保険者との続柄:" +cmp.get("v.relationshipWithInsured9")+"\n"+ 
						        "その他詳細:" +cmp.get("v.otherDetails9")+"\n"+ 
						        "新受取人生年月日:" +cmp.get("v.newReceiptDate9")+ "\n"+
								"受取割合:" + receiveRate9;
            }
        }
		else{
			obj.ChangeDetails9__c = "";
		}
		
		obj.ProcedureType10__c = cmp.get("v.innerCmpNewRequest").ProcedureType10__c;
        obj.PolicyNumber10__c = cmp.get("v.innerCmpNewRequest").PolicyNumber10__c; 
        
        if(obj.PolicyNumber10__c != ''){
			if (cmp.get("v.innerCmpNewRequest").ProcedureType10__c == '' || 
            	cmp.get("v.newRecipientNameKana10") == '' || 
				cmp.get("v.newRecipientNameKanji10") == '' || 
				cmp.get("v.relationshipWithInsured10") == '' || 
				receiveRate10 === ''){
				
                cmp.set("v.PolicyNumberValidate10",true);
                if (!bHasError) { cmp.find("policyNumber10").focus(); bHasError = true; }
            }
            else{
            	
                obj.ChangeDetails10__c = "新受取人氏名（カナ）:" +cmp.get("v.newRecipientNameKana10")+"\n"+
								"新受取人氏名（漢字）:" +cmp.get("v.newRecipientNameKanji10")+"\n"+
								"被保険者との続柄:" +cmp.get("v.relationshipWithInsured10")+"\n"+ 
								"その他詳細:" +cmp.get("v.otherDetails10")+"\n"+ 
								"新受取人生年月日:" +cmp.get("v.newReceiptDate10")+ "\n"+
								"受取割合:" + receiveRate10;
            }
        }
		else{
			obj.ChangeDetails10__c = "";
		}
		
        obj.Processing__c = cmp.get("v.innerCmpNewRequest").Processing__c;
        obj.ShippingDocuments__c = cmp.get("v.innerCmpNewRequest").ShippingDocuments__c;
        //obj.NumberOfCopies__c = cmp.get("v.innerCmpNewRequest").NumberOfCopies__c;
		obj.NumberOfCopies__c = cmp.get("v.numberOfCopies");
        obj.DateOfShipment__c = cmp.get("v.innerCmpNewRequest").DateOfShipment__c; 
        obj.ShippingMethod__c = cmp.get("v.innerCmpNewRequest").ShippingMethod__c;
        
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
        var recRate1 = cmp.get("v.recRate1");
        var recRate2 = cmp.get("v.recRate2");
        var recRate3 = cmp.get("v.recRate3");
        var recRate4 = cmp.get("v.recRate4");
        var recRate5 = cmp.get("v.recRate5");
        var recRate6 = cmp.get("v.recRate6");
        var recRate7 = cmp.get("v.recRate7");
        var recRate8 = cmp.get("v.recRate8");
        var recRate9 = cmp.get("v.recRate9");
        var recRate10 = cmp.get("v.recRate10");
        if(cmp.get("v.relationshipWithInsured1") == "その他親族" && cmp.get("v.otherDetails1") == ''){
            cmp.set("v.RelationshipInsureValidate1",true);
            if (!bHasError) { cmp.find("relationshipWithInsured1").focus(); bHasError = true; }
        }
		 if(cmp.get("v.relationshipWithInsured2") == "その他親族" && cmp.get("v.otherDetails2") == ''){
            cmp.set("v.RelationshipInsureValidate2",true);
            if (!bHasError) { cmp.find("relationshipWithInsured2").focus(); bHasError = true; }
        }
		 if(cmp.get("v.relationshipWithInsured3") == "その他親族" && cmp.get("v.otherDetails3") == ''){
            cmp.set("v.RelationshipInsureValidate3",true);
            if (!bHasError) { cmp.find("relationshipWithInsured3").focus(); bHasError = true; }
        }
		 if(cmp.get("v.relationshipWithInsured4") == "その他親族" && cmp.get("v.otherDetails4") == ''){
            cmp.set("v.RelationshipInsureValidate4",true);
            if (!bHasError) { cmp.find("relationshipWithInsured4").focus(); bHasError = true; }
        }
		 if(cmp.get("v.relationshipWithInsured5") == "その他親族" && cmp.get("v.otherDetails5") == ''){
            cmp.set("v.RelationshipInsureValidate5",true);
            if (!bHasError) { cmp.find("relationshipWithInsured5").focus(); bHasError = true; }
        }
		 if(cmp.get("v.relationshipWithInsured6") == "その他親族" && cmp.get("v.otherDetails6") == ''){
            cmp.set("v.RelationshipInsureValidate6",true);
            if (!bHasError) { cmp.find("relationshipWithInsured6").focus(); bHasError = true; }
        }
		 if(cmp.get("v.relationshipWithInsured7") == "その他親族" && cmp.get("v.otherDetails7") == ''){
            cmp.set("v.RelationshipInsureValidate7",true);
            if (!bHasError) { cmp.find("relationshipWithInsured7").focus(); bHasError = true; }
        }
		 if(cmp.get("v.relationshipWithInsured8") == "その他親族" && cmp.get("v.otherDetails8") == ''){
            cmp.set("v.RelationshipInsureValidate8",true);
            if (!bHasError) { cmp.find("relationshipWithInsured8").focus(); bHasError = true; }
        }
		 if(cmp.get("v.relationshipWithInsured9") == "その他親族" && cmp.get("v.otherDetails9") == ''){
            cmp.set("v.RelationshipInsureValidate9",true);
            if (!bHasError) { cmp.find("relationshipWithInsured9").focus(); bHasError = true; }
        }
		 if(cmp.get("v.relationshipWithInsured10") == "その他親族" && cmp.get("v.otherDetails10") == ''){
            cmp.set("v.RelationshipInsureValidate10",true);
            if (!bHasError) { cmp.find("relationshipWithInsured10").focus(); bHasError = true; }
        }
        
        if( bHasError || noOfCopiesErr ||
        	RecipientNameKana1 || RecipientNameKana2 || RecipientNameKana3 || RecipientNameKana4 ||RecipientNameKana5 ||
            RecipientNameKana6 || RecipientNameKana7 || RecipientNameKana8 || RecipientNameKana9 ||RecipientNameKana10 ||
            RecipientNameKanji1 || RecipientNameKanji2 || RecipientNameKanji3 || RecipientNameKanji4 ||RecipientNameKanji5 ||
            RecipientNameKanji6 || RecipientNameKanji7 || RecipientNameKanji8 || RecipientNameKanji9 ||RecipientNameKanji10 ||
           	ReceiptDate1 || ReceiptDate2 || ReceiptDate3 || ReceiptDate4 ||ReceiptDate5 ||
        	ReceiptDate6 || ReceiptDate7 || ReceiptDate8 || ReceiptDate9 ||ReceiptDate10 ||
            recRate1 || recRate2 || recRate3 || recRate4 ||recRate5 ||
        	recRate6 || recRate7 || recRate8 || recRate9 ||recRate10
			){
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
    
	init: function(component, event, helper){
		    var dependantSubject = component.get('v.dependantSubject');
		    helper.getProcessingPicklist(component, event,dependantSubject);
			helper.getShippingDocumentsPicklist(component, event,dependantSubject);
			helper.getDateOfShipmentPicklist(component, event);
			helper.getShippingMethodPicklist(component, event);
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
        
        	component.set("v.innerCmpNewRequest.Processing__c",'手動');
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
        component.find("otherDetails1").set("v.value","");
    },
	handleOtherDetails1: function (component, event,helper) {
        var selectedValues = component.find("otherDetails1").get("v.value");
		component.set("v.otherDetails1",selectedValues); 
        if(selectedValues != ''){
            component.set("v.RelationshipInsureValidate1",false);
        }
        if(selectedValues == '指定範囲外'){
//            component.set("v.processingPicklist","書類発送");
            component.set('v.innerCmpNewRequest.Processing__c', '書類発送');
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
            component.set('v.innerCmpNewRequest.Processing__c', '書類発送');
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
            component.set('v.innerCmpNewRequest.Processing__c', '書類発送');
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
            component.set('v.innerCmpNewRequest.Processing__c', '書類発送');
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
            component.set('v.innerCmpNewRequest.Processing__c', '書類発送');
//            component.set("v.processingPicklist","書類発送");
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
            component.set('v.innerCmpNewRequest.Processing__c', '書類発送');
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
            component.set('v.innerCmpNewRequest.Processing__c', '書類発送');
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
            component.set('v.innerCmpNewRequest.Processing__c', '書類発送');
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
            component.set('v.innerCmpNewRequest.Processing__c', '書類発送');
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
            component.set('v.innerCmpNewRequest.Processing__c', '書類発送');
            component.find("shippingDocumentsPickList").set("v.disabled", false);
            component.find("dateOfShipmentPickList").set("v.disabled", false);
            component.find("shippingMethodPickList").set("v.disabled", false);
            component.find("numberOfCopies").set("v.disabled", false);
        }
        else{
            helper.getOtherDetailDepPicklist(component, event);
        }
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
    handleRecipientNameKanji1 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientNameKanji1","v.RecipientNameKanji1");
    },
    handleRecipientNameKanji2 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientNameKanji2","v.RecipientNameKanji2");
    },
    handleRecipientNameKanji3 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientNameKanji3","v.RecipientNameKanji3");
    },
    handleRecipientNameKanji4 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientNameKanji4","v.RecipientNameKanji4");
    },
    handleRecipientNameKanji5 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientNameKanji5","v.RecipientNameKanji5");
    },
    handleRecipientNameKanji6 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientNameKanji6","v.RecipientNameKanji6");
    },
    handleRecipientNameKanji7 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientNameKanji7","v.RecipientNameKanji7");
    },
    handleRecipientNameKanji8 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientNameKanji8","v.RecipientNameKanji8");
    },
    handleRecipientNameKanji9 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientNameKanji9","v.RecipientNameKanji9");
    },
    handleRecipientNameKanji10 : function(component,event,helper) {
        helper.getDoubleByteCheck(component,event,"v.newRecipientNameKanji10","v.RecipientNameKanji10");
    },
    handleReceiptDate1 : function(component,event,helper) {
        var newReceiptDate1 = component.get("v.newReceiptDate1");
        if( newReceiptDate1 != '' && newReceiptDate1.length != 8){
             component.set("v.ReceiptDate1", true);
        } 
        else{
            helper.getNumericValidate(component, event,newReceiptDate1,"v.ReceiptDate1");
        } 
    },
    handleReceiptDate2 : function(component,event,helper) {
        var newReceiptDate2 = component.get("v.newReceiptDate2");
        if(newReceiptDate2 != '' && newReceiptDate2.length != 8){
            component.set("v.ReceiptDate2", true);
        } else{
            helper.getNumericValidate(component,event,newReceiptDate2,"v.ReceiptDate2");
        } 
    },
	handleReceiptDate3 : function(component,event,helper) {
        var newReceiptDate3 = component.get("v.newReceiptDate3");
        if(newReceiptDate3 != '' && newReceiptDate3.length != 8){
            component.set("v.ReceiptDate3", true);
        } else{
            helper.getNumericValidate(component,event,newReceiptDate3,"v.ReceiptDate3");
        } 
    },
	handleReceiptDate4 : function(component,event,helper) {
        var newReceiptDate4 = component.get("v.newReceiptDate4");
        if(newReceiptDate4 != '' && newReceiptDate4.length != 8){
            component.set("v.ReceiptDate4", true);
        } else{
            helper.getNumericValidate(component,event,newReceiptDate4,"v.ReceiptDate4");
        } 
    },
	handleReceiptDate5 : function(component,event,helper) {
        var newReceiptDate5 = component.get("v.newReceiptDate5");
        if(newReceiptDate5 != '' && newReceiptDate5.length != 8){
            component.set("v.ReceiptDate5", true);
        } else{
            helper.getNumericValidate(component,event,newReceiptDate5,"v.ReceiptDate5");
        } 
    },
	handleReceiptDate6 : function(component,event,helper) {
        var newReceiptDate6 = component.get("v.newReceiptDate6");
        if(newReceiptDate6 != '' && newReceiptDate6.length != 8){
            component.set("v.ReceiptDate6", true);
        } else{
            helper.getNumericValidate(component,event,newReceiptDate6,"v.ReceiptDate6");
        } 
    },
	handleReceiptDate7 : function(component,event,helper) {
        var newReceiptDate7 = component.get("v.newReceiptDate7");
        if(newReceiptDate7 != '' && newReceiptDate7.length != 8){
            component.set("v.ReceiptDate7", true);
        } else{
            helper.getNumericValidate(component,event,newReceiptDate7,"v.ReceiptDate7");
        } 
    },
	handleReceiptDate8 : function(component,event,helper) {
        var newReceiptDate8 = component.get("v.newReceiptDate8");
        if(newReceiptDate8 != '' && newReceiptDate8.length != 8){
            component.set("v.ReceiptDate8", true);
        } else{
            helper.getNumericValidate(component,event,newReceiptDate8,"v.ReceiptDate8");
        } 
    },
	handleReceiptDate9 : function(component,event,helper) {
        var newReceiptDate9 = component.get("v.newReceiptDate9");
        if(newReceiptDate9 != '' && newReceiptDate9.length != 8){
            component.set("v.ReceiptDate9", true);
        } else{
            helper.getNumericValidate(component,event,newReceiptDate9,"v.ReceiptDate9");
        } 
    },
	handleReceiptDate10 : function(component,event,helper) {
        var newReceiptDate10 = component.get("v.newReceiptDate10");
        if(newReceiptDate10 != '' && newReceiptDate10.length != 8){
            component.set("v.ReceiptDate10", true);
        } else{
            helper.getNumericValidate(component,event,newReceiptDate10,"v.ReceiptDate10");
        } 
    },
    handleReceiveRate1 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.receiveRate1","v.recRate1");
        helper.getRateValueCheck(component,event,"v.receiveRate1","v.recRate1");
    },
    handleReceiveRate2 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.receiveRate2","v.recRate2");
        helper.getRateValueCheck(component,event,"v.receiveRate2","v.recRate2");
    },
    handleReceiveRate3 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.receiveRate3","v.recRate3");
        helper.getRateValueCheck(component,event,"v.receiveRate3","v.recRate3");
    },
	handleReceiveRate4 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.receiveRate4","v.recRate4");
        helper.getRateValueCheck(component,event,"v.receiveRate4","v.recRate4");
    },
	handleReceiveRate5 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.receiveRate5","v.recRate5");
        helper.getRateValueCheck(component,event,"v.receiveRate5","v.recRate5");
    },
	handleReceiveRate6 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.receiveRate6","v.recRate6");
        helper.getRateValueCheck(component,event,"v.receiveRate6","v.recRate6");
    },
	handleReceiveRate7 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.receiveRate7","v.recRate7");
        helper.getRateValueCheck(component,event,"v.receiveRate7","v.recRate7");
    },
	handleReceiveRate8 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.receiveRate8","v.recRate8");
        helper.getRateValueCheck(component,event,"v.receiveRate8","v.recRate8");
    },
	handleReceiveRate9 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.receiveRate9","v.recRate9");
        helper.getRateValueCheck(component,event,"v.receiveRate9","v.recRate9");
    },
	handleReceiveRate10 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.receiveRate10","v.recRate10");
        helper.getRateValueCheck(component,event,"v.receiveRate10","v.recRate10");
    },
	handleNoOfCopies : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.numberOfCopies","v.noOfCopiesErr");
    }
})