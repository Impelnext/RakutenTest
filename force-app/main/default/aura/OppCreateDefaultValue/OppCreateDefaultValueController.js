({
    /*
     * 生保新規商談作成
     */
    createSeihoOpp: function(component, event, helper) {
        
        //取引先カナ名取得のため、サーバー側のコントローラにアクセス
        var recId = component.get("v.recordId");
        var action = component.get("c.getAccFurigana");
        action.setParams({ recordId: recId });
        
        //取引先カナ取得後のコールバック関数を定義
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            //サーバーへのアクセスに成功した場合、商談名をセットして新規商談画面に遷移
            if (state === "SUCCESS") {
                
                //商談レコード作成ページの呼び出しと商談名の初期設定
                var createRecordEvent = $A.get("e.force:createRecord");
                var oppName = helper.getNowYMD() + "_生保_" + response.getReturnValue();
                if(oppName.length > 80){
                    oppName = oppName.substr(0,80);
                }
                createRecordEvent.setParams({
                    entityApiName: "Opportunity",
                    recordTypeId: component.get("v.seihoRType"),
                    defaultFieldValues: {
                        AccountId:recId,
                        Name: oppName,
                        CloseDate:　helper.getCloseDate(),
                        StageName: "未対応",
                        CampaignDateTime__c: helper.getTodayString()
                    }
                });
                createRecordEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    /*
     * 損保新規商談作成
     */
    createSonpoOpp: function(component, event, helper) {
        
        //取引先カナ名取得のため、サーバー側のコントローラにアクセス
        var recId = component.get("v.recordId");
        var action = component.get("c.getAccFurigana");
        action.setParams({ recordId: recId });
        
        //取引先カナ取得後のコールバック関数を定義
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            //サーバーへのアクセスに成功した場合、商談名をセットして新規商談画面に遷移
            if (state === "SUCCESS") {
                
                //商談レコード作成ページの呼び出しと商談名の初期設定
                var createRecordEvent = $A.get("e.force:createRecord");
                var oppName =            helper.getNowYMD() + "_損保_" + response.getReturnValue();
                if(oppName.length > 80){
                    oppName = oppName.substr(0,80);
                }
                createRecordEvent.setParams({
                    entityApiName: "Opportunity",
                    recordTypeId: component.get("v.sonpoRType"),
                    defaultFieldValues: {
                        AccountId:recId,
                        Name: oppName,
                        CloseDate:　helper.getCloseDate(),
                        StageName: "未対応",
                        CampaignDateTime__c: helper.getTodayString()
                    }
                });
                createRecordEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    /*
     * 少短新規商談作成
     */
    createSyotanOpp: function(component, event, helper) {
        
        //取引先カナ名取得のため、サーバー側のコントローラにアクセス
        var recId = component.get("v.recordId");
        var action = component.get("c.getAccFurigana");
        action.setParams({ recordId: recId });
        
        //取引先カナ取得後のコールバック関数を定義
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            //サーバーへのアクセスに成功した場合、商談名をセットして新規商談画面に遷移
            if (state === "SUCCESS") {
                
                //商談レコード作成ページの呼び出しと商談名の初期設定
                var createRecordEvent = $A.get("e.force:createRecord");
                var oppName =helper.getNowYMD() + "_少短_" + response.getReturnValue();
                if(oppName.length > 80){
                    oppName = oppName.substr(0,80);
                }
                createRecordEvent.setParams({
                    entityApiName: "Opportunity",
                    recordTypeId: component.get("v.syotanRType"),
                    defaultFieldValues: {
                        AccountId:recId,
                        Name: oppName,
                        CloseDate:　helper.getCloseDate(),
                        StageName: "未対応",
                        CampaignDateTime__c: helper.getTodayString()
                    }
                });
                createRecordEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
    },
    doInit: function(component) {
		var action = component.get("c.getRType");
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            //サーバーへのアクセスに成功した場合、プロファイルに沿ってボタンを使用不可に変更
            if (state === "SUCCESS") {
                var map = response.getReturnValue();
                for(var key in map){
                    if(key == "生保"){
                        component.set("v.seihoRType",map[key]);
                        component.find("btnSeiho").set("v.disabled", false);
                    }else if(key == "損保"){
                        component.set("v.sonpoRType",map[key]);
                        component.find("btnSonpo").set("v.disabled", false);
                    }else if(key == "少短"){
                        component.set("v.syotanRType",map[key]);
                        component.find("btnSyotan").set("v.disabled", false);
                    }
        		}
            }
        });
        $A.enqueueAction(action);
    }
});