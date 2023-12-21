import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';
import {
  loadJQueryUiDatePickerScriptsAndStyles,
  waitJQueryUIDatePicker,
  resetJQueryDatePickerGlobal,
} from 'c/datepicker';

export default class Modaddress extends PubsubExtentions {
  @api itemKeyPostCode;
  @api itemKeyPrefectures;
  @api itemKeyAddress;
  @api itemKeyOtherAddress;
  @api itemKeyMoveDay;
  @api itemkeyCheckBox;
  @api yearUnit;
  @api monthUnit;
  @api dayUnit;

  // 確認画面への遷移
  confirmPhase;

  value = "";
  valuePostCode = "";
  valuePrefectures = "";
  valueAddress = "";
  valueOtherAddress = "";
  valueMoveDay = "";

  valueCheckBox;
  checkedCheckBox;
  isChanged = false;
  htmlValueMoveDay;
  MoveAddress;
  dispPostCode;
  confirmMoveDay;

  get styleInput(){
    return !this.confirmPhase ? 'display: block;' : 'display: none;'
  }

  onRecivedMessage(that, message){
    if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
  }

  connectedCallback() {
      this.confirmPhase = false;
      this.subscribeToMessageChannel(this ,this.onRecivedMessage);

      window.addEventListener("popstate", function (e) { // ブラウザバックを検出した時
        resetJQueryDatePickerGlobal();
      });
  }

  renderedCallback() {
    const chkbox = this.template.querySelector('input[type="checkbox"]');
    if (chkbox) chkbox.checked = this.valueCheckBox;
    const radio = this.template.querySelector('input[value="' + this.MoveAddress + '"]');
    if (radio) radio.checked = true;

    if(this.confirmPhase) this.inputs = null;
    if(!this.inputs && !this.confirmPhase) this.inputs = this.defineInputsOfValueGetterSetter(this)


    if(this.confirmPhase) this.prefectures = null;
    if(!this.prefectures && !this.confirmPhase) this.prefectures = this.template.querySelector('select');

    if(!this.modaddress) {
      const appendDiv = this.template.querySelector(".movingDate")
      this.modaddress = this.createInputElementForJqueryUI(this, appendDiv);
      this.loadJqueryDatePicker(this.modaddress);
    }
  }

  get dispModAddress(){
    return (true==this.valueCheckBox);
  }
  get styleModAddress(){
    return this.dispModAddress ? 'display: block;' : 'display: none;'
  }

  get PrefectureOptions() {
    const rtn = [
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
    rtn.forEach(element => {
      element.selected = (element.value==this.valuePrefectures)
    });
    return rtn;
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

  changeCheckBoxValueHandler(event) {
    this.valueCheckBox = event.target.checked;
    this.checkedCheckBox = this.valueCheckBox;

    const payload = {componentName:this.itemkeyCheckBox ,componentValue:this.valueCheckBox}
    this.publishToMessageChannel(payload);
    if (this.valueCheckBox) {
      this.publishToMessageChannel({componentName:this.itemKeyPostCode ,componentValue:this.valuePostCode});
      this.publishToMessageChannel({componentName:this.itemKeyPrefectures ,componentValue:this.valuePrefectures});
      this.publishToMessageChannel({componentName:this.itemKeyAddress ,componentValue:this.valueAddress});
      this.publishToMessageChannel({componentName:this.itemKeyOtherAddress ,componentValue:this.valueOtherAddress});
      this.publishToMessageChannel({componentName: this.itemKeyMoveDay, componentValue: this.valueMoveDay});
    } else {
      this.publishToMessageChannel({componentName:this.itemKeyPostCode ,componentValue:''});
      this.publishToMessageChannel({componentName:this.itemKeyPrefectures ,componentValue:''});
      this.publishToMessageChannel({componentName:this.itemKeyAddress ,componentValue:''});
      this.publishToMessageChannel({componentName:this.itemKeyOtherAddress ,componentValue:''});
      this.publishToMessageChannel({componentName: this.itemKeyMoveDay, componentValue:''});
    }
  }

  changeValueHandlerPostCode(event) {
      this.valuePostCode = event.target.value;
      const payload = {componentName:this.itemKeyPostCode ,componentValue:this.valuePostCode};
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

    if(this.prefectures && this.prefectures.value != this.valuePrefectures){
      this.changeValueHandlerPrefectures({target: this.prefectures})
    }
  }

  changeValueHandlerOtherAddress(event) {
    this.valueOtherAddress = event.target.value;
    const payload = {componentName:this.itemKeyOtherAddress ,componentValue:this.valueOtherAddress}
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


  changeValueHandler(event) {
    this.htmlValueMoveDay = event.target.value;
    const ymd = this.htmlValueMoveDay.replaceAll('/0', '/').split('/');
    this.confirmMoveDay = ymd[0] + this.yearUnit + ymd[1] + this.monthUnit + ymd[2] + this.dayUnit;
    if(this.htmlValueMoveDay) this.valueMoveDay = this.htmlValueMoveDay.replaceAll('-','/');
    const payload = {componentName:this.itemKeyMoveDay ,componentValue:this.valueMoveDay};
    this.publishToMessageChannel(payload);
  }

  createInputElementForJqueryUI(_this, appendDiv){
    if(appendDiv){

      this.appendInput = document.createElement('input');
      this.appendInput.type="text"
      this.appendInput.className="c-c-form_text c-form_text"
      this.appendInput.id=this.itemKeyMoveDay
      this.appendInput.name="nmMoveDate"
      this.appendInput.autocomplete="off"
      this.appendInput.placeholder="日付を選択してください"
      this.appendInput.style = "border: 1px solid #ccc;    border-radius: 4px;    background-color: #fafafa;    padding: 8px 16px;    width: 100%;    appearance: none;    -webkit-appearance: none;"
      this.appendInput.onchange =function(e){_this.changeValueHandler(e);};
      this.appendInput.onkeydown =function(e){e.preventDefault();};
      this.appendInput.oninput =function(e){e.target.value=""};
      this.appendInput.onclick =function(e){e.target.blur();};

      appendDiv.appendChild(this.appendInput)
      return this.appendInput;

    }
    return null;
  }

  initDatapicker(elem, $) {

    var dt = new Date();
    var y  = dt.getFullYear();
    var m  = dt.getMonth() + 1;
    var d  = dt.getDate();

    $(elem).datepicker( {
      changeYear: true,  // 年選択をプルダウン化
      changeMonth: true,  // 月選択をプルダウン化
      minDate: new Date(y, m - 1, d + 1),
      maxDate: new Date(y, m, d + 1)
    } );
  }


  async loadJqueryDatePicker(elem){
  await loadJQueryUiDatePickerScriptsAndStyles(this);
  await waitJQueryUIDatePicker()

  if(document.readyState === "complete") {
      // 既にDOMが完成して ready イベントが発火できない場合
      this.initDatapicker(elem, $);
    }
    else if(document.readyState === "interactive") {
      // 既にDOMが完成して ready イベントが発火できない場合 (ただし、画像やフレームなどの他のデータはダウンロード中)
      this.initDatapicker(elem, $);
    }
    else {
      // DOMが未完成の場合
      jQuery(function($) {
        this.initDatapicker(elem, $);
      });
    }
  }
}