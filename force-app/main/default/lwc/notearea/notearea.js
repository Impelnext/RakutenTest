import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';
import sitePrcResources from '@salesforce/resourceUrl/SitePrc';

export default class Notearea extends PubsubExtentions {
  @api notearea1;
  @api notearea2;

  cautionIcon = `${sitePrcResources}/template/images/icon_caution.svg`

  // 確認画面への遷移
  confirmPhase;

  onRecivedMessage(that, message){
    if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
  }
      
  connectedCallback() {
    this.confirmPhase = false;
    this.subscribeToMessageChannel(this ,this.onRecivedMessage);
  }
  
}