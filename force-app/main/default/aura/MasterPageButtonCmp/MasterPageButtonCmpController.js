({
   init : function(component, event, helper) {
        helper.fetchMasterRecords(component);
	},
    handleClick: function(component, event, helper) {
        var navService = component.find("navCreateReception");
        var pageReference = component.get("v.pageReference");
        console.log('pageReference'+pageReference);
        event.preventDefault();
        navService.navigate(pageReference);
    }
})