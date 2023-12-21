({
	saveInlineInsuredPersonChangeCmp : function(cmp, event, helper) {
		var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;
        if(cmp.get("v.getAutoAreaInfoMap").prefecture != ''){
            obj.CarPrefectureOfTheInsuredAfterChange__c = cmp.get("v.getAutoAreaInfoMap").prefecture;
        }
        if(cmp.get("v.getAutoAreaInfoMap").municipality != ''){
            obj.AutoInsuredCityAfterChange__c = cmp.get("v.getAutoAreaInfoMap").municipality;
        }
        if(cmp.get("v.getAutoAreaInfoMap").chome != ''){  
            obj.AutoInsuredPersonsAddressAfterChange1__c = cmp.get("v.getAutoAreaInfoMap").chome;
        }
        if(cmp.get("v.getOtherAreaInfoMap").prefecture != ''){  
            obj.OtherPrefectureOfInsuredAfterChange__c = cmp.get("v.getOtherAreaInfoMap").prefecture;
        }
        if(cmp.get("v.getOtherAreaInfoMap").municipality != ''){  
            obj.OtherInsuredCityAfterChange__c = cmp.get("v.getOtherAreaInfoMap").municipality;
        }
        if(cmp.get("v.getOtherAreaInfoMap").chome != ''){  
            obj.OtherInsuredPersonAddressAfterChange1__c = cmp.get("v.getOtherAreaInfoMap").chome;
        }
        

        obj.AutoChangeDate__c=cmp.get("v.innerCmpNewRequest").AutoChangeDate__c;
		obj.AutoInsuredAfterChange__c=cmp.get("v.innerCmpNewRequest").AutoInsuredAfterChange__c;
		obj.AutoInsuredPersonNameAfterChangeKana__c=cmp.get("v.innerCmpNewRequest").AutoInsuredPersonNameAfterChangeKana__c;
		obj.AutoInsuredPersonNameAfterChangeKanji__c=cmp.get("v.innerCmpNewRequest").AutoInsuredPersonNameAfterChangeKanji__c;
		obj.AutoInsuredPersonBirthAfterChange__c=cmp.get("v.innerCmpNewRequest").AutoInsuredPersonBirthAfterChange__c;
		obj.AutoGenderOfInsuredAfterChange__c=cmp.get("v.innerCmpNewRequest").AutoGenderOfInsuredAfterChange__c;
		obj.ReflectTheAddressOfTheInsuredPerson__c=cmp.get("v.innerCmpNewRequest").ReflectTheAddressOfTheInsuredPerson__c;
		obj.AutoInsuredPostalCodeAfterChange__c=cmp.get("v.innerCmpNewRequest").AutoInsuredPostalCodeAfterChange__c;
		obj.AutoInsuredBuildingNameAfterChange__c=cmp.get("v.innerCmpNewRequest").AutoInsuredBuildingNameAfterChange__c;
		obj.InsuredPersonsLicenseColorAfterChange__c=cmp.get("v.innerCmpNewRequest").InsuredPersonsLicenseColorAfterChange__c;
		obj.RelationshipInsuredPersonBeforeChange__c=cmp.get("v.innerCmpNewRequest").RelationshipInsuredPersonBeforeChange__c;
		obj.AdRelationshipInsuredPersonBefChange__c=cmp.get("v.innerCmpNewRequest").AdRelationshipInsuredPersonBefChange__c;
		obj.CarDriverAgeConditionChange__c=cmp.get("v.innerCmpNewRequest").CarDriverAgeConditionChange__c;
		obj.ChangeOfAutoDriverLimitedCategory__c=cmp.get("v.innerCmpNewRequest").ChangeOfAutoDriverLimitedCategory__c;
		obj.CarOtherInformation__c=cmp.get("v.innerCmpNewRequest").CarOtherInformation__c;
		obj.OtherChangeDate__c=cmp.get("v.innerCmpNewRequest").OtherChangeDate__c;
		obj.OtherInsuredPersonAfterChange__c=cmp.get("v.innerCmpNewRequest").OtherInsuredPersonAfterChange__c;
		obj.OtherNameInsuredPersonAfterChangeKana__c=cmp.get("v.innerCmpNewRequest").OtherNameInsuredPersonAfterChangeKana__c;
		obj.OtherInsuredPersonNameAfterChangeKnj__c=cmp.get("v.innerCmpNewRequest").OtherInsuredPersonNameAfterChangeKnj__c;
		obj.OtherInsuredPersonBirthAfterChange__c=cmp.get("v.innerCmpNewRequest").OtherInsuredPersonBirthAfterChange__c;
		obj.OtherGenderOfInsuredAfterChange__c=cmp.get("v.innerCmpNewRequest").OtherGenderOfInsuredAfterChange__c;
		obj.OtherPostCodeInsuredPersonAfterChange__c=cmp.get("v.innerCmpNewRequest").OtherPostCodeInsuredPersonAfterChange__c;
		obj.OtherInsuredPersonAddressAfterChange2__c=cmp.get("v.innerCmpNewRequest").OtherInsuredPersonAddressAfterChange2__c;
		obj.OtherReflectAdresPersonAfterChange__c=cmp.get("v.innerCmpNewRequest").OtherReflectAdresPersonAfterChange__c;
		obj.OtherRelationshipInsuredBeforeChange__c=cmp.get("v.innerCmpNewRequest").OtherRelationshipInsuredBeforeChange__c;
		obj.AddOtherRelationshipInsuredBefoChange__c=cmp.get("v.innerCmpNewRequest").AddOtherRelationshipInsuredBefoChange__c;
		obj.OtherOtherInformation__c=cmp.get("v.innerCmpNewRequest").OtherOtherInformation__c;		
		
	},
    handleAutoAreaInfo : function(cmp,event,helper){
        helper.areaInfo(cmp, event,'v.getAutoAreaInfoMap');
    },
    handleOtherAreaInfo : function(cmp,event,helper){
        helper.areaInfo(cmp, event,'v.getOtherAreaInfoMap');
    },
    init : function(component,event,helper){
        helper.getautoInsuredAfterChangePicklist(component, event);
		helper.getautoGenderOfInsuredAfterChangePicklist(component, event);
		helper.getinsurPersonsLicenseColorAftChngPicklist(component, event);
		helper.getrelatshpInsPersonBeforeChnPicklist(component, event);
		helper.getcarDriverAgeConditionChngPicklist(component, event);
		helper.getchngOfAutoDriverLtdCatgryPicklist(component, event);
		helper.getotherInsuredPersonAfterChangePicklist(component, event);
		helper.getotherGenOfInsAfrChngPicklist(component, event);
		helper.getotherRelatnInsBefChngPicklist(component, event);
    }
})