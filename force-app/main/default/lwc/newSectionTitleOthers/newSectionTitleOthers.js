import {api} from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class SearchResults extends PubsubExtentions {

  @api title;
  @api confirmPhaseKey;
  @api contractorCheckKey;
  @api otherCheckKey;
  @api noTopMargin;

  dispValue = false;


  // 確認画面への遷移
  confirmPhase;

  connectedCallback() {
    this.confirmPhase = false;
    this.subscribeToMessageChannel(this ,this.onRecivedMessage);
  }

  onRecivedMessage(that, message){
    if(message.componentName==that.confirmPhaseKey) that.confirmPhase = message.componentValue;
    if(message.componentName == 'RelationshipWithContractor'){
      if(message.componentValue == 'others1' || message.componentValue == 'others2' || message.componentValue == 'others3'){
        that.dispValue = true;
      }else {
        that.dispValue = false;
      }
    }
  }

  get marginClass() {
    if (this.noTopMargin) {
      return 'c-ttl_sec no_top_margin';
    } else {
      return 'c-ttl_sec';
    }
  }

  get dispTitle(){
    return this.dispValue;
  }

}