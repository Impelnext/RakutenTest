import { LightningElement, api } from 'lwc';
import { NavigationMixin} from 'lightning/navigation';

export default class LabelCancelAnnounce extends NavigationMixin(LightningElement) {

    @api nameMovePages
    buttonSettings

    connectedCallback() {
      this.buttonSettings = this.getButtonSettingsFromMap(this.nameMovePages)
    }

    getButtonSettingsFromMap(str){
      return str.split(',').map(
        item=>{return {
                        "apiname":item.split(':')[0],
                        "label":item.split(':')[1]}
                      }
        );
    }
    moveToPage(event){
      var apiname = event.target.dataset.id

      let _this = this
      this[NavigationMixin.Navigate]({
        type: 'comm__namedPage',
        attributes: {
            name: apiname
        },
        state:  {}
      });
    }

}