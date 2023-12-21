import {api} from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class SearchResults extends PubsubExtentions {

  @api title;
  @api confirmPhaseKey;
  @api noTopMargin;

  // 確認画面への遷移
  confirmPhase;

  connectedCallback() {
    this.confirmPhase = false;
    this.subscribeToMessageChannel(this ,this.onRecivedMessage);
  }

  onRecivedMessage(that, message){
    if(message.componentName==that.confirmPhaseKey) that.confirmPhase = message.componentValue;
  }

  get marginClass() {
    if (this.noTopMargin) {
      return 'c-ttl_sec no_top_margin';
    } else {
      return 'c-ttl_sec';
    }
  }
}