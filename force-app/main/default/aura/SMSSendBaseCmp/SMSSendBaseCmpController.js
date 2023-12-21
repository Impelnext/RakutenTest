({
    SMSSendCmp : function(component,event,helper){

        var C_MSG_FAILED = 'SMS送信リクエストに失敗しました。システム管理者に問い合わせてください。';  // *
        var C_MSG_SENDING = 'SMS送信処理中です。';  // *
        var C_MSG_SHITAGAKI = '承諾がないので送信できません。';  // *
        var C_MSG_NO_KENGEN = 'SMSを送信する権限がありません。';  // *
        var C_MSG_SUMI = '承諾がないので送信できません。';  // *
        var C_MSG_RET = '承諾がないので送信できません。';  // *
        var C_MSG_NO_KYOKA = '承諾がないので送信できません。';  // *
		var C_MSG_NO_MSG = 'メッセージ本文がないため送信できません。';  // *

		var err = 0;
		var msg = '';
        var accountId = component.get("v.recordId");
        var action = component.get("c.checkError");
		action.setParams({ smsinfoId: accountId })

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				err = response.getReturnValue();

                console.log("message:" + err);
                component.set('v.error', err);
                //alert("message:" + err);
                if (err != 0) {
                    if (err == 1) {
                        component.set('v.retmsg', C_MSG_NO_KENGEN);
                        msg = C_MSG_NO_KENGEN;
                    } else if (err == 2) {
                        component.set('v.retmsg', C_MSG_SHITAGAKI);
                        msg = C_MSG_SHITAGAKI;
                    } else if (err == 3) {
                        component.set('v.retmsg', C_MSG_SUMI);
                        msg = C_MSG_SUMI;
                    } else if (err == 4) {
                        component.set('v.retmsg', C_MSG_RET);
                        msg = C_MSG_RET;
                    } else if (err == 5) {
                        component.set('v.retmsg', C_MSG_NO_KYOKA);
                        msg = C_MSG_NO_KYOKA;
                    } else if (err == 6) {
                        component.set('v.retmsg', C_MSG_NO_MSG);
                        msg = C_MSG_NO_MSG;
                    } else if (err == 7) {
                        component.set('v.retmsg', C_MSG_NO_KENGEN);
                        msg = C_MSG_NO_KENGEN;
                    }
                } else {
                    component.set('v.retmsg', C_MSG_SENDING);
                    msg = C_MSG_SENDING;
                }
            } else {
                component.set('v.retmsg', C_MSG_FAILED);
                msg = C_MSG_FAILED;
			}

//		    alert(err);
    		if (err != 0) {
			    helper.createErrorMessage(component, msg);
    			return;
			}
			
            var accountId2 = component.get("v.recordId");
            //alert("acountId2:" + accountId2);
		    //$A.createComponent("c:SMSSendCmp",{"showSearchPopup" : true,"sourceScreen" : "lightningCmp", "smsinfoId" : accountId2},function(responseName, status, errorMessage){
		    $A.createComponent("c:SMSSendCmp",{"recordId": accountId2, "smsinfoId" : accountId2},function(responseName, status, errorMessage){
    			if(status === "SUCCESS"){
			    	var body = component.get("v.body");
                    body.push([]);
                    body.push(responseName);
                        component.set("v.body", body);
    			    }else{
			    	alert('ErrorMessage ' + errorMessage);
			    }
    		});

        });
		$A.enqueueAction(action);
	}
})