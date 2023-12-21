import { wire, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class ContentsOfInquiry extends PubsubExtentions {
  @api itemKey;
  @api itemKeyInquiryType;
  @api placeholderMapByInquiryTypeForLife;
  @api placeholderMapByInquiryTypeForGen;
  @api placeholderMapByInquiryTypeForPet;

  // 確認画面への遷移
  confirmPhase;

  value = "";
  placeholderMapByInquiryType;
  placeholder="";

  connectedCallback() {
    this.confirmPhase = false;
    this.subscribeToMessageChannel(this ,this.onRecivedMessage);
  }

  onRecivedMessage(that, message){
    if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
    if(message.componentName==that.itemKeyInquiryType && 
      message.componentValue in that.placeholderMapByInquiryType
      ) that.placeholder = that.placeholderMapByInquiryType[message.componentValue];
  }

  /* URL Parameter */
  @wire(CurrentPageReference)
  getStateParameters(currentPageReference) {
     if (currentPageReference) {
        this.urlStateParameters = currentPageReference.state;
        this.setParametersBasedOnUrl();
     }
  }

  setParametersBasedOnUrl() {
    this.company = this.urlStateParameters.company || null;
    this.placeholderMapByInquiryType = this.getPlaceholderMapFromUrlParameter(this.company)
    console.log('##placeholderMapByInquiryType', this.placeholderMapByInquiryType)
  }

  getPlaceholderMapFromUrlParameter(param){
    return param=='life' ? this.getPlaceholderMapFromSetting(this.placeholderMapByInquiryTypeForLife)
         : param=='gen' ? this.getPlaceholderMapFromSetting(this.placeholderMapByInquiryTypeForGen)
         : param=='pet' ? this.getPlaceholderMapFromSetting(this.placeholderMapByInquiryTypeForPet)
         : this.getPlaceholderMapFromSetting(this.placeholderMapByInquiryTypeForLife);
  }

  getPlaceholderMapFromSetting(str){
    let ret = {}
    if(str) str.split(',').map(item=>{ret[item.split(':')[0]]=item.split(':')[1]})
    return ret;
  }

  /* Handler */
  changeValueHandler(event) {
      this.value = event.target.value;
      const payload = {componentName:this.itemKey ,componentValue:this.value}
      this.publishToMessageChannel(payload);
  }

  onfocusout(event){
    console.log('### onfocusout');
    const payload = {componentName:this.itemKey ,componentValue:this.value, componentStatus: 'focusout'}
    this.publishToMessageChannel(payload);
  }

  get errorMessage(){
    return this.errorCheckRequired() ? 'お名前（漢字）「姓」を入力してください。'
    : this.errorCheckCharactor() ? 'お名前（カナ）「セイ」に使用できない文字（一部の漢字、ローマ数字など）が含まれています。'
    : null;
  }

  errorCheckRequired(){
    return false;
  }

  errorCheckCharactor(){
    return false;
  }
}