import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';

export default class Modaddressradio extends PubsubExtentions {
  @api itemkeyCheckBox;
  @api majorItemName
  @api itemName1
  @api itemName2
  @api itemKeyPostCode;
  @api itemKeyPrefectures;
  @api itemKeyAddress;
  @api itemKeyOtherAddress;
  @api itemKeyMoveDay;

  // 確認画面への遷移
  confirmPhase;
  htmlValueMoveDay;
  MoveAddress;

  value = "";
  valuePostCode = "";
  valuePrefectures = "";
  valueAddress = "";
  valueOtherAddress = "";
  valueMoveDay = "";
  valueRadio;
  isChanged = false;
  dispPostCode = "";

  onRecivedMessage(that, message){
    if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
  }
    
  connectedCallback() {
      this.confirmPhase = false;
      this.subscribeToMessageChannel(this ,this.onRecivedMessage);
  }

  renderedCallback() {
    const radio = this.template.querySelector('input[value="' + this.valueRadio + '"]');
    if (radio) radio.checked = true;
    const moveRadio = this.template.querySelector('input[value="' + this.MoveAddress + '"]');
    if (moveRadio) moveRadio.checked = true;
    const prefectures = this.template.querySelector('select');
    if (prefectures) prefectures.value = this.valuePrefectures;
  }
 
  get options() {
    return [
        { label: this.itemName1, value: this.itemName1 },
        { label: this.itemName2, value: this.itemName2 },
    ];
  }

  get PrefectureOptions() {
    return [
        { label: '北海道', value: '北海道', id: 'Prefecture_01' },
        { label: '青森県', value: '青森県', id: 'Prefecture_02' },
        { label: '岩手県', value: '岩手県', id: 'Prefecture_03' },
        { label: '宮城県', value: '宮城県', id: 'Prefecture_04' },
        { label: '秋田県', value: '秋田県', id: 'Prefecture_05' },
        { label: '山形県', value: '山形県', id: 'Prefecture_06' },
        { label: '福島県', value: '福島県', id: 'Prefecture_07' },
        { label: '茨城県', value: '茨城県', id: 'Prefecture_08' },
        { label: '栃木県', value: '栃木県', id: 'Prefecture_09' },
        { label: '群馬県', value: '群馬県', id: 'Prefecture_10' },
        { label: '埼玉県', value: '埼玉県', id: 'Prefecture_11' },
        { label: '千葉県', value: '千葉県', id: 'Prefecture_12' },
        { label: '東京都', value: '東京都', id: 'Prefecture_13' },
        { label: '神奈川県', value: '神奈川県', id: 'Prefecture_14' },
        { label: '新潟県', value: '新潟県', id: 'Prefecture_15' },
        { label: '富山県', value: '富山県', id: 'Prefecture_16' },
        { label: '石川県', value: '石川県', id: 'Prefecture_17' },
        { label: '福井県', value: '福井県', id: 'Prefecture_18' },
        { label: '山梨県', value: '山梨県', id: 'Prefecture_19' },
        { label: '長野県', value: '長野県', id: 'Prefecture_20' },
        { label: '岐阜県', value: '岐阜県', id: 'Prefecture_21' },
        { label: '静岡県', value: '静岡県', id: 'Prefecture_22' },
        { label: '愛知県', value: '愛知県', id: 'Prefecture_23' },
        { label: '三重県', value: '三重県', id: 'Prefecture_24' },
        { label: '滋賀県', value: '滋賀県', id: 'Prefecture_25' },
        { label: '京都府', value: '京都府', id: 'Prefecture_26' },
        { label: '大阪府', value: '大阪府', id: 'Prefecture_27' },
        { label: '兵庫県', value: '兵庫県', id: 'Prefecture_28' },
        { label: '奈良県', value: '奈良県', id: 'Prefecture_29' },
        { label: '和歌山県', value: '和歌山県', id: 'Prefecture_30' },
        { label: '鳥取県', value: '鳥取県', id: 'Prefecture_31' },
        { label: '島根県', value: '島根県', id: 'Prefecture_32' },
        { label: '岡山県', value: '岡山県', id: 'Prefecture_33' },
        { label: '広島県', value: '広島県', id: 'Prefecture_34' },
        { label: '山口県', value: '山口県', id: 'Prefecture_35' },
        { label: '徳島県', value: '徳島県', id: 'Prefecture_36' },
        { label: '香川県', value: '香川県', id: 'Prefecture_37' },
        { label: '愛媛県', value: '愛媛県', id: 'Prefecture_38' },
        { label: '高知県', value: '高知県', id: 'Prefecture_39' },
        { label: '福岡県', value: '福岡県', id: 'Prefecture_40' },
        { label: '佐賀県', value: '佐賀県', id: 'Prefecture_41' },
        { label: '長崎県', value: '長崎県', id: 'Prefecture_42' },
        { label: '熊本県', value: '熊本県', id: 'Prefecture_43' },
        { label: '大分県', value: '大分県', id: 'Prefecture_44' },
        { label: '宮崎県', value: '宮崎県', id: 'Prefecture_45' },
        { label: '鹿児島県', value: '鹿児島県', id: 'Prefecture_46' },
        { label: '沖縄県', value: '沖縄県', id: 'Prefecture_47' },
    ];
  }

  get dispModAddress(){
    return (this.itemName1==this.valueRadio);
  }
  get styleModAddress(){
    return this.dispModAddress ? 'display: block;' : 'display: none;'
  }
  
  get dispMoveDay() {
    return this.MoveAddress == '転居予定';
  }
  get styleMoveDay() {
    return this.dispMoveDay ? 'display: block;' : 'display: none;'
  }

  changeRadioValueMoveAddress(event) {
    this.MoveAddress = event.target.value;
    if (this.dispMoveDay) {
      this.publishToMessageChannel({componentName: this.itemKeyMoveDay, componentValue: this.valueMoveDay});
    } else {
      this.publishToMessageChannel({componentName: this.itemKeyMoveDay, componentValue: ''});
    }
  }

  changeRadioValueHandler(event) {
    this.valueRadio = event.target.value;

    const payload = {componentName:this.itemkeyCheckBox ,componentValue:this.dispModAddress}
    this.publishToMessageChannel(payload);
    if (this.dispModAddress) {
      this.publishToMessageChannel({componentName:this.itemKeyPostCode ,componentValue:this.valuePostCode});
      this.publishToMessageChannel({componentName:this.itemKeyPrefectures ,componentValue:this.valuePrefectures});
      this.publishToMessageChannel({componentName:this.itemKeyAddress ,componentValue:this.valueAddress});
      this.publishToMessageChannel({componentName:this.itemKeyOtherAddress ,componentValue:this.valueOtherAddress});
      this.publishToMessageChannel({componentName: this.itemKeyMoveDay, componentValue: this.valueMoveDay});
    } else {
      this.publishToMessageChannel({componentName:this.itemKeyPostCode ,componentValue: null});
      this.publishToMessageChannel({componentName:this.itemKeyPrefectures ,componentValue: null});
      this.publishToMessageChannel({componentName:this.itemKeyAddress ,componentValue: null});
      this.publishToMessageChannel({componentName:this.itemKeyOtherAddress ,componentValue: null});
      this.publishToMessageChannel({componentName: this.itemKeyMoveDay, componentValue: null});
    }

    /*
    this.valueRadio = event.target.value;
    let isRegistered = (this.valueRadio)? 'On' : '';
    const payload = {componentName:'DaytimePhoneNumberRegistered' ,componentValue:isRegistered}
    this.publishToMessageChannel(payload);
    if(this.valueRadio){
      const payload2 = {componentName:this.itemkeyCheckBox ,componentValue:''}
      this.publishToMessageChannel(payload2);
    }else{
      const payload2 = {componentName:this.itemkeyCheckBox ,componentValue:this.value}
      this.publishToMessageChannel(payload2);
    }
    */
  }

  changeValueHandlerPostCode(event) {
    this.valuePostCode = event.target.value;
    const payload = {componentName:this.itemKeyPostCode ,componentValue:this.valuePostCode}
    this.publishToMessageChannel(payload);
    if (this.valuePostCode) {
      this.dispPostCode = '〒' + this.valuePostCode.substring(0, 3) + '-' + this.valuePostCode.substring(3);
    } else {
      this.dispPostCode = '';
    }
  }

  changeValueHandlerPrefectures(event) {
    this.valuePrefectures = event.target.value;
    const payload = {componentName:this.itemKeyPrefectures ,componentValue:this.valuePrefectures}
    this.publishToMessageChannel(payload);
  }

  changeValueHandlerAddress(event) {
    this.valueAddress = event.target.value;
    const payload = {componentName:this.itemKeyAddress ,componentValue:this.valueAddress}
    this.publishToMessageChannel(payload);
  }

  changeValueHandlerOtherAddress(event) {
    this.valueOtherAddress = event.target.value;
    const payload = {componentName:this.itemKeyOtherAddress ,componentValue:this.valueOtherAddress}
    this.publishToMessageChannel(payload);
  }

  changeValueHandlerMoveDay(event) {
    this.htmlValueMoveDay = event.target.value;
    const ymd = this.htmlValueMoveDay.replaceAll('-0', '-').split('-');
    if (ymd.length < 3) {
      this.confirmValue = '';
    } else {
      this.confirmValue = ymd[0] + '年' + ymd[1] + '月' + ymd[2] + '日';
    }
    this.valueMoveDay = this.htmlValueMoveDay.replaceAll('-','/');
    const payload = {componentName: this.itemKeyMoveDay, componentValue: this.valueMoveDay};
    this.publishToMessageChannel(payload);
  }

  async clickSearchAddressHandler(event) {
    if (!this.valuePostCode) return;

    const response = await fetch(`https://yubinbango.github.io/yubinbango-data/data/${this.valuePostCode.substring(0, 3)}.js`);
    const respText = await response.text();
    const addrMap = JSON.parse(respText.replace('$yubin(', '').replace(');', ''));
    const address = addrMap[this.valuePostCode];
    if (address) {
      this.template.querySelector('select').selectedIndex = address[0];
      this.valueAddress = address[1] + address[2];
      this.valuePrefectures = this.template.querySelector('select').value;
      this.publishToMessageChannel({componentName:this.itemKeyPrefectures ,componentValue:this.valuePrefectures});
      this.publishToMessageChannel({componentName:this.itemKeyAddress ,componentValue:this.valueAddress});
      this.template.querySelector('input[name="nmAddress2"]').focus();
    } else {
      console.log('error post code:' + this.valuePostCode);
    }
  }

}