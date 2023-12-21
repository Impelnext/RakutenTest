import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class Modname extends PubsubExtentions {
  @api itemKeyName;
  @api itemKeyNameKana;
  @api itemkeyCheckBox;
  @api confirmSection;

  // 確認画面への遷移
  confirmPhase;

  valueCheckBox;
  checkedCheckBox;
  isChanged = false;

  onRecivedMessage(that, message){
    if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
  }
    
  connectedCallback() {
      this.valueName = "";
      this.valueNameKana = "";

      this.confirmPhase = false;
      this.subscribeToMessageChannel(this ,this.onRecivedMessage);
  }

  renderedCallback() {
    const chkbox = this.template.querySelector('input[type="checkbox"]');
    if (chkbox) chkbox.checked = this.checkedCheckBox;

    if(this.confirmPhase) this.inputs = null;
    if(!this.inputs && !this.confirmPhase) this.inputs = this.defineInputsOfValueGetterSetter(this)
  }

  get dispName(){
    return (true==this.valueCheckBox);
  }
  get styleName(){
    return this.dispName ? 'display: block;' : 'display: none;'
  }
  
  get dispSection() {
    return (this.confirmSection != null && this.confirmSection != '');
  }

  changeCheckBoxValueHandler(event) {
    this.valueCheckBox = event.target.checked;
    this.checkedCheckBox = this.valueCheckBox;

    const payload = {componentName:this.itemkeyCheckBox ,componentValue:this.valueCheckBox}
    this.publishToMessageChannel(payload);
    if (this.dispName) {
      this.publishToMessageChannel({componentName:this.itemKeyName ,componentValue:this.valueName});
      this.publishToMessageChannel({componentName:this.itemKeyNameKana ,componentValue:this.valueNameKana});
    } else {
      this.publishToMessageChannel({componentName:this.itemKeyName ,componentValue:''});
      this.publishToMessageChannel({componentName:this.itemKeyNameKana ,componentValue:''});
    }
  }

  changeValueHandlerName(event) {
      this.valueName = event.target.value;
      const payload = {componentName:this.itemKeyName ,componentValue:this.valueName};
      this.publishToMessageChannel(payload);
  }

  changeValueHandlerNameKana(event) {
    this.valueNameKana = event.target.value;
    const payload = {componentName:this.itemKeyNameKana ,componentValue:this.valueNameKana};
    this.publishToMessageChannel(payload);
  }

}