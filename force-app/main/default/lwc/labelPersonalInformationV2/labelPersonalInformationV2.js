import { LightningElement } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';
import sitePrcResources from '@salesforce/resourceUrl/SitePrc';


export default class LabelPersonalInformationV2 extends PubsubExtentions {

    // 確認画面への遷移
    confirmPhase;
    disableFlag;
    agree;

    linkIcon = `${sitePrcResources}/template/images/icon_link.svg`

    onRecivedMessage(that, message){
        if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
    }
      
    connectedCallback() {
        this.confirmPhase = false;
        this.disableFlag = true;
        this.subscribeToMessageChannel(this ,this.onRecivedMessage);
    }

    renderedCallback() {
        const chk = this.template.querySelector('input[type="checkbox"]');
        if (chk) chk.checked = this.agree;
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