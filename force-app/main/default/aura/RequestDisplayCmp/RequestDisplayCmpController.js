({
	doInit : function(component, event, helper) {
        helper.getContractInfo(component, event);
        helper.getSubjectPicklist(component, event);
        helper.getStatusPicklist(component, event);
        helper.getPriorityPicklist(component, event);
        helper.fetchPicklistValues(component,event);
        helper.reportButtonDisplay(component,event);
        //helper.getButtonReportNavigation(component,event);     
		var now = $A.localizationService.formatDate(new Date(), "YYYY-MM-DDTHH:mm:ss.SSSZ");
		component.set('v.newRequest.TelAcceptCompnDate__c', now);   
        component.find("statusPicklist").set("v.value","CC対応中");

        //有人チャット start
        var omniAPI = component.find("omniToolkit");
        omniAPI.getServicePresenceStatusId().then(function(result) {
            component.set("v.loginFlg", "login");
        });
        //有人チャット end
    },
    onControllerFieldChange: function(component, event, helper) {
		var reqOld = component.get("v.newRequest");
        
		component.set("v.newRequest",{ 'sObjectType': 'Request__c',
                                      'Class__c':reqOld.Class__c,
                                      'Type__c':reqOld.Type__c,
                                      'Status__c':reqOld.Status__c,
                                      'Subject__c':reqOld.Subject__c,
                                      'Priority__c':reqOld.Priority__c,
                                      'TelAcceptCompnDate__c':reqOld.TelAcceptCompnDate__c,
                                      'RequestStatusComment__c':reqOld.RequestStatusComment__c,
                                      'NonRelatedContractCheck__c':reqOld.NonRelatedContractCheck__c,
                                      'Notices__c':reqOld.Notices__c});
        
        var dependentFieldMap = [];
        var disableDependentFld;
        var listDependingValues;
        var clsSelected='';
        var controllerName = event.getSource().get("v.name");
        component.set("v.selectedType", '');
        var controllerValueKey = event.getSource().get("v.value");
        var dependentFieldMapAPIForCls=component.get("v.depnedentFieldAPIMap");
        // Add 2023/06/06 RIPCRM-893_名義変更ケースの要件変更についての変更 By 張　Start
        var accountFields = component.get("v.recContractWrapper");
        // Add 2023/06/06 RIPCRM-893_名義変更ケースの要件変更についての変更 By 張　End

        if(controllerName === "controllerFld"){
            clsSelected=controllerValueKey;
            component.set("v.clsSelected",clsSelected);
            dependentFieldMap = component.get("v.depnedentFieldMap");
            disableDependentFld = "v.bDisabledDependentFld";
            listDependingValues = "v.listDependingValues";  
            /*if (controllerValueKey == '--- None ---') {
                component.set("v.newRequest.Class__c","");
            }
            component.set("v.newRequest.Type__c","");
            component.set("v.newRequest.Subject__c","");*/
        }else{
            dependentFieldMap = component.get("v.subjectDependentFieldMap");
            disableDependentFld = "v.disableSubjectField";
            listDependingValues = "v.subjectDependingValues";   
            
        }
        //Onyx-->to pickup depending values based on API Names of picklist instead of label
        if (controllerValueKey !=''  && controllerName != "controllerFld" && component.get("v.clsSelected")!='' && dependentFieldMapAPIForCls!='') {
            controllerValueKey=dependentFieldMapAPIForCls[component.get("v.clsSelected")][controllerValueKey];
        }	 
        if (controllerValueKey != '--- None ---') {                  	 
            var ListOfDependentFields = dependentFieldMap[controllerValueKey];
            
            if(ListOfDependentFields.length > 0){                
                component.set(disableDependentFld ,false);
                helper.fetchDepValues(component, ListOfDependentFields,listDependingValues); 
            }else{
                component.set(disableDependentFld , true);
                component.set(listDependingValues, ['--- None ---']);
            }
            if(controllerName === "controllerFld"){
            	
                component.set("v.subjectDependingValues", ['--- None ---']);
                component.set("v.disableSubjectField" , true);
            }
        } else {
            component.set("v.selectedType", '');
            /*if(component.get("v.newRequest.Class__c") == '--- None ---'){
                component.set("v.bDisabledDependentFld" , true);
                component.set("v.listDependingValues", ['--- None ---']);
            }           
            component.set("v.subjectDependingValues", ['--- None ---']);
            component.set("v.disableSubjectField" , true);*/
        }
        
        //対応種別
        if(controllerValueKey == '住所変更'){
            component.set("v.selectedType","AddressChange");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component, "c:RequestInlineAddressChangeCmp",{ "dependantSubject" : controllerValueKey},"InlineAddressChangeCmp");
        }else if(controllerValueKey == '改姓（名義変更）'){
            component.set("v.selectedType","NameChange");
            component.set("v.body",component.get("v.body").push([]));
            // Modify 2023/06/06 RIPCRM-893_名義変更ケースの要件変更についての変更 By 張　Start
            // helper.createDynamicComponent(component,"c:RequestInlineNameChangeCmp",{"dependantSubject" : controllerValueKey},"InlineNameChangeCmp");
            helper.createDynamicComponent(component,"c:RequestInlineNameChangeCmp",{"dependantSubject" : controllerValueKey ,"accountFields" : accountFields},"InlineNameChangeCmp");
            // Modify 2023/06/06 RIPCRM-893_名義変更ケースの要件変更についての変更 By 張　End
        }else if(controllerValueKey == '電話番号変更'){
            component.set("v.selectedType","PhoneChange");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlinePhoneNumberChangeCmp",{},"InlinePhoneNumberChangeCmp");
        }else if(controllerValueKey == 'メールアドレス変更'){
            component.set("v.selectedType","MailAddrChange");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineMailAddrChangeCmp",{},"InlineMailAddrChangeCmp");   
        }else if(controllerValueKey == '対応依頼'){
            component.set("v.selectedType","SupportRequest");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineSupportRequestCmp",{},"InlineSupportRequestCmp");   
        }else if(controllerValueKey == '情報連携'){
            component.set("v.selectedType","InformationLinkage");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineInformationLinkageCmp",{},"InlineInformationLinkageCmp");
        }else if(controllerValueKey == '苦情・要望'){
            component.set("v.selectedType","Complaint");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineComplaintsCmp",{},"InlineComplaintsCmp");
        }
       
        //Picklist 2
        // Onyx
        else if(controllerValueKey=='タブレット・Team Viewer'){
            component.set("v.selectedType","TabletTeamViewer");
            component.set("v.body",component.get("v.body").push([]));
        }
        
        else if(controllerValueKey=='声紋認証'){
            component.set("v.selectedType","VoiceRegistration");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineVoiceRegistrationCmp",{},"InlineVoiceRegistrationCmp"); 
        }
         else if(controllerValueKey=='フォロー対応'){
            component.set("v.selectedType","FollowResponse");
            component.set("v.body",component.get("v.body").push([]));   
        }
        else if(controllerValueKey=='ポイントプログラム・楽天ID連携'){
            component.set("v.selectedType","RakutenIdCooperation");
            component.set("v.body",component.get("v.body").push([]));   
        }
        else if(controllerValueKey=='問い合わせケース'){
            component.set("v.selectedType","InquiryCaseType");
            component.set("v.body",component.get("v.body").push([]));   
        }
        else if(controllerValueKey=='更新'){
            component.set("v.selectedType","UpdateInquiry");
            component.set("v.body",component.get("v.body").push([]));   
        }
      	else if(controllerValueKey=='保全（異動）・照会'){
           	component.set("v.selectedType","InquiryType");
            component.set("v.body",component.get("v.body").push([]));    
        }
        else if(controllerValueKey == '保険金・給付金・共済金請求'){
            component.set("v.selectedType","InsuranceClaims");
            component.set("v.body",component.get("v.body").push([]));
            //helper.createDynamicComponent(component,"c:RequestInlineInsuranceClaimsCmp",{"dependantSubject" : controllerValueKey},"InlineInsuranceClaimsCmp");
        }else if(controllerValueKey == '解約'){
            component.set("v.selectedType","Cancellation");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineCancellationCmp",{"dependantSubject" : controllerValueKey},"InlineCancellationCmp");
        }else if(controllerValueKey == '特約減額'){
            component.set("v.selectedType","SpecialContractReduction");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineSpecialContractReductionCmp",{"dependantSubject" : controllerValueKey},"InlineSpecialContractReductionCmp"); 
        /*
        }else if(controllerValueKey == '証券再発行'){
            component.set("v.selectedType","SecuritiesReissue");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineSecuritiesReissueCmp",{"dependantSubject" : controllerValueKey},"InlineSecuritiesReissueCmp"); 
        */
        }else if(controllerValueKey == '保険証券・証書再発行'){
            component.set("v.selectedType","SecuritiesReissue");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineSecuritiesReissueCmp",{"dependantSubject" : controllerValueKey},"InlineSecuritiesReissueCmp"); 
        }else if(controllerValueKey == '更新拒否'){
            component.set("v.selectedType","RejectUpdate");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineRejectUpdateCmp",{"dependantSubject" : controllerValueKey},"InlineRejectUpdateCmp"); 
        }else if(controllerValueKey == '控除再発行'){
            component.set("v.selectedType","DeductionReissue");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineDeductionReissueCmp",{"dependantSubject" : controllerValueKey},"InlineDeductionReissueCmp");
        }else if(controllerValueKey == '海外渡航'){
            component.set("v.selectedType","InlineOverseasTravel");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineOverseasTravelCmp",{"dependantSubject" : controllerValueKey},"InlineOverseasTravelCmp");
        }else if(controllerValueKey == 'アルファ付替'){
            component.set("v.selectedType","inlineRequestAlphaReplacement");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineAlphaReplacementCmp",{"dependantSubject" : controllerValueKey},"InlineAlphaReplacementCmp");
        }else if(controllerValueKey == '返金先口座'){
            component.set("v.selectedType","inlineRefundAccount");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineRefundaccountCmp",{"dependantSubject" : controllerValueKey},"InlineRefundaccountCmp");
        }else if(controllerValueKey == "問合せケース（生命）"){
            component.set("v.selectedType","inlineInquirycase");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineInquirycaseCmp",{},"InlineInquirycaseCmp");
        }else if(controllerValueKey == "減額"){
            component.set("v.selectedType","inlineRequestReduction");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineReductionCmp",{"dependantSubject" : controllerValueKey},"InlineReductionCmp");
        }else if(controllerValueKey == "減口（生保）"){
            component.set("v.selectedType","inlineReducemouth");
            component.set("v.body",component.get("v.body").push([]));            
            helper.createDynamicComponent(component,"c:RequestInlineReducemouthCmp",{"dependantSubject" : controllerValueKey},"InlineReducemouthCmp");
        }else if(controllerValueKey == "書類発送ケース" || controllerValueKey=="書類発送ケース_代サ"){
            component.set("v.selectedType","inlineDocumentshippingcase");
            component.set("v.body",component.get("v.body").push([]));
/*            if(component.get("v.clsSelected")!='生命代サ専用ケース'){
            	helper.createDynamicComponent(component,"c:RequestInlineDocumentshippingcaseCmp",{"dependantSubject" : controllerValueKey},"InlineDocumentshippingcaseCmp");
            }*/
            /*
            else{
                //var dependentSubject = component.find('subjectPicklist');
                //var val = dependentSubject.get("v.value");
                //helper.createDynamicComponent(component,"c:RequestInlineDocShipmentCase",{"dependantSubject" : dependentSubject},"InlineDocumentshipmentcaseCmp");
                helper.createDynamicComponent(component,"c:RequestInlineDocShipmentCase",{"dependantSubject" : '書類発送'},"InlineDocumentshipmentcaseCmp");


//                helper.createDynamicComponent(component,"c:RequestInlineDocShipmentCase",{"dependantSubject" : '書類発送'},"InlineDocumentshipmentcaseCmp");
            }
            */
        }else if(controllerValueKey == "受取人（生保）"){
            component.set("v.selectedType","inlineRecipientlifeinsurance");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineRecipientlifeinsuranceCmp",{ "dependantSubject" : controllerValueKey},"InlineRecipientlifeinsuranceCmp");   
        }else if(controllerValueKey == "更新時減額"){
            component.set("v.selectedType","inlineRequestReductionatRenewal");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineReductionatRenewalCmp",{"dependantSubject" : controllerValueKey},"InlineReductionatRenewalCmp");
        }else if(controllerValueKey == "更新時減口（共済）"){
            component.set("v.selectedType","inlineRequestInlineRenewalexit");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineRenewalexitCmp",{"dependantSubject" : controllerValueKey},"InlineRenewalexitCmp");
        }else if(controllerValueKey == "Retention"){
            component.set("v.selectedType","inlineRetention");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineRetentionCmp",{"dependantSubject" : controllerValueKey},"InlineRetentionCmp");
        }else if(controllerValueKey == "減口（共済）"){
            component.set("v.selectedType","inlineRequestReductionMutualAid");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineReductionMutualAidCmp",{"dependantSubject" : controllerValueKey},"InlineReductionMutualAidCmp");   
        }else if(controllerValueKey == "受取人（共済）"){
            component.set("v.selectedType","inlineRecipientmutualaid");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineRecipientmutualaidCmp",{"dependantSubject" : controllerValueKey},"InlineRecipientmutualaidCmp");
        }else if(controllerValueKey == "特約解約"){
            component.set("v.selectedType","inlineSpecialCancellation");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineSpecialCancellationCmp",{"dependantSubject" : controllerValueKey},"InlineSpecialCancellationCmp");
        }else if(controllerValueKey == '指定代理人変更'){
            component.set("v.selectedType","inlineRequestChangedesignatedagent");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineChangedesignatedagentCmp",{"dependantSubject" : controllerValueKey},"InlineChangedesignatedagentCmp");

        } else if (controllerValueKey == '口座変更（無事故給付金）') {
            component.set("v.selectedType", "accidentFreeBenefit");
            component.set("v.body", component.get("v.body").push([]));
            helper.createDynamicComponent(component, "c:RequestAccidentFreeBenefitCmp", {"dependantSubject" : controllerValueKey}, "RequestAccidentFreeBenefitCmp");
        }
       //Picklist 3
       //Onyx
        else if(controllerValueKey=='新契約'){
            component.set("v.selectedType","NewContract");
            component.set("v.body",component.get("v.body").push([]));
           // helper.createDynamicComponent(component,"c:RequestInlineNewContractCmp",{},"InlineNewContractCmp"); 
        }
        else if(controllerValueKey=='収納（集金）'||controllerValueKey=='収納（集金）_代サ' ){
            component.set("v.selectedType","Storage");
            component.set("v.body",component.get("v.body").push([]));
            if(controllerValueKey!='収納（集金）_代サ'){
            	helper.createDynamicComponent(component,"c:RequestInlineStorageCmp",{},"RequestInlineStorageCmp");
            }
		}
        else if(controllerValueKey=='Agency Support'){
            component.set("v.selectedType","Storage");
            component.set("v.body",component.get("v.body").push([]));
            //helper.createDynamicComponent(component,"c:RequestInlineNewContractCmp",{},"InlineNewContractCmp"); 
        }
        else if(controllerValueKey == '住所・対象所在地同時変更'){
            component.set("v.selectedType","inlineSimultaneousChangOfAddrsCmp");
            component.set("v.body",component.get("v.body").push([]));
            //helper.createDynamicComponent(component,"c:RequestInlineSimultaneousChangOfAddrsCmp",{"dependantSubject" : controllerValueKey},"InlineSimultaneousChangOfAddrsCmp");
        }else if(controllerValueKey == '車両入替'){
            component.set("v.selectedType","inlineVehicleReplacement");
            component.set("v.body",component.get("v.body").push([]));
            //helper.createDynamicComponent(component,"c:RequestInlineVehicleReplacementCmp",{"dependantSubject" : controllerValueKey},"RequestInlineVehicleReplacementCmp");
        }else if(controllerValueKey == '保険証券再発行'){
            component.set("v.selectedType","inlineInsurancePolicyReissue");
            component.set("v.body",component.get("v.body").push([]));
            //helper.createDynamicComponent(component,"c:RequestInlineInsurancePolicyReissueCmp",{"dependantSubject" : controllerValueKey},"InlineInsurancePolicyReissueCmp");
        }else if(controllerValueKey == '承認書再発行'){
            component.set("v.selectedType","inlineReissueApproval");
            component.set("v.body",component.get("v.body").push([]));
            //helper.createDynamicComponent(component,"c:RequestInlineReissueApprovalCmp",{"dependantSubject" : controllerValueKey},"InlineReissueApprovalCmp");
        }else if(controllerValueKey == '控除証明書再発行'){
            component.set("v.selectedType","inlineReissuanceCertificateReissueCmp");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineReissuanceCertificateReissueCmp",{},"InlineReissuanceCertificateReissueCmp");
        }else if(controllerValueKey == 'サイクルアシスト証券発行'){
            component.set("v.selectedType","inlineCycleAssistContReissue");
            component.set("v.body",component.get("v.body").push([]));
            //helper.createDynamicComponent(component,"c:RequestInlineCycleAssistContReissueCmp",{"dependantSubject" : controllerValueKey},"InlineCycleAssistContReissueCmp");
        }else if(controllerValueKey == 'リビングアシスト契約証再発行'){
            component.set("v.selectedType","inlineLivingAssistContReissue");
            component.set("v.body",component.get("v.body").push([]));
            //helper.createDynamicComponent(component,"c:RequestInlineLivingAssistContReissueCmp",{},"InlineLivingAssistContReissueCmp"); 
        }else if(controllerValueKey == '中断証明発行'){
            component.set("v.selectedType","inlineIssuanceOfSusCertificate");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineIssuanceOfSusCertificateCmp",{},"InlineIssuanceOfSusCertificateCmp");
        }else if(controllerValueKey == '中断証明再発行'){
            component.set("v.selectedType","inlineReissueCertForSuspension");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineReissueCertForSuspensionCmp",{},"InlineReissueCertForSuspensionCmp");
        }else if(controllerValueKey == '解約（自動車）'){
            component.set("v.selectedType","inlineCancellationCarCmp");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineCancellationCarCmp",{},"InlineCancellationCarCmp");
        }else if(controllerValueKey == '解約（火災）'){
            component.set("v.selectedType","inlineCancellationFire");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineCancellationFireCmp",{},"InlineCancellationFireCmp");
        }else if(controllerValueKey == '解約（傷害）'){
            component.set("v.selectedType","inlineCancellationInjuryCmp");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineCancellationInjuryCmp",{},"InlineCancellationInjuryCmp");
        }else if(controllerValueKey == '解約（ジャンプ・積立・その他）'){
            component.set("v.selectedType","inlineCancellationJump");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineCancellationJumpCmp",{},"InlineCancellationJumpCmp");    
        }else if(controllerValueKey == '対象所在地変更（火災・満期戻）'){
            component.set("v.selectedType","inlineTargetLocationChangeFireorMaturityreturn");
            component.set("v.body",component.get("v.body").push([]));
            //helper.createDynamicComponent(component,"c:RequestInlineTrgtLctnChngFireorMtrtyrtrn",{"dependantSubject" : controllerValueKey},"InlineTrgtLctnChngFireorMtrtyrtrn");
        }else if(controllerValueKey == '用途車種変更（自動車）'){
            component.set("v.selectedType","inlineChangeModelCmp");
            component.set("v.body",component.get("v.body").push([]));
            //helper.createDynamicComponent(component,"c:RequestInlineChangeModelCmp",{"dependantSubject" : controllerValueKey},"InlineChangeModelCmp");
        }else if(controllerValueKey == '登録番号変更（自動車）'){
            component.set("v.selectedType","inlineRegistrationNumberChangecar");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineRegistrationNumberChangecar",{},"InlineRegistrationNumberChangecar");
        }else if(controllerValueKey == '保険金額変更'){
            component.set("v.selectedType","inlineInsuranceAmountChange");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineInsuranceAmountChangeCmp",{},"InlineInsuranceAmountChangeCmp");
        }else if(controllerValueKey == '条件変更（自動車）'){
            component.set("v.selectedType","inlineConditionChangeAutomobileCmp");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineConditionChangeAutomobileCmp",{},"InlineConditionChangeAutomobileCmp");
        }else if(controllerValueKey == '全損失効'){
            component.set("v.selectedType","inlineTotalLossEffect");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineTotalLossEffectCmp",{},"InlineTotalLossEffectCmp");
        }else if(controllerValueKey == '構造用法面積変更'){
            component.set("v.selectedType","inlineStructuralUsageAreaChngCmp");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineStructuralUsageAreaChngCmp",{"dependantSubject" : controllerValueKey},"InlineStructuralUsageAreaChngCmp");
        }else if(controllerValueKey == '職業職種（級別）の変更'){
            component.set("v.selectedType","inlineChangeOccupationTypeCls");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineChangeOccupationTypeClsCmp",{},"InlineChangeOccupationTypeClsCmp");
        }else if(controllerValueKey == '権利譲渡（名義変更）'){
            component.set("v.selectedType","inlineRightsTransferCmp");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineRightsTransferCmp",{"dependantSubject" : controllerValueKey},"InlineRightsTransferCmp");
        }else if(controllerValueKey == '名義変更（保険の対象の所有者氏名変更）'){
            component.set("v.selectedType","inlineOwnerNameChangeCmp");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineOwnerNameChangeCmp",{"dependantSubject" : controllerValueKey},"InlineOwnerNameChangeCmp");
        }else if(controllerValueKey == '増車'){
            component.set("v.selectedType","inlineIncrease");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineIncrease",{"dependantSubject" : controllerValueKey},"InlineIncrease");
        }else if(controllerValueKey == '質権設定・削除'){
            component.set("v.selectedType","inlinePledgeSettingOrDeletion");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlinePledgeSettingOrDeletionCmp",{},"InlinePledgeSettingOrDeletionCmp");
        }else if(controllerValueKey == '等級訂正'){
            component.set("v.selectedType","inlineGradeCorrectionCmp");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineGradeCorrectionCmp",{},"InlineGradeCorrectionCmp");
        }else if(controllerValueKey == '被保険者変更'){
            component.set("v.selectedType","inlineInsuredPersonChangeCmp");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineInsuredPersonChangeCmp",{},"InlineInsuredPersonChangeCmp");
        }else if(controllerValueKey == '付保証明書発行'){
            component.set("v.selectedType","inlineIssuanceAttachedCrtfct");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineIssuanceAttachedCrtfctCmp",{},"InlineIssuanceAttachedCrtfctCmp");
        }else if(controllerValueKey == '口座変更、クレカ変更'){
            component.set("v.selectedType","inlineAccountCrecaChange");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineAccountCrecaChangeCmp",{"dependantSubject" : controllerValueKey},"InlineAccountCrecaChangeCmp");
        }else if(controllerValueKey == '入金確認'){
            component.set("v.selectedType","inlinePaymentConfirmation");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlinePaymentConfirmationCmp",{},"InlinePaymentConfirmationCmp");
        }else if(controllerValueKey == '新規契約・継続契約・中途更改'){
            component.set("v.selectedType","inlineNewOngoingMidContract");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineNewOngoingMidContractCmp",{"dependantSubject" : controllerValueKey},"InlineNewOngoingMidContractCmp"); 
        }else if(controllerValueKey == '汎用（損保）'){
            component.set("v.selectedType","inlineGeneralPurposeNonlife");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineGeneralPurposeNonlifeCmp",{},"InlineGeneralPurposeNonlifeCmp");
        }else if(controllerValueKey == '問合せケース（損保）'){
            component.set("v.selectedType","inlineInquiryCaseNonlife");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineInquiryCaseNonlifeCmp",{},"InlineInquiryCaseNonlifeCmp");
        }
        //Picklist 4
        else if(controllerValueKey == '少短事故受付'){
            component.set("v.selectedType","inlineSSAcdntReception");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineSSAccidecntReceptionCmp",{},"InlineSSAccidecntReceptionCmp");
       }else if(controllerValueKey == '少短事故受付（賠責）'){
            component.set("v.selectedType","inlineSSAccRecResponsibility");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineSSAccRecResponsibilityCmp",{},"InlineSSAccRecResponsibilityCmp");    
       }else if(controllerValueKey == '保険金関連（事故受付以外）'){
            component.set("v.selectedType","inlineInsOtherThanAcdntRecpton");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineInsotherthanAcdntRecptonCmp",{"dependantSubject" : controllerValueKey},"InsotherthanAcdntRecptonCmp");
       }else if(controllerValueKey == '更新変更_少短'){
            component.set("v.selectedType","inlineUpdateChange");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineUpdateChangeCmp",{},"InlineUpdateChange");  
       }else if(controllerValueKey == '更新拒否_少短'){
            component.set("v.selectedType","inlineRejectUpdateShort");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineRejectUpdateShortCmp",{"dependantSubject" : controllerValueKey},"InlineRejectUpdateShortCmp");
       }else if(controllerValueKey == '解約_少短'){
            component.set("v.selectedType","inlineReleaseLessShort");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineReleaseLessShortCmp",{"dependantSubject" : controllerValueKey},"InlineReleaseLessShortCmp");
       }else if(controllerValueKey == 'Retention（少短）'){
            component.set("v.selectedType","inlineRetentionShort");
            component.set("v.body",component.get("v.body").push([]));
            //helper.createDynamicComponent(component,"c:RequestInlineRetentionShortCmp",{"dependantSubject" : controllerValueKey},"InlineReleaseLessShortCmp");  
       }else if(controllerValueKey == '振込用紙再送'){
            component.set("v.selectedType","inlineTransferPaperResend");
            component.set("v.body",component.get("v.body").push([]));
            //helper.createDynamicComponent(component,"c:RequestInlineTransferPaperResendCmp",{},"InlineTransferPaperResendCmp");  
       }else if(controllerValueKey == '証券類・更新案内再送'){
            component.set("v.selectedType","inlineResendSecuritiesUpdates");
            component.set("v.body",component.get("v.body").push([]));
            //helper.createDynamicComponent(component,"c:RequestInlineResendSecuritiesUpdatesCmp",{"dependantSubject" : controllerValueKey},"InlineResendSecuritiesUpdatesCmp"); 
       }else if(controllerValueKey == '申込内容変更・新規多頭対応'){
            component.set("v.selectedType","inlineAppliContntChngAndMultiheadSupp");
            component.set("v.body",component.get("v.body").push([]));
            //helper.createDynamicComponent(component,"c:RequestInlineAppliContntChngAndMultiheadSuppCmp",{ "dependantSubject" : controllerValueKey},"InlineAppliContntChngAndMultiheadSuppCmp");
       }else if(controllerValueKey == '契約内容変更'){
            component.set("v.selectedType","inlineChangeContractDetails");
            component.set("v.body",component.get("v.body").push([]));
            //helper.createDynamicComponent(component,"c:RequestInlineChangeContractDetailsCmp",{ "dependantSubject" : controllerValueKey},"InlineChangeContractDetailsCmp");
       }else if(controllerValueKey == '問合せケース（少短）'){
            component.set("v.selectedType","inlineSSInquiryCase");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineSSInquiryCaseCmp",{},"InlineSSInquiryCaseCmp");
       }else if(controllerValueKey == '汎用（少短）'){
            component.set("v.selectedType","inlineGeneralPurpose");
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineGeneralPurposeCmp",{"dependantSubject" : controllerValueKey},"InlineGeneralPurposeCmp"); 
       }else{
           component.set("v.selectedType","");
           component.set("v.body", []);
       }
    },

    // Handle Enter & Space KeyDown event in Button Div
    // Use as Common Method for other components also
    preventDefault: function(component, event, helper) {
        var keycode = event.code;
        if (keycode == 'Enter' || keycode == 'Space'){
            event.preventDefault();
            event.stopImmediatePropagation();
        }
    },
    //handle Save
    handleSaveRequest : function(component, event, helper) {
        // Modify 2022/10/20 RIPCRM-740_リクエスト「誤作成削除」選択時のアラート設定 By 邵　Start
        // helper.saveRequest(component, event);
        var getComplPicklistId = component.find("statusPicklist");
        if (getComplPicklistId.get("v.value") == '誤作成削除') {
            var mel=document.getElementsByClassName("saveDialog");
            var ml=mel.length;
            for(var cnt=0;cnt<ml;cnt++){
                mel[cnt].classList.add('slds-fade-in-open');
            }
            var bel=document.getElementsByClassName("saveDialogMask");
            var bl=bel.length;
            for(var cnt=0;cnt<bl;cnt++){
                bel[cnt].classList.add('slds-backdrop_open');
            }
        }else{
            helper.saveRequest(component, event);
        }
        // Modify 2022/10/20 RIPCRM-740_リクエスト「誤作成削除」選択時のアラート設定 By 邵　End
    },
    handleCancel : function(component, event, helper) {
        helper.showHide(component);
        event.preventDefault();
        var recpPageRef = component.get("v.pageReference");
        var receptionId = recpPageRef.state.c__receptionId;
        $A.get("e.force:navigateToSObject").setParams({
            recordId: receptionId,
            slideDevName: "detail"
        }).fire();
        var requestSubTab = component.find("RequestSubTab");
        requestSubTab.getFocusedTabInfo().then(function(response){
            var focusedTabId = response.tabId;
            requestSubTab.closeTab({ tabId : focusedTabId});
        });
    },
    handleRowsSelected : function(component,event,helper){
        var selectedRows = event.getParam('selectedRows');        
        var contractIds = []; 
        var policyNumbers = [];
        for (var i = 0; i < selectedRows.length; i++){           
            contractIds.push(selectedRows[i].Id);
             if(selectedRows[i].policyNumber != undefined){
                policyNumbers.push(selectedRows[i].policyNumber);
            }     
        }
        component.set("v.rowsSelectedId",contractIds);
        component.set("v.policyNumberList",policyNumbers);      
    },

    onSubControllerFieldChange: function(component,event,helper){
        var selectedType = component.get("v.selectedType");
        var selPickListValue = event.getSource().get("v.value");
        var recContractWrapper = component.get("v.recContractWrapper");
        if(selPickListValue == '--- None ---'){
            component.find("childCmp").destroy();
        }
        
        //Onyx
       	if(selectedType == 'TabletTeamViewer'){
			component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineTabletTeamViewerCmp",{},"InlineTabletTeamViewerCmp");      
        }
          if(selectedType=='NewContract'){
            component.set("v.body",component.get("v.body").push([]));
           helper.createDynamicComponent(component,"c:RequestInlineNewContractCmp",{},"InlineNewContractCmp"); 
        }
         
        if(selectedType == 'Storage'){
			component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineStorageCmp",{},"InlineStorageCmp");      
        }
        else if(selectedType=='FollowResponse'){
            if(selPickListValue == '口座不備'){
                component.set("v.body",component.get("v.body").push([]));
                helper.createDynamicComponent(component,"c:RequestInlineFollowResponseInsufficientAccountCmp",{},"InlineFollowResponseInsufficientAccountCmp");
            }	
            else if(selPickListValue == 'お客様対応依頼'){
                component.set("v.body",component.get("v.body").push([]));
                helper.createDynamicComponent(component,"c:RequestInlineCustomerresponserequestCmp",{},"InlineCustomerresponserequestCmp");
            } 
            else if(selPickListValue == '継続フォロー'||selPickListValue == '解約メール'){
                component.set("v.body",component.get("v.body").push([]));
                helper.createDynamicComponent(component,"c:RequestInlineCancellationEmailCmp",{},"InlineCancellationEmailCmp");
            }    
        }
       	else if(selectedType=='InquiryType'){
         	component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineInquiryTypeCmp",{"dependantSubject" : selPickListValue,"recContractWrapper":recContractWrapper},"RequestInlineInquiryTypeCmp");
        }     
        else if(selectedType=='RakutenIdCooperation'){
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineInquiryTypeCmp",{"dependantSubject" : selPickListValue},"RequestInlineInquiryTypeCmp");
        }
        else if(selectedType=='InquiryCaseType'){
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineInquiryTypeCmp",{"dependantSubject" : selPickListValue},"RequestInlineInquiryTypeCmp");
        }
        else if(selectedType=='UpdateInquiry'){
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineInquiryTypeCmp",{"dependantSubject" : selPickListValue,"recContractWrapper":recContractWrapper},"RequestInlineInquiryTypeCmp");
        }
		else if(selectedType == 'inlineAppliContntChngAndMultiheadSupp'){
			component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineAppliContntChngAndMultiheadSuppCmp",{ "dependantSubject" : selPickListValue},"InlineAppliContntChngAndMultiheadSuppCmp");
        } 
        else if(selectedType == 'inlineChangeContractDetails'){
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineChangeContractDetailsCmp",{ "dependantSubject" : selPickListValue},"InlineChangeContractDetailsCmp");
        }
        else if(selectedType == 'InsuranceClaims'){
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineInsuranceClaimsCmp",{"dependantSubject" : selPickListValue},"InlineInsuranceClaimsCmp");
        }
        else if(selectedType == 'inlineCycleAssistContReissue'){
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineCycleAssistContReissueCmp",{"dependantSubject" : selPickListValue},"InlineCycleAssistContReissueCmp"); 
        }
        else if(selectedType == 'inlineInsurancePolicyReissue'){
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineInsurancePolicyReissueCmp",{"dependantSubject" : selPickListValue},"InlineInsurancePolicyReissueCmp");                    
        }
        else if(selectedType == 'inlineLivingAssistContReissue'){
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineLivingAssistContReissueCmp",{"dependantSubject" : selPickListValue},"InlineLivingAssistContReissueCmp"); 
        }
        else if(selectedType == 'inlineReissueApproval'){
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineReissueApprovalCmp",{"dependantSubject" : selPickListValue},"InlineReissueApprovalCmp");
        }
        else if(selectedType == 'inlineVehicleReplacement'){
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineVehicleReplacementCmp",{"dependantSubject" : selPickListValue},"RequestInlineVehicleReplacementCmp");    
        }
        else if(selectedType == 'inlineChangeModelCmp'){
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineChangeModelCmp",{"dependantSubject" : selPickListValue},"InlineChangeModelCmp");
        }
        else if(selectedType == 'inlineSimultaneousChangOfAddrsCmp'){
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineSimultaneousChangOfAddrsCmp",{"dependantSubject" : selPickListValue},"InlineSimultaneousChangOfAddrsCmp");  
        }
        else if(selectedType == 'inlineTargetLocationChangeFireorMaturityreturn'){
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineTrgtLctnChngFireorMtrtyrtrn",{"dependantSubject" : selPickListValue},"InlineTrgtLctnChngFireorMtrtyrtrn");
        }
        else if(selectedType == 'inlineRetentionShort'){
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineRetentionShortCmp",{"dependantSubject" : selPickListValue},"InlineReleaseLessShortCmp"); 
        } 
        else if(selectedType == 'inlineTransferPaperResend'){
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineTransferPaperResendCmp",{"dependantSubject" : selPickListValue},"InlineTransferPaperResendCmp");
        }
        else if(selectedType == "inlineDocumentshippingcase" && component.get("v.clsSelected")=='生命専用ケース'){
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineDocumentshippingcaseCmp",{"dependantSubject" : selPickListValue},"InlineDocumentshippingcaseCmp");
        }
        else if(selectedType == "inlineDocumentshippingcase" && component.get("v.clsSelected")=='生命代サ専用ケース'){
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineDocShipmentCase",{"dependantSubject" : selPickListValue,"recContractWrapper":recContractWrapper},"inlineDocumentshippingcase");
        }
        /*else if(selectedType == 'inlineGeneralPurpose'){
           component.set("v.body",component.get("v.body").push([]));
           helper.createDynamicComponent(component,"c:RequestInlineGeneralPurposeCmp",{"dependantSubject" : selPickListValue},"InlineGeneralPurposeCmp"); 
        }*/
        else if(selectedType == 'inlineResendSecuritiesUpdates'){
        	component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineResendSecuritiesUpdatesCmp",{"dependantSubject" : selPickListValue},"InlineResendSecuritiesUpdatesCmp");
        }
        /*
        else if(selectedType == "inlineDocumentshippingcase"){
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:RequestInlineDocumentshippingcaseCmp",{},"InlineDocumentshippingcaseCmp");
        }
        else{
           component.set("v.selectedType","");
           component.set("v.body", []);
       }  */  
    },
    handleComponentEvent : function(component, event, helper) {
        var value = event.getParam("param");
        component.set("v.showErrorToStopSave",value);
    },
     handleReportOpen: function(component, event, helper){
        var sourceLabel = event.getSource().get("v.label");
		var reportID = "";
        var accountId = component.get("v.accountId");
        var loginFlg = component.get("v.loginFlg");
        if(sourceLabel == "生命(保全)一覧"){
            reportID = $A.get("{!$Label.c.ReportID_SeihoHozenList}");
        }else if(sourceLabel == "生命(保険金)一覧"){
            reportID = $A.get("{!$Label.c.ReportID_SeihoHokenkinList}");
        }else if(sourceLabel == "生命(特約)一覧"){
            reportID = $A.get("{!$Label.c.ReportID_SeihoTokuyakuList}");
        }else if(sourceLabel == "損保一覧"){
            reportID = $A.get("{!$Label.c.ReportID_SonpoContractList}");
        }else{
            reportID = $A.get("{!$Label.c.ReportID_ShotanContractList}");
        }
		//有人チャット start
        if(loginFlg == "login"){
            var pageReference2 = {
                type: 'standard__recordPage',
                attributes: {
                    recordId: reportID,
                    objectApiName: 'Report',
                    actionName: 'view'
                },
                state: {
                    fv0: accountId
                }
            };
            var navService = component.find("navCreateReceptionRDC");
            event.preventDefault();
            navService.navigate(pageReference2);
        }else{
    		var url = window.location.origin+'/lightning/r/Report/'+reportID+'/view?fv0='+accountId;
            window.open(url,"_blank","resizable=yes,toolbar=no,status=yes,location=no,menubar=yes,scrollbars=yes",false);
        }
        //有人チャット end		
    },
    //有人チャット
    onStatusChanged : function(component, event, helper){
        var statusName = event.getParam("statusName");
        if(statusName == "オフライン"){
            component.set("v.loginFlg", "logout");
        }else{
            component.set("v.loginFlg", "login");
        }
    },
    //有人チャット
    onLogout : function(component, event, helper) {
        component.set("v.loginFlg", "logout");
    },
    //Cancelボタン押下時のダイアログ表示/非表示
    showModal : function(component, event, helper){
        // Modify 2022/10/20 RIPCRM-740_リクエスト「誤作成削除」選択時のアラート設定 By 邵　Start
        // var mel=document.getElementsByClassName("slds-modal");
        var mel=document.getElementsByClassName("cancelDialog");
        // Modify 2022/10/20 RIPCRM-740_リクエスト「誤作成削除」選択時のアラート設定 By 邵　End
        var ml=mel.length;
        for(var cnt=0;cnt<ml;cnt++){
            mel[cnt].classList.add('slds-fade-in-open');
        }
        // Modify 2022/10/20 RIPCRM-740_リクエスト「誤作成削除」選択時のアラート設定 By 邵　Start
        // var bel=document.getElementsByClassName("slds-backdrop");
        var bel=document.getElementsByClassName("cancelDialogMask");
        // Modify 2022/10/20 RIPCRM-740_リクエスト「誤作成削除」選択時のアラート設定 By 邵　End
        var bl=bel.length;
        for(var cnt=0;cnt<bl;cnt++){
            bel[cnt].classList.add('slds-backdrop_open');
        }
    },
    hideModal: function(component, event, helper){
        // Modify 2022/10/20 RIPCRM-740_リクエスト「誤作成削除」選択時のアラート設定 By 邵　Start
        // var mel=document.getElementsByClassName("slds-modal");
        var mel=document.getElementsByClassName("cancelDialog");
        // Modify 2022/10/20 RIPCRM-740_リクエスト「誤作成削除」選択時のアラート設定 By 邵　End
        var ml=mel.length;
        for(var cnt=0;cnt<ml;cnt++){
            mel[cnt].classList.remove('slds-fade-in-open');
        }
        // Modify 2022/10/20 RIPCRM-740_リクエスト「誤作成削除」選択時のアラート設定 By 邵　Start
        // var bel=document.getElementsByClassName("slds-backdrop");
        var bel=document.getElementsByClassName("cancelDialogMask");
        // Modify 2022/10/20 RIPCRM-740_リクエスト「誤作成削除」選択時のアラート設定 By 邵　End
        var bl=bel.length;
        for(var cnt=0;cnt<bl;cnt++){
            bel[cnt].classList.remove('slds-backdrop_open');
        }
    },
    // Add 2022/10/05 RIPCRM-740_リクエスト「誤作成削除」選択時のアラート設定 By 範　Start
    saveDialogOK: function(component, event, helper){
        var mel=document.getElementsByClassName("saveDialog");
        var ml=mel.length;
        for(var cnt=0;cnt<ml;cnt++){
            mel[cnt].classList.remove('slds-fade-in-open');
        }
        var bel=document.getElementsByClassName("saveDialogMask");
        var bl=bel.length;
        for(var cnt=0;cnt<bl;cnt++){
            bel[cnt].classList.remove('slds-backdrop_open');
        }
        helper.saveRequest(component, event);
    },
    saveDialogCancel: function(component, event, helper){
        var mel=document.getElementsByClassName("saveDialog");
        var ml=mel.length;
        for(var cnt=0;cnt<ml;cnt++){
            mel[cnt].classList.remove('slds-fade-in-open');
        }
        var bel=document.getElementsByClassName("saveDialogMask");
        var bl=bel.length;
        for(var cnt=0;cnt<bl;cnt++){
            bel[cnt].classList.remove('slds-backdrop_open');
        }
    }
    // Add 2022/10/05 RIPCRM-740_リクエスト「誤作成削除」選択時のアラート設定 By 範　End
})