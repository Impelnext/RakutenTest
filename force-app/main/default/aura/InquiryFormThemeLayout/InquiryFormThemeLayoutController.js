({
	init : function(c, e, h) {
    const skipTargetDomainNameParts = 'live-preview.salesforce-experience.com';
    if( window.location.hostname.indexOf(skipTargetDomainNameParts)>=0 )return;

    var redirectUrl = c.get("v.redirectUrl");
    var company = h.getParam('company');
    var targetCompany
    if(c.get("v.targetCompany")) targetCompany = c.get("v.targetCompany").split(',')

    if(targetCompany && !targetCompany.includes(company) ){
      if(redirectUrl && redirectUrl.length>0 ){
        console.log('### window.location.hostname',window.location.hostname)
        window.location.href = redirectUrl;
        c.set("v.isValidParameter", false);
      }
    }
	}
})