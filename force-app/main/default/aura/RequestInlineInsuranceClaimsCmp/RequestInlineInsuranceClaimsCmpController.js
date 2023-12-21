/**
 * @File Name          : RequestInlineInsuranceClaimsCmpController.js
 * @Description        : 
 * @Author             : SRM
 * @Group              : 
 * @Last Modified By   : SRM
 * @Last Modified On   : 12/31/2019, 12:12:40 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    12/30/2019   SRM     Initial Version
**/
({
    saveRequestInsuranceClaims : function(cmp, event) {
	    var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;
        
        obj.MailingPrefectures__c = cmp.get("v.innerCmpNewRequest").MailingPrefectures__c;
        obj.MailingCity__c = cmp.get("v.innerCmpNewRequest").MailingCity__c;
        obj.MailingAddress1__c = cmp.get("v.innerCmpNewRequest").MailingAddress1__c;
        
        
		obj.ReceivedNumber__c= cmp.get("v.innerCmpNewRequest").ReceivedNumber__c;
		obj.ReturnDestinationName__c= cmp.get("v.innerCmpNewRequest").ReturnDestinationName__c;
		obj.EmergencyFlag__c= cmp.get("v.innerCmpNewRequest").EmergencyFlag__c;
		obj.CallBackStartTime__c= cmp.get("v.innerCmpNewRequest").CallBackStartTime__c;
		obj.CallBackEndTime__c= cmp.get("v.innerCmpNewRequest").CallBackEndTime__c;
		obj.PresenceeOfDocumentIncluded__c= cmp.get("v.innerCmpNewRequest").PresenceeOfDocumentIncluded__c;
		obj.SendingMethod__c= cmp.get("v.innerCmpNewRequest").SendingMethod__c;
		obj.SendingProducts__c= cmp.get("v.innerCmpNewRequest").SendingProducts__c;
		obj.DestinationCategory__c= cmp.get("v.innerCmpNewRequest").DestinationCategory__c;
		obj.ShippingAddressEtc__c= cmp.get("v.innerCmpNewRequest").ShippingAddressEtc__c;
		obj.ReflectMailingAddress__c= cmp.get("v.innerCmpNewRequest").ReflectMailingAddress__c;
		obj.MailingPostalCode__c= cmp.get("v.innerCmpNewRequest").MailingPostalCode__c;
		obj.MailingAddress2__c= cmp.get("v.innerCmpNewRequest").MailingAddress2__c;
		obj.DestinationAddress__c= cmp.get("v.innerCmpNewRequest").DestinationAddress__c;
		obj.CorrespondenceRequest__c= cmp.get("v.innerCmpNewRequest").CorrespondenceRequest__c;
		obj.CorrespondenceClassificationContents__c= cmp.get("v.innerCmpNewRequest").CorrespondenceClassificationContents__c;
		obj.DateOfConfirmationOfParentalAuthori__c= cmp.get("v.innerCmpNewRequest").DateOfConfirmationOfParentalAuthori__c;
		obj.NameOfParentalAuthority__c= cmp.get("v.innerCmpNewRequest").NameOfParentalAuthority__c;
		obj.ParentNameFullNameKana__c= cmp.get("v.innerCmpNewRequest").ParentNameFullNameKana__c;
		obj.ParentalAuthorityConfirmation__c= cmp.get("v.innerCmpNewRequest").ParentalAuthorityConfirmation__c;
		obj.ParentsLivingTogetherAndSeparated__c= cmp.get("v.innerCmpNewRequest").ParentsLivingTogetherAndSeparated__c;
		obj.PaperlessDocument__c= cmp.get("v.innerCmpNewRequest").PaperlessDocument__c;
		obj.ConsentMattersuidance__c= cmp.get("v.innerCmpNewRequest").ConsentMattersuidance__c;
		obj.TransferDesignatedAccount__c= cmp.get("v.innerCmpNewRequest").TransferDesignatedAccount__c;
		obj.ApplicablePAccount__c= cmp.get("v.innerCmpNewRequest").ApplicablePAccount__c;
		obj.AccountHolderKana__c= cmp.get("v.innerCmpNewRequest").AccountHolderKana__c;
		obj.AccountHolderKanji__c= cmp.get("v.innerCmpNewRequest").AccountHolderKanji__c;
		obj.FinancialInstitutionSearch__c= cmp.get("v.innerCmpNewRequest").FinancialInstitutionSearch__c;
		obj.FinancialName__c= cmp.get("v.innerCmpNewRequest").FinancialName__c;
		obj.BankCode__c= cmp.get("v.innerCmpNewRequest").BankCode__c;
		obj.BranchName__c= cmp.get("v.innerCmpNewRequest").BranchName__c;
		obj.BranchCodeStoreNumber__c= cmp.get("v.innerCmpNewRequest").BranchCodeStoreNumber__c;
		obj.DepositCategory__c= cmp.get("v.innerCmpNewRequest").DepositCategory__c;
		obj.AccountNumber__c= cmp.get("v.innerCmpNewRequest").AccountNumber__c;
		obj.DirectOwnership__c= cmp.get("v.innerCmpNewRequest").DirectOwnership__c;
		obj.BillingClassification__c= cmp.get("v.innerCmpNewRequest").BillingClassification__c;
		obj.NameOfInjuryOrIllness__c= cmp.get("v.innerCmpNewRequest").NameOfInjuryOrIllness__c;
		obj.Icd10__c= cmp.get("v.innerCmpNewRequest").Icd10__c;
		obj.DateOfInjuryAccidentDay__c= cmp.get("v.innerCmpNewRequest").DateOfInjuryAccidentDay__c;
		obj.CancerMedicalAnnouncement__c= cmp.get("v.innerCmpNewRequest").CancerMedicalAnnouncement__c;
		obj.ContractLiabilityStartDate__c= cmp.get("v.innerCmpNewRequest").ContractLiabilityStartDate__c;
		obj.CanceDiagnosisResponsibilityStart__c= cmp.get("v.innerCmpNewRequest").CanceDiagnosisResponsibilityStart__c;
		obj.HospitalizationDate__c= cmp.get("v.innerCmpNewRequest").HospitalizationDate__c;
		obj.HospitalizationRemarks__c= cmp.get("v.innerCmpNewRequest").HospitalizationRemarks__c;
		obj.SupportPaymentRestrictions__c= cmp.get("v.innerCmpNewRequest").SupportPaymentRestrictions__c;
		obj.DischargeDate__c= cmp.get("v.innerCmpNewRequest").DischargeDate__c;
		obj.DischargeDayRemarks__c= cmp.get("v.innerCmpNewRequest").DischargeDayRemarks__c;
		obj.NumberOfHospitalDays__c= cmp.get("v.treatmentDays");
		obj.HospitalRemarks__c= cmp.get("v.innerCmpNewRequest").HospitalRemarks__c;
		obj.VisitingHospitalPeriod__c= cmp.get("v.innerCmpNewRequest").VisitingHospitalPeriod__c;
		obj.HospitalizationDay2__c= cmp.get("v.innerCmpNewRequest").HospitalizationDay2__c;
		obj.HospitalizationTreatment__c= cmp.get("v.innerCmpNewRequest").HospitalizationTreatment__c;
		obj.SurgeryDate__c= cmp.get("v.innerCmpNewRequest").SurgeryDate__c;
		obj.SurgeryName__c= cmp.get("v.innerCmpNewRequest").SurgeryName__c;
		obj.Surgery__c= cmp.get("v.innerCmpNewRequest").Surgery__c;
		obj.Operation60DaysLimit__c= cmp.get("v.innerCmpNewRequest").Operation60DaysLimit__c;
		obj.AdvancedMedical__c= cmp.get("v.innerCmpNewRequest").AdvancedMedical__c;
		obj.Radiotherapy__c= cmp.get("v.innerCmpNewRequest").Radiotherapy__c;
		obj.AnticancerDrugTreatment__c= cmp.get("v.innerCmpNewRequest").AnticancerDrugTreatment__c;
		obj.HormonalTreatment__c= cmp.get("v.innerCmpNewRequest").HormonalTreatment__c;
		obj.AccidentDay__c= cmp.get("v.innerCmpNewRequest").AccidentDay__c;
		obj.DisasterCause__c= cmp.get("v.innerCmpNewRequest").DisasterCause__c;
		obj.TreatAsADisease__c= cmp.get("v.innerCmpNewRequest").TreatAsADisease__c;
		obj.ReportToPolice__c= cmp.get("v.innerCmpNewRequest").ReportToPolice__c;
		obj.OccurrenceStatus__c= cmp.get("v.innerCmpNewRequest").OccurrenceStatus__c;
		obj.CircumstancesOfAccident__c= cmp.get("v.innerCmpNewRequest").CircumstancesOfAccident__c;
		obj.SpecificDamage__c= cmp.get("v.innerCmpNewRequest").SpecificDamage__c;
		obj.DeathDate__c= cmp.get("v.innerCmpNewRequest").DeathDate__c;
		obj.CauseOfDeath__c= cmp.get("v.innerCmpNewRequest").CauseOfDeath__c;
		obj.PresenceOrAbsenceOfDeathCertificate__c= cmp.get("v.innerCmpNewRequest").PresenceOrAbsenceOfDeathCertificate__c;
		obj.LifeInsuranceMutualAid__c= cmp.get("v.innerCmpNewRequest").LifeInsuranceMutualAid__c;
		obj.Heir__c= cmp.get("v.innerCmpNewRequest").Heir__c;
		obj.BereavedFamilyInformation__c= cmp.get("v.innerCmpNewRequest").BereavedFamilyInformation__c;
		obj.SevereCareStatus__c= cmp.get("v.innerCmpNewRequest").SevereCareStatus__c;
		obj.FixedSymptoms__c= cmp.get("v.innerCmpNewRequest").FixedSymptoms__c;
		obj.OutOfBillingCharge__c= cmp.get("v.innerCmpNewRequest").OutOfBillingCharge__c;
		obj.ReasonOnForNotCharging__c= cmp.get("v.innerCmpNewRequest").ReasonOnForNotCharging__c;
    },		
    init : function(component,event,helper){
        var dependantSubject = component.get('v.dependantSubject');
		helper.getpaperlessDocumentPickList(component, event);
		helper.getbillingClassificationPickList(component, event);
		helper.getpresenceeOfDocumentIncludedPick(component, event);
		helper.getsendingMethodPick(component, event);
		helper.getdestinationCategoryPick(component, event);
		helper.getcorrespondenceRequestPick(component, event,dependantSubject);
		helper.getparentalAuthorityConfirmationPick(component, event);
		helper.getparentsLivingTogetherAndSeparatedPick(component, event);
		helper.gettransferDesignatedAccountPick(component, event);
		helper.getdepositCategoryPick(component, event);
		helper.getcancerMedicalAnnouncementPick(component, event);
		helper.gethospitalizationDay2Pick(component, event);
		helper.getsurgeryPick(component, event);
		helper.getdisasterCausePick(component, event);
		helper.getreportToPolicePick(component, event);
		helper.getoccurrenceStatusPick(component, event);
		helper.getspecificDamagePick(component, event);
		helper.getcauseOfDeathPick(component, event);
		helper.getpresenceOrAbsenceOfDeathCertificatePick(component, event);
		helper.getlifeInsuranceMutualAidPick(component, event);
		helper.getheirPick(component, event);
		helper.getfixedSymptomsPick(component, event);
		helper.getoutOfBillingChargePick(component, event);
        helper.getanticancerDrugTreatmentPick(component, event);
        helper.gethormonalTreatmentPick(component, event);
        helper.getradiotherapyPick(component,event);
        helper.fetchPicklistValues(component,'Request__c','LifeInsuranceMutualAid__c', 'Heir__c');
    },
    handleAreaInfo : function(cmp,event,helper){
		cmp.get("v.innerCmpNewRequest").MailingPrefectures__c ='';
        cmp.get("v.innerCmpNewRequest").MailingCity__c ='';
        cmp.get("v.innerCmpNewRequest").MailingAddress1__c ='';
        helper.areaInfo(cmp, event);             
    },
    
    onControllerFieldChange: function(component, event, helper) {     
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        
        if (controllerValueKey != '--- None ---') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", ['--- None ---']);
            }  
            
        } else {
            component.set("v.listDependingValues", ['--- None ---']);
            component.set("v.bDisabledDependentFld" , true);
        }
    },
	 handleCancerDiagnosis : function(cmp,event,helper){
         cmp.set("v.CancerDiagnosisDate", '');
         if(cmp.get("v.innerCmpNewRequest").ContractLiabilityStartDate__c  != null){
             var CancerDiagnosis = new Date(cmp.get("v.innerCmpNewRequest").ContractLiabilityStartDate__c ); 
            CancerDiagnosis.setDate(CancerDiagnosis.getDate()+90);
            var CancerDiagnosisDate = $A.localizationService.formatDate(CancerDiagnosis, "YYYY/MM/DD");
            cmp.set("v.CancerDiagnosisDate", CancerDiagnosisDate);
         }	
	 },
	 handleRestrictionsOnSupportDate : function(cmp,event,helper){
        cmp.set("v.RestrictionsOnSupportDate", '');
         if(cmp.get("v.innerCmpNewRequest").HospitalizationDate__c  != null){
             var RestrictionsOnSupport = new Date(cmp.get("v.innerCmpNewRequest").HospitalizationDate__c); 
            RestrictionsOnSupport.setDate(RestrictionsOnSupport.getDate()+180);
            var RestrictionsOnSupportDate = $A.localizationService.formatDate(RestrictionsOnSupport, "YYYY/MM/DD");
            cmp.set("v.RestrictionsOnSupportDate", RestrictionsOnSupportDate);
         }
	 },
	 handleAdmitRelatedDate : function(cmp,event,helper){
		helper.handleTreatmentDays(cmp,event,helper);
		if(cmp.get("v.innerCmpNewRequest").HospitalizationDate__c  != null){
			var RestrictionsOnSupport = new Date(cmp.get("v.innerCmpNewRequest").HospitalizationDate__c); 
			RestrictionsOnSupport.setDate(RestrictionsOnSupport.getDate()+180);
			var RestrictionsOnSupportDate = $A.localizationService.formatDate(RestrictionsOnSupport, "YYYY/MM/DD");
			cmp.set("v.RestrictionsOnSupportDate", RestrictionsOnSupportDate);
		}else{
			cmp.set("v.RestrictionsOnSupportDate", '');
		}
	 },
	 handleDischargeRelatedDate : function(cmp,event,helper){
		cmp.set("v.OutpatientCoveragePeriodDate", null);
		cmp.set("v.TreatedAsHospitalDate", null);
		cmp.set("v.ReclaimDate", null);
		cmp.set("v.DiseaseTreatmentDate", null);
		var DischargeDate = new Date(cmp.get("v.innerCmpNewRequest").DischargeDate__c);
		if(cmp.get("v.innerCmpNewRequest").DischargeDate__c != '' 
		&& cmp.get("v.innerCmpNewRequest").DischargeDate__c != null) {
			var OutpatientCoveragePeriod = new Date(DischargeDate);
			OutpatientCoveragePeriod.setDate(OutpatientCoveragePeriod.getDate()+120);
			var OutpatientCoveragePeriodDate = $A.localizationService.formatDate(OutpatientCoveragePeriod, "YYYY/MM/DD");
			cmp.set("v.OutpatientCoveragePeriodDate", OutpatientCoveragePeriodDate);
			
			var TreatedAsHospital = new Date(DischargeDate);
			TreatedAsHospital.setDate(TreatedAsHospital.getDate()+181);
			var TreatedAsHospitalDate = $A.localizationService.formatDate(TreatedAsHospital, "YYYY/MM/DD");
			cmp.set("v.TreatedAsHospitalDate", TreatedAsHospitalDate);

			var Reclaim = new Date(DischargeDate);
			Reclaim.setDate(Reclaim.getDate()+60);
			var ReclaimDate = $A.localizationService.formatDate(Reclaim, "YYYY/MM/DD");
			cmp.set("v.ReclaimDate", ReclaimDate);

			var DiseaseTreatment = new Date(DischargeDate);
			DiseaseTreatment.setDate(DiseaseTreatment.getDate()+180);
			var DiseaseTreatmentDate = $A.localizationService.formatDate(DiseaseTreatment, "YYYY/MM/DD");
			cmp.set("v.DiseaseTreatmentDate", DiseaseTreatmentDate);
		}
		helper.handleTreatmentDays(cmp,event,helper);
	 },
	 openBankMasterSearch : function(component,event,helper){

		$A.createComponent("c:BankMasterSearchCmp",{"showSearchPopup" : true,"sourceScreen" : "lightningCmp"},function(responseName, status, errorMessage){
			if(status === "SUCCESS"){
				var body = component.get("v.body");
                body.push([]);
                body.push(responseName);
                component.set("v.body", body);
			}else{
				alert('ErrorMessage ' + errorMessage);
			}
		});
	 },
	 handleBankMasterResultCmpEvt : function(component, event, helper){

		component.set("v.innerCmpNewRequest.BankCode__c", event.getParam("bankCode")); 
		component.set("v.innerCmpNewRequest.FinancialName__c", event.getParam("bankName"));
		component.set("v.innerCmpNewRequest.BranchCodeStoreNumber__c", event.getParam("branchCode"));
		component.set("v.innerCmpNewRequest.BranchName__c", event.getParam("branchName"));
	 }
})