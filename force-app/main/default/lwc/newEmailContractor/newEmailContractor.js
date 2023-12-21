import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class Email extends PubsubExtentions {
  @api itemKey;

  dispValue = true;
  formBlank = [];

  // 確認画面への遷移
  confirmPhase;

  onRecivedMessage(that, message){
    if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
    if(message.componentName == 'RelationshipWithContractor'){
      if(message.componentValue == 'contractor'){
        that.dispValue = true;
        that.value = "";
      }else {
        that.dispValue = false;
      }
    }
  }

  connectedCallback() {
      this.confirmPhase = false;
      this.subscribeToMessageChannel(this ,this.onRecivedMessage);
  }

  renderedCallback() {
    if(!this.confirmPhase){
      if(this.dispValue){
        this.formBlank = this.template.querySelectorAll('.c-form_text');
        if (this.formBlank[0].value == ''){
          this.formBlank[0].classList.add('blank');
        }
      }
    }

    if(this.confirmPhase) this.inputs = null;
    if(!this.inputs && !this.confirmPhase) this.inputs = this.defineInputsOfValueGetterSetter(this);
  }

  // 固有部品
  value = "";

  changeValueHandler(event) {
    if(event.target.value.match(/^[A-Za-z0-9]{1}[A-Za-z0-9_.-]*@{1}[A-Za-z0-9_.-]+\.[A-Za-z0-9]+$/)){
      this.formBlank[0].classList.remove('blank');
      this.value = event.target.value;
      const payload = {componentName:this.itemKey ,componentValue:this.value}
      this.publishToMessageChannel(payload);
    }else {
      this.formBlank[0].classList.add('blank');
      let error = this.template.querySelector('.errorMsg');
      error.classList.add('show');
      const payload2 = {componentName:this.itemKey ,componentValue:''}
      this.publishToMessageChannel(payload2);
      setTimeout(function(){
        error.classList.remove('show');
      }, 2000);
    }
  }

  get dispTitle(){
    return this.dispValue;
  }
}