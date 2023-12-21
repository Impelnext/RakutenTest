import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';


export default class cancelProduct extends PubsubExtentions {
    value = '';
    @api itemKey;

    get options() {
        return [
            { label: '終身・定期総合医療共済／メディエイド（旧メディ)', value: '終身・定期総合医療共済　／　メディエイド（旧メディ）', id: 'CancelProduct1' },
            { label: '災害保障共済　／　キュアエイド', value: '災害保障共済　／　キュアエイド', id: 'CancelProduct2' },
            { label: '重度障害共済　／　ライフエイド', value: '重度障害共済　／　ライフエイド', id: 'CancelProduct3' },
			{ label: '介護保障付特定疾病医療特約　／　メディエイドα', value: '介護保障付特定疾病医療特約　／　メディエイドα', id: 'CancelProduct4' },
			{ label: 'ガン保障付生命共済　／　マックエイド（旧マック）', value: 'ガン保障付生命共済　／　マックエイド（旧マック）', id: 'CancelProduct5' },
			{ label: '10年定期生命共済　／　リバイブ（旧アライブ）', value: '10年定期生命共済　／　リバイブ（旧アライブ）', id: 'CancelProduct6' },
        ];
    }

    // 確認画面への遷移
    confirmPhase;
    productCancel;
    disp1 = false;
    disp2 = false;
    disp3 = false;
    disp4 = false;
    disp5 = false;
    disp6 = false;
    value1 = "";
    value2 = "";
    value3 = "";
    value4 = "";
    value5 = "";
    value6 = "";

    onRecivedMessage(that, message){
        if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
        if (message.componentName=='CancelProduct') {
            that.productCancel = message.componentValue;
            if (that.dispInput) {
                that.publishToMessageChannel({componentName:'CancelProduct1' ,componentValue:that.value1});
                that.publishToMessageChannel({componentName:'CancelProduct2' ,componentValue:that.value2});
                that.publishToMessageChannel({componentName:'CancelProduct3' ,componentValue:that.value3});
                that.publishToMessageChannel({componentName:'CancelProduct4' ,componentValue:that.value4});
                that.publishToMessageChannel({componentName:'CancelProduct5' ,componentValue:that.value5});
                that.publishToMessageChannel({componentName:'CancelProduct6' ,componentValue:that.value6});
            } else {
                that.publishToMessageChannel({componentName:'CancelProduct1' ,componentValue:''});
                that.publishToMessageChannel({componentName:'CancelProduct2' ,componentValue:''});
                that.publishToMessageChannel({componentName:'CancelProduct3' ,componentValue:''});
                that.publishToMessageChannel({componentName:'CancelProduct4' ,componentValue:''});
                that.publishToMessageChannel({componentName:'CancelProduct5' ,componentValue:''});
                that.publishToMessageChannel({componentName:'CancelProduct6' ,componentValue:''});
            }
        }
    }
        
    connectedCallback() {
        this.confirmPhase = false;
        this.subscribeToMessageChannel(this ,this.onRecivedMessage);
    }

    renderedCallback() {
        const chk1 = this.template.querySelector('input[value="' + this.options[0].value + '"]');
        if (chk1) chk1.checked = this.disp1;
        const chk2 = this.template.querySelector('input[value="' + this.options[1].value + '"]');
        if (chk2) chk2.checked = this.disp2;
        const chk3 = this.template.querySelector('input[value="' + this.options[2].value + '"]');
        if (chk3) chk3.checked = this.disp3;
        const chk4 = this.template.querySelector('input[value="' + this.options[3].value + '"]');
        if (chk4) chk4.checked = this.disp4;
        const chk5 = this.template.querySelector('input[value="' + this.options[4].value + '"]');
        if (chk5) chk5.checked = this.disp5;
        const chk6 = this.template.querySelector('input[value="' + this.options[5].value + '"]');
        if (chk6) chk6.checked = this.disp6;
    }

    get dispInput() {
        return !this.confirmPhase && this.productCancel;
    }
    get styleInput() {
      return this.dispInput ? 'display: block;' : 'display: none;'
    }

    get dispConfirm() {
        return this.confirmPhase && this.productCancel;
    }

    changeCheckedHandler(event) {
        const itemName = event.target.dataset.id;
        const checked = event.target.checked;
        const itemValue = event.target.value;
        console.log('###' + itemName);
        console.log('###' + checked + ' : ' + itemValue);
        
        if (checked) {
            const payload = {componentName:itemName ,componentValue:itemValue};
            this.publishToMessageChannel(payload);
        } else {
            const payload = {componentName:itemName ,componentValue:''};
            this.publishToMessageChannel(payload);
        }
        
        if (itemName == 'CancelProduct1') {
            this.disp1 = checked;
            if (checked) {
                this.value1 = itemValue;
            } else {
                this.value1 = '';
            }
        } else if (itemName == 'CancelProduct2') {
            this.disp2 = checked;
            if (checked) {
                this.value2 = itemValue;
            } else {
                this.value2 = '';
            }
        } else if (itemName == 'CancelProduct3') {
            this.disp3 = checked;
            if (checked) {
                this.value3 = itemValue;
            } else {
                this.value3 = '';
            }
        } else if (itemName == 'CancelProduct4') {
            this.disp4 = checked;
            if (checked) {
                this.value4 = itemValue;
            } else {
                this.value4 = '';
            }
        } else if (itemName == 'CancelProduct5') {
            this.disp5 = checked;
            if (checked) {
                this.value5 = itemValue;
            } else {
                this.value5 = '';
            }
        } else if (itemName == 'CancelProduct6') {
            this.disp6 = checked;
            if (checked) {
                this.value6 = itemValue;
            } else {
                this.value6 = '';
            }
        }
        
    }
}