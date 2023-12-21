import { getDataConnectorSourceFields } from "lightning/analyticsWaveApi";
import { LightningElement, api} from "lwc";

export default class FaqChatbot extends LightningElement {
  @api isDisplayBackToSupportTOP;
  @api isDisplayBackToPreviousPage;
  @api siteName;
  @api isHideTitle;

  faqUrl;
  urlChatbot;

  connectedCallback() {
    switch (this.siteName) {
      case "FAQLife":
        this.faqUrl = "/faqlife/s/";
        this.urlChatbot = this.pageName('FAQLife');
        break;
      case "FAQLifeEnq":
        this.faqUrl = "/faqlife/s/";
        this.urlChatbot = this.pageName('FAQLifeEnq');
        break;
      case "FAQSonpo":
        this.faqUrl = "/faqsonpo/s/";
        this.urlChatbot = this.pageName('FAQSonpo');
        break;
      case "FAQSonpoEnq":
        this.faqUrl = "/faqsonpo/s/";
        this.urlChatbot = this.pageName('FAQSonpoEnq');
        break;
      case "FAQPet":
        this.faqUrl = "/faqpet/s/";
        this.urlChatbot = this.pageName('FAQPet');
        break;
      case "FAQPetEnq":
        this.faqUrl = "/faqpet/s/";
        this.urlChatbot = this.pageName('FAQPetEnq');
        break;
      default:
        break;
    }
  }

  pageName(site) {
    let page = {
      topFAQLife: 'https://www.rakuten-insurance.co.jp/contract/chat/privacy.html?scid=wi_lfe_life_faq_top_contract_chat_privacy',
      articleFAQLife: 'https://www.rakuten-insurance.co.jp/contract/chat/privacy.html?scid=wi_lfe_life_faq_detail_contract_chat_privacy',
      searchFAQLife: 'https://www.rakuten-insurance.co.jp/contract/chat/privacy.html?scid=wi_lfe_life_faq_search_result_contract_chat_privacy',
      topicFAQLife: 'https://www.rakuten-insurance.co.jp/contract/chat/privacy.html?scid=wi_lfe_life_faq_category_sub_contract_chat_privacy',
      articleFAQLifeEnq: 'https://www.rakuten-insurance.co.jp/contract/chat/privacy.html?scid=wi_lfe_life_faq_detail_enq_contract_chat_privacy',
      topFAQSonpo: 'https://www.rakuten-insurance.co.jp/contract/sonpo/chat/privacy.html?scid=wi_snp_gen_faq_top_contract_sonpo_chat_privacy',
      articleFAQSonpo: 'https://www.rakuten-insurance.co.jp/contract/sonpo/chat/privacy.html?scid=wi_snp_gen_faq_detail_contract_sonpo_chat_privacy',
      searchFAQSonpo: 'https://www.rakuten-insurance.co.jp/contract/sonpo/chat/privacy.html?scid=wi_snp_gen_faq_search_result_contract_sonpo_chat_privacy',
      topicFAQSonpo: 'https://www.rakuten-insurance.co.jp/contract/sonpo/chat/privacy.html?scid=wi_snp_gen_faq_category_sub_contract_sonpo_chat_privacy',
      articleFAQSonpoEnq: 'https://www.rakuten-insurance.co.jp/contract/sonpo/chat/privacy.html?scid=wi_snp_gen_faq_detail_enq_contract_sonpo_chat_privacy',
      topFAQPet: 'https://www.rakuten-insurance.co.jp/contract/pet/chat/privacy.html?scid=wi_pti_pet_faq_top_contract_pet_chat_privacy',
      articleFAQPet: 'https://www.rakuten-insurance.co.jp/contract/pet/chat/privacy.html?scid=wi_pti_pet_faq_detail_contract_pet_chat_privacy',
      searchFAQPet: 'https://www.rakuten-insurance.co.jp/contract/pet/chat/privacy.html?scid=wi_pti_pet_faq_search_result_contract_pet_chat_privacy',
      topicFAQPet: 'https://www.rakuten-insurance.co.jp/contract/pet/chat/privacy.html?scid=wi_pti_pet_faq_category_sub_contract_pet_chat_privacy',
      articleFAQPetEnq: 'https://www.rakuten-insurance.co.jp/contract/pet/chat/privacy.html?scid=wi_pti_pet_faq_detail_enq_contract_pet_chat_privacy',
    }
    let pageName = location.href.split('/')[5];
    if (!pageName) pageName = 'top';
    if (pageName.indexOf('?') !== -1) {
      pageName = pageName.substring(0, pageName.indexOf('?'));
      if (pageName === 'global-search') {
        pageName = 'search';
      }else if(pageName === 'topic'){
       pageName = 'topic';
      }else{
        pageName = 'top';
      }
    }
    return page[pageName + site];
  }
  
  handlePageBackClick(){
    window.history.back();
    return false;
  }
}