import { LightningElement, api, wire } from 'lwc';
import getKnowledge from '@salesforce/apex/KnowledgeHelper.getKnowledge';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import RakutenIpFAQResources from '@salesforce/resourceUrl/RakutenIpFAQResources';
import { loadStyle } from 'lightning/platformResourceLoader';

export default class FaqQAList extends NavigationMixin(LightningElement) {
	// コンポーネントプロパティ
	@api isDisplaySearchResult;
	@api isDisplayCountResult;
	@api isDisplayReadmore;
	@api callProcess
	@api companyName
	@api initialDisplayCount
	@api searchLimit

	// コンポーネント属性
	@api searchKeyWord
	@api searchCategory
	knowledges;
	displayKnowledges;
	recordCount;
	isHideButtonReadMore;
	saveState;
	loading = false;
	error;

	// URLからパラメータを取得
	@wire(CurrentPageReference)
	getStateParameters(currentPageReference) {
		if (currentPageReference) {
			currentPageReference.state?.categoryApiName 
			? this.searchCategory = currentPageReference.state?.categoryApiName
			: this.searchKeyWord = currentPageReference.state?.searchKeyWord;
		}
	}

	// 初期処理
	connectedCallback() {
		loadStyle(this, RakutenIpFAQResources + '/css/style.css');
		this.recordCount = 0;
		this.knowledges = [];
		this.displayKnowledges = [];
		this.isHideButtonReadMore = true;
		this.saveState = {};
		this.onLoadStorageEvent();
		this.loadKnowledges();
	}

	// ナレッジリスト読み込み
	loadKnowledges() {
		this.loading = true;
		// パラメータセット
		let searchParameters = {
			procName: this.callProcess,
			categoryGroupName: this.companyName,
			limitSize: this.searchLimit,
		};

		if (this.callProcess === '注目のご質問' || this.callProcess === 'よく読まれているご質問') {
			searchParameters.option = '';
		} else if (this.callProcess === 'サブカテゴリ' || this.callProcess === '検索結果') {
			let searchKey = this.callProcess === 'サブカテゴリ' ? this.searchCategory : this.searchKeyWord;
			searchParameters.option = searchKey;
		}

		getKnowledge(searchParameters)
			.then(result => {
				this.knowledges = [...result];
				this.recordCount = this.knowledges.length;
				// リストが存在する場合はsaveStateを表示、存在しない場合はinitialDisplayCountを表示
				this.spliceDisplayKnowledges(
					this.saveState.lengthDisplayKnowledges
						? this.saveState.lengthDisplayKnowledges
						: this.initialDisplayCount
				);
				this.loading = false;
			})
			.catch(error => {
				// this.error = JSON.stringify(error);
				this.recordCount = ''
				this.loading = false;
				this.navigateToHome();
			});
	}

	// saveStateのurlキーを取得
	getUrl(){
		let url = window.location.href;
		let index = url.indexOf('?');
		if(index > -1){
			url = url.substring(0, index);
		}
		return url;
	}

	// 詳細ページから戻った時に、saveStateをlocalStorageに読み込む
	onLoadStorageEvent() {
		let url = this.getUrl();
		let dataSave = localStorage.getItem(this.callProcess + this.companyName + url);
		localStorage.removeItem(this.callProcess + this.companyName + url);
		if (dataSave) {
			// get time
			this.saveState = JSON.parse(dataSave);
			let dateTime = Date.parse(this.saveState.timeBack);
			let seconds = (new Date().getTime() - dateTime) / 1000;
			// access when < 30 minutes
			if (seconds > 1800) {
				this.saveState = {}
			}
		}
	}

	// フォームのknowledgesをdisplayKnowledgesに置き換える
	spliceDisplayKnowledges(countDisplay) {
		this.displayKnowledges = [...this.displayKnowledges, ...this.knowledges.splice(0, countDisplay)];
		this.isHideButtonReadMore = this.knowledges.length === 0;
	}

	// さらに読み込む
	addMoreKnowledges(event) {
		this.spliceDisplayKnowledges(this.initialDisplayCount);
	}

	// 画面遷移
	navigateToDetailPage(event) {
		let id = event.currentTarget.dataset.id;
		// 詳細画面への遷移時に状態を保存
		this.saveState.lengthDisplayKnowledges = this.displayKnowledges.length
		this.saveState.timeBack = new Date();
		let url = this.getUrl();
		localStorage.setItem(this.callProcess + this.companyName + url, JSON.stringify(this.saveState));
		// 詳細画面へ遷移
		this[NavigationMixin.Navigate]({
			type: 'standard__webPage',
			attributes: {
				url: `/article/${id}`
			}
		});
	}

	navigateToHome() {
		// 詳細画面へ遷移
		this[NavigationMixin.Navigate]({
			type: 'standard__webPage',
			attributes: {
				url: `/`
			}
		});
	}

	// DisplaySearchLabel表示制御
	get isDisplaySearchLabel() {
		return this.isDisplaySearchResult && this.isDisplayCountResult && this.recordCount !== ''
			? true
			: false;
	}

	// DisplayCategoryLabel表示制御
	get isDisplayCategoryLabel() {
		return !this.isDisplaySearchResult && this.isDisplayCountResult && this.recordCount !== ''
			? true 
			: false;
	}

	// さらに表示ボタン表示制御
	get isDisplayButton() {
		return this.isDisplayReadmore && !this.isHideButtonReadMore
	}

	// 検索結果なし表示制御
	get isNoResults() {
		return this.isDisplaySearchResult && this.isDisplayCountResult && this.recordCount == '0'
			? true
			: false;
	}
}