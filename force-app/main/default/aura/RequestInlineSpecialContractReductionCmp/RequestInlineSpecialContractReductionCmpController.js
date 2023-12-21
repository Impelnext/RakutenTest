/**
 * @File Name          : RequestInlineSpecialContractReductionCmpController.js
 * @Description        : 
 * @Author             : SRM
 * @Group              : 
 * @Last Modified By   : SRM
 * @Last Modified On   : 12/23/2019, 2:06:41 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    12/23/2019   SRM     Initial Version
**/
({
    saveInlineRequestSpecialContractReduction: function (cmp, event, helper) {
        var params = event.getParam('arguments');
        var obj = params.parentNewRequest;
		
		// Check all Number Input field once again before Save
		helper.getSingleByteNumberCheck(cmp, event, "v.cancerTreaty1", "v.cancerTreatyErr1");
        helper.getSingleByteNumberCheck(cmp, event, "v.heartAttackStrokeAfter1", "v.heartAttackStrokeAfterErr1");
        helper.getSingleByteNumberCheck(cmp, event, "v.heartAttackStrokeBefore1", "v.heartAttackStrokeBeforeErr1");
        helper.getSingleByteNumberCheck(cmp, event, "v.afterCancerSpecialContractReduction1", "v.afterCancerSpecialContractReductionErr1");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalSpecialContracteforeReduc1", "v.hospitalSpecialContracteforeReducErr1");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalSpecialContractAfterReducti1", "v.hospitalSpecialContractAfterReductiErr1");
        helper.getSingleByteNumberCheck(cmp, event, "v.beforeHospitalizationSpecialContract1", "v.beforeHospitalizationSpecialContractErr1");
        helper.getSingleByteNumberCheck(cmp, event, "v.afterHospitalizationSpecialContract1", "v.afterHospitalizationSpecialContractErr1");
        helper.getSingleByteNumberCheck(cmp, event, "v.dischargeHospitalSpecialContractF1", "v.dischargeHospitalSpecialContractFErr1");
        helper.getSingleByteNumberCheck(cmp, event, "v.dischargeHospitalSpecialContractAf1", "v.dischargeHospitalSpecialContractAfErr1");
        helper.getSingleByteNumberCheck(cmp, event, "v.sevenSpecialContractFront1", "v.sevenSpecialContractFrontErr1");
        helper.getSingleByteNumberCheck(cmp, event, "v.sevenSpecialAfter1", "v.sevenSpecialAfterErr1");
        helper.getSingleByteNumberCheck(cmp, event, "v.longTermCareBnefitSpecialContractBefore1", "v.longTermCareBnefitSpecialContractBeforeErr1");
        helper.getSingleByteNumberCheck(cmp, event, "v.longTermCareBnefitSpecialContractAfter1", "v.longTermCareBnefitSpecialContractAfterErr1");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalWithMentalIllnessSpecialContractBefore1", "v.hospitalWithMentalIllnessSpecialContractBeforeErr1");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalWithMentalIllnessSpecialContractAfter1", "v.hospitalWithMentalIllnessSpecialContractAfterErr1");
        helper.getSingleByteNumberCheck(cmp, event, "v.accidentFreeBenefitSpecialContractBefore1", "v.accidentFreeBenefitSpecialContractBeforeErr1");
        helper.getSingleByteNumberCheck(cmp, event, "v.accidentFreeBenefitSpecialContractAfter1", "v.accidentFreeBenefitSpecialContractAfterErr1");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalLumpSumRiderBefore1", "v.hospitalLumpSumRiderBeforeErr1");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalLumpSumRiderAfter1", "v.hospitalLumpSumRiderAfterErr1");
        helper.getSingleByteNumberCheck(cmp, event, "v.cancerTreaty2", "v.cancerTreatyErr2");
        helper.getSingleByteNumberCheck(cmp, event, "v.afterCancerSpecialContractReduction2", "v.afterCancerSpecialContractReductionErr2");
        helper.getSingleByteNumberCheck(cmp, event, "v.heartAttackStrokeAfter2", "v.heartAttackStrokeAfterErr2");
        helper.getSingleByteNumberCheck(cmp, event, "v.heartAttackStrokeBefore2", "v.heartAttackStrokeBeforeErr2");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalSpecialContracteforeReduc2", "v.hospitalSpecialContracteforeReducErr2");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalSpecialContractAfterReducti2", "v.hospitalSpecialContractAfterReductiErr2");
        helper.getSingleByteNumberCheck(cmp, event, "v.beforeHospitalizationSpecialContract2", "v.beforeHospitalizationSpecialContractErr2");
        helper.getSingleByteNumberCheck(cmp, event, "v.afterHospitalizationSpecialContract2", "v.afterHospitalizationSpecialContractErr2");
        helper.getSingleByteNumberCheck(cmp, event, "v.dischargeHospitalSpecialContractF2", "v.dischargeHospitalSpecialContractFErr2");
        helper.getSingleByteNumberCheck(cmp, event, "v.dischargeHospitalSpecialContractAf2", "v.dischargeHospitalSpecialContractAfErr2");
        helper.getSingleByteNumberCheck(cmp, event, "v.sevenSpecialContractFront2", "v.sevenSpecialContractFrontErr2");
        helper.getSingleByteNumberCheck(cmp, event, "v.sevenSpecialAfter2", "v.sevenSpecialAfterErr2");
        helper.getSingleByteNumberCheck(cmp, event, "v.longTermCareBnefitSpecialContractBefore2", "v.longTermCareBnefitSpecialContractBeforeErr2");
        helper.getSingleByteNumberCheck(cmp, event, "v.longTermCareBnefitSpecialContractAfter2", "v.longTermCareBnefitSpecialContractAfterErr2");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalWithMentalIllnessSpecialContractBefore2", "v.hospitalWithMentalIllnessSpecialContractBeforeErr2");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalWithMentalIllnessSpecialContractAfter2", "v.hospitalWithMentalIllnessSpecialContractAfterErr2");
        helper.getSingleByteNumberCheck(cmp, event, "v.accidentFreeBenefitSpecialContractBefore2", "v.accidentFreeBenefitSpecialContractBeforeErr2");
        helper.getSingleByteNumberCheck(cmp, event, "v.accidentFreeBenefitSpecialContractAfter2", "v.accidentFreeBenefitSpecialContractAfterErr2");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalLumpSumRiderBefore2", "v.hospitalLumpSumRiderBeforeErr2");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalLumpSumRiderAfter2", "v.hospitalLumpSumRiderAfterErr2");
        helper.getSingleByteNumberCheck(cmp, event, "v.cancerTreaty3", "v.cancerTreatyErr3");
        helper.getSingleByteNumberCheck(cmp, event, "v.afterCancerSpecialContractReduction3", "v.afterCancerSpecialContractReductionErr3");
        helper.getSingleByteNumberCheck(cmp, event, "v.heartAttackStrokeAfter3", "v.heartAttackStrokeAfterErr3");
        helper.getSingleByteNumberCheck(cmp, event, "v.heartAttackStrokeBefore3", "v.heartAttackStrokeBeforeErr3");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalSpecialContracteforeReduc3", "v.hospitalSpecialContracteforeReducErr3");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalSpecialContractAfterReducti3", "v.hospitalSpecialContractAfterReductiErr3");
        helper.getSingleByteNumberCheck(cmp, event, "v.beforeHospitalizationSpecialContract3", "v.beforeHospitalizationSpecialContractErr3");
        helper.getSingleByteNumberCheck(cmp, event, "v.afterHospitalizationSpecialContract3", "v.afterHospitalizationSpecialContractErr3");
        helper.getSingleByteNumberCheck(cmp, event, "v.dischargeHospitalSpecialContractF3", "v.dischargeHospitalSpecialContractFErr3");
        helper.getSingleByteNumberCheck(cmp, event, "v.dischargeHospitalSpecialContractAf3", "v.dischargeHospitalSpecialContractAfErr3");
        helper.getSingleByteNumberCheck(cmp, event, "v.sevenSpecialContractFront3", "v.sevenSpecialContractFrontErr3");
        helper.getSingleByteNumberCheck(cmp, event, "v.sevenSpecialAfter3", "v.sevenSpecialAfterErr3");
        helper.getSingleByteNumberCheck(cmp, event, "v.longTermCareBnefitSpecialContractBefore3", "v.longTermCareBnefitSpecialContractBeforeErr3");
        helper.getSingleByteNumberCheck(cmp, event, "v.longTermCareBnefitSpecialContractAfter3", "v.longTermCareBnefitSpecialContractAfterErr3");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalWithMentalIllnessSpecialContractBefore3", "v.hospitalWithMentalIllnessSpecialContractBeforeErr3");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalWithMentalIllnessSpecialContractAfter3", "v.hospitalWithMentalIllnessSpecialContractAfterErr3");
        helper.getSingleByteNumberCheck(cmp, event, "v.accidentFreeBenefitSpecialContractBefore3", "v.accidentFreeBenefitSpecialContractBeforeErr3");
        helper.getSingleByteNumberCheck(cmp, event, "v.accidentFreeBenefitSpecialContractAfter3", "v.accidentFreeBenefitSpecialContractAfterErr3");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalLumpSumRiderBefore3", "v.hospitalLumpSumRiderBeforeErr3");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalLumpSumRiderAfter3", "v.hospitalLumpSumRiderAfterErr3");
        helper.getSingleByteNumberCheck(cmp, event, "v.cancerTreaty4", "v.cancerTreatyErr4");
        helper.getSingleByteNumberCheck(cmp, event, "v.afterCancerSpecialContractReduction4", "v.afterCancerSpecialContractReductionErr4");
        helper.getSingleByteNumberCheck(cmp, event, "v.heartAttackStrokeAfter4", "v.heartAttackStrokeAfterErr4");
        helper.getSingleByteNumberCheck(cmp, event, "v.heartAttackStrokeBefore4", "v.heartAttackStrokeBeforeErr4");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalSpecialContracteforeReduc4", "v.hospitalSpecialContracteforeReducErr4");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalSpecialContractAfterReducti4", "v.hospitalSpecialContractAfterReductiErr4");
        helper.getSingleByteNumberCheck(cmp, event, "v.beforeHospitalizationSpecialContract4", "v.beforeHospitalizationSpecialContractErr4");
        helper.getSingleByteNumberCheck(cmp, event, "v.afterHospitalizationSpecialContract4", "v.afterHospitalizationSpecialContractErr4");
        helper.getSingleByteNumberCheck(cmp, event, "v.dischargeHospitalSpecialContractF4", "v.dischargeHospitalSpecialContractFErr4");
        helper.getSingleByteNumberCheck(cmp, event, "v.dischargeHospitalSpecialContractAf4", "v.dischargeHospitalSpecialContractAfErr4");
        helper.getSingleByteNumberCheck(cmp, event, "v.sevenSpecialContractFront4", "v.sevenSpecialContractFrontErr4");
        helper.getSingleByteNumberCheck(cmp, event, "v.sevenSpecialAfter4", "v.sevenSpecialAfterErr4");
        helper.getSingleByteNumberCheck(cmp, event, "v.longTermCareBnefitSpecialContractBefore4", "v.longTermCareBnefitSpecialContractBeforeErr4");
        helper.getSingleByteNumberCheck(cmp, event, "v.longTermCareBnefitSpecialContractAfter4", "v.longTermCareBnefitSpecialContractAfterErr4");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalWithMentalIllnessSpecialContractBefore4", "v.hospitalWithMentalIllnessSpecialContractBeforeErr4");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalWithMentalIllnessSpecialContractAfter4", "v.hospitalWithMentalIllnessSpecialContractAfterErr4");
        helper.getSingleByteNumberCheck(cmp, event, "v.accidentFreeBenefitSpecialContractBefore4", "v.accidentFreeBenefitSpecialContractBeforeErr4");
        helper.getSingleByteNumberCheck(cmp, event, "v.accidentFreeBenefitSpecialContractAfter4", "v.accidentFreeBenefitSpecialContractAfterErr4");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalLumpSumRiderBefore4", "v.hospitalLumpSumRiderBeforeErr4");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalLumpSumRiderAfter4", "v.hospitalLumpSumRiderAfterErr4");
        helper.getSingleByteNumberCheck(cmp, event, "v.cancerTreaty5", "v.cancerTreatyErr5");
        helper.getSingleByteNumberCheck(cmp, event, "v.afterCancerSpecialContractReduction5", "v.afterCancerSpecialContractReductionErr5");
        helper.getSingleByteNumberCheck(cmp, event, "v.heartAttackStrokeAfter5", "v.heartAttackStrokeAfterErr5");
        helper.getSingleByteNumberCheck(cmp, event, "v.heartAttackStrokeBefore5", "v.heartAttackStrokeBeforeErr5");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalSpecialContracteforeReduc5", "v.hospitalSpecialContracteforeReducErr5");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalSpecialContractAfterReducti5", "v.hospitalSpecialContractAfterReductiErr5");
        helper.getSingleByteNumberCheck(cmp, event, "v.beforeHospitalizationSpecialContract5", "v.beforeHospitalizationSpecialContractErr5");
        helper.getSingleByteNumberCheck(cmp, event, "v.afterHospitalizationSpecialContract5", "v.afterHospitalizationSpecialContractErr5");
        helper.getSingleByteNumberCheck(cmp, event, "v.dischargeHospitalSpecialContractF5", "v.dischargeHospitalSpecialContractFErr5");
        helper.getSingleByteNumberCheck(cmp, event, "v.dischargeHospitalSpecialContractAf5", "v.dischargeHospitalSpecialContractAfErr5");
        helper.getSingleByteNumberCheck(cmp, event, "v.sevenSpecialContractFront5", "v.sevenSpecialContractFrontErr5");
        helper.getSingleByteNumberCheck(cmp, event, "v.sevenSpecialAfter5", "v.sevenSpecialAfterErr5");
        helper.getSingleByteNumberCheck(cmp, event, "v.longTermCareBnefitSpecialContractBefore5", "v.longTermCareBnefitSpecialContractBeforeErr5");
        helper.getSingleByteNumberCheck(cmp, event, "v.longTermCareBnefitSpecialContractAfter5", "v.longTermCareBnefitSpecialContractAfterErr5");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalWithMentalIllnessSpecialContractBefore5", "v.hospitalWithMentalIllnessSpecialContractBeforeErr5");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalWithMentalIllnessSpecialContractAfter5", "v.hospitalWithMentalIllnessSpecialContractAfterErr5");
        helper.getSingleByteNumberCheck(cmp, event, "v.accidentFreeBenefitSpecialContractBefore5", "v.accidentFreeBenefitSpecialContractBeforeErr5");
        helper.getSingleByteNumberCheck(cmp, event, "v.accidentFreeBenefitSpecialContractAfter5", "v.accidentFreeBenefitSpecialContractAfterErr5");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalLumpSumRiderBefore5", "v.hospitalLumpSumRiderBeforeErr5");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalLumpSumRiderAfter5", "v.hospitalLumpSumRiderAfterErr5");
        helper.getSingleByteNumberCheck(cmp, event, "v.cancerTreaty6", "v.cancerTreatyErr6");
        helper.getSingleByteNumberCheck(cmp, event, "v.afterCancerSpecialContractReduction6", "v.afterCancerSpecialContractReductionErr6");
        helper.getSingleByteNumberCheck(cmp, event, "v.heartAttackStrokeAfter6", "v.heartAttackStrokeAfterErr6");
        helper.getSingleByteNumberCheck(cmp, event, "v.heartAttackStrokeBefore6", "v.heartAttackStrokeBeforeErr6");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalSpecialContracteforeReduc6", "v.hospitalSpecialContracteforeReducErr6");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalSpecialContractAfterReducti6", "v.hospitalSpecialContractAfterReductiErr6");
        helper.getSingleByteNumberCheck(cmp, event, "v.beforeHospitalizationSpecialContract6", "v.beforeHospitalizationSpecialContractErr6");
        helper.getSingleByteNumberCheck(cmp, event, "v.afterHospitalizationSpecialContract6", "v.afterHospitalizationSpecialContractErr6");
        helper.getSingleByteNumberCheck(cmp, event, "v.dischargeHospitalSpecialContractF6", "v.dischargeHospitalSpecialContractFErr6");
        helper.getSingleByteNumberCheck(cmp, event, "v.dischargeHospitalSpecialContractAf6", "v.dischargeHospitalSpecialContractAfErr6");
        helper.getSingleByteNumberCheck(cmp, event, "v.sevenSpecialContractFront6", "v.sevenSpecialContractFrontErr6");
        helper.getSingleByteNumberCheck(cmp, event, "v.sevenSpecialAfter6", "v.sevenSpecialAfterErr6");
        helper.getSingleByteNumberCheck(cmp, event, "v.longTermCareBnefitSpecialContractBefore6", "v.longTermCareBnefitSpecialContractBeforeErr6");
        helper.getSingleByteNumberCheck(cmp, event, "v.longTermCareBnefitSpecialContractAfter6", "v.longTermCareBnefitSpecialContractAfterErr6");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalWithMentalIllnessSpecialContractBefore6", "v.hospitalWithMentalIllnessSpecialContractBeforeErr6");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalWithMentalIllnessSpecialContractAfter6", "v.hospitalWithMentalIllnessSpecialContractAfterErr6");
        helper.getSingleByteNumberCheck(cmp, event, "v.accidentFreeBenefitSpecialContractBefore6", "v.accidentFreeBenefitSpecialContractBeforeErr6");
        helper.getSingleByteNumberCheck(cmp, event, "v.accidentFreeBenefitSpecialContractAfter6", "v.accidentFreeBenefitSpecialContractAfterErr6");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalLumpSumRiderBefore6", "v.hospitalLumpSumRiderBeforeErr6");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalLumpSumRiderAfter6", "v.hospitalLumpSumRiderAfterErr6");
        helper.getSingleByteNumberCheck(cmp, event, "v.cancerTreaty7", "v.cancerTreatyErr7");
        helper.getSingleByteNumberCheck(cmp, event, "v.afterCancerSpecialContractReduction7", "v.afterCancerSpecialContractReductionErr7");
        helper.getSingleByteNumberCheck(cmp, event, "v.heartAttackStrokeAfter7", "v.heartAttackStrokeAfterErr7");
        helper.getSingleByteNumberCheck(cmp, event, "v.heartAttackStrokeBefore7", "v.heartAttackStrokeBeforeErr7");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalSpecialContracteforeReduc7", "v.hospitalSpecialContracteforeReducErr7");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalSpecialContractAfterReducti7", "v.hospitalSpecialContractAfterReductiErr7");
        helper.getSingleByteNumberCheck(cmp, event, "v.beforeHospitalizationSpecialContract7", "v.beforeHospitalizationSpecialContractErr7");
        helper.getSingleByteNumberCheck(cmp, event, "v.afterHospitalizationSpecialContract7", "v.afterHospitalizationSpecialContractErr7");
        helper.getSingleByteNumberCheck(cmp, event, "v.dischargeHospitalSpecialContractF7", "v.dischargeHospitalSpecialContractFErr7");
        helper.getSingleByteNumberCheck(cmp, event, "v.dischargeHospitalSpecialContractAf7", "v.dischargeHospitalSpecialContractAfErr7");
        helper.getSingleByteNumberCheck(cmp, event, "v.sevenSpecialContractFront7", "v.sevenSpecialContractFrontErr7");
        helper.getSingleByteNumberCheck(cmp, event, "v.sevenSpecialAfter7", "v.sevenSpecialAfterErr7");
        helper.getSingleByteNumberCheck(cmp, event, "v.longTermCareBnefitSpecialContractBefore7", "v.longTermCareBnefitSpecialContractBeforeErr7");
        helper.getSingleByteNumberCheck(cmp, event, "v.longTermCareBnefitSpecialContractAfter7", "v.longTermCareBnefitSpecialContractAfterErr7");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalWithMentalIllnessSpecialContractBefore7", "v.hospitalWithMentalIllnessSpecialContractBeforeErr7");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalWithMentalIllnessSpecialContractAfter7", "v.hospitalWithMentalIllnessSpecialContractAfterErr7");
        helper.getSingleByteNumberCheck(cmp, event, "v.accidentFreeBenefitSpecialContractBefore7", "v.accidentFreeBenefitSpecialContractBeforeErr7");
        helper.getSingleByteNumberCheck(cmp, event, "v.accidentFreeBenefitSpecialContractAfter7", "v.accidentFreeBenefitSpecialContractAfterErr7");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalLumpSumRiderBefore7", "v.hospitalLumpSumRiderBeforeErr7");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalLumpSumRiderAfter7", "v.hospitalLumpSumRiderAfterErr7");
        helper.getSingleByteNumberCheck(cmp, event, "v.cancerTreaty8", "v.cancerTreatyErr8");
        helper.getSingleByteNumberCheck(cmp, event, "v.afterCancerSpecialContractReduction8", "v.afterCancerSpecialContractReductionErr8");
        helper.getSingleByteNumberCheck(cmp, event, "v.heartAttackStrokeAfter8", "v.heartAttackStrokeAfterErr8");
        helper.getSingleByteNumberCheck(cmp, event, "v.heartAttackStrokeBefore8", "v.heartAttackStrokeBeforeErr8");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalSpecialContracteforeReduc8", "v.hospitalSpecialContracteforeReducErr8");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalSpecialContractAfterReducti8", "v.hospitalSpecialContractAfterReductiErr8");
        helper.getSingleByteNumberCheck(cmp, event, "v.beforeHospitalizationSpecialContract8", "v.beforeHospitalizationSpecialContractErr8");
        helper.getSingleByteNumberCheck(cmp, event, "v.afterHospitalizationSpecialContract8", "v.afterHospitalizationSpecialContractErr8");
        helper.getSingleByteNumberCheck(cmp, event, "v.dischargeHospitalSpecialContractF8", "v.dischargeHospitalSpecialContractFErr8");
        helper.getSingleByteNumberCheck(cmp, event, "v.dischargeHospitalSpecialContractAf8", "v.dischargeHospitalSpecialContractAfErr8");
        helper.getSingleByteNumberCheck(cmp, event, "v.sevenSpecialContractFront8", "v.sevenSpecialContractFrontErr8");
        helper.getSingleByteNumberCheck(cmp, event, "v.sevenSpecialAfter8", "v.sevenSpecialAfterErr8");
        helper.getSingleByteNumberCheck(cmp, event, "v.longTermCareBnefitSpecialContractBefore8", "v.longTermCareBnefitSpecialContractBeforeErr8");
        helper.getSingleByteNumberCheck(cmp, event, "v.longTermCareBnefitSpecialContractAfter8", "v.longTermCareBnefitSpecialContractAfterErr8");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalWithMentalIllnessSpecialContractBefore8", "v.hospitalWithMentalIllnessSpecialContractBeforeErr8");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalWithMentalIllnessSpecialContractAfter8", "v.hospitalWithMentalIllnessSpecialContractAfterErr8");
        helper.getSingleByteNumberCheck(cmp, event, "v.accidentFreeBenefitSpecialContractBefore8", "v.accidentFreeBenefitSpecialContractBeforeErr8");
        helper.getSingleByteNumberCheck(cmp, event, "v.accidentFreeBenefitSpecialContractAfter8", "v.accidentFreeBenefitSpecialContractAfterErr8");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalLumpSumRiderBefore8", "v.hospitalLumpSumRiderBeforeErr8");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalLumpSumRiderAfter8", "v.hospitalLumpSumRiderAfterErr8");
        helper.getSingleByteNumberCheck(cmp, event, "v.cancerTreaty9", "v.cancerTreatyErr9");
        helper.getSingleByteNumberCheck(cmp, event, "v.afterCancerSpecialContractReduction9", "v.afterCancerSpecialContractReductionErr9");
        helper.getSingleByteNumberCheck(cmp, event, "v.heartAttackStrokeAfter9", "v.heartAttackStrokeAfterErr9");
        helper.getSingleByteNumberCheck(cmp, event, "v.heartAttackStrokeBefore9", "v.heartAttackStrokeBeforeErr9");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalSpecialContracteforeReduc9", "v.hospitalSpecialContracteforeReducErr9");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalSpecialContractAfterReducti9", "v.hospitalSpecialContractAfterReductiErr9");
        helper.getSingleByteNumberCheck(cmp, event, "v.beforeHospitalizationSpecialContract9", "v.beforeHospitalizationSpecialContractErr9");
        helper.getSingleByteNumberCheck(cmp, event, "v.afterHospitalizationSpecialContract9", "v.afterHospitalizationSpecialContractErr9");
        helper.getSingleByteNumberCheck(cmp, event, "v.dischargeHospitalSpecialContractF9", "v.dischargeHospitalSpecialContractFErr9");
        helper.getSingleByteNumberCheck(cmp, event, "v.dischargeHospitalSpecialContractAf9", "v.dischargeHospitalSpecialContractAfErr9");
        helper.getSingleByteNumberCheck(cmp, event, "v.sevenSpecialContractFront9", "v.sevenSpecialContractFrontErr9");
        helper.getSingleByteNumberCheck(cmp, event, "v.sevenSpecialAfter9", "v.sevenSpecialAfterErr9");
        helper.getSingleByteNumberCheck(cmp, event, "v.longTermCareBnefitSpecialContractBefore9", "v.longTermCareBnefitSpecialContractBeforeErr9");
        helper.getSingleByteNumberCheck(cmp, event, "v.longTermCareBnefitSpecialContractAfter9", "v.longTermCareBnefitSpecialContractAfterErr9");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalWithMentalIllnessSpecialContractBefore9", "v.hospitalWithMentalIllnessSpecialContractBeforeErr9");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalWithMentalIllnessSpecialContractAfter9", "v.hospitalWithMentalIllnessSpecialContractAfterErr9");
        helper.getSingleByteNumberCheck(cmp, event, "v.accidentFreeBenefitSpecialContractBefore9", "v.accidentFreeBenefitSpecialContractBeforeErr9");
        helper.getSingleByteNumberCheck(cmp, event, "v.accidentFreeBenefitSpecialContractAfter9", "v.accidentFreeBenefitSpecialContractAfterErr9");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalLumpSumRiderBefore9", "v.hospitalLumpSumRiderBeforeErr9");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalLumpSumRiderAfter9", "v.hospitalLumpSumRiderAfterErr9");
        helper.getSingleByteNumberCheck(cmp, event, "v.cancerTreaty10", "v.cancerTreatyErr10");
        helper.getSingleByteNumberCheck(cmp, event, "v.afterCancerSpecialContractReduction10", "v.afterCancerSpecialContractReductionErr10");
        helper.getSingleByteNumberCheck(cmp, event, "v.heartAttackStrokeAfter10", "v.heartAttackStrokeAfterErr10");
        helper.getSingleByteNumberCheck(cmp, event, "v.heartAttackStrokeBefore10", "v.heartAttackStrokeBeforeErr10");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalSpecialContracteforeReduc10", "v.hospitalSpecialContracteforeReducErr10");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalSpecialContractAfterReducti10", "v.hospitalSpecialContractAfterReductiErr10");
        helper.getSingleByteNumberCheck(cmp, event, "v.beforeHospitalizationSpecialContract10", "v.beforeHospitalizationSpecialContractErr10");
        helper.getSingleByteNumberCheck(cmp, event, "v.afterHospitalizationSpecialContract10", "v.afterHospitalizationSpecialContractErr10");
        helper.getSingleByteNumberCheck(cmp, event, "v.dischargeHospitalSpecialContractF10", "v.dischargeHospitalSpecialContractFErr10");
        helper.getSingleByteNumberCheck(cmp, event, "v.dischargeHospitalSpecialContractAf10", "v.dischargeHospitalSpecialContractAfErr10");
        helper.getSingleByteNumberCheck(cmp, event, "v.sevenSpecialContractFront10", "v.sevenSpecialContractFrontErr10");
        helper.getSingleByteNumberCheck(cmp, event, "v.sevenSpecialAfter10", "v.sevenSpecialAfterErr10");
        helper.getSingleByteNumberCheck(cmp, event, "v.longTermCareBnefitSpecialContractBefore10", "v.longTermCareBnefitSpecialContractBeforeErr10");
        helper.getSingleByteNumberCheck(cmp, event, "v.longTermCareBnefitSpecialContractAfter10", "v.longTermCareBnefitSpecialContractAfterErr10");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalWithMentalIllnessSpecialContractBefore10", "v.hospitalWithMentalIllnessSpecialContractBeforeErr10");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalWithMentalIllnessSpecialContractAfter10", "v.hospitalWithMentalIllnessSpecialContractAfterErr10");
        helper.getSingleByteNumberCheck(cmp, event, "v.accidentFreeBenefitSpecialContractBefore10", "v.accidentFreeBenefitSpecialContractBeforeErr10");
        helper.getSingleByteNumberCheck(cmp, event, "v.accidentFreeBenefitSpecialContractAfter10", "v.accidentFreeBenefitSpecialContractAfterErr10");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalLumpSumRiderBefore10", "v.hospitalLumpSumRiderBeforeErr10");
        helper.getSingleByteNumberCheck(cmp, event, "v.hospitalLumpSumRiderAfter10", "v.hospitalLumpSumRiderAfterErr10");
        helper.getSingleByteNumberCheck(cmp,event,"v.numberOfCopies","v.noOfCopiesErr");
		
		var numberOfCopies = cmp.get("v.numberOfCopies") == null ? "" : cmp.get("v.numberOfCopies");
		var noOfCopiesErr = cmp.get("v.noOfCopiesErr");
		
        obj.PolicyNumber1__c = cmp.get("v.innerCmpNewRequest").PolicyNumber1__c;
        if (obj.PolicyNumber1__c != '') {
            obj.ChangeDetails1__c = "がん特約／がん診断給付特約／がん特約Ⅱ（減額前）:" + (cmp.get("v.cancerTreaty1") == null ? "" : cmp.get("v.cancerTreaty1")) + "\n" +
                "がん特約／がん診断給付特約／がん特約Ⅱ（減額後）:" + (cmp.get("v.afterCancerSpecialContractReduction1") == null ? "" : cmp.get("v.afterCancerSpecialContractReduction1")) + "\n" +
                "急性心筋梗塞・脳卒中特約（減額前）:" + (cmp.get("v.heartAttackStrokeAfter1") == null ? "" : cmp.get("v.heartAttackStrokeAfter1")) + "\n" +
                "急性心筋梗塞・脳卒中特約（減額後）:" + (cmp.get("v.heartAttackStrokeBefore1") == null ? "" : cmp.get("v.heartAttackStrokeBefore1")) + "\n" +
                "通院特約（減額前）:" + (cmp.get("v.hospitalSpecialContracteforeReduc1") == null ? "" : cmp.get("v.hospitalSpecialContracteforeReduc1")) + "\n" +
                "通院特約（減額後）:" + (cmp.get("v.hospitalSpecialContractAfterReducti1") == null ? "" : cmp.get("v.hospitalSpecialContractAfterReducti1")) + "\n" +
                "がん入院特約（減額前）:" + (cmp.get("v.beforeHospitalizationSpecialContract1") == null ? "" : cmp.get("v.beforeHospitalizationSpecialContract1")) + "\n" +
                "がん入院特約（減額後）:" + (cmp.get("v.afterHospitalizationSpecialContract1") == null ? "" : cmp.get("v.afterHospitalizationSpecialContract1")) + "\n" +
                "退院・通院特約（減額前）:" + (cmp.get("v.dischargeHospitalSpecialContractF1") == null ? "" : cmp.get("v.dischargeHospitalSpecialContractF1")) + "\n" +
                "退院・通院特約（減額後）:" + (cmp.get("v.dischargeHospitalSpecialContractAf1") == null ? "" : cmp.get("v.dischargeHospitalSpecialContractAf1")) + "\n" +
                "7疾病特約（減額前）:" + (cmp.get("v.sevenSpecialContractFront1") == null ? "" : cmp.get("v.sevenSpecialContractFront1")) + "\n" +
                "7疾病特約（減額後）:" + (cmp.get("v.sevenSpecialAfter1") == null ? "" : cmp.get("v.sevenSpecialAfter1")) + "\n" +
                "介護給付特約（減額前）:" + (cmp.get("v.longTermCareBnefitSpecialContractBefore1") == null ? "" : cmp.get("v.longTermCareBnefitSpecialContractBefore1")) + "\n" +
                "介護給付特約（減額後）:" + (cmp.get("v.longTermCareBnefitSpecialContractAfter1") == null ? "" : cmp.get("v.longTermCareBnefitSpecialContractAfter1")) + "\n" +
                "精神疾患併発入院特約（減額前）:" + (cmp.get("v.hospitalWithMentalIllnessSpecialContractBefore1") == null ? "" : cmp.get("v.hospitalWithMentalIllnessSpecialContractBefore1")) + "\n" +
                "精神疾患併発入院特約（減額後）:" + (cmp.get("v.hospitalWithMentalIllnessSpecialContractAfter1") == null ? "" : cmp.get("v.hospitalWithMentalIllnessSpecialContractAfter1")) + "\n" +
                "無事故給付特約（減額前）:" + (cmp.get("v.accidentFreeBenefitSpecialContractBefore1") == null ? "" : cmp.get("v.accidentFreeBenefitSpecialContractBefore1")) + "\n" +
                "無事故給付特約（減額後）:" + (cmp.get("v.accidentFreeBenefitSpecialContractAfter1") == null ? "" : cmp.get("v.accidentFreeBenefitSpecialContractAfter1")) + "\n" +
                "入院一時金特約（減額前）:" + (cmp.get("v.hospitalLumpSumRiderBefore1") == null ? "" : cmp.get("v.hospitalLumpSumRiderBefore1")) + "\n" +
                "入院一時金特約（減額後）:" + (cmp.get("v.hospitalLumpSumRiderAfter1") == null ? "" : cmp.get("v.hospitalLumpSumRiderAfter1"));

        }
        else {
            obj.ChangeDetails1__c = "";
        }
        obj.PolicyNumber2__c = cmp.get("v.innerCmpNewRequest").PolicyNumber2__c;
        if (obj.PolicyNumber2__c != '') {
            obj.ChangeDetails2__c = "がん特約／がん診断給付特約／がん特約Ⅱ（減額前）:" + (cmp.get("v.cancerTreaty2") == null ? "" : cmp.get("v.cancerTreaty2")) + "\n" +
                "がん特約／がん診断給付特約／がん特約Ⅱ（減額後）:" + (cmp.get("v.afterCancerSpecialContractReduction2") == null ? "" : cmp.get("v.afterCancerSpecialContractReduction2")) + "\n" +
                "急性心筋梗塞・脳卒中特約（減額前）:" + (cmp.get("v.heartAttackStrokeAfter2") == null ? "" : cmp.get("v.heartAttackStrokeAfter2")) + "\n" +
                "急性心筋梗塞・脳卒中特約（減額後）:" + (cmp.get("v.heartAttackStrokeBefore2") == null ? "" : cmp.get("v.heartAttackStrokeBefore2")) + "\n" +
                "通院特約（減額前）:" + (cmp.get("v.hospitalSpecialContracteforeReduc2") == null ? "" : cmp.get("v.hospitalSpecialContracteforeReduc2")) + "\n" +
                "通院特約（減額後）:" + (cmp.get("v.hospitalSpecialContractAfterReducti2") == null ? "" : cmp.get("v.hospitalSpecialContractAfterReducti2")) + "\n" +
                "がん入院特約（減額前）:" + (cmp.get("v.beforeHospitalizationSpecialContract2") == null ? "" : cmp.get("v.beforeHospitalizationSpecialContract2")) + "\n" +
                "がん入院特約（減額後）:" + (cmp.get("v.afterHospitalizationSpecialContract2") == null ? "" : cmp.get("v.afterHospitalizationSpecialContract2")) + "\n" +
                "退院・通院特約（減額前）:" + (cmp.get("v.dischargeHospitalSpecialContractF2") == null ? "" : cmp.get("v.dischargeHospitalSpecialContractF2")) + "\n" +
                "退院・通院特約（減額後）:" + (cmp.get("v.dischargeHospitalSpecialContractAf2") == null ? "" : cmp.get("v.dischargeHospitalSpecialContractAf2")) + "\n" +
                "7疾病特約（減額前）:" + (cmp.get("v.sevenSpecialContractFront2") == null ? "" : cmp.get("v.sevenSpecialContractFront2")) + "\n" +
                "7疾病特約（減額後）:" + (cmp.get("v.sevenSpecialAfter2") == null ? "" : cmp.get("v.sevenSpecialAfter2")) + "\n" +
                "介護給付特約（減額前）:" + (cmp.get("v.longTermCareBnefitSpecialContractBefore2") == null ? "" : cmp.get("v.longTermCareBnefitSpecialContractBefore2")) + "\n" +
                "介護給付特約（減額後）:" + (cmp.get("v.longTermCareBnefitSpecialContractAfter2") == null ? "" : cmp.get("v.longTermCareBnefitSpecialContractAfter2")) + "\n" +
                "精神疾患併発入院特約（減額前）:" + (cmp.get("v.hospitalWithMentalIllnessSpecialContractBefore2") == null ? "" : cmp.get("v.hospitalWithMentalIllnessSpecialContractBefore2")) + "\n" +
                "精神疾患併発入院特約（減額後）:" + (cmp.get("v.hospitalWithMentalIllnessSpecialContractAfter2") == null ? "" : cmp.get("v.hospitalWithMentalIllnessSpecialContractAfter2")) + "\n" +
                "無事故給付特約（減額前）:" + (cmp.get("v.accidentFreeBenefitSpecialContractBefore2") == null ? "" : cmp.get("v.accidentFreeBenefitSpecialContractBefore2")) + "\n" +
                "無事故給付特約（減額後）:" + (cmp.get("v.accidentFreeBenefitSpecialContractAfter2") == null ? "" : cmp.get("v.accidentFreeBenefitSpecialContractAfter2")) + "\n" +
                "入院一時金特約（減額前）:" + (cmp.get("v.hospitalLumpSumRiderBefore2") == null ? "" : cmp.get("v.hospitalLumpSumRiderBefore2")) + "\n" +
                "入院一時金特約（減額後）:" + (cmp.get("v.hospitalLumpSumRiderAfter2") == null ? "" : cmp.get("v.hospitalLumpSumRiderAfter2"));
        }
        else {
            obj.ChangeDetails2__c = "";
        }

        obj.PolicyNumber3__c = cmp.get("v.innerCmpNewRequest").PolicyNumber3__c;
        if (obj.PolicyNumber3__c != '') {
            obj.ChangeDetails3__c = "がん特約／がん診断給付特約／がん特約Ⅱ（減額前）:" + (cmp.get("v.cancerTreaty3") == null ? "" : cmp.get("v.cancerTreaty3")) + "\n" +
                "がん特約／がん診断給付特約／がん特約Ⅱ（減額後）:" + (cmp.get("v.afterCancerSpecialContractReduction3") == null ? "" : cmp.get("v.afterCancerSpecialContractReduction3")) + "\n" +
                "急性心筋梗塞・脳卒中特約（減額前）:" + (cmp.get("v.heartAttackStrokeAfter3") == null ? "" : cmp.get("v.heartAttackStrokeAfter3")) + "\n" +
                "急性心筋梗塞・脳卒中特約（減額後）:" + (cmp.get("v.heartAttackStrokeBefore3") == null ? "" : cmp.get("v.heartAttackStrokeBefore3")) + "\n" +
                "通院特約（減額前）:" + (cmp.get("v.hospitalSpecialContracteforeReduc3") == null ? "" : cmp.get("v.hospitalSpecialContracteforeReduc3")) + "\n" +
                "通院特約（減額後）:" + (cmp.get("v.hospitalSpecialContractAfterReducti3") == null ? "" : cmp.get("v.hospitalSpecialContractAfterReducti3")) + "\n" +
                "がん入院特約（減額前）:" + (cmp.get("v.beforeHospitalizationSpecialContract3") == null ? "" : cmp.get("v.beforeHospitalizationSpecialContract3")) + "\n" +
                "がん入院特約（減額後）:" + (cmp.get("v.afterHospitalizationSpecialContract3") == null ? "" : cmp.get("v.afterHospitalizationSpecialContract3")) + "\n" +
                "退院・通院特約（減額前）:" + (cmp.get("v.dischargeHospitalSpecialContractF3") == null ? "" : cmp.get("v.dischargeHospitalSpecialContractF3")) + "\n" +
                "退院・通院特約（減額後）:" + (cmp.get("v.dischargeHospitalSpecialContractAf3") == null ? "" : cmp.get("v.dischargeHospitalSpecialContractAf3")) + "\n" +
                "7疾病特約（減額前）:" + (cmp.get("v.sevenSpecialContractFront3") == null ? "" : cmp.get("v.sevenSpecialContractFront3")) + "\n" +
                "7疾病特約（減額後）:" + (cmp.get("v.sevenSpecialAfter3") == null ? "" : cmp.get("v.sevenSpecialAfter3")) + "\n" +
                "介護給付特約（減額前）:" + (cmp.get("v.longTermCareBnefitSpecialContractBefore3") == null ? "" : cmp.get("v.longTermCareBnefitSpecialContractBefore3")) + "\n" +
                "介護給付特約（減額後）:" + (cmp.get("v.longTermCareBnefitSpecialContractAfter3") == null ? "" : cmp.get("v.longTermCareBnefitSpecialContractAfter3")) + "\n" +
                "精神疾患併発入院特約（減額前）:" + (cmp.get("v.hospitalWithMentalIllnessSpecialContractBefore3") == null ? "" : cmp.get("v.hospitalWithMentalIllnessSpecialContractBefore3")) + "\n" +
                "精神疾患併発入院特約（減額後）:" + (cmp.get("v.hospitalWithMentalIllnessSpecialContractAfter3") == null ? "" : cmp.get("v.hospitalWithMentalIllnessSpecialContractAfter3")) + "\n" +
                "無事故給付特約（減額前）:" + (cmp.get("v.accidentFreeBenefitSpecialContractBefore3") == null ? "" : cmp.get("v.accidentFreeBenefitSpecialContractBefore3")) + "\n" +
                "無事故給付特約（減額後）:" + (cmp.get("v.accidentFreeBenefitSpecialContractAfter3") == null ? "" : cmp.get("v.accidentFreeBenefitSpecialContractAfter3")) + "\n" +
                "入院一時金特約（減額前）:" + (cmp.get("v.hospitalLumpSumRiderBefore3") == null ? "" : cmp.get("v.hospitalLumpSumRiderBefore3")) + "\n" +
                "入院一時金特約（減額後）:" + (cmp.get("v.hospitalLumpSumRiderAfter3") == null ? "" : cmp.get("v.hospitalLumpSumRiderAfter3"));

        }
        else {
            obj.ChangeDetails3__c = "";
        }

        obj.PolicyNumber4__c = cmp.get("v.innerCmpNewRequest").PolicyNumber4__c;
        if (obj.PolicyNumber4__c != '') {
            obj.ChangeDetails4__c = "がん特約／がん診断給付特約／がん特約Ⅱ（減額前）:" + (cmp.get("v.cancerTreaty4") == null ? "" : cmp.get("v.cancerTreaty4")) + "\n" +
                "がん特約／がん診断給付特約／がん特約Ⅱ（減額後）:" + (cmp.get("v.afterCancerSpecialContractReduction4") == null ? "" : cmp.get("v.afterCancerSpecialContractReduction4")) + "\n" +
                "急性心筋梗塞・脳卒中特約（減額前）:" + (cmp.get("v.heartAttackStrokeAfter4") == null ? "" : cmp.get("v.heartAttackStrokeAfter4")) + "\n" +
                "急性心筋梗塞・脳卒中特約（減額後）:" + (cmp.get("v.heartAttackStrokeBefore4") == null ? "" : cmp.get("v.heartAttackStrokeBefore4")) + "\n" +
                "通院特約（減額前）:" + (cmp.get("v.hospitalSpecialContracteforeReduc4") == null ? "" : cmp.get("v.hospitalSpecialContracteforeReduc4")) + "\n" +
                "通院特約（減額後）:" + (cmp.get("v.hospitalSpecialContractAfterReducti4") == null ? "" : cmp.get("v.hospitalSpecialContractAfterReducti4")) + "\n" +
                "がん入院特約（減額前）:" + (cmp.get("v.beforeHospitalizationSpecialContract4") == null ? "" : cmp.get("v.beforeHospitalizationSpecialContract4")) + "\n" +
                "がん入院特約（減額後）:" + (cmp.get("v.afterHospitalizationSpecialContract4") == null ? "" : cmp.get("v.afterHospitalizationSpecialContract4")) + "\n" +
                "退院・通院特約（減額前）:" + (cmp.get("v.dischargeHospitalSpecialContractF4") == null ? "" : cmp.get("v.dischargeHospitalSpecialContractF4")) + "\n" +
                "退院・通院特約（減額後）:" + (cmp.get("v.dischargeHospitalSpecialContractAf4") == null ? "" : cmp.get("v.dischargeHospitalSpecialContractAf4")) + "\n" +
                "7疾病特約（減額前）:" + (cmp.get("v.sevenSpecialContractFront4") == null ? "" : cmp.get("v.sevenSpecialContractFront4")) + "\n" +
                "7疾病特約（減額後）:" + (cmp.get("v.sevenSpecialAfter4") == null ? "" : cmp.get("v.sevenSpecialAfter4")) + "\n" +
                "介護給付特約（減額前）:" + (cmp.get("v.longTermCareBnefitSpecialContractBefore4") == null ? "" : cmp.get("v.longTermCareBnefitSpecialContractBefore4")) + "\n" +
                "介護給付特約（減額後）:" + (cmp.get("v.longTermCareBnefitSpecialContractAfter4") == null ? "" : cmp.get("v.longTermCareBnefitSpecialContractAfter4")) + "\n" +
                "精神疾患併発入院特約（減額前）:" + (cmp.get("v.hospitalWithMentalIllnessSpecialContractBefore4") == null ? "" : cmp.get("v.hospitalWithMentalIllnessSpecialContractBefore4")) + "\n" +
                "精神疾患併発入院特約（減額後）:" + (cmp.get("v.hospitalWithMentalIllnessSpecialContractAfter4") == null ? "" : cmp.get("v.hospitalWithMentalIllnessSpecialContractAfter4")) + "\n" +
                "無事故給付特約（減額前）:" + (cmp.get("v.accidentFreeBenefitSpecialContractBefore4") == null ? "" : cmp.get("v.accidentFreeBenefitSpecialContractBefore4")) + "\n" +
                "無事故給付特約（減額後）:" + (cmp.get("v.accidentFreeBenefitSpecialContractAfter4") == null ? "" : cmp.get("v.accidentFreeBenefitSpecialContractAfter4")) + "\n" +
                "入院一時金特約（減額前）:" + (cmp.get("v.hospitalLumpSumRiderBefore4") == null ? "" : cmp.get("v.hospitalLumpSumRiderBefore4")) + "\n" +
                "入院一時金特約（減額後）:" + (cmp.get("v.hospitalLumpSumRiderAfter4") == null ? "" : cmp.get("v.hospitalLumpSumRiderAfter4"));
        }
        else {
            obj.ChangeDetails4__c = "";
        }

        obj.PolicyNumber5__c = cmp.get("v.innerCmpNewRequest").PolicyNumber5__c;
        if (obj.PolicyNumber5__c != '') {
            obj.ChangeDetails5__c = "がん特約／がん診断給付特約／がん特約Ⅱ（減額前）:" + (cmp.get("v.cancerTreaty5") == null ? "" : cmp.get("v.cancerTreaty5")) + "\n" +
                "がん特約／がん診断給付特約／がん特約Ⅱ（減額後）:" + (cmp.get("v.afterCancerSpecialContractReduction5") == null ? "" : cmp.get("v.afterCancerSpecialContractReduction5")) + "\n" +
                "急性心筋梗塞・脳卒中特約（減額前）:" + (cmp.get("v.heartAttackStrokeAfter5") == null ? "" : cmp.get("v.heartAttackStrokeAfter5")) + "\n" +
                "急性心筋梗塞・脳卒中特約（減額後）:" + (cmp.get("v.heartAttackStrokeBefore5") == null ? "" : cmp.get("v.heartAttackStrokeBefore5")) + "\n" +
                "通院特約（減額前）:" + (cmp.get("v.hospitalSpecialContracteforeReduc5") == null ? "" : cmp.get("v.hospitalSpecialContracteforeReduc5")) + "\n" +
                "通院特約（減額後）:" + (cmp.get("v.hospitalSpecialContractAfterReducti5") == null ? "" : cmp.get("v.hospitalSpecialContractAfterReducti5")) + "\n" +
                "がん入院特約（減額前）:" + (cmp.get("v.beforeHospitalizationSpecialContract5") == null ? "" : cmp.get("v.beforeHospitalizationSpecialContract5")) + "\n" +
                "がん入院特約（減額後）:" + (cmp.get("v.afterHospitalizationSpecialContract5") == null ? "" : cmp.get("v.afterHospitalizationSpecialContract5")) + "\n" +
                "退院・通院特約（減額前）:" + (cmp.get("v.dischargeHospitalSpecialContractF5") == null ? "" : cmp.get("v.dischargeHospitalSpecialContractF5")) + "\n" +
                "退院・通院特約（減額後）:" + (cmp.get("v.dischargeHospitalSpecialContractAf5") == null ? "" : cmp.get("v.dischargeHospitalSpecialContractAf5")) + "\n" +
                "7疾病特約（減額前）:" + (cmp.get("v.sevenSpecialContractFront5") == null ? "" : cmp.get("v.sevenSpecialContractFront5")) + "\n" +
                "7疾病特約（減額後）:" + (cmp.get("v.sevenSpecialAfter5") == null ? "" : cmp.get("v.sevenSpecialAfter5")) + "\n" +
                "介護給付特約（減額前）:" + (cmp.get("v.longTermCareBnefitSpecialContractBefore5") == null ? "" : cmp.get("v.longTermCareBnefitSpecialContractBefore5")) + "\n" +
                "介護給付特約（減額後）:" + (cmp.get("v.longTermCareBnefitSpecialContractAfter5") == null ? "" : cmp.get("v.longTermCareBnefitSpecialContractAfter5")) + "\n" +
                "精神疾患併発入院特約（減額前）:" + (cmp.get("v.hospitalWithMentalIllnessSpecialContractBefore5") == null ? "" : cmp.get("v.hospitalWithMentalIllnessSpecialContractBefore5")) + "\n" +
                "精神疾患併発入院特約（減額後）:" + (cmp.get("v.hospitalWithMentalIllnessSpecialContractAfter5") == null ? "" : cmp.get("v.hospitalWithMentalIllnessSpecialContractAfter5")) + "\n" +
                "無事故給付特約（減額前）:" + (cmp.get("v.accidentFreeBenefitSpecialContractBefore5") == null ? "" : cmp.get("v.accidentFreeBenefitSpecialContractBefore5")) + "\n" +
                "無事故給付特約（減額後）:" + (cmp.get("v.accidentFreeBenefitSpecialContractAfter5") == null ? "" : cmp.get("v.accidentFreeBenefitSpecialContractAfter5")) + "\n" +
                "入院一時金特約（減額前）:" + (cmp.get("v.hospitalLumpSumRiderBefore5") == null ? "" : cmp.get("v.hospitalLumpSumRiderBefore5")) + "\n" +
                "入院一時金特約（減額後）:" + (cmp.get("v.hospitalLumpSumRiderAfter5") == null ? "" : cmp.get("v.hospitalLumpSumRiderAfter5"));
        }
        else {
            obj.ChangeDetails5__c = "";
        }

        obj.PolicyNumber6__c = cmp.get("v.innerCmpNewRequest").PolicyNumber6__c;
        if (obj.PolicyNumber6__c != '') {
            obj.ChangeDetails6__c = "がん特約／がん診断給付特約／がん特約Ⅱ（減額前）:" + (cmp.get("v.cancerTreaty6") == null ? "" : cmp.get("v.cancerTreaty6")) + "\n" +
                "がん特約／がん診断給付特約／がん特約Ⅱ（減額後）:" + (cmp.get("v.afterCancerSpecialContractReduction6") == null ? "" : cmp.get("v.afterCancerSpecialContractReduction6")) + "\n" +
                "急性心筋梗塞・脳卒中特約（減額前）:" + (cmp.get("v.heartAttackStrokeAfter6") == null ? "" : cmp.get("v.heartAttackStrokeAfter6")) + "\n" +
                "急性心筋梗塞・脳卒中特約（減額後）:" + (cmp.get("v.heartAttackStrokeBefore6") == null ? "" : cmp.get("v.heartAttackStrokeBefore6")) + "\n" +
                "通院特約（減額前）:" + (cmp.get("v.hospitalSpecialContracteforeReduc6") == null ? "" : cmp.get("v.hospitalSpecialContracteforeReduc6")) + "\n" +
                "通院特約（減額後）:" + (cmp.get("v.hospitalSpecialContractAfterReducti6") == null ? "" : cmp.get("v.hospitalSpecialContractAfterReducti6")) + "\n" +
                "がん入院特約（減額前）:" + (cmp.get("v.beforeHospitalizationSpecialContract6") == null ? "" : cmp.get("v.beforeHospitalizationSpecialContract6")) + "\n" +
                "がん入院特約（減額後）:" + (cmp.get("v.afterHospitalizationSpecialContract6") == null ? "" : cmp.get("v.afterHospitalizationSpecialContract6")) + "\n" +
                "退院・通院特約（減額前）:" + (cmp.get("v.dischargeHospitalSpecialContractF6") == null ? "" : cmp.get("v.dischargeHospitalSpecialContractF6")) + "\n" +
                "退院・通院特約（減額後）:" + (cmp.get("v.dischargeHospitalSpecialContractAf6") == null ? "" : cmp.get("v.dischargeHospitalSpecialContractAf6")) + "\n" +
                "7疾病特約（減額前）:" + (cmp.get("v.sevenSpecialContractFront6") == null ? "" : cmp.get("v.sevenSpecialContractFront6")) + "\n" +
                "7疾病特約（減額後）:" + (cmp.get("v.sevenSpecialAfter6") == null ? "" : cmp.get("v.sevenSpecialAfter6")) + "\n" +
                "介護給付特約（減額前）:" + (cmp.get("v.longTermCareBnefitSpecialContractBefore6") == null ? "" : cmp.get("v.longTermCareBnefitSpecialContractBefore6")) + "\n" +
                "介護給付特約（減額後）:" + (cmp.get("v.longTermCareBnefitSpecialContractAfter6") == null ? "" : cmp.get("v.longTermCareBnefitSpecialContractAfter6")) + "\n" +
                "精神疾患併発入院特約（減額前）:" + (cmp.get("v.hospitalWithMentalIllnessSpecialContractBefore6") == null ? "" : cmp.get("v.hospitalWithMentalIllnessSpecialContractBefore6")) + "\n" +
                "精神疾患併発入院特約（減額後）:" + (cmp.get("v.hospitalWithMentalIllnessSpecialContractAfter6") == null ? "" : cmp.get("v.hospitalWithMentalIllnessSpecialContractAfter6")) + "\n" +
                "無事故給付特約（減額前）:" + (cmp.get("v.accidentFreeBenefitSpecialContractBefore6") == null ? "" : cmp.get("v.accidentFreeBenefitSpecialContractBefore6")) + "\n" +
                "無事故給付特約（減額後）:" + (cmp.get("v.accidentFreeBenefitSpecialContractAfter6") == null ? "" : cmp.get("v.accidentFreeBenefitSpecialContractAfter6")) + "\n" +
                "入院一時金特約（減額前）:" + (cmp.get("v.hospitalLumpSumRiderBefore6") == null ? "" : cmp.get("v.hospitalLumpSumRiderBefore6")) + "\n" +
                "入院一時金特約（減額後）:" + (cmp.get("v.hospitalLumpSumRiderAfter6") == null ? "" : cmp.get("v.hospitalLumpSumRiderAfter6"));
        }
        else {
            obj.ChangeDetails6__c = "";
        }


        obj.PolicyNumber7__c = cmp.get("v.innerCmpNewRequest").PolicyNumber7__c;
        if (obj.PolicyNumber7__c != '') {
            obj.ChangeDetails7__c = "がん特約／がん診断給付特約／がん特約Ⅱ（減額前）:" + (cmp.get("v.cancerTreaty7") == null ? "" : cmp.get("v.cancerTreaty7")) + "\n" +
                "がん特約／がん診断給付特約／がん特約Ⅱ（減額後）:" + (cmp.get("v.afterCancerSpecialContractReduction7") == null ? "" : cmp.get("v.afterCancerSpecialContractReduction7")) + "\n" +
                "急性心筋梗塞・脳卒中特約（減額前）:" + (cmp.get("v.heartAttackStrokeAfter7") == null ? "" : cmp.get("v.heartAttackStrokeAfter7")) + "\n" +
                "急性心筋梗塞・脳卒中特約（減額後）:" + (cmp.get("v.heartAttackStrokeBefore7") == null ? "" : cmp.get("v.heartAttackStrokeBefore7")) + "\n" +
                "通院特約（減額前）:" + (cmp.get("v.hospitalSpecialContracteforeReduc7") == null ? "" : cmp.get("v.hospitalSpecialContracteforeReduc7")) + "\n" +
                "通院特約（減額後）:" + (cmp.get("v.hospitalSpecialContractAfterReducti7") == null ? "" : cmp.get("v.hospitalSpecialContractAfterReducti7")) + "\n" +
                "がん入院特約（減額前）:" + (cmp.get("v.beforeHospitalizationSpecialContract7") == null ? "" : cmp.get("v.beforeHospitalizationSpecialContract7")) + "\n" +
                "がん入院特約（減額後）:" + (cmp.get("v.afterHospitalizationSpecialContract7") == null ? "" : cmp.get("v.afterHospitalizationSpecialContract7")) + "\n" +
                "退院・通院特約（減額前）:" + (cmp.get("v.dischargeHospitalSpecialContractF7") == null ? "" : cmp.get("v.dischargeHospitalSpecialContractF7")) + "\n" +
                "退院・通院特約（減額後）:" + (cmp.get("v.dischargeHospitalSpecialContractAf7") == null ? "" : cmp.get("v.dischargeHospitalSpecialContractAf7")) + "\n" +
                "7疾病特約（減額前）:" + (cmp.get("v.sevenSpecialContractFront7") == null ? "" : cmp.get("v.sevenSpecialContractFront7")) + "\n" +
                "7疾病特約（減額後）:" + (cmp.get("v.sevenSpecialAfter7") == null ? "" : cmp.get("v.sevenSpecialAfter7")) + "\n" +
                "介護給付特約（減額前）:" + (cmp.get("v.longTermCareBnefitSpecialContractBefore7") == null ? "" : cmp.get("v.longTermCareBnefitSpecialContractBefore7")) + "\n" +
                "介護給付特約（減額後）:" + (cmp.get("v.longTermCareBnefitSpecialContractAfter7") == null ? "" : cmp.get("v.longTermCareBnefitSpecialContractAfter7")) + "\n" +
                "精神疾患併発入院特約（減額前）:" + (cmp.get("v.hospitalWithMentalIllnessSpecialContractBefore7") == null ? "" : cmp.get("v.hospitalWithMentalIllnessSpecialContractBefore7")) + "\n" +
                "精神疾患併発入院特約（減額後）:" + (cmp.get("v.hospitalWithMentalIllnessSpecialContractAfter7") == null ? "" : cmp.get("v.hospitalWithMentalIllnessSpecialContractAfter7")) + "\n" +
                "無事故給付特約（減額前）:" + (cmp.get("v.accidentFreeBenefitSpecialContractBefore7") == null ? "" : cmp.get("v.accidentFreeBenefitSpecialContractBefore7")) + "\n" +
                "無事故給付特約（減額後）:" + (cmp.get("v.accidentFreeBenefitSpecialContractAfter7") == null ? "" : cmp.get("v.accidentFreeBenefitSpecialContractAfter7")) + "\n" +
                "入院一時金特約（減額前）:" + (cmp.get("v.hospitalLumpSumRiderBefore7") == null ? "" : cmp.get("v.hospitalLumpSumRiderBefore7")) + "\n" +
                "入院一時金特約（減額後）:" + (cmp.get("v.hospitalLumpSumRiderAfter7") == null ? "" : cmp.get("v.hospitalLumpSumRiderAfter7"));
        }
        else {
            obj.ChangeDetails7__c = "";
        }

        obj.PolicyNumber8__c = cmp.get("v.innerCmpNewRequest").PolicyNumber8__c;
        if (obj.PolicyNumber8__c != '') {
            obj.ChangeDetails8__c = "がん特約／がん診断給付特約／がん特約Ⅱ（減額前）:" + (cmp.get("v.cancerTreaty8") == null ? "" : cmp.get("v.cancerTreaty8")) + "\n" +
                "がん特約／がん診断給付特約／がん特約Ⅱ（減額後）:" + (cmp.get("v.afterCancerSpecialContractReduction8") == null ? "" : cmp.get("v.afterCancerSpecialContractReduction8")) + "\n" +
                "急性心筋梗塞・脳卒中特約（減額前）:" + (cmp.get("v.heartAttackStrokeAfter8") == null ? "" : cmp.get("v.heartAttackStrokeAfter8")) + "\n" +
                "急性心筋梗塞・脳卒中特約（減額後）:" + (cmp.get("v.heartAttackStrokeBefore8") == null ? "" : cmp.get("v.heartAttackStrokeBefore8")) + "\n" +
                "通院特約（減額前）:" + (cmp.get("v.hospitalSpecialContracteforeReduc8") == null ? "" : cmp.get("v.hospitalSpecialContracteforeReduc8")) + "\n" +
                "通院特約（減額後）:" + (cmp.get("v.hospitalSpecialContractAfterReducti8") == null ? "" : cmp.get("v.hospitalSpecialContractAfterReducti8")) + "\n" +
                "がん入院特約（減額前）:" + (cmp.get("v.beforeHospitalizationSpecialContract8") == null ? "" : cmp.get("v.beforeHospitalizationSpecialContract8")) + "\n" +
                "がん入院特約（減額後）:" + (cmp.get("v.afterHospitalizationSpecialContract8") == null ? "" : cmp.get("v.afterHospitalizationSpecialContract8")) + "\n" +
                "退院・通院特約（減額前）:" + (cmp.get("v.dischargeHospitalSpecialContractF8") == null ? "" : cmp.get("v.dischargeHospitalSpecialContractF8")) + "\n" +
                "退院・通院特約（減額後）:" + (cmp.get("v.dischargeHospitalSpecialContractAf8") == null ? "" : cmp.get("v.dischargeHospitalSpecialContractAf8")) + "\n" +
                "7疾病特約（減額前）:" + (cmp.get("v.sevenSpecialContractFront8") == null ? "" : cmp.get("v.sevenSpecialContractFront8")) + "\n" +
                "7疾病特約（減額後）:" + (cmp.get("v.sevenSpecialAfter8") == null ? "" : cmp.get("v.sevenSpecialAfter8")) + "\n" +
                "介護給付特約（減額前）:" + (cmp.get("v.longTermCareBnefitSpecialContractBefore8") == null ? "" : cmp.get("v.longTermCareBnefitSpecialContractBefore8")) + "\n" +
                "介護給付特約（減額後）:" + (cmp.get("v.longTermCareBnefitSpecialContractAfter8") == null ? "" : cmp.get("v.longTermCareBnefitSpecialContractAfter8")) + "\n" +
                "精神疾患併発入院特約（減額前）:" + (cmp.get("v.hospitalWithMentalIllnessSpecialContractBefore8") == null ? "" : cmp.get("v.hospitalWithMentalIllnessSpecialContractBefore8")) + "\n" +
                "精神疾患併発入院特約（減額後）:" + (cmp.get("v.hospitalWithMentalIllnessSpecialContractAfter8") == null ? "" : cmp.get("v.hospitalWithMentalIllnessSpecialContractAfter8")) + "\n" +
                "無事故給付特約（減額前）:" + (cmp.get("v.accidentFreeBenefitSpecialContractBefore8") == null ? "" : cmp.get("v.accidentFreeBenefitSpecialContractBefore8")) + "\n" +
                "無事故給付特約（減額後）:" + (cmp.get("v.accidentFreeBenefitSpecialContractAfter8") == null ? "" : cmp.get("v.accidentFreeBenefitSpecialContractAfter8")) + "\n" +
                "入院一時金特約（減額前）:" + (cmp.get("v.hospitalLumpSumRiderBefore8") == null ? "" : cmp.get("v.hospitalLumpSumRiderBefore8")) + "\n" +
                "入院一時金特約（減額後）:" + (cmp.get("v.hospitalLumpSumRiderAfter8") == null ? "" : cmp.get("v.hospitalLumpSumRiderAfter8"));
        }
        else {
            obj.ChangeDetails8__c = "";
        }

        obj.PolicyNumber9__c = cmp.get("v.innerCmpNewRequest").PolicyNumber9__c;
        if (obj.PolicyNumber9__c != '') {
            obj.ChangeDetails9__c = "がん特約／がん診断給付特約／がん特約Ⅱ（減額前）:" + (cmp.get("v.cancerTreaty9") == null ? "" : cmp.get("v.cancerTreaty9")) + "\n" +
                "がん特約／がん診断給付特約／がん特約Ⅱ（減額後）:" + (cmp.get("v.afterCancerSpecialContractReduction9") == null ? "" : cmp.get("v.afterCancerSpecialContractReduction9")) + "\n" +
                "急性心筋梗塞・脳卒中特約（減額前）:" + (cmp.get("v.heartAttackStrokeAfter9") == null ? "" : cmp.get("v.heartAttackStrokeAfter9")) + "\n" +
                "急性心筋梗塞・脳卒中特約（減額後）:" + (cmp.get("v.heartAttackStrokeBefore9") == null ? "" : cmp.get("v.heartAttackStrokeBefore9")) + "\n" +
                "通院特約（減額前）:" + (cmp.get("v.hospitalSpecialContracteforeReduc9") == null ? "" : cmp.get("v.hospitalSpecialContracteforeReduc9")) + "\n" +
                "通院特約（減額後）:" + (cmp.get("v.hospitalSpecialContractAfterReducti9") == null ? "" : cmp.get("v.hospitalSpecialContractAfterReducti9")) + "\n" +
                "がん入院特約（減額前）:" + (cmp.get("v.beforeHospitalizationSpecialContract9") == null ? "" : cmp.get("v.beforeHospitalizationSpecialContract9")) + "\n" +
                "がん入院特約（減額後）:" + (cmp.get("v.afterHospitalizationSpecialContract9") == null ? "" : cmp.get("v.afterHospitalizationSpecialContract9")) + "\n" +
                "退院・通院特約（減額前）:" + (cmp.get("v.dischargeHospitalSpecialContractF9") == null ? "" : cmp.get("v.dischargeHospitalSpecialContractF9")) + "\n" +
                "退院・通院特約（減額後）:" + (cmp.get("v.dischargeHospitalSpecialContractAf9") == null ? "" : cmp.get("v.dischargeHospitalSpecialContractAf9")) + "\n" +
                "7疾病特約（減額前）:" + (cmp.get("v.sevenSpecialContractFront9") == null ? "" : cmp.get("v.sevenSpecialContractFront9")) + "\n" +
                "7疾病特約（減額後）:" + (cmp.get("v.sevenSpecialAfter9") == null ? "" : cmp.get("v.sevenSpecialAfter9")) + "\n" +
                "介護給付特約（減額前）:" + (cmp.get("v.longTermCareBnefitSpecialContractBefore9") == null ? "" : cmp.get("v.longTermCareBnefitSpecialContractBefore9")) + "\n" +
                "介護給付特約（減額後）:" + (cmp.get("v.longTermCareBnefitSpecialContractAfter9") == null ? "" : cmp.get("v.longTermCareBnefitSpecialContractAfter9")) + "\n" +
                "精神疾患併発入院特約（減額前）:" + (cmp.get("v.hospitalWithMentalIllnessSpecialContractBefore9") == null ? "" : cmp.get("v.hospitalWithMentalIllnessSpecialContractBefore9")) + "\n" +
                "精神疾患併発入院特約（減額後）:" + (cmp.get("v.hospitalWithMentalIllnessSpecialContractAfter9") == null ? "" : cmp.get("v.hospitalWithMentalIllnessSpecialContractAfter9")) + "\n" +
                "無事故給付特約（減額前）:" + (cmp.get("v.accidentFreeBenefitSpecialContractBefore9") == null ? "" : cmp.get("v.accidentFreeBenefitSpecialContractBefore9")) + "\n" +
                "無事故給付特約（減額後）:" + (cmp.get("v.accidentFreeBenefitSpecialContractAfter9") == null ? "" : cmp.get("v.accidentFreeBenefitSpecialContractAfter9")) + "\n" +
                "入院一時金特約（減額前）:" + (cmp.get("v.hospitalLumpSumRiderBefore9") == null ? "" : cmp.get("v.hospitalLumpSumRiderBefore9")) + "\n" +
                "入院一時金特約（減額後）:" + (cmp.get("v.hospitalLumpSumRiderAfter9") == null ? "" : cmp.get("v.hospitalLumpSumRiderAfter9"));
        }
        else {
            obj.ChangeDetails9__c = "";
        }

        obj.PolicyNumber10__c = cmp.get("v.innerCmpNewRequest").PolicyNumber10__c;
        if (obj.PolicyNumber10__c != '') {
            obj.ChangeDetails10__c = "がん特約／がん診断給付特約／がん特約Ⅱ（減額前）:" + (cmp.get("v.cancerTreaty10") == null ? "" : cmp.get("v.cancerTreaty10")) + "\n" +
                "がん特約／がん診断給付特約／がん特約Ⅱ（減額後）:" + (cmp.get("v.afterCancerSpecialContractReduction10") == null ? "" : cmp.get("v.afterCancerSpecialContractReduction10")) + "\n" +
                "急性心筋梗塞・脳卒中特約（減額前）:" + (cmp.get("v.heartAttackStrokeAfter10") == null ? "" : cmp.get("v.heartAttackStrokeAfter10")) + "\n" +
                "急性心筋梗塞・脳卒中特約（減額後）:" + (cmp.get("v.heartAttackStrokeBefore10") == null ? "" : cmp.get("v.heartAttackStrokeBefore10")) + "\n" +
                "通院特約（減額前）:" + (cmp.get("v.hospitalSpecialContracteforeReduc10") == null ? "" : cmp.get("v.hospitalSpecialContracteforeReduc10")) + "\n" +
                "通院特約（減額後）:" + (cmp.get("v.hospitalSpecialContractAfterReducti10") == null ? "" : cmp.get("v.hospitalSpecialContractAfterReducti10")) + "\n" +
                "がん入院特約（減額前）:" + (cmp.get("v.beforeHospitalizationSpecialContract10") == null ? "" : cmp.get("v.beforeHospitalizationSpecialContract10")) + "\n" +
                "がん入院特約（減額後）:" + (cmp.get("v.afterHospitalizationSpecialContract10") == null ? "" : cmp.get("v.afterHospitalizationSpecialContract10")) + "\n" +
                "退院・通院特約（減額前）:" + (cmp.get("v.dischargeHospitalSpecialContractF10") == null ? "" : cmp.get("v.dischargeHospitalSpecialContractF10")) + "\n" +
                "退院・通院特約（減額後）:" + (cmp.get("v.dischargeHospitalSpecialContractAf10") == null ? "" : cmp.get("v.dischargeHospitalSpecialContractAf10")) + "\n" +
                "7疾病特約（減額前）:" + (cmp.get("v.sevenSpecialContractFront10") == null ? "" : cmp.get("v.sevenSpecialContractFront10")) + "\n" +
                "7疾病特約（減額後）:" + (cmp.get("v.sevenSpecialAfter10") == null ? "" : cmp.get("v.sevenSpecialAfter10")) + "\n" +
                "介護給付特約（減額前）:" + (cmp.get("v.longTermCareBnefitSpecialContractBefore10") == null ? "" : cmp.get("v.longTermCareBnefitSpecialContractBefore10")) + "\n" +
                "介護給付特約（減額後）:" + (cmp.get("v.longTermCareBnefitSpecialContractAfter10") == null ? "" : cmp.get("v.longTermCareBnefitSpecialContractAfter10")) + "\n" +
                "精神疾患併発入院特約（減額前）:" + (cmp.get("v.hospitalWithMentalIllnessSpecialContractBefore10") == null ? "" : cmp.get("v.hospitalWithMentalIllnessSpecialContractBefore10")) + "\n" +
                "精神疾患併発入院特約（減額後）:" + (cmp.get("v.hospitalWithMentalIllnessSpecialContractAfter10") == null ? "" : cmp.get("v.hospitalWithMentalIllnessSpecialContractAfter10")) + "\n" +
                "無事故給付特約（減額前）:" + (cmp.get("v.accidentFreeBenefitSpecialContractBefore10") == null ? "" : cmp.get("v.accidentFreeBenefitSpecialContractBefore10")) + "\n" +
                "無事故給付特約（減額後）:" + (cmp.get("v.accidentFreeBenefitSpecialContractAfter10") == null ? "" : cmp.get("v.accidentFreeBenefitSpecialContractAfter10")) + "\n" +
                "入院一時金特約（減額前）:" + (cmp.get("v.hospitalLumpSumRiderBefore10") == null ? "" : cmp.get("v.hospitalLumpSumRiderBefore10")) + "\n" +
                "入院一時金特約（減額後）:" + (cmp.get("v.hospitalLumpSumRiderAfter10") == null ? "" : cmp.get("v.hospitalLumpSumRiderAfter10"));
        }
        else {
            obj.ChangeDetails10__c = "";
        }

        obj.Processing__c = cmp.get("v.innerCmpNewRequest").Processing__c;
        obj.ShippingDocuments__c = cmp.get("v.innerCmpNewRequest").ShippingDocuments__c;
        //obj.NumberOfCopies__c = cmp.get("v.innerCmpNewRequest").NumberOfCopies__c;
		obj.NumberOfCopies__c = cmp.get("v.numberOfCopies");
        obj.DateOfShipment__c = cmp.get("v.innerCmpNewRequest").DateOfShipment__c;
        obj.ShippingMethod__c = cmp.get("v.innerCmpNewRequest").ShippingMethod__c;

        var cancerTreatyErr1 = cmp.get("v.cancerTreatyErr1");
        var afterCancerSpecialContractReductionErr1 = cmp.get("v.afterCancerSpecialContractReductionErr1");
        var heartAttackStrokeAfterErr1 = cmp.get("v.heartAttackStrokeAfterErr1");
        var heartAttackStrokeBeforeErr1 = cmp.get("v.heartAttackStrokeBeforeErr1");
        var hospitalSpecialContracteforeReducErr1 = cmp.get("v.hospitalSpecialContracteforeReducErr1");
        var hospitalSpecialContractAfterReductiErr1 = cmp.get("v.hospitalSpecialContractAfterReductiErr1");
        var beforeHospitalizationSpecialContractErr1 = cmp.get("v.beforeHospitalizationSpecialContractErr1");
        var afterHospitalizationSpecialContractErr1 = cmp.get("v.afterHospitalizationSpecialContractErr1");
        var dischargeHospitalSpecialContractFErr1 = cmp.get("v.dischargeHospitalSpecialContractFErr1");
        var dischargeHospitalSpecialContractAfErr1 = cmp.get("v.dischargeHospitalSpecialContractAfErr1");
        var sevenSpecialContractFrontErr1 = cmp.get("v.sevenSpecialContractFrontErr1");
        var sevenSpecialAfterErr1 = cmp.get("v.sevenSpecialAfterErr1");
        var longTermCareBnefitSpecialContractBeforeErr1 = cmp.get("v.longTermCareBnefitSpecialContractBeforeErr1");
        var longTermCareBnefitSpecialContractAfterErr1 = cmp.get("v.longTermCareBnefitSpecialContractAfterErr1");
        var hospitalWithMentalIllnessSpecialContractBeforeErr1 = cmp.get("v.hospitalWithMentalIllnessSpecialContractBeforeErr1");
        var hospitalWithMentalIllnessSpecialContractAfterErr1 = cmp.get("v.hospitalWithMentalIllnessSpecialContractAfterErr1");
        var accidentFreeBenefitSpecialContractBeforeErr1 = cmp.get("v.accidentFreeBenefitSpecialContractBeforeErr1");
        var accidentFreeBenefitSpecialContractAfterErr1 = cmp.get("v.accidentFreeBenefitSpecialContractAfterErr1");
        var hospitalLumpSumRiderBeforeErr1 = cmp.get("v.hospitalLumpSumRiderBeforeErr1");
        var hospitalLumpSumRiderAfterErr1 = cmp.get("v.hospitalLumpSumRiderAfterErr1");

        var cancerTreatyErr2 = cmp.get("v.cancerTreatyErr2");
        var afterCancerSpecialContractReductionErr2 = cmp.get("v.afterCancerSpecialContractReductionErr2");
        var heartAttackStrokeAfterErr2 = cmp.get("v.heartAttackStrokeAfterErr2");
        var heartAttackStrokeBeforeErr2 = cmp.get("v.heartAttackStrokeBeforeErr2");
        var hospitalSpecialContracteforeReducErr2 = cmp.get("v.hospitalSpecialContracteforeReducErr2");
        var hospitalSpecialContractAfterReductiErr2 = cmp.get("v.hospitalSpecialContractAfterReductiErr2");
        var beforeHospitalizationSpecialContractErr2 = cmp.get("v.beforeHospitalizationSpecialContractErr2");
        var afterHospitalizationSpecialContractErr2 = cmp.get("v.afterHospitalizationSpecialContractErr2");
        var dischargeHospitalSpecialContractFErr2 = cmp.get("v.dischargeHospitalSpecialContractFErr2");
        var dischargeHospitalSpecialContractAfErr2 = cmp.get("v.dischargeHospitalSpecialContractAfErr2");
        var sevenSpecialContractFrontErr2 = cmp.get("v.sevenSpecialContractFrontErr2");
        var sevenSpecialAfterErr2 = cmp.get("v.sevenSpecialAfterErr2");
        var longTermCareBnefitSpecialContractBeforeErr2 = cmp.get("v.longTermCareBnefitSpecialContractBeforeErr2");
        var longTermCareBnefitSpecialContractAfterErr2 = cmp.get("v.longTermCareBnefitSpecialContractAfterErr2");
        var hospitalWithMentalIllnessSpecialContractBeforeErr2 = cmp.get("v.hospitalWithMentalIllnessSpecialContractBeforeErr2");
        var hospitalWithMentalIllnessSpecialContractAfterErr2 = cmp.get("v.hospitalWithMentalIllnessSpecialContractAfterErr2");
        var accidentFreeBenefitSpecialContractBeforeErr2 = cmp.get("v.accidentFreeBenefitSpecialContractBeforeErr2");
        var accidentFreeBenefitSpecialContractAfterErr2 = cmp.get("v.accidentFreeBenefitSpecialContractAfterErr2");
        var hospitalLumpSumRiderBeforeErr2 = cmp.get("v.hospitalLumpSumRiderBeforeErr2");
        var hospitalLumpSumRiderAfterErr2 = cmp.get("v.hospitalLumpSumRiderAfterErr2");

        var cancerTreatyErr3 = cmp.get("v.cancerTreatyErr3");
        var afterCancerSpecialContractReductionErr3 = cmp.get("v.afterCancerSpecialContractReductionErr3");
        var heartAttackStrokeAfterErr3 = cmp.get("v.heartAttackStrokeAfterErr3");
        var heartAttackStrokeBeforeErr3 = cmp.get("v.heartAttackStrokeBeforeErr3");
        var hospitalSpecialContracteforeReducErr3 = cmp.get("v.hospitalSpecialContracteforeReducErr3");
        var hospitalSpecialContractAfterReductiErr3 = cmp.get("v.hospitalSpecialContractAfterReductiErr3");
        var beforeHospitalizationSpecialContractErr3 = cmp.get("v.beforeHospitalizationSpecialContractErr3");
        var afterHospitalizationSpecialContractErr3 = cmp.get("v.afterHospitalizationSpecialContractErr3");
        var dischargeHospitalSpecialContractFErr3 = cmp.get("v.dischargeHospitalSpecialContractFErr3");
        var dischargeHospitalSpecialContractAfErr3 = cmp.get("v.dischargeHospitalSpecialContractAfErr3");
        var sevenSpecialContractFrontErr3 = cmp.get("v.sevenSpecialContractFrontErr3");
        var sevenSpecialAfterErr3 = cmp.get("v.sevenSpecialAfterErr3");
        var longTermCareBnefitSpecialContractBeforeErr3 = cmp.get("v.longTermCareBnefitSpecialContractBeforeErr3");
        var longTermCareBnefitSpecialContractAfterErr3 = cmp.get("v.longTermCareBnefitSpecialContractAfterErr3");
        var hospitalWithMentalIllnessSpecialContractBeforeErr3 = cmp.get("v.hospitalWithMentalIllnessSpecialContractBeforeErr3");
        var hospitalWithMentalIllnessSpecialContractAfterErr3 = cmp.get("v.hospitalWithMentalIllnessSpecialContractAfterErr3");
        var accidentFreeBenefitSpecialContractBeforeErr3 = cmp.get("v.accidentFreeBenefitSpecialContractBeforeErr3");
        var accidentFreeBenefitSpecialContractAfterErr3 = cmp.get("v.accidentFreeBenefitSpecialContractAfterErr3");
        var hospitalLumpSumRiderBeforeErr3 = cmp.get("v.hospitalLumpSumRiderBeforeErr3");
        var hospitalLumpSumRiderAfterErr3 = cmp.get("v.hospitalLumpSumRiderAfterErr3");

        var cancerTreatyErr4 = cmp.get("v.cancerTreatyErr4");
        var afterCancerSpecialContractReductionErr4 = cmp.get("v.afterCancerSpecialContractReductionErr4");
        var heartAttackStrokeAfterErr4 = cmp.get("v.heartAttackStrokeAfterErr4");
        var heartAttackStrokeBeforeErr4 = cmp.get("v.heartAttackStrokeBeforeErr4");
        var hospitalSpecialContracteforeReducErr4 = cmp.get("v.hospitalSpecialContracteforeReducErr4");
        var hospitalSpecialContractAfterReductiErr4 = cmp.get("v.hospitalSpecialContractAfterReductiErr4");
        var beforeHospitalizationSpecialContractErr4 = cmp.get("v.beforeHospitalizationSpecialContractErr4");
        var afterHospitalizationSpecialContractErr4 = cmp.get("v.afterHospitalizationSpecialContractErr4");
        var dischargeHospitalSpecialContractFErr4 = cmp.get("v.dischargeHospitalSpecialContractFErr4");
        var dischargeHospitalSpecialContractAfErr4 = cmp.get("v.dischargeHospitalSpecialContractAfErr4");
        var sevenSpecialContractFrontErr4 = cmp.get("v.sevenSpecialContractFrontErr4");
        var sevenSpecialAfterErr4 = cmp.get("v.sevenSpecialAfterErr4");
        var longTermCareBnefitSpecialContractBeforeErr4 = cmp.get("v.longTermCareBnefitSpecialContractBeforeErr4");
        var longTermCareBnefitSpecialContractAfterErr4 = cmp.get("v.longTermCareBnefitSpecialContractAfterErr4");
        var hospitalWithMentalIllnessSpecialContractBeforeErr4 = cmp.get("v.hospitalWithMentalIllnessSpecialContractBeforeErr4");
        var hospitalWithMentalIllnessSpecialContractAfterErr4 = cmp.get("v.hospitalWithMentalIllnessSpecialContractAfterErr4");
        var accidentFreeBenefitSpecialContractBeforeErr4 = cmp.get("v.accidentFreeBenefitSpecialContractBeforeErr4");
        var accidentFreeBenefitSpecialContractAfterErr4 = cmp.get("v.accidentFreeBenefitSpecialContractAfterErr4");
        var hospitalLumpSumRiderBeforeErr4 = cmp.get("v.hospitalLumpSumRiderBeforeErr4");
        var hospitalLumpSumRiderAfterErr4 = cmp.get("v.hospitalLumpSumRiderAfterErr4");

        var cancerTreatyErr5 = cmp.get("v.cancerTreatyErr5");
        var afterCancerSpecialContractReductionErr5 = cmp.get("v.afterCancerSpecialContractReductionErr5");
        var heartAttackStrokeAfterErr5 = cmp.get("v.heartAttackStrokeAfterErr5");
        var heartAttackStrokeBeforeErr5 = cmp.get("v.heartAttackStrokeBeforeErr5");
        var hospitalSpecialContracteforeReducErr5 = cmp.get("v.hospitalSpecialContracteforeReducErr5");
        var hospitalSpecialContractAfterReductiErr5 = cmp.get("v.hospitalSpecialContractAfterReductiErr5");
        var beforeHospitalizationSpecialContractErr5 = cmp.get("v.beforeHospitalizationSpecialContractErr5");
        var afterHospitalizationSpecialContractErr5 = cmp.get("v.afterHospitalizationSpecialContractErr5");
        var dischargeHospitalSpecialContractFErr5 = cmp.get("v.dischargeHospitalSpecialContractFErr5");
        var dischargeHospitalSpecialContractAfErr5 = cmp.get("v.dischargeHospitalSpecialContractAfErr5");
        var sevenSpecialContractFrontErr5 = cmp.get("v.sevenSpecialContractFrontErr5");
        var sevenSpecialAfterErr5 = cmp.get("v.sevenSpecialAfterErr5");
        var longTermCareBnefitSpecialContractBeforeErr5 = cmp.get("v.longTermCareBnefitSpecialContractBeforeErr5");
        var longTermCareBnefitSpecialContractAfterErr5 = cmp.get("v.longTermCareBnefitSpecialContractAfterErr5");
        var hospitalWithMentalIllnessSpecialContractBeforeErr5 = cmp.get("v.hospitalWithMentalIllnessSpecialContractBeforeErr5");
        var hospitalWithMentalIllnessSpecialContractAfterErr5 = cmp.get("v.hospitalWithMentalIllnessSpecialContractAfterErr5");
        var accidentFreeBenefitSpecialContractBeforeErr5 = cmp.get("v.accidentFreeBenefitSpecialContractBeforeErr5");
        var accidentFreeBenefitSpecialContractAfterErr5 = cmp.get("v.accidentFreeBenefitSpecialContractAfterErr5");
        var hospitalLumpSumRiderBeforeErr5 = cmp.get("v.hospitalLumpSumRiderBeforeErr5");
        var hospitalLumpSumRiderAfterErr5 = cmp.get("v.hospitalLumpSumRiderAfterErr5");

        var cancerTreatyErr6 = cmp.get("v.cancerTreatyErr6");
        var afterCancerSpecialContractReductionErr6 = cmp.get("v.afterCancerSpecialContractReductionErr6");
        var heartAttackStrokeAfterErr6 = cmp.get("v.heartAttackStrokeAfterErr6");
        var heartAttackStrokeBeforeErr6 = cmp.get("v.heartAttackStrokeBeforeErr6");
        var hospitalSpecialContracteforeReducErr6 = cmp.get("v.hospitalSpecialContracteforeReducErr6");
        var hospitalSpecialContractAfterReductiErr6 = cmp.get("v.hospitalSpecialContractAfterReductiErr6");
        var beforeHospitalizationSpecialContractErr6 = cmp.get("v.beforeHospitalizationSpecialContractErr6");
        var afterHospitalizationSpecialContractErr6 = cmp.get("v.afterHospitalizationSpecialContractErr6");
        var dischargeHospitalSpecialContractFErr6 = cmp.get("v.dischargeHospitalSpecialContractFErr6");
        var dischargeHospitalSpecialContractAfErr6 = cmp.get("v.dischargeHospitalSpecialContractAfErr6");
        var sevenSpecialContractFrontErr6 = cmp.get("v.sevenSpecialContractFrontErr6");
        var sevenSpecialAfterErr6 = cmp.get("v.sevenSpecialAfterErr6");
        var longTermCareBnefitSpecialContractBeforeErr6 = cmp.get("v.longTermCareBnefitSpecialContractBeforeErr6");
        var longTermCareBnefitSpecialContractAfterErr6 = cmp.get("v.longTermCareBnefitSpecialContractAfterErr6");
        var hospitalWithMentalIllnessSpecialContractBeforeErr6 = cmp.get("v.hospitalWithMentalIllnessSpecialContractBeforeErr6");
        var hospitalWithMentalIllnessSpecialContractAfterErr6 = cmp.get("v.hospitalWithMentalIllnessSpecialContractAfterErr6");
        var accidentFreeBenefitSpecialContractBeforeErr6 = cmp.get("v.accidentFreeBenefitSpecialContractBeforeErr6");
        var accidentFreeBenefitSpecialContractAfterErr6 = cmp.get("v.accidentFreeBenefitSpecialContractAfterErr6");
        var hospitalLumpSumRiderBeforeErr6 = cmp.get("v.hospitalLumpSumRiderBeforeErr6");
        var hospitalLumpSumRiderAfterErr6 = cmp.get("v.hospitalLumpSumRiderAfterErr6");

        var cancerTreatyErr7 = cmp.get("v.cancerTreatyErr7");
        var afterCancerSpecialContractReductionErr7 = cmp.get("v.afterCancerSpecialContractReductionErr7");
        var heartAttackStrokeAfterErr7 = cmp.get("v.heartAttackStrokeAfterErr7");
        var heartAttackStrokeBeforeErr7 = cmp.get("v.heartAttackStrokeBeforeErr7");
        var hospitalSpecialContracteforeReducErr7 = cmp.get("v.hospitalSpecialContracteforeReducErr7");
        var hospitalSpecialContractAfterReductiErr7 = cmp.get("v.hospitalSpecialContractAfterReductiErr7");
        var beforeHospitalizationSpecialContractErr7 = cmp.get("v.beforeHospitalizationSpecialContractErr7");
        var afterHospitalizationSpecialContractErr7 = cmp.get("v.afterHospitalizationSpecialContractErr7");
        var dischargeHospitalSpecialContractFErr7 = cmp.get("v.dischargeHospitalSpecialContractFErr7");
        var dischargeHospitalSpecialContractAfErr7 = cmp.get("v.dischargeHospitalSpecialContractAfErr7");
        var sevenSpecialContractFrontErr7 = cmp.get("v.sevenSpecialContractFrontErr7");
        var sevenSpecialAfterErr7 = cmp.get("v.sevenSpecialAfterErr7");
        var longTermCareBnefitSpecialContractBeforeErr7 = cmp.get("v.longTermCareBnefitSpecialContractBeforeErr7");
        var longTermCareBnefitSpecialContractAfterErr7 = cmp.get("v.longTermCareBnefitSpecialContractAfterErr7");
        var hospitalWithMentalIllnessSpecialContractBeforeErr7 = cmp.get("v.hospitalWithMentalIllnessSpecialContractBeforeErr7");
        var hospitalWithMentalIllnessSpecialContractAfterErr7 = cmp.get("v.hospitalWithMentalIllnessSpecialContractAfterErr7");
        var accidentFreeBenefitSpecialContractBeforeErr7 = cmp.get("v.accidentFreeBenefitSpecialContractBeforeErr7");
        var accidentFreeBenefitSpecialContractAfterErr7 = cmp.get("v.accidentFreeBenefitSpecialContractAfterErr7");
        var hospitalLumpSumRiderBeforeErr7 = cmp.get("v.hospitalLumpSumRiderBeforeErr7");
        var hospitalLumpSumRiderAfterErr7 = cmp.get("v.hospitalLumpSumRiderAfterErr7");

        var cancerTreatyErr8 = cmp.get("v.cancerTreatyErr8");
        var afterCancerSpecialContractReductionErr8 = cmp.get("v.afterCancerSpecialContractReductionErr8");
        var heartAttackStrokeAfterErr8 = cmp.get("v.heartAttackStrokeAfterErr8");
        var heartAttackStrokeBeforeErr8 = cmp.get("v.heartAttackStrokeBeforeErr8");
        var hospitalSpecialContracteforeReducErr8 = cmp.get("v.hospitalSpecialContracteforeReducErr8");
        var hospitalSpecialContractAfterReductiErr8 = cmp.get("v.hospitalSpecialContractAfterReductiErr8");
        var beforeHospitalizationSpecialContractErr8 = cmp.get("v.beforeHospitalizationSpecialContractErr8");
        var afterHospitalizationSpecialContractErr8 = cmp.get("v.afterHospitalizationSpecialContractErr8");
        var dischargeHospitalSpecialContractFErr8 = cmp.get("v.dischargeHospitalSpecialContractFErr8");
        var dischargeHospitalSpecialContractAfErr8 = cmp.get("v.dischargeHospitalSpecialContractAfErr8");
        var sevenSpecialContractFrontErr8 = cmp.get("v.sevenSpecialContractFrontErr8");
        var sevenSpecialAfterErr8 = cmp.get("v.sevenSpecialAfterErr8");
        var longTermCareBnefitSpecialContractBeforeErr8 = cmp.get("v.longTermCareBnefitSpecialContractBeforeErr8");
        var longTermCareBnefitSpecialContractAfterErr8 = cmp.get("v.longTermCareBnefitSpecialContractAfterErr8");
        var hospitalWithMentalIllnessSpecialContractBeforeErr8 = cmp.get("v.hospitalWithMentalIllnessSpecialContractBeforeErr8");
        var hospitalWithMentalIllnessSpecialContractAfterErr8 = cmp.get("v.hospitalWithMentalIllnessSpecialContractAfterErr8");
        var accidentFreeBenefitSpecialContractBeforeErr8 = cmp.get("v.accidentFreeBenefitSpecialContractBeforeErr8");
        var accidentFreeBenefitSpecialContractAfterErr8 = cmp.get("v.accidentFreeBenefitSpecialContractAfterErr8");
        var hospitalLumpSumRiderBeforeErr8 = cmp.get("v.hospitalLumpSumRiderBeforeErr8");
        var hospitalLumpSumRiderAfterErr8 = cmp.get("v.hospitalLumpSumRiderAfterErr8");

        var cancerTreatyErr9 = cmp.get("v.cancerTreatyErr9");
        var afterCancerSpecialContractReductionErr9 = cmp.get("v.afterCancerSpecialContractReductionErr9");
        var heartAttackStrokeAfterErr9 = cmp.get("v.heartAttackStrokeAfterErr9");
        var heartAttackStrokeBeforeErr9 = cmp.get("v.heartAttackStrokeBeforeErr9");
        var hospitalSpecialContracteforeReducErr9 = cmp.get("v.hospitalSpecialContracteforeReducErr9");
        var hospitalSpecialContractAfterReductiErr9 = cmp.get("v.hospitalSpecialContractAfterReductiErr9");
        var beforeHospitalizationSpecialContractErr9 = cmp.get("v.beforeHospitalizationSpecialContractErr9");
        var afterHospitalizationSpecialContractErr9 = cmp.get("v.afterHospitalizationSpecialContractErr9");
        var dischargeHospitalSpecialContractFErr9 = cmp.get("v.dischargeHospitalSpecialContractFErr9");
        var dischargeHospitalSpecialContractAfErr9 = cmp.get("v.dischargeHospitalSpecialContractAfErr9");
        var sevenSpecialContractFrontErr9 = cmp.get("v.sevenSpecialContractFrontErr9");
        var sevenSpecialAfterErr9 = cmp.get("v.sevenSpecialAfterErr9");
        var longTermCareBnefitSpecialContractBeforeErr9 = cmp.get("v.longTermCareBnefitSpecialContractBeforeErr9");
        var longTermCareBnefitSpecialContractAfterErr9 = cmp.get("v.longTermCareBnefitSpecialContractAfterErr9");
        var hospitalWithMentalIllnessSpecialContractBeforeErr9 = cmp.get("v.hospitalWithMentalIllnessSpecialContractBeforeErr9");
        var hospitalWithMentalIllnessSpecialContractAfterErr9 = cmp.get("v.hospitalWithMentalIllnessSpecialContractAfterErr9");
        var accidentFreeBenefitSpecialContractBeforeErr9 = cmp.get("v.accidentFreeBenefitSpecialContractBeforeErr9");
        var accidentFreeBenefitSpecialContractAfterErr9 = cmp.get("v.accidentFreeBenefitSpecialContractAfterErr9");
        var hospitalLumpSumRiderBeforeErr9 = cmp.get("v.hospitalLumpSumRiderBeforeErr9");
        var hospitalLumpSumRiderAfterErr9 = cmp.get("v.hospitalLumpSumRiderAfterErr9");

        var cancerTreatyErr10 = cmp.get("v.cancerTreatyErr10");
        var afterCancerSpecialContractReductionErr10 = cmp.get("v.afterCancerSpecialContractReductionErr10");
        var heartAttackStrokeAfterErr10 = cmp.get("v.heartAttackStrokeAfterErr10");
        var heartAttackStrokeBeforeErr10 = cmp.get("v.heartAttackStrokeBeforeErr10");
        var hospitalSpecialContracteforeReducErr10 = cmp.get("v.hospitalSpecialContracteforeReducErr10");
        var hospitalSpecialContractAfterReductiErr10 = cmp.get("v.hospitalSpecialContractAfterReductiErr10");
        var beforeHospitalizationSpecialContractErr10 = cmp.get("v.beforeHospitalizationSpecialContractErr10");
        var afterHospitalizationSpecialContractErr10 = cmp.get("v.afterHospitalizationSpecialContractErr10");
        var dischargeHospitalSpecialContractFErr10 = cmp.get("v.dischargeHospitalSpecialContractFErr10");
        var dischargeHospitalSpecialContractAfErr10 = cmp.get("v.dischargeHospitalSpecialContractAfErr10");
        var sevenSpecialContractFrontErr10 = cmp.get("v.sevenSpecialContractFrontErr10");
        var sevenSpecialAfterErr10 = cmp.get("v.sevenSpecialAfterErr10");
        var longTermCareBnefitSpecialContractBeforeErr10 = cmp.get("v.longTermCareBnefitSpecialContractBeforeErr10");
        var longTermCareBnefitSpecialContractAfterErr10 = cmp.get("v.longTermCareBnefitSpecialContractAfterErr10");
        var hospitalWithMentalIllnessSpecialContractBeforeErr10 = cmp.get("v.hospitalWithMentalIllnessSpecialContractBeforeErr10");
        var hospitalWithMentalIllnessSpecialContractAfterErr10 = cmp.get("v.hospitalWithMentalIllnessSpecialContractAfterErr10");
        var accidentFreeBenefitSpecialContractBeforeErr10 = cmp.get("v.accidentFreeBenefitSpecialContractBeforeErr10");
        var accidentFreeBenefitSpecialContractAfterErr10 = cmp.get("v.accidentFreeBenefitSpecialContractAfterErr10");
        var hospitalLumpSumRiderBeforeErr10 = cmp.get("v.hospitalLumpSumRiderBeforeErr10");
        var hospitalLumpSumRiderAfterErr10 = cmp.get("v.hospitalLumpSumRiderAfterErr10");

        if (cancerTreatyErr1 || noOfCopiesErr||
			afterCancerSpecialContractReductionErr1 || heartAttackStrokeAfterErr1 || heartAttackStrokeBeforeErr1 || hospitalSpecialContracteforeReducErr1 ||
            hospitalSpecialContractAfterReductiErr1 || beforeHospitalizationSpecialContractErr1 || afterHospitalizationSpecialContractErr1 || dischargeHospitalSpecialContractFErr1 ||
            dischargeHospitalSpecialContractAfErr1 || sevenSpecialContractFrontErr1 || sevenSpecialAfterErr1 ||
            longTermCareBnefitSpecialContractBeforeErr1 || longTermCareBnefitSpecialContractAfterErr1 || hospitalWithMentalIllnessSpecialContractBeforeErr1 ||
            hospitalWithMentalIllnessSpecialContractAfterErr1 || accidentFreeBenefitSpecialContractBeforeErr1 || accidentFreeBenefitSpecialContractAfterErr1 ||
            hospitalLumpSumRiderBeforeErr1 || hospitalLumpSumRiderAfterErr1 ||
            cancerTreatyErr2 || afterCancerSpecialContractReductionErr2 || heartAttackStrokeAfterErr2 || heartAttackStrokeBeforeErr2 || hospitalSpecialContracteforeReducErr2 ||
            hospitalSpecialContractAfterReductiErr2 || beforeHospitalizationSpecialContractErr2 || afterHospitalizationSpecialContractErr2 || dischargeHospitalSpecialContractFErr2 ||
            dischargeHospitalSpecialContractAfErr2 || sevenSpecialContractFrontErr2 || sevenSpecialAfterErr2 ||
            longTermCareBnefitSpecialContractBeforeErr2 || longTermCareBnefitSpecialContractAfterErr2 || hospitalWithMentalIllnessSpecialContractBeforeErr2 ||
            hospitalWithMentalIllnessSpecialContractAfterErr2 || accidentFreeBenefitSpecialContractBeforeErr2 || accidentFreeBenefitSpecialContractAfterErr2 ||
            hospitalLumpSumRiderBeforeErr2 || hospitalLumpSumRiderAfterErr2 ||
            cancerTreatyErr3 || afterCancerSpecialContractReductionErr3 || heartAttackStrokeAfterErr3 || heartAttackStrokeBeforeErr3 || hospitalSpecialContracteforeReducErr3 ||
            hospitalSpecialContractAfterReductiErr3 || beforeHospitalizationSpecialContractErr3 || afterHospitalizationSpecialContractErr3 || dischargeHospitalSpecialContractFErr3 ||
            dischargeHospitalSpecialContractAfErr3 || sevenSpecialContractFrontErr3 || sevenSpecialAfterErr3 ||
            longTermCareBnefitSpecialContractBeforeErr3 || longTermCareBnefitSpecialContractAfterErr3 || hospitalWithMentalIllnessSpecialContractBeforeErr3 ||
            hospitalWithMentalIllnessSpecialContractAfterErr3 || accidentFreeBenefitSpecialContractBeforeErr3 || accidentFreeBenefitSpecialContractAfterErr3 ||
            hospitalLumpSumRiderBeforeErr3 || hospitalLumpSumRiderAfterErr3 ||
            cancerTreatyErr4 || afterCancerSpecialContractReductionErr4 || heartAttackStrokeAfterErr4 || heartAttackStrokeBeforeErr4 || hospitalSpecialContracteforeReducErr4 ||
            hospitalSpecialContractAfterReductiErr4 || beforeHospitalizationSpecialContractErr4 || afterHospitalizationSpecialContractErr4 || dischargeHospitalSpecialContractFErr4 ||
            dischargeHospitalSpecialContractAfErr4 || sevenSpecialContractFrontErr4 || sevenSpecialAfterErr4 ||
            longTermCareBnefitSpecialContractBeforeErr4 || longTermCareBnefitSpecialContractAfterErr4 || hospitalWithMentalIllnessSpecialContractBeforeErr4 ||
            hospitalWithMentalIllnessSpecialContractAfterErr4 || accidentFreeBenefitSpecialContractBeforeErr4 || accidentFreeBenefitSpecialContractAfterErr4 ||
            hospitalLumpSumRiderBeforeErr4 || hospitalLumpSumRiderAfterErr4 ||
            cancerTreatyErr5 || afterCancerSpecialContractReductionErr5 || heartAttackStrokeAfterErr5 || heartAttackStrokeBeforeErr5 || hospitalSpecialContracteforeReducErr5 ||
            hospitalSpecialContractAfterReductiErr5 || beforeHospitalizationSpecialContractErr5 || afterHospitalizationSpecialContractErr5 || dischargeHospitalSpecialContractFErr5 ||
            dischargeHospitalSpecialContractAfErr5 || sevenSpecialContractFrontErr5 || sevenSpecialAfterErr5 ||
            longTermCareBnefitSpecialContractBeforeErr5 || longTermCareBnefitSpecialContractAfterErr5 || hospitalWithMentalIllnessSpecialContractBeforeErr5 ||
            hospitalWithMentalIllnessSpecialContractAfterErr5 || accidentFreeBenefitSpecialContractBeforeErr5 || accidentFreeBenefitSpecialContractAfterErr5 ||
            hospitalLumpSumRiderBeforeErr5 || hospitalLumpSumRiderAfterErr5 ||
            cancerTreatyErr6 || afterCancerSpecialContractReductionErr6 || heartAttackStrokeAfterErr6 || heartAttackStrokeBeforeErr6 || hospitalSpecialContracteforeReducErr6 ||
            hospitalSpecialContractAfterReductiErr6 || beforeHospitalizationSpecialContractErr6 || afterHospitalizationSpecialContractErr6 || dischargeHospitalSpecialContractFErr6 ||
            dischargeHospitalSpecialContractAfErr6 || sevenSpecialContractFrontErr6 || sevenSpecialAfterErr6 ||
            longTermCareBnefitSpecialContractBeforeErr6 || longTermCareBnefitSpecialContractAfterErr6 || hospitalWithMentalIllnessSpecialContractBeforeErr6 ||
            hospitalWithMentalIllnessSpecialContractAfterErr6 || accidentFreeBenefitSpecialContractBeforeErr6 || accidentFreeBenefitSpecialContractAfterErr6 ||
            hospitalLumpSumRiderBeforeErr6 || hospitalLumpSumRiderAfterErr6 ||
            cancerTreatyErr7 || afterCancerSpecialContractReductionErr7 || heartAttackStrokeAfterErr7 || heartAttackStrokeBeforeErr7 || hospitalSpecialContracteforeReducErr7 ||
            hospitalSpecialContractAfterReductiErr7 || beforeHospitalizationSpecialContractErr7 || afterHospitalizationSpecialContractErr7 || dischargeHospitalSpecialContractFErr7 ||
            dischargeHospitalSpecialContractAfErr7 || sevenSpecialContractFrontErr7 || sevenSpecialAfterErr7 ||
            longTermCareBnefitSpecialContractBeforeErr7 || longTermCareBnefitSpecialContractAfterErr7 || hospitalWithMentalIllnessSpecialContractBeforeErr7 ||
            hospitalWithMentalIllnessSpecialContractAfterErr7 || accidentFreeBenefitSpecialContractBeforeErr7 || accidentFreeBenefitSpecialContractAfterErr7 ||
            hospitalLumpSumRiderBeforeErr7 || hospitalLumpSumRiderAfterErr7 ||
            cancerTreatyErr8 || afterCancerSpecialContractReductionErr8 || heartAttackStrokeAfterErr8 || heartAttackStrokeBeforeErr8 || hospitalSpecialContracteforeReducErr8 ||
            hospitalSpecialContractAfterReductiErr8 || beforeHospitalizationSpecialContractErr8 || afterHospitalizationSpecialContractErr8 || dischargeHospitalSpecialContractFErr8 ||
            dischargeHospitalSpecialContractAfErr8 || sevenSpecialContractFrontErr8 || sevenSpecialAfterErr8 ||
            longTermCareBnefitSpecialContractBeforeErr8 || longTermCareBnefitSpecialContractAfterErr8 || hospitalWithMentalIllnessSpecialContractBeforeErr8 ||
            hospitalWithMentalIllnessSpecialContractAfterErr8 || accidentFreeBenefitSpecialContractBeforeErr8 || accidentFreeBenefitSpecialContractAfterErr8 ||
            hospitalLumpSumRiderBeforeErr8 || hospitalLumpSumRiderAfterErr8 ||
            cancerTreatyErr9 || afterCancerSpecialContractReductionErr9 || heartAttackStrokeAfterErr9 || heartAttackStrokeBeforeErr9 || hospitalSpecialContracteforeReducErr9 ||
            hospitalSpecialContractAfterReductiErr9 || beforeHospitalizationSpecialContractErr9 || afterHospitalizationSpecialContractErr9 || dischargeHospitalSpecialContractFErr9 ||
            dischargeHospitalSpecialContractAfErr9 || sevenSpecialContractFrontErr9 || sevenSpecialAfterErr9 ||
            longTermCareBnefitSpecialContractBeforeErr9 || longTermCareBnefitSpecialContractAfterErr9 || hospitalWithMentalIllnessSpecialContractBeforeErr9 ||
            hospitalWithMentalIllnessSpecialContractAfterErr9 || accidentFreeBenefitSpecialContractBeforeErr9 || accidentFreeBenefitSpecialContractAfterErr9 ||
            hospitalLumpSumRiderBeforeErr9 || hospitalLumpSumRiderAfterErr9 ||
            cancerTreatyErr10 || afterCancerSpecialContractReductionErr10 || heartAttackStrokeAfterErr10 || heartAttackStrokeBeforeErr10 || hospitalSpecialContracteforeReducErr10 ||
            hospitalSpecialContractAfterReductiErr10 || beforeHospitalizationSpecialContractErr10 || afterHospitalizationSpecialContractErr10 || dischargeHospitalSpecialContractFErr10 ||
            dischargeHospitalSpecialContractAfErr10 || sevenSpecialContractFrontErr10 || sevenSpecialAfterErr10 ||
            longTermCareBnefitSpecialContractBeforeErr10 || longTermCareBnefitSpecialContractAfterErr10 || hospitalWithMentalIllnessSpecialContractBeforeErr10 ||
            hospitalWithMentalIllnessSpecialContractAfterErr10 || accidentFreeBenefitSpecialContractBeforeErr10 || accidentFreeBenefitSpecialContractAfterErr10 ||
            hospitalLumpSumRiderBeforeErr10 || hospitalLumpSumRiderAfterErr10

        ) {
            var events = cmp.getEvent("ReqStopSaveComponentEvent");
            events.setParams({ "param": true });
            events.fire();
        }
        else {
            var events = cmp.getEvent("ReqStopSaveComponentEvent");
            events.setParams({ "param": false });
            events.fire();
        }
    },
    init: function (component, event, helper) {
        var dependantSubject = component.get('v.dependantSubject');
        helper.getProcessingPicklist(component, event, dependantSubject);
        helper.getShippingDocumentsPicklist(component, event, dependantSubject);
        helper.getDateOfShipmentPicklist(component, event);
        helper.getShippingMethodPicklist(component, event);

        component.set("v.innerCmpNewRequest.Processing__c", '手動');
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
    handleCancerTreaty1: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.cancerTreaty1", "v.cancerTreatyErr1");
    },
    handleAftrCncrSpclConRed1: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.afterCancerSpecialContractReduction1", "v.afterCancerSpecialContractReductionErr1");
    },
    handleHeartAttackStrokeAfter1: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.heartAttackStrokeAfter1", "v.heartAttackStrokeAfterErr1");
    },
    handleHeartAttackStrokeBefore1: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.heartAttackStrokeBefore1", "v.heartAttackStrokeBeforeErr1");
    },
    handleHospitalSpclConBfrRed1: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalSpecialContracteforeReduc1", "v.hospitalSpecialContracteforeReducErr1");
    },
    handleHospitalSpclConAfrRed1: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalSpecialContractAfterReducti1", "v.hospitalSpecialContractAfterReductiErr1");
    },
    handleBeforeHospitalSpclCon1: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.beforeHospitalizationSpecialContract1", "v.beforeHospitalizationSpecialContractErr1");
    },
    handleAfterHospitalSpclCon1: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.afterHospitalizationSpecialContract1", "v.afterHospitalizationSpecialContractErr1");
    },
    handleBfrDischargeHospSpclCon1: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.dischargeHospitalSpecialContractF1", "v.dischargeHospitalSpecialContractFErr1");
    },
    handleAfrDischargeHospSpclCon1: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.dischargeHospitalSpecialContractAf1", "v.dischargeHospitalSpecialContractAfErr1");
    },
    handleSevenSpecialContractFront1: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.sevenSpecialContractFront1", "v.sevenSpecialContractFrontErr1");
    },
    handleSevenSpecialAfter1: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.sevenSpecialAfter1", "v.sevenSpecialAfterErr1");
    },
    handleLongTermCareBnefitSpecialContractBefore1: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.longTermCareBnefitSpecialContractBefore1", "v.longTermCareBnefitSpecialContractBeforeErr1");
    },
    handleLongTermCareBnefitSpecialContractAfter1: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.longTermCareBnefitSpecialContractAfter1", "v.longTermCareBnefitSpecialContractAfterErr1");
    },
    handleHospitalWithMentalIllnessSpecialContractBefore1: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalWithMentalIllnessSpecialContractBefore1", "v.hospitalWithMentalIllnessSpecialContractBeforeErr1");
    },
    handleHospitalWithMentalIllnessSpecialContractAfter1: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalWithMentalIllnessSpecialContractAfter1", "v.hospitalWithMentalIllnessSpecialContractAfterErr1");
    },
    handleAccidentFreeBenefitSpecialContractBefore1: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.accidentFreeBenefitSpecialContractBefore1", "v.accidentFreeBenefitSpecialContractBeforeErr1");
    },
    handleAccidentFreeBenefitSpecialContractAfter1: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.accidentFreeBenefitSpecialContractAfter1", "v.accidentFreeBenefitSpecialContractAfterErr1");
    },
    handleHospitalLumpSumRiderBefore1: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalLumpSumRiderBefore1", "v.hospitalLumpSumRiderBeforeErr1");
    },
    handleHospitalLumpSumRiderAfter1: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalLumpSumRiderAfter1", "v.hospitalLumpSumRiderAfterErr1");
    },
    handleCancerTreaty2: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.cancerTreaty2", "v.cancerTreatyErr2");
    },
    handleAftrCncrSpclConRed2: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.afterCancerSpecialContractReduction2", "v.afterCancerSpecialContractReductionErr2");
    },
    handleHeartAttackStrokeAfter2: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.heartAttackStrokeAfter2", "v.heartAttackStrokeAfterErr2");
    },
    handleHeartAttackStrokeBefore2: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.heartAttackStrokeBefore2", "v.heartAttackStrokeBeforeErr2");
    },
    handleHospitalSpclConBfrRed2: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalSpecialContracteforeReduc2", "v.hospitalSpecialContracteforeReducErr2");
    },
    handleHospitalSpclConAfrRed2: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalSpecialContractAfterReducti2", "v.hospitalSpecialContractAfterReductiErr2");
    },
    handleBeforeHospitalSpclCon2: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.beforeHospitalizationSpecialContract2", "v.beforeHospitalizationSpecialContractErr2");
    },
    handleAfterHospitalSpclCon2: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.afterHospitalizationSpecialContract2", "v.afterHospitalizationSpecialContractErr2");
    },
    handleBfrDischargeHospSpclCon2: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.dischargeHospitalSpecialContractF2", "v.dischargeHospitalSpecialContractFErr2");
    },
    handleAfrDischargeHospSpclCon2: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.dischargeHospitalSpecialContractAf2", "v.dischargeHospitalSpecialContractAfErr2");
    },
    handleSevenSpecialContractFront2: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.sevenSpecialContractFront2", "v.sevenSpecialContractFrontErr2");
    },
    handleSevenSpecialAfter2: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.sevenSpecialAfter2", "v.sevenSpecialAfterErr2");
    },
    handleLongTermCareBnefitSpecialContractBefore2: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.longTermCareBnefitSpecialContractBefore2", "v.longTermCareBnefitSpecialContractBeforeErr2");
    },
    handleLongTermCareBnefitSpecialContractAfter2: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.longTermCareBnefitSpecialContractAfter2", "v.longTermCareBnefitSpecialContractAfterErr2");
    },
    handleHospitalWithMentalIllnessSpecialContractBefore2: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalWithMentalIllnessSpecialContractBefore2", "v.hospitalWithMentalIllnessSpecialContractBeforeErr2");
    },
    handleHospitalWithMentalIllnessSpecialContractAfter2: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalWithMentalIllnessSpecialContractAfter2", "v.hospitalWithMentalIllnessSpecialContractAfterErr2");
    },
    handleAccidentFreeBenefitSpecialContractBefore2: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.accidentFreeBenefitSpecialContractBefore2", "v.accidentFreeBenefitSpecialContractBeforeErr2");
    },
    handleAccidentFreeBenefitSpecialContractAfter2: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.accidentFreeBenefitSpecialContractAfter2", "v.accidentFreeBenefitSpecialContractAfterErr2");
    },
    handleHospitalLumpSumRiderBefore2: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalLumpSumRiderBefore2", "v.hospitalLumpSumRiderBeforeErr2");
    },
    handleHospitalLumpSumRiderAfter2: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalLumpSumRiderAfter2", "v.hospitalLumpSumRiderAfterErr2");
    },
    handleCancerTreaty3: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.cancerTreaty3", "v.cancerTreatyErr3");
    },
    handleAftrCncrSpclConRed3: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.afterCancerSpecialContractReduction3", "v.afterCancerSpecialContractReductionErr3");
    },
    handleHeartAttackStrokeAfter3: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.heartAttackStrokeAfter3", "v.heartAttackStrokeAfterErr3");
    },
    handleHeartAttackStrokeBefore3: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.heartAttackStrokeBefore3", "v.heartAttackStrokeBeforeErr3");
    },
    handleHospitalSpclConBfrRed3: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalSpecialContracteforeReduc3", "v.hospitalSpecialContracteforeReducErr3");
    },
    handleHospitalSpclConAfrRed3: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalSpecialContractAfterReducti3", "v.hospitalSpecialContractAfterReductiErr3");
    },
    handleBeforeHospitalSpclCon3: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.beforeHospitalizationSpecialContract3", "v.beforeHospitalizationSpecialContractErr3");
    },
    handleAfterHospitalSpclCon3: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.afterHospitalizationSpecialContract3", "v.afterHospitalizationSpecialContractErr3");
    },
    handleBfrDischargeHospSpclCon3: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.dischargeHospitalSpecialContractF3", "v.dischargeHospitalSpecialContractFErr3");
    },
    handleAfrDischargeHospSpclCon3: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.dischargeHospitalSpecialContractAf3", "v.dischargeHospitalSpecialContractAfErr3");
    },
    handleSevenSpecialContractFront3: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.sevenSpecialContractFront3", "v.sevenSpecialContractFrontErr3");
    },
    handleSevenSpecialAfter3: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.sevenSpecialAfter3", "v.sevenSpecialAfterErr3");
    },
    handleLongTermCareBnefitSpecialContractBefore3: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.longTermCareBnefitSpecialContractBefore3", "v.longTermCareBnefitSpecialContractBeforeErr3");
    },
    handleLongTermCareBnefitSpecialContractAfter3: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.longTermCareBnefitSpecialContractAfter3", "v.longTermCareBnefitSpecialContractAfterErr3");
    },
    handleHospitalWithMentalIllnessSpecialContractBefore3: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalWithMentalIllnessSpecialContractBefore3", "v.hospitalWithMentalIllnessSpecialContractBeforeErr3");
    },
    handleHospitalWithMentalIllnessSpecialContractAfter3: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalWithMentalIllnessSpecialContractAfter3", "v.hospitalWithMentalIllnessSpecialContractAfterErr3");
    },
    handleAccidentFreeBenefitSpecialContractBefore3: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.accidentFreeBenefitSpecialContractBefore3", "v.accidentFreeBenefitSpecialContractBeforeErr3");
    },
    handleAccidentFreeBenefitSpecialContractAfter3: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.accidentFreeBenefitSpecialContractAfter3", "v.accidentFreeBenefitSpecialContractAfterErr3");
    },
    handleHospitalLumpSumRiderBefore3: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalLumpSumRiderBefore3", "v.hospitalLumpSumRiderBeforeErr3");
    },
    handleHospitalLumpSumRiderAfter3: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalLumpSumRiderAfter3", "v.hospitalLumpSumRiderAfterErr3");
    },
    handleCancerTreaty4: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.cancerTreaty4", "v.cancerTreatyErr4");
    },
    handleAftrCncrSpclConRed4: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.afterCancerSpecialContractReduction4", "v.afterCancerSpecialContractReductionErr4");
    },
    handleHeartAttackStrokeAfter4: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.heartAttackStrokeAfter4", "v.heartAttackStrokeAfterErr4");
    },
    handleHeartAttackStrokeBefore4: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.heartAttackStrokeBefore4", "v.heartAttackStrokeBeforeErr4");
    },
    handleHospitalSpclConBfrRed4: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalSpecialContracteforeReduc4", "v.hospitalSpecialContracteforeReducErr4");
    },
    handleHospitalSpclConAfrRed4: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalSpecialContractAfterReducti4", "v.hospitalSpecialContractAfterReductiErr4");
    },
    handleBeforeHospitalSpclCon4: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.beforeHospitalizationSpecialContract4", "v.beforeHospitalizationSpecialContractErr4");
    },
    handleAfterHospitalSpclCon4: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.afterHospitalizationSpecialContract4", "v.afterHospitalizationSpecialContractErr4");
    },
    handleBfrDischargeHospSpclCon4: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.dischargeHospitalSpecialContractF4", "v.dischargeHospitalSpecialContractFErr4");
    },
    handleAfrDischargeHospSpclCon4: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.dischargeHospitalSpecialContractAf4", "v.dischargeHospitalSpecialContractAfErr4");
    },
    handleSevenSpecialContractFront4: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.sevenSpecialContractFront4", "v.sevenSpecialContractFrontErr4");
    },
    handleSevenSpecialAfter4: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.sevenSpecialAfter4", "v.sevenSpecialAfterErr4");
    },
    handleLongTermCareBnefitSpecialContractBefore4: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.longTermCareBnefitSpecialContractBefore4", "v.longTermCareBnefitSpecialContractBeforeErr4");
    },
    handleLongTermCareBnefitSpecialContractAfter4: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.longTermCareBnefitSpecialContractAfter4", "v.longTermCareBnefitSpecialContractAfterErr4");
    },
    handleHospitalWithMentalIllnessSpecialContractBefore4: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalWithMentalIllnessSpecialContractBefore4", "v.hospitalWithMentalIllnessSpecialContractBeforeErr4");
    },
    handleHospitalWithMentalIllnessSpecialContractAfter4: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalWithMentalIllnessSpecialContractAfter4", "v.hospitalWithMentalIllnessSpecialContractAfterErr4");
    },
    handleAccidentFreeBenefitSpecialContractBefore4: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.accidentFreeBenefitSpecialContractBefore4", "v.accidentFreeBenefitSpecialContractBeforeErr4");
    },
    handleAccidentFreeBenefitSpecialContractAfter4: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.accidentFreeBenefitSpecialContractAfter4", "v.accidentFreeBenefitSpecialContractAfterErr4");
    },
    handleHospitalLumpSumRiderBefore4: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalLumpSumRiderBefore4", "v.hospitalLumpSumRiderBeforeErr4");
    },
    handleHospitalLumpSumRiderAfter4: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalLumpSumRiderAfter4", "v.hospitalLumpSumRiderAfterErr4");
    },
    handleCancerTreaty5: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.cancerTreaty5", "v.cancerTreatyErr5");
    },
    handleAftrCncrSpclConRed5: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.afterCancerSpecialContractReduction5", "v.afterCancerSpecialContractReductionErr5");
    },
    handleHeartAttackStrokeAfter5: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.heartAttackStrokeAfter5", "v.heartAttackStrokeAfterErr5");
    },
    handleHeartAttackStrokeBefore5: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.heartAttackStrokeBefore5", "v.heartAttackStrokeBeforeErr5");
    },
    handleHospitalSpclConBfrRed5: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalSpecialContracteforeReduc5", "v.hospitalSpecialContracteforeReducErr5");
    },
    handleHospitalSpclConAfrRed5: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalSpecialContractAfterReducti5", "v.hospitalSpecialContractAfterReductiErr5");
    },
    handleBeforeHospitalSpclCon5: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.beforeHospitalizationSpecialContract5", "v.beforeHospitalizationSpecialContractErr5");
    },
    handleAfterHospitalSpclCon5: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.afterHospitalizationSpecialContract5", "v.afterHospitalizationSpecialContractErr5");
    },
    handleBfrDischargeHospSpclCon5: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.dischargeHospitalSpecialContractF5", "v.dischargeHospitalSpecialContractFErr5");
    },
    handleAfrDischargeHospSpclCon5: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.dischargeHospitalSpecialContractAf5", "v.dischargeHospitalSpecialContractAfErr5");
    },
    handleSevenSpecialContractFront5: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.sevenSpecialContractFront5", "v.sevenSpecialContractFrontErr5");
    },
    handleSevenSpecialAfter5: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.sevenSpecialAfter5", "v.sevenSpecialAfterErr5");
    },
    handleLongTermCareBnefitSpecialContractBefore5: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.longTermCareBnefitSpecialContractBefore5", "v.longTermCareBnefitSpecialContractBeforeErr5");
    },
    handleLongTermCareBnefitSpecialContractAfter5: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.longTermCareBnefitSpecialContractAfter5", "v.longTermCareBnefitSpecialContractAfterErr5");
    },
    handleHospitalWithMentalIllnessSpecialContractBefore5: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalWithMentalIllnessSpecialContractBefore5", "v.hospitalWithMentalIllnessSpecialContractBeforeErr5");
    },
    handleHospitalWithMentalIllnessSpecialContractAfter5: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalWithMentalIllnessSpecialContractAfter5", "v.hospitalWithMentalIllnessSpecialContractAfterErr5");
    },
    handleAccidentFreeBenefitSpecialContractBefore5: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.accidentFreeBenefitSpecialContractBefore5", "v.accidentFreeBenefitSpecialContractBeforeErr5");
    },
    handleAccidentFreeBenefitSpecialContractAfter5: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.accidentFreeBenefitSpecialContractAfter5", "v.accidentFreeBenefitSpecialContractAfterErr5");
    },
    handleHospitalLumpSumRiderBefore5: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalLumpSumRiderBefore5", "v.hospitalLumpSumRiderBeforeErr5");
    },
    handleHospitalLumpSumRiderAfter5: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalLumpSumRiderAfter5", "v.hospitalLumpSumRiderAfterErr5");
    },
    handleCancerTreaty6: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.cancerTreaty6", "v.cancerTreatyErr6");
    },
    handleAftrCncrSpclConRed6: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.afterCancerSpecialContractReduction6", "v.afterCancerSpecialContractReductionErr6");
    },
    handleHeartAttackStrokeAfter6: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.heartAttackStrokeAfter6", "v.heartAttackStrokeAfterErr6");
    },
    handleHeartAttackStrokeBefore6: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.heartAttackStrokeBefore6", "v.heartAttackStrokeBeforeErr6");
    },
    handleHospitalSpclConBfrRed6: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalSpecialContracteforeReduc6", "v.hospitalSpecialContracteforeReducErr6");
    },
    handleHospitalSpclConAfrRed6: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalSpecialContractAfterReducti6", "v.hospitalSpecialContractAfterReductiErr6");
    },
    handleBeforeHospitalSpclCon6: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.beforeHospitalizationSpecialContract6", "v.beforeHospitalizationSpecialContractErr6");
    },
    handleAfterHospitalSpclCon6: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.afterHospitalizationSpecialContract6", "v.afterHospitalizationSpecialContractErr6");
    },
    handleBfrDischargeHospSpclCon6: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.dischargeHospitalSpecialContractF6", "v.dischargeHospitalSpecialContractFErr6");
    },
    handleAfrDischargeHospSpclCon6: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.dischargeHospitalSpecialContractAf6", "v.dischargeHospitalSpecialContractAfErr6");
    },
    handleSevenSpecialContractFront6: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.sevenSpecialContractFront6", "v.sevenSpecialContractFrontErr6");
    },
    handleSevenSpecialAfter6: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.sevenSpecialAfter6", "v.sevenSpecialAfterErr6");
    },
    handleLongTermCareBnefitSpecialContractBefore6: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.longTermCareBnefitSpecialContractBefore6", "v.longTermCareBnefitSpecialContractBeforeErr6");
    },
    handleLongTermCareBnefitSpecialContractAfter6: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.longTermCareBnefitSpecialContractAfter6", "v.longTermCareBnefitSpecialContractAfterErr6");
    },
    handleHospitalWithMentalIllnessSpecialContractBefore6: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalWithMentalIllnessSpecialContractBefore6", "v.hospitalWithMentalIllnessSpecialContractBeforeErr6");
    },
    handleHospitalWithMentalIllnessSpecialContractAfter6: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalWithMentalIllnessSpecialContractAfter6", "v.hospitalWithMentalIllnessSpecialContractAfterErr6");
    },
    handleAccidentFreeBenefitSpecialContractBefore6: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.accidentFreeBenefitSpecialContractBefore6", "v.accidentFreeBenefitSpecialContractBeforeErr6");
    },
    handleAccidentFreeBenefitSpecialContractAfter6: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.accidentFreeBenefitSpecialContractAfter6", "v.accidentFreeBenefitSpecialContractAfterErr6");
    },
    handleHospitalLumpSumRiderBefore6: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalLumpSumRiderBefore6", "v.hospitalLumpSumRiderBeforeErr6");
    },
    handleHospitalLumpSumRiderAfter6: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalLumpSumRiderAfter6", "v.hospitalLumpSumRiderAfterErr6");
    },
    handleCancerTreaty7: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.cancerTreaty7", "v.cancerTreatyErr7");
    },
    handleAftrCncrSpclConRed7: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.afterCancerSpecialContractReduction7", "v.afterCancerSpecialContractReductionErr7");
    },
    handleHeartAttackStrokeAfter7: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.heartAttackStrokeAfter7", "v.heartAttackStrokeAfterErr7");
    },
    handleHeartAttackStrokeBefore7: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.heartAttackStrokeBefore7", "v.heartAttackStrokeBeforeErr7");
    },
    handleHospitalSpclConBfrRed7: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalSpecialContracteforeReduc7", "v.hospitalSpecialContracteforeReducErr7");
    },
    handleHospitalSpclConAfrRed7: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalSpecialContractAfterReducti7", "v.hospitalSpecialContractAfterReductiErr7");
    },
    handleBeforeHospitalSpclCon7: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.beforeHospitalizationSpecialContract7", "v.beforeHospitalizationSpecialContractErr7");
    },
    handleAfterHospitalSpclCon7: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.afterHospitalizationSpecialContract7", "v.afterHospitalizationSpecialContractErr7");
    },
    handleBfrDischargeHospSpclCon7: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.dischargeHospitalSpecialContractF7", "v.dischargeHospitalSpecialContractFErr7");
    },
    handleAfrDischargeHospSpclCon7: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.dischargeHospitalSpecialContractAf7", "v.dischargeHospitalSpecialContractAfErr7");
    },
    handleSevenSpecialContractFront7: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.sevenSpecialContractFront7", "v.sevenSpecialContractFrontErr7");
    },
    handleSevenSpecialAfter7: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.sevenSpecialAfter7", "v.sevenSpecialAfterErr7");
    },
    handleLongTermCareBnefitSpecialContractBefore7: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.longTermCareBnefitSpecialContractBefore7", "v.longTermCareBnefitSpecialContractBeforeErr7");
    },
    handleLongTermCareBnefitSpecialContractAfter7: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.longTermCareBnefitSpecialContractAfter7", "v.longTermCareBnefitSpecialContractAfterErr7");
    },
    handleHospitalWithMentalIllnessSpecialContractBefore7: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalWithMentalIllnessSpecialContractBefore7", "v.hospitalWithMentalIllnessSpecialContractBeforeErr7");
    },
    handleHospitalWithMentalIllnessSpecialContractAfter7: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalWithMentalIllnessSpecialContractAfter7", "v.hospitalWithMentalIllnessSpecialContractAfterErr7");
    },
    handleAccidentFreeBenefitSpecialContractBefore7: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.accidentFreeBenefitSpecialContractBefore7", "v.accidentFreeBenefitSpecialContractBeforeErr7");
    },
    handleAccidentFreeBenefitSpecialContractAfter7: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.accidentFreeBenefitSpecialContractAfter7", "v.accidentFreeBenefitSpecialContractAfterErr7");
    },
    handleHospitalLumpSumRiderBefore7: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalLumpSumRiderBefore7", "v.hospitalLumpSumRiderBeforeErr7");
    },
    handleHospitalLumpSumRiderAfter7: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalLumpSumRiderAfter7", "v.hospitalLumpSumRiderAfterErr7");
    },
    handleCancerTreaty8: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.cancerTreaty8", "v.cancerTreatyErr8");
    },
    handleAftrCncrSpclConRed8: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.afterCancerSpecialContractReduction8", "v.afterCancerSpecialContractReductionErr8");
    },
    handleHeartAttackStrokeAfter8: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.heartAttackStrokeAfter8", "v.heartAttackStrokeAfterErr8");
    },
    handleHeartAttackStrokeBefore8: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.heartAttackStrokeBefore8", "v.heartAttackStrokeBeforeErr8");
    },
    handleHospitalSpclConBfrRed8: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalSpecialContracteforeReduc8", "v.hospitalSpecialContracteforeReducErr8");
    },
    handleHospitalSpclConAfrRed8: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalSpecialContractAfterReducti8", "v.hospitalSpecialContractAfterReductiErr8");
    },
    handleBeforeHospitalSpclCon8: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.beforeHospitalizationSpecialContract8", "v.beforeHospitalizationSpecialContractErr8");
    },
    handleAfterHospitalSpclCon8: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.afterHospitalizationSpecialContract8", "v.afterHospitalizationSpecialContractErr8");
    },
    handleBfrDischargeHospSpclCon8: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.dischargeHospitalSpecialContractF8", "v.dischargeHospitalSpecialContractFErr8");
    },
    handleAfrDischargeHospSpclCon8: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.dischargeHospitalSpecialContractAf8", "v.dischargeHospitalSpecialContractAfErr8");
    },
    handleSevenSpecialContractFront8: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.sevenSpecialContractFront8", "v.sevenSpecialContractFrontErr8");
    },
    handleSevenSpecialAfter8: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.sevenSpecialAfter8", "v.sevenSpecialAfterErr8");
    },
    handleLongTermCareBnefitSpecialContractBefore8: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.longTermCareBnefitSpecialContractBefore8", "v.longTermCareBnefitSpecialContractBeforeErr8");
    },
    handleLongTermCareBnefitSpecialContractAfter8: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.longTermCareBnefitSpecialContractAfter8", "v.longTermCareBnefitSpecialContractAfterErr8");
    },
    handleHospitalWithMentalIllnessSpecialContractBefore8: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalWithMentalIllnessSpecialContractBefore8", "v.hospitalWithMentalIllnessSpecialContractBeforeErr8");
    },
    handleHospitalWithMentalIllnessSpecialContractAfter8: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalWithMentalIllnessSpecialContractAfter8", "v.hospitalWithMentalIllnessSpecialContractAfterErr8");
    },
    handleAccidentFreeBenefitSpecialContractBefore8: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.accidentFreeBenefitSpecialContractBefore8", "v.accidentFreeBenefitSpecialContractBeforeErr8");
    },
    handleAccidentFreeBenefitSpecialContractAfter8: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.accidentFreeBenefitSpecialContractAfter8", "v.accidentFreeBenefitSpecialContractAfterErr8");
    },
    handleHospitalLumpSumRiderBefore8: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalLumpSumRiderBefore8", "v.hospitalLumpSumRiderBeforeErr8");
    },
    handleHospitalLumpSumRiderAfter8: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalLumpSumRiderAfter8", "v.hospitalLumpSumRiderAfterErr8");
    },
    handleCancerTreaty9: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.cancerTreaty9", "v.cancerTreatyErr9");
    },
    handleAftrCncrSpclConRed9: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.afterCancerSpecialContractReduction9", "v.afterCancerSpecialContractReductionErr9");
    },
    handleHeartAttackStrokeAfter9: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.heartAttackStrokeAfter9", "v.heartAttackStrokeAfterErr9");
    },
    handleHeartAttackStrokeBefore9: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.heartAttackStrokeBefore9", "v.heartAttackStrokeBeforeErr9");
    },
    handleHospitalSpclConBfrRed9: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalSpecialContracteforeReduc9", "v.hospitalSpecialContracteforeReducErr9");
    },
    handleHospitalSpclConAfrRed9: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalSpecialContractAfterReducti9", "v.hospitalSpecialContractAfterReductiErr9");
    },
    handleBeforeHospitalSpclCon9: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.beforeHospitalizationSpecialContract9", "v.beforeHospitalizationSpecialContractErr9");
    },
    handleAfterHospitalSpclCon9: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.afterHospitalizationSpecialContract9", "v.afterHospitalizationSpecialContractErr9");
    },
    handleBfrDischargeHospSpclCon9: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.dischargeHospitalSpecialContractF9", "v.dischargeHospitalSpecialContractFErr9");
    },
    handleAfrDischargeHospSpclCon9: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.dischargeHospitalSpecialContractAf9", "v.dischargeHospitalSpecialContractAfErr9");
    },
    handleSevenSpecialContractFront9: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.sevenSpecialContractFront9", "v.sevenSpecialContractFrontErr9");
    },
    handleSevenSpecialAfter9: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.sevenSpecialAfter9", "v.sevenSpecialAfterErr9");
    },
    handleLongTermCareBnefitSpecialContractBefore9: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.longTermCareBnefitSpecialContractBefore9", "v.longTermCareBnefitSpecialContractBeforeErr9");
    },
    handleLongTermCareBnefitSpecialContractAfter9: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.longTermCareBnefitSpecialContractAfter9", "v.longTermCareBnefitSpecialContractAfterErr9");
    },
    handleHospitalWithMentalIllnessSpecialContractBefore9: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalWithMentalIllnessSpecialContractBefore9", "v.hospitalWithMentalIllnessSpecialContractBeforeErr9");
    },
    handleHospitalWithMentalIllnessSpecialContractAfter9: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalWithMentalIllnessSpecialContractAfter9", "v.hospitalWithMentalIllnessSpecialContractAfterErr9");
    },
    handleAccidentFreeBenefitSpecialContractBefore9: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.accidentFreeBenefitSpecialContractBefore9", "v.accidentFreeBenefitSpecialContractBeforeErr9");
    },
    handleAccidentFreeBenefitSpecialContractAfter9: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.accidentFreeBenefitSpecialContractAfter9", "v.accidentFreeBenefitSpecialContractAfterErr9");
    },
    handleHospitalLumpSumRiderBefore9: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalLumpSumRiderBefore9", "v.hospitalLumpSumRiderBeforeErr9");
    },
    handleHospitalLumpSumRiderAfter9: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalLumpSumRiderAfter9", "v.hospitalLumpSumRiderAfterErr9");
    },
    handleCancerTreaty10: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.cancerTreaty10", "v.cancerTreatyErr10");
    },
    handleAftrCncrSpclConRed10: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.afterCancerSpecialContractReduction10", "v.afterCancerSpecialContractReductionErr10");
    },
    handleHeartAttackStrokeAfter10: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.heartAttackStrokeAfter10", "v.heartAttackStrokeAfterErr10");
    },
    handleHeartAttackStrokeBefore10: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.heartAttackStrokeBefore10", "v.heartAttackStrokeBeforeErr10");
    },
    handleHospitalSpclConBfrRed10: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalSpecialContracteforeReduc10", "v.hospitalSpecialContracteforeReducErr10");
    },
    handleHospitalSpclConAfrRed10: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalSpecialContractAfterReducti10", "v.hospitalSpecialContractAfterReductiErr10");
    },
    handleBeforeHospitalSpclCon10: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.beforeHospitalizationSpecialContract10", "v.beforeHospitalizationSpecialContractErr10");
    },
    handleAfterHospitalSpclCon10: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.afterHospitalizationSpecialContract10", "v.afterHospitalizationSpecialContractErr10");
    },
    handleBfrDischargeHospSpclCon10: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.dischargeHospitalSpecialContractF10", "v.dischargeHospitalSpecialContractFErr10");
    },
    handleAfrDischargeHospSpclCon10: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.dischargeHospitalSpecialContractAf10", "v.dischargeHospitalSpecialContractAfErr10");
    },
    handleSevenSpecialContractFront10: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.sevenSpecialContractFront10", "v.sevenSpecialContractFrontErr10");
    },
    handleSevenSpecialAfter10: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.sevenSpecialAfter10", "v.sevenSpecialAfterErr10");
    },
    handleLongTermCareBnefitSpecialContractBefore10: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.longTermCareBnefitSpecialContractBefore10", "v.longTermCareBnefitSpecialContractBeforeErr10");
    },
    handleLongTermCareBnefitSpecialContractAfter10: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.longTermCareBnefitSpecialContractAfter10", "v.longTermCareBnefitSpecialContractAfterErr10");
    },
    handleHospitalWithMentalIllnessSpecialContractBefore10: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalWithMentalIllnessSpecialContractBefore10", "v.hospitalWithMentalIllnessSpecialContractBeforeErr10");
    },
    handleHospitalWithMentalIllnessSpecialContractAfter10: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalWithMentalIllnessSpecialContractAfter10", "v.hospitalWithMentalIllnessSpecialContractAfterErr10");
    },
    handleAccidentFreeBenefitSpecialContractBefore10: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.accidentFreeBenefitSpecialContractBefore10", "v.accidentFreeBenefitSpecialContractBeforeErr10");
    },
    handleAccidentFreeBenefitSpecialContractAfter10: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.accidentFreeBenefitSpecialContractAfter10", "v.accidentFreeBenefitSpecialContractAfterErr10");
    },
    handleHospitalLumpSumRiderBefore10: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalLumpSumRiderBefore10", "v.hospitalLumpSumRiderBeforeErr10");
    },
    handleHospitalLumpSumRiderAfter10: function (component, event, helper) {
        helper.getSingleByteNumberCheck(component, event, "v.hospitalLumpSumRiderAfter10", "v.hospitalLumpSumRiderAfterErr10");
    },
	handleNoOfCopies : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.numberOfCopies","v.noOfCopiesErr");
    }
})