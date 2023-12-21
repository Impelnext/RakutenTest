import { LightningElement , wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';

export default class FaqSubCategoryHeader extends LightningElement {

    categoryName;

	// URLからパラメータを取得
	@wire(CurrentPageReference)
	getStateParameters(currentPageReference) {
		if (currentPageReference) {
			this.categoryName = currentPageReference.state?.categoryName;
		}
	}
}