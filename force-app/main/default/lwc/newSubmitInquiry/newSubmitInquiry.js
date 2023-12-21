import { wire ,api} from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';
import publishPlatformEvent from '@salesforce/apex/ExC_FormInquiryController.publishPlatformEvent';
import checkProcess from '@salesforce/apex/ExC_FormInquiryController.checkProcess';
import { CurrentPageReference, NavigationMixin} from 'lightning/navigation';
import submitError from '@salesforce/resourceUrl/submitError';

export default class SubmitInquiry extends NavigationMixin(PubsubExtentions) {

  @api labelConfirmButton;
  @api labelModifyButton;
  @api labelRegistInquiryButton;
  @api labelRegistNote;
  @api keyRegistDataContractor;
  @api keyRegistDataOther;
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
  submitErrorURL;
  dispBtn = true;
  checkMsgVal = [];
  contractorType = 'contractor';
  allOk = false;
  errorImg;
  isRegistered = 'On';
  inquiryType;
  contentsOfInquiry;


  appendDiv 
  appendInput

  submitErrorURL = submitError;

  connectedCallback() {
    console.log(this.companyName)
    this.confirmPhase = false;
    this.RegistDataContractor = {};
    this.RegistDataOther = {};
    console.log('this.keyRegistDataContractor: ', this.keyRegistDataContractor);
    console.log('this.keyRegistDataOther: ', this.keyRegistDataOther);
    if(this.keyRegistDataContractor)this.keyRegistDataContractor.split(',').map(key=>{this.RegistDataContractor[key]={value:'',status:''}})
    if(this.keyRegistDataOther)this.keyRegistDataOther.split(',').map(key=>{this.RegistDataOther[key]={value:'',status:''}})
    if(this.companyName) this.RegistDataContractor['CompanyName'] = {value:this.companyName, status:''}
    if(this.companyName) this.RegistDataOther['CompanyName'] = {value:this.companyName, status:''}
    if(this.companyName){
      this.RegistDataContractor['RelationshipWithContractor'] = {value:'契約者ご本人さま', status:''}
    } 
    this.subscribeToMessageChannel(this ,this.onRecivedMessage);

  }

  renderedCallback(){
    console.log('続柄', this.contractorType);
    const elem = this.template.querySelector('input[data-id=\'CompanyName\']');
    if(elem) elem.id='CompanyName';
    const elemBtn = this.template.querySelector('input[name=\'nmButtonConfirmationPage\']');
    if(elemBtn) elemBtn.id='ButtonConfirmationPage';

    this.appendDiv = this.template.querySelector('.p-form_btn');
    this.appendInput = this.template.querySelector('.c-btn_submit');
    this.errorImg = this.template.querySelector('.error-img');

    if(this.confirmPhase){
      this.appendDiv.style.display = 'none';
    }else {
      this.appendDiv.style.display = 'block';
    }
  }

  onRecivedMessage(that, message){
    if(message.componentName == 'ContractorPhoneNumberRegistered'){
      that.isRegistered = message.componentValue;
    }
    if(message.componentName == 'InquiryType') that.inquiryType = message.componentValue;
    if(message.componentName == 'ContentsOfInquiry') that.contentsOfInquiry = message.componentValue;
    console.log('Recieveed message', message);
    if(that.contractorType == 'contractor'){
      if(message.componentName in that.RegistDataContractor){
        that.RegistDataContractor[message.componentName]={value:message.componentValue, status:message.componentStatus};
        console.log("##111111" , JSON.stringify(that.RegistDataContractor));
      }
    }
    if(that.contractorType == 'other'){
      if(message.componentName in that.RegistDataOther){
        that.RegistDataOther[message.componentName]={value:message.componentValue, status:message.componentStatus};
        console.log("##111111" , JSON.stringify(that.RegistDataOther));
      }
    }
    if (message.componentName == 'personalInfoAgree') {
      that.confirmDisable = !message.componentValue;
      console.log('@@@@@', that.appendInput);
      that.appendInput.disabled = that.confirmDisable;
    }

    if(message.componentName == 'RelationshipWithContractor'){
      if(message.componentValue == 'contractor'){
        that.contractorType = 'contractor';
        for(let data in that.RegistDataContractor){
          that.RegistDataContractor[data].value = '';
        }
        that.RegistDataContractor['CompanyName'] = {value:that.companyName, status:''}
        that.RegistDataContractor['RelationshipWithContractor'] = {value:'契約者ご本人さま', status:''}
        that.RegistDataContractor['InquiryType'] = {value:that.inquiryType, status:''}
        that.RegistDataContractor['ContentsOfInquiry'] = {value:that.contentsOfInquiry, status:''}
      }else if(message.componentValue == 'others1'){
        that.contractorType = 'other';
        for(let data in that.RegistDataOther){
          that.RegistDataOther[data].value = '';
        }
        that.RegistDataOther['CompanyName'] = {value:that.companyName, status:''}
        that.RegistDataOther['RelationshipWithContractor'] = {value:'被保険者さま（保障、補償の対象の方）', status:''}
        that.RegistDataOther['InquiryType'] = {value:that.inquiryType, status:''}
        that.RegistDataOther['ContentsOfInquiry'] = {value:that.contentsOfInquiry, status:''}
        that.RegistDataOther['ContractorPhoneNumberRegistered'] = {value:that.isRegistered, status:''}
      }else if(message.componentValue == 'others2'){
        that.contractorType = 'other';
        for(let data in that.RegistDataOther){
          that.RegistDataOther[data].value = '';
        }
        that.RegistDataOther['CompanyName'] = {value:that.companyName, status:''}
        that.RegistDataOther['RelationshipWithContractor'] = {value:'ご親族さま（配偶者、子、親、兄弟姉妹）', status:''}
        that.RegistDataOther['InquiryType'] = {value:that.inquiryType, status:''}
        that.RegistDataOther['ContentsOfInquiry'] = {value:that.contentsOfInquiry, status:''}
        that.RegistDataOther['ContractorPhoneNumberRegistered'] = {value:that.isRegistered, status:''}
      }else if(message.componentValue == 'others3'){
        that.contractorType = 'other';
        for(let data in that.RegistDataOther){
          that.RegistDataOther[data].value = '';
        }
        that.RegistDataOther['CompanyName'] = {value:that.companyName, status:''}
        that.RegistDataOther['RelationshipWithContractor'] = {value:'その他（代理店さま、開示指定者さまなど）', status:''}
        that.RegistDataOther['InquiryType'] = {value:that.inquiryType, status:''}
        that.RegistDataOther['ContentsOfInquiry'] = {value:that.contentsOfInquiry, status:''}
        that.RegistDataOther['ContractorPhoneNumberRegistered'] = {value:that.isRegistered, status:''}
      }
      console.log('続柄@@@@', that.contractorType);
      console.log('続柄value', that.RegistDataOther['RelationshipWithContractor'].value);
    }

    if(that.contractorType == 'contractor'){
      for(let data in that.RegistDataContractor){
        if(that.RegistDataContractor[data].value == '' && data != 'PolicyNumber'){
          console.log('未入力があります。');
          that.allOk = false;
          that.appendInput.style.display = 'none';
          that.errorImg.style.display = 'block';
          break;
        }else {
          console.log('すべておｋです。');
          that.allOk = true;
        }
      }
      if(that.allOk){
        console.log('画像が消えます');
        // that.errorImg = that.template.querySelector('.error-img');
        that.errorImg.style.display = 'none';
        that.appendInput.style.display = 'block';
      }
    }
    if(that.contractorType == 'other'){
      for(let data in that.RegistDataOther){
        if(that.isRegistered == 'On'){
          if(data != 'ContractorDaytimePhoneNumber' && data != 'PolicyNumber' && that.RegistDataOther[data].value == ''){
            console.log('未入力があります、その他問い合わせ用', data);
            that.allOk = false;
            that.appendInput.style.display = 'none';
            that.errorImg.style.display = 'block';
            break;
          }else {
            that.allOk = true;    
          }
          console.log('すべておｋです、問い合わせ用', that.allOk);
        }else if(that.isRegistered == 'Off'){
          if(data != 'ContractorRegisteredPhoneNumber' && data != 'PolicyNumber' && that.RegistDataOther[data].value == ''){
            console.log('未入力があります、その他問い合わせ用');
            that.allOk = false;
            that.appendInput.style.display = 'none';
            that.errorImg.style.display = 'block';
            break;
          }else {
            that.allOk = true;    
          }
          console.log('すべておｋです、問い合わせ用', that.allOk);
        }
      }
      if(that.allOk){
        console.log('画像が消えます、問い合わせ用');
        // that.errorImg = that.template.querySelector('.error-img');
        that.errorImg.style.display = 'none';
        that.appendInput.style.display = 'block';
      } 
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
    event.preventDefault();
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

    this.appendDiv.style.display = 'block';
    this.appendInput.style.display = 'block';


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
    if(this.contractorType == 'contractor'){
      Object.keys(this.RegistDataContractor).map(key=>{param[key]=this.RegistDataContractor[key].value})
    }else {
      Object.keys(this.RegistDataOther).map(key=>{param[key]=this.RegistDataOther[key].value})
    }
    console.log("##111111" , JSON.stringify(param));
    console.log("##111111" , Object.keys(this.RegistDataContractor));
    

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
        console.log('###3333 error', JSON.stringify(error));
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
        console.log('### success', res);

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