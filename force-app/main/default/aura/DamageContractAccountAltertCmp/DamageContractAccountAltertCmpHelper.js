({
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