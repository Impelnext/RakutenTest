import { LightningElement } from 'lwc';
import jquery_ui_datepicker from '@salesforce/resourceUrl/jquery_ui_datepicker';
import siteIncResources from '@salesforce/resourceUrl/SiteInc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';

const JQ_UI_DATE_PICKER_MUTEX_NAME =  '__jq-ui-datepicker';

/**
* 指定時間待機
* @param {number} ms 待機時間(ミリ秒)
*/
const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

/**
* 待機処理
* @param {Promise<() => boolean>} predicate
* @param {{maxRetryCount?: number; intervalMs?: number}} options
* @returns
*/
const waitFor = async(
  predicate,
  options = {
    maxRetryCount: Number.MAX_SAFE_INTEGER,
    intervalMs: 100
  }
) => {
  options.maxRetryCount = Number.MAX_SAFE_INTEGER;
  options.intervalMs = 100;

  for(let i = 0; i < options.maxRetryCount; i++) {
    if (await predicate()) {
      return true;
    }

    await sleep(options.intervalMs);
  }
  return false;
};

/**
 * jQueryオブジェクト"$"がロード済みかチェック
 * @returns {boolean} trueの場合ロード済み。falseの場合ロード未完了
 */
const isJQueryLoaded = () => typeof $ !== "undefined";

/**
 * jQueryUIのDatePickerがロード済みかチェック
 * @returns {boolean} trueの場合ロード済み。falseの場合ロード未完了
 */
  const isJQueryUiDatePickerLoaded = () => isJQueryLoaded() && (typeof $('body').datepicker !== "undefined");

/**
 * jQueryUIのDatePickerがロードされるのを待機する
 * @returns {Promise<boolean>}
 */
export const waitJQueryUIDatePicker = async() => {
  console.log('isJQueryLoaded', isJQueryLoaded());
  console.log('isJQueryUiDatePickerLoaded', isJQueryUiDatePickerLoaded());
  // 100ms * 600回 = 60秒最大待機する（今はずっと待機する）
  const loaded = await waitFor(() => isJQueryUiDatePickerLoaded(), {
    intervalMs: 100,
    maxRetryCount: 100
  });
  console.log('waitJQueryUIDatePickerのReturn');
  return loaded;
};


// jquery.ui.datepicker-ja.min.jsの読み込み
const jqueryUiDatepickerJaMin = () => {
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
};


/**
 * ロードがユニークになるようにする
 * @param {string} uniqueName
 * @param {() => (Promise<any> | any)} loadFn
 */
const loadUnique = async(uniqueName, loadFn) => {
  //2023/06/12 datepickerの件でこちらの条件をコメントアウト
  if (!window[uniqueName]) {
    console.log('window[uniqueName]before  ', window[uniqueName]);
    window[uniqueName] = true;
    console.log('window[uniqueName]after  ', window[uniqueName]);
    return await loadFn();
  }
  // console.log('window[uniqueName](return):  ', window[uniqueName]);
  return undefined;
};

/**
 * jQueryUIのDatePickerをロードする
 * @param {LightningElement} component
 * @returns {Promise<void>}
 */
export const loadJQueryUiDatePickerScriptsAndStyles = async(component) => {
  return loadUnique(JQ_UI_DATE_PICKER_MUTEX_NAME, async() => {
    //await loadScript(component, jquery_min)
    await loadScript(component, siteIncResources + '/template/js/jquery-3.4.1.min.js')
    await loadScript(component, jquery_ui_datepicker + '/jquery-ui.min.js')
    await jqueryUiDatepickerJaMin();
    await loadStyle(component, jquery_ui_datepicker + '/jquery-ui.min.css')
    await loadStyle(component, jquery_ui_datepicker + '/picker-ui-custom.css')
    await loadScript(component, siteIncResources + '/shared/js/jquery.cookie.js')
  });
};

/**
 * jQueryUIのDatePickerオブジェクトをリセットする
 * @note ブラウザバックの不具合対策用の関数です
 * @attention ブラウザバックのコールバックなどから、この関数を呼び出す場合、戻り先ページのレンダリング前に本関数のコールが終わっていることを保証すること
 */
export const resetJQueryDatePickerGlobal = () => {
  if (window[JQ_UI_DATE_PICKER_MUTEX_NAME]) {
    try {
      delete window[JQ_UI_DATE_PICKER_MUTEX_NAME];

      const datePickerDiv =  document.getElementById('ui-datepicker-div'); // "ui-datepicker-div" == jQuery の datepicker プラグインが生成する固定のID
      if (datePickerDiv) {
        datePickerDiv.parentElement.removeChild(datePickerDiv);
      }
    }
    catch(_) {
      console.error('remove element of "ui-datepicker-div" failed'); // 複数箇所から重複で消されたことを念の為ログに出力する。握り潰すしかない・・・
    }
  }
  else {
    console.error('resetJQueryDatePickerGlobal was called duplicated'); // 複数箇所から重複で消されたことを念の為ログに出力する。ログを出すしかない・・・
  }
};