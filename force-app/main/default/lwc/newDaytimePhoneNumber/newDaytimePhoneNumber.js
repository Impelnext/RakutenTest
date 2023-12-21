import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class DaytimePhoneNumber extends PubsubExtentions {
  @api itemKey;
  @api confirmName1;
  @api confirmName2;

  dispValue = true;
  formBlankBetsu = [];
  formBlank = [];
  radioBlank = [];
  radioLabel = [];

  // 確認画面への遷移
  confirmPhase;

  value = "";
  valueRadio;
  isChanged = false;
  contactRegistered = 'On';
  registeredNumber = 'Off';

  onRecivedMessage(that, message){
    if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
    if(message.componentName == 'ContactPhoneNumberRegistered'){
      that.contactRegistered = message.componentValue;
      that.value = '';
      that.publishToMessageChannel({componentName:'DaytimePhoneNumberRegistered' ,componentValue:that.contactRegistered});
    } 
    if(message.componentName == 'RegisteredPhoneNumber') {
      that.registeredNumber = message.componentValue;
      if(that.dispRadioButton && that.valueRadio == '上記と同じ') {
        that.publishToMessageChannel({componentName:that.itemKey ,componentValue:that.registeredNumber});
      }
    }
    if(message.componentName == 'RelationshipWithContractor'){
      if(message.componentValue == 'contractor'){
        that.dispValue = true;
        that.value = "";
        that.valueRadio = '';
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
        this.formBlankBetsu = this.template.querySelectorAll('.c-form_text.tel-input1');
        if(this.formBlankBetsu[0].value == ''){
          this.formBlankBetsu[0].classList.add('blank');
        }
        this.formBlank = this.template.querySelectorAll('.c-form_text.tel-input2');
        if(this.formBlank[0].value == ''){
          this.formBlank[0].classList.add('blank');
        }
        this.radioBlank = this.template.querySelectorAll('.c-form_radio');
        this.radioLabel = this.template.querySelectorAll('.center');
        if(!this.radioBlank[0].checked && !this.radioBlank[1].checked){
          this.radioLabel[0].classList.add('blank');
          this.radioLabel[1].classList.add('blank');
        }else if(this.radioBlank[0].checked || this.radioBlank[1].checked){
          this.radioLabel[0].classList.remove('blank');
          this.radioLabel[1].classList.remove('blank');
        }  
      }
    }
  }
 

  get options() {
    return [
        { label: '当社にご登録のお電話番号と同じ', value: '当社にご登録のお電話番号と同じ' },
        { label: '別の電話番号', value: '別の電話番号' },
    ];
  }
  get dispPhoneNumber(){
    console.log('22222222');
    return ('別の電話番号'==this.valueRadio);
  }

  get stylePhoneNumber() {
    console.log('111111111');
    return '別の電話番号'==this.valueRadio ? 'display: block;' : 'display: none;'
  }

  get dispRadioButton() {
    return 'On' == this.contactRegistered;
  }

  get styleRadioButton() {
    return 'On' == this.contactRegistered ? 'display: block;' : 'display: none;';
  }

  get styleTextBox() {
    return 'On' == this.contactRegistered ? 'display: none;' : 'display: block;';
  }
  
  get dispTitle(){
    return this.dispValue;
  }

  changeRadioValueHandler(event) {

    this.valueRadio = event.target.value;
    let isRegistered = (this.dispPhoneNumber)? 'Off' : 'On';
    const payload = {componentName:'DaytimePhoneNumberRegistered' ,componentValue:isRegistered};
    this.publishToMessageChannel(payload);
    if(this.dispRadioButton && this.valueRadio == '上記と同じ') {
      const payload2 = {componentName:this.itemKey ,componentValue:this.registeredNumber};
      this.publishToMessageChannel(payload2);
    } else {
      const payload2 = {componentName:this.itemKey ,componentValue:this.value};
      this.publishToMessageChannel(payload2);
    }
  }

  changeOtherValueHandler(event) {
    if(event.target.value.match(/^([0-9]{10,11})$/)){
      this.formBlankBetsu[0].classList.remove('blank');
      this.value = event.target.value;
      const payload = {componentName:this.itemKey ,componentValue:this.value}
      this.publishToMessageChannel(payload);
    }else {
      this.formBlankBetsu[0].classList.add('blank');
      let error = this.template.querySelector('.errorMsgOther');
      error.classList.add('show');
      const payload2 = {componentName:this.itemKey ,componentValue:''}
      this.publishToMessageChannel(payload2);
      setTimeout(function(){
        error.classList.remove('show');
      }, 2000);
    }
  }

  changeValueHandler(event) {
    if(event.target.value.match(/^([0-9]{10,11})$/)){
      this.formBlank[0].classList.remove('blank');
      this.value = event.target.value;
      const payload = {componentName:this.itemKey ,componentValue:this.value}
      this.publishToMessageChannel(payload);
      const payload2 = {componentName:'DaytimePhoneNumberRegistered', componentValue:'Off'}
      this.publishToMessageChannel(payload2);
    }else {
      this.formBlank[0].classList.add('blank');
      let error = this.template.querySelector('.errorMsg');
      error.classList.add('show');
      const payload3 = {componentName:this.itemKey ,componentValue:''}
      this.publishToMessageChannel(payload3);
      setTimeout(function(){
        error.classList.remove('show');
      }, 2000);
    }
  }

}