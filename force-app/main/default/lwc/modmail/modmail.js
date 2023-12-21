import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class Modmail extends PubsubExtentions {
  @api itemKey;
  @api itemkeyCheckBox;

  // 確認画面への遷移
  confirmPhase;

  value = "";
  valueCheckBox;
  isChanged = false;
  checkedCheckBox;
  
  
  onRecivedMessage(that, message){
    if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
  }

  connectedCallback() {
      this.confirmPhase = false;
      this.subscribeToMessageChannel(this ,this.onRecivedMessage);
  }

  renderedCallback() {
    const chkbox = this.template.querySelector('input[type="checkbox"]');
    if (chkbox) chkbox.checked = this.valueCheckBox;

    if(this.confirmPhase) this.inputs = null;
    if(!this.inputs && !this.confirmPhase) this.inputs = this.defineInputsOfValueGetterSetter(this)
  }

  get dispModMail(){
    return (true==this.valueCheckBox);
  }

  get styleModMail(){
    return this.dispModMail ? 'display: block;' : 'display: none;'
  }

  changeCheckBoxValueHandler(event) {
    this.valueCheckBox = event.target.checked;
    this.checkedCheckBox = this.valueCheckBox;

    const payload = {componentName:this.itemkeyCheckBox ,componentValue:this.valueCheckBox}
    this.publishToMessageChannel(payload);
    if (this.dispModMail) {
      this.publishToMessageChannel({componentName:this.itemKey ,componentValue:this.value});
    } else {
      this.publishToMessageChannel({componentName:this.itemKey ,componentValue:''});
    }
  }

  changeValueHandler(event) {
      this.value = event.target.value;
      const payload = {componentName:this.itemKey ,componentValue:this.value}
      this.publishToMessageChannel(payload);
  }

}