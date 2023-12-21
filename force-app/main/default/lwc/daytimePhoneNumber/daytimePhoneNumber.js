import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class DaytimePhoneNumber extends PubsubExtentions {
  @api itemKey;
  @api confirmName1;
  @api confirmName2;
  // 確認画面への遷移
  confirmPhase;

  value = "";
  valueRadio;
  isChanged = false;
  contactRegistered = 'On';
  registeredNumber = '';

  onRecivedMessage(that, message){
    if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
    if(message.componentName == 'ContactPhoneNumberRegistered') that.contactRegistered = message.componentValue;
    if(message.componentName == 'RegisteredPhoneNumber') {
      that.registeredNumber = message.componentValue;
      if(that.dispRadioButton && that.valueRadio == '上記と同じ') {
        that.publishToMessageChannel({componentName:that.itemKey ,componentValue:that.registeredNumber});
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
  }
 

  get options() {
    return [
        { label: '当社にご登録のお電話番号と同じ', value: '当社にご登録のお電話番号と同じ' },
        { label: '別の電話番号', value: '別の電話番号' },
    ];
  }
  get dispPhoneNumber(){
    return ('別の電話番号'==this.valueRadio);
  }

  get stylePhoneNumber() {
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

  changeRadioValueHandler(event) {
    this.valueRadio = event.target.value;
    let isRegistered = (this.dispPhoneNumber)? 'On' : '';
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

  changeValueHandler(event) {
      this.value = event.target.value;
      const payload = {componentName:this.itemKey ,componentValue:this.value}
      this.publishToMessageChannel(payload);
  }

}