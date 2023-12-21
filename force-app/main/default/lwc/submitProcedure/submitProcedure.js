import { wire ,api} from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';
import publishPlatformEvent from '@salesforce/apex/ExC_FormProcedureController.publishPlatformEvent';
import { CurrentPageReference, NavigationMixin} from 'lightning/navigation';
import sitePrcResources from '@salesforce/resourceUrl/SitePrc';

export default class SubmitProcedure extends NavigationMixin(PubsubExtentions) {

  @api companyName;
  @api procedureType;
  @api labelConfirmButton;
  @api labelModifyButton;
  @api labelRegistButton;
  @api labelRegistNote;
  @api keyRegistData;
  @api confirmPhaseKey;
  @api nameCompletePage;
  @api cancelAmt;
  @api cancelCont;
  @api cancelAnother;
  //2023/10/11 Add 不利益事項のチェック内容のオブジェクト連携  By 張　Start
  @api disadvantageOPT;
  //2023/10/11 Add 不利益事項のチェック内容のオブジェクト連携  By 張　End

  // 確認画面への遷移
  confirmPhase;
  registData;
  currentPageReference = null;
  urlStateParameters = null;
  isLoading = false
  confirmDisable = true;
  cautionIcon = `${sitePrcResources}/template/images/icon_caution.svg`;
  reasonAmt = null;
  reasonCont = null;
  reasonAnother = null;
  amtVal = '';
  contVal = '';
  anotherVal = '';
  payload2;
  reason1;
  reason2;
  reason3;
  //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 張　Start
  disadvantageOPT1;
  disadvantageOPT2;
  disadvantageOPT3;
  disadvantageOPT4;
  disadvantageOPT5;
  disadvantageOPT6;
  tmpArr = []; 
  //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 張　End

  propertySplit() {
    this.reason1 = this.cancelAmt ? this.cancelAmt.split(',') : null;
    this.reason2 = this.cancelCont ? this.cancelCont.split(',') : null;
    this.reason3 = this.cancelAnother ? this.cancelAnother.split(',') : null;
  }

  appendDiv
  appendInput

  connectedCallback() {
    this.propertySplit();
    this.confirmPhase = false;
    this.registData = {}
    if(this.keyRegistData)this.keyRegistData.split(',').map(key=>{this.registData[key]={value:'',status:''}})
    if(this.companyName) this.registData['ConfCompanyName'] = {value:this.companyName, status:''};
    if(this.procedureType) this.registData['ProcedureType'] = {value:this.procedureType, status:''};
    this.subscribeToMessageChannel(this ,this.onRecivedMessage);
    this.createInputElementForEFO(this);
    console.log("1.submitProcedure connectedCallback()");
    window.addEventListener("popstate", function (e) {
      console.log("1.2. FormAssist check");
      console.log(FormAssistTagCheck);
      FormAssistTagCheck = undefined;
      console.log("1.3.FormAssistTagCheck = undefined");
      console.log(FormAssistTagCheck);
      FormAssist.sInterval = undefined;
      console.log("1.4.FormAssist.sInterval = undefined;");
    });
  }

  renderedCallback(){
    this.appendDiv.style.cssText=(this.confirmPhase)?"display: none;":"";

    if(this.reasonAmt){
      for(let rsn1 of this.reason1){
        if(rsn1 == this.reasonAmt){
          console.log('正しいパラメータ');
          this.registData['CancelReason1'] = {value:this.reasonAmt, status:''};
          //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 張　Start
          this.SettingDisadvantages(this);
          //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 張　End
          break;
        }
      }
    }else if(this.reasonCont){
      for(let rsn2 of this.reason2){
        if(rsn2 == this.reasonCont){
          console.log('正しいパラメータ');
          this.registData['CancelReason2'] = {value:this.reasonCont, status:''};
          //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 張　Start
          this.SettingDisadvantages(this);
          //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 張　End
          break;
        }
      }
    }else if(this.reasonAnother){
      for(let rsn3 of this.reason3){
        if(rsn3 == this.reasonAnother){
          console.log('正しいパラメータ');
          this.registData['CancelReason3'] = {value:this.reasonAnother, status:''};
          //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 張　Start
          this.SettingDisadvantages(this);
          //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 張　End
          break;
        }
      }
    }
  }
  //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 張　Start
  SettingDisadvantages(){
    for (let i = 0; i < this.tmpArr.length; i++) {
      if(this.tmpArr[i] == this.disadvantageOPT){
        this.registData['disadvantageOPT'+(i+1)] = {value:this.disadvantageOPT, status:''};
      }     
    }   
  }
 //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携 By 張　End
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

  @wire(CurrentPageReference)
  getStateParameters(currentPageReference) {
     if (currentPageReference) {
        this.urlStateParameters = currentPageReference.state;
        this.setParametersBasedOnUrl();
     }
  }

  setParametersBasedOnUrl() {
      this.reasonAmt = this.urlStateParameters.reason1 ? decodeURI(this.urlStateParameters.reason1) : null;
      //2023/10/02 Add 不利益事項のチェック内容のオブジェクト連携  By 張　Start
      this.disadvantageOPT1 = this.urlStateParameters.disadvantageOPT1 ? decodeURI(this.urlStateParameters.disadvantageOPT1) : null;
      this.disadvantageOPT2 = this.urlStateParameters.disadvantageOPT2 ? decodeURI(this.urlStateParameters.disadvantageOPT2) : null;
      this.disadvantageOPT3 = this.urlStateParameters.disadvantageOPT3 ? decodeURI(this.urlStateParameters.disadvantageOPT3) : null;
      this.disadvantageOPT4 = this.urlStateParameters.disadvantageOPT4 ? decodeURI(this.urlStateParameters.disadvantageOPT4) : null;
      this.disadvantageOPT5 = this.urlStateParameters.disadvantageOPT5 ? decodeURI(this.urlStateParameters.disadvantageOPT5) : null;
      this.disadvantageOPT6 = this.urlStateParameters.disadvantageOPT6 ? decodeURI(this.urlStateParameters.disadvantageOPT6) : null;
      this.tmpArr.push(this.disadvantageOPT1);
      this.tmpArr.push(this.disadvantageOPT2);
      this.tmpArr.push(this.disadvantageOPT3);
      this.tmpArr.push(this.disadvantageOPT4);
      this.tmpArr.push(this.disadvantageOPT5);
      this.tmpArr.push(this.disadvantageOPT6);
      //2023/10/02 Add 不利益事項のチェック内容のオブジェクト連携  By 張　End
      this.reasonCont = this.urlStateParameters.reason2 ? decodeURI(this.urlStateParameters.reason2) : null;
      this.reasonAnother = this.urlStateParameters.reason3 ? decodeURI(this.urlStateParameters.reason3) : null;
      console.log('submit@1', this.reasonAmt);
  }

  /* handlar */
  clickConfirm(){
    this.isLoading = true
    this.confirmPhase = true;
    const payload = {componentName:this.confirmPhaseKey ,componentValue:this.confirmPhase}
    this.publishToMessageChannel(payload);

    //this.publishToMessageChannel({componentName:'buttonConfirmation' ,componentValue:this.confirmPhase});

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
    let _target = event.target;
    let param = {};
    console.log("##" , this.registData);
    Object.keys(this.registData).map(key=>{param[key]=this.registData[key].value})
    console.log("##" , param);

    publishPlatformEvent({ //imperative Apex call
      jsonData: JSON.stringify(param)
    })
      .then(res => {
        console.log('### success', res)
        this.moveToCompletePage()
      })
      .catch(error => {
        console.log('### error', error)
        alert('処理が失敗しました、再度お試しください');
        event.target.disabled = false;
        _target.disabled = false;
      });
  }

  moveToCompletePage(){
    let _this = this
    this[NavigationMixin.Navigate]({
      type: 'comm__namedPage',
      attributes: {
          name: _this.nameCompletePage
      }
    });
  }


}