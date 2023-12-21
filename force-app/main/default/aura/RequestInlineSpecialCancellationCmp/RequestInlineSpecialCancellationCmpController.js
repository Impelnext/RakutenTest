({
	saveInlineSpecialCancellation: function (cmp, event, helper) {
		var params = event.getParam('arguments');
		var obj = params.parentNewRequest;
		
		// Check all Number Input field once again before Save
		helper.getSingleByteNumberCheck(cmp,event,"v.numberOfCopies","v.noOfCopiesErr");
		
		obj.PolicyNumber1__c = cmp.get("v.innerCmpNewRequest").PolicyNumber1__c;
		if (obj.PolicyNumber1__c != '') {
			obj.ChangeDetails1__c = "リビングニーズ特約:" + cmp.find("livingNeedsSpecialAgreement1").get("v.value") + "\n" +
				"指定代理請求特約:" + cmp.find("specialProxyRequest1").get("v.value") + "\n" +
				"先進医療特約関連:" + cmp.find("advancedMedicalSpecialties1").get("v.value") + "\n" +
				"がん特約/がん診断給付特約/がん特約Ⅱ:" + cmp.find("cancerContract1").get("v.value") + "\n" +
				"急性心筋梗塞・脳卒中特約:" + cmp.find("acuteMyocardialInfarction1").get("v.value") + "\n" +
				"通院特約:" + cmp.find("outpatientSpecialAgreement1").get("v.value") + "\n" +
				"がん入院特約:" + cmp.find("cancerHospitalizationSpecialAgreement1").get("v.value") + "\n" +
				"退院・通院特約:" + cmp.find("dischargeHospital1").get("v.value") + "\n" +
				"7疾病特約:" + cmp.find("sevenDiseaseSpecialAgreement1").get("v.value") + "\n" +
				"3大疾病P免特約:" + cmp.find("threeMajorDiseasesPExemption1").get("v.value") + "\n" +
				"継続割引特約:" + cmp.find("continuousDiscountSpecialContract1").get("v.value") + "\n" +
				// 認知症保険PT Ph1
				"介護給付特約:" + cmp.find("longTermCareBnefitSpecialContract1").get("v.value") + "\n" +
				"精神疾患併発入院特約:" + cmp.find("hospitalWithMentalIllnessSpecialContract1").get("v.value") + "\n" +
				"無事故給付特約:" + cmp.find("accidentFreeBenefitSpecialContract1").get("v.value") + "\n" +
				"入院一時金特約:" + cmp.find("hospitalLumpSumRider1").get("v.value");
		}
		else {
			obj.ChangeDetails1__c = "";
		}

		obj.PolicyNumber2__c = cmp.get("v.innerCmpNewRequest").PolicyNumber2__c;
		if (obj.PolicyNumber2__c != '') {
			obj.ChangeDetails2__c = "リビングニーズ特約:" + cmp.find("livingNeedsSpecialAgreement2").get("v.value") + "\n" +
				"指定代理請求特約:" + cmp.find("specialProxyRequest2").get("v.value") + "\n" +
				"先進医療特約関連:" + cmp.find("advancedMedicalSpecialties2").get("v.value") + "\n" +
				"がん特約/がん診断給付特約/がん特約Ⅱ:" + cmp.find("cancerContract2").get("v.value") + "\n" +
				"急性心筋梗塞・脳卒中特約:" + cmp.find("acuteMyocardialInfarction2").get("v.value") + "\n" +
				"通院特約:" + cmp.find("outpatientSpecialAgreement2").get("v.value") + "\n" +
				"がん入院特約:" + cmp.find("cancerHospitalizationSpecialAgreement2").get("v.value") + "\n" +
				"退院・通院特約:" + cmp.find("dischargeHospital2").get("v.value") + "\n" +
				"7疾病特約:" + cmp.find("sevenDiseaseSpecialAgreement2").get("v.value") + "\n" +
				"3大疾病P免特約:" + cmp.find("threeMajorDiseasesPExemption2").get("v.value") + "\n" +
				"継続割引特約:" + cmp.find("continuousDiscountSpecialContract2").get("v.value") + "\n" +
				// 認知症保険PT Ph1
				"介護給付特約:" + cmp.find("longTermCareBnefitSpecialContract2").get("v.value") + "\n" +
				"精神疾患併発入院特約:" + cmp.find("hospitalWithMentalIllnessSpecialContract2").get("v.value") + "\n" +
				"無事故給付特約:" + cmp.find("accidentFreeBenefitSpecialContract2").get("v.value") + "\n" +
				"入院一時金特約:" + cmp.find("hospitalLumpSumRider2").get("v.value");
		}
		else {
			obj.ChangeDetails2__c = "";
		}

		obj.PolicyNumber3__c = cmp.get("v.innerCmpNewRequest").PolicyNumber3__c;
		if (obj.PolicyNumber3__c != '') {
			obj.ChangeDetails3__c = "リビングニーズ特約:" + cmp.find("livingNeedsSpecialAgreement3").get("v.value") + "\n" +
				"指定代理請求特約:" + cmp.find("specialProxyRequest3").get("v.value") + "\n" +
				"先進医療特約関連:" + cmp.find("advancedMedicalSpecialties3").get("v.value") + "\n" +
				"がん特約/がん診断給付特約/がん特約Ⅱ:" + cmp.find("cancerContract3").get("v.value") + "\n" +
				"急性心筋梗塞・脳卒中特約:" + cmp.find("acuteMyocardialInfarction3").get("v.value") + "\n" +
				"通院特約:" + cmp.find("outpatientSpecialAgreement3").get("v.value") + "\n" +
				"がん入院特約:" + cmp.find("cancerHospitalizationSpecialAgreement3").get("v.value") + "\n" +
				"退院・通院特約:" + cmp.find("dischargeHospital3").get("v.value") + "\n" +
				"7疾病特約:" + cmp.find("sevenDiseaseSpecialAgreement3").get("v.value") + "\n" +
				"3大疾病P免特約:" + cmp.find("threeMajorDiseasesPExemption3").get("v.value") + "\n" +
				"継続割引特約:" + cmp.find("continuousDiscountSpecialContract3").get("v.value") + "\n" +
				// 認知症保険PT Ph1
				"介護給付特約:" + cmp.find("longTermCareBnefitSpecialContract3").get("v.value") + "\n" +
				"精神疾患併発入院特約:" + cmp.find("hospitalWithMentalIllnessSpecialContract3").get("v.value") + "\n" +
				"無事故給付特約:" + cmp.find("accidentFreeBenefitSpecialContract3").get("v.value") + "\n" +
				"入院一時金特約:" + cmp.find("hospitalLumpSumRider3").get("v.value");
		}
		else {
			obj.ChangeDetails3__c = "";
		}

		obj.PolicyNumber4__c = cmp.get("v.innerCmpNewRequest").PolicyNumber4__c;
		if (obj.PolicyNumber4__c != '') {
			obj.ChangeDetails4__c = "リビングニーズ特約:" + cmp.find("livingNeedsSpecialAgreement4").get("v.value") + "\n" +
				"指定代理請求特約:" + cmp.find("specialProxyRequest4").get("v.value") + "\n" +
				"先進医療特約関連:" + cmp.find("advancedMedicalSpecialties4").get("v.value") + "\n" +
				"がん特約/がん診断給付特約/がん特約Ⅱ:" + cmp.find("cancerContract4").get("v.value") + "\n" +
				"急性心筋梗塞・脳卒中特約:" + cmp.find("acuteMyocardialInfarction4").get("v.value") + "\n" +
				"通院特約:" + cmp.find("outpatientSpecialAgreement4").get("v.value") + "\n" +
				"がん入院特約:" + cmp.find("cancerHospitalizationSpecialAgreement4").get("v.value") + "\n" +
				"退院・通院特約:" + cmp.find("dischargeHospital4").get("v.value") + "\n" +
				"7疾病特約:" + cmp.find("sevenDiseaseSpecialAgreement4").get("v.value") + "\n" +
				"3大疾病P免特約:" + cmp.find("threeMajorDiseasesPExemption4").get("v.value") + "\n" +
				"継続割引特約:" + cmp.find("continuousDiscountSpecialContract4").get("v.value") + "\n" +
				// 認知症保険PT Ph1
				"介護給付特約:" + cmp.find("longTermCareBnefitSpecialContract4").get("v.value") + "\n" +
				"精神疾患併発入院特約:" + cmp.find("hospitalWithMentalIllnessSpecialContract4").get("v.value") + "\n" +
				"無事故給付特約:" + cmp.find("accidentFreeBenefitSpecialContract4").get("v.value") + "\n" +
				"入院一時金特約:" + cmp.find("hospitalLumpSumRider4").get("v.value");
		}
		else {
			obj.ChangeDetails4__c = "";
		}

		obj.PolicyNumber5__c = cmp.get("v.innerCmpNewRequest").PolicyNumber5__c;
		if (obj.PolicyNumber5__c != '') {
			obj.ChangeDetails5__c = "リビングニーズ特約:" + cmp.find("livingNeedsSpecialAgreement5").get("v.value") + "\n" +
				"指定代理請求特約:" + cmp.find("specialProxyRequest5").get("v.value") + "\n" +
				"先進医療特約関連:" + cmp.find("advancedMedicalSpecialties5").get("v.value") + "\n" +
				"がん特約/がん診断給付特約/がん特約Ⅱ:" + cmp.find("cancerContract5").get("v.value") + "\n" +
				"急性心筋梗塞・脳卒中特約:" + cmp.find("acuteMyocardialInfarction5").get("v.value") + "\n" +
				"通院特約:" + cmp.find("outpatientSpecialAgreement5").get("v.value") + "\n" +
				"がん入院特約:" + cmp.find("cancerHospitalizationSpecialAgreement5").get("v.value") + "\n" +
				"退院・通院特約:" + cmp.find("dischargeHospital5").get("v.value") + "\n" +
				"7疾病特約:" + cmp.find("sevenDiseaseSpecialAgreement5").get("v.value") + "\n" +
				"3大疾病P免特約:" + cmp.find("threeMajorDiseasesPExemption5").get("v.value") + "\n" +
				"継続割引特約:" + cmp.find("continuousDiscountSpecialContract5").get("v.value") + "\n" +
				// 認知症保険PT Ph1
				"介護給付特約:" + cmp.find("longTermCareBnefitSpecialContract5").get("v.value") + "\n" +
				"精神疾患併発入院特約:" + cmp.find("hospitalWithMentalIllnessSpecialContract5").get("v.value") + "\n" +
				"無事故給付特約:" + cmp.find("accidentFreeBenefitSpecialContract5").get("v.value") + "\n" +
				"入院一時金特約:" + cmp.find("hospitalLumpSumRider5").get("v.value");
		} else {
			obj.ChangeDetails5__c = "";
		}

		obj.PolicyNumber6__c = cmp.get("v.innerCmpNewRequest").PolicyNumber6__c;
		if (obj.PolicyNumber6__c != '') {
			obj.ChangeDetails6__c = "リビングニーズ特約:" + cmp.find("livingNeedsSpecialAgreement6").get("v.value") + "\n" +
				"指定代理請求特約:" + cmp.find("specialProxyRequest6").get("v.value") + "\n" +
				"先進医療特約関連:" + cmp.find("advancedMedicalSpecialties6").get("v.value") + "\n" +
				"がん特約/がん診断給付特約/がん特約Ⅱ:" + cmp.find("cancerContract6").get("v.value") + "\n" +
				"急性心筋梗塞・脳卒中特約:" + cmp.find("acuteMyocardialInfarction6").get("v.value") + "\n" +
				"通院特約:" + cmp.find("outpatientSpecialAgreement6").get("v.value") + "\n" +
				"がん入院特約:" + cmp.find("cancerHospitalizationSpecialAgreement6").get("v.value") + "\n" +
				"退院・通院特約:" + cmp.find("dischargeHospital6").get("v.value") + "\n" +
				"7疾病特約:" + cmp.find("sevenDiseaseSpecialAgreement6").get("v.value") + "\n" +
				"3大疾病P免特約:" + cmp.find("threeMajorDiseasesPExemption6").get("v.value") + "\n" +
				"継続割引特約:" + cmp.find("continuousDiscountSpecialContract6").get("v.value") + "\n" +
				// 認知症保険PT Ph1
				"介護給付特約:" + cmp.find("longTermCareBnefitSpecialContract6").get("v.value") + "\n" +
				"精神疾患併発入院特約:" + cmp.find("hospitalWithMentalIllnessSpecialContract6").get("v.value") + "\n" +
				"無事故給付特約:" + cmp.find("accidentFreeBenefitSpecialContract6").get("v.value") + "\n" +
				"入院一時金特約:" + cmp.find("hospitalLumpSumRider6").get("v.value");
		} else {
			obj.ChangeDetails6__c = "";
		}

		obj.PolicyNumber7__c = cmp.get("v.innerCmpNewRequest").PolicyNumber7__c;
		if (obj.PolicyNumber7__c != '') {
			obj.ChangeDetails7__c = "リビングニーズ特約:" + cmp.find("livingNeedsSpecialAgreement7").get("v.value") + "\n" +
				"指定代理請求特約:" + cmp.find("specialProxyRequest7").get("v.value") + "\n" +
				"先進医療特約関連:" + cmp.find("advancedMedicalSpecialties7").get("v.value") + "\n" +
				"がん特約/がん診断給付特約/がん特約Ⅱ:" + cmp.find("cancerContract7").get("v.value") + "\n" +
				"急性心筋梗塞・脳卒中特約:" + cmp.find("acuteMyocardialInfarction7").get("v.value") + "\n" +
				"通院特約:" + cmp.find("outpatientSpecialAgreement7").get("v.value") + "\n" +
				"がん入院特約:" + cmp.find("cancerHospitalizationSpecialAgreement7").get("v.value") + "\n" +
				"退院・通院特約:" + cmp.find("dischargeHospital7").get("v.value") + "\n" +
				"7疾病特約:" + cmp.find("sevenDiseaseSpecialAgreement7").get("v.value") + "\n" +
				"3大疾病P免特約:" + cmp.find("threeMajorDiseasesPExemption7").get("v.value") + "\n" +
				"継続割引特約:" + cmp.find("continuousDiscountSpecialContract7").get("v.value") + "\n" +
				// 認知症保険PT Ph1
				"介護給付特約:" + cmp.find("longTermCareBnefitSpecialContract7").get("v.value") + "\n" +
				"精神疾患併発入院特約:" + cmp.find("hospitalWithMentalIllnessSpecialContract7").get("v.value") + "\n" +
				"無事故給付特約:" + cmp.find("accidentFreeBenefitSpecialContract7").get("v.value") + "\n" +
				"入院一時金特約:" + cmp.find("hospitalLumpSumRider7").get("v.value");
		}
		else {
			obj.ChangeDetails7__c = "";
		}

		obj.PolicyNumber8__c = cmp.get("v.innerCmpNewRequest").PolicyNumber8__c;
		if (obj.PolicyNumber8__c != '') {
			obj.ChangeDetails8__c = "リビングニーズ特約:" + cmp.find("livingNeedsSpecialAgreement8").get("v.value") + "\n" +
				"指定代理請求特約:" + cmp.find("specialProxyRequest8").get("v.value") + "\n" +
				"先進医療特約関連:" + cmp.find("advancedMedicalSpecialties8").get("v.value") + "\n" +
				"がん特約/がん診断給付特約/がん特約Ⅱ:" + cmp.find("cancerContract8").get("v.value") + "\n" +
				"急性心筋梗塞・脳卒中特約:" + cmp.find("acuteMyocardialInfarction8").get("v.value") + "\n" +
				"通院特約:" + cmp.find("outpatientSpecialAgreement8").get("v.value") + "\n" +
				"がん入院特約:" + cmp.find("cancerHospitalizationSpecialAgreement8").get("v.value") + "\n" +
				"退院・通院特約:" + cmp.find("dischargeHospital8").get("v.value") + "\n" +
				"7疾病特約:" + cmp.find("sevenDiseaseSpecialAgreement8").get("v.value") + "\n" +
				"3大疾病P免特約:" + cmp.find("threeMajorDiseasesPExemption8").get("v.value") + "\n" +
				"継続割引特約:" + cmp.find("continuousDiscountSpecialContract8").get("v.value") + "\n" +
				// 認知症保険PT Ph1
				"介護給付特約:" + cmp.find("longTermCareBnefitSpecialContract8").get("v.value") + "\n" +
				"精神疾患併発入院特約:" + cmp.find("hospitalWithMentalIllnessSpecialContract8").get("v.value") + "\n" +
				"無事故給付特約:" + cmp.find("accidentFreeBenefitSpecialContract8").get("v.value") + "\n" +
				"入院一時金特約:" + cmp.find("hospitalLumpSumRider8").get("v.value");
		} else {
			obj.ChangeDetails8__c = "";
		}

		obj.PolicyNumber9__c = cmp.get("v.innerCmpNewRequest").PolicyNumber9__c;
		if (obj.PolicyNumber9__c != '') {
			obj.ChangeDetails9__c = "リビングニーズ特約:" + cmp.find("livingNeedsSpecialAgreement9").get("v.value") + "\n" +
				"指定代理請求特約:" + cmp.find("specialProxyRequest9").get("v.value") + "\n" +
				"先進医療特約関連:" + cmp.find("advancedMedicalSpecialties9").get("v.value") + "\n" +
				"がん特約/がん診断給付特約/がん特約Ⅱ:" + cmp.find("cancerContract9").get("v.value") + "\n" +
				"急性心筋梗塞・脳卒中特約:" + cmp.find("acuteMyocardialInfarction9").get("v.value") + "\n" +
				"通院特約:" + cmp.find("outpatientSpecialAgreement9").get("v.value") + "\n" +
				"がん入院特約:" + cmp.find("cancerHospitalizationSpecialAgreement9").get("v.value") + "\n" +
				"退院・通院特約:" + cmp.find("dischargeHospital9").get("v.value") + "\n" +
				"7疾病特約:" + cmp.find("sevenDiseaseSpecialAgreement9").get("v.value") + "\n" +
				"3大疾病P免特約:" + cmp.find("threeMajorDiseasesPExemption9").get("v.value") + "\n" +
				"継続割引特約:" + cmp.find("continuousDiscountSpecialContract9").get("v.value") + "\n" +
				// 認知症保険PT Ph1
				"介護給付特約:" + cmp.find("longTermCareBnefitSpecialContract9").get("v.value") + "\n" +
				"精神疾患併発入院特約:" + cmp.find("hospitalWithMentalIllnessSpecialContract9").get("v.value") + "\n" +
				"無事故給付特約:" + cmp.find("accidentFreeBenefitSpecialContract9").get("v.value") + "\n" +
				"入院一時金特約:" + cmp.find("hospitalLumpSumRider9").get("v.value");
		}
		else {
			obj.ChangeDetails9__c = "";
		}

		obj.PolicyNumber10__c = cmp.get("v.innerCmpNewRequest").PolicyNumber10__c;
		if (obj.PolicyNumber10__c != '') {
			obj.ChangeDetails10__c = "リビングニーズ特約:" + cmp.find("livingNeedsSpecialAgreement10").get("v.value") + "\n" +
				"指定代理請求特約:" + cmp.find("specialProxyRequest10").get("v.value") + "\n" +
				"先進医療特約関連:" + cmp.find("advancedMedicalSpecialties10").get("v.value") + "\n" +
				"がん特約/がん診断給付特約/がん特約Ⅱ:" + cmp.find("cancerContract10").get("v.value") + "\n" +
				"急性心筋梗塞・脳卒中特約:" + cmp.find("acuteMyocardialInfarction10").get("v.value") + "\n" +
				"通院特約:" + cmp.find("outpatientSpecialAgreement10").get("v.value") + "\n" +
				"がん入院特約:" + cmp.find("cancerHospitalizationSpecialAgreement10").get("v.value") + "\n" +
				"退院・通院特約:" + cmp.find("dischargeHospital10").get("v.value") + "\n" +
				"7疾病特約:" + cmp.find("sevenDiseaseSpecialAgreement10").get("v.value") + "\n" +
				"3大疾病P免特約:" + cmp.find("threeMajorDiseasesPExemption10").get("v.value") + "\n" +
				"継続割引特約:" + cmp.find("continuousDiscountSpecialContract10").get("v.value") + "\n" +
				// 認知症保険PT Ph1
				"介護給付特約:" + cmp.find("longTermCareBnefitSpecialContract10").get("v.value") + "\n" +
				"精神疾患併発入院特約:" + cmp.find("hospitalWithMentalIllnessSpecialContract10").get("v.value") + "\n" +
				"無事故給付特約:" + cmp.find("accidentFreeBenefitSpecialContract10").get("v.value") + "\n" +
				"入院一時金特約:" + cmp.find("hospitalLumpSumRider10").get("v.value");
		}
		else {
			obj.ChangeDetails10__c = "";
		}

		obj.Processing__c = cmp.get("v.innerCmpNewRequest").Processing__c;
		obj.ShippingDocuments__c = cmp.get("v.innerCmpNewRequest").ShippingDocuments__c;
		//obj.NumberOfCopies__c = cmp.get("v.innerCmpNewRequest").NumberOfCopies__c;
		obj.DateOfShipment__c = cmp.get("v.innerCmpNewRequest").DateOfShipment__c;
		obj.ShippingMethod__c = cmp.get("v.innerCmpNewRequest").ShippingMethod__c;
		
		var numberOfCopies = cmp.get("v.numberOfCopies") == null ? "" : cmp.get("v.numberOfCopies");
		var noOfCopiesErr = cmp.get("v.noOfCopiesErr");
        
        obj.NumberOfCopies__c = cmp.get("v.numberOfCopies");

        if (noOfCopiesErr){
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
	init: function (component, event, helper) {
		var opts = [
			{ value: "解約", label: "解約" },
			{ value: "変更無", label: "変更無", selected: true }
		];

		component.set("v.options", opts);
		component.set('v.selectedValue', '変更無');

		var dependantSubject = component.get('v.dependantSubject');
		helper.getProcessingPicklist(component, event, dependantSubject);
		helper.getShippingDocumentsPicklist(component, event, dependantSubject);
		helper.getDateOfShipmentPicklist(component, event);
		helper.getShippingMethodPicklist(component, event);

		component.set("v.innerCmpNewRequest.Processing__c", '手動');
	},
	handlelivingNeedsSpecialAgreement1: function (component, event) {
		var selectedValues = component.find("livingNeedsSpecialAgreement1").get("v.value");
		component.set("v.livingNeedsSpecialAgreement1", selectedValues);
	},
	handlespecialProxyRequest1: function (component, event) {
		var selectedValues = component.find("specialProxyRequest1").get("v.value");
		component.set("v.specialProxyRequest1", selectedValues);
	},
	handleadvancedMedicalSpecialties1: function (component, event) {
		var selectedValues = component.find("advancedMedicalSpecialties1").get("v.value");
		component.set("v.advancedMedicalSpecialties1", selectedValues);
	},
	handlecancerContract1: function (component, event) {
		var selectedValues = component.find("cancerContract1").get("v.value");
		component.set("v.cancerContract1", selectedValues);
	},
	handleacuteMyocardialInfarction1: function (component, event) {
		var selectedValues = component.find("acuteMyocardialInfarction1").get("v.value");
		component.set("v.acuteMyocardialInfarction1", selectedValues);
	},
	handleoutpatientSpecialAgreement1: function (component, event) {
		var selectedValues = component.find("outpatientSpecialAgreement1").get("v.value");
		component.set("v.outpatientSpecialAgreement1", selectedValues);
	},
	handlecancerHospitalizationSpecialAgreement1: function (component, event) {
		var selectedValues = component.find("cancerHospitalizationSpecialAgreement1").get("v.value");
		component.set("v.cancerHospitalizationSpecialAgreement1", selectedValues);
	},
	handledischargeHospital1: function (component, event) {
		var selectedValues = component.find("dischargeHospital1").get("v.value");
		component.set("v.dischargeHospital1", selectedValues);
	},
	handlesevenDiseaseSpecialAgreement1: function (component, event) {
		var selectedValues = component.find("sevenDiseaseSpecialAgreement1").get("v.value");
		component.set("v.sevenDiseaseSpecialAgreement1", selectedValues);
	},
	handlethreeMajorDiseasesPExemption1: function (component, event) {
		var selectedValues = component.find("threeMajorDiseasesPExemption1").get("v.value");
		component.set("v.threeMajorDiseasesPExemption1", selectedValues);
	},
	handlecontinuousDiscountSpecialContract1: function (component, event) {
		var selectedValues = component.find("continuousDiscountSpecialContract1").get("v.value");
		component.set("v.continuousDiscountSpecialContract1", selectedValues);
	},
	// 認知症保険PT Ph1
	handleLongTermCareBnefitSpecialContract1: function (component, event) {
		var selectedValues = component.find("longTermCareBnefitSpecialContract1").get("v.value");
		component.set("v.longTermCareBnefitSpecialContract1", selectedValues);
	},
	handleHospitalWithMentalIllnessSpecialContract1: function (component, event) {
		var selectedValues = component.find("hospitalWithMentalIllnessSpecialContract1").get("v.value");
		component.set("v.hospitalWithMentalIllnessSpecialContract1", selectedValues);
	},
	handleAccidentFreeBenefitSpecialContract1: function (component, event) {
		var selectedValues = component.find("accidentFreeBenefitSpecialContract1").get("v.value");
		component.set("v.accidentFreeBenefitSpecialContract1", selectedValues);
	},
	handleHospitalLumpSumRider1: function (component, event) {
		var selectedValues = component.find("hospitalLumpSumRider1").get("v.value");
		component.set("v.hospitalLumpSumRider1", selectedValues);
	},
	handlerefundAccount1: function (component, event) {
		var selectedValues = component.find("refundAccount1").get("v.value");
		component.set("v.refundAccount1", selectedValues);
	},
	handlelivingNeedsSpecialAgreement2: function (component, event) {
		var selectedValues = component.find("livingNeedsSpecialAgreement2").get("v.value");
		component.set("v.livingNeedsSpecialAgreement2", selectedValues);
	},
	handlespecialProxyRequest2: function (component, event) {
		var selectedValues = component.find("specialProxyRequest2").get("v.value");
		component.set("v.specialProxyRequest2", selectedValues);
	},
	handleadvancedMedicalSpecialties2: function (component, event) {
		var selectedValues = component.find("advancedMedicalSpecialties2").get("v.value");
		component.set("v.advancedMedicalSpecialties2", selectedValues);
	},
	handlecancerContract2: function (component, event) {
		var selectedValues = component.find("cancerContract2").get("v.value");
		component.set("v.cancerContract2", selectedValues);
	},
	handleacuteMyocardialInfarction2: function (component, event) {
		var selectedValues = component.find("acuteMyocardialInfarction2").get("v.value");
		component.set("v.acuteMyocardialInfarction2", selectedValues);
	},
	handleoutpatientSpecialAgreement2: function (component, event) {
		var selectedValues = component.find("outpatientSpecialAgreement2").get("v.value");
		component.set("v.outpatientSpecialAgreement2", selectedValues);
	},
	handlecancerHospitalizationSpecialAgreement2: function (component, event) {
		var selectedValues = component.find("cancerHospitalizationSpecialAgreement2").get("v.value");
		component.set("v.cancerHospitalizationSpecialAgreement2", selectedValues);
	},
	handledischargeHospital2: function (component, event) {
		var selectedValues = component.find("dischargeHospital2").get("v.value");
		component.set("v.dischargeHospital2", selectedValues);
	},
	handlesevenDiseaseSpecialAgreement2: function (component, event) {
		var selectedValues = component.find("sevenDiseaseSpecialAgreement2").get("v.value");
		component.set("v.sevenDiseaseSpecialAgreement2", selectedValues);
	},
	handlethreeMajorDiseasesPExemption2: function (component, event) {
		var selectedValues = component.find("threeMajorDiseasesPExemption2").get("v.value");
		component.set("v.threeMajorDiseasesPExemption2", selectedValues);
	},
	handlecontinuousDiscountSpecialContract2: function (component, event) {
		var selectedValues = component.find("continuousDiscountSpecialContract2").get("v.value");
		component.set("v.continuousDiscountSpecialContract2", selectedValues);
	},
	// 認知症保険PT Ph1
	handleLongTermCareBnefitSpecialContract2: function (component, event) {
		var selectedValues = component.find("longTermCareBnefitSpecialContract2").get("v.value");
		component.set("v.longTermCareBnefitSpecialContract2", selectedValues);
	},
	handleHospitalWithMentalIllnessSpecialContract2: function (component, event) {
		var selectedValues = component.find("hospitalWithMentalIllnessSpecialContract2").get("v.value");
		component.set("v.hospitalWithMentalIllnessSpecialContract2", selectedValues);
	},
	handleAccidentFreeBenefitSpecialContract2: function (component, event) {
		var selectedValues = component.find("accidentFreeBenefitSpecialContract2").get("v.value");
		component.set("v.accidentFreeBenefitSpecialContract2", selectedValues);
	},
	handleHospitalLumpSumRider2: function (component, event) {
		var selectedValues = component.find("hospitalLumpSumRider2").get("v.value");
		component.set("v.hospitalLumpSumRider2", selectedValues);
	},
	handlerefundAccount2: function (component, event) {
		var selectedValues = component.find("refundAccount2").get("v.value");
		component.set("v.refundAccount2", selectedValues);
	},
	handlelivingNeedsSpecialAgreement3: function (component, event) {
		var selectedValues = component.find("livingNeedsSpecialAgreement3").get("v.value");
		component.set("v.livingNeedsSpecialAgreement3", selectedValues);
	},
	handlespecialProxyRequest3: function (component, event) {
		var selectedValues = component.find("specialProxyRequest3").get("v.value");
		component.set("v.specialProxyRequest3", selectedValues);
	},
	handleadvancedMedicalSpecialties3: function (component, event) {
		var selectedValues = component.find("advancedMedicalSpecialties3").get("v.value");
		component.set("v.advancedMedicalSpecialties3", selectedValues);
	},
	handlecancerContract3: function (component, event) {
		var selectedValues = component.find("cancerContract3").get("v.value");
		component.set("v.cancerContract3", selectedValues);
	},
	handleacuteMyocardialInfarction3: function (component, event) {
		var selectedValues = component.find("acuteMyocardialInfarction3").get("v.value");
		component.set("v.acuteMyocardialInfarction3", selectedValues);
	},
	handleoutpatientSpecialAgreement3: function (component, event) {
		var selectedValues = component.find("outpatientSpecialAgreement3").get("v.value");
		component.set("v.outpatientSpecialAgreement3", selectedValues);
	},
	handlecancerHospitalizationSpecialAgreement3: function (component, event) {
		var selectedValues = component.find("cancerHospitalizationSpecialAgreement3").get("v.value");
		component.set("v.cancerHospitalizationSpecialAgreement3", selectedValues);
	},
	handledischargeHospital3: function (component, event) {
		var selectedValues = component.find("dischargeHospital3").get("v.value");
		component.set("v.dischargeHospital3", selectedValues);
	},
	handlesevenDiseaseSpecialAgreement3: function (component, event) {
		var selectedValues = component.find("sevenDiseaseSpecialAgreement3").get("v.value");
		component.set("v.sevenDiseaseSpecialAgreement3", selectedValues);
	},
	handlethreeMajorDiseasesPExemption3: function (component, event) {
		var selectedValues = component.find("threeMajorDiseasesPExemption3").get("v.value");
		component.set("v.threeMajorDiseasesPExemption3", selectedValues);
	},
	handlecontinuousDiscountSpecialContract3: function (component, event) {
		var selectedValues = component.find("continuousDiscountSpecialContract3").get("v.value");
		component.set("v.continuousDiscountSpecialContract3", selectedValues);
	},
	// 認知症保険PT Ph1
	handleLongTermCareBnefitSpecialContract3: function (component, event) {
		var selectedValues = component.find("longTermCareBnefitSpecialContract3").get("v.value");
		component.set("v.longTermCareBnefitSpecialContract3", selectedValues);
	},
	handleHospitalWithMentalIllnessSpecialContract3: function (component, event) {
		var selectedValues = component.find("hospitalWithMentalIllnessSpecialContract3").get("v.value");
		component.set("v.hospitalWithMentalIllnessSpecialContract3", selectedValues);
	},
	handleAccidentFreeBenefitSpecialContract3: function (component, event) {
		var selectedValues = component.find("accidentFreeBenefitSpecialContract3").get("v.value");
		component.set("v.accidentFreeBenefitSpecialContract3", selectedValues);
	},
	handleHospitalLumpSumRider3: function (component, event) {
		var selectedValues = component.find("hospitalLumpSumRider3").get("v.value");
		component.set("v.hospitalLumpSumRider3", selectedValues);
	},
	handlerefundAccount3: function (component, event) {
		var selectedValues = component.find("refundAccount3").get("v.value");
		component.set("v.refundAccount3", selectedValues);
	},
	handlelivingNeedsSpecialAgreement4: function (component, event) {
		var selectedValues = component.find("livingNeedsSpecialAgreement4").get("v.value");
		component.set("v.livingNeedsSpecialAgreement4", selectedValues);
	},
	handlespecialProxyRequest4: function (component, event) {
		var selectedValues = component.find("specialProxyRequest4").get("v.value");
		component.set("v.specialProxyRequest4", selectedValues);
	},
	handleadvancedMedicalSpecialties4: function (component, event) {
		var selectedValues = component.find("advancedMedicalSpecialties4").get("v.value");
		component.set("v.advancedMedicalSpecialties4", selectedValues);
	},
	handlecancerContract4: function (component, event) {
		var selectedValues = component.find("cancerContract4").get("v.value");
		component.set("v.cancerContract4", selectedValues);
	},
	handleacuteMyocardialInfarction4: function (component, event) {
		var selectedValues = component.find("acuteMyocardialInfarction4").get("v.value");
		component.set("v.acuteMyocardialInfarction4", selectedValues);
	},
	handleoutpatientSpecialAgreement4: function (component, event) {
		var selectedValues = component.find("outpatientSpecialAgreement4").get("v.value");
		component.set("v.outpatientSpecialAgreement4", selectedValues);
	},
	handlecancerHospitalizationSpecialAgreement4: function (component, event) {
		var selectedValues = component.find("cancerHospitalizationSpecialAgreement4").get("v.value");
		component.set("v.cancerHospitalizationSpecialAgreement4", selectedValues);
	},
	handledischargeHospital4: function (component, event) {
		var selectedValues = component.find("dischargeHospital4").get("v.value");
		component.set("v.dischargeHospital4", selectedValues);
	},
	handlesevenDiseaseSpecialAgreement4: function (component, event) {
		var selectedValues = component.find("sevenDiseaseSpecialAgreement4").get("v.value");
		component.set("v.sevenDiseaseSpecialAgreement4", selectedValues);
	},
	handlethreeMajorDiseasesPExemption4: function (component, event) {
		var selectedValues = component.find("threeMajorDiseasesPExemption4").get("v.value");
		component.set("v.threeMajorDiseasesPExemption4", selectedValues);
	},
	handlecontinuousDiscountSpecialContract4: function (component, event) {
		var selectedValues = component.find("continuousDiscountSpecialContract4").get("v.value");
		component.set("v.continuousDiscountSpecialContract4", selectedValues);
	},
	// 認知症保険PT Ph1
	handleLongTermCareBnefitSpecialContract4: function (component, event) {
		var selectedValues = component.find("longTermCareBnefitSpecialContract4").get("v.value");
		component.set("v.longTermCareBnefitSpecialContract4", selectedValues);
	},
	handleHospitalWithMentalIllnessSpecialContract4: function (component, event) {
		var selectedValues = component.find("hospitalWithMentalIllnessSpecialContract4").get("v.value");
		component.set("v.hospitalWithMentalIllnessSpecialContract4", selectedValues);
	},
	handleAccidentFreeBenefitSpecialContract4: function (component, event) {
		var selectedValues = component.find("accidentFreeBenefitSpecialContract4").get("v.value");
		component.set("v.accidentFreeBenefitSpecialContract4", selectedValues);
	},
	handleHospitalLumpSumRider4: function (component, event) {
		var selectedValues = component.find("hospitalLumpSumRider4").get("v.value");
		component.set("v.hospitalLumpSumRider4", selectedValues);
	},
	handlerefundAccount4: function (component, event) {
		var selectedValues = component.find("refundAccount4").get("v.value");
		component.set("v.refundAccount4", selectedValues);
	},
	handlelivingNeedsSpecialAgreement5: function (component, event) {
		var selectedValues = component.find("livingNeedsSpecialAgreement5").get("v.value");
		component.set("v.livingNeedsSpecialAgreement5", selectedValues);
	},
	handlespecialProxyRequest5: function (component, event) {
		var selectedValues = component.find("specialProxyRequest5").get("v.value");
		component.set("v.specialProxyRequest5", selectedValues);
	},
	handleadvancedMedicalSpecialties5: function (component, event) {
		var selectedValues = component.find("advancedMedicalSpecialties5").get("v.value");
		component.set("v.advancedMedicalSpecialties5", selectedValues);
	},
	handlecancerContract5: function (component, event) {
		var selectedValues = component.find("cancerContract5").get("v.value");
		component.set("v.cancerContract5", selectedValues);
	},
	handleacuteMyocardialInfarction5: function (component, event) {
		var selectedValues = component.find("acuteMyocardialInfarction5").get("v.value");
		component.set("v.acuteMyocardialInfarction5", selectedValues);
	},
	handleoutpatientSpecialAgreement5: function (component, event) {
		var selectedValues = component.find("outpatientSpecialAgreement5").get("v.value");
		component.set("v.outpatientSpecialAgreement5", selectedValues);
	},
	handlecancerHospitalizationSpecialAgreement5: function (component, event) {
		var selectedValues = component.find("cancerHospitalizationSpecialAgreement5").get("v.value");
		component.set("v.cancerHospitalizationSpecialAgreement5", selectedValues);
	},
	handledischargeHospital5: function (component, event) {
		var selectedValues = component.find("dischargeHospital5").get("v.value");
		component.set("v.dischargeHospital5", selectedValues);
	},
	handlesevenDiseaseSpecialAgreement5: function (component, event) {
		var selectedValues = component.find("sevenDiseaseSpecialAgreement5").get("v.value");
		component.set("v.sevenDiseaseSpecialAgreement5", selectedValues);
	},
	handlethreeMajorDiseasesPExemption5: function (component, event) {
		var selectedValues = component.find("threeMajorDiseasesPExemption5").get("v.value");
		component.set("v.threeMajorDiseasesPExemption5", selectedValues);
	},
	handlecontinuousDiscountSpecialContract5: function (component, event) {
		var selectedValues = component.find("continuousDiscountSpecialContract5").get("v.value");
		component.set("v.continuousDiscountSpecialContract5", selectedValues);
	},
	// 認知症保険PT Ph1
	handleLongTermCareBnefitSpecialContract5: function (component, event) {
		var selectedValues = component.find("longTermCareBnefitSpecialContract5").get("v.value");
		component.set("v.longTermCareBnefitSpecialContract5", selectedValues);
	},
	handleHospitalWithMentalIllnessSpecialContract5: function (component, event) {
		var selectedValues = component.find("hospitalWithMentalIllnessSpecialContract5").get("v.value");
		component.set("v.hospitalWithMentalIllnessSpecialContract5", selectedValues);
	},
	handleAccidentFreeBenefitSpecialContract5: function (component, event) {
		var selectedValues = component.find("accidentFreeBenefitSpecialContract5").get("v.value");
		component.set("v.accidentFreeBenefitSpecialContract5", selectedValues);
	},
	handleHospitalLumpSumRider5: function (component, event) {
		var selectedValues = component.find("hospitalLumpSumRider5").get("v.value");
		component.set("v.hospitalLumpSumRider5", selectedValues);
	},
	handlerefundAccount5: function (component, event) {
		var selectedValues = component.find("refundAccount5").get("v.value");
		component.set("v.refundAccount5", selectedValues);
	},
	handlelivingNeedsSpecialAgreement6: function (component, event) {
		var selectedValues = component.find("livingNeedsSpecialAgreement6").get("v.value");
		component.set("v.livingNeedsSpecialAgreement6", selectedValues);
	},
	handlespecialProxyRequest6: function (component, event) {
		var selectedValues = component.find("specialProxyRequest6").get("v.value");
		component.set("v.specialProxyRequest6", selectedValues);
	},
	handleadvancedMedicalSpecialties6: function (component, event) {
		var selectedValues = component.find("advancedMedicalSpecialties6").get("v.value");
		component.set("v.advancedMedicalSpecialties6", selectedValues);
	},
	handlecancerContract6: function (component, event) {
		var selectedValues = component.find("cancerContract6").get("v.value");
		component.set("v.cancerContract6", selectedValues);
	},
	handleacuteMyocardialInfarction6: function (component, event) {
		var selectedValues = component.find("acuteMyocardialInfarction6").get("v.value");
		component.set("v.acuteMyocardialInfarction6", selectedValues);
	},
	handleoutpatientSpecialAgreement6: function (component, event) {
		var selectedValues = component.find("outpatientSpecialAgreement6").get("v.value");
		component.set("v.outpatientSpecialAgreement6", selectedValues);
	},
	handlecancerHospitalizationSpecialAgreement6: function (component, event) {
		var selectedValues = component.find("cancerHospitalizationSpecialAgreement6").get("v.value");
		component.set("v.cancerHospitalizationSpecialAgreement6", selectedValues);
	},
	handledischargeHospital6: function (component, event) {
		var selectedValues = component.find("dischargeHospital6").get("v.value");
		component.set("v.dischargeHospital6", selectedValues);
	},
	handlesevenDiseaseSpecialAgreement6: function (component, event) {
		var selectedValues = component.find("sevenDiseaseSpecialAgreement6").get("v.value");
		component.set("v.sevenDiseaseSpecialAgreement6", selectedValues);
	},
	handlethreeMajorDiseasesPExemption6: function (component, event) {
		var selectedValues = component.find("threeMajorDiseasesPExemption6").get("v.value");
		component.set("v.threeMajorDiseasesPExemption6", selectedValues);
	},
	handlecontinuousDiscountSpecialContract6: function (component, event) {
		var selectedValues = component.find("continuousDiscountSpecialContract6").get("v.value");
		component.set("v.continuousDiscountSpecialContract6", selectedValues);
	},
	// 認知症保険PT Ph1
	handleLongTermCareBnefitSpecialContract6: function (component, event) {
		var selectedValues = component.find("longTermCareBnefitSpecialContract6").get("v.value");
		component.set("v.longTermCareBnefitSpecialContract6", selectedValues);
	},
	handleHospitalWithMentalIllnessSpecialContract6: function (component, event) {
		var selectedValues = component.find("hospitalWithMentalIllnessSpecialContract6").get("v.value");
		component.set("v.hospitalWithMentalIllnessSpecialContract6", selectedValues);
	},
	handleAccidentFreeBenefitSpecialContract6: function (component, event) {
		var selectedValues = component.find("accidentFreeBenefitSpecialContract6").get("v.value");
		component.set("v.accidentFreeBenefitSpecialContract6", selectedValues);
	},
	handleHospitalLumpSumRider6: function (component, event) {
		var selectedValues = component.find("hospitalLumpSumRider6").get("v.value");
		component.set("v.hospitalLumpSumRider6", selectedValues);
	},
	handlerefundAccount6: function (component, event) {
		var selectedValues = component.find("refundAccount6").get("v.value");
		component.set("v.refundAccount6", selectedValues);
	},
	handlelivingNeedsSpecialAgreement7: function (component, event) {
		var selectedValues = component.find("livingNeedsSpecialAgreement7").get("v.value");
		component.set("v.livingNeedsSpecialAgreement7", selectedValues);
	},
	handlespecialProxyRequest7: function (component, event) {
		var selectedValues = component.find("specialProxyRequest7").get("v.value");
		component.set("v.specialProxyRequest7", selectedValues);
	},
	handleadvancedMedicalSpecialties7: function (component, event) {
		var selectedValues = component.find("advancedMedicalSpecialties7").get("v.value");
		component.set("v.advancedMedicalSpecialties7", selectedValues);
	},
	handlecancerContract7: function (component, event) {
		var selectedValues = component.find("cancerContract7").get("v.value");
		component.set("v.cancerContract7", selectedValues);
	},
	handleacuteMyocardialInfarction7: function (component, event) {
		var selectedValues = component.find("acuteMyocardialInfarction7").get("v.value");
		component.set("v.acuteMyocardialInfarction7", selectedValues);
	},
	handleoutpatientSpecialAgreement7: function (component, event) {
		var selectedValues = component.find("outpatientSpecialAgreement7").get("v.value");
		component.set("v.outpatientSpecialAgreement7", selectedValues);
	},
	handlecancerHospitalizationSpecialAgreement7: function (component, event) {
		var selectedValues = component.find("cancerHospitalizationSpecialAgreement7").get("v.value");
		component.set("v.cancerHospitalizationSpecialAgreement7", selectedValues);
	},
	handledischargeHospital7: function (component, event) {
		var selectedValues = component.find("dischargeHospital7").get("v.value");
		component.set("v.dischargeHospital7", selectedValues);
	},
	handlesevenDiseaseSpecialAgreement7: function (component, event) {
		var selectedValues = component.find("sevenDiseaseSpecialAgreement7").get("v.value");
		component.set("v.sevenDiseaseSpecialAgreement7", selectedValues);
	},
	handlethreeMajorDiseasesPExemption7: function (component, event) {
		var selectedValues = component.find("threeMajorDiseasesPExemption7").get("v.value");
		component.set("v.threeMajorDiseasesPExemption7", selectedValues);
	},
	handlecontinuousDiscountSpecialContract7: function (component, event) {
		var selectedValues = component.find("continuousDiscountSpecialContract7").get("v.value");
		component.set("v.continuousDiscountSpecialContract7", selectedValues);
	},
	// 認知症保険PT Ph1
	handleLongTermCareBnefitSpecialContract7: function (component, event) {
		var selectedValues = component.find("longTermCareBnefitSpecialContract7").get("v.value");
		component.set("v.longTermCareBnefitSpecialContract7", selectedValues);
	},
	handleHospitalWithMentalIllnessSpecialContract7: function (component, event) {
		var selectedValues = component.find("hospitalWithMentalIllnessSpecialContract7").get("v.value");
		component.set("v.hospitalWithMentalIllnessSpecialContract7", selectedValues);
	},
	handleAccidentFreeBenefitSpecialContract7: function (component, event) {
		var selectedValues = component.find("accidentFreeBenefitSpecialContract7").get("v.value");
		component.set("v.accidentFreeBenefitSpecialContract7", selectedValues);
	},
	handleHospitalLumpSumRider7: function (component, event) {
		var selectedValues = component.find("hospitalLumpSumRider7").get("v.value");
		component.set("v.hospitalLumpSumRider7", selectedValues);
	},
	handlerefundAccount7: function (component, event) {
		var selectedValues = component.find("refundAccount7").get("v.value");
		component.set("v.refundAccount7", selectedValues);
	},
	handlelivingNeedsSpecialAgreement8: function (component, event) {
		var selectedValues = component.find("livingNeedsSpecialAgreement8").get("v.value");
		component.set("v.livingNeedsSpecialAgreement8", selectedValues);
	},
	handlespecialProxyRequest8: function (component, event) {
		var selectedValues = component.find("specialProxyRequest8").get("v.value");
		component.set("v.specialProxyRequest8", selectedValues);
	},
	handleadvancedMedicalSpecialties8: function (component, event) {
		var selectedValues = component.find("advancedMedicalSpecialties8").get("v.value");
		component.set("v.advancedMedicalSpecialties8", selectedValues);
	},
	handlecancerContract8: function (component, event) {
		var selectedValues = component.find("cancerContract8").get("v.value");
		component.set("v.cancerContract8", selectedValues);
	},
	handleacuteMyocardialInfarction8: function (component, event) {
		var selectedValues = component.find("acuteMyocardialInfarction8").get("v.value");
		component.set("v.acuteMyocardialInfarction8", selectedValues);
	},
	handleoutpatientSpecialAgreement8: function (component, event) {
		var selectedValues = component.find("outpatientSpecialAgreement8").get("v.value");
		component.set("v.outpatientSpecialAgreement8", selectedValues);
	},
	handlecancerHospitalizationSpecialAgreement8: function (component, event) {
		var selectedValues = component.find("cancerHospitalizationSpecialAgreement8").get("v.value");
		component.set("v.cancerHospitalizationSpecialAgreement8", selectedValues);
	},
	handledischargeHospital8: function (component, event) {
		var selectedValues = component.find("dischargeHospital8").get("v.value");
		component.set("v.dischargeHospital8", selectedValues);
	},
	handlesevenDiseaseSpecialAgreement8: function (component, event) {
		var selectedValues = component.find("sevenDiseaseSpecialAgreement8").get("v.value");
		component.set("v.sevenDiseaseSpecialAgreement8", selectedValues);
	},
	handlethreeMajorDiseasesPExemption8: function (component, event) {
		var selectedValues = component.find("threeMajorDiseasesPExemption8").get("v.value");
		component.set("v.threeMajorDiseasesPExemption8", selectedValues);
	},
	handlecontinuousDiscountSpecialContract8: function (component, event) {
		var selectedValues = component.find("continuousDiscountSpecialContract8").get("v.value");
		component.set("v.continuousDiscountSpecialContract8", selectedValues);
	},
	// 認知症保険PT Ph1
	handleLongTermCareBnefitSpecialContract8: function (component, event) {
		var selectedValues = component.find("longTermCareBnefitSpecialContract8").get("v.value");
		component.set("v.longTermCareBnefitSpecialContract8", selectedValues);
	},
	handleHospitalWithMentalIllnessSpecialContract8: function (component, event) {
		var selectedValues = component.find("hospitalWithMentalIllnessSpecialContract8").get("v.value");
		component.set("v.hospitalWithMentalIllnessSpecialContract8", selectedValues);
	},
	handleAccidentFreeBenefitSpecialContract8: function (component, event) {
		var selectedValues = component.find("accidentFreeBenefitSpecialContract8").get("v.value");
		component.set("v.accidentFreeBenefitSpecialContract8", selectedValues);
	},
	handleHospitalLumpSumRider8: function (component, event) {
		var selectedValues = component.find("hospitalLumpSumRider8").get("v.value");
		component.set("v.hospitalLumpSumRider8", selectedValues);
	},
	handlerefundAccount8: function (component, event) {
		var selectedValues = component.find("refundAccount8").get("v.value");
		component.set("v.refundAccount8", selectedValues);
	},
	handlelivingNeedsSpecialAgreement9: function (component, event) {
		var selectedValues = component.find("livingNeedsSpecialAgreement9").get("v.value");
		component.set("v.livingNeedsSpecialAgreement9", selectedValues);
	},
	handlespecialProxyRequest9: function (component, event) {
		var selectedValues = component.find("specialProxyRequest9").get("v.value");
		component.set("v.specialProxyRequest9", selectedValues);
	},
	handleadvancedMedicalSpecialties9: function (component, event) {
		var selectedValues = component.find("advancedMedicalSpecialties9").get("v.value");
		component.set("v.advancedMedicalSpecialties9", selectedValues);
	},
	handlecancerContract9: function (component, event) {
		var selectedValues = component.find("cancerContract9").get("v.value");
		component.set("v.cancerContract9", selectedValues);
	},
	handleacuteMyocardialInfarction9: function (component, event) {
		var selectedValues = component.find("acuteMyocardialInfarction9").get("v.value");
		component.set("v.acuteMyocardialInfarction9", selectedValues);
	},
	handleoutpatientSpecialAgreement9: function (component, event) {
		var selectedValues = component.find("outpatientSpecialAgreement9").get("v.value");
		component.set("v.outpatientSpecialAgreement9", selectedValues);
	},
	handlecancerHospitalizationSpecialAgreement9: function (component, event) {
		var selectedValues = component.find("cancerHospitalizationSpecialAgreement9").get("v.value");
		component.set("v.cancerHospitalizationSpecialAgreement9", selectedValues);
	},
	handledischargeHospital9: function (component, event) {
		var selectedValues = component.find("dischargeHospital9").get("v.value");
		component.set("v.dischargeHospital9", selectedValues);
	},
	handlesevenDiseaseSpecialAgreement9: function (component, event) {
		var selectedValues = component.find("sevenDiseaseSpecialAgreement9").get("v.value");
		component.set("v.sevenDiseaseSpecialAgreement9", selectedValues);
	},
	handlethreeMajorDiseasesPExemption9: function (component, event) {
		var selectedValues = component.find("threeMajorDiseasesPExemption9").get("v.value");
		component.set("v.threeMajorDiseasesPExemption9", selectedValues);
	},
	handlecontinuousDiscountSpecialContract9: function (component, event) {
		var selectedValues = component.find("continuousDiscountSpecialContract9").get("v.value");
		component.set("v.continuousDiscountSpecialContract9", selectedValues);
	},
	// 認知症保険PT Ph1
	handleLongTermCareBnefitSpecialContract9: function (component, event) {
		var selectedValues = component.find("longTermCareBnefitSpecialContract9").get("v.value");
		component.set("v.longTermCareBnefitSpecialContract9", selectedValues);
	},
	handleHospitalWithMentalIllnessSpecialContract9: function (component, event) {
		var selectedValues = component.find("hospitalWithMentalIllnessSpecialContract9").get("v.value");
		component.set("v.hospitalWithMentalIllnessSpecialContract9", selectedValues);
	},
	handleAccidentFreeBenefitSpecialContract9: function (component, event) {
		var selectedValues = component.find("accidentFreeBenefitSpecialContract9").get("v.value");
		component.set("v.accidentFreeBenefitSpecialContract9", selectedValues);
	},
	handleHospitalLumpSumRider9: function (component, event) {
		var selectedValues = component.find("hospitalLumpSumRider9").get("v.value");
		component.set("v.hospitalLumpSumRider9", selectedValues);
	},
	handlerefundAccount9: function (component, event) {
		var selectedValues = component.find("refundAccount9").get("v.value");
		component.set("v.refundAccount9", selectedValues);
	},
	handlelivingNeedsSpecialAgreement10: function (component, event) {
		var selectedValues = component.find("livingNeedsSpecialAgreement10").get("v.value");
		component.set("v.livingNeedsSpecialAgreement10", selectedValues);
	},
	handlespecialProxyRequest10: function (component, event) {
		var selectedValues = component.find("specialProxyRequest10").get("v.value");
		component.set("v.specialProxyRequest10", selectedValues);
	},
	handleadvancedMedicalSpecialties10: function (component, event) {
		var selectedValues = component.find("advancedMedicalSpecialties10").get("v.value");
		component.set("v.advancedMedicalSpecialties10", selectedValues);
	},
	handlecancerContract10: function (component, event) {
		var selectedValues = component.find("cancerContract10").get("v.value");
		component.set("v.cancerContract10", selectedValues);
	},
	handleacuteMyocardialInfarction10: function (component, event) {
		var selectedValues = component.find("acuteMyocardialInfarction10").get("v.value");
		component.set("v.acuteMyocardialInfarction10", selectedValues);
	},
	handleoutpatientSpecialAgreement10: function (component, event) {
		var selectedValues = component.find("outpatientSpecialAgreement10").get("v.value");
		component.set("v.outpatientSpecialAgreement10", selectedValues);
	},
	handlecancerHospitalizationSpecialAgreement10: function (component, event) {
		var selectedValues = component.find("cancerHospitalizationSpecialAgreement10").get("v.value");
		component.set("v.cancerHospitalizationSpecialAgreement10", selectedValues);
	},
	handledischargeHospital10: function (component, event) {
		var selectedValues = component.find("dischargeHospital10").get("v.value");
		component.set("v.dischargeHospital10", selectedValues);
	},
	handlesevenDiseaseSpecialAgreement10: function (component, event) {
		var selectedValues = component.find("sevenDiseaseSpecialAgreement10").get("v.value");
		component.set("v.sevenDiseaseSpecialAgreement10", selectedValues);
	},
	handlethreeMajorDiseasesPExemption10: function (component, event) {
		var selectedValues = component.find("threeMajorDiseasesPExemption10").get("v.value");
		component.set("v.threeMajorDiseasesPExemption10", selectedValues);
	},
	handlecontinuousDiscountSpecialContract10: function (component, event) {
		var selectedValues = component.find("continuousDiscountSpecialContract10").get("v.value");
		component.set("v.continuousDiscountSpecialContract10", selectedValues);
	},
	// 認知症保険PT Ph1
	handleLongTermCareBnefitSpecialContract10: function (component, event) {
		var selectedValues = component.find("longTermCareBnefitSpecialContract10").get("v.value");
		component.set("v.longTermCareBnefitSpecialContract10", selectedValues);
	},
	handleHospitalWithMentalIllnessSpecialContract10: function (component, event) {
		var selectedValues = component.find("hospitalWithMentalIllnessSpecialContract10").get("v.value");
		component.set("v.hospitalWithMentalIllnessSpecialContract10", selectedValues);
	},
	handleAccidentFreeBenefitSpecialContract10: function (component, event) {
		var selectedValues = component.find("accidentFreeBenefitSpecialContract10").get("v.value");
		component.set("v.accidentFreeBenefitSpecialContract10", selectedValues);
	},
	handleHospitalLumpSumRider10: function (component, event) {
		var selectedValues = component.find("hospitalLumpSumRider10").get("v.value");
		component.set("v.hospitalLumpSumRider10", selectedValues);
	},
	handlerefundAccount10: function (component, event) {
		var selectedValues = component.find("refundAccount10").get("v.value");
		component.set("v.refundAccount10", selectedValues);
	},
	handleProcessingPick: function (component, event, helper) {
		var disableFlag;
		var processingInput = component.get("v.innerCmpNewRequest.Processing__c");
		if (processingInput == "書類発送") {
			disableFlag = false;
		} else {
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
    handleNoOfCopies : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.numberOfCopies","v.noOfCopiesErr");
    }
})