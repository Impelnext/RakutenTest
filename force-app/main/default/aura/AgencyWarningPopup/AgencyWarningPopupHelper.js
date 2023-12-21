({
	showNgAgencyPopup : function(cmp, warningList) {
        if(warningList.ngList.length == 0) return;
        this.showWarningPopup(cmp, "保全禁止代理店有り顧客", null);
	},
    showWarningPopup : function(cmp, title, msg){
        cmp.find('notifLib').showNotice({
            "variant": "error",
            "header": title,
            "message": msg,
            closeCallback: function() {
            }
        });
    }
})