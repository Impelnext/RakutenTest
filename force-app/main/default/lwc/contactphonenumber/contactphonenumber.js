import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class DaytimePhoneNumber extends PubsubExtentions {
  @api itemKey;
  @api majorItemName
  @api itemName1
  @api itemName2
  @api confirmName1;
  @api confirmName2;
  // 確認画面への遷移
  confirmPhase;

  value = "";
  valueRadio = "";
  isChanged = false;

  onRecivedMessage(that, message){
    if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
  }
    
  connectedCallback() {
      this.confirmPhase = false;
      this.subscribeToMessageChannel(this ,this.onRecivedMessage);
  }

  renderedCallback() {
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

  changeRadioValueHandler(event) {
    this.valueRadio = event.target.value;
    let isRegistered = (this.valueRadio == this.itemName1)? 'On' : '';
    const payload = {componentName:'ContactPhoneNumberRegistered' ,componentValue:isRegistered}
    this.publishToMessageChannel(payload);
    if(this.valueRadio == this.itemName1){
      const payload2 = {componentName:this.itemKey ,componentValue:this.value}
      this.publishToMessageChannel(payload2);
    }else{
      const payload2 = {componentName:this.itemKey ,componentValue:''}
      this.publishToMessageChannel(payload2);
    }
  }

  changeValueHandler(event) {
      this.value = event.target.value;
      const payload = {componentName:this.itemKey ,componentValue:this.value}
      this.publishToMessageChannel(payload);
  }

}