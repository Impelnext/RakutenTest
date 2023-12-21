import { wire} from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';
import checkURLPassword from '@salesforce/apex/ExC_FileUploadController.checkURLPassword';
import { CurrentPageReference} from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

export default class LoginFormWithLimited extends PubsubExtentions {
  status;
  message;
  key;
  pass;
  errorMsg;

  connectedCallback() {
    this.status = 'init';
    const payload = {componentName:'status' ,componentValue:this.status}
    this.publishToMessageChannel(payload);
  }

  @wire(CurrentPageReference)
  getStateParameters(currentPageReference) {
     if (currentPageReference) {
        this.urlStateParameters = currentPageReference.state;
        this.setParametersBasedOnUrl();
     }
  }
  setParametersBasedOnUrl() {
    this.key = this.urlStateParameters.key || null;
  }

  onChangePass(event) {
    this.pass = event.target.value;
  }

  clickLogin(event){
    event.preventDefault();
    this.errorMsg = '';
    if(!this.pass){
      this.errorMsg = 'パスワードを入力してください';
      return;
    }
    let _this = this
    checkURLPassword({ //imperative Apex call
      key: this.key,
      pass: this.pass
    })
      .then(res => {
        console.log('### success', res)
        let resobj = JSON.parse(res)
        if(resobj.IsSuccess){
          this.successLogin(resobj)
        }else{
          this.errorMsg = resobj.Message
        }
      })
      .catch(error => {
        console.log('### error', error)

      });
  }

  successLogin(res){
    if(this.pass){
      this.status = 'input'
      const payload = {componentName:'status' ,componentValue:this.status}
      this.publishToMessageChannel(payload);

      const guidanceCustomerName = {componentName:'GuidanceCustomerName' ,componentValue: res.GuidanceCustomerName}
      const guidanceMessage = {componentName:'GuidanceMessage' ,componentValue: res.GuidanceMessage}
      const insuranceCompany = {componentName: 'InsuranceCompany', componentValue: res.InsuranceCompany};
      this.publishToMessageChannel(guidanceCustomerName);
      this.publishToMessageChannel(guidanceMessage);
      this.publishToMessageChannel(insuranceCompany);

      const key = {componentName:'key' ,componentValue: this.key}
      const pass = {componentName:'pass' ,componentValue: this.pass}
      this.publishToMessageChannel(key);
      this.publishToMessageChannel(pass);

    }
  }

  get isDisplay(){
    return (this.status == 'init')
  }

}