import { wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { PubsubExtentions } from 'c/pubsubExtentions';
import siteIncResources from '@salesforce/resourceUrl/SiteInc';

export default class LabelPersonalInformation extends PubsubExtentions {

    /* Params from Url */
    currentPageReference = null; 
    urlStateParameters = null;
    company = null;

    // 確認画面への遷移
    confirmPhase;
    disableFlag;
    agree;

    linkIcon = `${siteIncResources}/template/images/icon_link.svg`;

    onRecivedMessage(that, message){
        if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
    }
      
    connectedCallback() {
        this.confirmPhase = false;
        this.disableFlag = true;
        this.agree = false;
        this.subscribeToMessageChannel(this ,this.onRecivedMessage);
    }

    renderedCallback() {
        const chk = this.template.querySelector('input[type="checkbox"]');
        if (chk) chk.checked = this.agree;
    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.urlStateParameters = currentPageReference.state;
          this.setParametersBasedOnUrl();
       }
    }
  
    setParametersBasedOnUrl() {
      this.company = this.urlStateParameters.company || null;
    }

    get isLife() {
        return this.company == 'life' || this.company == null;
    }
  

    scrollToBottomHandler(event) {
        const {scrollHeight, scrollTop, clientHeight} = event.target;

        if (this.disableFlag && scrollTop !== 0) {
            if ((scrollHeight - clientHeight - scrollTop) <= 3.0) {
                this.disableFlag = false;
            }
        }
    }

    agreeCheckHandler(event) {
        this.agree = event.target.checked;
        const payload = {componentName:'personalInfoAgree' ,componentValue:this.agree};
        this.publishToMessageChannel(payload);
    }


}