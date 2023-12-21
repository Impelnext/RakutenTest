import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';
//import inquiryResources from '@salesforce/resourceUrl/policynumber';

export default class Policynumber extends PubsubExtentions {
  @api itemKeyPolicyNumber;
  @api majorItemName

  // 確認画面への遷移
  confirmPhase;

  value = "";

  majorItemName = "";
/*
	appResources = {
		policyNumberIcon: `${inquiryResources}/policynumber.png`
	};
*/

  get disp(){

    return ('ご契約の証券番号'==this.majorItemName);

  }

  onRecivedMessage(that, message){
    if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
  }
    
  connectedCallback() {
      this.confirmPhase = false;
      this.subscribeToMessageChannel(this ,this.onRecivedMessage);
  }

  changeValueHandlerPolicyNumber(event) {
    this.valuePolicyNumber = event.target.value;
    const payload = {componentName:this.itemKeyPolicyNumber ,componentValue:this.valuePolicyNumber}
    this.publishToMessageChannel(payload);
  }
}