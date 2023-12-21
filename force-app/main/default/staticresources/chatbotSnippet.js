
/**
 * オペレーター不在時を特定するためのボット発話文の定義.
 */ 
const OPERATOR_ABSENCE = "対応可能なオペレーターがおりません。";

var addEndOfChat = function() {
    // 有人チャット開始時にはボットメニューが要素として存在しないので、全体的に遅延実行させる
    setTimeout( function() {
        // ボットメニューボタンをクリックしてボットメニューを生成する
        document.querySelector("html").querySelector("button.slds-button_icon-container-more").click();
    }, 1000 );
    setTimeout( function() {
        // ボットメニューボタンを再度クリックしてボットメニューを非表示にする
        document.querySelector("html").querySelector("button.slds-button_icon-container-more").click();
    }, 1050 );
    setTimeout( function() {
        // チャットを終了するリンクが存在するかチェック
        var isExists = false;
        var spans = document.querySelector("html").querySelectorAll("span.slds-truncate");
        spans.forEach(e => {
            if (e.outerText == "チャットを終了する") {
                isExists = true;
            }
        });
        if (isExists) {
            // チャットを終了するリンクが既に存在する場合は何もしない
            return;
        }
        // ボットメニューに「チャットを終了する」を追加する
        document.querySelector("html").querySelector("div.footer-menu-items").insertAdjacentHTML('beforeend',
            `<lightning-menu-item class="slds-dropdown__item" role="presentation" interop-menuitem_menuitem-host="">
            <a interop-menuitem_menuitem="" href="javascript:embedded_svc.liveAgentAPI.endChat();" role="menuitem" tabindex="-1" aria-disabled="false">
            <span interop-menuitem_menuitem="" class="slds-truncate">チャットを終了する</span></a></lightning-menu-item>`
            );
    }, 2000);
};

window._snapinsSnippetSettingsFile = (function() {
    console.log("Snippet settings file loaded.");	// Logs that the snippet settings file was loaded successfully
    embedded_svc.snippetSettingsFile.language = 'ja';
    embedded_svc.snippetSettingsFile.avatarImgURL = 'https://next-cc-integrated-crm-chat-assets.s3.ap-northeast-1.amazonaws.com/chat/assets/personIcon.png';
    embedded_svc.snippetSettingsFile.chatbotAvatarImgURL = 'https://next-cc-integrated-crm-chat-assets.s3.ap-northeast-1.amazonaws.com/chat/assets/chatbotIcon.png';

    embedded_svc.addEventHandler("onAgentMessage", function(data) {
        console.log("onAgentMessage");
        console.log(data);
        
        setTimeout( function() {
            let chatMessageAgents = document.getElementsByClassName("chatMessage agent");
            let lastCma = chatMessageAgents[chatMessageAgents.length - 1];
            let chatContent = lastCma.getElementsByClassName("chatContent");
            let cc = chatContent[chatContent.length - 1];
            if (cc != null) {
                console.log(cc.textContent);
                if (cc.textContent == null || cc.textContent == "") {
                    lastCma = chatMessageAgents[chatMessageAgents.length - 2];
                    chatContent = lastCma.getElementsByClassName("chatContent");
                    cc = chatContent[chatContent.length - 1];
                    console.log(cc.textContent);
                }
                if (cc.textContent.includes(OPERATOR_ABSENCE)) {
                        addEndOfChat();
                }
            }
        }, 100 );

        setTimeout( function() {
            var icon = document.querySelector(".avatar.iconAvatar.agentInitial.agentIconColor2");
            if (icon != null) {
                var parentElm = icon.parentElement;
                icon.remove();
                parentElm.insertAdjacentHTML('beforeend',
                    `<div style="background-image: url(https://next-cc-integrated-crm-chat-assets.s3.ap-northeast-1.amazonaws.com/chat/assets/personIcon.png);"
                    class="avatar" data-aura-rendered-by="1117:0">
                    <span class="assistiveText" data-aura-rendered-by="1118:0"></span></div>`
                    );
            }
        }, 50 );
    });

    embedded_svc.addEventHandler("onAgentRichMessage", function(data) {
        console.log("onAgentRichMessage");
        console.log(data);
    });

    embedded_svc.addEventHandler("onChasitorMessage", function(data) {
        console.log("onChasitorMessage");
        console.log(data);
    });

    embedded_svc.addEventHandler("afterDestroy", function(data) {
        console.log("destroyed");
        embedded_svc.settings.displayHelpButton = false;
        document.querySelector(".uiOutputRichText > p ").textContent= "ブラウザのタブを閉じてください";
    });

    // add Visitor info
    embedded_svc.snippetSettingsFile.extraPrechatFormDetails = [{
        "label":"First Name",
        "name":"FirstName",
        "value":"(自分)",
        "displayToAgent": false
    }]; 

    // custom CSS
    if (navigator.userAgent.match(/(iPhone|iPad|iPod|Android)/i)) {
    } else {
        document.querySelector(`head`).insertAdjacentHTML('beforeend',
         `<style type="text/css">div.btc-button {
          display: none;
          }</style>`
        );
    }

    embedded_svc.addEventHandler("onChatTransferSuccessful", function(data) {
        console.log("onChatTransferSuccessful");
        console.log(data);
        addEndOfChat();
    });

})();