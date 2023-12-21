import {api} from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class LastNameFirstNameFurigana extends PubsubExtentions {
  @api itemKeySei;
  @api itemKeyMei;

  // 確認画面への遷移
  confirmPhase;

  // 固有部品
  lastNameKana = "";
  firstNameKana = "";

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

  changeHandlerForLastName(event) {
      this.lastNameKana = event.target.value;
      const payload = {componentName:this.itemKeySei ,componentValue:this.lastNameKana}
      this.publishToMessageChannel(payload);
  }

  changeHandlerForFirstName(event) {
      this.firstNameKana = event.target.value;
      const payload = {componentName:this.itemKeyMei ,componentValue:this.firstNameKana}
      this.publishToMessageChannel(payload);
  }
}