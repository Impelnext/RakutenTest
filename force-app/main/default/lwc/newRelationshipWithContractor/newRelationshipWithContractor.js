import {api} from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class RelationshipWithContractor extends PubsubExtentions {
  @api itemKey;
  // 確認画面への遷移
  confirmPhase;

  onRecivedMessage(that, message){
    if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
  }

  connectedCallback() {
    this.confirmPhase = false;
    this.subscribeToMessageChannel(this ,this.onRecivedMessage);
  }

  get options() {
    return [
        { label: '契約者ご本人さま', value: 'contractor', checked: 'checked', id: this.itemKey + '_01' },
        { label: '被保険者さま（保障、補償の対象の方）', value: 'others1', id: this.itemKey + '_02' },
        { label: 'ご親族さま（配偶者、子、親、兄弟姉妹）', value: 'others2', id: this.itemKey + '_03' },
        { label: 'その他（代理店さま、開示指定者さまなど）', value: 'others3', id: this.itemKey + '_04' }
    ];
  }

  // 固有部品
  value = "contractor";
  dispLabel = "契約者ご本人さま";

  renderedCallback() {
    const radio = this.template.querySelector('input[value="' + this.value + '"]');
    if (radio) radio.checked = true;
  }

  changeValueHandler(event) {
    this.value = event.target.value;
    if(this.value == 'contractor'){
      this.dispLabel = "契約者ご本人さま";
    }else if(this.value == 'others1'){
      this.dispLabel = "被保険者さま（保障、補償の対象の方）";
    }else if(this.value == 'others2'){
      this.dispLabel = "ご親族さま（配偶者、子、親、兄弟姉妹）";
    }else if(this.value == 'others3'){
      this.dispLabel = "その他（代理店さま、開示指定者さまなど）";
    }
    const payload = {componentName:this.itemKey ,componentValue:this.value}
    this.publishToMessageChannel(payload);
    const payload2 = {componentName:'RelationshipWithContractor', componentValue:this.value}
    this.publishToMessageChannel(payload2);
  }

}