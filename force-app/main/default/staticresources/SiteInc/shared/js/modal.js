/**
 * modal.js
 *
 * version --- 1.0
 * updated --- 2021/XX/XX
 */

!function() {
this.RLImodal = (function() {

    'use strict';

    var templates = {
        backdrop:
            '<div class="modal-backdrop"></div>',
        header:
            '<div class="modal-header"><div class="modal-title"></div></div>',
        footer:
            '<div class="modal-footer"></div>',
        close_button:
            '<div class="close-button"><a href="javascript:void(0)" class="modal-close-button button"><span></span>閉じる</a></div>',
        dialog:
            '<div class="modal" tabindex="-1" role="dialog" aria-hidden="true">' +
                '<div class="modal-dialog">' +
                    '<div class="modal-content">' +
                        '<div class="modal-body"></div>' +
                    '</div>' +
                '</div>' +
            '</div>',
    };

    var defaults = {
        title: '',
        fade: true,
        full: true,
        className: null,
        closeButton: true,
        header: false,
        footer: false,
        /* buttons: { sample: {
                                  label: '' ,
                                  className: '',
                                  callback: function() { this.hide; }, 
                               }
                 }, */
    };

    var buttonLabels= {
        ok    : 'OK',
        cancel: 'キャンセル'
    }

    function excuteCallback(e, $modal, callback) {
        e.stopPropagation();
        e.preventDefault();

        var preserveDialog = $.isFunction(callback) && callback.call($modal, e) === false;

        if (!preserveDialog) {
            RLImodal.hide();
        }
    }

    var exports = {
        alert : function(message, options) {
            var alert = { className: 'alert',
                          full: false,
                          buttons: {
                                        cancel: { label: buttonLabels.cancel, className: 'btn-cancel', callback: function() { this.hide; } },
                                   },
                        };

            options = $.extend({}, defaults, options, alert);

            options.buttons.cancel.callback = options.onClose = function() { options.callback.call(this, false); }

            this.show(message, options);
        },
        confirm : function(message, options) {
            var confirm = { className: 'confirm',
                            full: false,
                            buttons: {
                                        cancel: { label: buttonLabels.cancel, className:'btn-cancel', callback: function() { this.hide; } },
                                        ok:     { label: buttonLabels.ok,     className:'btn-ok',     callback: function() { this.hide; } }
                                      },
                           };

            options = $.extend({}, defaults, options, confirm);

            options.buttons.cancel.callback = options.onClose = function() { options.callback.call(this, false); }
            options.buttons.ok.callback = function() { options.callback.call(this, true); }

            this.show(message, options);
        },
        show : function(html, options) {
            var $body = $(document.body);
            var $modal = $(templates.dialog)
            var $modal_body = $modal.find('.modal-body');
            var $backdrop = $(templates.backdrop)

            this.options = $.extend({}, defaults, options);

            if (this.options.className) {
                $modal.addClass(options.className);
            }

            if(this.options.fade) {
                $modal.addClass('fade');
                $backdrop.addClass('fade');
            }

            if(this.options.full) {
                $modal.addClass('full');
                $backdrop.addClass('full');
            }

            if(this.options.header || this.options.title || this.options.closeButton) {
                $modal_body.before(templates.header);
            }

            if(this.options.title) {
                $modal.find('.modal-title').html(options.title);
            }

            if(this.options.closeButton) {
                $modal.find('.modal-title').before(templates.close_button);
            }

            $modal_body.html(html);

            if(this.options.footer || this.options.buttons) {
                $modal_body.after(templates.footer);
            }

            if(this.options.buttons) {
                var buttons = '<div class="modal-buttons">';
                var callbacks = {};
                
                $.each( this.options.buttons, function(key, button) {
                    buttons += '<a href="javascript:void(0)" data-trigger="'+ key + '" name=button-' + key + ' class="button ' + button.className + '">' + button.label + '</a>';
                    callbacks[key] = button.callback;
                });
                buttons += '</div>'
                $modal.find('.modal-footer').html(buttons);
                
                this.callbacks = callbacks;
                $modal.find('.modal-footer .button').on('click', function(e) {
                    var callbackKey = $(this).data('trigger');
                    excuteCallback(e, $modal, callbacks[callbackKey]);
                });
            }
            $modal.find('.modal-content').addClass('scroll');

            $body.append($modal);
            $body.append($backdrop);

            this.$modal = $modal;
            this.$backdrop = $backdrop;

            $modal.on('click', '.modal-content', function(e) { e.stopPropagation(); });
            $modal.on('click', '.modal-content .modal-close-button', function(e) { excuteCallback(e, $modal, options.onClose); });
            if(this.options.closeButton) {
                $modal.on('click', function(e) { excuteCallback(e, $modal, options.onClose); });
            }

            if(this.options.fade) {
                $backdrop.addClass('in');
                $modal.addClass('in');
            }

            $body.addClass('modal-open');
        },
        hide: function(){
            var _this = this;

            var close_modal = function() {
                _this.$modal.remove();
                _this.$backdrop.remove();
                $(document.body).removeClass('modal-open');
            }

            if(this.options.fade) {
                this.$modal.addClass('out');
                this.$backdrop.addClass('out');
                setTimeout(close_modal, 300);
            } else {
                close_modal();
            }
        },
        setDefaultOptions: function(options) {
            $.extend(defaults, options);
        },
        setButtonLabels: function(labels) {
            $.extend(buttonLabels, labels);
        }
    };

    return exports;
}());
}();