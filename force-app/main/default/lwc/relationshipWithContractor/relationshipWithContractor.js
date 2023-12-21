import {api} from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class RelationshipWithContractor extends PubsubExtentions {
  @api itemKey;
  // 確認画面への遷移
  confirmPhase;

  onRecivedMessage(that, message){
    if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
  }
    
  connectedCallback() {
    this.confirmPhase = false;
    this.subscribeToMessageChannel(this ,this.onRecivedMessage);
  }

  get options() {
    return [
        { label: '契約者ご本人さま', value: '契約者ご本人さま', id: this.itemKey + '_01' },
        { label: '契約者ご本人さま以外', value: '契約者ご本人さま以外', id: this.itemKey + '_02' }
    ];
  }

  // 固有部品
  value = "";

  renderedCallback() {
    const radio = this.template.querySelector('input[value="' + this.value + '"]');
    if (radio) radio.checked = true;
  }

  changeValueHandler(event) {
    this.value = event.target.value;
    const payload = {componentName:this.itemKey ,componentValue:this.value}
    this.publishToMessageChannel(payload);
  }

}