({
    searchBankMaster : function(component, searchSource) {

        var action = component.get("c.searchBankMaster");
        var param1 = "";
        var param2 = "";
        if(searchSource === "code"){
            param1 = component.find("inputBankCode").get("v.value");
            param2 = component.find("inputBranchCode").get("v.value");
        }else{
            param1 = component.find("inputBankName").get("v.value");
            param2 = component.find("inputBranchName").get("v.value");
        }
        action.setParams({
            arg1 : param1,
            arg2 : param2,
            source : searchSource
        });
        action.setCallback(this, function(response) {
            var result = response.getState();
            if(result === "SUCCESS"){
                var searchResult = response.getReturnValue();
                //検索結果が100件過ぎると、検索結果を表示しないようにする。
                if(response.getReturnValue().errorDisplayFlag === 1){
                    component.set("v.showSearchResultFlg",false);
                    component.set("v.errorFlag",true);
                    component.set("v.errorMessage","検索結果が100件を超えています。条件を絞って再度検索してください。");
                }else if(response.getReturnValue().errorDisplayFlag === 2){
                    component.set("v.showSearchResultFlg",false);
                    component.set("v.errorFlag",true);
                    component.set("v.errorMessage","検索条件に一致するレコードがありません。");
                }else{
                    component.set("v.showSearchResultFlg", true);
                    component.set('v.searchResultCol', [
                        {label: '銀行名', fieldName: 'bankName', type: 'text'},
                        {label: '支店名', fieldName: 'branchName', type: 'text'}
                    ]);
                    component.set("v.searchResult", response.getReturnValue().bankMasterSearchResultList);
                    component.set("v.errorFlag",false);
                }
            }
        });
        $A.enqueueAction(action);
    },

    validateBankBranchName : function(component,name){

        var nameArray = [];
        var bankBranchNameErrorFlag = false;
        var nameArray = Array.prototype.map.call(name, i => i);
        for(var j = 0; j < nameArray.length; j++){
            if(nameArray[j] >= '\uff61' && nameArray[j] <= '\uff9f' || 
               nameArray[j] >= '\u30a0' && nameArray[j] <= '\u30ff'){
                continue;
            }else{
                bankBranchNameErrorFlag = true;
                break;
            }
        }
        component.set("v.bankBranchNameErrorFlag",bankBranchNameErrorFlag);
    }
})