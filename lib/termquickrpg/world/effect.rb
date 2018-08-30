module TermQuickRPG
  class Effect
    attr_reader :template

    def self.none
      Effect.new("Used %s to no effect.")
    end

    def initialize(template)
      @template = template.is_a?(Effect) ? template.template : template
    end

    def message(item, object)
      format(template, item.name || item.to_s, object.name || object.to_s)
    end
  end
end
