import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class PageTitle extends PubsubExtentions {

    @api titleForInput;
    @api titleForConfirm;
    @api confirmPhaseKey;

    // 確認画面への遷移
    confirmPhase;
    originalTitle; 

    connectedCallback() {
        this.confirmPhase = false;
        this.subscribeToMessageChannel(this ,this.onRecivedMessage);
        this.originalTitle = document.title;
    }

    onRecivedMessage(that, message){
        if(message.componentName==that.confirmPhaseKey) that.confirmPhase = message.componentValue;
        if(that.confirmPhase ){
          document.title = that.titleForConfirm
        }else{
          if(that.originalTitle) document.title = that.originalTitle
        }
    }
    
}