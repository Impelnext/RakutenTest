import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class ReissueYears extends PubsubExtentions {
  

  @api itemKey
  @api reissueYear01
  @api reissueYear02
  @api reissueYear03
  @api reissueYear04
  @api reissueYear05

  // 確認画面への遷移
  confirmPhase;
  valueCheck1 = '';
  valueCheck2 = '';
  valueCheck3 = '';
  valueCheck4 = '';
  valueCheck5 = '';

  onRecivedMessage(that, message){
    if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
  }

  connectedCallback() {
    this.confirmPhase = false;
    this.subscribeToMessageChannel(this ,this.onRecivedMessage);
  }

  renderedCallback() {
    const chk1 = this.template.querySelector('input[value="' + this.reissueYear01 + '"]');
    if (chk1) chk1.checked = (this.valueCheck1 == this.reissueYear01);
    const chk2 = this.template.querySelector('input[value="' + this.reissueYear02 + '"]');
    if (chk2) chk2.checked = (this.valueCheck2 == this.reissueYear02);
    const chk3 = this.template.querySelector('input[value="' + this.reissueYear03 + '"]');
    if (chk3) chk3.checked = (this.valueCheck3 == this.reissueYear03);
    const chk4 = this.template.querySelector('input[value="' + this.reissueYear04 + '"]');
    if (chk4) chk4.checked = (this.valueCheck4 == this.reissueYear04);
    const chk5 = this.template.querySelector('input[value="' + this.reissueYear05 + '"]');
    if (chk5) chk5.checked = (this.valueCheck5 == this.reissueYear05);
  }

  /*
  changeValueHandler(event) {
    this.value = event.target.value;

    console.log(this.value);
    console.log('checked',event.target.checked);
    //const payload = {componentName:this.itemKey ,componentValue:this.value}
    //this.publishToMessageChannel(payload);
  }
  */

  changeValueHandler1(event) {
    if (event.target.checked) {
      this.valueCheck1 = event.target.value;
    } else {
      this.valueCheck1 = '';
    }

    const payload = {componentName:this.itemKey ,componentValue:this.valueCheck1}
    this.publishToMessageChannel(payload);
  }

  changeValueHandler2(event) {
    if (event.target.checked) {
      this.valueCheck2 = event.target.value;
    } else {
      this.valueCheck2 = '';
    }

    const payload = {componentName:'InfoReissueYear2' ,componentValue:this.valueCheck2}
    this.publishToMessageChannel(payload);
  }

  changeValueHandler3(event) {
    if (event.target.checked) {
      this.valueCheck3 = event.target.value;
    } else {
      this.valueCheck3 = '';
    }

    const payload = {componentName:'InfoReissueYear3' ,componentValue:this.valueCheck3}
    this.publishToMessageChannel(payload);
  }

  changeValueHandler4(event) {
    if (event.target.checked) {
      this.valueCheck4 = event.target.value;
    } else {
      this.valueCheck4 = '';
    }

    const payload = {componentName:'InfoReissueYear4' ,componentValue:this.valueCheck4}
    this.publishToMessageChannel(payload);
  }

  changeValueHandler5(event) {
    if (event.target.checked) {
      this.valueCheck5 = event.target.value;
    } else {
      this.valueCheck5 = '';
    }

    const payload = {componentName:'InfoReissueYear5' ,componentValue:this.valueCheck5}
    this.publishToMessageChannel(payload);
  }

  get disp1(){
    return (this.valueCheck1 != '');
  }

  get disp2(){
    return (this.valueCheck2 != '');
  }

  get disp3(){
    return (this.valueCheck3 != '');
  }

  get disp4(){
    return (this.valueCheck4 != '');
  }

  get disp5(){
    return (this.valueCheck5 != '');
  }


}