import {api} from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class ContInfoNameFurigana extends PubsubExtentions {
  @api itemKeySei;
  @api itemKeyMei;
  @api itemNote;

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

  get dispNote() {
    return this.itemNote != null && this.itemNote != '';
  }

  // 固有部品
  lastNameKana = "";
  firstNameKana = "";

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