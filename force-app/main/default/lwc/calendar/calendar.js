import { LightningElement } from 'lwc';
import {api} from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';
import jquery_ui_datepicker from '@salesforce/resourceUrl/jquery_ui_datepicker';
import siteIncResources from '@salesforce/resourceUrl/SiteInc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';

export default class Calendar extends LightningElement {

  @api itemKey;
  @api yearUnit;
  @api monthUnit;
  @api dayUnit;
  // 確認画面への遷移
  confirmPhase;

  onRecivedMessage(that, message){
      if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
  }

  connectedCallback() {
    this.confirmPhase = false;
    this.subscribeToMessageChannel(this ,this.onRecivedMessage);
  }

  renderedCallback() {
    if(!this.Calendar) {

      const appendDiv = this.template.querySelector(".p-form_item")
      this.Calendar = this.createInputElementForJqueryUI(this, appendDiv);
      this.loadJqueryDatePicker(this.Calendar);

    }
  }

  // 固有部品
  value = "";
  htmlValue = "";
  confirmValue = '';

  get styleInput(){
    return !this.confirmPhase ? 'display: block;' : 'display: none;'
  }

  changeValueHandler(event) {
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
      this.appendInput.name="nmButtonConfirmationPage"
      this.appendInput.type="text"
      this.appendInput.className="c-c-form_text birthday c-form_text"
      this.appendInput.id="birthday"
      this.appendInput.name="nmBirthday"
      this.appendInput.autocomplete="off"
      this.appendInput.placeholder="1988/01/01"
      this.appendInput.style = "border: 1px solid #ccc;    border-radius: 4px;    background-color: #fafafa;    padding: 8px 16px;    width: 100%;    appearance: none;    -webkit-appearance: none;"
      this.appendInput.onchange =function(e){_this.changeValueHandler(e);};
      this.appendInput.onkeydown =function(e){e.preventDefault();};
      this.appendInput.oninput =function(e){e.target.value=""};

      appendDiv.appendChild(this.appendInput)
      return this.appendInput;

    }
    return null;
  }

  async loadJqueryDatePicker(elem){

    loadStyle(this, jquery_ui_datepicker + '/jquery-ui.min.css')
    loadStyle(this, jquery_ui_datepicker + '/picker-ui-custom.css')
    //await loadScript(this, jquery_min)
    await loadScript(this, siteIncResources + '/template/js/jquery-3.4.1.min.js')

    await loadScript(this, jquery_ui_datepicker + '/jquery-ui.min.js')

    jQuery(function(t) {
      t.datepicker.regional.ja = {
        closeText: "閉じる",
        prevText: "<前",
        nextText: "次>",
        currentText: "今日",
        monthNames: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
        monthNamesShort: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
        dayNames: ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"],
        dayNamesShort: ["日", "月", "火", "水", "木", "金", "土"],
        dayNamesMin: ["日", "月", "火", "水", "木", "金", "土"],
        weekHeader: "週",
        dateFormat: "yy/mm/dd",
        firstDay: 0,
        isRTL: !1,
        showMonthAfterYear: !0,
        yearSuffix: "年"
      }, t.datepicker.setDefaults(t.datepicker.regional.ja)
    });

    $(function() {

      $(elem).datepicker( {
        changeYear: true,  // 年選択をプルダウン化
        changeMonth: true,  // 月選択をプルダウン化
        yearRange: "-90:+0", // 現在日付の90年前～現在まで選択可能
        defaultDate: "1988/01/01"
      } );

      // 日本語化
      $.datepicker.regional['ja'] = {
        closeText: '閉じる',
        prevText: '<前',
        nextText: '次>',
        currentText: '今日',
        monthNames: ['1月','2月','3月','4月','5月','6月',
        '7月','8月','9月','10月','11月','12月'],
        monthNamesShort: ['1月','2月','3月','4月','5月','6月',
        '7月','8月','9月','10月','11月','12月'],
        dayNames: ['日曜日','月曜日','火曜日','水曜日','木曜日','金曜日','土曜日'],
        dayNamesShort: ['日','月','火','水','木','金','土'],
        dayNamesMin: ['日','月','火','水','木','金','土'],
        weekHeader: '週',
        dateFormat: 'yy/mm/dd',
        firstDay: 0,
        isRTL: false,
        showMonthAfterYear: true,
        yearSuffix: '年'};
      $.datepicker.setDefaults($.datepicker.regional['ja']);
    });

  }

}