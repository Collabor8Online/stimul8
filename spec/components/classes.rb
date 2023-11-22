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

class ConditionalRenderComponent
  include Stimul8::Component
  render_if { context == "Alice" }

  template do
    p "Hello"
  end
end

class NameBadgeComponent
  include Stimul8::Component
  property :name

  template do
    div class: "badge" do
      p "Hello #{name}"
    end
  end
end

class SidebarComponent
  include Stimul8::Component
  tag :aside

  template do
    ul.menu do
      li "Item 1"
      li "Item 2"
    end
  end

  style "ul.menu", "background-color: #fff;"
  style "ul.menu", "font-size: 18px;"
  style "ul.menu li", "font-size: 14px;"
end

class ContentComponent
  include Stimul8::Component
  template do
    contents
  end
end

class EmbeddedComponent
  include Stimul8::Component
  property :name
  template do
    component "name_badge", name: name
  end
end

class PersonFormComponent
  include Stimul8::Component
  property :first_name
  property :last_name

  template do
    form do
      # Form stuff goes here
    end
  end

  def update_person first_name:, last_name:
    self.first_name = first_name
    self.last_name = last_name
  end
end
