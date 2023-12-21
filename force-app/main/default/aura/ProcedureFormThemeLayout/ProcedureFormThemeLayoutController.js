({
	init : function(c, e, h) {
    const skipTargetDomainNameParts = 'live-preview.salesforce-experience.com';
    if( window.location.hostname.indexOf(skipTargetDomainNameParts)>=0 ){
      return;      ;
    }
    
    var redirectUrl = c.get("v.redirectUrl");
    // var reason = false;
    var targetReason1;
    var targetReason2;
    var targetReason3;
    var rsn1 = true;
    var rsn2 = true;
    var rsn3 = true;
    // 2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 邵　Start 
    var targetDisadvantageOpt;
    var dagOpt = true;
    // 2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 邵　End
    
    try {
      var reason1 = h.getParam('reason1') ? decodeURI(h.getParam('reason1')) : null;
      var reason2 = h.getParam('reason2') ? decodeURI(h.getParam('reason2')) : null;
      var reason3 = h.getParam('reason3') ? decodeURI(h.getParam('reason3')) : null;
      // 2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 邵　Start 
      var disadvantageOPT1 = h.getParam('disadvantageOPT1') ? decodeURI(h.getParam('disadvantageOPT1')) : null;
      var disadvantageOPT2 = h.getParam('disadvantageOPT2') ? decodeURI(h.getParam('disadvantageOPT2')) : null;
      var disadvantageOPT3 = h.getParam('disadvantageOPT3') ? decodeURI(h.getParam('disadvantageOPT3')) : null;
      var disadvantageOPT4 = h.getParam('disadvantageOPT4') ? decodeURI(h.getParam('disadvantageOPT4')) : null;
      var disadvantageOPT5 = h.getParam('disadvantageOPT5') ? decodeURI(h.getParam('disadvantageOPT5')) : null;
      var disadvantageOPT6 = h.getParam('disadvantageOPT6') ? decodeURI(h.getParam('disadvantageOPT6')) : null;
      // 2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 邵　End
    } catch (e) {
      console.error("Invalid URI");
      window.location.href = redirectUrl;
    }

    //使ってないです。
    // var targetCompany;
    // reason1 = ["現在のお支払いが負担に感じるため", "更新後保険料のお支払いが負担に感じるため", "楽天生命の他の保険に加入し直したほうが安くなるため", "楽天生命以外の保険に加入し直したほうが安くなるため"];
    // reason2 = ["楽天生命の他の保険に加入し直し、保障を充実したいため", "楽天生命以外の保険に加入し直し、保障を充実したいため", "不要な保障を減らしたいため", "生活環境が変わり、保障を見直したいため"];
    // reason3 = ["楽天生命のサービスにご不安・不満足", "その他"];
  

    if(c.get("v.targetReason1")) targetReason1 = c.get("v.targetReason1").split(',');
    if(c.get("v.targetReason2")) targetReason2 = c.get("v.targetReason2").split(',');
    if(c.get("v.targetReason3")) targetReason3 = c.get("v.targetReason3").split(',');
    // 2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 邵　Start 
    if(c.get("v.targetDisadvantageOpt")) targetDisadvantageOpt = c.get("v.targetDisadvantageOpt")
    // 2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 邵　End

    if(reason1){
      if(!targetReason1.includes(reason1)){
        rsn1 = false;
      }
    }else if(reason2){
      if(!targetReason2.includes(reason2)){
        rsn2 = false;
      }
    }else if(reason3){
      if(!targetReason3.includes(reason3)){
        rsn3 = false;
      }
    }else {
      rsn1 = false;
      rsn2 = false;
      rsn3 = false;
    }
    
    // 2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 邵　Start 
    if(disadvantageOPT1 && disadvantageOPT2 && disadvantageOPT3 && disadvantageOPT4 && disadvantageOPT5 && disadvantageOPT6){
      if(disadvantageOPT1 !== targetDisadvantageOpt ||  
        disadvantageOPT2 !== targetDisadvantageOpt || 
        disadvantageOPT3 !== targetDisadvantageOpt || 
        disadvantageOPT4 !== targetDisadvantageOpt || 
        disadvantageOPT5 !== targetDisadvantageOpt || 
        disadvantageOPT6 !== targetDisadvantageOpt){
        dagOpt = false;
      }
    }else {
      dagOpt = false;
    }
    // 2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 邵　End

    
    if(!rsn1){
      if(targetReason1 && !targetReason1.includes(reason1) ){
        if(redirectUrl && redirectUrl.length>0 ){
          console.log('### window.location.hostname',window.location.hostname)
          window.location.href = redirectUrl;
          c.set("v.isValidParameter", false);
        }
      }
    }else if(!rsn2){
      if(targetReason2 && !targetReason2.includes(reason2) ){
        if(redirectUrl && redirectUrl.length>0 ){
          console.log('### window.location.hostname',window.location.hostname)
          window.location.href = redirectUrl;
          c.set("v.isValidParameter", false);
        }
      }
    }else if(!rsn3){
      if(targetReason3 && !targetReason3.includes(reason3) ){
        if(redirectUrl && redirectUrl.length>0 ){
          console.log('### window.location.hostname',window.location.hostname)
          window.location.href = redirectUrl;
          c.set("v.isValidParameter", false);
        }
      }
    }else if(!rsn1 && !rsn2 && !rsn3){
      if(redirectUrl && redirectUrl.length>0 ){
        console.log('### window.location.hostname',window.location.hostname)
        window.location.href = redirectUrl;
        c.set("v.isValidParameter", false);
      }
    }

   // 2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 邵　Start
   if(!dagOpt){
      if(redirectUrl && redirectUrl.length>0 ){
        console.log('### window.location.hostname',window.location.hostname)
        window.location.href = redirectUrl;
        c.set("v.isValidParameter", false);
      }
    }
    // 2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 邵　End
	}
})