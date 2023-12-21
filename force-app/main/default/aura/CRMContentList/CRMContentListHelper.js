({

	getColumn  : function(c) {
        c.set('v.dispColumns', [
            {label: '作成日時',  fieldName: 'CreatedDate' , type: 'date', typeAttributes:{day:'2-digit',month:'2-digit',year:'numeric', hour:'2-digit',minute:'2-digit',second:'2-digit',hour12:false}},
            {label: 'ファイル名',  fieldName: 'LinkName', type: 'date' , type: 'url', typeAttributes:{label: {fieldName: 'Name'}, target: '_blank'}},
            {label: 'URL',  fieldName: 'DistributionPublicUrlForExC', type: 'url' , typeAttributes: {label: { fieldName: 'DistributionPublicUrlForExC' }, target: '_self'}},
            {label: 'パスワード',  fieldName: 'Password'},
            {label: '期限 ',  fieldName: 'ExpiryDate', type: 'date', typeAttributes:{day:'2-digit',month:'2-digit',year:'numeric', hour:'2-digit',minute:'2-digit',second:'2-digit',hour12:false}},
            {label: '表示回数',  fieldName: 'ViewCount'}
        ]);
	},
	getContentList : function(c) {
        var action = c.get("c.getContentList");
        action.setParams({
            recordId:c.get("v.recordId")
        });   
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let url = $A.get("$Label.c.ExC_ContentDistributionURL")
                let urlReplace = $A.get("$Label.c.ExC_ContentDistributionDomain")
                var records =response.getReturnValue();
                records.forEach(function(record){
                    let urlid = record.DistributionPublicUrl.replace(urlReplace+'/sfc/p/','');
                    let urlid_querystr = encodeURIComponent(urlid);
                    record.DistributionPublicUrlForExC = url + '?id='+ urlid_querystr;
                    
                    record.LinkName = "/"+record.Id; 
                });
                c.set("v.lstContent", records);
            }
        });
        $A.enqueueAction(action);
	},
    
	createContentDistribution : function(c) {
        console.log('## dateTimeLimit' ,c.get('v.dateTimeLimit'));

        var action = c.get("c.createContentDistribution");
        var newContent = c.get("v.newContent");
        var dtLimit =  c.get('v.dateTimeLimit');
        console.log('#newContent',newContent.Id)
        console.log('#newContent',newContent.Name)
        console.log('#recordId',c.get("v.recordId"))
        action.setParams({
            title: newContent.Name,
            ContentId: newContent.Id,
            RelatedRecordId: c.get("v.recordId"),
            DateTimeLimit: dtLimit
        });   
        action.setCallback(this,function(response) {
            var state = response.getState();
            console.log('## result', state);
            if (state === "SUCCESS") {
                var ret =response.getReturnValue();
                let url = $A.get("$Label.c.ExC_ContentDistributionURL")
                let urlReplace = $A.get("$Label.c.ExC_ContentDistributionDomain")
                
                let urlid = ret.DistributionPublicUrl.replace(urlReplace+'/sfc/p/','');
                let urlid_querystr = encodeURIComponent(urlid);
                ret.DistributionPublicUrlForExC = url + '?id='+ urlid_querystr;
                c.set("v.newContent", ret);
            }
        });
        $A.enqueueAction(action);
	}
})