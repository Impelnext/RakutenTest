import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class ContInfoPolicyNum extends PubsubExtentions {
  @api itemKey;
  @api itemComment;
  
  // 確認画面への遷移
  confirmPhase;

  onRecivedMessage(that, message){
    if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
  }
    
  connectedCallback() {
      this.confirmPhase = false;
      this.subscribeToMessageChannel(this ,this.onRecivedMessage);
  }

  renderedCallback() {
    if(!this.iscalladdevent) {
      this.addEventInput();
      this.iscalladdevent = true;
    }
  }
  // 固有部品
  value = "";

  changeValueHandler(event) {
      this.value = event.target.value;
      const payload = {componentName:this.itemKey ,componentValue:this.value}
      this.publishToMessageChannel(payload);
  }

  get dispConfirm() {
    return this.value != '';
  }

  get dispComment() {
    return this.itemComment != '';
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
	    blowing.innerHTML = "<div>" + blowing.innerHTML + "</div>";
	    const checkCount = () => {
	      let errFlg   = false;
	      let errColor = false;
	      len = (numCheck.value).length;
	      switch (type) {
	        case '8':
	          if (len > 0 && len < 8) {
	            errText = '文字数が不足しています。ご確認ください。';
	            errFlg = true;
	          }
	          break;
	        case '8-10':
	          if (len > 0 && len < 8) {
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

}