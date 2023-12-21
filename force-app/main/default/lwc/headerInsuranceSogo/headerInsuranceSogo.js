import { LightningElement, wire, api } from 'lwc';
import { CurrentPageReference} from 'lightning/navigation';
import siteIncResources from '@salesforce/resourceUrl/SiteInc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';

export default class HeaderInsuranceSogo extends LightningElement {
  @api dispFAQTop;
  @api faqUrlForLife;
  @api faqUrlForSonpo;
  @api faqUrlForPet;
  @api confirmPageExit;
  @api normalLogoWidth;
  @api mobileLogoWidth;
  @api loadJs;
  faqurl;
  linkCaption;
  faqUrlCaptionForLife = 'リンク先は楽天生命のページになります。';
  faqUrlCaptionForSonpo = 'リンク先は楽天損保のページになります。';
  faqUrlCaptionForPet = 'リンク先は楽天ペット保険のページになります。';

	siteResources = {
		logo_sp: `${siteIncResources}/shared/img/header/logo_sp.svg`,
		logo_pc: `${siteIncResources}/shared/img/header/logo_pc.svg`,
	};

  async connectedCallback(){
    console.log('### siteIncResources', siteIncResources);
    loadStyle(this, siteIncResources + '/shared/css/index.css')
    //loadStyle(this, siteIncResources + '/template/css/style.css')


    //await loadScript(this, siteIncResources + '/template/js/jquery-3.4.1.min.js')
    //await loadScript(this, siteIncResources + '/template/js/lib.js')
    //await loadScript(this, siteIncResources + '/template/js/common.js')
    await loadScript(this, siteIncResources + '/appjs/agencyControl.js')
    await loadScript(this, siteIncResources + '/common/js/rc-h-standard.js')

    await loadScript(this, siteIncResources + '/appjs/agencyControl.js')
    
    // datepickerコンポーネントを読み込んでいない場合は、読み込む
    if(!this.loadJs) {
      await loadScript(this, siteIncResources + '/shared/js/lib/jquery.js')
      await loadScript(this, siteIncResources + '/shared/js/jquery.cookie.js')
    }

    await loadScript(this, siteIncResources + '/shared/js/lib.js')
    await loadScript(this, siteIncResources + '/shared/js/common_r.js')
    
    this.faqurl = (this.companyName=='life') ? (this.faqUrlForLife) ? this.faqUrlForLife:'#'
                : (this.companyName=='gen') ?  (this.faqUrlForSonpo) ? this.faqUrlForSonpo:'#'
                : this.companyName=='pet' ?  (this.faqUrlForPet) ? this.faqUrlForPet:'#'
                : '#';

    this.linkCaption = (this.companyName=='life') ? (this.faqUrlCaptionForLife) ? this.faqUrlCaptionForLife: null
                    : (this.companyName=='gen') ?  (this.faqUrlCaptionForSonpo) ? this.faqUrlCaptionForSonpo: null
                    : this.companyName=='pet' ?  (this.faqUrlCaptionForPet) ? this.faqUrlCaptionForPet: null
                    : null;
    if(this.confirmPageExit){
      addEventListener("beforeunload", this.beforeunload);
    }else {
      removeEventListener('beforeunload', this.beforeunload);
    }
    
  }

  beforeunload(evt){
    evt.preventDefault();
    evt.returnValue = 'Check';
  }

  /* URL Parameter */
  @wire(CurrentPageReference)
  getStateParameters(currentPageReference) {
     if (currentPageReference) {
        this.urlStateParameters = currentPageReference.state;
        this.setParametersBasedOnUrl();
     }
  }

  setParametersBasedOnUrl() {
    this.companyName = this.urlStateParameters.company || null;
  }

  beforeUnloadHandler(event) {
    console.log('before unload handler has been called.');
  }

}