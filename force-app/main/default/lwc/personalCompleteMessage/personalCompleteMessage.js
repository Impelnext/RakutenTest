import { LightningElement } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class PersonalCompleteMessage extends LightningElement {
  onClickClose(){
    //window.close();
    console.log('###onClickClose')
    this.dispatchEvent(new CloseActionScreenEvent());

  }
}