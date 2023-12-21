import { LightningElement , api , wire } from 'lwc';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import RakutenIpFAQResources from '@salesforce/resourceUrl/RakutenIpFAQResources';
import { loadStyle } from 'lightning/platformResourceLoader';
// Add 2023/08/10 【RIPCRM-983】次世代CC_検索結果0件ワード収集 By 張　Start
import getKnowledge from '@salesforce/apex/KnowledgeHelper.getKnowledge';
// Add 2023/08/10 【RIPCRM-983】次世代CC_検索結果0件ワード収集 By 張　End
export default class FaqKnowledgeSearch extends NavigationMixin(LightningElement) {

	@api searchKeyWord;
	@api companyName;

	isResultPage;
	inputSearchKeyWord;
	howToMessage;
	tmpKeyWord;
	hasError;
	// Add 2023/08/10 【RIPCRM-983】次世代CC_検索結果0件ワード収集 By 張　Start
	recordCount;
	// Add 2023/08/10 【RIPCRM-983】次世代CC_検索結果0件ワード収集 By 張　End
	// URLからパラメータを取得
	@wire(CurrentPageReference)
	getStateParameters(currentPageReference) {
		if (currentPageReference) {
			this.searchKeyWord = currentPageReference.state?.searchKeyWord;
		}
	}

	// 初期処理
    connectedCallback() {
        loadStyle(this, RakutenIpFAQResources + '/css/style.css');
		if(this.searchKeyWord === undefined){
			this.isResultPage = false;
			this.inputSearchKeyWord = '';
		}else{
			this.isResultPage = true;
			this.inputSearchKeyWord = this.searchKeyWord;
		}
		this.hasError = this.inputCheck();
    }

	// 検索
	searchClick() {
		this.navigateToSearchResultPage();
	}

	// クリア
    clearClick() {
        this.inputSearchKeyWord = '';
    }

	// 画面遷移
	// modifiy 2023/08/10 【RIPCRM-983】次世代CC_検索結果0件ワード収集 By 張　Start
    /* navigateToSearchResultPage() { */
	async navigateToSearchResultPage() {
	// modifiy 2023/08/10 【RIPCRM-983】次世代CC_検索結果0件ワード収集 By 張　End
		this.inputSearchKeyWord = this.tmpKeyWord;
		this.searchKeyWord = this.inputSearchKeyWord;
		let encodedSearchKeyWord = encodeURIComponent(this.searchKeyWord);
		// Add 2023/08/10 【RIPCRM-983】次世代CC_検索結果0件ワード収集 By 張　Start
		let searchParameters = {
			procName:'検索結果',
			categoryGroupName: this.companyName,
			limitSize:0,
			option : this.searchKeyWord,
		};
		await getKnowledge(searchParameters)
		.then((result) => {
			this.recordCount = result.length;
		  })
		  .catch((error) => {
			console.log('----error----->:'+error);
		});
		// Add 2023/08/10 【RIPCRM-983】次世代CC_検索結果0件ワード収集 By 張　End
		// 検索結果画面へ遷移
		// modifiy 2023/08/10 【RIPCRM-983】次世代CC_検索結果0件ワード収集 By 張　Start
		/* this[NavigationMixin.Navigate]({ */
		await this[NavigationMixin.Navigate]({
	    // modifiy 2023/08/10 【RIPCRM-983】次世代CC_検索結果0件ワード収集 By 張　End
			type: 'standard__webPage',
			attributes: {
				// modifiy 2023/08/10 【RIPCRM-983】次世代CC_検索結果0件ワード収集 By 張　Start
				/* url: `/global-search?searchKeyWord=${encodedSearchKeyWord}` */
				url: `/global-search?searchKeyWord=${encodedSearchKeyWord}&result=${this.recordCount}`
				// modifiy 2023/08/10 【RIPCRM-983】次世代CC_検索結果0件ワード収集 By 張　End
			}
		});
    }

	// 検索ボックスハンドリング
    handleInput(event) {
        this.inputSearchKeyWord = event.target.value;
		this.hasError = this.inputCheck();
		if(event.keyCode === 13 && !this.hasError){
			this.searchClick();
		}
    }

	// 入力チェック
	inputCheck() {
		this.tmpKeyWord = this.inputSearchKeyWord;
		let arrayKeyWords = [];

		// 全角スペース、連続したスペースを半角スペースに変換
		this.tmpKeyWord = this.tmpKeyWord.replaceAll(/　/g,' ');
		this.tmpKeyWord = this.tmpKeyWord.replace(/  +/g, ' ');
		this.tmpKeyWord = this.tmpKeyWord.trimEnd();
		this.tmpKeyWord = this.tmpKeyWord.trimStart();

		// 入力文字が全体で1文字の場合エラー
		if(this.tmpKeyWord.length < 2){
			return true;
		}

		// 入力単語を3単語に丸める
		arrayKeyWords = this.tmpKeyWord.split(' ',3);
		this.tmpKeyWord = arrayKeyWords.join(' ');

		return false;
	}

    // 虫眼鏡のアイコン画像定義
	get appResources() {
		return {
			lens: `${RakutenIpFAQResources}/images/icon_lens.svg`
		}
	}

	// 検索方法表示制御
	get getHowToMessage() {
		if(this.companyName == 'CategoryGroupLife'){
			this.howToMessage = '';
		}else if(this.companyName == 'CategoryGroupInsurance'){
			this.howToMessage = '例：「住所変更」「自動車保険」のように複数のキーワードで検索すると見つけやすくなります。';
		}else if(this.companyName == 'CategoryGroupPet'){
			this.howToMessage = '例：「保険金」「スーパーペット保険」のように複数のキーワードで検索すると見つけやすくなります。';
		}else{
			this.howToMessage = '';
		}
		return this.howToMessage;
	}

}