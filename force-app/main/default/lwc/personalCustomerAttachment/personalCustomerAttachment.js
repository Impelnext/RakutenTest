import { api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import { PubsubExtentions } from 'c/pubsubExtentions';
import siteIncResources from '@salesforce/resourceUrl/SiteInc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';

const MAX_FILESIZE = 10*1000000
const ATTACHMENT_ACCEPT = '.jpg,.gif,.png,image/gif,image/jpeg,image/png'

export default class PersonalCustomerAttachment extends PubsubExtentions {

  @api recordId
  @api objectApiName
  @api framePath

  linkIcon = `${siteIncResources}/template/images/icon_link.svg`;

  fileContents
  uploadedFile
  fileName
  contentType

  imgresult
  imgdata = []
  imgdataKeys = 'imagedata1,imagedata2,imagedata3,imagedata4,imagedata5'
  isLoading = false
  filesize
  companyName = null;


  // 確認画面への遷移
  status;

  onRecivedMessage(that, message){
    if(message.componentName=='status') that.status = message.componentValue;
    if(message.componentName == 'InsuranceCompany') that.companyName = message.componentValue;
  }

  async connectedCallback() {
    this.status = '';
    this.subscribeToMessageChannel(this ,this.onRecivedMessage);
    this.imgdata = []
    if(this.imgdataKeys) this.imgdataKeys.split(',').map((key,index)=>{this.imgdata.push({key:key ,label: '画像'+(index+1) ,value: null})})
    this.imgdata[0].disp = true;
    this.imgdata[1].disp = true;

    loadStyle(this, siteIncResources + '/template/css/style.css')

    await loadScript(this, siteIncResources + '/template/js/jquery-3.4.1.min.js');
    await loadScript(this, siteIncResources + '/template/js/lib.js')
    await loadScript(this, siteIncResources + '/template/js/common.js')
    // await loadScript(this, siteIncResources + '/template/js/jquery.qrcode.min.js');

    /*
    const qr = this.template.querySelector("[data-id='js-qrcode']");
    console.log('##qr',$(qr).length)
    if($(qr).length) {
      var qrtext = location.href;
      var utf8qrtext = unescape(encodeURIComponent(qrtext));
      $(qr).qrcode({width:100,height:100,text:utf8qrtext});
    }
    */
  }
  
  async renderedCallback(){

    if(!this.isQrLoaded) {
      await loadScript(this, siteIncResources + '/template/js/jquery.qrcode.min.js');
      const qr = this.template.querySelector("[data-id='js-qrcode']");
      console.log('###qr',$(qr).length)
      if($(qr).length) {
        var qrtext = location.href;
        var utf8qrtext = unescape(encodeURIComponent(qrtext));
        $(qr).qrcode({width:100,height:100,text:utf8qrtext});
        this.isQrLoaded = true
      }
    }

  }

  get isDisplay(){
    return (this.status == 'input' || this.status == 'confirm')
  }
  get isConfirm(){
    return (this.status == 'confirm')
  }

  get privacyPolicy() {
    if (this.companyName == '楽天損保' || this.companyName == '楽天ペット保険') {
      return 'https://www.rakuten-sonpo.co.jp/privacy/tabid/79/Default.aspx';
    } else {
      return 'https://www.rakuten-life.co.jp/privacy/';
    }
  }

  get InsuranceCompany() {
    if (this.companyName == '楽天損保' || this.companyName == '楽天ペット保険') {
      return '楽天損害保険';
    } else {
      return '楽天生命保険';
    }
  }

  init(){
      this.filesUploaded = []
      this.fileName = ''
      this.isLoading = false
  }

  imageChange(event){
    var dataid = event.target.dataset.id
    this.isLoading = true
    this.filesize = event.target.files[0].size;
    console.log('#### filesize', this.filesize);
    if ( this.filesize > MAX_FILESIZE ) {
        this.showNotification('ファイルサイズが大きすぎます', `ファイルサイズは${MAX_FILESIZE / 1000000}MBまでです。`, 'warning')
        this.init()
        return
    }
    this.filesUploaded = event.target.files
    this.fileName = event.target.files[0].name
    this.contentType = event.target.files[0].type
    console.log('####this.contentType',this.contentType)
    
    if ( ATTACHMENT_ACCEPT.indexOf(this.contentType) < 0 ) {
      this.showNotification('ファイルタイプが不正です', `画像の種類（拡張子）は、jpg、gif、png のいずれかで保存をお願いします。`, 'warning')
      this.init()
      return
    }
    
    console.log('##dataid', dataid);
    this.saveTemporarily(dataid);
  }

  saveTemporarily(itemkey){
      let _this = this

      const reader = new FileReader();
      reader.onloadend = function() {
          this.fileContents = reader.result;
          var index = _this.imgdata.findIndex(ele => ele.key == itemkey);
          _this.imgdata[index].value = this.fileContents;
          _this.imgdata[index].fileName = _this.fileName;
          _this.imgdata[index].confirm = true;
          if(index+1 != _this.imgdata.length) _this.imgdata[index + 1].disp = true; 
          console.log('##_this.imgdata',_this.imgdata);

          var base64Mark = 'base64,';
          var dataStart = this.fileContents.indexOf(base64Mark) + base64Mark.length;
          console.log('#dataStart',dataStart);
          this.fileContents = this.fileContents.substring(dataStart);

          _this.isLoading = false
          const payload = {componentName: itemkey ,componentValue:{value: _this.imgdata[index].value, name: _this.imgdata[index].fileName} }
          _this.publishToMessageChannel(payload);
      }
      reader.readAsDataURL(this.filesUploaded[0])
  }

  fileDelete(event){
    var dataid = event.target.dataset.id
    var parent = event.target.parentElement.parentElement
		var filePreview = parent.querySelector('.c-form_filePreview');
    filePreview.classList.remove('uploaded')

    var index = this.imgdata.findIndex(ele => ele.key == dataid);
    this.imgdata[index].value = null;
    this.imgdata[index].fileName = null;
    this.imgdata[index].confirm = false;
    console.log('###this.imgdata' ,this.imgdata)

    const payload = {componentName: dataid ,componentValue:{value: this.imgdata[index].value, name: this.imgdata[index].fileName} }
    this.publishToMessageChannel(payload);
  }

  showNotification(title, message, variant) {
      const event = new ShowToastEvent({
          title: title,
          message: message,
          variant: variant,
      })
      this.dispatchEvent(event)
  }

}