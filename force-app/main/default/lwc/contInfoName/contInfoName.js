import {api} from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class ContInfoName extends PubsubExtentions {
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

    get dispNote() {
        return this.itemNote != null && this.itemNote != '';
    }

    // 固有部品
    lastName = "";
    firstName = "";

    changeHandlerForLastName(event) {
        this.lastName = event.target.value;
        const payload = {componentName:this.itemKeySei ,componentValue:this.lastName}
        this.publishToMessageChannel(payload);
    }

    changeHandlerForFirstName(event) {
        this.firstName = event.target.value;
        const payload = {componentName:this.itemKeyMei ,componentValue:this.firstName}
        this.publishToMessageChannel(payload);
    }
}