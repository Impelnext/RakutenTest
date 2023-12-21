import { LightningElement, api, track } from 'lwc';
import getDataCategory from '@salesforce/apex/DataCategoryHelper.getDataCategory';
import { NavigationMixin } from 'lightning/navigation';
import RakutenIpFAQResources from '@salesforce/resourceUrl/RakutenIpFAQResources';
import { loadStyle } from 'lightning/platformResourceLoader';

export default class FaqCategoryList extends NavigationMixin(LightningElement) {
    @api categoryGroupName;
    @track categories = [];

    // 初期処理
    connectedCallback() {
        loadStyle(this, RakutenIpFAQResources + '/css/style.css');
        this.loadDataCategory();
    }

    // カテゴリ一覧アコーディオンハンドリング
    expandCollapseSubcategory(event) {
        let indexItem = +event.currentTarget.dataset.index;
        this.categories.forEach((element, index) => {
            let category = this.template.querySelector(`ul[data-index="${index}"]`);
            let labelCheck = this.template.querySelector(`label[data-index="${index}"]`);
            if (indexItem === index) {
                this.expandOrCollapseCurrent(category, labelCheck);
            } else {
                this.collapseOther(category, labelCheck);
            }
        });
    }

    // カテゴリレベル3展開切り替え
    expandOrCollapseCurrent(category, labelCheck) {
        if (category.classList.value.indexOf('wrap') !== -1
            && category.classList.value.indexOf('flex') !== -1
            && category.classList.value.indexOf('show') !== -1) {
            this.collapseOther(category, labelCheck);
        } else {
            category.classList.add('wrap');
            category.classList.add('flex');
            category.classList.add('show');
            labelCheck.classList.remove('close');
            labelCheck.classList.add('open');
        }
    }

    // 常時折り畳み
    collapseOther(category, labelCheck) {
        category.classList.remove('wrap');
        category.classList.remove('flex');
        category.classList.remove('show');
        labelCheck.value = false;
        labelCheck.classList.remove('open');
        labelCheck.classList.add('close');
    }

    // カテゴリデータリスト読み込み
    loadDataCategory() {
        getDataCategory({ categoryGroupName: this.categoryGroupName })
            .then(result => {
                this.categories = JSON.parse(result);
            })
            .catch(error => {
                console.log('Error while getting CategoryData => ' + JSON.stringify(error));
            });
    }

    // 画面遷移
    navigateToTopicPage(event) {
        let categoryApiName = event.currentTarget.dataset.category;
        let categoryName = event.currentTarget.dataset.name;
        let categoryNameLevel1 = event.currentTarget.dataset.category1;

        // サブカテゴリ画面へ遷移
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: `/topic?categoryApiName=${categoryApiName}&categoryName=${categoryName}&companyGroupName=${this.categoryGroupName}&categoryLevel1=${categoryNameLevel1}`
            }
        });
    }
}