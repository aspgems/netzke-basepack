When /^I expand combobox "([^"]*)"$/ do |combo_label|
  page.driver.browser.execute_script <<-JS
    var combo = Ext.ComponentQuery.query("combobox[fieldLabel='#{combo_label}']")[0];
    combo = combo || Ext.ComponentQuery.query("combobox[name='#{combo_label}']")[0];
    combo.onTriggerClick();
  JS

  When "I wait for the response from the server"
end

def loading? (combo_label)
  page.driver.browser.execute_script <<-JS
    var combo =  Ext.ComponentQuery.query("combobox[fieldLabel='#{combo_label}']")[0];
    return combo.store.loading;
  JS
end

When /^I select "([^"]*)" from combobox "([^"]*)"$/ do |value, combo_label|
  page.driver.browser.execute_script <<-JS
    var combo = Ext.ComponentQuery.query("combobox[fieldLabel='#{combo_label}']")[0];
    combo = combo || Ext.ComponentQuery.query("combobox[name='#{combo_label}']")[0];
    combo.onTriggerClick();
  JS

  # HACK: this code looks ugly
  while loading?(combo_label) do
    sleep(1)
  end

  page.driver.browser.execute_script <<-JS
    var combo = Ext.ComponentQuery.query("combobox[fieldLabel='#{combo_label}']")[0];
    combo = combo || Ext.ComponentQuery.query("combobox[name='#{combo_label}']")[0];
    var rec = combo.findRecordByDisplay('#{value}');
    combo.select( rec.data.field1 );
  JS
end

Then /the form should show #{capture_fields}$/ do |fields|
  fields = ActiveSupport::JSON.decode("{#{fields}}")
  page.driver.browser.execute_script(<<-JS).should == true
    var components = [];
    for (var cmp in Netzke.page) { components.push(cmp); }
    var form = Netzke.page[components[0]].getForm();
    var result = true;
    var values = #{fields.to_json};
    for (var fieldName in values) {
      result = form.findField(fieldName).getValue() === values[fieldName] || form.findField(fieldName).getRawValue() === values[fieldName];
      return result;
    }
    return result;
  JS
end

When /^(?:|I )check ext checkbox "([^"]*)"$/ do |field|
  page.driver.browser.execute_script <<-JS
    var checkbox = Ext.ComponentQuery.query("checkboxfield[fieldLabel='#{field}']")[0];
    checkbox.setValue(true);
  JS
end
