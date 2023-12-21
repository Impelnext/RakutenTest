import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';
import sitePrcResources from '@salesforce/resourceUrl/SitePrc';

export default class Modpaymentmethod extends PubsubExtentions {
  @api itemKey;
  @api majorItemName;

  cautionIcon = `${sitePrcResources}/template/images/icon_caution.svg`;

  // 確認画面への遷移
  confirmPhase;

  value = "";
  valueRadio;
  valueRadioBank;

  isChanged = false;
  isChangedBank = false;

  onRecivedMessage(that, message){
    if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
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
        { label: '口座振替', value: '口座振替' },
        { label: 'クレジットカード払い', value: 'クレジットカード払い' },
    ];
  }

  get dispNote() {
    return this.valueRadio == 'クレジットカード払い';
  }

  changeRadioValueHandlerPaymentMethod(event) {
    this.valueRadio = event.target.value;
    const payload = {componentName:this.itemKey ,componentValue:this.valueRadio}
    this.publishToMessageChannel(payload);
  }

}