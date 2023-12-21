import { wire ,api} from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';
import { CurrentPageReference, NavigationMixin} from 'lightning/navigation';
import updateURLWithLimited from '@salesforce/apex/ExC_FileUploadController.updateURLWithLimited';
import issueSiteProcessId from '@salesforce/apex/ExC_FileUploadController.issueSiteProcessId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

export default class SubmitPersonalInfo extends NavigationMixin(PubsubExtentions) {

  @api nameCompletePage

  siteProcessId
  imagedata1={}
  imagedata2={}
  imagedata3={}
  imagedata4={}
  imagedata5={}
  uploadData = []
  uploadDataIndex

  GuidanceMessage
  GuidanceMessageKeys = 'CustomerQuestion,pass,key'

  submitStatus = ''
  isLoading = false

  // 画面の遷移
  status;
  timeIntervalInstance;

  get isDisplay(){
    return (this.status == 'input' || this.status == 'confirm')
  }
  get isConfirm(){
    return (this.status == 'confirm')
  }

  connectedCallback() {
    this.status = '';
    
    this.registData = {'imagedata1': null, 'imagedata2': null}
    this.GuidanceMessage={}
    if(this.GuidanceMessageKeys)this.GuidanceMessageKeys.split(',').map(key=>{this.GuidanceMessage[key]=null})

    this.subscribeToMessageChannel(this ,this.onRecivedMessage);
    //window.addEventListener('message', this.handleMessageFileUpVF);
    window.addEventListener('message', this.handleMessageFileUpVF.bind(this));

    this.createInputElementForEFO(this)
  }
  onRecivedMessage(that, message){
    console.log('Recieveed message', message);
    if(message.componentName == 'imagedata1') {
      that.registData['imagedata1'] = message.componentValue;
      that.imagedata1 = message.componentValue;
    }
    if(message.componentName == 'imagedata2') {
      that.registData['imagedata2'] = message.componentValue;
      that.imagedata2 = message.componentValue;
    }
    if(message.componentName == 'imagedata3') {
      that.registData['imagedata3'] = message.componentValue;
      that.imagedata3 = message.componentValue;
    }
    if(message.componentName == 'imagedata4') {
      that.registData['imagedata4'] = message.componentValue;
      that.imagedata4 = message.componentValue;
    }
    if(message.componentName == 'imagedata5') {
      that.registData['imagedata5'] = message.componentValue;
      that.imagedata5 = message.componentValue;
    }
    if(message.componentName=='status') that.status = message.componentValue;
    if(message.componentName in that.GuidanceMessage) that.GuidanceMessage[message.componentName] = message.componentValue;

  }
  renderedCallback(){
    this.appendDiv.style.cssText=(this.isDisplay && !this.isConfirm)?"":"display: none;"

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
      this.appendInput.value="入力内容を確認する"
      this.appendInput.onclick =function(e){e.preventDefault();_this.onClickInputConfirm(e)};
  
      this.appendDiv.appendChild(this.appendInput)
      this.template.appendChild(this.appendDiv);

    }
  }
  onClickInputConfirm(){
    this.status = 'confirm'
    const payload = {componentName:'status' ,componentValue:this.status}
    this.publishToMessageChannel(payload);

    const payload2 = {componentName:'confirmPhase' ,componentValue:true}
    this.publishToMessageChannel(payload2);

    const scrollOptions = {
        left: 0,
        top: 0,
        // behavior: 'smooth'
    }
    window.scrollTo(scrollOptions);
    setTimeout(() => {this.isLoading = false}, 1000);
  }
  onClickModify(){
    this.status = 'input'
    const payload = {componentName:'status' ,componentValue:this.status}
    this.publishToMessageChannel(payload);

    const payload2 = {componentName:'confirmPhase' ,componentValue:false}
    this.publishToMessageChannel(payload2);
  }
  startSubmitPersonalInfo(){
    let _this = this
    let param = this.GuidanceMessage
    issueSiteProcessId({ //imperative Apex call
      key: this.GuidanceMessage.key,
      pass: this.GuidanceMessage.pass,
      jsonData: JSON.stringify(param)
    })
      .then(res => {
        console.log('### success', res)
        let resobj = JSON.parse(res)
        if(resobj.IsSuccess){
          _this.siteProcessId = resobj.SiteProcessId
          _this.handleFileup()
        }else{
          this.showNotification('エラー', resobj.Message, 'error')
        }
      })
      .catch(error => {
        console.log('### error', error)

      });
  }
  submitPersonalInfo(){
    let _this = this
    let param = this.GuidanceMessage
    updateURLWithLimited({ //imperative Apex call
      key: this.GuidanceMessage.key,
      pass: this.GuidanceMessage.pass,
      jsonData: JSON.stringify(param)
    })
      .then(res => {
        console.log('### success', res)
        let resobj = JSON.parse(res)
        if(resobj.IsSuccess){
          _this.moveToCompletePage()
        }else{
          this.showNotification('エラー', resobj.Message, 'error')
          const btn = _this.template.querySelector('button.c-btn_submit');
          if (btn) btn.disabled = false;
        }
      })
      .catch(error => {
        console.log('### error', error)
        alert('処理が失敗しました、再度お試しください');
        const btn = _this.template.querySelector('button.c-btn_submit');
        if (btn) btn.disabled = false;
    });
  }
  moveToCompletePage(){
    let _this = this
    this[NavigationMixin.Navigate]({
      type: 'comm__namedPage',
      attributes: {
          name: _this.nameCompletePage
      },
      state:  {
      }
    });
  }
  handleFileup(event){
    event.preventDefault();
    console.log('### Online', navigator.onLine);
    if (!navigator.onLine) {
      alert('通信状況を確認いただき通信可能な環境で再度お試しください。');
      return false;
    }
    event.target.disabled = true;
    this.isLoading = true
    this.submitStatus = '実行中';
    console.log('###handleFileup')
    if(this.imagedata1.value) this.uploadData.push(this.imagedata1);
    if(this.imagedata2.value) this.uploadData.push(this.imagedata2);
    if(this.imagedata3.value) this.uploadData.push(this.imagedata3);
    if(this.imagedata4.value) this.uploadData.push(this.imagedata4);
    if(this.imagedata5.value) this.uploadData.push(this.imagedata5);

    if(this.uploadData.length>0) {
      this.uploadDataIndex=0;
      this.uploadFile(this.uploadDataIndex)
    }else{
      this.submitPersonalInfo();
    };
  }

  uploadFile(fileIndex){
    var fileContents = this.uploadData[fileIndex].value;
    var base64Mark = 'base64,';
    var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
    let fileBody = fileContents.substring(dataStart);
    console.log('###uploadFile')

    let _this = this
    let message = {
      key : this.GuidanceMessage.key,
      pass : this.GuidanceMessage.pass,
      fileName : this.uploadData[fileIndex].name,
      fileBody :fileBody
    };
    console.log('###message',message)

    this.template.querySelector('iframe').contentWindow.postMessage(message, '*');

  }

  handleMessageFileUpVF(){
    console.log('###handleMessageFileUpVF test',this.isLoading);
    console.log('###uploadDataIndex',this.uploadDataIndex);
    if(this.uploadData.length==0) return;
    
    this.uploadDataIndex+=1;
    if(this.uploadData.length<=this.uploadDataIndex) {
      this.isLoading = false;
      this.submitStatus = null;
      this.submitPersonalInfo();
    }else{
      this.uploadFile(this.uploadDataIndex)
    };

    console.log('###handleMessageFileUpVF',this.isLoading);
  }

  showNotification(title, message, variant) {
    const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
    })
    this.dispatchEvent(event)
  }

  start(event) {
      var parentThis = this;
      this.isLoading = true;
      // Run timer code in every 100 milliseconds
      this.timeIntervalInstance = setInterval(function() {


          parentThis.status = 100;
      }, 3000);
  }
}