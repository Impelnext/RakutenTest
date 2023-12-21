({
	doInit  : function(c, e, h) {
        h.getColumn(c);
        h.getContentList(c);
        console.log('### recordId', c.get("v.recordId"));
    },
    openContentDistributionWizard : function(c, e, h) {
        var recordId = c.get("v.recordId")
        var url = '/udd/ContentDistribution/wiz/selectContent.apexp';
        if(recordId) url = url + '?whatId=' + recordId + '&retURL=%2F' + recordId
        window.open(url);
	},
    openModal : function(c, e, h) {
        var dateTimeLimitDefault = c.get('v.dateTimeLimitDefault');
        var today = new Date();
        today.setTime(today.getTime() + dateTimeLimitDefault*24*60*60*1000)
        today.setHours(23, 59, 59, 0);
        
        c.set('v.dateTimeLimit', today.toISOString());
        c.set('v.newContent', null);
        c.set('v.showModal', true);
	},
    
	handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        console.log("uploadedFiles : ", uploadedFiles);
        console.log("uploadedFiles[0] : ", uploadedFiles[0]);
        console.log("uploadedFiles[0] : ", uploadedFiles[0].name);
        console.log("uploadedFiles[0] : ", uploadedFiles[0].documentId );
        cmp.set('v.newContent', {Id: uploadedFiles[0].contentVersionId , Name: uploadedFiles[0].name});

    },
    
    onCancelClicked: function(c, e, h) {
        c.set('v.showModal', false);
    },
    
    onSaveClicked: function(c, e, h) {
        var newContent = c.get("v.newContent");

        if(newContent && newContent.DistributionPublicUrlForExC){
            c.set('v.showModal', false);
            h.getContentList(c);
        }else{
            h.createContentDistribution(c, e, h);
        }
    },
    
})