import { api, track } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';
import sitePrcResources from '@salesforce/resourceUrl/SitePrc';

export default class Modpolicynumber extends PubsubExtentions {
  @api itemKeyPolicyNumber;
  @api majorItemName;
  @api confirmItemName;
  @api itemGuide1;
  @api itemGuide2;
  @api linkComponentName;
  @api lifeOnly;

  @track policyNumList = [];

  // 確認画面への遷移
  confirmPhase;
  DisplayAll;
  confirmNumber = ['','','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20'];
  policyNumListLength = 0

  value = "";
  valuePolicyNumber = '';
  plusIcon = `${sitePrcResources}/template/images/icon_plus.svg`;
  // add 2023/07/19 RIPCRM-924_次世代CC BAU（引継ぎOJTタスク）：ExperienceCloud対応案件 By 邵　Start
  isCreditCart=false;

  get dispCreditCart() {
    return this.isCreditCart;
  }
  // add 2023/07/19 RIPCRM-924_次世代CC BAU（引継ぎOJTタスク）：ExperienceCloud対応案件 By 邵　End 

  get dispGuide() {
    return (this.itemGuide1 != null || this.itemGuide2 != null);
  }

  get dispInput() {
    return !this.confirmPhase && this.DisplayAll;
  }
  get styleInput() {
    return this.dispInput ? 'display: block;' : 'display: none;'
  }

  get dispConfirm() {
    return this.confirmPhase && this.DisplayAll;
  }

  get dispAddNumber() {
    return this.policyNumListLength < 19;
  }

  onRecivedMessage(that, message){
    if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
    // add 2023/07/19 RIPCRM-924_次世代CC BAU（引継ぎOJTタスク）：ExperienceCloud対応案件 By 邵　Start
    if(message.componentName=='ModPaymentMethod') 
    {
      if(message.componentValue == 'クレジットカード払い'){
        that.isCreditCart = true;
      }else if(message.componentValue == '口座振替'){
        that.isCreditCart = false;
      }
      that.DisplayAll = true;
    }
    // add 2023/07/19 RIPCRM-924_次世代CC BAU（引継ぎOJTタスク）：ExperienceCloud対応案件 By 邵　End
    if (that.linkComponentName !== undefined && that.linkComponentName != '') {
      if(message.componentName==that.linkComponentName) {
        that.DisplayAll = message.componentValue;
        if (that.DisplayAll) {
          that.publishToMessageChannel({componentName:that.itemKeyPolicyNumber ,componentValue:that.valuePolicyNumber});
          var number = 2;
          for (var i = 0; i < that.policyNumListLength; i++) {
            that.publishToMessageChannel({componentName:'CancelInsurance' + number ,componentValue:that.policyNumList[i].value});
            number++;
          }
        } else {
          that.publishToMessageChannel({componentName:that.itemKeyPolicyNumber ,componentValue:''});
          var number = 2;
          for (var i = 0; i < that.policyNumListLength; i++) {
            that.publishToMessageChannel({componentName:'CancelInsurance' + number ,componentValue:''});
            number++;
          }
        }
      }
    }
  }
    
  connectedCallback() {
      this.confirmPhase = false;
      this.subscribeToMessageChannel(this ,this.onRecivedMessage);
      if (this.linkComponentName !== undefined && this.linkComponentName != '') {
        this.DisplayAll = false;
      } else {
        this.DisplayAll = true;
      }
      this.initPolicyNumberList();
  }

  renderedCallback() {
    if(!this.iscalladdevent) {
      this.addEventInput();
      console.log('### debug')
      this.iscalladdevent = true;
    }
  }
  changeValueHandlerPolicyNumber(event) {
    this.valuePolicyNumber = event.target.value;
    const payload = {componentName:this.itemKeyPolicyNumber ,componentValue:this.valuePolicyNumber}
    this.publishToMessageChannel(payload);
  }

  changeValueHandlerPolicyNumberList(event) {
    console.log(event.target.dataset.id);
    for (var i = 0; i < this.policyNumListLength; i++) {
      if (this.policyNumList[i].key == event.target.dataset.id) {
        this.policyNumList[i].value = event.target.value;
        break;
      }
    }
    const payload = {componentName:event.target.dataset.id ,componentValue:event.target.value};
    this.publishToMessageChannel(payload);
  }

  initPolicyNumberList() {
    for(var i=0;i<19;i++){
      const count = this.policyNumList.length + 2;
      let _number = count.toString().padStart( 2, '0'); 
      this.policyNumList.push({
        key: 'CancelInsurance' + count, 
        num: count, value: '', 
        label: this.confirmNumber[count], 
        tagName: 'nmNumber['+ _number +']', 
        class: 'mt5 u-hide js-toggle-hide', 
        disabled: true
      });
    }
    this.policyNumListlength = 1;
  }

  addPolicyNumber(event) {
    this.policyNumListLength += 1;
    this.policyNumList[this.policyNumListLength-1].class = "mt5 js-toggle-hide"
    this.policyNumList[this.policyNumListLength-1].disabled = false
  }

  removePolicyNumber(event) {
    const targetName = event.target.value;
    let removeIndex;
    for (var i = 0; i < this.policyNumListLength; i++) {
      if (this.policyNumList[i].key == targetName) {
        removeIndex = i;
      }
    }

    for (var i = removeIndex; i < this.policyNumListLength; i++) {
      if(i==this.policyNumList.length-1){
        this.policyNumList[i].value = '';
      }else{
        this.policyNumList[i].value = this.policyNumList[i+1].value;
      }

      this.publishToMessageChannel({componentName:this.policyNumList[i].key ,componentValue:this.policyNumList[i].value});
    }

    this.policyNumList[this.policyNumListLength-1].class = 'mt5 u-hide js-toggle-hide';
    this.policyNumList[this.policyNumListLength-1].disabled = true;
    this.policyNumListLength -= 1;

  }

  get confirmPolicyNumList(){
    return this.policyNumList.slice(0, this.policyNumListLength)
  }
  
  get dataNumType(){
    return this.lifeOnly? "8" :"8-10"
  }

  addEventInput(event) {
	  let numChecks = this.template.querySelectorAll('.js-numCheck');
    console.log('### debbug' ,numChecks)
	  for (let i = 0; i < numChecks.length; i++) {
	    let numCheck  = numChecks[i];
	    let type      = numCheck.dataset.numType;
	    let len       = 0;
	    let blowing   = document.createElement('div');
	    let errText   = '';
	    blowing.classList.add('js-numCheck__err');
	    (numCheck.closest('.c-number-form')).style.position = 'relative';
	    (numCheck.closest('.c-number-form')).appendChild(blowing);
	    // ($(numCheck).parent('.c-number-form').get(0)).style.position = 'relative';
	    // ($(numCheck).parent('.c-number-form').get(0)).appendChild(blowing);
	    blowing.innerHTML = "<div>" + blowing.innerHTML + "</div>";
	    const checkCount = () => {
	      let errFlg   = false;
	      let errColor = false;
	      len = (numCheck.value).length;
	      switch (type) {
	        case '8':
	          if (len < 8) {
	            errText = '文字数が不足しています。ご確認ください。';
	            errFlg = true;
	          }
	          break;
	        case '8-10':
	          if (len < 8) {
	            errText = '文字数が不足しています。ご確認ください。';
	            errFlg = true;
	          }
	          else if (len > 8 && len < 10) {
	            errText = '文字数が誤っています。ご確認ください。';
	            errFlg   = true;
	            errColor = true;
	          }
	          break;
	      }
	      if (errFlg) {
	        blowing.style.marginTop = '-10px';
	        blowing.style.opacity   = '1';
	      } else {
	        blowing.style.marginTop = '0';
	        blowing.style.opacity   = '0';
	      }
	      if (errColor) {
	        (numCheck.closest('.c-number-form')).classList.add('is-error');
	      } else {
	        (numCheck.closest('.c-number-form')).classList.remove('is-error');
	      }
	      if (blowing.innerText !== errText) {
	        blowing.childNodes[0].innerText = errText;
	      }
	    };
	    numCheck.addEventListener('keyup',e=>{
	      checkCount();
	    });
	    numCheck.addEventListener('focus',e=>{
	      checkCount();
	    });
	    numCheck.addEventListener('blur',e=>{
	      blowing.style.marginTop = '0';
	      blowing.style.opacity   = '0';
	    });
	  }
  }

  onBlurInput(event){
    const inputval = event.target.value;

    if(!inputval){
      event.target.nextElementSibling.click();
    }
  }

}