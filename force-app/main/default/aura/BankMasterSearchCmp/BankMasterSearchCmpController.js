({ 
    openBankMasterSearch : function(component, event, helper) {
        var params = event.getParam('arguments');
        console.log("params value " + params.showSearchPopup);
        component.set("v.showSearchPopup",params.showSearchPopup);
    },

    search : function(component, event, helper){
        var label = event.getSource().get("v.label");
        if(label === "コード検索"){
            var inputBankCodeCmp = component.find("inputBankCode"); 
            var enteredBankCode = inputBankCodeCmp.get("v.value");

            var inputBranchCodeCmp = component.find("inputBranchCode");
            var enteredBranchCode = inputBranchCodeCmp.get("v.value");

            if($A.util.isEmpty(enteredBankCode) && $A.util.isEmpty(enteredBranchCode)){
                inputBankCodeCmp.setCustomValidity("銀行コードもしくは支店コードを入力してください。");
            }else{
                component.find("inputBankCode").setCustomValidity("");
                if(inputBankCodeCmp.get("v.validity").valid && inputBranchCodeCmp.get("v.validity").valid)
                    helper.searchBankMaster(component,"code");
            }
            inputBankCodeCmp.reportValidity();
        }else{
            var inputBankNameCmp = component.find("inputBankName");
            var enteredBankName = inputBankNameCmp.get("v.value");

            var inputBranchNameCmp = component.find("inputBranchName");
            var enteredBranchName = inputBranchNameCmp.get("v.value");

            if($A.util.isEmpty(enteredBankName) && $A.util.isEmpty(enteredBranchName)){
                component.set("v.bankBranchNameErrorFlag",true);
            }else if(!$A.util.isEmpty(enteredBankName)){
                helper.validateBankBranchName(component,enteredBankName);
            }
            if(!$A.util.isEmpty(enteredBranchName)){
                helper.validateBankBranchName(component,enteredBranchName);
            }

            alert('bankNameErrorFlag ' + component.get("v.bankBranchNameErrorFlag"));
            if(!component.get("v.bankBranchNameErrorFlag")){
                inputBankNameCmp.setCustomValidity("");
                helper.searchBankMaster(component,"name");
            }else{
                inputBankNameCmp.setCustomValidity("");
                inputBankNameCmp.setCustomValidity("銀行名/支店名を全角/半角カナで入力してください。");
            }
            inputBankNameCmp.reportValidity();
        }
    },

    getSelectedRecord : function(component,event,helper){
        var selectedRows = event.getParam('selectedRows');
        component.set("v.selectedRecord", selectedRows);
    },

    setSelectedRecord : function(component,event,helper){
        var selectedRecord = component.get("v.selectedRecord");
        var sourceScreen = component.get("v.sourceScreen");
        if(sourceScreen === "VF"){
            var appEvent = $A.get("e.c:BankMasterSearchResultEvt");
            appEvent.setParams({
                "bankCode" : selectedRecord[0].bankCode,
                "bankName" : selectedRecord[0].bankName,
                "branchCode" : selectedRecord[0].branchCode,
                "branchName" : selectedRecord[0].branchName
            });
            console.log("getparam " +appEvent.getParam("bankCode"));
            appEvent.fire();
            //決定後、検索ポップアップをクローズする
            vfCmp.set("v.showSearchPopup",false);
            //検索結果一覧をクリアする
            vfCmp.set("v.showSearchResultFlg", false);
        }else if(sourceScreen === "lightningCmp"){
            var cmpEvent = component.getEvent("bankMasterSearchCmpEvt");
            cmpEvent.setParams({
                "bankCode" : selectedRecord[0].bankCode,
                "bankName" : selectedRecord[0].bankName,
                "branchCode" : selectedRecord[0].branchCode,
                "branchName" : selectedRecord[0].branchName
            });
            cmpEvent.fire();
            //決定後、検索ポップアップをクローズする
            component.set("v.showSearchPopup",false);
            //検索結果一覧をクリアする
            component.set("v.showSearchResultFlg", false);
        }
    },

    closeSearchPopup : function(component, event, helper){
        component.set("v.errorFlag",false)
        component.set("v.showSearchResultFlg", false);
        component.set("v.showSearchPopup",false);
    }
})