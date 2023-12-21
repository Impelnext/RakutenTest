import { PubsubExtentions } from 'c/pubsubExtentions';

export default class PersonalMessage extends PubsubExtentions {
  // 確認画面への遷移
  status;
  
  htmlMsg
  GuidanceMessage
  GuidanceMessageKeys = 'GuidanceCustomerName,GuidanceMessage,LastName,FirstName,CustomerMessage'

  CustomerQuestion

  connectedCallback() {
    this.GuidanceMessage={}
    if(this.GuidanceMessageKeys)this.GuidanceMessageKeys.split(',').map(key=>{this.GuidanceMessage[key]=null})

    this.status = '';
    this.subscribeToMessageChannel(this ,this.onRecivedMessage);
  }
  
  onRecivedMessage(_this, message){
    console.log('Recieveed message', message);

    if(message.componentName=='status') _this.status = message.componentValue;
    if(message.componentName in _this.GuidanceMessage) _this.GuidanceMessage[message.componentName] = message.componentValue;
  
    if (message.componentName == 'GuidanceMessage') {
      if (message.componentValue == null) {
        _this.htmlMsg = '';
      } else {
        _this.htmlMsg = message.componentValue.replace(/(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig,"<a href='$1'>$1</a>");
      }
    }
  }

  renderedCallback() {
    const msgdiv = this.template.querySelector('.GuidanceMessage');
    if (msgdiv) msgdiv.innerHTML = this.htmlMsg;
  }

  get isDisplay(){
    return (this.status == 'input' || this.status == 'confirm')
  }
  get displayStyle(){
    return this.isDisplay ? 'display: block;' : 'display: none;'
  }
  get isConfirm(){
    return (this.status == 'confirm')
  }

  onChangeCustomerQuestion(event){
    this.CustomerQuestion = event.target.value;
    const payload = {componentName:'CustomerQuestion' ,componentValue:this.CustomerQuestion}
    this.publishToMessageChannel(payload);
  }
}