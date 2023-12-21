import {api} from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';
import { loadJQueryUiDatePickerScriptsAndStyles, waitJQueryUIDatePicker } from 'c/datepicker';

export default class Birthday extends PubsubExtentions {
  @api itemKey;
  @api yearUnit;
  @api monthUnit;
  @api dayUnit;

  // 固有部品
  value = "";
  htmlValue = "";
  confirmValue = '';  
  dispValue = true;
  formBlank = [];
  conBirthday;

  // 確認画面への遷移
  confirmPhase;

  onRecivedMessage(that, message){
    if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
    if(message.componentName == 'RelationshipWithContractor'){
      if(message.componentValue == 'contractor'){
        that.dispValue = true;
        that.conBirthday.value = '';
      }else {
        that.dispValue = false;
      }
    }
  }

  connectedCallback() {
    this.confirmPhase = false;
    this.subscribeToMessageChannel(this ,this.onRecivedMessage);
  }

  renderedCallback() {
    if(!this.birthday){
      const appendDiv = this.template.querySelector(".p-form_item");
      this.birthday = this.createInputElementForJqueryUI(this, appendDiv);
      this.loadJqueryDatePicker(this.birthday);
    }
    this.conBirthday = document.getElementById('birthday');
    if(this.conBirthday.value == ''){
      this.conBirthday.style = "border: 1px solid #ccc;    border-radius: 4px;    background-color: #ffdddd;    padding: 8px 16px;    width: 100%;    appearance: none;    -webkit-appearance: none;";
    }
  }


  get styleInput(){
    return !this.confirmPhase ? 'display: block;' : 'display: none;'
  }

  changeValueHandler(event) {
    this.appendInput.style = "border: 1px solid #ccc;    border-radius: 4px;    background-color: #fafafa;    padding: 8px 16px;    width: 100%;    appearance: none;    -webkit-appearance: none;";
    this.htmlValue = event.target.value;
    const ymd = this.htmlValue.replaceAll('/0', '/').split('/');
    this.confirmValue = ymd[0] + this.yearUnit + ymd[1] + this.monthUnit + ymd[2] + this.dayUnit;
    if(this.htmlValue) this.value = this.htmlValue.replaceAll('-','/');
    const payload = {componentName:this.itemKey ,componentValue:this.value};
    this.publishToMessageChannel(payload);
  }

  createInputElementForJqueryUI(_this, appendDiv){
    if(appendDiv){

      this.appendInput = document.createElement('input');
      this.appendInput.type="text"
      this.appendInput.className="c-c-form_text c-form_text"
      this.appendInput.id="birthday"
      this.appendInput.name="nmBirthday"
      this.appendInput.autocomplete="off"
      this.appendInput.placeholder="年/月/日"
      this.appendInput.style = "border: 1px solid #ccc;    border-radius: 4px;    background-color: #ffdddd;    padding: 8px 16px;    width: 100%;    appearance: none;    -webkit-appearance: none;"
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
    $(elem).datepicker( {
      changeYear: true,  // 年選択をプルダウン化
      changeMonth: true,  // 月選択をプルダウン化
      yearRange: "-90:+0", // 現在日付の90年前～現在まで選択可能
      defaultDate: "1988/01/01"
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

  get dispTitle(){
    return this.dispValue ? 'display: block;' : 'display: none;'
  }
}