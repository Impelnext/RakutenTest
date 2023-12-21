import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class cancelContractType extends PubsubExtentions  {
    value = '';
    @api itemKey;

    get options() {
        return [
            { label: '生命保険契約のみ', value: '生命保険契約のみ', id:'CancelType1' },
            { label: '共済契約のみ', value: '共済契約のみ', id:'CancelType2' },
            { label: '生命保険契約と共済契約の両契約', value: '生命保険契約と共済契約の両契約', id:'CancelType3' },
        ];
    }

    InsuranceValue = false;
    ProductValue = false;
    BothValue = false;

    handleRadioChange(event) {
        const selectedOption = event.target.value;
        this.value=selectedOption

        if(selectedOption == '生命保険契約のみ'){
            this.InsuranceValue = true;
        }else{
            this.InsuranceValue = false;
        }

        if(selectedOption == '共済契約のみ'){
            this.ProductValue = true;
        }else{
            this.ProductValue = false;
        }
        
        if(selectedOption == '生命保険契約と共済契約の両契約'){
            this.BothValue = true;
        }else{
            this.BothValue = false;
        }
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
        const rdo = this.template.querySelector('input[value="' + this.value + '"]');
        if (rdo) rdo.checked = true;
     }

     changeRadioHandler(event) {
        this.value = event.target.value;
        if (this.value == '生命保険契約のみ') {
            this.publishToMessageChannel({componentName:'CancelInsurance' ,componentValue:true});
            this.publishToMessageChannel({componentName:'CancelProduct' ,componentValue:false});
        } else if (this.value == '共済契約のみ') {
            this.publishToMessageChannel({componentName:'CancelInsurance' ,componentValue:false});
            this.publishToMessageChannel({componentName:'CancelProduct' ,componentValue:true});
        } else if (this.value == '生命保険契約と共済契約の両契約') {
            this.publishToMessageChannel({componentName:'CancelInsurance' ,componentValue:true});
            this.publishToMessageChannel({componentName:'CancelProduct' ,componentValue:true});
        }
     }
}