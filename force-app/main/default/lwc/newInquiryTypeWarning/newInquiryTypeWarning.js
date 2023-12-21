import { LightningElement, wire, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { PubsubExtentions } from 'c/pubsubExtentions';


//export default class InquiryType extends LightningElement {
export default class InquiryType extends PubsubExtentions {
  // 確認画面への遷移
  confirmPhase;
  itemId;

  connectedCallback() {
    this.confirmPhase = false;
    this.subscribeToMessageChannel(this ,this.onRecivedMessage);
    this.typeOptions = this.getTypeOptionsFromUrlParameter(this.company);
  }

  onRecivedMessage(that, message){
    if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
  }

  /* Params from Url */
  currentPageReference = null;
  urlStateParameters = null;

  company = null;
  @api itemKey;
  @api typeSelectionLife;
  @api typeSelectionGen;
  @api typeSelectionPet;
  value = '';
  typeOptions;

  @wire(CurrentPageReference)
  getStateParameters(currentPageReference) {
     if (currentPageReference) {
        this.urlStateParameters = currentPageReference.state;
        this.setParametersBasedOnUrl();
     }
  }

  setParametersBasedOnUrl() {
    this.company = this.urlStateParameters.company || null;
  }

  getTypeOptionsFromUrlParameter(param){
    return param=='life' ? this.getOptionsFromArray(this.typeSelectionLife)
         : param=='gen' ? this.getOptionsFromArray(this.typeSelectionGen)
         : param=='pet' ? this.getOptionsFromArray(this.typeSelectionPet)
         : this.getOptionsFromArray(this.typeSelectionLife);
  }
  getOptionsFromArray(str){
    let ret = []
    //if(str) str.split(',').map(key=>{ret.push({label:key ,value: key})})
    if(str) str.split(',').map((key, idx)=>{ret.push({label:key ,value: key, id:this.itemKey + '_0' + (idx + 1)})});
    return ret;
  }

  get sonpo() {
    if(this.company =='gen'){
      return this.company
    }
  }
}