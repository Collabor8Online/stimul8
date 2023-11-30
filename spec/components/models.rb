Person = Struct.new(:id, :name) do # standard:disable Lint/ConstantDefinitionInBlock
  class << self
    def find id
      models[id] || raise(ActiveRecord::RecordNotFound)
    end

    def models
      @models ||= {}
    end
  end

  def initialize *args
    super(*args)
    self.class.models[id] = self
  end
end
