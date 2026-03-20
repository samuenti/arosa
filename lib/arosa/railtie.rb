# frozen_string_literal: true

module Arosa
  class Railtie < Rails::Railtie
    initializer "arosa.view_helpers" do
      ActiveSupport.on_load(:action_view) do
        include Arosa::ViewHelpers
      end

      ActiveSupport.on_load(:action_controller) do
        include Arosa::ViewHelpers
      end
    end
  end
end
