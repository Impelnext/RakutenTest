window._snapinsSnippetSettingsFile = (function () {
    //Todo Add Script
    // const siteIncResources = 'https://insub--nxtccdev1--c.sandbox.vf.force.com/resource/1667808098000/SiteInc'
    let links = [
        '/sfsites/c/resource/SiteInc/template/js/jquery-3.4.1.min.js',
        '/sfsites/c/resource/SiteInc/template/js/lib.js',
        '/sfsites/c/resource/SiteInc/template/js/common.js',
        '/sfsites/c/resource/SiteInc/appjs/agencyControl.js',
        '/sfsites/c/resource/SiteInc/common/js/rc-h-standard.js',

        '/sfsites/c/resource/SiteInc/appjs/agencyControl.js',
        '/sfsites/c/resource/SiteInc/shared/js/lib/jquery.js',
        '/sfsites/c/resource/SiteInc/shared/js/jquery.cookie.js',
        '/sfsites/c/resource/SiteInc/shared/js/lib.js',
        '/sfsites/c/resource/SiteInc/shared/js/common_r.js',

        '/sfsites/c/resource/SiteInc/shared/js/fintechui.js'
    ]
    links.forEach(item => {
        console.log("Link js: ", item)
        let element = document.createElement('script');
        element.src = item;
        document.body.appendChild(element);
        console.log("Link js done: ", item)
    })
})();