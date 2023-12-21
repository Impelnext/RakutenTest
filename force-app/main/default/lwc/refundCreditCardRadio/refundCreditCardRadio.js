import { api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';


export default class RefundCreditCardRadio extends PubsubExtentions {
    @api itemKey;

    value = '';
    valueBankType = '';
    insurance = '';
    valueBookSymbol = '';
    valueBookNum = '';
    valueBank = '';
    valueBranch = '';
    valueDepositType = '';
    valueAccNum = '';

    // 確認画面への遷移
    confirmPhase;
  
    onRecivedMessage(that, message){
      if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
    }
      
    connectedCallback() {
        this.confirmPhase = false;
        this.subscribeToMessageChannel(this ,this.onRecivedMessage);
    }

    renderedCallback() {
        const rdo = this.template.querySelector('input[value="' + this.value + '"]')
        if (rdo) rdo.checked = true;
        const bnk = this.template.querySelector('input[value="' + this.valueBankType + '"]');
        if (bnk) bnk.checked = true;
        const slt = this.template.querySelector('select');
        if (slt) slt.value = this.valueDepositType;
    }

    get options() {
        return [
	{ label: '契約がある', value: '契約がある' },
	{ label: '契約がない', value: '契約がない' },
					
        ];
    }

    get dispCreditCard() {
        return this.value == '契約がある';
    }
    get styleCreditCard() {
      return this.dispCreditCard ? 'display: block;' : 'display: none;'
    }
  
    get dispPostBank() {
        return this.dispCreditCard && this.valueBankType == 'ゆうちょ銀行';
    }
    get stylePostBank() {
      return this.dispPostBank ? 'display: block;' : 'display: none;'
    }
    get disabledPostBankInputs() {
      return !this.dispPostBank;
    }

    get dispOtherBank() {
        return this.dispCreditCard && this.valueBankType == 'その他銀行';
    }
    get styleOtherBank() {
      return this.dispOtherBank ? 'display: block;' : 'display: none;'
    }
    get disabledOtherBankInputs() {
      return !this.dispOtherBank;
    }

    changeRadioHandler(event) {
        this.value = event.target.value;
        const payload = {componentName:this.itemKey ,componentValue:this.value == '契約がある'}
        this.publishToMessageChannel(payload);
        this.publishToMessageChannel({componentName:'CreditCardRadio' ,componentValue:this.value});
        if (this.dispCreditCard) {
            if (this.dispPostBank) {
                this.publishToMessageChannel({componentName:'ConfRefundAccInfoBank' ,componentValue:this.valueBankType});
                this.publishToMessageChannel({componentName:'ConfRefundAccInfoBranch' ,componentValue:''});
                this.publishToMessageChannel({componentName:'ConfRefundAccInfoDepoType' ,componentValue:''});
                this.publishToMessageChannel({componentName:'ConfRefundAccInfoAccNum' ,componentValue:''});
                this.publishToMessageChannel({componentName:'ConfRefundAccInfoPassbookSymbol' ,componentValue:this.valueBookSymbol});
                this.publishToMessageChannel({componentName:'ConfRefundAccInfoPassbookNum' ,componentValue:this.valueBookNum});
            } else {
                this.publishToMessageChannel({componentName:'ConfRefundAccInfoBank' ,componentValue:this.valueBank});
                this.publishToMessageChannel({componentName:'ConfRefundAccInfoBranch' ,componentValue:this.valueBranch});
                this.publishToMessageChannel({componentName:'ConfRefundAccInfoDepoType' ,componentValue:this.valueDepositType});
                this.publishToMessageChannel({componentName:'ConfRefundAccInfoAccNum' ,componentValue:this.valueAccNum});
                this.publishToMessageChannel({componentName:'ConfRefundAccInfoPassbookSymbol' ,componentValue:''});
                this.publishToMessageChannel({componentName:'ConfRefundAccInfoPassbookNum' ,componentValue:''});
            }
        } else {
            this.publishToMessageChannel({componentName:'ConfRefundAccInfoBank' ,componentValue:''});
            this.publishToMessageChannel({componentName:'ConfRefundAccInfoBranch' ,componentValue:''});
            this.publishToMessageChannel({componentName:'ConfRefundAccInfoDepoType' ,componentValue:''});
            this.publishToMessageChannel({componentName:'ConfRefundAccInfoAccNum' ,componentValue:''});
            this.publishToMessageChannel({componentName:'ConfRefundAccInfoPassbookSymbol' ,componentValue:''});
            this.publishToMessageChannel({componentName:'ConfRefundAccInfoPassbookNum' ,componentValue:''});
        }
    }

    changeRadioBankTypeHandler(event) {
        this.valueBankType = event.target.value;
        if (this.dispPostBank) {
            const payload = {componentName:'ConfRefundAccInfoBank' ,componentValue:this.valueBankType};
            this.publishToMessageChannel(payload);
            this.publishToMessageChannel({componentName:'ConfRefundAccInfoBranch' ,componentValue:''});
            this.publishToMessageChannel({componentName:'ConfRefundAccInfoDepoType' ,componentValue:''});
            this.publishToMessageChannel({componentName:'ConfRefundAccInfoAccNum' ,componentValue:''});
            this.publishToMessageChannel({componentName:'ConfRefundAccInfoPassbookSymbol' ,componentValue:this.valueBookSymbol});
            this.publishToMessageChannel({componentName:'ConfRefundAccInfoPassbookNum' ,componentValue:this.valueBookNum});
        } else {
            const payload = {componentName:'ConfRefundAccInfoBank' ,componentValue:''};
            this.publishToMessageChannel(payload);
            if (this.valueDepositType == '') {
                this.valueDepositType = '普通預金';
            }
            this.publishToMessageChannel({componentName:'ConfRefundAccInfoBranch' ,componentValue:this.valueBranch});
            this.publishToMessageChannel({componentName:'ConfRefundAccInfoDepoType' ,componentValue:this.valueDepositType});
            this.publishToMessageChannel({componentName:'ConfRefundAccInfoAccNum' ,componentValue:this.valueAccNum});
            this.publishToMessageChannel({componentName:'ConfRefundAccInfoPassbookSymbol' ,componentValue:''});
            this.publishToMessageChannel({componentName:'ConfRefundAccInfoPassbookNum' ,componentValue:''});
        }
        this.publishToMessageChannel({componentName:'CreditCardBank' ,componentValue:this.valueBankType});

    }

    changeValuePassbookSymbolHandler(event) {
        this.valueBookSymbol = event.target.value;
        const payload = {componentName:'ConfRefundAccInfoPassbookSymbol' ,componentValue:this.valueBookSymbol};
        this.publishToMessageChannel(payload);
    }

    changeValuePassbookNumHandler(event) {
        this.valueBookNum = event.target.value;
        const payload = {componentName:'ConfRefundAccInfoPassbookNum' ,componentValue:this.valueBookNum};
        this.publishToMessageChannel(payload);
    }

    changeValueBankNameHandler(event) {
        this.valueBank = event.target.value;
        const payload = {componentName:'ConfRefundAccInfoBank' ,componentValue:this.valueBank};
        this.publishToMessageChannel(payload);
    }

    changeValueBranchNameHandler(event) {
        this.valueBranch = event.target.value;
        const payload = {componentName:'ConfRefundAccInfoBranch' ,componentValue:this.valueBranch};
        this.publishToMessageChannel(payload);
    }

    changeValueDepositTypeHandler(event) {
        this.valueDepositType = event.target.value;
        const payload = {componentName:'ConfRefundAccInfoDepoType' ,componentValue:this.valueDepositType};
        this.publishToMessageChannel(payload);
    }

    changeValueAccNumHandler(event) {
        this.valueAccNum = event.target.value;
        const payload = {componentName:'ConfRefundAccInfoAccNum' ,componentValue:this.valueAccNum};
        this.publishToMessageChannel(payload);
    }
}