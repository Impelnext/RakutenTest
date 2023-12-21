import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class Email extends PubsubExtentions {
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

  renderedCallback() {
    if(this.confirmPhase) this.inputs = null;
    if(!this.inputs && !this.confirmPhase) this.inputs = this.defineInputsOfValueGetterSetter(this)
  }

  // 固有部品
  value = "";

  changeValueHandler(event) {
      this.value = event.target.value;
      const payload = {componentName:this.itemKey ,componentValue:this.value}
      this.publishToMessageChannel(payload);
  }

}