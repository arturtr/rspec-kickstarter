# frozen_string_literal: true

require 'erb'
require 'rspec_kickstarter'

#
# ERB templates
#
module RSpecKickstarter
  module ERBTemplates

    BASIC_METHODS_PART_TEMPLATE = <<SPEC
<%- methods_to_generate.map { |method| %>
  # TODO: auto-generated
  describe '#<%= method.name %>' do
    it '<%= method.name %>' do
<%- if get_instantiation_code(c, method)      -%><%= get_instantiation_code(c, method) %><%- end -%>
<%- if get_params_initialization_code(method) -%><%= get_params_initialization_code(method) %><%- end -%>
      result = <%= get_method_invocation_code(c, method).sub(c.to_s,'described_class') %>  

      expect(result).not_to be_nil
    end
  end
<% } %>
SPEC

    BASIC_NEW_SPEC_TEMPLATE = <<SPEC
# frozen_string_literal: true

require 'spec_helper'
<% unless rails_mode then %>require '<%= self_path %>'
<% end -%>

RSpec.describe <%= to_string_namespaced_path(self_path) %><%= get_complete_class_name(c) %> do
<%= ERB.new(BASIC_METHODS_PART_TEMPLATE, nil, '-').result(binding) -%>
end
SPEC

    RAILS_CONTROLLER_METHODS_PART_TEMPLATE = <<SPEC
<%- methods_to_generate.map { |method| %>
  # TODO: auto-generated
  describe '<%= get_rails_http_method(method.name).upcase %> <%= method.name %>' do
    it '<%= method.name %>s' do
      <%= get_rails_http_method(method.name) %> :<%= method.name %>, {}, {}     

      expect(response.status).to have_http_status(:ok)
    end
  end
<% } %>
SPEC

    RAILS_CONTROLLER_NEW_SPEC_TEMPLATE = <<SPEC
# frozen_string_literal: true

require 'rails_helper'  

RSpec.describe <%= to_string_namespaced_path(self_path) %><%= get_complete_class_name(c) %>, type: :controller do
<%= ERB.new(RAILS_CONTROLLER_METHODS_PART_TEMPLATE, nil, '-').result(binding) -%>
end
SPEC

    RAILS_HELPER_METHODS_PART_TEMPLATE = <<SPEC
<%- methods_to_generate.map { |method| %>
  # TODO: auto-generated
  describe '#<%= method.name %>' do
    it 'works' do
      result = <%= get_rails_helper_method_invocation_code(method) %>  

      expect(result).not_to be_nil
    end
  end
<% } %>
SPEC

    RAILS_HELPER_NEW_SPEC_TEMPLATE = <<SPEC
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe <%= to_string_namespaced_path(self_path) %><%= get_complete_class_name(c) %>, type: :helper do
<%= ERB.new(RAILS_HELPER_METHODS_PART_TEMPLATE, nil, '-').result(binding) -%>
end
SPEC

  end
end
