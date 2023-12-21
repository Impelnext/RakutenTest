import { api } from 'lwc';
import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import sitePrcResources from '@salesforce/resourceUrl/SitePrc';

export default class CancelProcedure extends NavigationMixin(LightningElement) {
    @api nameCancelPage;

    deleteIcon = `${sitePrcResources}/template/images/icon_delete.svg`;
    containerClass = 'form-modal modal-container';

    openModal() {
        this.containerClass = 'form-modal modal-container active';
    }

    closeModal() {
        this.containerClass = 'form-modal modal-container';
    }

    clickDialog(event) {
        event.stopPropagation();
    }

    moveToCancelPage(){
        let _this = this
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: _this.nameCancelPage
            },
            state:  {
            }
        });
    }
    
}