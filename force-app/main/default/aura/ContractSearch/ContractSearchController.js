({
	doInit: function(component, event, helper) {

	},
	doSearch: function(component, event, helper) {

		var toastEvent = $A.get("e.force:showToast");

		// 入力なしチェック
        var insuraPolicyNo = component.find("insuraPolicyNo").get("v.value")
		var applicationNumber = component.find("applicationNumber").get("v.value")
		var insuraType = component.find("insuraType").get("v.value");
		var name = component.find("name").get("v.value");
		var status = component.find("status").get("v.value");
		var contractTerm = component.find("contractTerm").get("v.value");
		var CSID = component.find("CSID").get("v.value");
		var contractorNameKana = component.find("contractorNameKana").get("v.value");
		var contractorNameKanji = component.find("contractorNameKanji").get("v.value");
		var subscriberDateOfBirth = component.find("subscriberDateOfBirth").get("v.value");
		var phone = component.find("phone").get("v.value");
		var postalCode = component.find("postalCode").get("v.value");
		var insuredNameKana = component.find("insuredNameKana").get("v.value");
		var insuredNameKanji = component.find("insuredNameKanji").get("v.value");
		var insuredBirthdate = component.find("insuredBirthdate").get("v.value");
		var insuredBody = component.find("insuredBody").get("v.value");
		var carNo = component.find("carNo").get("v.value");
		var agencyCode = component.find("agencyCode").get("v.value");
		var agency = component.find("agency").get("v.value");

        if(!insuraPolicyNo
        && !applicationNumber
        && !insuraType
        && !name
        && !status
        && !contractTerm
        && !CSID
        && !contractorNameKana
        && !contractorNameKanji
        && !subscriberDateOfBirth
        && !phone
        && !postalCode
        && !insuredNameKana
        && !insuredNameKanji
        && !insuredBirthdate
        && !insuredBody
        && !carNo
        && !agencyCode
        && !agency) {
			toastEvent.setParams({
				 "title": "検索条件なし"
				,"type": "warning"
				,"message": "条件を指定して検索してください。"
			}).fire();
			exit;
        }

		// 検索先の振り分け（押下されたボタンのIDを取得）
		var whichOne = event.getSource().getLocalId();
		var action = "";

		if(whichOne == "life") {
			if(carNo) {
				toastEvent.setParams({"title": "検索失敗","type": "warning","message": "生保契約検索では車両ナンバー（損保）を指定して検索することはできません。"}).fire();
				return null;
			}
			if(insuredBody) {
				toastEvent.setParams({"title": "検索失敗","type": "warning","message": "生保契約検索では被保険体（ペット名）を指定して検索することはできません。"}).fire();
				return null;
			}
			action = component.get("c.getLifeContract");
		} else if (whichOne == "damage") {
			if(insuredBody) {
				toastEvent.setParams({"title": "検索失敗","type": "warning","message": "損保契約検索では被保険体（ペット名）を指定して検索することはできません。"}).fire();
				return null;
			}
			/*** UAT00250 FIX START */
			/*if(agencyCode) {
				toastEvent.setParams({"title": "検索失敗","type": "warning","message": "損保契約検索では代理店コードを指定して検索することはできません。"}).fire();
				return null;
			}*/
			/*** UAT00250 FIX END */
			if(insuredBirthdate) {
				toastEvent.setParams({"title": "検索失敗","type": "warning","message": "損保契約検索では被保険者生年月日（西暦）を指定して検索することはできません。"}).fire();
				return null;
			}
			if(insuredNameKana) {
				toastEvent.setParams({"title": "検索失敗","type": "warning","message": "損保契約検索では被保険者名カナ（姓名）を指定して検索することはできません。"}).fire();
				return null;
			}
			action = component.get("c.getDamageContract");
		} else {
			if(carNo) {
				toastEvent.setParams({"title": "検索失敗","type": "warning","message": "少短契約検索では車両ナンバー（損保）を指定して検索することはできません。"}).fire();
				return null;
			}
			action = component.get("c.getLittleContract");
		}

        // スピナーON
		helper.showSpinner(component);

		// Apexコントローラへの検索条件渡し
		action.setParams({
			  "insuraPolicyNo": component.find("insuraPolicyNo").get("v.value")
			 ,"applicationNumber": component.find("applicationNumber").get("v.value")
			 ,"insuraType": component.find("insuraType").get("v.value")
			 ,"name": component.find("name").get("v.value")
			 ,"status": component.find("status").get("v.value")
			 ,"contractTerm": component.find("contractTerm").get("v.value")
			 ,"CSID": component.find("CSID").get("v.value")
			 ,"contractorNameKana": component.find("contractorNameKana").get("v.value")
			 ,"contractorNameKanji": component.find("contractorNameKanji").get("v.value")
			 ,"subscriberDateOfBirth": component.find("subscriberDateOfBirth").get("v.value")
			 ,"phone": component.find("phone").get("v.value")
			 ,"postalCode": component.find("postalCode").get("v.value")
			 ,"insuredNameKana": component.find("insuredNameKana").get("v.value")
			 ,"insuredNameKanji": component.find("insuredNameKanji").get("v.value")
			 ,"insuredBirthdate": component.find("insuredBirthdate").get("v.value")
			 ,"insuredBody": component.find("insuredBody").get("v.value")
			 ,"carNo": component.find("carNo").get("v.value")
			 ,"agencyCode": component.find("agencyCode").get("v.value")
			 ,"agency": component.find("agency").get("v.value")
		});

		action.setCallback(this, function(response) {
			var state = response.getState();
			if(state === "SUCCESS") {
				component.set("v.dtos", response.getReturnValue());
				component.set("v.listSize",component.get("v.dtos").length);
				if(component.get("v.dtos").length == 0) {
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						 "title": "検索結果 0件"
						,"type": "warning"
						,"message": "検索条件にヒットするレコードが見つかりませんでした。検索条件を変更し、検索してください。"
					});
					toastEvent.fire();
				}
				if(component.get("v.dtos").length >= 200) {
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						 "title": "検索結果 200件以上"
						,"type": "warning"
						,"message": "検索結果が200件を超えており、全て表示できません。検索条件を追加し、検索してください。"
					});
					toastEvent.fire();
				}
			} else {
				console.log('Response state: ' + state);
			}
			// スピナーOFF
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},
	gotoSobject : function(component, event, helper) {
		// 遷移先レコードID取得
		var targetId = event.currentTarget.dataset.targetid;

		var toSobjectEvent = $A.get("e.force:navigateToSObject");
		toSobjectEvent.setParams({
			"recordId": targetId
		}).fire();
	}
})