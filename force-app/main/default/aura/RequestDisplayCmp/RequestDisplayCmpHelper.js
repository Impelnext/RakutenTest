({
	getContractInfo : function(component, event) { 
      
        component.set('v.contractColumns', [
                    {label: '注意', fieldName: 'note', type: 'text'},
                    {label: 'ステータス', fieldName: 'status', type: 'text'},
                    {label: '証券番号/会員番号/契約管理番号', fieldName: 'policyNumber', type: 'text'},
                    {label: '契約者氏名', fieldName: 'contractorName', type: 'text'},
                    {label: '被保険者氏名', fieldName: 'insurerName', type: 'text'},
                    {label: '保険種類', fieldName: 'insuranceType', type: 'text'},
                    {label: '保険期間', fieldName: 'insurancePeriod', type: 'text'},
                    {label: '保険始期/契約日', fieldName: 'contractEstablishedDate', type: 'text'},
                    {label: '保険金額', fieldName: 'amount', type: 'text'},
                    {label: '保険料', fieldName: 'premium', type: 'text'},
                    {label: '保険の目的', fieldName: 'insurancePurpose', type: 'text'},
                    {label: '保険対象区分', fieldName: 'insuredDivision', type: 'text'},
                    {label: '登録番号', fieldName: 'carNumber', type: 'text'}
                ]);
		var pageReference = component.get("v.pageReference");
		var receptionId = pageReference.state.c__receptionId;
        var action = component.get("c.getContractInfo");
        action.setParams({
            receptionId :  receptionId
        });
		action.setCallback(this, function(response) {
            var result = response.getState();
            var contractList = [];
            if(result === "SUCCESS"){
                var recepContractDetails = response.getReturnValue();
                component.set("v.contractList", response.getReturnValue().contractList);
                component.set("v.accountId",response.getReturnValue().accountId);
                component.set("v.recContractWrapper", recepContractDetails);
                var requestSubTab = component.find("RequestSubTab");
                requestSubTab.getFocusedTabInfo().then(function (response){
                    var focusedTabId = response.tabId;
                    requestSubTab.setTabLabel({ 
                        tabId : focusedTabId,
                        label : "新規リクエスト"
                    });
                });
            }
        });
		$A.enqueueAction(action);
	},
    getSubjectPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Subject__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var subjectPickMap = [];
                for(var key in result){
                    subjectPickMap.push({key: key, value: result[key]});
                }
                component.set("v.subjectPickMap", subjectPickMap);
            }
        });
        $A.enqueueAction(action);
    },
    
    getStatusPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Status__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var statusPickMap = [];
                for(var key in result){
                    statusPickMap.push({key: key, value: result[key]});
                }
                component.set("v.statusPickMap", statusPickMap);
            }
        });
        $A.enqueueAction(action);
    },
    
    getPriorityPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Priority__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var priorityPickMap = [];
                for(var key in result){
                    priorityPickMap.push({key: key, value: result[key]});
                }
                component.set("v.priorityPickMap", priorityPickMap);
                component.find("priorityPicklist").set("v.value","中");
            }
        });
        $A.enqueueAction(action);
    },
    
    reportButtonDisplay: function(component,event){
        var receptionId = component.get("v.pageReference").state.c__receptionId;
        var action = component.get("c.getReportButtonDisplay");
        action.setParams({ receptionId : receptionId});
        action.setCallback(this,function(response){
            var result = response.getState();
            if(result === "SUCCESS"){
                var map = response.getReturnValue();
			    for(var key in map){
                    if(key === "SEIHO" && map[key]){
                        component.find("btnSeihoHozen").set("v.disabled", false);
                    }
                    if(key === "SEIHO" && map[key]){
                        component.find("btnSeihoHokenkin").set("v.disabled", false);
                    }
                    if(key === "SEIHO_TOKUYAKU" && map[key]){
                        component.find("btnSeihoTokuyaku").set("v.disabled", false);
                    }
                    if(key === "SONPO" && map[key]){
                        component.find("btnSonpo").set("v.disabled", false);
                    }
                    if(key === "SYOTAN" && map[key]){
                        component.find("btnSyotan").set("v.disabled", false);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    //handle Save
    saveRequest : function(component, event) {
        // Double click prevention
        var bel=document.getElementsByClassName("slds-backdrop");
        var bl=bel.length;
        for(var cnt=0;cnt<bl;cnt++){
            bel[cnt].classList.add('slds-backdrop_open');
        }

        var receptionId = component.get("v.pageReference").state.c__receptionId;
        var req = component.get("v.newRequest");
        var policyNumbers = component.get("v.policyNumberList");
        //For display error message
        var NonRelatedContractCheck = component.get("v.newRequest.NonRelatedContractCheck__c");
        var selectedRows = component.get("v.rowsSelectedId");
        if(selectedRows.length > 1 ){
            req.MultiRequestFlag__c = true;
        }else{
            req.MultiRequestFlag__c = false;
        }
        var showSelectedContract = false;
        if(selectedRows.length > 0 || NonRelatedContractCheck){
            showSelectedContract = false;
        }else{
            showSelectedContract = true;
            component.find("btnFocus").set("v.disabled", false);
            component.find('btnFocus').focus();
            component.find("btnFocus").set("v.disabled", true);
        }
        component.set("v.showSelectedContract",showSelectedContract);
        var selectedType = component.get("v.selectedType");
        var subject = component.get("v.newRequest.Subject__c");
        if(subject != ''){
            if(selectedType == 'AddressChange'){
            component.get("v.body")[2].addressChange(req);
            }
            else if(selectedType == 'NameChange'){
                component.get("v.body")[2].inlineNameChange(req);
            }
            else if(selectedType == 'PhoneChange'){
                component.get("v.body")[2].phoneNumberChange(req);
            }else if(selectedType == 'MailAddrChange'){
                component.get("v.body")[2].mailAddrChange(req);
            }else if(selectedType == 'SupportRequest'){
                component.get("v.body")[2].supportRequest(req);
            }else if(selectedType == 'InformationLinkage'){
                component.get("v.body")[2].informationLinkage(req);
            }else if(selectedType == 'Complaint'){
                component.get("v.body")[2].complaints(req);
            }
            //Onyx - Passing Variables to the child cmp
            else if(selectedType == 'TabletTeamViewer'){
                component.get("v.body")[2].TabletTeamViewer(req); 
                
            }
            else if(selectedType == 'VoiceRegistration'){
                component.get("v.body")[2].VoiceRegistration(req); 
                
            }
            else if(selectedType == 'NewContract'){
                component.get("v.body")[2].NewContract(req);             
            }
            else if(selectedType == 'Storage'){
                component.get("v.body")[2].Storage(req);           
            }
             else if(selectedType == 'RakutenIdCooperation'){
                component.get("v.body")[2].InquiryTyp(req);           
            }
            else if(selectedType == 'InquiryCaseType'){
                component.get("v.body")[2].InquiryTyp(req);           
            }
            else if(selectedType == 'UpdateInquiry'){
                component.get("v.body")[2].InquiryTyp(req);           
            }
            else if(selectedType == 'FollowResponse'){
             if(subject == '口座不備'){
            	 component.get("v.body")[2].InsufficientAccount(req);
              }	
               else if(subject == 'お客様対応依頼'){
            	 component.get("v.body")[2].CustomerResponseRequest(req);             
               }    
               else if(subject == '継続フォロー'||subject == '解約メール'){
            	 component.get("v.body")[2].CancellationEmail(req);           
               }    
           }
            //Picklist 2
            //Onyx for InquiryType chilp cmp call
            else if(selectedType == 'InquiryType'){ 
                component.get("v.body")[2].InquiryTyp(req);
            }
            else if(selectedType == 'InsuranceClaims'){ 
                component.get("v.body")[2].requestInsuranceClaims(req);
            }else if(selectedType == 'Cancellation'){
                component.get("v.body")[2].inlineRequestCancel(req);
            }else if(selectedType == 'SpecialContractReduction'){
                component.get("v.body")[2].specialContractReduction(req);
                //Policy NUmber Validaton
                this.policyNumberValidationHandle(component,event,req,policyNumbers);
            }else if(selectedType == 'SecuritiesReissue'){
                component.get("v.body")[2].securitiesReissue(req);
            }else if(selectedType == 'RejectUpdate'){
                component.get("v.body")[2].inlineRequestRejectUpdate(req);
            }else if(selectedType == 'DeductionReissue'){
                component.get("v.body")[2].deductionReissue(req);
            }else if(selectedType == 'InlineOverseasTravel'){
                component.get("v.body")[2].inlineOverseasTravel(req);
            }else if(selectedType == 'inlineRequestAlphaReplacement'){
                component.get("v.body")[2].inlineRequestAlphaReplacement(req);
            }else if(selectedType == 'inlineRefundAccount'){
                component.get("v.body")[2].inlineRefundAccount(req);
            }else if(selectedType == 'inlineInquirycase'){
                component.get("v.body")[2].inlineInquirycase(req);
            }else if(selectedType == 'inlineRequestReduction'){
                component.get("v.body")[2].inlineRequestReduction(req);
                 //Policy Number Validaton
                this.policyNumberValidationHandle(component,event,req,policyNumbers);
            }else if(selectedType == 'inlineReducemouth'){
                component.get("v.body")[2].inlineReducemouth(req,policyNumbers);
            }else if(selectedType == 'inlineDocumentshippingcase'){
                component.get("v.body")[2].inlineDocumentshippingcase(req);
            }else if(selectedType == 'inlineRequestChangedesignatedagent'){
                component.get("v.body")[2].inlineRequestChangedesignatedagent(req);
                //Policy Number Validaton
                this.policyNumberValidationHandle(component,event,req,policyNumbers);
            }else if(selectedType == 'inlineRecipientlifeinsurance'){
                component.get("v.body")[2].inlineRecipientlifeinsurance(req);
                 //Policy Number Validaton
                this.policyNumberValidationHandle(component,event,req,policyNumbers);
            }else if(selectedType == 'inlineRequestReductionatRenewal'){
                component.get("v.body")[2].inlineRequestReductionatRenewal(req);
                 //Policy Number Validaton
                this.policyNumberValidationHandle(component,event,req,policyNumbers);
            }else if(selectedType == 'inlineRequestInlineRenewalexit'){
                component.get("v.body")[2].inlineRequestInlineRenewalexit(req);
                 //Policy Number Validaton
                this.policyNumberValidationHandle(component,event,req,policyNumbers);
            }else if(selectedType == 'inlineRetention'){
                component.get("v.body")[2].inlineRetention(req);
                component.set("v.showErrorToStopSavePolicy",false);
                if(req.Ret10_PolicyNumber__c != '' && (req.Ret9_PolicyNumber__c == '' || req.Ret8_PolicyNumber__c == '' || req.Ret7_PolicyNumber__c == '' || req.Ret6_PolicyNumber__c == '' || req.Ret5_PolicyNumber__c == '' || req.Ret4_PolicyNumber__c == '' || req.Ret3_PolicyNumber__c == '' || req.Ret2_PolicyNumber__c == '' || req.Ret1_PolicyNumber__c == '')){
                     this.policyNumberErrorHandling(component,event);
                }
                else if(req.Ret10_PolicyNumber__c != ''){
                    this.getPolicyNumberValidateRtn(component,event,req.Ret10_PolicyNumber__c,policyNumbers,"v.policyNumber10Error");
                }
                if(req.Ret9_PolicyNumber__c != '' && (req.Ret8_PolicyNumber__c == '' || req.Ret7_PolicyNumber__c == '' || req.Ret6_PolicyNumber__c == '' || req.Ret5_PolicyNumber__c == '' || req.Ret4_PolicyNumber__c == '' || req.Ret3_PolicyNumber__c == '' || req.Ret2_PolicyNumber__c == '' || req.Ret1_PolicyNumber__c == '')){
                     this.policyNumberErrorHandling(component,event);
                }
                else if(req.Ret9_PolicyNumber__c != ''){
                    this.getPolicyNumberValidateRtn(component,event,req.Ret9_PolicyNumber__c,policyNumbers,"v.policyNumber9Error");
                }
                if(req.Ret8_PolicyNumber__c != '' && (req.Ret7_PolicyNumber__c == '' || req.Ret6_PolicyNumber__c == '' || req.Ret5_PolicyNumber__c == '' || req.Ret4_PolicyNumber__c == '' || req.Ret3_PolicyNumber__c == '' || req.Ret2_PolicyNumber__c == '' || req.Ret1_PolicyNumber__c == '')){
                    this.policyNumberErrorHandling(component,event);
                }
                else if(req.Ret8_PolicyNumber__c != ''){
                    this.getPolicyNumberValidateRtn(component,event,req.Ret8_PolicyNumber__c,policyNumbers,"v.policyNumber8Error");
                }
                if(req.Ret7_PolicyNumber__c != '' && (req.Ret6_PolicyNumber__c == '' || req.Ret5_PolicyNumber__c == '' || req.Ret4_PolicyNumber__c == '' || req.Ret3_PolicyNumber__c == '' || req.Ret2_PolicyNumber__c == '' || req.Ret1_PolicyNumber__c == '')){
                    this.policyNumberErrorHandling(component,event); 
                }
                else if(req.Ret7_PolicyNumber__c != ''){
                    this.getPolicyNumberValidateRtn(component,event,req.Ret7_PolicyNumber__c,policyNumbers,"v.policyNumber7Error");
                }
                if(req.Ret6_PolicyNumber__c != '' && (req.Ret5_PolicyNumber__c == '' || req.Ret4_PolicyNumber__c == '' || req.Ret3_PolicyNumber__c == '' || req.Ret2_PolicyNumber__c == '' || req.Ret1_PolicyNumber__c == '')){
                    this.policyNumberErrorHandling(component,event); 
                }
                else if(req.Ret6_PolicyNumber__c != ''){
                    this.getPolicyNumberValidateRtn(component,event,req.Ret6_PolicyNumber__c,policyNumbers,"v.policyNumber6Error");
                }
                if(req.Ret5_PolicyNumber__c != '' && (req.Ret4_PolicyNumber__c == '' || req.Ret3_PolicyNumber__c == '' || req.Ret2_PolicyNumber__c == '' || req.Ret1_PolicyNumber__c == '')){
                    this.policyNumberErrorHandling(component,event); 
                }
                else if(req.Ret5_PolicyNumber__c != ''){
                    this.getPolicyNumberValidateRtn(component,event,req.Ret5_PolicyNumber__c,policyNumbers,"v.policyNumber5Error");
                }
                 if(req.Ret4_PolicyNumber__c != '' && (req.Ret3_PolicyNumber__c == '' || req.Ret2_PolicyNumber__c == '' || req.Ret1_PolicyNumber__c == '')){
                     this.policyNumberErrorHandling(component,event);
                }
                else if(req.Ret4_PolicyNumber__c != ''){
                    this.getPolicyNumberValidateRtn(component,event,req.Ret4_PolicyNumber__c,policyNumbers,"v.policyNumber4Error");
                }
                if(req.Ret3_PolicyNumber__c != '' && (req.Ret2_PolicyNumber__c == '' || req.Ret1_PolicyNumber__c == '')){
                     this.policyNumberErrorHandling(component,event);
                }
                else if(req.Ret3_PolicyNumber__c != ''){
                    this.getPolicyNumberValidateRtn(component,event,req.Ret3_PolicyNumber__c,policyNumbers,"v.policyNumber3Error");
                }
                if(req.Ret2_PolicyNumber__c != '' && req.Ret1_PolicyNumber__c == ''){
                     this.policyNumberErrorHandling(component,event);
                }
                else if(req.Ret2_PolicyNumber__c != ''){
                    this.getPolicyNumberValidateRtn(component,event,req.Ret2_PolicyNumber__c,policyNumbers,"v.policyNumber2Error");
                }
                if(req.Ret1_PolicyNumber__c != ''){
                    this.getPolicyNumberValidateRtn(component,event,req.Ret1_PolicyNumber__c,policyNumbers,"v.policyNumber1Error");
                }
            }else if(selectedType == 'inlineRequestReductionMutualAid'){
                component.get("v.body")[2].inlineRequestReductionMutualAid(req);
                 //Policy Number Validaton
                this.policyNumberValidationHandle(component,event,req,policyNumbers);
            }else if(selectedType == 'inlineRecipientmutualaid'){
                component.get("v.body")[2].inlineRecipientmutualaid(req);
                 //Policy Number Validaton
                this.policyNumberValidationHandle(component,event,req,policyNumbers);
            }else if(selectedType == 'inlineSpecialCancellation'){
                component.get("v.body")[2].inlineSpecialCancellation(req);
                 //Policy Number Validaton
                this.policyNumberValidationHandle(component,event,req,policyNumbers);
            } else if (selectedType == 'accidentFreeBenefit') {
                component.get("v.body")[2].accidentFreeBenefit(req);
                //Policy Number Validaton
               this.policyNumberValidationHandle(component,event,req,policyNumbers);
            }
            //Picklist 3
            else if(selectedType == 'inlineSSAcdntReception'){
                component.get("v.body")[2].inlineSSAcdntReception(req);
            }else if(selectedType == 'inlineSSAccRecResponsibility'){
                component.get("v.body")[2].inlineSSAccRecResponsibility(req);
           }else if(selectedType == 'inlineInsOtherThanAcdntRecpton'){
                component.get("v.body")[2].inlineInsOtherThanAcdntRecpton(req);
           }else if(selectedType == 'inlineUpdateChange'){
                component.get("v.body")[2].inlineUpdateChange(req);
           }else if(selectedType == 'inlineRejectUpdateShort'){
                component.get("v.body")[2].inlineRejectUpdateShort(req);
           }else if(selectedType == 'inlineReleaseLessShort'){
                component.get("v.body")[2].inlineReleaseLessShort(req);
           }else if(selectedType == 'inlineRetentionShort'){
                component.get("v.body")[2].inlineRetentionShort(req);
           }else if(selectedType == 'inlineTransferPaperResend'){
                component.get("v.body")[2].inlineTransferPaperResend(req);
           }else if(selectedType == 'inlineResendSecuritiesUpdates'){
                component.get("v.body")[2].inlineResendSecuritiesUpdates(req);
           }else if(selectedType == 'inlineAppliContntChngAndMultiheadSupp'){
                component.get("v.body")[2].inlineAppliContntChngAndMultiheadSupp(req);
           }else if(selectedType == 'inlineChangeContractDetails'){
                component.get("v.body")[2].inlineChangeContractDetails(req);
           }else if(selectedType == 'inlineSSInquiryCase'){
                component.get("v.body")[2].inlineSSInquiryCase(req);
           }else if(selectedType == 'inlineGeneralPurpose'){
                component.get("v.body")[2].inlineGeneralPurpose(req);
           }
            //Picklist 4
            else if(selectedType == 'inlineSimultaneousChangOfAddrsCmp'){
                component.get("v.body")[2].inlineSimultaneousChangOfAddrsCmp(req);
            }else if(selectedType == 'inlineVehicleReplacement'){
                component.get("v.body")[2].inlineVehicleReplacement(req);
            }else if(selectedType == 'inlineInsurancePolicyReissue'){
                component.get("v.body")[2].inlineInsurancePolicyReissue(req);
            }else if(selectedType == 'inlineReissueApproval'){
                component.get("v.body")[2].inlineReissueApproval(req);
            }else if(selectedType == 'inlineReissuanceCertificateReissueCmp'){
                component.get("v.body")[2].inlineReissuanceCertificateReissueCmp(req);
            }else if(selectedType == 'inlineCycleAssistContReissue'){
                component.get("v.body")[2].inlineCycleAssistContReissue(req);
            }else if(selectedType == 'inlineLivingAssistContReissue'){
                component.get("v.body")[2].inlineLivingAssistContReissue(req);
            }else if(selectedType == 'inlineIssuanceOfSusCertificate'){
                component.get("v.body")[2].inlineIssuanceOfSusCertificate(req);
            }else if(selectedType == 'inlineReissueCertForSuspension'){
                component.get("v.body")[2].inlineReissueCertForSuspension(req);
            }else if(selectedType == 'inlineCancellationCarCmp'){
                component.get("v.body")[2].inlineCancellationCarCmp(req);
            }else if(selectedType == 'inlineCancellationFire'){
                component.get("v.body")[2].inlineCancellationFire(req);
            }else if(selectedType == 'inlineCancellationInjuryCmp'){
                component.get("v.body")[2].inlineCancellationInjuryCmp(req);
            }else if(selectedType == 'inlineCancellationJump'){
                component.get("v.body")[2].inlineCancellationJump(req);
            }else if(selectedType == 'inlineTargetLocationChangeFireorMaturityreturn'){
                component.get("v.body")[2].inlineTargetLocationChangeFireorMaturityreturn(req);
            }else if(selectedType == 'inlineChangeModelCmp'){
                component.get("v.body")[2].inlineChangeModelCmp(req);
            }else if(selectedType == 'inlineRegistrationNumberChangecar'){
                component.get("v.body")[2].inlineRegistrationNumberChangecar(req);
            }else if(selectedType == 'inlineInsuranceAmountChange'){
                component.get("v.body")[2].inlineInsuranceAmountChange(req);
            }else if(selectedType == 'inlineConditionChangeAutomobileCmp'){
                component.get("v.body")[2].inlineConditionChangeAutomobileCmp(req);
            }else if(selectedType == 'inlineTotalLossEffect'){
                component.get("v.body")[2].inlineTotalLossEffect(req);
            }else if(selectedType == 'inlineStructuralUsageAreaChngCmp'){
                component.get("v.body")[2].inlineStructuralUsageAreaChngCmp(req);
            }else if(selectedType == 'inlineChangeOccupationTypeCls'){
                component.get("v.body")[2].inlineChangeOccupationTypeCls(req);
            }else if(selectedType == 'inlineRightsTransferCmp'){
                component.get("v.body")[2].inlineRightsTransferCmp(req);
            }else if(selectedType == 'inlineOwnerNameChangeCmp'){
                component.get("v.body")[2].inlineOwnerNameChangeCmp(req);
            }else if(selectedType == 'inlineIncrease'){
                component.get("v.body")[2].inlineIncrease(req);
            }else if(selectedType == 'inlinePledgeSettingOrDeletion'){
                component.get("v.body")[2].inlinePledgeSettingOrDeletion(req);
            }else if(selectedType == 'inlineGradeCorrectionCmp'){
                component.get("v.body")[2].inlineGradeCorrectionCmp(req);
            }else if(selectedType == 'inlineInsuredPersonChangeCmp'){
                component.get("v.body")[2].inlineInsuredPersonChangeCmp(req);
            }else if(selectedType == 'inlineIssuanceAttachedCrtfct'){
                component.get("v.body")[2].inlineIssuanceAttachedCrtfct(req);
            }else if(selectedType == 'inlineAccountCrecaChange'){
                component.get("v.body")[2].inlineAccountCrecaChange(req);
            }else if(selectedType == 'inlinePaymentConfirmation'){
                component.get("v.body")[2].inlinePaymentConfirmation(req);
            }else if(selectedType == 'inlineNewOngoingMidContract'){
                component.get("v.body")[2].inlineNewOngoingMidContract(req);
            }else if(selectedType == 'inlineGeneralPurposeNonlife'){
                component.get("v.body")[2].inlineGeneralPurposeNonlife(req);
            }else if(selectedType == 'inlineInquiryCaseNonlife'){
                component.get("v.body")[2].inlineInquiryCaseNonlife(req);
            }
        }
        var stopSaving = component.get("v.showErrorToStopSave");
		var showErrorToStopSavePolicy = component.get("v.showErrorToStopSavePolicy");
        
        if(!(stopSaving || showSelectedContract || showErrorToStopSavePolicy)){
        	var action = component.get("c.saveRequest");
            var requestSubTab = component.find("RequestSubTab");
            var accountId = component.get("v.accountId");
            action.setParams({
                req : req,
                receptionId : receptionId,
                accountId : accountId,
                selectPolicyNumbers : policyNumbers
            });
            action.setCallback(this,function(response){
                var self = this;
                var state = response.getState();
                // Remove the mask
                var bel=document.getElementsByClassName("slds-backdrop");
                var bl=bel.length;
                for(var cnt=0;cnt<bl;cnt++){
                    bel[cnt].classList.remove('slds-backdrop_open');
                }
        
                
                if(state === "SUCCESS"){
                    alert('リクエスト情報を作成しました');
                    var reqDetails = response.getReturnValue();
                    //createCaseForContract
                    this.createCaseForContract(component, reqDetails.Id);
                    requestSubTab.getFocusedTabInfo().then(function (focusedTabResponse){
                        var focusedTabId = focusedTabResponse.tabId;
                        var parentTabId = focusedTabResponse.parentTabId;
                        requestSubTab.openSubtab({
                            parentTabId : parentTabId,
                            recordId : reqDetails.Id,
                            focus :true
                        }).then(function (openSubTabresponse){
                            requestSubTab.setTabLabel({
                                tabId: openSubTabresponse,
                                label: reqDetails.Name
                            });
                            self.closeOpenTab(component,focusedTabResponse,focusedTabId);
                        });
                    });
                }else if(state === "ERROR"){
                    var errors = action.getError();
                    if (errors) { 
                        if (errors[0] && errors[0].message) {
                            component.set("v.showError",true);
                            component.set("v.errorMessage",errors[0].message);
                            self.setInitFocus(component,event);
                        }
                    }
                }else if (status === "INCOMPLETE") {
                    alert('サーバーからレスポンスがありません');
                }
            });
            $A.enqueueAction(action);
        } else {
            // Remove the mask
            var bel=document.getElementsByClassName("slds-backdrop");
            var bl=bel.length;
            for(var cnt=0;cnt<bl;cnt++){
                bel[cnt].classList.remove('slds-backdrop_open');
            }
                        
        }
    },
    
    fetchPicklistValues: function(component,event) {
        // call the server side function  
        var action = component.get("c.getDependentMap");
        // pass paramerters
        // to server side function 
        action.setParams({
            "objDetail" : 'Request__c',
            "contrfieldApiName" : 'Class__c',
            "depfieldApiName" : 'Type__c' 
        });
        //set callback
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                // once set #StoreResponse to depnedentFieldMap attribute 
                component.set("v.depnedentFieldMap",StoreResponse);
                
                // create a empty array for store map keys(@@--->which is controller picklist values) 
                var listOfkeys = [];// for store all map keys (controller picklist values)
                var ControllerField = [];// for store controller picklist value to set on lightning:select. 
                
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                
                //set the controller field value for lightning:select
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push('--- None ---');
                }
                
                for (var i = 0;i < listOfkeys.length;i++) {
                    ControllerField.push(listOfkeys[i]);
                }
                // set the ControllerField variable values (controller picklist field)
                component.set("v.listControllingValues", ControllerField);
				//Sub Dependant
				this.getDepSubPickList(component,'Request__c','Type__c','Subject__c',"v.subjectDependentFieldMap");
				
            }else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }
        });
        
        //getting dependency as API Names
        var actionAPI = component.get("c.getDependentAPIMap");
        
        actionAPI.setParams({
            "objDetail" : 'Request__c',
            "contrfieldApiName" : 'Class__c',
            "depfieldApiName" : 'Type__c' 
        });
        //set callback
        actionAPI.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var Response = response.getReturnValue();
                // once set #StoreResponse to depnedentFieldMap attribute 
                component.set("v.depnedentFieldAPIMap",Response);
            }
        });
     
        $A.enqueueAction(action);
        $A.enqueueAction(actionAPI);
    },
    
    getPolicyNumberValidate: function(component,event,PolicyNumber,policyNumberList,policyNumberError){
		var nonRelatedContractCheck = component.get("v.newRequest.NonRelatedContractCheck__c");
        var IntNonRelatedContractCheck = 0;
        if(nonRelatedContractCheck){
            IntNonRelatedContractCheck = 1;
        }
        var action = component.get("c.getPolicyNumberValidate");
        action.setParams({ "givenValue" : PolicyNumber,
                          "policyNumberList": policyNumberList,
						  "nonRelatedContractCheck": IntNonRelatedContractCheck});
        //set callback
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var StoreResponse = response.getReturnValue();
            }
            else if(response.getState() === "ERROR"){
                var errors = action.getError();
                component.set("v.policyNumberErrorDisplay",true);
                component.set("v.errorMessagePolicyNumber",errors[0].message);
                component.find('btnSeihoHozen').focus();
                self.setInitFocus(component,event);
            }
        });
        $A.enqueueAction(action);
    },
    
	getPolicyNumberValidateRtn: function(component,event,PolicyNumber,policyNumberList,policyNumberError){
		var nonRelatedContractCheck = component.get("v.newRequest.NonRelatedContractCheck__c");
        var IntNonRelatedContractCheck = 0;
        if(nonRelatedContractCheck){
            IntNonRelatedContractCheck = 1;
        }
        var action = component.get("c.getPolicyNumberValidateRetention");
        action.setParams({ "givenValue" : PolicyNumber,
                          "policyNumberList": policyNumberList,
						  "nonRelatedContractCheck": IntNonRelatedContractCheck});
        //set callback
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var StoreResponse = response.getReturnValue();
            }
            else if(response.getState() === "ERROR"){
                var errors = action.getError();
                component.set("v.policyNumberErrorDisplay",true);
                component.set("v.errorMessagePolicyNumber",errors[0].message);
                component.find('btnSeihoHozen').focus();
                self.setInitFocus(component,event);
            }
        });
        $A.enqueueAction(action);
    },
    
    closeOpenTab :  function (component, focusedTabResponse,focusedTabId){
        var requestSubTab = component.find("RequestSubTab");
        requestSubTab.closeTab({ tabId : focusedTabId});
    },
    
	policyNumberErrorHandling: function(component,event){
		component.set("v.showErrorToStopSavePolicy",true);
		component.set("v.policyNumberErrorDisplay",true);
		component.set("v.errorMessagePolicyNumber","証券番号をスキップして入力できません。例：証券番号1を入力せず、証券番号2を入力する。");
		component.find('btnSeihoHozen').focus();
	},
	
    fetchDepValues: function(component, ListOfDependentFields, listDependingValues) {
        component.find("subjectPicklist").set("v.value","");
        // create a empty array var for store dependent picklist values for controller field
        var dependentFields = [];
        if(ListOfDependentFields.length != 1){
           dependentFields.push('--- None ---');
        }else{
            var firstValue = ListOfDependentFields[0];
            component.find("subjectPicklist").set("v.value",firstValue);
        }
        for (var i = 0;i < ListOfDependentFields.length;i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set(listDependingValues, dependentFields);
    },
    
    fetchDepValuesSub: function(component, ListOfDependentFields,listSubDependingValues) {
        // create a empty array var for store dependent picklist values for controller field
        var dependentFields = [];
        dependentFields.push('--- None ---');
        for (var i = 0;i < ListOfDependentFields.length;i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set(listSubDependingValues, dependentFields);
        
    },
    
    createDynamicComponent: function(component,dynamicCmpName, attribute, responseName){
        var db=component.find("childCmp");
        $A.createComponent(dynamicCmpName,attribute,function(responseName,status, errorMessage){
            if (status === "SUCCESS") {  
                var body = component.get("v.body");
                body.push([]);
                body.push(responseName);
                component.set("v.body", body);
            }else{
                alert('ErrorMessage ' + errorMessage);
            }
        });
        
    },
    
    createCaseForContract: function (component, requestId) {
        var selectedContractIds =  component.get("v.rowsSelectedId");
        //Pass Params to Controller 
        var action = component.get("c.createCase");
		action.setParams({
			"contractIds" : selectedContractIds,
            "requestId" : requestId
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
            }
        });
        $A.enqueueAction(action);
    },
    
	getDepSubPickList :function(component,object,depField,subDepField,setResultMap){
		var subDepAction = component.get("c.getDependentMap");
		subDepAction.setParams({
			objDetail : object,
			contrfieldApiName : depField,
			depfieldApiName : subDepField
		});
		subDepAction.setCallback(this, function(subDepResponse){

			if(subDepResponse.getState() === "SUCCESS"){
				var depSubResponse = subDepResponse.getReturnValue();
                component.set(setResultMap, depSubResponse);
			}
		});
		$A.enqueueAction(subDepAction);
    },
    
    setInitFocus: function(component,event) {
        component.find("btnSeihoHozen").set("v.disabled", false);
        var fields = component.find('btnSeihoHozen');
        Array.isArray(fields) ? fields[0].focus() : fields.focus();
        //component.find("btnSeihoHozen").set("v.disabled", true);
        self.getButtonReportNavigation(component,event);
	},
	
    showHide : function(component) {
        var editForm = component.find("editForm");
        $A.util.toggleClass(editForm, "slds-hide");
        var viewForm = component.find("viewForm");
		$A.util.toggleClass(viewForm, "slds-hide");
    },
    
    getButtonReportNavigation: function(component, event) {
        var pageReference = component.get("v.pageReference");
		var receptionId = pageReference.state.c__receptionId;
        var action = component.get("c.getAccountContract");
        action.setParams({ receptionId : receptionId});
        action.setCallback(this,function(response){
            var result = response.getState();
            if(result === "SUCCESS"){
                var map = response.getReturnValue();
                for(var key in map){
                    if(key === "SEIHO" && map[key]){
                        component.find("btnSeihoHozen").set("v.disabled", false);
                    }
                    if(key === "SEIHO" && map[key]){
                        component.find("btnSeihoHokenkin").set("v.disabled", false);
                    }
                    if(key === "SEIHO_TOKUYAKU"  && map[key]){ 
                        component.find("btnSeihoTokuyaku").set("v.disabled", false);
                    }
                    if(key === "SONPO" && map[key]){
                        component.find("btnSonpo").set("v.disabled", false);
                    }
                    if(key === "SYOTAN" && map[key]){
                        component.find("btnSyotan").set("v.disabled", false);
                    }
                    if(key !== "SEIHO" && key !== "SEIHO_TOKUYAKU" && key !== "SYOTAN" && key !== "SONPO" ){
                        component.set("v.accountId",key);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    
	policyNumberValidationHandle: function(component,event,req,policyNumbers){
		component.set("v.showErrorToStopSavePolicy",false);
		if(req.PolicyNumber10__c != '' && ( req.PolicyNumber9__c == '' || req.PolicyNumber8__c == '' || req.PolicyNumber7__c == '' || req.PolicyNumber6__c == '' || req.PolicyNumber5__c == '' || req.PolicyNumber4__c == '' || req.PolicyNumber3__c == '' || req.PolicyNumber2__c == '' || req.PolicyNumber1__c == '')){
			this.policyNumberErrorHandling(component,event);
		}
		else if(req.PolicyNumber10__c != ''){
			this.getPolicyNumberValidate(component,event,req.PolicyNumber10__c,policyNumbers,"v.policyNumber10Error");
		}
		if(req.PolicyNumber9__c != '' && (req.PolicyNumber8__c == '' || req.PolicyNumber7__c == '' || req.PolicyNumber6__c == '' || req.PolicyNumber5__c == '' || req.PolicyNumber4__c == '' || req.PolicyNumber3__c == '' || req.PolicyNumber2__c == '' || req.PolicyNumber1__c == '')){
			this.policyNumberErrorHandling(component,event);
		}
		else if(req.PolicyNumber9__c != '') {
			this.getPolicyNumberValidate(component,event,req.PolicyNumber9__c,policyNumbers,"v.policyNumber9Error");
		}
		if(req.PolicyNumber8__c != '' && (req.PolicyNumber7__c == '' || req.PolicyNumber6__c == '' || req.PolicyNumber5__c == '' || req.PolicyNumber4__c == '' || req.PolicyNumber3__c == '' || req.PolicyNumber2__c == '' || req.PolicyNumber1__c == '')){
			this.policyNumberErrorHandling(component,event);
		}
		else if(req.PolicyNumber8__c != '') {
			this.getPolicyNumberValidate(component,event,req.PolicyNumber8__c,policyNumbers,"v.policyNumber8Error");
		}
		if(req.PolicyNumber7__c != '' && (req.PolicyNumber6__c == '' || req.PolicyNumber5__c == '' || req.PolicyNumber4__c == '' || req.PolicyNumber3__c == '' || req.PolicyNumber2__c == '' || req.PolicyNumber1__c == '')){
			this.policyNumberErrorHandling(component,event);
		}
		else if(req.PolicyNumber7__c != ''){
			this.getPolicyNumberValidate(component,event,req.PolicyNumber7__c,policyNumbers,"v.policyNumber7Error");
		}
		if(req.PolicyNumber6__c != '' && (req.PolicyNumber5__c == '' || req.PolicyNumber4__c == '' || req.PolicyNumber3__c == '' || req.PolicyNumber2__c == '' || req.PolicyNumber1__c == '')){
            this.policyNumberErrorHandling(component,event);
		}
		else if(req.PolicyNumber6__c != ''){
			this.getPolicyNumberValidate(component,event,req.PolicyNumber6__c,policyNumbers,"v.policyNumber6Error");
		}
		if(req.PolicyNumber5__c != '' && (req.PolicyNumber4__c == '' || req.PolicyNumber3__c == '' || req.PolicyNumber2__c == '' || req.PolicyNumber1__c == '')){
			this.policyNumberErrorHandling(component,event);
		}
		else if(req.PolicyNumber5__c != ''){
			this.getPolicyNumberValidate(component,event,req.PolicyNumber5__c,policyNumbers,"v.policyNumber5Error");
		}
		if(req.PolicyNumber4__c != '' && (req.PolicyNumber3__c == '' || req.PolicyNumber2__c == '' || req.PolicyNumber1__c == '')){
			this.policyNumberErrorHandling(component,event);
		}
		else if(req.PolicyNumber4__c != ''){
			this.getPolicyNumberValidate(component,event,req.PolicyNumber4__c,policyNumbers,"v.policyNumber4Error");
		}		
		if(req.PolicyNumber3__c != '' && (req.PolicyNumber2__c == '' || req.PolicyNumber1__c == '')){
			 this.policyNumberErrorHandling(component,event);
		}
		else if(req.PolicyNumber3__c != ''){
			this.getPolicyNumberValidate(component,event,req.PolicyNumber3__c,policyNumbers,"v.policyNumber3Error");
		}
		if(req.PolicyNumber2__c != '' && req.PolicyNumber1__c == ''){
			 this.policyNumberErrorHandling(component,event);
		}
		else if(req.PolicyNumber2__c != ''){
			this.getPolicyNumberValidate(component,event,req.PolicyNumber2__c,policyNumbers,"v.policyNumber2Error");
		}
		if(req.PolicyNumber1__c != ''){
			this.getPolicyNumberValidate(component,event,req.PolicyNumber1__c,policyNumbers,"v.policyNumber1Error");
		}
	}
})