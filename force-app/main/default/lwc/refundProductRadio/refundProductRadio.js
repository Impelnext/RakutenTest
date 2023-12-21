import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';
import sitePrcResources from '@salesforce/resourceUrl/SitePrc';


export default class RefundProductRadio extends PubsubExtentions {
    value = '';
    @api itemKey;

    get options() {
        return [
            { label: '契約がある', value: '契約がある', id: 'refundProduct1' },
            { label: '契約がない', value: '契約がない', id: 'refundProduct2' },		
        ];
    }

    // 確認画面への遷移
    confirmPhase;
    refundCreditCard;
    containerClass;

    get dispInput() {
        return !this.confirmPhase && this.refundCreditCard != '';
    }
    get styleInput() {
      return this.dispInput ? 'display: block;' : 'display: none;'
    }

    openModal() {
        this.containerClass = 'form-modal modal-container active';
    }

    closeModal() {
        this.containerClass = 'form-modal modal-container';
    }

    clickDialog(event) {
        event.stopPropagation();
    }
  
    onRecivedMessage(that, message){
      if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
      if(message.componentName=='CreditCardRadio') that.refundCreditCard = message.componentValue;

    }
      
    connectedCallback() {
        this.confirmPhase = false;
        this.refundCreditCard = '';
        this.containerClass = 'form-modal modal-container';
        this.subscribeToMessageChannel(this ,this.onRecivedMessage);
    }

    renderedCallback() {
        const rdo = this.template.querySelector('input[value="' + this.value + '"]');
        if (rdo) rdo.checked = true;
     }

    changeRadioHandler(event) {
        this.value = event.target.value;
        const payload = {componentName:'ConfRefundProductNote' ,componentValue:this.value == '契約がある'}
        this.publishToMessageChannel(payload);
        this.publishToMessageChannel({componentName:'RefundProductRadio' ,componentValue:this.value});
    }

}