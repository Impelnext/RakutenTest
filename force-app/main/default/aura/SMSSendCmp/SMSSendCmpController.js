({
        clickCancel: function(component, event, helper) {

            var workspaceAPI = component.find("workspace");
            var focusedTabId;
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                focusedTabId = response.tabId;
                workspaceAPI.refreshTab({tabId : focusedTabId});
                component.destroy();
            })
            .catch(function(error) {
                console.log(error);
            });
        },

        init : function(component, event, helper) {

        var err = 0;
        var accountId = component.get("v.recordId");
        var action = component.get("c.sendSMS");
        action.setParams({ smsinfoId: accountId });
        //alert("init:" + accountId);

        action.setCallback(this, function(response) {
            var state = response.getState();
            //サーバーへのアクセスに成功した場合、保持する契約に沿ってボタンを使用不可に変更
            if (state === "SUCCESS") {
                err = response.getReturnValue();
                //
                console.log("message:" + err);
                component.set('v.error', err);
                //alert("message:" + err);
                if (err != 0) {
                    if (err == 1) {
                        component.set('v.retmsg', C_MSG_NO_KENGEN);
                        count = -1;
                    } else if (err == 2) {
                        component.set('v.retmsg', C_MSG_SHITAGAKI);
                        count = -1;
                    } else if (err == 3) {
                        component.set('v.retmsg', C_MSG_SUMI);
                        count = -1;
                    } else if (err == 4) {
                        component.set('v.retmsg', C_MSG_RET);
                        count = -1;
                    } else if (err == 5) {
                        component.set('v.retmsg', C_MSG_NO_KYOKA);
                        count = -1;
                    } else if (err == 6) {
                        component.set('v.retmsg', C_MSG_NO_MSG);
                        count = -1;
                    }
                } else {
                    component.set('v.retmsg', C_MSG_SENDING);
                }
            } else {
                component.set('v.retmsg', C_MSG_FAILED);
            }
        });
        $A.enqueueAction(action);

    var C_STATUS_OK = '送信済み(成功)'; 
    var C_STATUS_NG = '送信済み(失敗)';
    var C_STATUS_SHITAGAKI = '下書き';
    var C_STATUS_RETRY = 'リトライ中';
    var C_STATUS_MISHONIN = '未承認';
    var C_MSG_OK = 'SMS送信が成功しました。';  // *
    var C_MSG_NG = 'SMS送信が失敗しました。';  // *
    var C_MSG_FAILED = 'SMS送信リクエストに失敗しました。システム管理者に問い合わせてください。';  // *
    var C_MSG_SENDING = 'SMS送信処理中です。';  // *
    var C_MSG_RETRY = 'SMS送信リトライ中です。'; 
    //var C_MSG_TIMEOUT = 'タイムアウトです。後ほど確認してください。';  // *
    var C_MSG_TIMEOUT = '後ほど確認してください。';  // *
    //var C_MSG_SHITAGAKI = 'SMSを送信する権限がありません。';  // *
    var C_MSG_SHITAGAKI = '承諾がないので送信できません。';  // *
    var C_MSG_NO_KENGEN = 'SMSを送信する権限がありません。';  // *
    var C_MSG_SUMI = '承諾がないので送信できません。';  // *
    var C_MSG_RET = '承諾がないので送信できません。';  // *
    var C_MSG_NO_KYOKA = '承諾がないので送信できません。';  // *
    var C_MSG_NO_MSG = 'メッセージ本文がないため送信できません。';  // *
    var C_INTERVAL = 3000; // ms
    var C_COUNT = 20; // 40; // 40; //  3 x 40 = 2min

    // 3秒間隔で120秒まで
    var count = 0;
    var countup = function() {
        
        $A.get("e.force:refreshView").fire();

        if (count < 0)  {
            clearInterval(id);
            return;
        }

        console.log(count++);

        var accountId = component.get("v.recordId");
        //alert(accountId);

        var action = component.get("c.checkSMS");
        action.setParams({ smsinfoId: accountId });

        //alert("checkSMS:" + accountId);

        action.setCallback(this, function(response) {
            var state = response.getState();
            
component.set('v.packed', false);
            //サーバーへのアクセスに成功した場合、保持する契約に沿ってボタンを使用不可に変更
            if (state === "SUCCESS") {
                var status = response.getReturnValue();
                console.log('controller status : ' + status);
                if (status ==  C_STATUS_OK) {
                    component.set('v.retmsg', C_MSG_OK);
                    clearInterval(id);
                    count = -1;
                } else if (status == C_STATUS_RETRY) {
                    if (count >= 0) {
                        component.set('v.retmsg', C_MSG_RETRY);
                    }
                } else if (status == C_STATUS_NG) {
                    component.set('v.retmsg', C_MSG_NG);
                    clearInterval(id);
                    count = -1;
                }
            } else {
                component.set('v.retmsg', C_MSG_FAILED);
            }
        });
        $A.enqueueAction(action);
    }

//  countup();
    var id = setInterval(function() {
        countup();
        if(count == -1){ 
            clearInterval(id);
            //alert('clearInterval');
        } else if (count > C_COUNT) {
            clearInterval(id);
            component.set('v.retmsg', C_MSG_TIMEOUT);
            count = -1;
        }}, C_INTERVAL);

        component.set("v.setIntervalId", id) ; 
    }
})