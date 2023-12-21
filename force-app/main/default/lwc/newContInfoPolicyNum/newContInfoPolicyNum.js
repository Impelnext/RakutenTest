import { wire, api } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';
import Company from '@salesforce/schema/Lead.Company';
import { CurrentPageReference } from 'lightning/navigation';

export default class ContInfoPolicyNum extends PubsubExtentions {
	@api itemKey;
	@api itemComment;
	@api typeSelectionLife;
	@api typeSelectionGen;
	@api typeSelectionPet;

	currentPageReference = null;
	urlStateParameters = null;
	company = null;
	formBlank = [];

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
		if(!this.iscalladdevent) {
		//   this.addEventInput();
		this.iscalladdevent = true;
		}
	}
	// 固有部品
	value = "";

	get life() {
		if(this.company =='life'){
			return this.company
		}
	}

	changeValueHandler(event) {
		if(this.company=='life'){
			if((event.target.value.match(/^([0-9]{8})$/)) || (event.target.value.match(/^([0-9]{10})$/))){
			this.value = event.target.value;
			const payload = {componentName:this.itemKey ,componentValue:this.value}
			this.publishToMessageChannel(payload);
			}else {
				let error = this.template.querySelector('.errorMsg');
				error.classList.add('show');
				this.value = '';
				event.target.value = '';
				const payload2 = {componentName:this.itemKey ,componentValue:''}
				this.publishToMessageChannel(payload2);
				setTimeout(function(){
					error.classList.remove('show');
				}, 5000);
			}
		}else if(this.company=='gen' || this.company=='pet'){
			if((event.target.value.match(/^[A-Za-z0-9]*$/))){
				this.value = event.target.value;
				const payload = {componentName:this.itemKey ,componentValue:this.value}
				this.publishToMessageChannel(payload);
			}else {
				let error = this.template.querySelector('.errorMsg');
				error.classList.add('show');
				this.value = '';
				event.target.value = '';
				const payload2 = {componentName:this.itemKey ,componentValue:''}
				this.publishToMessageChannel(payload2);
				setTimeout(function(){
					error.classList.remove('show');
				}, 5000);
			}
		}
	}

	get dispConfirm() {
		return this.value != '';
	}

	get dispComment() {
		return this.itemComment != '';
	}


	addEventInput(event) {
		let numChecks = this.template.querySelectorAll('.js-numCheck');
		console.log('### debbug' ,numChecks)
		for (let i = 0; i < numChecks.length; i++) {
			let numCheck  = numChecks[i];
			let type      = numCheck.dataset.numType;
			let len       = 0;
			let blowing   = document.createElement('div');
			let errText   = '';
			blowing.classList.add('js-numCheck__err');
			(numCheck.closest('.c-number-form')).style.position = 'relative';
			(numCheck.closest('.c-number-form')).appendChild(blowing);
			blowing.innerHTML = "<div>" + blowing.innerHTML + "</div>";
			const checkCount = () => {
			let errFlg   = false;
			let errColor = false;
			len = (numCheck.value).length;
			switch (type) {
				case '8':
				if (len > 0 && len < 8) {
					errText = '文字数が不足しています。ご確認ください。';
					errFlg = true;
				}
				break;
				case '8-10':
				if (len > 0 && len < 8) {
					errText = '文字数が不足しています。ご確認ください。';
					errFlg = true;
				}
				else if (len > 8 && len < 10) {
					errText = '文字数が誤っています。ご確認ください。';
					errFlg   = true;
					errColor = true;
				}
				break;
			}
			if (errFlg) {
				blowing.style.marginTop = '-10px';
				blowing.style.opacity   = '1';
			} else {
				blowing.style.marginTop = '0';
				blowing.style.opacity   = '0';
			}
			if (errColor) {
				(numCheck.closest('.c-number-form')).classList.add('is-error');
			} else {
				(numCheck.closest('.c-number-form')).classList.remove('is-error');
			}

			if (blowing.innerText !== errText) {
				blowing.childNodes[0].innerText = errText;
			}
			};
			numCheck.addEventListener('keyup',e=>{
			checkCount();
			});
			numCheck.addEventListener('focus',e=>{
			checkCount();
			});
			numCheck.addEventListener('blur',e=>{
			blowing.style.marginTop = '0';
			blowing.style.opacity   = '0';
			});
		}
	}

	@wire(CurrentPageReference)
	getStateParameters(currentPageReference) {
		if (currentPageReference) {
			this.urlStateParameters = currentPageReference.state;
			this.setParametersBasedOnUrl();
		}
	}

	getOptionsFromArray(str){
		let ret = []
		//if(str) str.split(',').map(key=>{ret.push({label:key ,value: key})})
		if(str) str.split(',').map((key, idx)=>{ret.push({label:key ,value: key, id:this.itemKey + '_0' + (idx + 1)})});
		return ret;
	}

	setParametersBasedOnUrl() {
		this.company = this.urlStateParameters.company || null;
	}

	//title文を3社で分けるための分岐
	get insuranceNumber(){
		if(this.company=='life'){
			return 'ご契約の証券番号、または会員（証書）番号'
		}
		else if(this.company=='gen'){
			return 'ご契約の証券番号（契約証番号）'
		}
		else if(this.company=='pet'){
			return 'ご契約の証券番号'
		}
	}

  //補足文を3社で分けるための分岐
	get insuranceNotes(){
		if(this.company=='life'){
			return '複数の契約がある場合はいずれか一つ<br/>'+
					'■生命保険：数字8桁<br/>'+
					'お手元の証券番号が12桁の場合は、中央の8桁のみ入力してください。（例：XXX-12345678-X）<br/>'+
					'■共済契約：数字10桁<br/>'+
					'お手元の会員(証書)番号が14桁の場合は、中央の10桁のみ入力してください。（例：XXX-1234567890-X）';
		}
		else if(this.company=='gen'){
			return '複数の契約がある場合はいずれか一つ<br/>'+
					'証券番号（契約証番号）：半角英数字';
		}
		else if(this.company=='pet'){
			return '複数の契約がある場合はいずれか一つ<br/>'+
					'証券番号：半角英数字';
		}
	}
}