import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class PageGuidance extends PubsubExtentions {

    @api guideForInput;
    @api guideForConfirm;
    @api confirmPhaseKey;
    @api alignCenter;

    // 確認画面への遷移
    confirmPhase;

    connectedCallback() {
        this.confirmPhase = false;
        this.subscribeToMessageChannel(this, this.onRecivedMessage);
    }

    onRecivedMessage(that, message) {
        if(message.componentName==that.confirmPhaseKey) that.confirmPhase = message.componentValue;
    }

    get isEmptyInput() { 
        return this.guideForInput == null || this.guideForInput == '';
    }

    get isEmptyConfirm() {
        return this.guideForConfirm == null || this.guideForConfirm == '';
    }
    
}