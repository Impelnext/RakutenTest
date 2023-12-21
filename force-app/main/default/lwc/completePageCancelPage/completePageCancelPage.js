import { LightningElement, api } from 'lwc';

export default class CompletePageCancelPage extends LightningElement {
    @api isDisplayCompletePage;

    connectedCallback(){
        // 自身のページを履歴に追加
        history.pushState(null, null, null);
        // ページ戻り時にも自身のページを履歴に追加
        window.addEventListener = ("popstate", function(){
        history.pushState(null, null, null);
        });
    }
}