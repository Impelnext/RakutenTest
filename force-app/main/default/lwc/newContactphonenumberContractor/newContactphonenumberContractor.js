import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class DaytimePhoneNumber extends PubsubExtentions {
  @api itemKey;
  @api majorItemName
  @api itemName1
  @api itemName2
  @api confirmName1;
  @api confirmName2;

  dispValue = true;
  formBlank = [];

  // 確認画面への遷移
  confirmPhase;

  value = "";
  valueRadio = "";
  isChanged = false;

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
    if (this.valueRadio == '') {
      this.valueRadio = this.itemName1;
      this.publishToMessageChannel({componentName:'ContactPhoneNumberRegistered' ,componentValue:'On'});
    }
    const radio = this.template.querySelector('input[value="' + this.valueRadio + '"]');
    if (radio) radio.checked = true;
  }
 
  get options() {
    return [
        { label: this.itemName1, value: this.itemName1 },
        { label: this.itemName2, value: this.itemName2 },
    ];
  }
  get dispPhoneNumber(){
    return (this.itemName1==this.valueRadio);
  }
  get stylePhoneNumber(){
    return this.dispPhoneNumber ? 'display: block;' : 'display: none;'
  }

  get dispTitle(){
    return this.dispValue;
  }

  changeRadioValueHandler(event) {
    this.valueRadio = event.target.value;
    let isRegistered = (this.valueRadio == this.itemName1)? 'On' : 'Off';
    const payload = {componentName:'ContactPhoneNumberRegistered' ,componentValue:isRegistered}
    this.publishToMessageChannel(payload);
    if(this.valueRadio == this.itemName1){
      const payload2 = {componentName:this.itemKey ,componentValue:this.value}
      this.publishToMessageChannel(payload2);
    }else{
      this.value = '';
      const payload2 = {componentName:this.itemKey ,componentValue:'Off'}
      this.publishToMessageChannel(payload2);
      const payload3 = {componentName:'DaytimePhoneNumber' ,componentValue:''}
      this.publishToMessageChannel(payload3);
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

}