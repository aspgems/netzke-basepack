# Warning: this component participates in i18n.feature, careful with adding new fields!
class BookForm < Netzke::Basepack::FormPanel
  extend Extras::BookPresentation

  title Book.model_name.human

  model "Book"

  record_id Book.first.try(:id)

  items [
    :title,
    {:name => :author__first_name, :setter => author_first_name_setter},
    :author__name,
    {:name => :author__last_name, :xtype => :displayfield},
    {:name => :rating, :xtype => :combo, :store => [[1, "Good"], [2, "Average"], [3, "Poor"]]},
    {:name => :author__updated_at, :editable => false},
    :digitized,
    :exemplars,
    {:name => :in_abundance, :getter => in_abundance_getter, :xtype => :displayfield},
    {:name => :updated_at},
    :last_read_at,
    :published_on

    # WIP: commalistcbg is kind of broken, giving an Ext error
    # {:name => :tags, :xtype => :commalistcbg, :options => %w(read cool recommend buy)},
    # WIP: waithing on nradiogroup
    # {:name => :rating, :xtype => :nradiogroup, :options => [[1, "Good"], [2, "Average"], [3, "Poor"]]}
  ]

  js_method :init_component, <<-JS
    function(){
      this.callParent();
      this.on('submitsuccess', function(){ this.netzkeFeedback('Suc'+'cess!')}, this);
    }
  JS

end
