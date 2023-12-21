import { PubsubExtentions } from 'c/pubsubExtentions';

export default class CancelNotification extends PubsubExtentions {

    // 確認画面への遷移
    confirmPhase;

    onRecivedMessage(that, message){
        if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
    }

    connectedCallback() {
        this.confirmPhase = false;
        this.subscribeToMessageChannel(this ,this.onRecivedMessage);
    }
  
}