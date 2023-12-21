import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class ReturnPageTop extends PubsubExtentions {

    @api labelForInput;
    @api labelForConfirm;
    @api confirmPhaseKey;

    // 確認画面への遷移
    confirmPhase;

    get dispInput() {
        return this.labelForInput != null && this.labelForInput != '';
    }

    get dispConfirm() {
        return this.labelForConfirm != null && this.labelForConfirm != '';
    }

    connectedCallback() {
        this.confirmPhase = false;
        this.subscribeToMessageChannel(this ,this.onRecivedMessage);
    }

    onRecivedMessage(that, message){
        if(message.componentName==that.confirmPhaseKey) that.confirmPhase = message.componentValue;
    }

    moveToTop() {
        const scrollOptions = {
            left: 0,
            top: 0,
            //behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);
    }
    
}