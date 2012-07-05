#class TypeStatus
  #include Mongoid::Document

  #field :uri
  #field :order, type: Integer, default: 0
  #attr_accessible :uri, :order

  #embedded_in :type

  #validates :uri, presence: true, url: true
  #validates :order, presence: true
#end
