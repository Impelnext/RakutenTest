import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class Modtelnumber extends PubsubExtentions {
  @api itemKeyTelNumber;
  @api itemKeyCellPhoneNumber;
  @api itemkeyCheckBox;
  @api confirmSection;

  // 確認画面への遷移
  confirmPhase;

  value = "";

  valueTelNumber = "";
  valueCellPhoneNumber = "";

  valueCheckBox;
  checkedCheckBox;
  valuePhoneRadio;
  valueMobileRadio;
  isChanged = false;

  PHONE_NO_USE = '0000000000'

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
    const radio1 = this.template.querySelector('.phone_list input[value="' + this.valuePhoneRadio + '"]');
    if (radio1) radio1.checked = true;
    const radio2 = this.template.querySelector('.mobile_phone_list input[value="' + this.valueMobileRadio + '"]');
    if (radio2) radio2.checked = true;
  }

  get dispTelNumber(){
    return (true==this.valueCheckBox);
  }

  get styleTelNumber(){
    return this.dispTelNumber ? 'display: block;' : 'display: none;'
  }

  get dispPhoneNumber() {
    return (this.valuePhoneRadio == '変更・登録する');
  }

  get dispMobileNumber() {
    return (this.valueMobileRadio == '変更・登録する');
  }

  get dispError() {
    return (this.valuePhoneRadio == 'ご自宅電話番号の利用なし' && this.valueMobileRadio == '携帯電話番号の利用なし');
  }

  get dispSection() {
    return (this.confirmSection != null && this.confirmSection != '');
  }

  get disabledPhone() {
    return (this.valueMobileRadio == '携帯電話番号の利用なし');
  }

  get disabledMobilePhone() {
    return (this.valuePhoneRadio == 'ご自宅電話番号の利用なし');
  }

  isPhoneNoUse(valueRadio){
    return (valueRadio == 'ご自宅電話番号の利用なし' || valueRadio == '携帯電話番号の利用なし');
  }

  changeCheckBoxValueHandler(event) {
    this.valueCheckBox = event.target.checked;
    this.checkedCheckBox = this.valueCheckBox;

    const payload = {componentName:this.itemkeyCheckBox ,componentValue:this.valueCheckBox}
    this.publishToMessageChannel(payload);

    if (this.valueCheckBox) {
      if (this.dispPhoneNumber) {
        this.publishToMessageChannel({componentName:this.itemKeyTelNumber ,componentValue:this.valueTelNumber});
      } else {
        this.publishToMessageChannel({componentName:this.itemKeyTelNumber ,componentValue:''});
      }
      if (this.dispMobileNumber) {
        this.publishToMessageChannel({componentName:this.itemKeyCellPhoneNumber ,componentValue:this.valueCellPhoneNumber});
      } else {
        this.publishToMessageChannel({componentName:this.itemKeyCellPhoneNumber ,componentValue:''});
      }
    } else {
      this.publishToMessageChannel({componentName:this.itemKeyTelNumber ,componentValue:''});
      this.publishToMessageChannel({componentName:this.itemKeyCellPhoneNumber ,componentValue:''});
    }
  }

  changeRadioPhoneValueHandler(event) {
    this.valuePhoneRadio = event.target.value;
    if (this.dispPhoneNumber) {
      this.publishToMessageChannel({componentName:this.itemKeyTelNumber ,componentValue:this.valueTelNumber});
    } else {
      this.publishToMessageChannel({componentName:this.itemKeyTelNumber ,
                                    componentValue: (this.isPhoneNoUse(this.valuePhoneRadio)) ? this.PHONE_NO_USE : ''
                                  });
    }
  }

  changeRadioMobileValueHandler(event) {
    this.valueMobileRadio = event.target.value;
    if (this.dispMobileNumber) {
      this.publishToMessageChannel({componentName:this.itemKeyCellPhoneNumber ,componentValue:this.valueCellPhoneNumber});
    } else {
      this.publishToMessageChannel({componentName:this.itemKeyCellPhoneNumber  ,
                                    componentValue: (this.isPhoneNoUse(this.valueMobileRadio)) ? this.PHONE_NO_USE : ''
                                  });
    }
  }

  changeValueHandlerTelNumber(event) {
      this.valueTelNumber = event.target.value;
      const payload = {componentName:this.itemKeyTelNumber ,componentValue:this.valueTelNumber}
      this.publishToMessageChannel(payload);
  }

  changeValueHandlerCellPhoneNumber(event) {
    this.valueCellPhoneNumber = event.target.value;
    const payload = {componentName:this.itemKeyCellPhoneNumber ,componentValue:this.valueCellPhoneNumber}
    this.publishToMessageChannel(payload);
  }

}