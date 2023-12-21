import { wire ,api} from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';
import publishPlatformEvent from '@salesforce/apex/ExC_FormInquiryController.publishPlatformEvent';
import checkProcess from '@salesforce/apex/ExC_FormInquiryController.checkProcess';
import { CurrentPageReference, NavigationMixin} from 'lightning/navigation';

export default class SubmitInquiry extends NavigationMixin(PubsubExtentions) {

  @api labelConfirmButton;
  @api labelModifyButton;
  @api labelRegistInquiryButton;
  @api labelRegistNote;
  @api keyRegistData;
  @api confirmPhaseKey;
  @api nameCompletePage

  // 確認画面への遷移
  confirmPhase;
  registData;
  companyName;
  currentPageReference = null; 
  urlStateParameters = null;
  isLoading = false;
  confirmDisable = true;


  appendDiv 
  appendInput

  connectedCallback() {
    console.log(this.companyName)
    this.confirmPhase = false;
    this.registData = {}
    console.log('this.keyRegistData: ', this.keyRegistData);
    if(this.keyRegistData)this.keyRegistData.split(',').map(key=>{this.registData[key]={value:'',status:''}})
    if(this.companyName) this.registData['CompanyName'] = {value:this.companyName, status:''};
    this.subscribeToMessageChannel(this ,this.onRecivedMessage);

    this.createInputElementForEFO(this)
  }

  createInputElementForEFO(_this){
    if(!this.appendDiv){
      this.appendDiv = document.createElement('div');
      this.appendDiv.className="p-form_btn";
      this.appendInput = document.createElement('input');
      this.appendInput.name="nmButtonConfirmationPage"
      this.appendInput.type="submit"
      this.appendInput.className="c-btn_submit"
      this.appendInput.id="ButtonConfirmationPage"
      this.appendInput.disabled = this.confirmDisable
      this.appendInput.value=this.labelConfirmButton
      this.appendInput.onclick =function(e){e.preventDefault();_this.clickConfirm(e)};
  
      this.appendDiv.appendChild(this.appendInput)
      this.template.appendChild(this.appendDiv);
    }
  }

  renderedCallback(){
    
    const elem = this.template.querySelector('input[data-id=\'CompanyName\']');
    if(elem) elem.id='CompanyName';
    const elemBtn = this.template.querySelector('input[name=\'nmButtonConfirmationPage\']');
    if(elemBtn) elemBtn.id='ButtonConfirmationPage';
    
    this.appendDiv.style.cssText=(this.confirmPhase)?"display: none;":""

  }

  onRecivedMessage(that, message){
    console.log('Recieveed message', message);
    if(message.componentName in that.registData){
      that.registData[message.componentName]={value:message.componentValue, status:message.componentStatus};
      console.log("##" , that.registData);
    }
    if (message.componentName == 'personalInfoAgree') {
      that.confirmDisable = !message.componentValue;
      that.appendInput.disabled = that.confirmDisable
    }
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
    console.log('### companyName', this.companyName)
    this.companyName = this.getCompanyNameFromUrlParameter(this.companyName);
    console.log('### companyName', this.companyName)
    //if(!this.companyName) window.location.href='https://www.rakuten-insurance.co.jp/error404.html'
  }

  getCompanyNameFromUrlParameter(param){
    return param=='life' ? '楽天生命'
         : param=='gen' ? '楽天損保'
         : param=='pet' ? '楽天ペット保険'
         : null;
  }
  
  /* handlar */
  clickConfirm(event){
    this.isLoading = true
    this.confirmPhase = true;
    const payload = {componentName:this.confirmPhaseKey ,componentValue:this.confirmPhase}
    this.publishToMessageChannel(payload);

    this.publishToMessageChannel({componentName:'buttonConfirmation' ,componentValue:this.confirmPhase});

    const scrollOptions = {
        left: 0,
        top: 0,
    }
    window.scrollTo(scrollOptions);
    setTimeout(() => {this.isLoading = false}, 1000);
    
  }

  clickModify(){
    this.confirmPhase = false;
    const payload = {componentName:this.confirmPhaseKey ,componentValue:this.confirmPhase}
    this.publishToMessageChannel(payload);

    this.publishToMessageChannel({componentName:'buttonModify' ,componentValue:this.confirmPhase});

    const scrollOptions = {
      left: 0,
      top: 0,
      // behavior: 'smooth'
    }
    window.scrollTo(scrollOptions);
  }

  clickRegist(event) {
    event.preventDefault();
    console.log('### Online', navigator.onLine);
    if (!navigator.onLine) {
      alert('通信状況を確認いただき通信可能な環境で再度お試しください。');
      return false;
    }
    event.target.disabled = true;
    this.isLoading = true
    let _target = event.target;
    let param = {};
    //console.log("##" , this.registData);
    Object.keys(this.registData).map(key=>{param[key]=this.registData[key].value})
    
    //console.log("##" , param);

    publishPlatformEvent({ //imperative Apex call
      jsonData: JSON.stringify(param)
    })
      .then(res => {
        console.log('### success ProcessId', res)
        this.processId = res;
        if(this.setTimeInterval) clearInterval(this.setTimeInterval);
        this.setTimeInterval = setInterval(() => {
          this.checkProcess(res)
        }, 3000);
      })
      .catch(error => {
        console.log('### error', error)
        alert('処理が失敗しました、再度お試しください');
        this.isLoading = false
        _target.disabled = false;
      });
  }

  checkProcess(processid){
    console.log('### this.processId', this.processId);
    console.log('### processid', processid);
    checkProcess({ //imperative Apex call
      processId: this.processId
    })
      .then(res => {
        console.log('### success', res)

        if(res) {
          if(this.setTimeInterval) clearInterval(this.setTimeInterval);
          this.moveToCompletePage(res)
        }
      })
      .catch(error => {
        console.log('### error', error)
      });
  }

  moveToCompletePage(inquiryNo){
    let _this = this
    this[NavigationMixin.Navigate]({
      type: 'comm__namedPage',
      attributes: {
          name: _this.nameCompletePage
      },
      state:  {
        company: _this.urlStateParameters.company || null,
        inquiryNo: inquiryNo
      }
    });
  }
}