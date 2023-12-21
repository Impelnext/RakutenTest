import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';


export default class CancelReasonAnother extends PubsubExtentions {
    value = '';
    @api itemKey;

    get options() {
        return [
	{ label: '楽天生命のサービスにご不安・不満足', value: '楽天生命のサービスにご不安・不満足', id: 'ReasonOther1' },
	{ label: 'その他', value: 'その他', id: 'ReasonOther2' },
					
        ];
    }
  
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
        const radio = this.template.querySelector('input[value="' + this.value + '"]');
        if (radio) radio.checked = true;
    }

    get dispConfirm() {
        return this.value != '' && this.confirmPhase;
    }

    changeValueHandler(event) {
        this.value = event.target.value;
        const payload = {componentName:'CancelReason3' ,componentValue:this.value};
        this.publishToMessageChannel(payload);
    }
    

}