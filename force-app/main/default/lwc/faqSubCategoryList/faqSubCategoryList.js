import { LightningElement, wire } from "lwc";
import RakutenIpFAQResources from "@salesforce/resourceUrl/RakutenIpFAQResources";
import { NavigationMixin, CurrentPageReference } from "lightning/navigation";
import { loadStyle } from "lightning/platformResourceLoader";
import getSubCategoryInfo from "@salesforce/apex/DataCategoryHelper.getSubCategoryInfo";

export default class FaqSubCategoryList extends NavigationMixin(
  LightningElement
) {
  searchCategory;
  categoryLabel;
  companyGroupName;
  subCategories;

  // URLからパラメータを取得
  @wire(CurrentPageReference)
  getStateParameters(currentPageReference) {
    if (currentPageReference?.state?.categoryApiName) {
      this.searchCategory = currentPageReference.state.categoryApiName;
    }
    if (currentPageReference?.state?.categoryLevel1) {
      this.categoryLabel = currentPageReference.state.categoryLevel1;
    }
    if (currentPageReference?.state?.companyGroupName) {
      this.companyGroupName = currentPageReference.state.companyGroupName;
    }
  }

  // 初期処理
  connectedCallback() {
    loadStyle(this, RakutenIpFAQResources + "/css/style.css");
    this.loadDataSubCategory();
  }

  //Category name to category label
  companyName(companyGroupName) {
    let companyGroups = {
      CategoryGroupPet: "楽天ペット保険",
      CategoryGroupInsurance: "楽天損保",
      CategoryGroupLife: "楽天生命"
    };
    return companyGroups[companyGroupName];
  }

  //Load data
  loadDataSubCategory() {
    getSubCategoryInfo({
      companyName: this.companyName(this.companyGroupName),
      categoryLabel: this.categoryLabel
    })
      .then((result) => {
        this.subCategories = JSON.parse(result);
      })
      .catch((error) => {
        console.log(
          "Error while getting Sub CategoryData => " + JSON.stringify(error)
        );
        this.navigateToHome();
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

  // 画面遷移
  navigateToTopicPage(event) {
    let categoryApiName = event.currentTarget.dataset.category;
    let categoryName = event.currentTarget.dataset.name;

    // サブカテゴリ画面へ遷移
    this[NavigationMixin.Navigate]({
      type: "standard__webPage",
      attributes: {
        url: `/topic?categoryApiName=${categoryApiName}&categoryName=${categoryName}&companyGroupName=${this.companyGroupName}&categoryLevel1=${this.categoryLabel}`
      }
    });
  }
}