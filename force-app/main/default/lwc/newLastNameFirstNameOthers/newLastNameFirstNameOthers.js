import {api} from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class LastNameFirstName extends PubsubExtentions {
    @api itemKeySei;
    @api itemKeyMei;

    dispValue = false;
    formBlank = [];

    // 確認画面への遷移
    confirmPhase;

    onRecivedMessage(that, message){
      if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
      if(message.componentName == 'RelationshipWithContractor'){
        if(message.componentValue == 'others1' || message.componentValue == 'others2' || message.componentValue == 'others3'){
          that.dispValue = true;
          that.lastName = "";
          that.firstName = "";      
        }else {
          that.dispValue = false;
        }
      }
    }

    connectedCallback() {
      this.confirmPhase = false;
      this.subscribeToMessageChannel(this ,this.onRecivedMessage);
    }

    renderedCallback() {
      if(!this.confirmPhase){
        if(this.dispValue){
          this.formBlank = this.template.querySelectorAll('.c-form_text');
          if (this.formBlank[0].value == ''){
            this.formBlank[0].classList.add('blank');
          }
          if(this.formBlank[1].value == ''){
            this.formBlank[1].classList.add('blank');
          }
        }
      }
    }

    // 固有部品
    lastName = "";
    firstName = "";

    changeHandlerForLastName(event) {
      if(event.target.value.match(/^[^\x01-\x7E\uFF61-\uFF9F]+$/)){
        this.formBlank[0].classList.remove('blank');
        this.lastName = event.target.value;
        const payload = {componentName:this.itemKeySei ,componentValue:this.lastName}
        this.publishToMessageChannel(payload);
      }else {
        let error = this.template.querySelector('.errorMsgSei');
        error.classList.add('show');
        this.formBlank[0].classList.add('blank');
        const payload2 = {componentName:this.itemKeySei ,componentValue:''}
        this.publishToMessageChannel(payload2);  
        setTimeout(function(){
          error.classList.remove('show');
        }, 2000);
      }
    }

    changeHandlerForFirstName(event) {
      if(event.target.value.match(/^[^\x01-\x7E\uFF61-\uFF9F]+$/)){
        this.formBlank[1].classList.remove('blank');
        this.firstName = event.target.value;
        const payload = {componentName:this.itemKeyMei ,componentValue:this.firstName}
        this.publishToMessageChannel(payload);
      }else {
        let error = this.template.querySelector('.errorMsgMei');
        error.classList.add('show');
        this.formBlank[1].classList.add('blank');
        const payload2 = {componentName:this.itemKeyMei ,componentValue:''}
        this.publishToMessageChannel(payload2);  
        setTimeout(function(){
          error.classList.remove('show');
        }, 2000);
      }
    }

    get dispTitle(){
      return this.dispValue;
    }
}