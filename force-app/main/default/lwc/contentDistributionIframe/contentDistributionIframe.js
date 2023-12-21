import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import domainSF from '@salesforce/label/c.ExC_ContentDistributionDomain';
import checkPassword from '@salesforce/apex/ExC_FileDownloadController.checkPassword';

export default class ContentDistributionIframe extends LightningElement {
   currentPageReference = null;
   urlStateParameters = null;
   password = '';
   errorMsg = '';
   isDownload = '';

   /* Params from Url */
   domain = domainSF + '/sfc/p/';
   urlId = null;
   crmContentUrl = null;
   isSubmit = false;
   showIframe = 'hide_iframe container';
   keyState = window.location.href + ''
   isSaveState = false;

   @wire(CurrentPageReference)
   getStateParameters(currentPageReference) {
      if (currentPageReference) {
         this.urlStateParameters = currentPageReference.state;
         this.setParametersBasedOnUrl();
      }
   }

   connectedCallback(){
      if(this.isLogin()){
         this.isDownload = 'ダンロードが完了しました。\nファイルフォルダに格納しました。'
      }
   }

   setParametersBasedOnUrl() {
      this.urlId = this.urlStateParameters.id || null;
      this.crmContentUrl = this.domain + this.urlId;
   }

   onChangePass(event) {
      this.password = event.target.value;
   }

   clickSubmit(event) {
      event.preventDefault();
      if(this.password) {
         this.checkPassword(this.urlId, this.password);
      } else {
         this.errorMsg = 'パスワードを入力してください';
      }
   }

   checkPassword(id, pass) {
      checkPassword({
         id: id,
         pass: pass
      })
         .then(res => {
            console.log('### success', res)
            if (res) {
               let form = this.template.querySelector('form');
               form.submit();
               this.isSubmit = true;
              this.isSaveState = true;
               this.showIframe = 'show_iframe container'
               //add event new tab + old tab blur
               if(this.getBrowser() === 'Apple Safari') {
                  document.addEventListener('visibilitychange', () => {
                     let elementAcctive = document.activeElement?.nodeName;
                     if (!document.hasFocus() && this.isSaveState && elementAcctive === 'C-CONTENT-DISTRIBUTION-IFRAME') {
                        this.saveStateLogin()
                        this.isSaveState = false
                     }
                  })
               }
            } else {
               this.errorMsg = 'パスワードが正しくありません'
            }
         })
         .catch(error => {
            console.log('### error', error)
         });
   }

   //get browser
   getBrowser() {
      let browser = (function () {
         let test = function (regexp) { return regexp.test(window.navigator.userAgent) }
         switch (true) {
            case test(/edg/i): return "Microsoft Edge";
            case test(/trident/i): return "Microsoft Internet Explorer";
            case test(/firefox|fxios/i): return "Mozilla Firefox";
            case test(/opr\//i): return "Opera";
            case test(/ucbrowser/i): return "UC Browser";
            case test(/samsungbrowser/i): return "Samsung Browser";
            case test(/chrome|chromium|crios/i): return "Google Chrome";
            case test(/safari/i): return "Apple Safari";
            default: return "Other";
         }
      })();
      return browser;
   }

   //save login state
   saveStateLogin(){
      let timeBack = new Date();
      localStorage.setItem(this.keyState, JSON.stringify(timeBack));
      console.log('set true: ')
   }

   //check login state
   isLogin(){
      let dataSave = localStorage.getItem(this.keyState);
      localStorage.removeItem(this.keyState);
      if (dataSave) {
			// get time
			let timeBack = JSON.parse(dataSave);
			let dateTime = Date.parse(timeBack);
			let seconds = (new Date().getTime() - dateTime) / 1000;
			// access when < 30 minutes
			if (seconds < 1800) {
				return true;
			}
		}
      return false;
   }
}