import {api,wire} from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';
//import searchKnowledeByCategory from '@salesforce/apex/KnowledgeController.getAllKnowledes';
import searchKnowledeForInquiry from '@salesforce/apex/KnowledgeController.searchKnowledeForInquiry';
import { CurrentPageReference } from 'lightning/navigation';

export default class SearchResults extends PubsubExtentions {

  @api itemKey;
  @api confirmPhaseKey;
  @api searchItemKey;

  // 確認画面への遷移
  confirmPhase;
  knowledes;
  company

  connectedCallback() {
    this.confirmPhase = false;
    this.subscribeToMessageChannel(this ,this.onRecivedMessage);
  }

  onRecivedMessage(that, message){
    if(message.componentName==that.confirmPhaseKey) that.confirmPhase = message.componentValue;
    if(message.componentName==that.searchItemKey && message.componentStatus=='focusout') that.searchKnowledges(message.componentValue);
  }


  /* URL パラメータ */
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

  get existSearchResult(){
    if(this.knowledes){
      return (this.knowledes.length==0) ? false: true
    }else{
      return false
    }
  }
  searchKnowledges(searchKey){
    console.log('### searchKnowledges');
    this.knowledes = null;//clear result
    if(!searchKey || searchKey=='') return;

		searchKnowledeForInquiry({ //imperative Apex call
      inquiry: searchKey
      ,categoryIdentify: this.company
    })
			.then(result => {
        console.log('### success',result);
				this.knowledes = result;
			})
			.catch(error => {
        console.log('### error',error);
				this.error = error;
			});
  }

}