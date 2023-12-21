import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class Modcontractorlabel extends PubsubExtentions {

    @api itemName;
    @api itemGuide;
    @api itemGuide2;
    @api confirmPhaseKey;

    // 確認画面への遷移
    confirmPhase;

    get dispGuide2() {
        return this.itemGuide2 != null && this.itemGuide2 != '';
    }

    connectedCallback() {
        this.confirmPhase = false;
        this.subscribeToMessageChannel(this ,this.onRecivedMessage);
    }

    onRecivedMessage(that, message){
        if (message.componentName == that.confirmPhaseKey) that.confirmPhase = message.componentValue;
    }

}