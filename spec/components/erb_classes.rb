module Erb
  class ConditionalRenderComponent
    include Stimul8::Component
    render_if { context == "Alice" }
  end

  class NameBadgeComponent
    include Stimul8::Component
    property :name
  end

  class SidebarComponent
    include Stimul8::Component
    tag :aside

    style "ul.menu", "background-color: #fff;"
    style "ul.menu", "font-size: 18px;"
    style "ul.menu li", "font-size: 14px;"
  end

  class ContentComponent
    include Stimul8::Component
  end

  class EmbeddedComponent
    include Stimul8::Component
    property :name
  end

  class PersonFormComponent
    include Stimul8::Component
    property :first_name
    property :last_name

    def update_person first_name:, last_name:
      self.first_name = first_name
      self.last_name = last_name
    end
  end
end
