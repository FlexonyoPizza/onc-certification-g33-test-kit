require 'davinci_pas_test_kit/client/v2.2.1/urls'
require_relative 'g33_options'

module ONCCertificationG33TestKit
  module G33ClientURLs
    SUITE_ID = 'g33_certification'.freeze

    def base_url
      @base_url ||= G33PASImport.base_url
    end
  end

  module G33PASImport
    STALE_CACHE_IVARS = [:@test_count, :@available_inputs, :@children_available_inputs].freeze

    def self.import!(runnable)
      select_client_type!(runnable)
      exclude_optional!(runnable)
      rewrite_pas_urls!(runnable)

      runnable
    end

    # (g)(33) certifies against SMART Backend Services only, so this suite offers no :client_type
    # suite option. Without a selected option Inferno keeps every variant of a runnable, so the
    # ones gated on another client type are dropped and the requirement is cleared from the rest.
    def self.select_client_type!(runnable)
      rejected = runnable.all_children.reject { |child| client_type_match?(child) }
      rejected.each(&:remove_self_from_repository)
      runnable.all_children.reject! { |child| rejected.include?(child) }
      clear_stale_caches!(runnable)

      runnable.all_children.each do |child|
        child.required_suite_options(client_type_free_requirements(child))
        select_client_type!(child)
      end
    end

    # Keeps runnables that either impose no :client_type requirement or ask for this suite's type.
    def self.client_type_match?(runnable)
      requirement = runnable.suite_option_requirements&.find { |option| option.id == :client_type }

      requirement.nil? || requirement.value == G33Options::CLIENT_TYPE
    end
    private_class_method :client_type_match?

    def self.client_type_free_requirements(runnable)
      (runnable.suite_option_requirements || [])
        .reject { |option| option.id == :client_type }
        .to_h { |option| [option.id, option.value] }
    end
    private_class_method :client_type_free_requirements

    def self.exclude_optional!(runnable)
      runnable.all_children.reject(&:required?).each(&:remove_self_from_repository)
      runnable.all_children.select!(&:required?)
      clear_stale_caches!(runnable)

      runnable.all_children.each { |child| exclude_optional!(child) }
    end

    def self.clear_stale_caches!(runnable)
      STALE_CACHE_IVARS.each do |ivar|
        runnable.remove_instance_variable(ivar) if runnable.instance_variable_defined?(ivar)
      end
    end
    private_class_method :clear_stale_caches!

    def self.rewrite_pas_urls!(runnable)
      runnable.include(G33ClientURLs) if runnable.include?(DaVinciPASTestKit::DaVinciPASV221::URLs)
      rewrite_runnable_text!(runnable)
      rewrite_input_descriptions!(runnable)

      runnable.all_children.each { |child| rewrite_pas_urls!(child) }
    end

    def self.rewrite_runnable_text!(runnable)
      [:description, :input_instructions].each do |field|
        text = runnable.send(field).to_s
        next unless text.include?(pas_base_url)

        runnable.send(field, text.gsub(pas_base_url, base_url))
      end
    end
    private_class_method :rewrite_runnable_text!

    def self.rewrite_input_descriptions!(runnable)
      updates = runnable.config.inputs.each_with_object({}) do |(identifier, input), acc|
        description = input.description.to_s
        next unless description.include?(pas_base_url)

        acc[identifier] = { description: description.gsub(pas_base_url, base_url) }
      end

      runnable.config(inputs: updates) if updates.any?
    end
    private_class_method :rewrite_input_descriptions!

    # Includes the PAS version prefix, so imported tests point at this suite's v2.2.1 endpoints
    def self.base_url
      "#{Inferno::Application['base_url']}/custom/#{G33ClientURLs::SUITE_ID}#{G33Options::PAS_V221_PREFIX}"
    end

    def self.pas_base_url
      "#{Inferno::Application['base_url']}/custom/#{DaVinciPASTestKit::DaVinciPASV221::ClientSuite.id}"
    end
  end
end
