import { LightningElement, wire } from 'lwc';
import { publish,subscribe, MessageContext, APPLICATION_SCOPE } from "lightning/messageService";
import COMPOMESSAGECHANNEL from "@salesforce/messageChannel/componentValueChannel__c";

export default class PubsubExtentions extends LightningElement {
  message;

  @wire(MessageContext)
  messageContext;

  subscribeToMessageChannel(that, callback) {
    if (!this.subscription) {
        this.subscription = subscribe(
            this.messageContext,
            COMPOMESSAGECHANNEL,
            (message) => {this.message = message; callback(that, message)},
            { scope: APPLICATION_SCOPE }
        );
    }
  }

  publishToMessageChannel(payload) {
    publish(this.messageContext, COMPOMESSAGECHANNEL, payload);
  }
  
  defineInputsOfValueGetterSetter(that){
    const inputs = that.template.querySelectorAll('input');
    
    if(inputs){
      inputs.forEach(elem => this.defineValue(elem))
    }
    return inputs
  }
  
  defineValue(elem){
    const { set: originalSet } = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value');
    const { get: originalGet } = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value');
    const changeEvent = new Event('change')
    
    if(elem){
      Object.defineProperty(elem, 'value', {
        get() {
          return originalGet.call(this);
        },
        set(value) {
          let rtn = originalSet.call(this, value);
          elem.dispatchEvent(changeEvent)
          return rtn;
        }
      });
    }
    return elem
  }

}

export {PubsubExtentions}