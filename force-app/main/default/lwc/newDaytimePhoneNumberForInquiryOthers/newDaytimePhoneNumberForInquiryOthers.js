import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class DaytimePhoneNumberForInquiry extends PubsubExtentions {
  @api itemKey;
  // 確認画面への遷移
  confirmPhase;

  value = "";
  valueRadio = "";
  isChanged = false;
  dispValue = false;
  formBlank = [];

  onRecivedMessage(that, message){
    if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
    if(message.componentName == 'RelationshipWithContractor'){
      if(message.componentValue == 'others1' || message.componentValue == 'others2' || message.componentValue == 'others3'){
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
    const radio = this.template.querySelector('input[value="' + this.valueRadio + '"]');
    if (radio) radio.checked = true;

    if(!this.confirmPhase){
      if(this.dispValue){
        this.formBlank = this.template.querySelectorAll('.c-form_text');
        if(this.formBlank[0].value == ''){
          this.formBlank[0].classList.add('blank');
        }
      }
    }
  }

  /*
  get options() {
    return [
        { label: '当社にご登録のお電話番号と同じ', value: '当社にご登録のお電話番号と同じ' },
        { label: '別の電話番号', value: '別の電話番号' },
    ];
  }
  */

  get optRegist() {
    return { label: '当社にご登録のお電話番号と同じ', value: '当社にご登録のお電話番号と同じ' };
  }

  get optOther() {
    return { label: '別の電話番号', value: '別の電話番号' };
  }

  get dispPhoneNumber(){
    return ('別の電話番号'==this.valueRadio);
  }

  changeRadioValueHandler(event) {
    this.valueRadio = event.target.value;
    let isRegistered = (this.valueRadio==this.optRegist.value)? 'On' : '';
    const payload = {componentName:'DaytimePhoneNumberRegistered' ,componentValue:isRegistered}
    this.publishToMessageChannel(payload);
    if(isRegistered=='On'){
      const payload2 = {componentName:this.itemKey ,componentValue:''}
      this.publishToMessageChannel(payload2);
    }else{
      const payload2 = {componentName:this.itemKey ,componentValue:this.value}
      this.publishToMessageChannel(payload2);
    }
  }

  changeValueHandler(event) {
    if(event.target.value.match(/^([0-9]{10,11})$/)){
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

  get stylePhoneNumber() {
    return this.dispPhoneNumber ? 'display: block;' : 'display: none;'
  }

  get dispTitle(){
    return this.dispValue;
  }
}