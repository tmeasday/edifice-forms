class User < Edifice::Forms::FormModel
  attr_accessor :name, :location, :description
    
  validates :name, :length => {:minimum => 3}, :presence => true
  
  after_save :log_save
  
  def log_save
    User.model_saved
  end
  
  # this is just here so we can easily test for it.
  def self.model_saved
  end
end