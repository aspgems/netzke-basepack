Ext.ns("Ext.netzke.form");

/*
 * Custom error reader. We don't use it to process form values, but rather to normalize the response from the server
 * in case of "real" (iframe) form submit.
 */
Ext.define('Ext.netzke.form.ErrorReader', {
  extend:'Ext.data.reader.Reader',
  alias:'reader.netzke',

  getResponseData: function (xhr) {
    var unescapeHTML = function (str) {
      return str.replace(/&lt;/gi, '<').replace(/&gt;/gi, '>').replace(/&amp;/gi, '&');
    };
    xhr.responseText = unescapeHTML(xhr.responseText.replace(/<pre.*?>/i, "").replace(/<\/pre>/i, ""));

    var json;
    try {
      json = Ext.decode(xhr.responseText) || {};
    }
    catch (e) {
      json = {};
    }

    return {records:[], success:json.applyFormErrors == undefined};
  }
});

