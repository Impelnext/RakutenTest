import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';
import { NavigationMixin} from 'lightning/navigation';

export default class LabelCancelAnnounce extends NavigationMixin(PubsubExtentions) {

    @api nameMovePage

    // 確認画面への遷移
    confirmPhase;
    disableFlag;

    onRecivedMessage(that, message){
        if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
    }
      
    connectedCallback() {
        this.confirmPhase = false;
        this.disableFlag = true;
        this.subscribeToMessageChannel(this ,this.onRecivedMessage);
    }

    scrollToBottomHandler(event) {
        const {scrollHeight, scrollTop, clientHeight} = event.target;
        if (this.disableFlag && scrollTop !== 0) {
            console.log('###scroll rest', scrollHeight - clientHeight - scrollTop);
            if ((scrollHeight - clientHeight - scrollTop) <= 3.0) {
                this.disableFlag = false;
            }
        }
    }

    moveToPage(){
      let _this = this
      this[NavigationMixin.Navigate]({
        type: 'comm__namedPage',
        attributes: {
            name: 'custom_cancel_contract__c'
        },
        state:  {}
      });
    }

}